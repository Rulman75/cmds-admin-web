import json
from collections import defaultdict

with open("data/oracle_other_schemas.json", encoding="utf-8") as f:
    schemas = json.load(f)

with open("data/oracle_other_catalogs.json", encoding="utf-8") as f:
    cats = json.load(f)

for owner in ["ADM_EDUCA", "ADM_RHU", "ADM_PORTALDIR", "ADMETA", "ADM_NOTAS"]:
    tbls = list(schemas[owner]["tables"].values())
    vws = list(schemas[owner]["views"].values())
    cons_count = sum(len(t["constraints"]) for t in tbls)
    tbls_sorted = sorted(tbls, key=lambda x: int(x["num_rows"] or 0), reverse=True)
    print(f"\n==========================================")
    print(f"{owner}: {len(tbls)} tables, {len(vws)} views, {cons_count} constraints")
    print(f"==========================================")
    
    prefixes = defaultdict(list)
    for t in tbls:
        parts = t["table_name"].split("_")
        pref = "_".join(parts[:2]) if len(parts) > 1 and parts[0] in ("EDC", "RHU", "PDIR", "ETA", "PIE") else parts[0]
        prefixes[pref].append(t)
    
    print("\nTop Prefixes:")
    for pref, plist in sorted(prefixes.items(), key=lambda x: len(x[1]), reverse=True)[:25]:
        total_rows = sum(int(x["num_rows"] or 0) for x in plist)
        sample_names = ", ".join(x["table_name"] for x in sorted(plist, key=lambda x: int(x["num_rows"] or 0), reverse=True)[:4])
        print(f"  - {pref}_* ({len(plist)} tables, {total_rows:,} rows): e.g. {sample_names}")
    
    print("\nTop 20 Tables by Row Count:")
    for t in tbls_sorted[:20]:
        print(f"  - {t['table_name']}: {int(t['num_rows'] or 0):,} rows | {t['comments'] or ''}")
        
    print("\nSample Views (up to 20):")
    for v in vws[:20]:
        print(f"  - {v['view_name']}")
