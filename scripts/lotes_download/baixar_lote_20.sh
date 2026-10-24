#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 20 DE 20 NO BRAVE (Mods 286 a 291) ==="

URLS=(
    "https://sharemods.com/6m3go2b7lqbx/Robbery_Mod.7z.html" # [307] 24/7 Robbery
    "https://sharemods.com/ao53yl4oua80/SA_-_Random_Car_Talk.7z.html" # [308] Random Car Talk
    "https://sharemods.com/a2odu18dk7wn/Car_Dealership.7z.html" # [309] Car Dealership (Concessionárias Funcionais)
    "https://www.mixmods.com.br/2015/11/camping-mobile-save-house-20a-trailer-attach.html" # [310] Camping Mobile Save House 2.0a (Acampamento Selvagem & Sobrevivência)
    "https://sharemods.com/m4rshrky14dw/Car_Wash.7z.html" # [311] Car Wash v2.2
    "https://sharemods.com/lss6fpp1ujm5/Breakable_Vending_Machines.7z.html" # [312] Breakable Vending Machines
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 20/20 enviado para o navegador com sucesso!"
