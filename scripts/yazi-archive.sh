#!/usr/bin/env bash
# ==============================================================================
# 📦 YAZI ARCHIVE HELPER — Compressão e Extração Universal com Progresso Visual
# ==============================================================================
# Suporta: .zip, .7z, .rar, .tar, .tar.gz, .tar.xz, .tar.zst, .tar.bz2, .apk, .iso
# Motores: ouch (progresso animado nativo) -> 7-Zip (-bsp1) -> tar/unzip -> python
# ==============================================================================

set -euo pipefail

ACTION="${1:-}"
shift || true

if [ -z "$ACTION" ] || [ $# -eq 0 ]; then
    echo "Uso: $0 {extract-here|extract-sub|compress-zip|compress-7z|compress-tar|compress-custom} <arquivos...>"
    exit 1
fi

# Cores ANSI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
DIM='\033[2m'
RESET='\033[0m'

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Yazi" -i "package-x-generic" "$title" "$msg" 2>/dev/null || true
    fi
}

print_header() {
    local title="$1"
    local info="$2"
    echo ""
    echo -e "${CYAN}======================================================================${RESET}"
    echo -e "${BOLD}${MAGENTA}📦 YAZI ARCHIVE${RESET} — ${BOLD}${title}${RESET}"
    [ -n "$info" ] && echo -e "$info"
    echo -e "${CYAN}======================================================================${RESET}"
    echo ""
}

check_hidden_root_items() {
    local file="$1"
    local has_hidden=""
    if command -v 7z &>/dev/null; then
        has_hidden="$(7z l -ba "$file" 2>/dev/null | awk '{print $NF}' | grep '^\.' | head -n 1 || true)"
    elif command -v unzip &>/dev/null && [[ "$file" =~ \.zip$ ]]; then
        has_hidden="$(unzip -Z1 "$file" 2>/dev/null | grep '^\.' | head -n 1 || true)"
    fi

    if [ -n "$has_hidden" ]; then
        echo ""
        echo -e "${YELLOW}💡 AVISO: O arquivo contém itens ocultos (ex: ${BOLD}${has_hidden}${RESET}${YELLOW}).${RESET}"
        echo -e "${YELLOW}👉 No Yazi, pressione '${BOLD}.${RESET}${YELLOW}' (ponto) para alternar a exibição de arquivos ocultos!${RESET}"
        return 0
    fi
    return 1
}

