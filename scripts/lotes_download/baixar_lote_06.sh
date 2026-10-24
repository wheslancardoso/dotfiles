#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 06 DE 16 NO BRAVE (Mods 76 a 90) ==="

URLS=(
    "https://sharemods.com/z2uh6naoyg1i/Pre-lighting_Fixes_Pack.7z.html" # [88] Pre-lighting Fixes Pack (correções de iluminação)
    "https://sharemods.com/4s905tmgiphk/Upgraded_Vehicles_Pack.7z.html" # [89] Upgraded Vehicles Pack (carros originais corrigidos)
    "https://sharemods.com/dgcbm6ixj1pl/RenderHookFix.7z.html" # [90] RenderHook Fix (correções para o RH)
    "https://sharemods.com/q2pnidt84vet/GTA_Healer.7z.html" # [91] GTA Healer (check & backup)
    "https://sharemods.com/y6emrqj5rvbo/RenderHook_-_Serendipity.7z.html" # [92] RenderHook – Serendipity v1.1 (gráficos remasterizados em HD)
    "https://sharemods.com/2m9bwht7zw96/Effects_Mod_-_by_Ezekiel_-_Junior_Djjr.7z.html" # [93] [SA] Effects Mod by Ezekiel / Junior_Djjr (efeitos realistas)
    "https://sharemods.com/cz2vbf9kc9a2/ENB_Series_CloudWorks.7z.html" # [94] CloudWorks (volumetric clouds for ENB/RenderHook)
    "https://sharemods.com/1c6sk6faws7z/Clipboard_Teleport.7z.html" # [95] Clipboard Teleport (teletransporte com CTRL+V)
    "https://sharemods.com/98xo43wqfjlm/ImprovedMove.7z.html" # [97] [SA] ImprovedMove v0.2.2 (melhorar movimentos e anims)
    "https://sharemods.com/6ljnksq0hmrq/FireType.7z.html" # [98] FireType v6.0 (tiro seletivo: auto, semi, burst)
    "https://drive.google.com/file/d/1KcMiIBNyF7Z-hND1f8G4K3aRUzg6A7se/view?usp=sharing" # [99] Mipmapping
    "https://sharemods.com/qipof5weizvy/Generate_Free_IDs_List.7z.html" # [100] Generate Free IDs List (mostrar IDs vazios)
    "https://sharemods.com/v4buqzhgmour/IMBEL_IA2_FN_FAL.7z.html" # [101] IMBEL IA2 & FN FAL (armas brasileiras em HD)
    "https://sharemods.com/xiqp6ec07z44/Taurus_24_7_PT_58.7z.html" # [102] Pistolas Taurus 24/7 e PT 58 (lowpoly)
    "https://sharemods.com/zh4lmnw9s3m4/Proper_Weapon_Retex.7z.html" # [103] Proper Weapons Retex v1.3 (armas com texturas HD)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 06/16 enviado para o navegador com sucesso!"
