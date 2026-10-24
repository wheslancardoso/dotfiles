#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 09 DE 17 NO BRAVE (Mods 121 a 135) ==="

URLS=(
    "https://sharemods.com/t1oa3uuqyl8p/Beta_Gang_Skins_Added.7z.html" # [138] Beta Gang Skins Added (restaurar gangue beta)
    "https://sharemods.com/04ywd5k9r0ps/Revamped_Arsenal.7z.html" # [139] Revamped Arsenal (armas originais melhoradas)
    "https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html" # [140] NewOpcodes.cleo v2.1
    "https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html" # [141] [III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [142] MoonLoader
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [143] ModLoader support for MoonLoader (mods Lua no ModLoader)
    "https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html" # [144] VPJ – Vertex Paint Job (novas sombras e iluminação)
    "https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html" # [145] Skyscrapers Reflections (reflexos nos vidros dos prédios)
    "https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html" # [146] Dynamic FOV v1.1 (campo de visão dinâmico)
    "https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html" # [147] SIG Sauer P226R do Escape from Tarkov
    "https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html" # [148] [SA] Glowing Pickups v1.0.3 (weapon coronas)
    "https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html" # [149] Rhino Animated (tanque original animado)
    "https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html" # [150] Cutscene Weapons Fix (corrigir armas das cutscenes)
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [151] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [153] Handshake Mod (aperto de mão)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 09/17 enviado para o navegador com sucesso!"
