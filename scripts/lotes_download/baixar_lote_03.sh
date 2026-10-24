#!/usr/bin/env bash
echo "=== ABRINDO LOTE 03 DE 18 NO BRAVE (Mods 31 a 45) ==="
URLS=(
    "https://sharemods.com/3b7uuwotoncu/SA_-_Wind_Project.7z.html" # [31] [SA] Wind Project v1.0.2 (mod de vento)
    "https://sharemods.com/6s9h92i8pfd0/Girlfriend_Parked_Cars_Restore_Fix.zip.html" # [32] [SA] RepairGTA (corrigir problemas automaticamente)
    "https://sharemods.com/qi1khsdznvmg/Myths_Maker.7z.html" # [33] Myths Maker v2.7 (criar mitos e lendas)
    "https://sharemods.com/wia802k6ikkm/Myths_Maker_-_Animals_Pack.7z.html" # [34] Myths Maker – Animals Pack (mod de animais)
    "https://sharemods.com/0zi4kjql48g1/SA_-_Furniture_Mod.zip.html" # [35] [SA] Furniture Mod v1.0 beta (comprar móveis)
    "https://sharemods.com/a8lp92fm5jz4/Open_Limit_Adjuster.zip.html" # [36] [III|VC|SA] OLA – Open Limit Adjuster v1.7
    "https://sharemods.com/jvdsgr5n0kf9/SA_-_Cyber_Cafe_Interior.7z.html" # [37] [SA] Cyber Cafe Interior (lan-house)
    "https://sharemods.com/6gxnkrbws5wr/GPS_Redux.zip.html" # [38] [SA/SAMP] GPS Redux v1.5 (mostrar caminho no mapa)
    "https://sharemods.com/uj564y9f94iy/SA_-_Proper_HD_Models.7z.html" # [39] [SA] Proper HD Models (objetos remasterizados)
    "https://sharemods.com/4qoj2ti1l74c/SA_VC_III_-_Windowed_Mode.zip.html" # [40] [III/VC/SA] Windowed Mode (modo janela)
    "https://sharemods.com/xhb7m223eofm/Radar_Map_by_wD_D159.7z.html" # [41] [SA] Radar Map by wD.D159 (mapa redesenhado)
    "https://sharemods.com/8f2odk9nzebs/Cars_On_Dirt_Roads.7z.html" # [42] [SA/SA:DE/Mobile] Cars On Dirt Roads Mod (veículos em estradas)
    "https://www.mixmods.com.br/2022/09/sa-visual-path-editor-in-game/" # [43] [SA] Visual Path Editor (in-game)
    "https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html" # [44] [III|VC|SA] CrashInfo v1.2.1 (mostrar solução de crash)
    "https://sharemods.com/7pj7gxozu63l/Color_Mod_and_Fix.zip.html" # [45] [SA] Color Mod by Ryosuke v2 + Fix
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"
