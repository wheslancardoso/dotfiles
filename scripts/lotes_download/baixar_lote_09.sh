#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 09 DE 20 NO BRAVE (Mods 121 a 135) ==="

URLS=(
    "https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html" # [137] [III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [138] MoonLoader
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [139] ModLoader support for MoonLoader (mods Lua no ModLoader)
    "https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html" # [140] VPJ – Vertex Paint Job (novas sombras e iluminação)
    "https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html" # [141] Skyscrapers Reflections (reflexos nos vidros dos prédios)
    "https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html" # [142] Dynamic FOV v1.1 (campo de visão dinâmico)
    "https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html" # [143] SIG Sauer P226R do Escape from Tarkov
    "https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html" # [144] [SA] Glowing Pickups v1.0.3 (weapon coronas)
    "https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html" # [145] Rhino Animated (tanque original animado)
    "https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html" # [146] Cutscene Weapons Fix (corrigir armas das cutscenes)
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [147] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [149] Handshake Mod (aperto de mão)
    "https://sharemods.com/shb6ml79ruhj/Stress_Test.7z.html" # [150] Stress Test (forçar jogo a crashar)
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [151] Gang Rider v2 (carregar mais gangue)
    "https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html" # [152] fastman92 processor v1.9 + GUI
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 09/20 enviado para o navegador com sucesso!"
