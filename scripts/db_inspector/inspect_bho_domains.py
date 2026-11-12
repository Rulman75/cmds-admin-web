import json
from collections import defaultdict

with open("data/oracle_domains_and_routines.json", encoding="utf-8") as f:
    d = json.load(f)

domains = defaultdict(list)
for r in d["ref_codes"]:
    domains[r["REF_DOM"]].append(r)

for dom, items in sorted(domains.items()):
    print(f"\n* {dom} ({len(items)} items):")
    for it in items:
        print(f"    {it['REF_LOW_VAL']} -> {it['REF_MNG']} (abr: {it['REF_ABR']}, mod: {it['REF_MOD']})")
