#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 19 DE 20 NO BRAVE (Mods 271 a 285) ==="

URLS=(
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [291] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [292] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [293] More Radar Icons v2.0
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [294] Improved Surface Physics (Superfícies com Física Aprimorada)
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [295] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [296] Smooth Criminal Bicycles
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [297] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [298] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [299] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [300] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [301] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [302] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [303] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [305] More Locked Cars
    "https://sharemods.com/0gemwch5bivn/Alarm_Touching_Cars.7z.html" # [306] Alarm Touching Cars
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 19/20 enviado para o navegador com sucesso!"
