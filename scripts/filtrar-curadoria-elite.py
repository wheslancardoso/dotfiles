#!/usr/bin/env python3
"""
Filtra o catalogo de mods expurgando:
1. Shaders/ENBs/ReShade conflitantes com SkyGfx
2. Trainers duplicados (já temos Cheat Menu by Grinch)
3. Mods de debug ou dev tools (Draw Cols, CamHunt, etc.)
4. Mods que removem conteúdo ou deixam o jogo punitivo/chato (Remove Brass Knuckles, PedSkills hardcore)
5. Mods que já estão baixados (Framerate Vigilante já está no Essentials)
"""

import json

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

# Termos a expurgar estritamente
unwanted_terms = [
    # Shaders que conflitam com SkyGfx / crasham RenderWare
    'enb series',
    'reshade',
    'colormod',
    'graphics tweaker',
    'real linear graphics',
    
    # Trainers inferiores duplicados (Grinch_ Cheat Menu é o rei supremo)
    'z menu',
    
    # Debug / Dev Tools
    'draw cols',
    'camhunt',
    
    # Restrições chatas / mods de nicho indesejados
    'remove brass knuckles',
    'pedskills'
]

clean_catalog = []
purged = []

for m in catalog:
    t_low = m['title'].lower()
    p_low = m['post'].lower()
    
    should_purge = False
    reason = ""
    for term in unwanted_terms:
        if term in t_low or term in p_low:
            should_purge = True
            reason = term
            break
            
    if should_purge:
        purged.append((m['id'], m['title'], reason))
    else:
        clean_catalog.append(m)

print(f"Total antes: {len(catalog)}")
print(f"Mods expurgados por incompatibilidade, redundância ou serem chatos/dev: {len(purged)}")
for pid, ptitle, preason in purged:
    print(f"  ❌ [{pid:03d}] {ptitle} (Motivo: {preason})")
print(f"Total de mods APROVADOS para a experiência definitiva: {len(clean_catalog)}")

for idx, m in enumerate(clean_catalog, 1):
    m['id'] = idx

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
    json.dump(clean_catalog, out, indent=2, ensure_ascii=False)

