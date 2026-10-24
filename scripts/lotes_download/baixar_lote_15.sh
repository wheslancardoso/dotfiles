#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 15 DE 17 NO BRAVE (Mods 211 a 225) ==="

URLS=(
    "https://sharemods.com/82fetghs6l0z/III_VC_SA_-_SaveLoader.7z.html" # [230] SaveLoader v2.7
    "https://sharemods.com/r880ibdugvnx/SA_SADE_-_Burglary_With_Any_Car.7z.html" # [231] Burglary With Any Car v2.0
    "https://sharemods.com/udjhqbqcf6co/Trunk_Store_Weapons.7z.html" # [232] Trunk Store Weapons
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUkJGMU9weEVnRDg/view" # [233] Weapon Inventory
    "https://sharemods.com/iuerx95tkkup/Enterable_Hidden_Interiors.7z.html" # [234] Enterable Hidden Interiors (EHI)
    "https://sharemods.com/u7gptzz36fct/Save_screen_after_mission.7z.html" # [235] Autosave Mod
    "https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/" # [236] Use All Ladders (Subir em Escadas)
    "https://sharemods.com/mjxz5fvpmt4p/HeliFix.7z.html" # [237] HeliFix v1.4
    "https://drive.google.com/open?id=0B04D_5yMCyl9RWNHdUdTQVZ0T2M" # [238] Recomeçar Missão
    "https://sharemods.com/duxyrps05sns/Dynamic_Shadow_Color.7z.html" # [240] Dynamic Shadow Color (Sombras com Cores Atmosféricas)
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [241] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [242] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [243] More Radar Icons v2.0
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [244] Improved Surface Physics (Superfícies com Física Aprimorada)
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [245] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 15/17 enviado para o navegador com sucesso!"