extract_archive() {
    local raw_file="$1"
    local mode="$2" # "here" ou "sub"
    local abs_file
    abs_file="$(realpath "$raw_file" 2>/dev/null || echo "$raw_file")"

    if [ ! -f "$abs_file" ]; then
        echo -e "${RED}Erro: Arquivo não encontrado: $raw_file${RESET}"
        return 1
    fi

    local filename="$(basename "$abs_file")"
    local parent_dir="$(dirname "$abs_file")"
    local filesize
    filesize="$(du -h "$abs_file" 2>/dev/null | cut -f1 || echo "")"
    [ -n "$filesize" ] && filesize="($filesize)"

    local target_dir
    local is_sub=0
    if [ "$mode" = "sub" ]; then
        is_sub=1
        local sub_name="${filename%.*}"
        if [[ "$filename" =~ \.tar\.[a-zA-Z0-9]+$ ]]; then
            sub_name="${filename%.*.*}"
        fi
        target_dir="$parent_dir/$sub_name"
        mkdir -p "$target_dir"
    else
        target_dir="$parent_dir"
    fi

    local dest_display="$target_dir"
    if [ "$mode" = "here" ]; then
        dest_display="Pasta Atual ($(basename "$target_dir"))"
    fi

    print_header "Extração de Arquivo" "  Arquivo : ${BOLD}${filename}${RESET} ${DIM}${filesize}${RESET}\n  Destino : ${CYAN}${dest_display}${RESET}"

    local start_time=$(date +%s)
    local success=0

    # 1. Tenta ouch se disponível (UI moderna com barra de progresso em Rust)
    if command -v ouch &>/dev/null; then
        echo -e "${CYAN}▶ Extraindo via ouch...${RESET}"
        if [ "$is_sub" -eq 1 ]; then
            if ouch decompress --yes --dir "$target_dir" "$abs_file"; then
                success=1
            fi
        else
            if (cd "$target_dir" && ouch decompress --yes --here "$abs_file"); then
                success=1
            fi
        fi
    fi

    # 2. Fallback: 7-Zip com exibição ativa de progresso (-bsp1)
    if [ $success -ne 1 ] && command -v 7z &>/dev/null; then
        echo -e "${CYAN}▶ Extraindo via 7-Zip (com progresso)...${RESET}"
        if 7z x -bsp1 -y "-o$target_dir" "$abs_file"; then
            success=1
        fi
    fi

    # 3. Fallbacks específicos do sistema
    if [ $success -ne 1 ]; then
        local lower_name="$(echo "$filename" | tr '[:upper:]' '[:lower:]')"
        if [[ "$lower_name" =~ \.zip$|\.apk$|\.jar$ ]] && command -v unzip &>/dev/null; then
            echo -e "${CYAN}▶ Extraindo via unzip...${RESET}"
            unzip -o "$abs_file" -d "$target_dir" && success=1
        elif [[ "$lower_name" =~ \.tar\.gz$|\.tgz$ ]]; then
            echo -e "${CYAN}▶ Extraindo via tar.gz...${RESET}"
            tar -xzvf "$abs_file" -C "$target_dir" && success=1
        elif [[ "$lower_name" =~ \.tar\.xz$|\.txz$ ]]; then
            echo -e "${CYAN}▶ Extraindo via tar.xz...${RESET}"
            tar -xJvf "$abs_file" -C "$target_dir" && success=1
        elif [[ "$lower_name" =~ \.tar\.zst$ ]]; then
            echo -e "${CYAN}▶ Extraindo via tar.zst...${RESET}"
            tar --zstd -xvf "$abs_file" -C "$target_dir" && success=1
        elif [[ "$lower_name" =~ \.tar$ ]]; then
            echo -e "${CYAN}▶ Extraindo via tar...${RESET}"
            tar -xvf "$abs_file" -C "$target_dir" && success=1
        fi
    fi

    if [ $success -eq 1 ]; then
        local elapsed=$(( $(date +%s) - start_time ))
        echo ""
        echo -e "${GREEN}✔ Extração concluída com sucesso em ${elapsed}s!${RESET}"

        local had_hidden=0
        if check_hidden_root_items "$abs_file"; then
            had_hidden=1
        fi

        if [ "$is_sub" -eq 1 ]; then
            notify "Extração Concluída" "$filename extraído em /$(basename "$target_dir")$([ $had_hidden -eq 1 ] && echo ' (contém itens ocultos: aperte .)')"
        else
            notify "Extração Concluída" "$filename extraído aqui$([ $had_hidden -eq 1 ] && echo ' (contém itens ocultos: aperte .)')"
        fi

        if [ $had_hidden -eq 1 ]; then
            sleep 2.5
        else
            sleep 0.8
        fi
        return 0
    else
        echo ""
        echo -e "${RED}✖ Falha ao extrair $filename!${RESET}"
        notify "Erro na Extração" "Falha ao extrair $filename"
        echo ""
        read -rp "Pressione Enter para fechar..."
        return 1
    fi
}

