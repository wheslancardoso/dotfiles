#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 03 DE 20 NO BRAVE (Mods 31 a 45) ==="

URLS=(
    "https://sharemods.com/8f2odk9nzebs/Cars_On_Dirt_Roads.7z.html" # [37] [SA/SA:DE/Mobile] Cars On Dirt Roads Mod (veículos em estradas)
    "https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html" # [38] [III|VC|SA] CrashInfo v1.2.1 (mostrar solução de crash)
    "https://sharemods.com/7pj7gxozu63l/Color_Mod_and_Fix.zip.html" # [39] [SA] Color Mod by Ryosuke v2 + Fix
    "https://sharemods.com/6xafx05pnj6v/GraphicsTweaker.7z.html" # [40] [SA] Graphics Tweaker v1.3.1 (melhorar gráficos)
    "https://sharemods.com/1euifjsacuwu/SA_-_Z_Menu.7z.html" # [41] [SA] Z Menu (mod trainer)
    "https://sharemods.com/4bgzyt2gtpj2/SA_-_Throw_Rotate_Fix.7z.html" # [42] [SA] Throw Rotate Fix v2.0 (molotov/granada rodando no ar)
    "https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/" # [43] [SA] Revamped Vehicles Project (carros corrigidos e adaptados)
    "https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html" # [44] [III/VC/SA] Framerate Vigilante (corrigir bugs de FPS alto)
    "https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html" # [45] [SA] Peds Extender v1.1.5 (corrigir, restaurar e variar pedestres)
    "https://sharemods.com/a4lbda6sgq5v/Destructive_Rhino_Mod.7z.html" # [46] [SA] Destructive Rhino Mod (explodir tanques)
    "https://sharemods.com/2xibsxei9gan/PedSkills.7z.html" # [47] [SA] PedSkills v2.2 (aumentar dificuldade)
    "https://sharemods.com/dhjea67wrhm1/Real_Linear_Graphics.7z.html" # [48] Real Linear Graphics v2.6 (cores realistas)
    "https://sharemods.com/w1gml4nqvlo8/Remove_Brass_Knucles.7z.html" # [49] [SA/SADE/Mobile] Remove Brass Knuckles (desativar soco-inglês)
    "https://sharemods.com/a3tl94dgrzrb/Body_Stats_Fix.7z.html" # [51] [SA] Body Stats Fix in Interiors (corrigir corpo sem mudar)
    "https://sharemods.com/pknk1m9jkooc/SADE_-_Torch_Mod.7z.html" # [53] [SA/SA:DE] Torch Mod (tocha com luz)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 03/20 enviado para o navegador com sucesso!"
