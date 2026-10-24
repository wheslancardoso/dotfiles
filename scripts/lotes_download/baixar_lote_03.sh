#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 03 DE 17 NO BRAVE (Novos Mods 31 a 45) ==="
URLS=(
    "https://sharemods.com/6gxnkrbws5wr/GPS_Redux.zip.html" # [38] [SA/SAMP] GPS Redux v1.5 (mostrar caminho no mapa)
    "https://sharemods.com/uj564y9f94iy/SA_-_Proper_HD_Models.7z.html" # [39] [SA] Proper HD Models (objetos remasterizados)
    "https://sharemods.com/4qoj2ti1l74c/SA_VC_III_-_Windowed_Mode.zip.html" # [40] [III/VC/SA] Windowed Mode (modo janela)
    "https://sharemods.com/xhb7m223eofm/Radar_Map_by_wD_D159.7z.html" # [41] [SA] Radar Map by wD.D159 (mapa redesenhado)
    "https://sharemods.com/8f2odk9nzebs/Cars_On_Dirt_Roads.7z.html" # [42] [SA/SA:DE/Mobile] Cars On Dirt Roads Mod (veículos em estradas)
    "https://www.mixmods.com.br/2022/09/sa-visual-path-editor-in-game/" # [43] [SA] Visual Path Editor (in-game)
    "https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html" # [44] [III|VC|SA] CrashInfo v1.2.1 (mostrar solução de crash)
    "https://sharemods.com/7pj7gxozu63l/Color_Mod_and_Fix.zip.html" # [45] [SA] Color Mod by Ryosuke v2 + Fix
    "https://sharemods.com/6xafx05pnj6v/GraphicsTweaker.7z.html" # [46] [SA] Graphics Tweaker v1.3.1 (melhorar gráficos)
    "https://sharemods.com/1euifjsacuwu/SA_-_Z_Menu.7z.html" # [47] [SA] Z Menu (mod trainer)
    "https://sharemods.com/4bgzyt2gtpj2/SA_-_Throw_Rotate_Fix.7z.html" # [48] [SA] Throw Rotate Fix v2.0 (molotov/granada rodando no ar)
    "https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/" # [49] [SA] Revamped Vehicles Project (carros corrigidos e adaptados)
    "https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html" # [50] [III/VC/SA] Framerate Vigilante (corrigir bugs de FPS alto)
    "https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html" # [51] [SA] Peds Extender v1.1.5 (corrigir, restaurar e variar pedestres)
    "https://sharemods.com/a4lbda6sgq5v/Destructive_Rhino_Mod.7z.html" # [52] [SA] Destructive Rhino Mod (explodir tanques)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote pendente aberto no Brave!"
