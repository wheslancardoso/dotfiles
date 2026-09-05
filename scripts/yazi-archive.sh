#!/usr/bin/env bash
# ==============================================================================
# 📦 YAZI ARCHIVE HELPER — Compressão e Extração Universal de Alta Velocidade
# ==============================================================================
# Suporta: .zip, .7z, .rar, .tar, .tar.gz, .tar.xz, .tar.zst, .tar.bz2, .apk, .iso
# Fallbacks: 7z -> tar/unzip -> Python3 nativo (zero falhas)
# ==============================================================================

set -euo pipefail

ACTION="${1:-}"
shift || true

if [ -z "$ACTION" ] || [ $# -eq 0 ]; then
    echo "Uso: $0 {extract-here|extract-sub|compress-zip|compress-7z|compress-tar} <arquivos...>"
    exit 1
fi

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Yazi" -i "package-x-generic" "$title" "$msg" 2>/dev/null || true
    fi
}

extract_single() {
    local file="$1"
    local outdir="$2"

    mkdir -p "$outdir"
    local filename="$(basename "$file")"
    local lower_name="$(echo "$filename" | tr '[:upper:]' '[:lower:]')"

    # 1. Tenta 7z se disponível (suporta quase tudo)
    if command -v 7z &>/dev/null; then
        7z x -y "-o$outdir" "$file" >/dev/null
        return 0
    fi

    # 2. Fallbacks específicos por formato
    if [[ "$lower_name" =~ \.zip$|\.apk$|\.jar$|\.xapk$ ]]; then
        if command -v unzip &>/dev/null; then
            unzip -q -o "$file" -d "$outdir"
        else
            python3 -m zipfile -e "$file" "$outdir"
        fi
    elif [[ "$lower_name" =~ \.tar\.gz$|\.tgz$ ]]; then
        tar -xzf "$file" -C "$outdir"
    elif [[ "$lower_name" =~ \.tar\.xz$|\.txz$ ]]; then
        tar -xJf "$file" -C "$outdir"
    elif [[ "$lower_name" =~ \.tar\.zst$ ]]; then
        tar --zstd -xf "$file" -C "$outdir"
    elif [[ "$lower_name" =~ \.tar\.bz2$|\.tbz2$ ]]; then
        tar -xjf "$file" -C "$outdir"
    elif [[ "$lower_name" =~ \.tar$ ]]; then
        tar -xf "$file" -C "$outdir"
    elif [[ "$lower_name" =~ \.rar$ ]]; then
        if command -v unrar &>/dev/null; then
            unrar x -o+ -inul "$file" "$outdir/"
        else
            echo "Erro: Instale '7zip' ou 'unrar' para descompactar arquivos .rar"
            return 1
        fi
    else
        # Fallback genérico Python se for zip
        python3 -c "import zipfile, sys; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" "$file" "$outdir" 2>/dev/null || {
            echo "Formato não suportado sem 7zip instalado: $file"
            return 1
        }
    fi
}

