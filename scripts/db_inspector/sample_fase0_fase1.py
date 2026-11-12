import os
import csv
import io
import subprocess
from dotenv import load_dotenv

load_dotenv(".env")

ORACLE_HOST = os.getenv("ORACLE_HOST")
ORACLE_PORT = os.getenv("ORACLE_PORT", "9521")
ORACLE_SERVICE = os.getenv("ORACLE_SERVICE")
ORACLE_USER = os.getenv("ORACLE_USER")
ORACLE_PASS = os.getenv("ORACLE_PASS")
SQLPLUS_BIN = r"C:\oracle32\client\sqlplus.exe"

dsn = (
    f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={ORACLE_HOST})(PORT={ORACLE_PORT}))"
    f"(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={ORACLE_SERVICE})))"
)
conn_str = f'{ORACLE_USER}/"{ORACLE_PASS}"@{dsn}'

queries = {
    "auth_user": "SELECT USUA_ID, USUA_RUT, USUA_DV, USUA_PWD, USA_NOMBRE, USA_APELLIDOS, USA_EMAIL, USA_TIPO, USUA_ESTADO FROM ADM_AUTH.AUT_USUARIOS WHERE USUA_RUT = 10633447",
    "obs_user": "SELECT * FROM ADM_OBS.OBS_USUARIOS_AUTH_V WHERE RUT_USUARIO = 10633447",
    "sectors": "SELECT * FROM ADM_OBS.ADM_SECTOR ORDER BY SECT_SEC",
    "periodos": "SELECT * FROM (SELECT PERI_SEC, PERI_NOMBRE, PERI_ESTADO, TO_CHAR(PERI_FECHA_ING, 'YYYY-MM-DD') AS FECHA_ING, SECT_SEC FROM ADM_OBS.BHO_PERIODOS ORDER BY PERI_SEC DESC) WHERE ROWNUM <= 15",
    "boletas_estados": "SELECT BOLE_ULT_ESTADO, COUNT(*) AS CANT, SUM(BOLE_NETO) AS NETO, SUM(BOLE_IMPUESTO) AS IMP, SUM(BOLE_TOTAL) AS TOTAL FROM ADM_OBS.BHO_BOLETAS GROUP BY BOLE_ULT_ESTADO ORDER BY CANT DESC",
    "boletas_sample": "SELECT * FROM (SELECT b.BOLE_SEC, b.FUNC_SEC, f.FUNC_RUT, f.FUNC_DV, f.FUNC_NOMBRES, f.FUNC_AP_PATERNO, b.PERI_SEC, p.PERI_NOMBRE, b.BOLE_NRO_DOCTO, TO_CHAR(b.BOLE_FECHA_DOCTO, 'YYYY-MM-DD') AS FECHA_DOCTO, b.BOLE_ULT_ESTADO, b.BOLE_NETO, b.BOLE_IMPUESTO, b.BOLE_TOTAL, b.BOLE_UNIDAD, b.ACTI_CODIGO, b.BOLE_CECO_COD, b.BOLE_CONV_CODIGO, b.SECT_SEC FROM ADM_OBS.BHO_BOLETAS b LEFT JOIN ADM_OBS.BHO_FUNCIONARIOS f ON b.FUNC_SEC = f.FUNC_SEC LEFT JOIN ADM_OBS.BHO_PERIODOS p ON b.PERI_SEC = p.PERI_SEC ORDER BY b.BOLE_SEC DESC) WHERE ROWNUM <= 5",
    "evidencia_estados": "SELECT EVIA_ESTADO, COUNT(*) AS CANT FROM ADM_OBS.BHO_EVIDENCIA GROUP BY EVIA_ESTADO ORDER BY CANT DESC",
    "evidencia_sample": "SELECT * FROM (SELECT EVIA_SEC, EVIA_ESTA_COD, EVIA_CONVENIO, EVIA_ANO, EVIA_MES, EVIA_ESTADO, EVIA_BOLETA, EVIA_RUT_EMPLEADO, TO_CHAR(EVIA_FECH_ING, 'YYYY-MM-DD') AS FECH_ING, EVIA_USER_FIRMA_1, EVIA_USER_FIRMA_2, PERI_SEC FROM ADM_OBS.BHO_EVIDENCIA ORDER BY EVIA_SEC DESC) WHERE ROWNUM <= 5"
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
p = subprocess.run([SQLPLUS_BIN, "-S", conn_str], input=("\n".join(sql_parts) + "\n").encode("utf-8"), capture_output=True)
out = p.stdout.decode("utf-8", errors="replace")

for sec in out.split("___SECTION:")[1:]:
    header, _, body = sec.partition("___")
    name = header.strip()
    lines = [ln for ln in body.strip().splitlines() if ln.strip() and not ln.startswith(('"___', 'ORA-', 'SP2-'))]
    rows = list(csv.DictReader(io.StringIO("\n".join(lines)))) if lines else []
    print(f"\n=== {name} ({len(rows)} rows) ===")
    for r in rows:
        print(" ", r)
