#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 02 DE 07 NO BRAVE (Mods 13 a 24) ==="

URLS=(
    "https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro" # [18] Vigilante Special
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [19] Sprinting With Two Handed Weapons
    "https://sharemods.com/wia802k6ikkm/Myths_Maker_-_Animals_Pack.7z.html" # [20] Myths Maker – Animals Pack
    "https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo" # [21] Weapons OutFit
    "https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project" # [22] Revamped Vehicles Project
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [23] Proper Vehicles Retex
    "https://sharemods.com/rupfn9c41t3t/Round_Tuning_Wheels_CE.7z.html" # [24] Round Tuning Wheels CE
    "https://sharemods.com/px30jmq1k2xo/SA_-_Proper_Shaders_08-26___40_py8vte2gr7a__41_.zip.html" # [25] Proper Shaders
    "https://sharemods.com/bw24kx8xr9xa/Thunder_Mod.7z.html" # [26] Thunder Mod
    "https://drive.google.com/file/d/0B04D_5yMCyl9ZTZSY25DVEVkaGs/view" # [27] Rain Drops on Screen
    "https://sharemods.com/x5ncmg17msvb/Hard_Rain_Remake.7z.html" # [28] Hard Rain Remake
    "https://sharemods.com/oh41bi0ir69k/SA_-_Project2dfx.zip.html" # [29] Project2DFX v4.4
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 02/07 aberto no Brave com sucesso!"
