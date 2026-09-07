#!/usr/bin/env bash
# ==============================================================================
# ⚡ RSYNC TURBO — Transferências Ultra-Rápidas com Retomada Automática
# ==============================================================================
# Executa rsync com:
#   -a: preserva datas, permissões, links simbólicos e integridade
#   -h: tamanhos legíveis (MB/GB)
#   -P: progresso e retomada de arquivos parciais interrompidos (--partial)
#   --inplace: gravação linear direta no destino (sem .tmp intermediário)
#   --info=progress2: barra de progresso única e global do lote
# ==============================================================================

set -e

if [ $# -eq 0 ]; then
    echo "Uso: rsync-turbo <origem...> <destino>"
    echo "Exemplo: rsync-turbo /mnt/dados/pasta /run/media/$USER/pendrive/"
    exit 1
fi

exec rsync -ahP --inplace --info=progress2 "$@"
