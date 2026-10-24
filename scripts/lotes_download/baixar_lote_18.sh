#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 18 DE 20 NO BRAVE (Mods 256 a 270) ==="

URLS=(
    "https://sharemods.com/z4br8dabaeum/SA_-_Improved_Night_Windows.7z.html" # [275] Improved Night Windows
    "https://sharemods.com/b3k2k0v5e4pm/Project_Immerse-Yourself.7z.html" # [276] Project Immerse-Yourself
    "https://sharemods.com/82fetghs6l0z/III_VC_SA_-_SaveLoader.7z.html" # [277] SaveLoader v2.7
    "https://sharemods.com/r880ibdugvnx/SA_SADE_-_Burglary_With_Any_Car.7z.html" # [278] Burglary With Any Car v2.0
    "https://sharemods.com/udjhqbqcf6co/Trunk_Store_Weapons.7z.html" # [279] Trunk Store Weapons
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUkJGMU9weEVnRDg/view" # [280] Weapon Inventory
    "https://sharemods.com/iuerx95tkkup/Enterable_Hidden_Interiors.7z.html" # [281] Enterable Hidden Interiors (EHI)
    "https://sharemods.com/u7gptzz36fct/Save_screen_after_mission.7z.html" # [282] Autosave Mod
    "https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/" # [283] Use All Ladders (Subir em Escadas)
    "https://sharemods.com/mjxz5fvpmt4p/HeliFix.7z.html" # [284] HeliFix v1.4
    "https://drive.google.com/open?id=0B04D_5yMCyl9RWNHdUdTQVZ0T2M" # [285] Recomeçar Missão
    "https://sharemods.com/duxyrps05sns/Dynamic_Shadow_Color.7z.html" # [287] Dynamic Shadow Color (Sombras com Cores Atmosféricas)
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [288] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [289] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [290] More Radar Icons v2.0
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 18/20 enviado para o navegador com sucesso!"
