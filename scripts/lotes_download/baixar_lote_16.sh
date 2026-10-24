#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 20 NO BRAVE (Mods 226 a 240) ==="

URLS=(
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [243] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [244] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [245] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [246] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [247] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [248] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [249] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [250] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [251] No Dual Wield + Segurar pistola com duas mãos
    "https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html" # [252] Bloodz & CripZ (Remake)
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [253] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [254] Pack Skins Da Nang Boyz HD
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [255] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [256] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [257] The Gang War
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/20 enviado para o navegador com sucesso!"
