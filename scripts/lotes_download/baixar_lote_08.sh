#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 08 DE 16 NO BRAVE (Mods 106 a 120) ==="

URLS=(
    "https://sharemods.com/z7cnx7ur9s5n/San_Andreas_Farming_Equipment_DLC.7z.html" # [122] San Andreas Farming Equipment DLC (SAFE DLC) (trator HD)
    "https://sharemods.com/kgi120yjoqgc/Vehicle_Shared_HD_Wheels.7z.html" # [124] Vehicle Shared HD Wheels (carros com rodas HD)
    "https://sharemods.com/t1oa3uuqyl8p/Beta_Gang_Skins_Added.7z.html" # [125] Beta Gang Skins Added (restaurar gangue beta)
    "https://sharemods.com/04ywd5k9r0ps/Revamped_Arsenal.7z.html" # [126] Revamped Arsenal (armas originais melhoradas)
    "https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html" # [127] NewOpcodes.cleo v2.1
    "https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html" # [128] [III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [129] MoonLoader
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [130] ModLoader support for MoonLoader (mods Lua no ModLoader)
    "https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html" # [131] VPJ – Vertex Paint Job (novas sombras e iluminação)
    "https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html" # [132] Skyscrapers Reflections (reflexos nos vidros dos prédios)
    "https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html" # [133] Dynamic FOV v1.1 (campo de visão dinâmico)
    "https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html" # [134] SIG Sauer P226R do Escape from Tarkov
    "https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html" # [135] [SA] Glowing Pickups v1.0.3 (weapon coronas)
    "https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html" # [136] Rhino Animated (tanque original animado)
    "https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html" # [137] Cutscene Weapons Fix (corrigir armas das cutscenes)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 08/16 enviado para o navegador com sucesso!"
