#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 06 DE 17 NO BRAVE (Mods 76 a 90) ==="

URLS=(
    "https://sharemods.com/l01yekk929dh/MW_Project.7z.html" # [86] MW Project (mais água por SA)
    "https://sharemods.com/c08l1q6s8kxy/SA_SADE_-_Peds_Run_Fix.7z.html" # [88] [SA/SA:DE] Ped Run Fix v2.2 (corrigir velhinhas correndo)
    "https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html" # [89] Custom Ammunation Mod v3.5 (adicionar armas pra comprar)
    "https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html" # [90] LOD Vegetation v1.2 (árvores distantes)
    "https://www.mixmods.com.br/2021/12/cleo-redux/" # [91] CLEO Redux
    "https://sharemods.com/s13yawvkfnwn/SADE_MP5.7z.html" # [93] MP5 (convertida do SA:DE)
    "https://sharemods.com/i8pyupgkl3ia/Tesla_Model_S_2014.7z.html" # [94] Tesla Model S 2014 (fix + script)
    "https://sharemods.com/uelr5g9m1eff/Illuminated_Vinewood_Sign.7z.html" # [95] Illuminated Vinewood Sign (placa de Vinewood iluminada)
    "https://sharemods.com/z2uh6naoyg1i/Pre-lighting_Fixes_Pack.7z.html" # [96] Pre-lighting Fixes Pack (correções de iluminação)
    "https://sharemods.com/4s905tmgiphk/Upgraded_Vehicles_Pack.7z.html" # [97] Upgraded Vehicles Pack (carros originais corrigidos)
    "https://sharemods.com/dgcbm6ixj1pl/RenderHookFix.7z.html" # [98] RenderHook Fix (correções para o RH)
    "https://sharemods.com/q2pnidt84vet/GTA_Healer.7z.html" # [99] GTA Healer (check & backup)
    "https://sharemods.com/y6emrqj5rvbo/RenderHook_-_Serendipity.7z.html" # [100] RenderHook – Serendipity v1.1 (gráficos remasterizados em HD)
    "https://sharemods.com/2m9bwht7zw96/Effects_Mod_-_by_Ezekiel_-_Junior_Djjr.7z.html" # [101] [SA] Effects Mod by Ezekiel / Junior_Djjr (efeitos realistas)
    "https://sharemods.com/cz2vbf9kc9a2/ENB_Series_CloudWorks.7z.html" # [102] CloudWorks (volumetric clouds for ENB/RenderHook)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 06/17 enviado para o navegador com sucesso!"
