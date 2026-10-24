#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 03 DE 16 NO BRAVE (Mods 31 a 45) ==="

URLS=(
    "https://sharemods.com/uj564y9f94iy/SA_-_Proper_HD_Models.7z.html" # [38] [SA] Proper HD Models (objetos remasterizados)
    "https://sharemods.com/4qoj2ti1l74c/SA_VC_III_-_Windowed_Mode.zip.html" # [39] [III/VC/SA] Windowed Mode (modo janela)
    "https://sharemods.com/xhb7m223eofm/Radar_Map_by_wD_D159.7z.html" # [40] [SA] Radar Map by wD.D159 (mapa redesenhado)
    "https://sharemods.com/8f2odk9nzebs/Cars_On_Dirt_Roads.7z.html" # [41] [SA/SA:DE/Mobile] Cars On Dirt Roads Mod (veículos em estradas)
    "https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html" # [42] [III|VC|SA] CrashInfo v1.2.1 (mostrar solução de crash)
    "https://sharemods.com/7pj7gxozu63l/Color_Mod_and_Fix.zip.html" # [43] [SA] Color Mod by Ryosuke v2 + Fix
    "https://sharemods.com/4bgzyt2gtpj2/SA_-_Throw_Rotate_Fix.7z.html" # [44] [SA] Throw Rotate Fix v2.0 (molotov/granada rodando no ar)
    "https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/" # [45] [SA] Revamped Vehicles Project (carros corrigidos e adaptados)
    "https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html" # [46] [III/VC/SA] Framerate Vigilante (corrigir bugs de FPS alto)
    "https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html" # [47] [SA] Peds Extender v1.1.5 (corrigir, restaurar e variar pedestres)
    "https://sharemods.com/a4lbda6sgq5v/Destructive_Rhino_Mod.7z.html" # [48] [SA] Destructive Rhino Mod (explodir tanques)
    "https://sharemods.com/a3tl94dgrzrb/Body_Stats_Fix.7z.html" # [50] [SA] Body Stats Fix in Interiors (corrigir corpo sem mudar)
    "https://sharemods.com/pknk1m9jkooc/SADE_-_Torch_Mod.7z.html" # [52] [SA/SA:DE] Torch Mod (tocha com luz)
    "https://sharemods.com/2289owg3jx0m/Death_In_Car.7z.html" # [53] Death In Car (morrer dentro do carro)
    "https://sharemods.com/1u3i9l2uo4ao/Gang_Hands_Texture_Fix.7z.html" # [54] [SA] Gang Hands Texture Fix (corrigir mãos bugadas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 03/16 enviado para o navegador com sucesso!"
