#!/usr/bin/env bash
# ==============================================================================
#  THE CREATION OF ADAM — NOKIA 3310 PIXEL ART GREETING
# ==============================================================================
#  Exibe a icônica cena de "A Criação de Adão" em pixel art no estilo clássico
#  monocromático do Nokia 3310 / LCD ao iniciar o terminal.
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ASSETS_DIR="$DOTFILES_DIR/assets/ascii"

# Fallback se diretório não existir
if [[ ! -d "$ASSETS_DIR" ]]; then
    ASSETS_DIR="$HOME/dotfiles/assets/ascii"
fi

show_help() {
    cat << EOF
Uso: adam-nokia [OPÇÃO]

Opções:
  --adam, -a      Exibe 'The Creation of Adam' (Michelangelo) em pixel art Nokia (Padrão)
  --nokia, -n     Exibe a clássica tela de boot do Nokia 3310 ('Connecting People')
  --lcd, -l       Exibe a versão com moldura e fundo verde LCD retrô
  --random, -r    Escolhe aleatoriamente entre as artes
  --help, -h      Mostra esta mensagem de ajuda

EOF
}

case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --nokia|-n|nokia|boot|3310)
        TARGET="$ASSETS_DIR/nokia-connecting.txt"
        ;;
    --lcd|-l|lcd)
        TARGET="$ASSETS_DIR/creation-of-adam-lcd.txt"
        ;;
    --random|-r|random)
        FILES=("$ASSETS_DIR/creation-of-adam.txt" "$ASSETS_DIR/nokia-connecting.txt" "$ASSETS_DIR/creation-of-adam-lcd.txt")
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
