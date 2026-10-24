#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 17 DE 17 NO BRAVE (Mods 241 a 244) ==="

URLS=(
    "https://sharemods.com/a2odu18dk7wn/Car_Dealership.7z.html" # [262] Car Dealership (Concessionárias Funcionais)
    "https://www.mixmods.com.br/2015/11/camping-mobile-save-house-20a-trailer-attach.html" # [263] Camping Mobile Save House 2.0a (Acampamento Selvagem & Sobrevivência)
    "https://sharemods.com/m4rshrky14dw/Car_Wash.7z.html" # [264] Car Wash v2.2
    "https://sharemods.com/lss6fpp1ujm5/Breakable_Vending_Machines.7z.html" # [265] Breakable Vending Machines
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 17/17 enviado para o navegador com sucesso!"
