import os
import csv
import io
import json
import subprocess
from dotenv import load_dotenv

load_dotenv()

ORACLE_HOST = os.getenv("ORACLE_HOST")
ORACLE_PORT = os.getenv("ORACLE_PORT", "9521")
ORACLE_SERVICE = os.getenv("ORACLE_SERVICE")
ORACLE_USER = os.getenv("ORACLE_USER")
ORACLE_PASS = os.getenv("ORACLE_PASS")

SQLPLUS_BIN = r"C:\oracle32\client\sqlplus.exe"

APP_SCHEMAS = (
    'ADM_OBS', 'ADM_CMDS', 'ADM_AUTH', 'PADLOG',
    'ADMETA', 'ADM_EDUCA', 'ADM_NOTAS', 'ADM_PORTALDIR',
    'ADM_PROC_BE', 'ADM_RHU', 'ADM_TOTEM'
)

CMDS_ADM_SCHEMAS = ('ADM_OBS', 'ADM_CMDS', 'ADM_AUTH', 'PADLOG')

def run_sql_csv(query):
    dsn = (
        f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={ORACLE_HOST})(PORT={ORACLE_PORT}))"
        f"(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={ORACLE_SERVICE})))"
    )
    conn_str = f'{ORACLE_USER}/"{ORACLE_PASS}"@{dsn}'
    script = f"""SET PAGESIZE 50000
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING ON
SET ECHO OFF
SET TRIMSPOOL ON
SET LONG 30000
SET LONGCHUNKSIZE 30000
SET MARKUP CSV ON DELIMITER , QUOTE ON
{query.strip().rstrip(';')};
EXIT;
"""
    env = os.environ.copy()
    env["NLS_LANG"] = "AMERICAN_AMERICA.AL32UTF8"
    p = subprocess.run(
        [SQLPLUS_BIN, "-S", conn_str],
        input=script.encode("utf-8"),
        capture_output=True
    )
    out = p.stdout.decode("utf-8", errors="replace").strip()
    if p.returncode != 0:
        raise RuntimeError(f"SQL*Plus failed ({p.returncode}): {out}\n{p.stderr.decode('utf-8', errors='replace')}")
    lines = [line for line in out.splitlines() if line.strip()]
    if not lines:
        return []
    reader = csv.DictReader(io.StringIO("\n".join(lines)))
    return list(reader)

