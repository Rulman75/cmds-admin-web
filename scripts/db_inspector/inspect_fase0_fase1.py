import json

with open("data/oracle_schema.json", encoding="utf-8") as f:
    s = json.load(f)

tables = s["tables"]
views = s["views"]

print("All BHO_, ADM_, OBS_, HR_ tables in ADM_OBS:")
for k, v in sorted(tables.items()):
    if k.startswith("ADM_OBS.") and any(k.split(".")[1].startswith(p) for p in ("BHO_", "ADM_", "OBS_", "HR_")):
        print(f"  - {k}: {v['num_rows']} rows")

targets = [
    "ADM_OBS.BHO_BOLETAS", "ADM_OBS.BHO_FUNCIONARIOS", "ADM_OBS.BHO_PERIODOS", "ADM_OBS.BHO_FLUJO_ESTADO",
    "ADM_OBS.BHO_EVIDENCIA", "ADM_OBS.BHO_EVIDENCIA_DOCUMENTO", "ADM_OBS.BHO_EVIDENCIA_LOG",
    "ADM_OBS.BHO_CENTRO_COSTO", "ADM_OBS.ADM_REPORTE_SOFTLAND", "ADM_OBS.BHO_REPORTE_PRESUPUESTO",
    "ADM_OBS.BHO_REPORTE_TRANSPARENCIA", "ADM_OBS.BHO_NOMINA_SERVIPAG",
    "ADM_OBS.ADM_SECTOR", "ADM_OBS.ADM_UNIDAD", "ADM_OBS.ADM_FORMACION", "ADM_OBS.ADM_ACTIVIDAD", "ADM_OBS.ADM_CONVENIO",
    "ADM_OBS.HR_DEPARTAMENTO", "ADM_OBS.OBS_REF_CODES", "ADM_OBS.OBS_PARAMETROS", "ADM_OBS.OBS_MENU", "ADM_OBS.OBS_MENU_DETALLE",
    "ADM_OBS.OBS_USUARIOS", "ADM_OBS.OBS_ROLES", "ADM_OBS.OBS_PERFILES", "ADM_OBS.OBS_USER_MENU",
    "ADM_AUTH.AUT_USUARIOS", "ADM_AUTH.AUT_SISTEMAS"
]

print("\n--- DETAILED COLUMNS ---")
for t in targets:
    if t in tables:
        cols = [f"{c['name']} ({c['type']})" for c in tables[t]["columns"]]
        print(f"\nTABLE {t} ({tables[t]['num_rows']} rows):")
        print("  " + ", ".join(cols))
    else:
        print(f"\nMISSING: {t}")

print("\n--- VIEWS ---")
for k, v in sorted(views.items()):
    cols = [f"{c['name']} ({c['type']})" for c in v.get("columns", [])]
    print(f"\nVIEW {k}:")
    print("  " + ", ".join(cols))
    if v.get("text_preview"):
        print("  SQL:", v["text_preview"][:200].replace("\n", " "))
