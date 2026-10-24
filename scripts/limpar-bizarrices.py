#!/usr/bin/env python3
"""
Expurgo forense definitivo de mods bizarros, zoados, tutoriais e substituições incoerentes:
- Carros brasileiros avulsos e tratores (VW Gol Quadrado/Bola, Valtra, Peugeot 206)
- Armas de outros jogos zoados (Fortnite, CS:GO, Combat Arms, Battlegrounds)
- Mods de outros jogos que descaracterizam (Resident Evil 4 Ganados, Max Payne, etc)
- Ferramentas/Tutoriais que vieram do scraper ('Como copiar pastas sem ocupar espaco', 'Euryopa', 'Acceleratorgen')
- Skins e modelos redundantes/conflitantes de gangues
"""

import json

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

# Termos que descaracterizam completamente ou são lixo de scraper
bizarre_terms = [
    # Tutoriais e Ferramentas técnicas de PC
    'como copiar pastas sem ocupar espaço',
    'euryopa',
    'acceleratorgen',
    'chroma key mod',
    'mod vr',
    'sa_directx 2.0',
    'clean render (renderhook)',
    'pbr materials for renderhook',
    'cartoon mod fixed',
    'moddedsaa',
    
    # Armas de outros jogos/zoadas
    'fortnite',
    'combat arms',
    'battlegrounds',
    'cs:go',
    'rainbow weapons',
    'airsoft',
    
    # Carros BR avulsos e tratores soltos
    'vw gol',
    'peugeot 206',
    'trator valtra',
    'farming equipment dlc',
    'snowmobile',
    
    # Conversões e crossovers sem sentido
    'ganados v2.0 (mod resident evil 4)',
    'max payne mod',
    'comic edition',
    'mount akina',
    'london cabbie',
    'amazing player: female',
    
    # Duplicatas caóticas de gangues em HD que brigam entre si
    'nova groove v1',
    'nova grove v2',
    'novas skins para grove em hd',
    'novos ballas em hd',
    'pack de skins grove em hd',
    'pack de skins vagos hd',
    'pack skins da nang boyz hd',
    'bloodz & cripz'
]

clean_catalog = []
removed = []

for m in catalog:
    t_low = m['title'].lower()
    
    matched = False
    for b in bizarre_terms:
        if b in t_low:
            matched = True
            removed.append((m['id'], m['title'], b))
            break
            
    if not matched:
        clean_catalog.append(m)

print(f"Total antes: {len(catalog)}")
print(f"Mods bizarros / tutoriais / crossovers expurgados: {len(removed)}")
for rid, rtitle, rreason in removed:
    print(f"  ❌ [{rid:03d}] {rtitle}")
print(f"\nTotal de mods REALMENTE DEFINITIVOS (Lore-friendly, gráficos, correções, QoL): {len(clean_catalog)}")

for idx, m in enumerate(clean_catalog, 1):
    m['id'] = idx

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
    json.dump(clean_catalog, out, indent=2, ensure_ascii=False)

