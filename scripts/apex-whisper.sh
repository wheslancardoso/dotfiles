#!/usr/bin/env bash
# ==============================================================================
# 🎙️ APEX WHISPER PIPELINE — TRANSCRIÇÃO EM LOTE INTELIGENTE & SEM DUPLICAÇÃO
# ==============================================================================
# GPU: NVIDIA GeForce RTX 5060 (CUDA Acelerado via Faster-Whisper)
# Lógica: Transcreve apenas arquivos novos/finalizados (ignora *.tmp e já transcritos)
# ==============================================================================

set -eo pipefail

VIDEO_DIR="${1:-$HOME/Downloads/AlgaWorks}"
OUT_DIR="$VIDEO_DIR/transcricoes"
TXT_DIR="$OUT_DIR/txt"
SRT_DIR="$OUT_DIR/srt"
PROGRESS_FILE="$OUT_DIR/.transcritos.log"

mkdir -p "$TXT_DIR" "$SRT_DIR"
touch "$PROGRESS_FILE"

echo -e "\033[1;36m============================================================\033[0m"
echo -e "\033[1;32m🎙️  INICIANDO PIPELINE DE TRANSCRIÇÃO APEX (GPU RTX 5060)\033[0m"
echo -e "\033[1;36m============================================================\033[0m"
echo "📂 Diretório dos Vídeos: $VIDEO_DIR"
echo "📝 Diretório de Textos:  $TXT_DIR"
echo "🎬 Diretório de Legendas:$SRT_DIR"
echo ""

VENV_DIR="$HOME/.local/share/apex-whisper-venv"
PYTHON_BIN="$VENV_DIR/bin/python"

# Exportar caminhos das bibliotecas CUDA da Nvidia
NVIDIA_BASE="$VENV_DIR/lib/python3.12/site-packages/nvidia"
export LD_LIBRARY_PATH="$NVIDIA_BASE/cublas/lib:$NVIDIA_BASE/cudnn/lib:$NVIDIA_BASE/cuda_nvrtc/lib:${LD_LIBRARY_PATH:-}"

cat << 'EOF' > /tmp/transcribe_worker.py
import sys
import os
from faster_whisper import WhisperModel

video_path = sys.argv[1]
txt_out = sys.argv[2]
srt_out = sys.argv[3]

# Carrega modelo na GPU RTX 5060
model = WhisperModel("small", device="cuda", compute_type="float16")

segments, info = model.transcribe(video_path, language="pt", beam_size=5)

with open(txt_out, "w", encoding="utf-8") as f_txt, open(srt_out, "w", encoding="utf-8") as f_srt:
    for i, seg in enumerate(segments, start=1):
        f_txt.write(seg.text.strip() + "\n")
        
        s_h, s_rem = divmod(seg.start, 3600)
        s_m, s_s = divmod(s_rem, 60)
        s_ms = int((s_s - int(s_s)) * 1000)
        
        e_h, e_rem = divmod(seg.end, 3600)
        e_m, e_s = divmod(e_rem, 60)
        e_ms = int((e_s - int(e_s)) * 1000)
        
        f_srt.write(f"{i}\n")
        f_srt.write(f"{int(s_h):02}:{int(s_m):02}:{int(s_s):02},{s_ms:03} --> {int(e_h):02}:{int(e_m):02}:{int(e_s):02},{e_ms:03}\n")
        f_srt.write(f"{seg.text.strip()}\n\n")

EOF

# Loop sobre todos os vídeos finalizados (ignora *.tmp)
find "$VIDEO_DIR" -maxdepth 1 -name "*.mp4" ! -name "*.tmp" | sort -V | while read -r video; do
    filename=$(basename "$video")
    base="${filename%.*}"
    
    txt_file="$TXT_DIR/${base}.txt"
    srt_file="$SRT_DIR/${base}.srt"
    
    # Checagem anti-duplicação:
    if grep -Fxq "$filename" "$PROGRESS_FILE" 2>/dev/null && [ -s "$txt_file" ]; then
        continue
    fi
    
    echo "⚡ [Transcrevendo]: $filename"
    if "$PYTHON_BIN" /tmp/transcribe_worker.py "$video" "$txt_file" "$srt_file"; then
        echo "$filename" >> "$PROGRESS_FILE"
        echo "✅ [Concluído]: $base (Removendo vídeo para poupar disco...)"
        rm -f "$video"
    else
        echo "❌ [Erro]: Falha ao transcrever $filename"
    fi
done

echo -e "\n\033[1;32m🎉 Lote de transcrições finalizado com sucesso!\033[0m"
