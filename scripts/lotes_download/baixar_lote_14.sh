#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 14 DE 17 NO BRAVE (Mods 196 a 210) ==="

URLS=(
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [213] No Dual Wield + Segurar pistola com duas mãos
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [214] Grafites originais em HD
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [215] The Gang War
    "https://drive.google.com/open?id=0B04D_5yMCyl9N3h6emNOZHJRLW8" # [218] Extintor Apaga Fogo do Carro
    "https://sharemods.com/ykr4p8mtjmom/Sniper_Distance_Fix.7z.html" # [219] Sniper Distance Fix
    "https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/" # [220] Vigilante Special
    "https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/" # [221] Weapons OutFit
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [222] Proper Vehicles Retex
    "https://sharemods.com/rupfn9c41t3t/Round_Tuning_Wheels_CE.7z.html" # [223] Round Tuning Wheels CE
    "https://sharemods.com/bw24kx8xr9xa/Thunder_Mod.7z.html" # [224] Thunder Mod
    "https://drive.google.com/file/d/0B04D_5yMCyl9ZTZSY25DVEVkaGs/view" # [225] Rain Drops on Screen
    "https://sharemods.com/x5ncmg17msvb/Hard_Rain_Remake.7z.html" # [226] Hard Rain Remake
    "https://sharemods.com/oh41bi0ir69k/SA_-_Project2dfx.zip.html" # [227] Project2DFX v4.4
    "https://sharemods.com/z4br8dabaeum/SA_-_Improved_Night_Windows.7z.html" # [228] Improved Night Windows
    "https://sharemods.com/b3k2k0v5e4pm/Project_Immerse-Yourself.7z.html" # [229] Project Immerse-Yourself
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 14/17 enviado para o navegador com sucesso!"
