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

dsn = (
    f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={ORACLE_HOST})(PORT={ORACLE_PORT}))"
    f"(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={ORACLE_SERVICE})))"
)
conn_str = f'{ORACLE_USER}/"{ORACLE_PASS}"@{dsn}'

queries = {
    "ref_codes": "SELECT REF_DOM, REF_LOW_VAL, REF_HIG_VAL, REF_ABR, REF_MNG, REF_AGR, REF_MOD FROM ADM_OBS.OBS_REF_CODES ORDER BY REF_DOM, REF_LOW_VAL",
    "dbg_routines": "SELECT DISTINCT LOGG_CLIENT_ID, LOGG_RUTINA FROM ADM_OBS.DBG_LOGGER_01 ORDER BY 1, 2",
    "padlog_procedures": "SELECT DISTINCT LOG_CLIENT, LOG_PROCEDURE FROM PADLOG.PADLOG_LOGGER2_01 WHERE ROWNUM <= 50000 ORDER BY 1, 2"
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

res = {}
sections = out.split("___SECTION:")
for sec in sections[1:]:
    header, _, body = sec.partition("___")
    name = header.strip()
    lines = [ln for ln in body.strip().splitlines() if ln.strip() and not ln.startswith(('"___', 'ORA-', 'SP2-'))]
    if lines:
        res[name] = list(csv.DictReader(io.StringIO("\n".join(lines))))
    else:
        res[name] = []
    print(f"{name}: {len(res[name])} rows")
    for sample in res[name][:20]:
        print(" ", sample)

with open("data/oracle_domains_and_routines.json", "w", encoding="utf-8") as f:
    json.dump(res, f, ensure_ascii=False, indent=2)
