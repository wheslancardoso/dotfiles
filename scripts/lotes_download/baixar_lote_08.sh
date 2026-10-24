#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 08 DE 17 NO BRAVE (Mods 106 a 120) ==="

URLS=(
    "https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html" # [122] NewOpcodes.cleo v2.1
    "https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html" # [123] [III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [124] MoonLoader
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [125] ModLoader support for MoonLoader (mods Lua no ModLoader)
    "https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html" # [126] VPJ – Vertex Paint Job (novas sombras e iluminação)
    "https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html" # [127] Skyscrapers Reflections (reflexos nos vidros dos prédios)
    "https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html" # [128] Dynamic FOV v1.1 (campo de visão dinâmico)
    "https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html" # [129] SIG Sauer P226R do Escape from Tarkov
    "https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html" # [130] [SA] Glowing Pickups v1.0.3 (weapon coronas)
    "https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html" # [131] Rhino Animated (tanque original animado)
    "https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html" # [132] Cutscene Weapons Fix (corrigir armas das cutscenes)
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [133] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [135] Handshake Mod (aperto de mão)
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [136] Gang Rider v2 (carregar mais gangue)
    "https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html" # [137] fastman92 processor v1.9 + GUI
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 08/17 enviado para o navegador com sucesso!"
