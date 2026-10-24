#!/usr/bin/env bash
echo "=== ABRINDO LOTE 08 DE 18 NO BRAVE (Mods 106 a 120) ==="
URLS=(
    "https://sharemods.com/6ljnksq0hmrq/FireType.7z.html" # [106] FireType v6.0 (tiro seletivo: auto, semi, burst)
    "https://drive.google.com/file/d/1KcMiIBNyF7Z-hND1f8G4K3aRUzg6A7se/view?usp=sharing" # [107] Mipmapping
    "https://sharemods.com/qipof5weizvy/Generate_Free_IDs_List.7z.html" # [108] Generate Free IDs List (mostrar IDs vazios)
    "https://sharemods.com/v4buqzhgmour/IMBEL_IA2_FN_FAL.7z.html" # [109] IMBEL IA2 & FN FAL (armas brasileiras em HD)
    "https://sharemods.com/xiqp6ec07z44/Taurus_24_7_PT_58.7z.html" # [110] Pistolas Taurus 24/7 e PT 58 (lowpoly)
    "https://sharemods.com/zh4lmnw9s3m4/Proper_Weapon_Retex.7z.html" # [111] Proper Weapons Retex v1.3 (armas com texturas HD)
    "https://sharemods.com/asxvzdjkpa6m/Real_Skybox.7z.html" # [112] Real Skybox v1.3.4 (céu realista)
    "https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html" # [113] Widescreen Fix para GTA SA (corrigir widescreen)
    "https://sharemods.com/kyvwkd7vtt4i/More_Realistic_Reload_Animation_Mod.7z.html" # [114] More Realistic Reload Weapon Animation Mod (anims de recarregar)
    "https://sharemods.com/ipzt2b4jipim/Discord_Rich_Presence.7z.html" # [115] GTA SA Discord Rich Presence (mostrar informações no Discord)
    "https://drive.google.com/file/d/1fAxvXqia40TEKuFvyDw-KGaQZEIBf3Wo/view?usp=sharing" # [116] NeXtGen Remaster Weapons (pack de armas em HD)
    "https://sharemods.com/21ot2q919vjr/View_Models_Info.7z.html" # [117] View Models Info v1.1 (ver ID de objetos)
    "https://sharemods.com/j7ee0xxh4rjn/Race_Creator.7z.html" # [118] Race Creator v0.1 (criador de corridas)
    "https://sharemods.com/izvr4xkn8brr/Skyline_Timecyc.7z.html" # [119] Skyline Timecyc (cores corrigidas)
    "https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html" # [120] Open Door Anim v1.2.2 (animação abrindo porta)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"
