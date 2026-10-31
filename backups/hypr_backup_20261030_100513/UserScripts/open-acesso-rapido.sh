#!/usr/bin/env bash
# 📂 Abre o Yazi flutuante centralizado direto no Acesso Rápido de Documentos (CNH, RG, Comprovantes)

TARGET=""
POSSIBLE_DIRS=(
    "$HOME/documents/01.1_Identidade_e_Documentos/01_Acesso_Rapido_Dia_a_Dia"
    "/mnt/dados/01_Pessoal_e_Vida/01.1_Identidade_e_Documentos/01_Acesso_Rapido_Dia_a_Dia"
    "$HOME/drive-organizacao/01_Pessoal_e_Vida/01.1_Identidade_e_Documentos/01_Acesso_Rapido_Dia_a_Dia"
    "$HOME/documents/01.1_Identidade_e_Documentos"
    "$HOME/documents"
)

for d in "${POSSIBLE_DIRS[@]}"; do
    if [ -d "$d" ]; then
        TARGET="$d"
        break
    fi
done

if [ -z "$TARGET" ]; then
    TARGET="$HOME"
fi

exec "$HOME/.config/hypr/UserScripts/open-yazi.sh" "$TARGET"