compress_items() {
    local fmt="$1"
    shift
    local raw_items=("$@")

    if [ ${#raw_items[@]} -eq 0 ]; then
        echo -e "${RED}Erro: Nenhum item selecionado para compactação.${RESET}"
        return 1
    fi

    local first_item
    first_item="$(realpath "${raw_items[0]}" 2>/dev/null || echo "${raw_items[0]}")"
    local parent_dir="$(dirname "$first_item")"
    local base_name="$(basename "$first_item")"
    local clean_name="${base_name%.*}"

    local custom_fmt="$fmt"
    if [ "$fmt" = "custom" ]; then
        echo ""
        echo -e "${CYAN}======================================================================${RESET}"
        echo -e "${BOLD}${MAGENTA}📦 COMPACTAÇÃO PERSONALIZADA${RESET}"
        echo -e "${CYAN}======================================================================${RESET}"
        echo -n "Nome do arquivo (sem extensão) [padrão: ${clean_name}]: "
        read -r input_name
        [ -n "$input_name" ] && clean_name="$input_name"

        echo ""
        echo "Escolha o formato:"
        echo "  [1] .zip    (Padrão e compatibilidade universal)"
        echo "  [2] .7z     (Ultra compressão LZMA2)"
        echo "  [3] .tar.gz (Padrão Linux / Servidores)"
        echo -n "Opção [1]: "
        read -r choice
        case "$choice" in
            2) custom_fmt="7z" ;;
            3) custom_fmt="tar" ;;
            *) custom_fmt="zip" ;;
        esac
    fi

    local out_file=""
    if [ ${#raw_items[@]} -eq 1 ]; then
        case "$custom_fmt" in
            7z)  out_file="$parent_dir/${clean_name}.7z" ;;
            tar) out_file="$parent_dir/${clean_name}.tar.gz" ;;
            *)   out_file="$parent_dir/${clean_name}.zip" ;;
        esac
    else
        local ts="$(date +%Y%m%d_%H%M%S)"
        case "$custom_fmt" in
            7z)  out_file="$parent_dir/arquivo_${ts}.7z" ;;
            tar) out_file="$parent_dir/arquivo_${ts}.tar.gz" ;;
            *)   out_file="$parent_dir/arquivo_${ts}.zip" ;;
        esac
    fi

    print_header "Compactação de Arquivos" "  Destino : ${BOLD}${CYAN}$(basename "$out_file")${RESET}\n  Itens   : ${#raw_items[@]} item(ns) selecionado(s)"

    local start_time=$(date +%s)
    local success=0

    # 1. Tenta ouch (UI de barra de progresso nativa)
    if command -v ouch &>/dev/null; then
        echo -e "${CYAN}▶ Comprimindo via ouch com barra de progresso...${RESET}"
        if ouch compress --yes "${raw_items[@]}" "$out_file"; then
            success=1
        fi
    fi

    # 2. Fallbacks de ferramentas
    if [ $success -ne 1 ]; then
        if [ "$custom_fmt" = "7z" ] && command -v 7z &>/dev/null; then
            echo -e "${CYAN}▶ Comprimindo via 7-Zip (LZMA2)...${RESET}"
            7z a -m0=lzma2 -mx=9 -bsp1 "$out_file" "${raw_items[@]}" && success=1
        elif [ "$custom_fmt" = "tar" ]; then
            echo -e "${CYAN}▶ Comprimindo via tar.gz...${RESET}"
            tar -czvf "$out_file" "${raw_items[@]}" && success=1
        elif command -v 7z &>/dev/null; then
            echo -e "${CYAN}▶ Comprimindo via 7-Zip (ZIP)...${RESET}"
            7z a -tzip -mx=7 -bsp1 "$out_file" "${raw_items[@]}" && success=1
        elif command -v zip &>/dev/null; then
            echo -e "${CYAN}▶ Comprimindo via zip...${RESET}"
            zip -r "$out_file" "${raw_items[@]}" && success=1
        fi
    fi

    if [ $success -eq 1 ]; then
        local elapsed=$(( $(date +%s) - start_time ))
        local out_size
        out_size="$(du -h "$out_file" 2>/dev/null | cut -f1 || echo "")"
        [ -n "$out_size" ] && out_size="($out_size)"
        echo ""
        echo -e "${GREEN}✔ Compactado com sucesso em ${elapsed}s!${RESET} ${DIM}${out_size}${RESET}"
        notify "Compactação Concluída" "Criado: $(basename "$out_file") $out_size"
        sleep 0.8
        return 0
    else
        echo ""
        echo -e "${RED}✖ Falha ao compactar arquivos!${RESET}"
        notify "Erro na Compactação" "Falha ao criar $(basename "$out_file")"
        echo ""
        read -rp "Pressione Enter para fechar..."
        return 1
    fi
}

case "$ACTION" in
    extract-here)
        for f in "$@"; do
            extract_archive "$f" "here"
        done
        ;;

    extract-sub)
        for f in "$@"; do
            extract_archive "$f" "sub"
        done
        ;;

    compress-zip)
        compress_items "zip" "$@"
        ;;

    compress-7z)
        compress_items "7z" "$@"
        ;;

    compress-tar)
        compress_items "tar" "$@"
        ;;

    compress-custom)
        compress_items "custom" "$@"
        ;;

    *)
        echo -e "${RED}Ação desconhecida: $ACTION${RESET}"
        exit 1
        ;;
esac
