#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 16 NO BRAVE (Mods 226 a 228) ==="

URLS=(
    "https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing" # [244] Novos Ballas em HD
    "https://www.mixmods.com.br/2011/10/nova-grove-v2/" # [245] Nova Grove v2
    "https://www.mixmods.com.br/2011/05/nova-groove-v1/" # [246] NOVA GROOVE V1
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/16 enviado para o navegador com sucesso!"
