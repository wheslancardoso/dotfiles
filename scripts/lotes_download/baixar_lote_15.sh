#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 15 DE 16 NO BRAVE (Mods 211 a 225) ==="

URLS=(
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [229] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [230] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [231] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [232] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [233] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [234] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [235] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [236] No Dual Wield + Segurar pistola com duas mãos
    "https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html" # [237] Bloodz & CripZ (Remake)
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [238] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [239] Pack Skins Da Nang Boyz HD
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [240] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [241] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [242] The Gang War
    "https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html" # [243] Novas Skins para Grove em HD
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 15/16 enviado para o navegador com sucesso!"
