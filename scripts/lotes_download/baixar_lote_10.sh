#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 10 DE 19 NO BRAVE (Mods 136 a 150) ==="

URLS=(
    "https://sharemods.com/3mapd6624i7k/LCS_PlayIdles_to_SA.7z.html" # [153] LCS PlayIdles to SA
    "https://sharemods.com/nti33jp135j3/PCJ600_Remastered_HD.7z.html" # [154] PCJ600 Remastered HD
    "https://sharemods.com/8kbzd9j6ez1s/Arma_MAC-10.7z.html" # [155] Arma MAC-10 (lowpoly)
    "https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html" # [156] Big Gangster Mod (mais gangues)
    "https://sharemods.com/r17sebrganh9/Deluxo.7z.html" # [157] 86′ Deluxo (SA style)
    "https://sharemods.com/2hzskb32rm52/Chroma_Key.7z.html" # [158] Chroma Key Mod
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [159] Comet Plus+ (SA style)
    "https://www.mixmods.com.br/2020/04/como-copiar-pastas-sem-ocupar-espaco-em-disco-symbolic-link/" # [160] Como copiar pastas sem ocupar espaço em disco (symbolic link)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [161] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/ov81mu97sllm/PBR_materials_for_RenderHook_by_jujubao.7z.html" # [162] PBR materials for RenderHook by jujubao (materiais para RH)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [163] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [164] Wayfarer Plus+ (sa style)
    "https://sharemods.com/9is4rzz7fd7w/Cartoon_Mod_Fixed.7z.html" # [165] Cartoon Mod Fixed (texturas e gráficos cartoon)
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [166] Dream Grass (grama HD do GTA V)
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [167] Grip Animation (nova animação de segurar arma)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 10/19 enviado para o navegador com sucesso!"
