#!/usr/bin/env bash
echo "=== ABRINDO LOTE 12 DE 18 NO BRAVE (Mods 166 a 180) ==="
URLS=(
    "https://sharemods.com/zprw8r1npn0f/Hangout_with_Story_Characters.7z.html" # [166] Hangout with Story Characters (recrutar personagens)
    "https://sharemods.com/1gegyekjbnht/Beta_Gang_Restore.7z.html" # [167] Beta Gang Restore (restaurar gangue beta)
    "https://sharemods.com/3mapd6624i7k/LCS_PlayIdles_to_SA.7z.html" # [168] LCS PlayIdles to SA
    "https://sharemods.com/nti33jp135j3/PCJ600_Remastered_HD.7z.html" # [169] PCJ600 Remastered HD
    "https://sharemods.com/8kbzd9j6ez1s/Arma_MAC-10.7z.html" # [170] Arma MAC-10 (lowpoly)
    "https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html" # [171] Big Gangster Mod (mais gangues)
    "https://sharemods.com/r17sebrganh9/Deluxo.7z.html" # [172] 86′ Deluxo (SA style)
    "https://sharemods.com/2hzskb32rm52/Chroma_Key.7z.html" # [173] Chroma Key Mod
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [174] Comet Plus+ (SA style)
    "https://www.mixmods.com.br/2020/04/como-copiar-pastas-sem-ocupar-espaco-em-disco-symbolic-link/" # [175] Como copiar pastas sem ocupar espaço em disco (symbolic link)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [176] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/y1o3rvh75rzr/ReShade_Auto_Toggle.7z.html" # [177] [III/VC/SA] ReShade Auto Toggle (desativar efeitos no menu)
    "https://sharemods.com/ov81mu97sllm/PBR_materials_for_RenderHook_by_jujubao.7z.html" # [178] PBR materials for RenderHook by jujubao (materiais para RH)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [179] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [180] Wayfarer Plus+ (sa style)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"
