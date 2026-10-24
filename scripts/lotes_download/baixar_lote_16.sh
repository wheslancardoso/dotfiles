#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 20 NO BRAVE (Mods 226 a 240) ==="

URLS=(
    "https://www.mixmods.com.br/2017/10/pack-de-skins-da-ak-47-do-csgo/" # [243] Pack de Skins da AK-47 do CS:GO
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [244] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [245] Explosivo TNT (relógio com detonador)
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [246] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [247] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [248] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [249] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [250] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [251] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [252] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [253] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [254] No Dual Wield + Segurar pistola com duas mãos
    "https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html" # [255] Bloodz & CripZ (Remake)
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [256] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [257] Pack Skins Da Nang Boyz HD
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/20 enviado para o navegador com sucesso!"
