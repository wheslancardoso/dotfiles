#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 07 DE 16 NO BRAVE (Mods 91 a 105) ==="

URLS=(
    "https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html" # [105] Widescreen Fix para GTA SA (corrigir widescreen)
    "https://sharemods.com/ipzt2b4jipim/Discord_Rich_Presence.7z.html" # [107] GTA SA Discord Rich Presence (mostrar informações no Discord)
    "https://drive.google.com/file/d/1fAxvXqia40TEKuFvyDw-KGaQZEIBf3Wo/view?usp=sharing" # [108] NeXtGen Remaster Weapons (pack de armas em HD)
    "https://sharemods.com/21ot2q919vjr/View_Models_Info.7z.html" # [109] View Models Info v1.1 (ver ID de objetos)
    "https://sharemods.com/j7ee0xxh4rjn/Race_Creator.7z.html" # [110] Race Creator v0.1 (criador de corridas)
    "https://sharemods.com/izvr4xkn8brr/Skyline_Timecyc.7z.html" # [111] Skyline Timecyc (cores corrigidas)
    "https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html" # [112] Open Door Anim v1.2.2 (animação abrindo porta)
    "https://sharemods.com/1i8s8xh9yhsn/Mesa_Plus.7z.html" # [113] Mesa Plus+ (SA style)
    "https://sharemods.com/j7nwrbkgywll/Improved_Default_Armoury.7z.html" # [114] Improved Default Armoury (armas melhoradas com reflexos)
    "https://sharemods.com/z8idkvw7pxvs/Improved_Default_Armoury_For_Cutscenes.7z.html" # [115] Improved Default Armoury For Cutscenes (armas remasterizadas)
    "https://www.mixmods.com.br/2021/03/autoid-v2-2-corrigir-conflito-de-ids-autoadapt/" # [116] AutoID (corrigir conflito de IDs) + AutoAdapt
    "https://sharemods.com/m7m47k8pbah5/Added_Weapons_Pack.7z.html" # [117] Added 70 Weapons Pack (70 novas armas adicionadas)
    "https://sharemods.com/v0mqs5d7wick/Save_Tools.7z.html" # [118] Save Tools – Jogo salvo 100% + Save Game Helper + Backup
    "https://sharemods.com/cg6r9vwvtdik/Rikintosh__x27_s_Small_Details_Mod_-_Improved.7z.html" # [119] Rikintosh’s Small Details Mod (carros com texturas HD)
    "https://sharemods.com/3bet7r9pi53t/SAORS.7z.html" # [121] SAORS v2 (mod rádio online)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 07/16 enviado para o navegador com sucesso!"
