#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 17 DE 19 NO BRAVE (Mods 241 a 255) ==="

URLS=(
    "https://sharemods.com/bw24kx8xr9xa/Thunder_Mod.7z.html" # [260] Thunder Mod
    "https://drive.google.com/file/d/0B04D_5yMCyl9ZTZSY25DVEVkaGs/view" # [261] Rain Drops on Screen
    "https://sharemods.com/x5ncmg17msvb/Hard_Rain_Remake.7z.html" # [262] Hard Rain Remake
    "https://sharemods.com/oh41bi0ir69k/SA_-_Project2dfx.zip.html" # [263] Project2DFX v4.4
    "https://sharemods.com/z4br8dabaeum/SA_-_Improved_Night_Windows.7z.html" # [264] Improved Night Windows
    "https://sharemods.com/b3k2k0v5e4pm/Project_Immerse-Yourself.7z.html" # [265] Project Immerse-Yourself
    "https://sharemods.com/82fetghs6l0z/III_VC_SA_-_SaveLoader.7z.html" # [266] SaveLoader v2.7
    "https://sharemods.com/r880ibdugvnx/SA_SADE_-_Burglary_With_Any_Car.7z.html" # [267] Burglary With Any Car v2.0
    "https://sharemods.com/udjhqbqcf6co/Trunk_Store_Weapons.7z.html" # [268] Trunk Store Weapons
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUkJGMU9weEVnRDg/view" # [269] Weapon Inventory
    "https://sharemods.com/iuerx95tkkup/Enterable_Hidden_Interiors.7z.html" # [270] Enterable Hidden Interiors (EHI)
    "https://sharemods.com/u7gptzz36fct/Save_screen_after_mission.7z.html" # [271] Autosave Mod
    "https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/" # [272] Use All Ladders (Subir em Escadas)
    "https://sharemods.com/mjxz5fvpmt4p/HeliFix.7z.html" # [273] HeliFix v1.4
    "https://drive.google.com/open?id=0B04D_5yMCyl9RWNHdUdTQVZ0T2M" # [274] Recomeçar Missão
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 17/19 enviado para o navegador com sucesso!"
