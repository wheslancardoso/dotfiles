#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 09 DE 20 NO BRAVE (Mods 121 a 135) ==="

URLS=(
    "https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html" # [137] VPJ – Vertex Paint Job (novas sombras e iluminação)
    "https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html" # [138] Skyscrapers Reflections (reflexos nos vidros dos prédios)
    "https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html" # [139] Dynamic FOV v1.1 (campo de visão dinâmico)
    "https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html" # [140] SIG Sauer P226R do Escape from Tarkov
    "https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html" # [141] [SA] Glowing Pickups v1.0.3 (weapon coronas)
    "https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html" # [142] Rhino Animated (tanque original animado)
    "https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html" # [143] Cutscene Weapons Fix (corrigir armas das cutscenes)
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [144] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [146] Handshake Mod (aperto de mão)
    "https://sharemods.com/shb6ml79ruhj/Stress_Test.7z.html" # [147] Stress Test (forçar jogo a crashar)
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [148] Gang Rider v2 (carregar mais gangue)
    "https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html" # [149] fastman92 processor v1.9 + GUI
    "https://drive.google.com/drive/folders/1gPYZm_H0i-h22r1TjSZCcKY8hiCEqI8t" # [150] GTA SA Comic Edition
    "https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing" # [151] Faithful Weapons Pack 2.0 (pack de armas fiéis)
    "https://sharemods.com/t0qrb187b7qr/Banshee_Plus.7z.html" # [152] Banshee Plus+ (SA style)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 09/20 enviado para o navegador com sucesso!"
