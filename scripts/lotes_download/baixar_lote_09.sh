#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 09 DE 19 NO BRAVE (Mods 121 a 135) ==="

URLS=(
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [137] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [139] Handshake Mod (aperto de mão)
    "https://sharemods.com/shb6ml79ruhj/Stress_Test.7z.html" # [140] Stress Test (forçar jogo a crashar)
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [141] Gang Rider v2 (carregar mais gangue)
    "https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html" # [142] fastman92 processor v1.9 + GUI
    "https://drive.google.com/drive/folders/1gPYZm_H0i-h22r1TjSZCcKY8hiCEqI8t" # [143] GTA SA Comic Edition
    "https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing" # [144] Faithful Weapons Pack 2.0 (pack de armas fiéis)
    "https://sharemods.com/t0qrb187b7qr/Banshee_Plus.7z.html" # [145] Banshee Plus+ (SA style)
    "https://sharemods.com/jm60r1j8pr72/Euryopa.7z.html" # [146] Euryopa (visualizador de mapa para GTA)
    "https://sharemods.com/ywqqzuky007z/Futo_Trueno_Levin.7z.html" # [147] Futo Trueno + Levin (AE86 SA style)
    "https://sharemods.com/s8bmfqkshpzo/90s_Atmosphere_Weapons_Pack_Reborn.7z.html" # [148] 90s AWP – 90s Atmosphere Weapons Pack Reborn 4.0
    "https://sharemods.com/jvzzb61srlpb/Peugeot_206_GTI.7z.html" # [149] Peugeot 206 GTI (tunável)
    "https://sharemods.com/w955w0xtii2a/Clean_Render_-_Renderhook.7z.html" # [150] Clean Render (RenderHook)
    "https://sharemods.com/zprw8r1npn0f/Hangout_with_Story_Characters.7z.html" # [151] Hangout with Story Characters (recrutar personagens)
    "https://sharemods.com/1gegyekjbnht/Beta_Gang_Restore.7z.html" # [152] Beta Gang Restore (restaurar gangue beta)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 09/19 enviado para o navegador com sucesso!"