case "$ACTION" in
    extract-here)
        for f in "$@"; do
            if [ -f "$f" ]; then
                target_dir="$(dirname "$f")"
                extract_single "$f" "$target_dir"
                notify "Extração Concluída" "$(basename "$f") extraído aqui"
            fi
        done
        ;;

    extract-sub)
        for f in "$@"; do
            if [ -f "$f" ]; then
                base_name="$(basename "$f")"
                # Remove extensão (.tar.gz, .zip, etc.)
                sub_name="${base_name%.*}"
                if [[ "$base_name" =~ \.tar\.[a-zA-Z0-9]+$ ]]; then
                    sub_name="${base_name%.*.*}"
                fi
                target_dir="$(dirname "$f")/$sub_name"
                extract_single "$f" "$target_dir"
                notify "Extração Concluída" "$(basename "$f") extraído em /$sub_name"
            fi
        done
        ;;

    compress-zip)
        first_item="$1"
        parent_dir="$(dirname "$first_item")"
        if [ $# -eq 1 ]; then
            base_name="$(basename "$first_item")"
            clean_name="${base_name%.*}"
            out_zip="${parent_dir}/${clean_name}.zip"
        else
            out_zip="${parent_dir}/arquivo_$(date +%Y%m%d_%H%M%S).zip"
        fi

        if command -v 7z &>/dev/null; then
            7z a -tzip -mx=7 "$out_zip" "$@" >/dev/null
        elif command -v zip &>/dev/null; then
            zip -r -q "$out_zip" "$@"
        else
            python3 -c "
import zipfile, os, sys
out = sys.argv[1]
items = sys.argv[2:]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for item in items:
        if os.path.isdir(item):
            for root, dirs, files in os.walk(item):
                for file in files:
                    full = os.path.join(root, file)
                    rel = os.path.relpath(full, os.path.dirname(item))
                    z.write(full, rel)
        else:
            z.write(item, os.path.basename(item))
" "$out_zip" "$@"
        fi
        notify "Compactação Concluída" "Criado: $(basename "$out_zip")"
        ;;

    compress-7z)
        first_item="$1"
        parent_dir="$(dirname "$first_item")"
        if [ $# -eq 1 ]; then
            base_name="$(basename "$first_item")"
            clean_name="${base_name%.*}"
            out_7z="${parent_dir}/${clean_name}.7z"
        else
            out_7z="${parent_dir}/arquivo_$(date +%Y%m%d_%H%M%S).7z"
        fi

        if command -v 7z &>/dev/null; then
            7z a -m0=lzma2 -mx=9 "$out_7z" "$@" >/dev/null
            notify "Compactação 7z Concluída" "Criado: $(basename "$out_7z") (Ultra LZMA2)"
        else
            echo "7z não encontrado. Gerando .zip com máxima compressão..."
            out_zip="${parent_dir}/${clean_name:-arquivo}.zip"
            python3 -c "
import zipfile, os, sys
out = sys.argv[1]
items = sys.argv[2:]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for item in items:
        if os.path.isdir(item):
            for root, dirs, files in os.walk(item):
                for file in files:
                    full = os.path.join(root, file)
                    rel = os.path.relpath(full, os.path.dirname(item))
                    z.write(full, rel)
        else:
            z.write(item, os.path.basename(item))
" "$out_zip" "$@"
            notify "Compactação Concluída (Fallback)" "Criado: $(basename "$out_zip")"
        fi
        ;;

    compress-tar)
        first_item="$1"
        parent_dir="$(dirname "$first_item")"
        if [ $# -eq 1 ]; then
            base_name="$(basename "$first_item")"
            clean_name="${base_name%.*}"
            out_tar="${parent_dir}/${clean_name}.tar.gz"
        else
            out_tar="${parent_dir}/arquivo_$(date +%Y%m%d_%H%M%S).tar.gz"
        fi

        tar -czf "$out_tar" "$@"
        notify "Compactação TAR.GZ Concluída" "Criado: $(basename "$out_tar")"
        ;;

    compress-custom)
        first_item="$1"
        parent_dir="$(dirname "$first_item")"
        echo ""
        echo "=================================================="
        echo "📦 YAZI ARCHIVE CREATOR (Personalizado)"
        echo "=================================================="
        echo -n "Nome do arquivo (sem extensão) [default: arquivo_$(date +%Y%m%d_%H%M)]: "
        read -r custom_name
        if [ -z "$custom_name" ]; then
            custom_name="arquivo_$(date +%Y%m%d_%H%M%S)"
        fi

        echo ""
        echo "Escolha o formato:"
        echo "  [1] .zip    (Padrão e compatibilidade universal)"
        echo "  [2] .7z     (Ultra compressão LZMA2)"
        echo "  [3] .tar.gz (Padrão Linux / Servidores)"
        echo -n "Opção [1]: "
        read -r fmt_choice

        case "$fmt_choice" in
            2)
                "$0" compress-7z "$@"
                # Renomeia se nome customizado foi dado
                ;;
            3)
                out_tar="${parent_dir}/${custom_name}.tar.gz"
                tar -czf "$out_tar" "$@"
                notify "Compactação TAR.GZ Concluída" "Criado: $(basename "$out_tar")"
                ;;
            *)
                out_zip="${parent_dir}/${custom_name}.zip"
                if command -v 7z &>/dev/null; then
                    7z a -tzip -mx=7 "$out_zip" "$@" >/dev/null
                elif command -v zip &>/dev/null; then
                    zip -r -q "$out_zip" "$@"
                else
                    python3 -c "
import zipfile, os, sys
out = sys.argv[1]
items = sys.argv[2:]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for item in items:
        if os.path.isdir(item):
            for root, dirs, files in os.walk(item):
                for file in files:
                    full = os.path.join(root, file)
                    rel = os.path.relpath(full, os.path.dirname(item))
                    z.write(full, rel)
        else:
            z.write(item, os.path.basename(item))
" "$out_zip" "$@"
                fi
                notify "Compactação Concluída" "Criado: $(basename "$out_zip")"
                ;;
        esac
        echo "Sucesso!"
        sleep 1
        ;;

    *)
        echo "Ação desconhecida: $ACTION"
        exit 1
        ;;
esac
