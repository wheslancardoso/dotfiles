#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 07 DE 20 NO BRAVE (Mods 91 a 105) ==="

URLS=(
    "https://sharemods.com/xiqp6ec07z44/Taurus_24_7_PT_58.7z.html" # [103] Pistolas Taurus 24/7 e PT 58 (lowpoly)
    "https://sharemods.com/zh4lmnw9s3m4/Proper_Weapon_Retex.7z.html" # [104] Proper Weapons Retex v1.3 (armas com texturas HD)
    "https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html" # [106] Widescreen Fix para GTA SA (corrigir widescreen)
    "https://sharemods.com/ipzt2b4jipim/Discord_Rich_Presence.7z.html" # [108] GTA SA Discord Rich Presence (mostrar informações no Discord)
    "https://drive.google.com/file/d/1fAxvXqia40TEKuFvyDw-KGaQZEIBf3Wo/view?usp=sharing" # [109] NeXtGen Remaster Weapons (pack de armas em HD)
    "https://sharemods.com/21ot2q919vjr/View_Models_Info.7z.html" # [110] View Models Info v1.1 (ver ID de objetos)
    "https://sharemods.com/j7ee0xxh4rjn/Race_Creator.7z.html" # [111] Race Creator v0.1 (criador de corridas)
    "https://sharemods.com/izvr4xkn8brr/Skyline_Timecyc.7z.html" # [112] Skyline Timecyc (cores corrigidas)
    "https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html" # [113] Open Door Anim v1.2.2 (animação abrindo porta)
    "https://sharemods.com/1i8s8xh9yhsn/Mesa_Plus.7z.html" # [114] Mesa Plus+ (SA style)
    "https://sharemods.com/j7nwrbkgywll/Improved_Default_Armoury.7z.html" # [115] Improved Default Armoury (armas melhoradas com reflexos)
    "https://sharemods.com/z8idkvw7pxvs/Improved_Default_Armoury_For_Cutscenes.7z.html" # [116] Improved Default Armoury For Cutscenes (armas remasterizadas)
    "https://www.mixmods.com.br/2021/03/autoid-v2-2-corrigir-conflito-de-ids-autoadapt/" # [117] AutoID (corrigir conflito de IDs) + AutoAdapt
    "https://sharemods.com/6o30hb6d20nc/Disable_camera_-_Insert_key.7z.html" # [118] ENB Series v0.430 (.asi) + complex shadows, soft particles
    "https://sharemods.com/m7m47k8pbah5/Added_Weapons_Pack.7z.html" # [119] Added 70 Weapons Pack (70 novas armas adicionadas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 07/20 enviado para o navegador com sucesso!"
