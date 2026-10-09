#!/usr/bin/env bash
# ==============================================================================
#  THE CREATION OF ADAM — MASTER ASCII / NOKIA PIXEL ART GREETING
# ==============================================================================
#  Exibe a obra-prima 'A Criação de Adão' de Michelangelo em alta fidelidade
#  ASCII art com gradiente tonal retrô estilo Nokia 3310 ao iniciar o terminal.
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ASSETS_DIR="$DOTFILES_DIR/assets/ascii"

if [[ ! -d "$ASSETS_DIR" ]]; then
    ASSETS_DIR="$HOME/dotfiles/assets/ascii"
fi

show_help() {
    cat << EOF
Uso: adam-nokia [OPÇÃO]

Opções:
  --adam, -a      The Creation of Adam em ASCII de alta fidelidade (Verde Nokia 3310) [Padrão]
  --mint, -m      The Creation of Adam em paleta Catppuccin Mint / Teal
  --mono          The Creation of Adam em escala monocromática (Branco/Cinza clássico)
  --nokia, -n     Boot screen autêntico do Nokia 3310 ('Connecting People')
  --lcd, -l       Versão moldura completa de tela LCD verde
  --random, -r    Escolhe aleatoriamente entre as artes
  --help, -h      Mostra esta mensagem de ajuda

EOF
}

case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --mint|-m|mint)
        TARGET="$ASSETS_DIR/creation-of-adam-mint.txt"
        ;;
    --mono|mono|white|gray)
        TARGET="$ASSETS_DIR/creation-of-adam-mono.txt"
        ;;
    --nokia|-n|nokia|boot|3310)
        TARGET="$ASSETS_DIR/nokia-connecting.txt"
        ;;
    --lcd|-l|lcd)
        TARGET="$ASSETS_DIR/creation-of-adam-lcd.txt"
        ;;
    --random|-r|random)
        FILES=("$ASSETS_DIR/creation-of-adam.txt" "$ASSETS_DIR/creation-of-adam-mint.txt" "$ASSETS_DIR/creation-of-adam-mono.txt" "$ASSETS_DIR/nokia-connecting.txt")
        TARGET="${FILES[$RANDOM % ${#FILES[@]}]}"
        ;;
    --adam|-a|adam|*)
        TARGET="$ASSETS_DIR/creation-of-adam.txt"
        ;;
esac

if [[ -f "$TARGET" ]]; then
    echo ""
    cat "$TARGET"
    echo ""
else
    echo "Erro: Arquivo de arte não encontrado em $TARGET" >&2
    exit 1
fi
