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

queries = {
    "aut_sistemas": "SELECT SIST_ID, SIST_DESCRIPCION, CLIENT_ID, REDIRECT_URI, GRANT_TYPES, SCOPE FROM ADM_AUTH.AUT_SISTEMAS ORDER BY 1",
    "aut_grupos": "SELECT GRUP_ID, GRUP_NOMBRE FROM ADM_AUTH.AUT_GRUPOS ORDER BY 1",
    "aut_grupos_sistemas": "SELECT GRUP_ID, SIST_ID FROM ADM_AUTH.AUT_GRUPOS_SISTEMAS ORDER BY 1",
    "aut_parametros": "SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR FROM ADM_AUTH.AUT_PARAMETROS ORDER BY 1",
    "obs_menu": "SELECT MENU_ID, MENU_DESC, MENU_ID_PADRE FROM ADM_OBS.OBS_MENU ORDER BY MENU_ID",
    "obs_menu_detalle": "SELECT MEDE_ID, MENU_ID, MEDE_DESC, MEDE_LABEL, MEDE_LINK, MEDE_AYUDA, MEDE_POS_PADRE, MEDE_POS_APLIC FROM ADM_OBS.OBS_MENU_DETALLE ORDER BY MENU_ID, MEDE_POS_APLIC",
    "obs_parametros": "SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR FROM ADM_OBS.OBS_PARAMETROS ORDER BY 1",
    "mpu_param_app": "SELECT PAAP_CODIGO, PAAP_DESC, PAAP_VALOR FROM ADM_OBS.MPU_PARAM_APP ORDER BY 1",
    "pbe_sistemas": "SELECT * FROM ADM_PROC_BE.PBE_SISTEMAS ORDER BY 1",
    "pbe_job_procesos": "SELECT * FROM ADM_PROC_BE.PBE_JOB_PROCESOS ORDER BY 1"
}

dsn = (
    f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={ORACLE_HOST})(PORT={ORACLE_PORT}))"
    f"(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={ORACLE_SERVICE})))"
)
conn_str = f'{ORACLE_USER}/"{ORACLE_PASS}"@{dsn}'

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
script = "\n".join(sql_parts) + "\n"

env = os.environ.copy()
env["NLS_LANG"] = "AMERICAN_AMERICA.AL32UTF8"
p = subprocess.run([SQLPLUS_BIN, "-S", conn_str], input=script.encode("utf-8"), capture_output=True)
out = p.stdout.decode("utf-8", errors="replace")

catalogs = {}
sections = out.split("___SECTION:")
for sec in sections[1:]:
    header, _, body = sec.partition("___")
    name = header.strip()
    lines = [ln for ln in body.strip().splitlines() if ln.strip() and not ln.startswith("ORA-") and not ln.startswith("SP2-")]
    if lines:
        reader = csv.DictReader(io.StringIO("\n".join(lines)))
        catalogs[name] = list(reader)
    else:
        catalogs[name] = []
    print(f"{name}: {len(catalogs[name])} rows")

with open("data/oracle_catalogs.json", "w", encoding="utf-8") as f:
    json.dump(catalogs, f, ensure_ascii=False, indent=2)
