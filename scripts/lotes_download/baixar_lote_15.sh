#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 15 DE 19 NO BRAVE (Mods 211 a 225) ==="

URLS=(
    "https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO" # [228] M4k3’s New Car Animations – Novas animações ao dirigir
    "https://drive.google.com/open?id=1zgWe0bejROV0cdFQDR6zTr0-E7zK2bKD" # [229] Max Payne Mod
    "https://drive.google.com/file/d/0B1sAJQAUfOOYNjhwLXFQTWFneG8/view" # [230] Amazing Player: Female v2.0 (skin feminina)
    "https://www.mixmods.com.br/2017/10/pack-de-skins-da-ak-47-do-csgo/" # [231] Pack de Skins da AK-47 do CS:GO
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [232] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [233] Explosivo TNT (relógio com detonador)
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [234] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [235] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [236] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [237] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [238] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [239] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [240] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [241] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [242] No Dual Wield + Segurar pistola com duas mãos
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 15/19 enviado para o navegador com sucesso!"
