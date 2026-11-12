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
    "educa_apps": "SELECT APLI_COD, APLI_DESC, APLI_LABEL, APLI_PADRE, APLI_LINK, APLI_ICONO, APLI_AYUDA, APLI_TARGET FROM ADM_EDUCA.EDC_APLICACIONES ORDER BY APLI_PADRE NULLS FIRST, APLI_COD",
    "educa_tipo_apps": "SELECT * FROM ADM_EDUCA.EDC_TIPO_APPS ORDER BY 1",
    "educa_parametros": "SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR FROM ADM_EDUCA.EDC_PARAMETROS ORDER BY 1",
    "educa_param_corp": "SELECT ESAD_COD, PCOR_COD, PCOR_DESC, PCOR_VALOR FROM ADM_EDUCA.EDC_PARAM_CORP ORDER BY 1, 2",
    "educa_sige_param": "SELECT SIPA_CODIGO, SIPA_VALOR, SIPA_DESC FROM ADM_EDUCA.EDC_SIGE_PARAMETROS ORDER BY 1",
    "educa_top_used_apps": "SELECT APLI_LINK, COUNT(*) AS USOS FROM ADM_EDUCA.EDC_TRACE_APLIC_LOG$_11 GROUP BY APLI_LINK ORDER BY USOS DESC",
    "rhu_menu_apps": "SELECT APLI_ID, APLI_DESC, APLI_LABEL, APLI_PADRE, APLI_LINK, APLI_AYUDA, APLI_TARGET FROM ADM_RHU.RHU_MENU_APP_V ORDER BY APLI_PADRE NULLS FIRST, APLI_ID",
    "rhu_roles": "SELECT ROLE_ID, ROLE_DESC FROM ADM_RHU.RHU_ROLES ORDER BY 1",
    "rhu_parametros": "SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR FROM ADM_RHU.RHU_PARAMETROS ORDER BY 1",
    "rhu_top_used_apps": "SELECT LOAP_APP_NOMBRE, COUNT(*) AS USOS, TO_CHAR(MAX(LOAP_FEC_INGRESO), 'YYYY-MM-DD') AS ULTIMO_USO FROM ADM_RHU.RHU_LOG_APP GROUP BY LOAP_APP_NOMBRE ORDER BY USOS DESC",
    "rhu_domains_summary": "SELECT APDO_DOMAIN, COUNT(*) AS CANT FROM ADM_RHU.RHU_APP_DOMAINS GROUP BY APDO_DOMAIN ORDER BY APDO_DOMAIN",
    "pdir_apps": "SELECT APPS_NOMBRE, APP_MODULO, APPS_ES_PAGADO FROM ADM_PORTALDIR.PDIR_APPS ORDER BY 2, 1",
    "pdir_used_apps": "SELECT APPLICATION, ACTION, COUNT(*) AS USOS, TO_CHAR(MAX(INSERTED_DATE), 'YYYY-MM-DD') AS ULTIMO_USO FROM ADM_PORTALDIR.PDIR_LOG_MENU GROUP BY APPLICATION, ACTION ORDER BY USOS DESC",
    "pdir_parametros": "SELECT PARA_COD, PARA_DESC, PARA_VALOR, PARA_DOMINIO FROM ADM_PORTALDIR.PDIR_PARAMETROS ORDER BY 1",
    "pdir_dominios": "SELECT * FROM ADM_PORTALDIR.PDIR_DOMINIOS ORDER BY 1",
    "eta_menu_apps": "SELECT APLI_ID, APLI_DESC, APLI_LABEL, APLI_PADRE, APLI_LINK, APLI_AYUDA FROM ADMETA.ETA_MENU_APP_V ORDER BY APLI_PADRE NULLS FIRST, APLI_ID",
    "eta_parametros": "SELECT PARA_CODIGO, PARA_DESC, PARA_VALOR FROM ADMETA.ETA_PARAMETROS ORDER BY 1",
    "eta_perfiles": "SELECT PERF_ID, PERF_DESC FROM ADMETA.ETA_PERFILES ORDER BY 1",
    "eta_roles": "SELECT ROLE_ID, ROLE_DESC FROM ADMETA.ETA_ROLES ORDER BY 1"
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

catalogs = {}
for sec in out.split("___SECTION:")[1:]:
    header, _, body = sec.partition("___")
    name = header.strip()
    lines = [ln for ln in body.strip().splitlines() if ln.strip() and not ln.startswith(('"___', 'ORA-', 'SP2-'))]
    catalogs[name] = list(csv.DictReader(io.StringIO("\n".join(lines)))) if lines else []
    print(f"{name}: {len(catalogs[name])} rows")

with open("data/oracle_other_catalogs.json", "w", encoding="utf-8") as f:
    json.dump(catalogs, f, ensure_ascii=False, indent=2)
