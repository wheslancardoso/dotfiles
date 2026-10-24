#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 01 DE 07 NO BRAVE (Mods 1 a 12) ==="

URLS=(
    "https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html" # [01] MixSets v4.3.7+
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [02] MoonLoader v0.26+
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [03] ModLoader Support for MoonLoader
    "https://sharemods.com/6gxnkrbws5wr/GPS_Redux.zip.html" # [04] GPS Redux v1.5
    "https://www.mixmods.com.br/2022/03/atualizados-anderius-manual-driveby-v-hud-mesh-smoothed" # [07] GTA V HUD / Weapon Wheel
    "https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html" # [08] Framerate Vigilante
    "https://sharemods.com/79u303jv0csa/Proper_Streaming.zip.html" # [09] Save Anywhere Mod
    "https://github.com/CookiePLMonster/SilentPatch/releases/tag/1.1-BUILD34.1-SA" # [11] SilentPatch
    "https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52" # [12] Cheat Menu v3.52
    "https://drive.google.com/open?id=0B04D_5yMCyl9N3h6emNOZHJRLW8" # [14] Extintor Apaga Fogo do Carro
    "https://drive.google.com/file/d/115LMhaNP6mh-Sip9Sbtdl9EulSUlaq2F/view" # [15] Proper Fixes v2.1.1
    "https://sharemods.com/ykr4p8mtjmom/Sniper_Distance_Fix.7z.html" # [17] Sniper Distance Fix
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 01/07 aberto no Brave com sucesso!"
