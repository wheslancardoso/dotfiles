#!/usr/bin/env bash
# Script inteligente de extração e compactação para o Yazi
# Detecta automaticamente o formato do arquivo e usa a ferramenta adequada
set -euo pipefail

ACAO="${1:?"Uso: arquivo.sh <extrair|compactar> [arquivos...]"}"
shift

notificar() {
  local tipo="$1" msg="$2"
  if command -v notify-send &>/dev/null; then
    notify-send -a "Yazi" "$tipo" "$msg"
  fi
  echo "$tipo: $msg"
}

extrair() {
  for arquivo in "$@"; do
    [ -f "$arquivo" ] || { notificar "Erro" "Arquivo não encontrado: $arquivo"; continue; }

    local nome_base
    nome_base="$(basename "$arquivo")"
    local extensao_lower
    extensao_lower="$(echo "$nome_base" | tr '[:upper:]' '[:lower:]')"

    echo "━━━ Extraindo: $nome_base ━━━"

    case "$extensao_lower" in
      *.tar.gz|*.tgz)       tar -xvzf "$arquivo" ;;
      *.tar.bz2|*.tbz2)     tar -xvjf "$arquivo" ;;
      *.tar.xz|*.txz)       tar -xvJf "$arquivo" ;;
      *.tar.zst|*.tzst)     tar --zstd -xvf "$arquivo" ;;
      *.tar)                tar -xvf "$arquivo" ;;
      *.zip|*.cbz)          7z x "$arquivo" ;;
      *.rar|*.cbr)          unrar x "$arquivo" ;;
      *.7z)                 7z x "$arquivo" ;;
      *.gz)                 gunzip -k "$arquivo" ;;
      *.bz2)                bunzip2 -k "$arquivo" ;;
      *.xz)                 xz -dk "$arquivo" ;;
      *.zst)                zstd -dk "$arquivo" ;;
      *.iso)                7z x "$arquivo" ;;
      *.deb)                ar x "$arquivo" ;;
      *.rpm)                7z x "$arquivo" ;;
      *)
        echo "Formato desconhecido, tentando com 7z..."
        7z x "$arquivo"
        ;;
    esac

    notificar "Extração concluída" "$nome_base"
  done

  echo ""
  echo "━━━ Pressione ENTER para voltar ao Yazi ━━━"
  read -r
}

compactar() {
  if [ $# -eq 0 ]; then
    notificar "Erro" "Nenhum arquivo selecionado para compactar"
    return 1
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Selecione o formato de compactação:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  1) .zip      (mais compatível)"
  echo "  2) .tar.gz   (padrão Linux)"
  echo "  3) .tar.bz2  (melhor compressão)"
  echo "  4) .tar.xz   (excelente compressão)"
  echo "  5) .tar.zst  (rápido + boa compressão)"
  echo "  6) .7z       (máxima compressão)"
  echo "  0) Cancelar"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  printf "  Opção: "
  read -r opcao

  local nome_saida
  if [ $# -eq 1 ]; then
    nome_saida="$(basename "$1")"
  else
    nome_saida="arquivos_$(date +%Y%m%d_%H%M%S)"
  fi

  case "$opcao" in
    1)
      7z a "${nome_saida}.zip" "$@"
      notificar "Compactação concluída" "${nome_saida}.zip"
      ;;
    2)
      tar -czvf "${nome_saida}.tar.gz" "$@"
      notificar "Compactação concluída" "${nome_saida}.tar.gz"
      ;;
    3)
      tar -cjvf "${nome_saida}.tar.bz2" "$@"
      notificar "Compactação concluída" "${nome_saida}.tar.bz2"
      ;;
    4)
      tar -cJvf "${nome_saida}.tar.xz" "$@"
      notificar "Compactação concluída" "${nome_saida}.tar.xz"
      ;;
    5)
      tar --zstd -cvf "${nome_saida}.tar.zst" "$@"
      notificar "Compactação concluída" "${nome_saida}.tar.zst"
      ;;
    6)
      7z a "${nome_saida}.7z" "$@"
      notificar "Compactação concluída" "${nome_saida}.7z"
      ;;
    0)
      echo "Cancelado."
      return 0
      ;;
    *)
      notificar "Erro" "Opção inválida: $opcao"
      return 1
      ;;
  esac

  echo ""
  echo "━━━ Pressione ENTER para voltar ao Yazi ━━━"
  read -r
}

case "$ACAO" in
  extrair)    extrair "$@" ;;
  compactar)  compactar "$@" ;;
  *)
    echo "Uso: arquivo.sh <extrair|compactar> [arquivos...]"
    exit 1
    ;;
esac