def main():
    os.makedirs("data", exist_ok=True)
    print("1. Extrayendo resumen de todos los esquemas de negocio en Oracle...")
    schemas_in = ",".join(f"'{s}'" for s in APP_SCHEMAS)
    cmds_in = ",".join(f"'{s}'" for s in CMDS_ADM_SCHEMAS)

    version_rows = run_sql_csv("SELECT BANNER FROM V$VERSION")
    schema_obj_rows = run_sql_csv(f"""
        SELECT OWNER, OBJECT_TYPE, COUNT(*) AS CNT
        FROM ALL_OBJECTS
        WHERE OWNER IN ({schemas_in})
        GROUP BY OWNER, OBJECT_TYPE
        ORDER BY OWNER, OBJECT_TYPE
    """)

    print("2. Extrayendo catálogo de tablas de todos los esquemas...")
    all_tables_rows = run_sql_csv(f"""
        SELECT t.OWNER, t.TABLE_NAME, t.NUM_ROWS,
               TO_CHAR(t.LAST_ANALYZED, 'YYYY-MM-DD') AS LAST_ANALYZED,
               tc.COMMENTS
        FROM ALL_TABLES t
        LEFT JOIN ALL_TAB_COMMENTS tc
          ON t.OWNER = tc.OWNER AND t.TABLE_NAME = tc.TABLE_NAME
        WHERE t.OWNER IN ({schemas_in})
        ORDER BY t.OWNER, t.TABLE_NAME
    """)

    tables = {}
    other_schemas_tables = {}
    for r in all_tables_rows:
        owner = r["OWNER"]
        tname = r["TABLE_NAME"]
        key = f"{owner}.{tname}"
        num_rows = int(r["NUM_ROWS"]) if r.get("NUM_ROWS") and r["NUM_ROWS"].isdigit() else 0
        entry = {
            "owner": owner,
            "table_name": tname,
            "num_rows": num_rows,
            "last_analyzed": r.get("LAST_ANALYZED"),
            "comments": r.get("COMMENTS") or "",
            "columns": [],
            "constraints": []
        }
        if owner in CMDS_ADM_SCHEMAS:
            tables[key] = entry
        else:
            other_schemas_tables.setdefault(owner, []).append({
                "table_name": tname,
                "num_rows": num_rows,
                "comments": r.get("COMMENTS") or ""
            })

    print(f"3. Extrayendo columnas detalladas de {CMDS_ADM_SCHEMAS}...")
    cols_rows = run_sql_csv(f"""
        SELECT c.OWNER, c.TABLE_NAME, c.COLUMN_ID, c.COLUMN_NAME, c.DATA_TYPE,
               c.DATA_LENGTH, c.DATA_PRECISION, c.DATA_SCALE, c.NULLABLE,
               cc.COMMENTS
        FROM ALL_TAB_COLUMNS c
        LEFT JOIN ALL_COL_COMMENTS cc
          ON c.OWNER = cc.OWNER AND c.TABLE_NAME = cc.TABLE_NAME AND c.COLUMN_NAME = cc.COLUMN_NAME
        WHERE c.OWNER IN ({cmds_in})
        ORDER BY c.OWNER, c.TABLE_NAME, c.COLUMN_ID
    """)
    view_cols = {}
    for r in cols_rows:
        key = f"{r['OWNER']}.{r['TABLE_NAME']}"
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
        if key in tables:
            tables[key]["columns"].append(col_obj)
        else:
            view_cols.setdefault(key, []).append(col_obj)

    print("4. Extrayendo claves primarias y foráneas (Constraints)...")
    cons_rows = run_sql_csv(f"""
        SELECT c.OWNER, c.TABLE_NAME, c.CONSTRAINT_NAME, c.CONSTRAINT_TYPE,
               c.R_OWNER, c.R_CONSTRAINT_NAME,
               LISTAGG(cc.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY cc.POSITION) AS COLS
        FROM ALL_CONSTRAINTS c
        JOIN ALL_CONS_COLUMNS cc
          ON c.OWNER = cc.OWNER AND c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
        WHERE c.CONSTRAINT_TYPE IN ('P', 'R', 'U')
        AND c.OWNER IN ({cmds_in})
        GROUP BY c.OWNER, c.TABLE_NAME, c.CONSTRAINT_NAME, c.CONSTRAINT_TYPE, c.R_OWNER, c.R_CONSTRAINT_NAME
    """)
    pk_map = {}
    for r in cons_rows:
        if r["CONSTRAINT_TYPE"] in ("P", "U"):
            pk_map[f"{r['OWNER']}.{r['CONSTRAINT_NAME']}"] = f"{r['OWNER']}.{r['TABLE_NAME']}({r['COLS']})"

    for r in cons_rows:
        key = f"{r['OWNER']}.{r['TABLE_NAME']}"
        ref = pk_map.get(f"{r['R_OWNER']}.{r['R_CONSTRAINT_NAME']}", f"{r['R_OWNER']}.{r['R_CONSTRAINT_NAME']}") if r["CONSTRAINT_TYPE"] == "R" else None
        if key in tables:
            tables[key]["constraints"].append({
                "name": r["CONSTRAINT_NAME"],
                "type": r["CONSTRAINT_TYPE"],
                "columns": r["COLS"],
                "references": ref
            })

    print("5. Extrayendo vistas de ADM_OBS, ADM_CMDS, ADM_AUTH y PADLOG...")
    views_rows = run_sql_csv(f"""
        SELECT OWNER, VIEW_NAME, TEXT_VC
        FROM ALL_VIEWS
        WHERE OWNER IN ({cmds_in})
        ORDER BY OWNER, VIEW_NAME
    """)
    views = {}
    for r in views_rows:
        key = f"{r['OWNER']}.{r['VIEW_NAME']}"
        views[key] = {
            "owner": r["OWNER"],
            "view_name": r["VIEW_NAME"],
            "text_preview": r.get("TEXT_VC") or "",
            "columns": view_cols.get(key, [])
        }

    output = {
        "banners": [r["BANNER"] for r in version_rows],
        "schema_objects": schema_obj_rows,
        "cmds_adm_tables_count": len(tables),
        "cmds_adm_views_count": len(views),
        "tables": tables,
        "views": views,
        "other_schemas_summary": {
            owner: {
                "table_count": len(tlist),
                "tables": tlist
            }
            for owner, tlist in other_schemas_tables.items()
        }
    }

    with open("data/oracle_schema.json", "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print(f"Extracción Oracle lista: {len(tables)} tablas detalladas de CMDS_ADM, {len(views)} vistas, y resumen de {len(other_schemas_tables)} esquemas adicionales.")

if __name__ == "__main__":
    main()
