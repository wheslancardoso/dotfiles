#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 06 DE 20 NO BRAVE (Mods 76 a 90) ==="

URLS=(
    "https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html" # [86] LOD Vegetation v1.2 (árvores distantes)
    "https://www.mixmods.com.br/2021/12/cleo-redux/" # [87] CLEO Redux
    "https://sharemods.com/s13yawvkfnwn/SADE_MP5.7z.html" # [89] MP5 (convertida do SA:DE)
    "https://sharemods.com/i8pyupgkl3ia/Tesla_Model_S_2014.7z.html" # [90] Tesla Model S 2014 (fix + script)
    "https://sharemods.com/uelr5g9m1eff/Illuminated_Vinewood_Sign.7z.html" # [91] Illuminated Vinewood Sign (placa de Vinewood iluminada)
    "https://sharemods.com/z2uh6naoyg1i/Pre-lighting_Fixes_Pack.7z.html" # [92] Pre-lighting Fixes Pack (correções de iluminação)
    "https://sharemods.com/4s905tmgiphk/Upgraded_Vehicles_Pack.7z.html" # [93] Upgraded Vehicles Pack (carros originais corrigidos)
    "https://sharemods.com/dgcbm6ixj1pl/RenderHookFix.7z.html" # [94] RenderHook Fix (correções para o RH)
    "https://sharemods.com/q2pnidt84vet/GTA_Healer.7z.html" # [95] GTA Healer (check & backup)
    "https://sharemods.com/y6emrqj5rvbo/RenderHook_-_Serendipity.7z.html" # [96] RenderHook – Serendipity v1.1 (gráficos remasterizados em HD)
    "https://sharemods.com/2m9bwht7zw96/Effects_Mod_-_by_Ezekiel_-_Junior_Djjr.7z.html" # [97] [SA] Effects Mod by Ezekiel / Junior_Djjr (efeitos realistas)
    "https://sharemods.com/cz2vbf9kc9a2/ENB_Series_CloudWorks.7z.html" # [98] CloudWorks (volumetric clouds for ENB/RenderHook)
    "https://sharemods.com/1c6sk6faws7z/Clipboard_Teleport.7z.html" # [99] Clipboard Teleport (teletransporte com CTRL+V)
    "https://sharemods.com/98xo43wqfjlm/ImprovedMove.7z.html" # [101] [SA] ImprovedMove v0.2.2 (melhorar movimentos e anims)
    "https://sharemods.com/6ljnksq0hmrq/FireType.7z.html" # [102] FireType v6.0 (tiro seletivo: auto, semi, burst)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 06/20 enviado para o navegador com sucesso!"
