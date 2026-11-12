import json
from collections import defaultdict

with open("data/oracle_other_catalogs.json", encoding="utf-8") as f:
    cats = json.load(f)

print("=== 1. ADM_EDUCA CATALOGS ===")
print("Tipo Apps:", cats["educa_tipo_apps"])
print("\nParametros (EDC_PARAMETROS):")
for p in cats["educa_parametros"]:
    print(f"  - {p['PARA_CODIGO']}: {p['PARA_VALOR']} ({p['PARA_DESC']})")
print("\nParam Corp (EDC_PARAM_CORP):")
for p in cats["educa_param_corp"]:
    print(f"  - [{p['ESAD_COD']}] {p['PCOR_COD']}: {p['PCOR_VALOR']} ({p['PCOR_DESC']})")
print("\nSIGE Param (EDC_SIGE_PARAMETROS):")
for p in cats["educa_sige_param"]:
    print(f"  - {p['SIPA_CODIGO']}: {p['SIPA_VALOR']} ({p['SIPA_DESC']})")

educa_usage = {r["APLI_LINK"]: int(r["USOS"]) for r in cats["educa_top_used_apps"]}
educa_by_parent = defaultdict(list)
educa_by_id = {}
for a in cats["educa_apps"]:
    educa_by_id[a["APLI_COD"]] = a
    educa_by_parent[a["APLI_PADRE"] or "ROOT"].append(a)

print("\nMenu Tree ADM_EDUCA:")
for root in educa_by_parent["ROOT"]:
    print(f"\n* [{root['APLI_COD']}] {root['APLI_LABEL']} ({root['APLI_DESC']})")
    for child in educa_by_parent.get(root["APLI_COD"], []):
        usos = educa_usage.get(child["APLI_LINK"], 0)
        print(f"  - [{child['APLI_COD']}] {child['APLI_LABEL']} -> {child['APLI_LINK']} (Usos log: {usos:,}) | {child['APLI_DESC']}")
        for grand in educa_by_parent.get(child["APLI_COD"], []):
            gusos = educa_usage.get(grand["APLI_LINK"], 0)
            print(f"    * [{grand['APLI_COD']}] {grand['APLI_LABEL']} -> {grand['APLI_LINK']} (Usos log: {gusos:,}) | {grand['APLI_DESC']}")

print("\n\n=== 2. ADM_RHU CATALOGS ===")
print("Roles (RHU_ROLES):")
for r in cats["rhu_roles"]:
    print(f"  - [{r['ROLE_ID']}] {r['ROLE_DESC']}")
print("\nParametros (RHU_PARAMETROS):")
for p in cats["rhu_parametros"]:
    print(f"  - {p['PARA_CODIGO']}: {p['PARA_VALOR']} ({p['PARA_DESC']})")

rhu_usage = {r["LOAP_APP_NOMBRE"]: (int(r["USOS"]), r["ULTIMO_USO"]) for r in cats["rhu_top_used_apps"]}
rhu_by_parent = defaultdict(list)
for a in cats["rhu_menu_apps"]:
    rhu_by_parent[a["APLI_PADRE"] or "ROOT"].append(a)

print("\nMenu Tree ADM_RHU:")
for root in rhu_by_parent["ROOT"]:
    print(f"\n* [{root['APLI_ID']}] {root['APLI_LABEL']} ({root['APLI_DESC']})")
    for child in rhu_by_parent.get(root["APLI_ID"], []):
        u, last = rhu_usage.get(child["APLI_LINK"], (0, "-"))
        print(f"  - [{child['APLI_ID']}] {child['APLI_LABEL']} -> {child['APLI_LINK']} (Usos: {u:,}, Ult: {last}) | {child['APLI_DESC']}")
        for grand in rhu_by_parent.get(child["APLI_ID"], []):
            gu, glast = rhu_usage.get(grand["APLI_LINK"], (0, "-"))
            print(f"    * [{grand['APLI_ID']}] {grand['APLI_LABEL']} -> {grand['APLI_LINK']} (Usos: {gu:,}, Ult: {glast}) | {grand['APLI_DESC']}")

print("\nTop 25 Used RHU Apps (from RHU_LOG_APP):")
for r in cats["rhu_top_used_apps"][:30]:
    print(f"  - {r['LOAP_APP_NOMBRE']}: {int(r['USOS']):,} usos (ultimo: {r['ULTIMO_USO']})")

print("\n\n=== 3. ADM_PORTALDIR CATALOGS ===")
print("Parametros (PDIR_PARAMETROS):")
for p in cats["pdir_parametros"]:
    print(f"  - {p['PARA_COD']}: {p['PARA_VALOR']} ({p['PARA_DESC']}) [Dom: {p['PARA_DOMINIO']}]")
print("\nDominios (PDIR_DOMINIOS):")
for d in cats["pdir_dominios"]:
    print(f"  - {d}")
print("\nApps (PDIR_APPS):")
for a in cats["pdir_apps"]:
    print(f"  - [{a['APP_MODULO']}] {a['APPS_NOMBRE']} (Pagado: {a['APPS_ES_PAGADO']})")
print("\nUsed Apps (PDIR_LOG_MENU):")
for u in cats["pdir_used_apps"]:
    print(f"  - {u['APPLICATION']} ({u['ACTION']}): {int(u['USOS']):,} usos (ultimo: {u['ULTIMO_USO']})")

print("\n\n=== 4. ADMETA CATALOGS ===")
print("Roles:", cats["eta_roles"])
print("Perfiles:", cats["eta_perfiles"])
print("Parametros:", cats["eta_parametros"])
eta_by_parent = defaultdict(list)
for a in cats["eta_menu_apps"]:
    eta_by_parent[a["APLI_PADRE"] or "ROOT"].append(a)
print("\nMenu Tree ADMETA:")
for root in eta_by_parent["ROOT"]:
    print(f"\n* [{root['APLI_ID']}] {root['APLI_LABEL']} ({root['APLI_DESC']})")
    for child in eta_by_parent.get(root["APLI_ID"], []):
        print(f"  - [{child['APLI_ID']}] {child['APLI_LABEL']} -> {child['APLI_LINK']} | {child['APLI_DESC']}")
        for grand in eta_by_parent.get(child["APLI_ID"], []):
            print(f"    * [{grand['APLI_ID']}] {grand['APLI_LABEL']} -> {grand['APLI_LINK']} | {grand['APLI_DESC']}")
