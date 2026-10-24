#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 07 DE 20 NO BRAVE (Mods 91 a 105) ==="

URLS=(
    "https://drive.google.com/file/d/1KcMiIBNyF7Z-hND1f8G4K3aRUzg6A7se/view?usp=sharing" # [103] Mipmapping
    "https://sharemods.com/qipof5weizvy/Generate_Free_IDs_List.7z.html" # [104] Generate Free IDs List (mostrar IDs vazios)
    "https://sharemods.com/v4buqzhgmour/IMBEL_IA2_FN_FAL.7z.html" # [105] IMBEL IA2 & FN FAL (armas brasileiras em HD)
    "https://sharemods.com/xiqp6ec07z44/Taurus_24_7_PT_58.7z.html" # [106] Pistolas Taurus 24/7 e PT 58 (lowpoly)
    "https://sharemods.com/zh4lmnw9s3m4/Proper_Weapon_Retex.7z.html" # [107] Proper Weapons Retex v1.3 (armas com texturas HD)
    "https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html" # [109] Widescreen Fix para GTA SA (corrigir widescreen)
    "https://sharemods.com/ipzt2b4jipim/Discord_Rich_Presence.7z.html" # [111] GTA SA Discord Rich Presence (mostrar informações no Discord)
    "https://drive.google.com/file/d/1fAxvXqia40TEKuFvyDw-KGaQZEIBf3Wo/view?usp=sharing" # [112] NeXtGen Remaster Weapons (pack de armas em HD)
    "https://sharemods.com/21ot2q919vjr/View_Models_Info.7z.html" # [113] View Models Info v1.1 (ver ID de objetos)
    "https://sharemods.com/j7ee0xxh4rjn/Race_Creator.7z.html" # [114] Race Creator v0.1 (criador de corridas)
    "https://sharemods.com/izvr4xkn8brr/Skyline_Timecyc.7z.html" # [115] Skyline Timecyc (cores corrigidas)
    "https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html" # [116] Open Door Anim v1.2.2 (animação abrindo porta)
    "https://sharemods.com/1i8s8xh9yhsn/Mesa_Plus.7z.html" # [117] Mesa Plus+ (SA style)
    "https://sharemods.com/j7nwrbkgywll/Improved_Default_Armoury.7z.html" # [118] Improved Default Armoury (armas melhoradas com reflexos)
    "https://sharemods.com/z8idkvw7pxvs/Improved_Default_Armoury_For_Cutscenes.7z.html" # [119] Improved Default Armoury For Cutscenes (armas remasterizadas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 07/20 enviado para o navegador com sucesso!"
