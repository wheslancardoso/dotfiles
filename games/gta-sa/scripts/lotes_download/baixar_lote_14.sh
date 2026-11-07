#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 14 DE 14 NO BRAVE (Mods 196 a 203) ==="

URLS=(
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [213] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [214] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [215] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [216] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [217] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [218] No Dual Wield + Segurar pistola com duas mãos
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [219] Grafites originais em HD
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [220] The Gang War
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 14/14 enviado para o navegador com sucesso!"
