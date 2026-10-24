#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 07 DE 07 NO BRAVE (Mods 73 a 78) ==="

URLS=(
    "https://sharemods.com/6m3go2b7lqbx/Robbery_Mod.7z.html" # [88] 24/7 Robbery
    "https://sharemods.com/ao53yl4oua80/SA_-_Random_Car_Talk.7z.html" # [89] Random Car Talk
    "https://sharemods.com/a2odu18dk7wn/Car_Dealership.7z.html" # [90] Car Dealership (Concessionárias Funcionais)
    "https://www.mixmods.com.br/2015/11/camping-mobile-save-house-20a-trailer-attach.html" # [91] Camping Mobile Save House 2.0a (Acampamento Selvagem & Sobrevivência)
    "https://sharemods.com/m4rshrky14dw/Car_Wash.7z.html" # [92] Car Wash v2.2
    "https://sharemods.com/lss6fpp1ujm5/Breakable_Vending_Machines.7z.html" # [93] Breakable Vending Machines
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 07/07 aberto no Brave com sucesso!"
