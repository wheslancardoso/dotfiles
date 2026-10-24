#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 17 DE 19 NO BRAVE (Mods 241 a 255) ==="

URLS=(
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [260] Proper Vehicles Retex
    "https://sharemods.com/rupfn9c41t3t/Round_Tuning_Wheels_CE.7z.html" # [261] Round Tuning Wheels CE
    "https://sharemods.com/bw24kx8xr9xa/Thunder_Mod.7z.html" # [262] Thunder Mod
    "https://drive.google.com/file/d/0B04D_5yMCyl9ZTZSY25DVEVkaGs/view" # [263] Rain Drops on Screen
    "https://sharemods.com/x5ncmg17msvb/Hard_Rain_Remake.7z.html" # [264] Hard Rain Remake
    "https://sharemods.com/oh41bi0ir69k/SA_-_Project2dfx.zip.html" # [265] Project2DFX v4.4
    "https://sharemods.com/z4br8dabaeum/SA_-_Improved_Night_Windows.7z.html" # [266] Improved Night Windows
    "https://sharemods.com/b3k2k0v5e4pm/Project_Immerse-Yourself.7z.html" # [267] Project Immerse-Yourself
    "https://sharemods.com/82fetghs6l0z/III_VC_SA_-_SaveLoader.7z.html" # [268] SaveLoader v2.7
    "https://sharemods.com/r880ibdugvnx/SA_SADE_-_Burglary_With_Any_Car.7z.html" # [269] Burglary With Any Car v2.0
    "https://sharemods.com/udjhqbqcf6co/Trunk_Store_Weapons.7z.html" # [270] Trunk Store Weapons
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUkJGMU9weEVnRDg/view" # [271] Weapon Inventory
    "https://sharemods.com/iuerx95tkkup/Enterable_Hidden_Interiors.7z.html" # [272] Enterable Hidden Interiors (EHI)
    "https://sharemods.com/u7gptzz36fct/Save_screen_after_mission.7z.html" # [273] Autosave Mod
    "https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/" # [274] Use All Ladders (Subir em Escadas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 17/19 enviado para o navegador com sucesso!"
