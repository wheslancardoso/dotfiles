#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 19 DE 19 NO BRAVE (Mods 271 a 282) ==="

URLS=(
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [291] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [293] More Locked Cars
    "https://sharemods.com/0gemwch5bivn/Alarm_Touching_Cars.7z.html" # [294] Alarm Touching Cars
    "https://www.mixmods.com.br/2019/04/swim-fps-fix-corrigir-nadar-com-fps-alto/" # [295] Swim FPS Fix
    "https://www.mixmods.com.br/2022/06/model-variations/" # [296] Model Variations
    "http://sharemods.com/f0n5080m9quu/Phoenix_Mode.7z.html" # [297] Phoenix Mode
    "https://sharemods.com/6m3go2b7lqbx/Robbery_Mod.7z.html" # [298] 24/7 Robbery
    "https://sharemods.com/ao53yl4oua80/SA_-_Random_Car_Talk.7z.html" # [299] Random Car Talk
    "https://sharemods.com/a2odu18dk7wn/Car_Dealership.7z.html" # [300] Car Dealership (Concessionárias Funcionais)
    "https://www.mixmods.com.br/2015/11/camping-mobile-save-house-20a-trailer-attach.html" # [301] Camping Mobile Save House 2.0a (Acampamento Selvagem & Sobrevivência)
    "https://sharemods.com/m4rshrky14dw/Car_Wash.7z.html" # [302] Car Wash v2.2
    "https://sharemods.com/lss6fpp1ujm5/Breakable_Vending_Machines.7z.html" # [303] Breakable Vending Machines
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 19/19 enviado para o navegador com sucesso!"
