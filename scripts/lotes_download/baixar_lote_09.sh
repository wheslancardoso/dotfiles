#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 09 DE 17 NO BRAVE (Mods 121 a 135) ==="

URLS=(
    "https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing" # [138] Faithful Weapons Pack 2.0 (pack de armas fiéis)
    "https://sharemods.com/t0qrb187b7qr/Banshee_Plus.7z.html" # [139] Banshee Plus+ (SA style)
    "https://sharemods.com/ywqqzuky007z/Futo_Trueno_Levin.7z.html" # [140] Futo Trueno + Levin (AE86 SA style)
    "https://sharemods.com/s8bmfqkshpzo/90s_Atmosphere_Weapons_Pack_Reborn.7z.html" # [141] 90s AWP – 90s Atmosphere Weapons Pack Reborn 4.0
    "https://sharemods.com/zprw8r1npn0f/Hangout_with_Story_Characters.7z.html" # [142] Hangout with Story Characters (recrutar personagens)
    "https://sharemods.com/1gegyekjbnht/Beta_Gang_Restore.7z.html" # [143] Beta Gang Restore (restaurar gangue beta)
    "https://sharemods.com/3mapd6624i7k/LCS_PlayIdles_to_SA.7z.html" # [144] LCS PlayIdles to SA
    "https://sharemods.com/nti33jp135j3/PCJ600_Remastered_HD.7z.html" # [145] PCJ600 Remastered HD
    "https://sharemods.com/8kbzd9j6ez1s/Arma_MAC-10.7z.html" # [146] Arma MAC-10 (lowpoly)
    "https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html" # [147] Big Gangster Mod (mais gangues)
    "https://sharemods.com/r17sebrganh9/Deluxo.7z.html" # [148] 86′ Deluxo (SA style)
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [149] Comet Plus+ (SA style)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [150] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [151] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [152] Wayfarer Plus+ (sa style)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 09/17 enviado para o navegador com sucesso!"
