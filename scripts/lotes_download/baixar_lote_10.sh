#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 10 DE 20 NO BRAVE (Mods 136 a 150) ==="

URLS=(
    "https://sharemods.com/jm60r1j8pr72/Euryopa.7z.html" # [153] Euryopa (visualizador de mapa para GTA)
    "https://sharemods.com/ywqqzuky007z/Futo_Trueno_Levin.7z.html" # [154] Futo Trueno + Levin (AE86 SA style)
    "https://sharemods.com/s8bmfqkshpzo/90s_Atmosphere_Weapons_Pack_Reborn.7z.html" # [155] 90s AWP – 90s Atmosphere Weapons Pack Reborn 4.0
    "https://sharemods.com/coxoxpb23p35/ENBSeriesAutoToggle.7z.html" # [156] ENB Series Auto Toggle (desativar ENB em interior e menu)
    "https://sharemods.com/jvzzb61srlpb/Peugeot_206_GTI.7z.html" # [157] Peugeot 206 GTI (tunável)
    "https://sharemods.com/w955w0xtii2a/Clean_Render_-_Renderhook.7z.html" # [158] Clean Render (RenderHook)
    "https://sharemods.com/zprw8r1npn0f/Hangout_with_Story_Characters.7z.html" # [159] Hangout with Story Characters (recrutar personagens)
    "https://sharemods.com/1gegyekjbnht/Beta_Gang_Restore.7z.html" # [160] Beta Gang Restore (restaurar gangue beta)
    "https://sharemods.com/3mapd6624i7k/LCS_PlayIdles_to_SA.7z.html" # [161] LCS PlayIdles to SA
    "https://sharemods.com/nti33jp135j3/PCJ600_Remastered_HD.7z.html" # [162] PCJ600 Remastered HD
    "https://sharemods.com/8kbzd9j6ez1s/Arma_MAC-10.7z.html" # [163] Arma MAC-10 (lowpoly)
    "https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html" # [164] Big Gangster Mod (mais gangues)
    "https://sharemods.com/r17sebrganh9/Deluxo.7z.html" # [165] 86′ Deluxo (SA style)
    "https://sharemods.com/2hzskb32rm52/Chroma_Key.7z.html" # [166] Chroma Key Mod
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [167] Comet Plus+ (SA style)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 10/20 enviado para o navegador com sucesso!"
