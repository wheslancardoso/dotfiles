#!/usr/bin/env bash
# 🎥 Screen Recording Toggle (GIF/MP4) para Hyprland
# Atalho: SUPER + SHIFT + R (ou SUPER + ALT + R)
# Suporta aceleração de GPU e áudio, salvando em ~/videos/recordings

set -e

VIDEOS_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/videos")"
[ -d "$VIDEOS_DIR" ] || VIDEOS_DIR="$HOME/Videos"
[ -d "$VIDEOS_DIR" ] || VIDEOS_DIR="$HOME/videos"
RECORDINGS_DIR="$VIDEOS_DIR/recordings"
mkdir -p "$RECORDINGS_DIR"

PID_FILE="/tmp/screen-record.pid"
LOG_FILE="/tmp/screen-record.log"

notify_cmd="notify-send -t 6000 -h string:x-canonical-private-synchronous:screen-record"

# 1. Se já estiver gravando, parar a gravação
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    PID=$(cat "$PID_FILE")
    kill -INT "$PID" 2>/dev/null || true
    rm -f "$PID_FILE"

    # Aguardar gravação do container MP4
    sleep 0.8

    # Pegar o último arquivo gravado
    LAST_VIDEO=$(ls -t "$RECORDINGS_DIR"/*.mp4 2>/dev/null | head -n1 || true)

    if [ -n "$LAST_VIDEO" ] && [ -f "$LAST_VIDEO" ]; then
        # Copiar caminho para o clipboard (wl-copy)
        if command -v wl-copy &>/dev/null; then
            wl-copy "$LAST_VIDEO" || true
        fi

        # Notificar com opções
        RESP=$(notify-send -t 8000 \
            -i video-x-generic \
            -A "open=Abrir Vídeo" \
            -A "folder=Abrir Pasta" \
            "🎬 Gravação Concluída!" \
            "Salvo em: $(basename "$LAST_VIDEO")\n(Caminho copiado para o clipboard)")

        case "$RESP" in
            open)
                xdg-open "$LAST_VIDEO" &
                ;;
            folder)
                xdg-open "$RECORDINGS_DIR" &
                ;;
        esac
    else
        $notify_cmd -i dialog-information "Gravação Encerrada" "Nenhum arquivo gravado."
    fi
    exit 0
fi

# 2. Se não estiver gravando, iniciar nova gravação
# Selecionar área da tela com slurp
if ! command -v slurp &>/dev/null; then
    $notify_cmd -u critical "Erro" "slurp não encontrado para selecionar a tela."
    exit 1
fi

GEOMETRY=$(slurp -b 00000088 -c 89b4fa -w 2 2>/dev/null || true)
if [ -z "$GEOMETRY" ]; then
    # Usuário cancelou ou pressionou Escape
    exit 0
fi

TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$RECORDINGS_DIR/Recording_${TIMESTAMP}.mp4"

# 3. Detectar gravador disponível (wf-recorder ou gpu-screen-recorder)
RECORDER_CMD=""
if command -v wf-recorder &>/dev/null; then
    # Verificar se temos áudio pipewire disponível
    AUDIO_ARG=""
    if pactl info &>/dev/null; then
        AUDIO_ARG="--audio"
    fi
    wf-recorder -g "$GEOMETRY" -f "$OUTPUT_FILE" $AUDIO_ARG --pixel-format yuv420p > "$LOG_FILE" 2>&1 &
    REC_PID=$!
elif command -v gpu-screen-recorder &>/dev/null; then
    # Formato do geometry para gpu-screen-recorder: WxH+X+Y
    gpu-screen-recorder -w screen -s "$GEOMETRY" -f 60 -o "$OUTPUT_FILE" > "$LOG_FILE" 2>&1 &
    REC_PID=$!
else
    $notify_cmd -u critical "Erro" "Nenhum gravador de tela encontrado (instale wf-recorder)."
    exit 1
fi

echo "$REC_PID" > "$PID_FILE"

$notify_cmd -u normal -i media-record \
    "🔴 Gravando Área Selecionada..." \
    "Pressione SUPER+SHIFT+R para parar e salvar."
