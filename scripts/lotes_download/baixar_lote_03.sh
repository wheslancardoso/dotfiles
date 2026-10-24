#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 03 DE 07 NO BRAVE (Mods 25 a 36) ==="

URLS=(
    "https://sharemods.com/z4br8dabaeum/SA_-_Improved_Night_Windows.7z.html" # [30] Improved Night Windows
    "https://sharemods.com/b3k2k0v5e4pm/Project_Immerse-Yourself.7z.html" # [31] Project Immerse-Yourself
    "https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html" # [32] Missing Lampposts Fix
    "https://sharemods.com/82fetghs6l0z/III_VC_SA_-_SaveLoader.7z.html" # [33] SaveLoader v2.7
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [34] Gang Rider v2
    "https://sharemods.com/r880ibdugvnx/SA_SADE_-_Burglary_With_Any_Car.7z.html" # [35] Burglary With Any Car v2.0
    "https://sharemods.com/udjhqbqcf6co/Trunk_Store_Weapons.7z.html" # [36] Trunk Store Weapons
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUkJGMU9weEVnRDg/view" # [37] Weapon Inventory
    "https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html" # [38] LOD Vegetation v1.2
    "https://sharemods.com/iuerx95tkkup/Enterable_Hidden_Interiors.7z.html" # [39] Enterable Hidden Interiors (EHI)
    "https://sharemods.com/u7gptzz36fct/Save_screen_after_mission.7z.html" # [40] Autosave Mod
    "https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas" # [41] Use All Ladders (Subir em Escadas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 03/07 aberto no Brave com sucesso!"
