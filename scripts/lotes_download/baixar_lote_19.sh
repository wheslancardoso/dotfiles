#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 19 DE 20 NO BRAVE (Mods 271 a 285) ==="

URLS=(
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [291] Improved Surface Physics (Superfícies com Física Aprimorada)
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [292] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [293] Smooth Criminal Bicycles
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [294] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [295] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [296] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [297] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [298] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [299] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [300] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [302] More Locked Cars
    "https://sharemods.com/0gemwch5bivn/Alarm_Touching_Cars.7z.html" # [303] Alarm Touching Cars
    "https://www.mixmods.com.br/2019/04/swim-fps-fix-corrigir-nadar-com-fps-alto/" # [304] Swim FPS Fix
    "https://www.mixmods.com.br/2022/06/model-variations/" # [305] Model Variations
    "http://sharemods.com/f0n5080m9quu/Phoenix_Mode.7z.html" # [306] Phoenix Mode
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 19/20 enviado para o navegador com sucesso!"
