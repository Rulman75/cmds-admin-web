import os
import csv
import io
import json
import subprocess
from dotenv import load_dotenv

load_dotenv(".env")

ORACLE_HOST = os.getenv("ORACLE_HOST")
ORACLE_PORT = os.getenv("ORACLE_PORT", "9521")
ORACLE_SERVICE = os.getenv("ORACLE_SERVICE")
ORACLE_USER = os.getenv("ORACLE_USER")
ORACLE_PASS = os.getenv("ORACLE_PASS")
SQLPLUS_BIN = r"C:\oracle32\client\sqlplus.exe"

TARGET_SCHEMAS = ('ADM_EDUCA', 'ADM_RHU', 'ADM_PORTALDIR', 'ADMETA', 'ADM_NOTAS')

def main():
    os.makedirs("data", exist_ok=True)
    schemas_in = ",".join(f"'{s}'" for s in TARGET_SCHEMAS)

    dsn = (
        f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={ORACLE_HOST})(PORT={ORACLE_PORT}))"
        f"(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={ORACLE_SERVICE})))"
    )
    conn_str = f'{ORACLE_USER}/"{ORACLE_PASS}"@{dsn}'

    queries = {
        "tables": f"SELECT t.OWNER, t.TABLE_NAME, t.NUM_ROWS, TO_CHAR(t.LAST_ANALYZED, 'YYYY-MM-DD') AS LAST_ANALYZED, tc.COMMENTS FROM ALL_TABLES t LEFT JOIN ALL_TAB_COMMENTS tc ON t.OWNER = tc.OWNER AND t.TABLE_NAME = tc.TABLE_NAME WHERE t.OWNER IN ({schemas_in}) ORDER BY t.OWNER, t.TABLE_NAME",
        "columns": f"SELECT c.OWNER, c.TABLE_NAME, c.COLUMN_ID, c.COLUMN_NAME, c.DATA_TYPE, c.DATA_LENGTH, c.DATA_PRECISION, c.DATA_SCALE, c.NULLABLE, cc.COMMENTS FROM ALL_TAB_COLUMNS c LEFT JOIN ALL_COL_COMMENTS cc ON c.OWNER = cc.OWNER AND c.TABLE_NAME = cc.TABLE_NAME AND c.COLUMN_NAME = cc.COLUMN_NAME WHERE c.OWNER IN ({schemas_in}) ORDER BY c.OWNER, c.TABLE_NAME, c.COLUMN_ID",
        "constraints": f"SELECT c.OWNER, c.TABLE_NAME, c.CONSTRAINT_NAME, c.CONSTRAINT_TYPE, c.R_OWNER, c.R_CONSTRAINT_NAME, LISTAGG(cc.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY cc.POSITION) AS COLS FROM ALL_CONSTRAINTS c JOIN ALL_CONS_COLUMNS cc ON c.OWNER = cc.OWNER AND c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME WHERE c.CONSTRAINT_TYPE IN ('P', 'R', 'U') AND c.OWNER IN ({schemas_in}) GROUP BY c.OWNER, c.TABLE_NAME, c.CONSTRAINT_NAME, c.CONSTRAINT_TYPE, c.R_OWNER, c.R_CONSTRAINT_NAME",
        "views": f"SELECT OWNER, VIEW_NAME, TEXT_VC FROM ALL_VIEWS WHERE OWNER IN ({schemas_in}) ORDER BY OWNER, VIEW_NAME"
    }

    sql_parts = [
        "SET PAGESIZE 50000",
        "SET FEEDBACK OFF",
        "SET VERIFY OFF",
        "SET HEADING ON",
        "SET ECHO OFF",
        "SET TRIMSPOOL ON",
        "SET MARKUP CSV ON DELIMITER , QUOTE ON"
    ]
    for name, q in queries.items():
        sql_parts.append(f"PROMPT ___SECTION:{name}___")
        sql_parts.append(f"{q};")
    sql_parts.append("EXIT;")

    env = os.environ.copy()
    env["NLS_LANG"] = "AMERICAN_AMERICA.AL32UTF8"
    print("Ejecutando extracción unificada en Oracle para ADM_EDUCA, ADM_RHU, ADM_PORTALDIR, ADMETA, ADM_NOTAS...")
    p = subprocess.run([SQLPLUS_BIN, "-S", conn_str], input=("\n".join(sql_parts) + "\n").encode("utf-8"), capture_output=True)
    out = p.stdout.decode("utf-8", errors="replace")

    raw_sections = {}
    for sec in out.split("___SECTION:")[1:]:
        header, _, body = sec.partition("___")
        name = header.strip()
        lines = [ln for ln in body.strip().splitlines() if ln.strip() and not ln.startswith(('"___', 'ORA-', 'SP2-'))]
        raw_sections[name] = list(csv.DictReader(io.StringIO("\n".join(lines)))) if lines else []
        print(f"  Sección {name}: {len(raw_sections[name])} filas")

    schemas_data = {s: {"tables": {}, "views": {}} for s in TARGET_SCHEMAS}

    for r in raw_sections.get("tables", []):
        owner = r["OWNER"]
        tname = r["TABLE_NAME"]
        nrows = int(r["NUM_ROWS"]) if r.get("NUM_ROWS") and r["NUM_ROWS"].isdigit() else 0
        schemas_data[owner]["tables"][tname] = {
            "table_name": tname,
            "num_rows": nrows,
            "last_analyzed": r.get("LAST_ANALYZED"),
            "comments": r.get("COMMENTS") or "",
            "columns": [],
            "constraints": []
        }

    view_cols = {}
    for r in raw_sections.get("columns", []):
        owner = r["OWNER"]
        tname = r["TABLE_NAME"]
        col_obj = {
            "id": int(r["COLUMN_ID"]) if r.get("COLUMN_ID") and r["COLUMN_ID"].isdigit() else 0,
            "name": r["COLUMN_NAME"],
            "type": r["DATA_TYPE"],
            "length": r.get("DATA_LENGTH"),
            "precision": r.get("DATA_PRECISION"),
            "scale": r.get("DATA_SCALE"),
            "nullable": r.get("NULLABLE") == "Y",
            "comments": r.get("COMMENTS") or ""
        }
        if tname in schemas_data.get(owner, {}).get("tables", {}):
            schemas_data[owner]["tables"][tname]["columns"].append(col_obj)
        else:
            view_cols.setdefault(f"{owner}.{tname}", []).append(col_obj)

    pk_map = {}
    for r in raw_sections.get("constraints", []):
        if r["CONSTRAINT_TYPE"] in ("P", "U"):
            pk_map[f"{r['OWNER']}.{r['CONSTRAINT_NAME']}"] = f"{r['OWNER']}.{r['TABLE_NAME']}({r['COLS']})"

    for r in raw_sections.get("constraints", []):
        owner = r["OWNER"]
        tname = r["TABLE_NAME"]
        ref = pk_map.get(f"{r['R_OWNER']}.{r['R_CONSTRAINT_NAME']}", f"{r['R_OWNER']}.{r['R_CONSTRAINT_NAME']}") if r["CONSTRAINT_TYPE"] == "R" else None
        if tname in schemas_data.get(owner, {}).get("tables", {}):
            schemas_data[owner]["tables"][tname]["constraints"].append({
                "name": r["CONSTRAINT_NAME"],
                "type": r["CONSTRAINT_TYPE"],
                "columns": r["COLS"],
                "references": ref
            })

    for r in raw_sections.get("views", []):
        owner = r["OWNER"]
        vname = r["VIEW_NAME"]
        schemas_data[owner]["views"][vname] = {
            "view_name": vname,
            "text_preview": r.get("TEXT_VC") or "",
            "columns": view_cols.get(f"{owner}.{vname}", [])
        }

    with open("data/oracle_other_schemas.json", "w", encoding="utf-8") as f:
        json.dump(schemas_data, f, ensure_ascii=False, indent=2)

    for s, d in schemas_data.items():
        print(f"Esquema {s}: {len(d['tables'])} tablas, {len(d['views'])} vistas guardadas.")

if __name__ == "__main__":
    main()
