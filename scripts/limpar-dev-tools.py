#!/usr/bin/env python3
import json

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

# IDs ou títulos de ferramentas puras de desenvolvimento de mods (não para jogar)
dev_keywords = [
    'visual path editor',
    'in-game map editor',
    'map editor (editar mapa dentro do jogo'
]

clean_catalog = []
removed = []

for m in catalog:
    t_low = m['title'].lower()
    if any(k in t_low for k in dev_keywords):
        removed.append(m['title'])
    else:
        clean_catalog.append(m)

print(f"Total antes: {len(catalog)}")
print(f"Removidas ferramentas de desenvolvimento in-game: {len(removed)}")
for r in removed:
    print(f"  - {r}")
print(f"Total definitivo para GAMEPLAY: {len(clean_catalog)}")

# Reindexar
for idx, m in enumerate(clean_catalog, 1):
    m['id'] = idx

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
    json.dump(clean_catalog, out, indent=2, ensure_ascii=False)

