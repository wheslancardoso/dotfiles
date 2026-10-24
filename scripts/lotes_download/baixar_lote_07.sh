#!/usr/bin/env bash
echo "=== ABRINDO LOTE 07 DE 18 NO BRAVE (Mods 91 a 105) ==="
URLS=(
    "https://www.mixmods.com.br/2021/12/cleo-redux/" # [91] CLEO Redux
    "https://sharemods.com/47465yc6kq12/Awesome_IFP.7z.html" # [92] [SA/SA:DE] Awesome IFP v3 (novas animações)
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
    "https://sharemods.com/1c6sk6faws7z/Clipboard_Teleport.7z.html" # [103] Clipboard Teleport (teletransporte com CTRL+V)
    "https://sharemods.com/txlr846ungla/Ragdoll_Bullet_Physics.zip.html" # [104] Mod Ragdoll Bullet Physics + Fix (física realista)
    "https://sharemods.com/98xo43wqfjlm/ImprovedMove.7z.html" # [105] [SA] ImprovedMove v0.2.2 (melhorar movimentos e anims)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"
