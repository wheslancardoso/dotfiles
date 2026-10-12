#!/usr/bin/env bash
# ==============================================================================
# ⚡ YAZI ELITE ACTIONS — Motor de Ações Forenses & Mídia
# ==============================================================================
set -euo pipefail

action="${1:-help}"
target="${2:-$PWD}"

case "$action" in
    ocr)
        if [[ ! -f "$target" ]]; then
            echo "Arquivo inválido para OCR!"
            sleep 1
            exit 1
        fi
        echo -e "\033[1;34m🔍 Executando OCR Forense (Tesseract)...\033[0m"
        tmp_txt="/tmp/yazi_ocr_$(date +%s)"
        # Tenta português + inglês
        tesseract "$target" "$tmp_txt" -l por+eng 2>/dev/null || tesseract "$target" "$tmp_txt" 2>/dev/null
        if [[ -f "${tmp_txt}.txt" ]]; then
            cat "${tmp_txt}.txt" | wl-copy
            lines=$(wc -l < "${tmp_txt}.txt")
            chars=$(wc -m < "${tmp_txt}.txt")
            rm -f "${tmp_txt}.txt"
            notify-send -a "Yazi OCR" "✓ Texto Extraído Copiado!" "$lines linhas ($chars caracteres) copiados para o clipboard." 2>/dev/null || true
            echo -e "\033[1;32m✓ Texto extraído e copiado para o clipboard ($lines linhas)!\033[0m"
            sleep 0.8
        else
            echo "Falha ao processar OCR."
            sleep 1
        fi
        ;;

    qr-share)
        local_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || hostname -I | awk '{print $1}')
        port=8080
        target_dir="$target"
        if [[ -f "$target_dir" ]]; then
            target_dir="$(dirname "$target_dir")"
        fi
        share_url="http://${local_ip}:${port}/"

        clear
        echo -e "\033[1;35m====================================================\033[0m"
        echo -e "\033[1;32m 🌐 YAZI LOCAL AIR-DROP — Servidor Web & QR Code\033[0m"
        echo -e "\033[1;35m====================================================\033[0m"
        echo -e "Pasta Compartilhada: \033[1;34m$target_dir\033[0m"
        echo -e "Acesse na mesma rede Wi-Fi / LAN em:"
        echo -e "\033[1;33m👉 $share_url\033[0m"
        echo ""
        if command -v qrencode >/dev/null 2>&1; then
            qrencode -t ANSI256 "$share_url"
        fi
        echo ""
        echo -e "\033[1;31m[Ctrl+C] Encerrar Compartilhamento\033[0m"
        echo "----------------------------------------------------"
        python3 -m http.server "$port" -d "$target_dir" || true
        ;;

    sha256)
        if [[ ! -f "$target" ]]; then
            echo "Selecione um arquivo válido!"
            sleep 1
            exit 1
        fi
        echo -e "\033[1;34m🔒 Calculando SHA-256...\033[0m"
        hash_val=$(sha256sum "$target" | awk '{print $1}')
        echo "$hash_val" | wl-copy
        notify-send -a "Yazi Hashes" "🔒 SHA-256 Copiado!" "$(basename "$target"):\n$hash_val" 2>/dev/null || true
        echo -e "Arquivo: \033[1;32m$(basename "$target")\033[0m"
        echo -e "SHA-256: \033[1;33m$hash_val\033[0m"
        echo -e "\033[1;32m✓ Hash copiado para a área de transferência!\033[0m"
        sleep 1.2
        ;;

    copy-content)
        if [[ ! -f "$target" ]]; then
            echo "Selecione um arquivo de texto válido!"
            sleep 1
            exit 1
        fi
        cat "$target" | wl-copy
        lines=$(wc -l < "$target" 2>/dev/null || echo 0)
        notify-send -a "Yazi Clipboard" "📋 Conteúdo Copiado!" "$(basename "$target") ($lines linhas) copiado." 2>/dev/null || true
        echo -e "\033[1;32m✓ Conteúdo de $(basename "$target") copiado para o clipboard!\033[0m"
        sleep 0.6
        ;;

    copy-image)
        if [[ ! -f "$target" ]]; then
            echo "Selecione uma imagem válida!"
            sleep 1
            exit 1
        fi
        # Converte para PNG em memória se necessário para garantir compatibilidade com wl-copy -t image/png
        ffmpeg -v error -i "$target" -f image2pipe -vcodec png - | wl-copy -t image/png 2>/dev/null || wl-copy -t image/png < "$target"
        notify-send -a "Yazi Clipboard" "🖼️ Imagem Copiada!" "Pronta para colar com Ctrl+V no Discord/Navegador." 2>/dev/null || true
        echo -e "\033[1;32m✓ Imagem copiada como bitmap PNG para o clipboard!\033[0m"
        sleep 0.6
        ;;

    disk-usage)
        target_dir="$target"
        if [[ -f "$target_dir" ]]; then
            target_dir="$(dirname "$target_dir")"
        fi
        gdu "$target_dir"
        ;;

    trash-put)
        if [[ -e "$target" ]]; then
            trash-put "$target"
            notify-send -a "Yazi" "🗑️ Enviado para a Lixeira" "$(basename "$target") movido para a lixeira." 2>/dev/null || true
        fi
        ;;

    trash-restore)
        echo -e "\033[1;33m🗑️ Restaurando arquivos da Lixeira...\033[0m"
        trash-restore || true
        ;;

    media-webp)
        if [[ ! -f "$target" ]]; then exit 1; fi
        out="${target%.*}.webp"
        ffmpeg -v error -stats -i "$target" -c:v libwebp -quality 85 "$out" -y
        notify-send -a "Yazi Mídia" "✓ Convertido para WebP" "$(basename "$out") criado!" 2>/dev/null || true
        echo -e "\033[1;32m✓ Criado: $(basename "$out")\033[0m"
        sleep 0.8
        ;;

    media-mp3)
        if [[ ! -f "$target" ]]; then exit 1; fi
        out="${target%.*}.mp3"
        ffmpeg -v error -stats -i "$target" -vn -c:a libmp3lame -q:a 2 "$out" -y
        notify-send -a "Yazi Mídia" "✓ Áudio Extraído para MP3" "$(basename "$out") criado!" 2>/dev/null || true
        echo -e "\033[1;32m✓ Criado: $(basename "$out")\033[0m"
        sleep 0.8
        ;;

    media-gif)
        if [[ ! -f "$target" ]]; then exit 1; fi
        out="${target%.*}.gif"
        palette="/tmp/palette_$(date +%s).png"
        ffmpeg -v error -i "$target" -vf "fps=15,scale=480:-1:flags=lanczos,palettegen" -y "$palette"
        ffmpeg -v error -stats -i "$target" -i "$palette" -lavfi "fps=15,scale=480:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y "$out"
        rm -f "$palette"
        notify-send -a "Yazi Mídia" "✓ GIF Otimizado Criado" "$(basename "$out") pronto!" 2>/dev/null || true
        echo -e "\033[1;32m✓ Criado: $(basename "$out")\033[0m"
        sleep 0.8
        ;;

    *)
        echo "Uso: $0 {ocr|qr-share|sha256|copy-content|copy-image|disk-usage|trash-put|trash-restore|media-webp|media-mp3|media-gif} [alvo]"
        exit 1
        ;;
esac
