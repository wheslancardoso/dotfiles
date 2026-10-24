#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 05 DE 07 NO BRAVE (Mods 49 a 60) ==="

URLS=(
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [57] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [60] Smooth Criminal Bicycles
    "https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html" # [61] Custom Ammunation Mod v3.5
    "https://www.mixmods.com.br/2026/06/soundize" # [62] Soundize (AAA Audio System - 06/2026)
    "https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing" # [64] Faithful Weapons Pack 2.0
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [65] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [66] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://sharemods.com/tysasyrhqebt/nadalao_Weapon_Icons_-_icones_fieis_corrigidos.7z.html" # [67] nadalao Weapon Icons (Ícones HD Fiéis Corrigidos)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [68] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [69] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [70] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [71] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 05/07 aberto no Brave com sucesso!"
