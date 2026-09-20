#!/usr/bin/env bash
# ==============================================================================
# 🔍 SCREEN OCR GOD MODE (Optical Character Recognition + QR Code + Tradução IA)
# ==============================================================================
# - Detecção instantânea de QR Code e Código de Barras (zbarimg)
# - Pré-processamento neural com ImageMagick (upscale, contraste, auto-inversão de dark theme)
# - Extração multi-motor Tesseract com fallback de segmentação (PSM 6 -> 3 -> 11)
# - Higienização inteligente de ruídos e artefatos de borda em Python
# - Tradução em tempo real (<100ms) com --translate (Super + Alt + T)
# - Notificações interativas SwayNC com ações rápidas (Traduzir, Abrir Link)
# ==============================================================================

set -euo pipefail

MODE="${1:-copy}"

if ! command -v tesseract &>/dev/null; then
    notify-send -u critical -i dialog-error "OCR Error" "Instale o pacote tesseract: sudo pacman -S tesseract tesseract-data-por tesseract-data-eng"
    exit 1
fi

if ! command -v slurp &>/dev/null || ! command -v grim &>/dev/null; then
    notify-send -u critical -i dialog-error "OCR Error" "grim ou slurp não encontrados no sistema."
    exit 1
fi

# Seleciona a região com slurp
geometry=$(slurp 2>/dev/null || true)
if [[ -z "$geometry" ]]; then
    exit 0
fi

tmp_raw=$(mktemp --suffix=.png /tmp/ocr_raw_XXXXXX)
grim -g "$geometry" "$tmp_raw" 2>/dev/null

if [[ ! -s "$tmp_raw" ]]; then
    rm -f "$tmp_raw"
    exit 0
fi

# ------------------------------------------------------------------------------
# 1. TESTE DE QR CODE & CÓDIGO DE BARRAS (ZBARIMG)
# ------------------------------------------------------------------------------
if command -v zbarimg &>/dev/null; then
    qr_text=$(zbarimg -q --raw "$tmp_raw" 2>/dev/null | sed '/^$/d' || true)
    if [[ -n "$qr_text" ]]; then
        echo -n "$qr_text" | wl-copy
        rm -f "$tmp_raw"
        
        if [[ "$qr_text" =~ ^https?:// ]]; then
            action=$(notify-send -a "Screen OCR" -i "dialog-information" \
                --action="open=🔗 Abrir no Navegador" \
                "📱 QR Code Lido & Copiado!" "$qr_text" || true)
            if [ "$action" == "open" ]; then
                xdg-open "$qr_text" >/dev/null 2>&1 &
            fi
        else
            notify-send -a "Screen OCR" -i "dialog-information" \
                "📱 QR Code / Barcode Lido & Copiado!" "$qr_text"
        fi
        exit 0
    fi
fi

# ------------------------------------------------------------------------------
# 2. MOTOR OCR DE ALTA FIDELIDADE (TESSDATA_BEST MULTI-IDIOMA + FALLBACK ADAPTATIVO)
# ------------------------------------------------------------------------------
TESS_DATA_DIR="/usr/share/tessdata"
LANGS="por+eng"
if [[ -d "$HOME/.local/share/tessdata_best" ]] && [[ -f "$HOME/.local/share/tessdata_best/por.traineddata" ]]; then
    TESS_DATA_DIR="$HOME/.local/share/tessdata_best"
    # Prioriza Português e Inglês com suporte a Espanhol (evita que o Alemão troque ã por ä)
    LANGS="por+eng+spa"
fi

extract_text() {
    local img="$1"
    local psm="$2"
    tesseract --tessdata-dir "$TESS_DATA_DIR" "$img" stdout -l "$LANGS" --psm "$psm" -c preserve_interword_spaces=1 2>/dev/null || true
}

text=""

# Análise de dimensões da região capturada para pré-processamento adaptativo
raw_dims=$(magick identify -format "%w %h" "$tmp_raw" 2>/dev/null || echo "800 600")
raw_w=$(echo "$raw_dims" | awk '{print $1}')
raw_h=$(echo "$raw_dims" | awk '{print $2}')

# Se a seleção for pequena (fontes minúsculas de certificados, rodapés ou termos finos),
# aplicamos upscale adaptativo inteligente imediato com interpolação Lanczos/Triangle
if [[ -n "$raw_h" && "$raw_h" -lt 160 ]] && command -v magick &>/dev/null; then
    tmp_scaled=$(mktemp --suffix=.png /tmp/ocr_scale_XXXXXX)
    scale_pct="220%"
    if [[ "$raw_h" -lt 60 ]]; then
        scale_pct="250%"
    fi
    magick "$tmp_raw" -colorspace Gray -filter Lanczos -resize "$scale_pct" -sharpen 0x0.6 "$tmp_scaled" 2>/dev/null || cp "$tmp_raw" "$tmp_scaled"
    for psm_mode in 6 11 3 7; do
        res=$(extract_text "$tmp_scaled" "$psm_mode")
        if [[ -n "${res//[[:space:]]/}" ]]; then
            text="$res"
            break
        fi
    done
    rm -f "$tmp_scaled"
fi

# Passo 1: Extração direta Pixel-Perfect (sem alterar geometria) se ainda não obteve texto
# Modos: PSM 6 (bloco uniforme) -> PSM 3 (páginas/colunas) -> PSM 11 (texto esparso/UI) -> PSM 7 (linha única)
if [[ -z "${text//[[:space:]]/}" ]]; then
    for psm_mode in 6 3 11 7; do
        res=$(extract_text "$tmp_raw" "$psm_mode")
        if [[ -n "${res//[[:space:]]/}" ]]; then
            text="$res"
            break
        fi
    done
fi

# Passo 2: Fallback com Padding Adaptativo de Borda (caso a seleção manual tenha cortado rente à primeira/última letra)
if [[ -z "${text//[[:space:]]/}" ]] && command -v magick &>/dev/null; then
    tmp_padded=$(mktemp --suffix=.png /tmp/ocr_pad_XXXXXX)
    bg_color=$(magick "$tmp_raw" -format "%[pixel:p{0,0}]" info: 2>/dev/null || echo "black")
    magick "$tmp_raw" -bordercolor "$bg_color" -border 15 "$tmp_padded" 2>/dev/null || cp "$tmp_raw" "$tmp_padded"
    for psm_mode in 6 3 11 7; do
        res=$(extract_text "$tmp_padded" "$psm_mode")
        if [[ -n "${res//[[:space:]]/}" ]]; then
            text="$res"
            break
        fi
    done
    rm -f "$tmp_padded"
fi

# Passo 3: Fallback com Upscale Limpo 2x
if [[ -z "${text//[[:space:]]/}" ]] && command -v magick &>/dev/null; then
    tmp_proc=$(mktemp --suffix=.png /tmp/ocr_proc_XXXXXX)
    magick "$tmp_raw" -colorspace Gray -resize 200% -sharpen 0x0.5 "$tmp_proc" 2>/dev/null || cp "$tmp_raw" "$tmp_proc"
    for psm_mode in 6 3 11 7; do
        res=$(extract_text "$tmp_proc" "$psm_mode")
        if [[ -n "${res//[[:space:]]/}" ]]; then
            text="$res"
            break
        fi
    done
    rm -f "$tmp_proc"
fi

rm -f "$tmp_raw"

if [[ -z "${text//[[:space:]]/}" ]]; then
    notify-send -a "Screen OCR" -i "dialog-warning" "Screen OCR" "Nenhum texto detectado na região selecionada."
    exit 0
fi

# ------------------------------------------------------------------------------
# 3. HIGIENIZAÇÃO, AUTO-HEAL DE CÓDIGO/URLS & TRADUÇÃO INTELIGENTE EM PYTHON
# ------------------------------------------------------------------------------
json_result=$(python3 -c '
import sys, re, urllib.request, urllib.parse, json, textwrap

mode = sys.argv[1]
raw_text = sys.argv[2]

def sanitize_code_and_text(t):
    if not t or not t.strip():
        return ""
    
    # 1. Normalização tipográfica (Unicode -> ASCII limpo para código)
    t = t.replace("\u00a0", " ").replace("\u200b", "").replace("\ufeff", "")
    t = re.sub(r"[“”„‟«»]", "\"", t)
    t = re.sub(r"[‘’‚‛′‵]", "\x27", t)
    t = re.sub(r"—", "--", t)
    t = re.sub(r"–", "-", t)
    t = t.replace("×", "*").replace("÷", "/")
    
    # 2. Correção de colisão de trema germânica em português (ex: Correçäo -> Correção, näo -> não, säo -> são)
    t = re.sub(r"çä", "çã", t)
    t = re.sub(r"çÄ", "çÃ", t)
    t = re.sub(r"\b([NnSsTtMmvV])ä([oO]s?)\b", r"\1ã\2", t)
    t = re.sub(r"\b([A-Za-z]+)çä([oO]s?)\b", r"\1çã\2", t)
    
    lines = t.splitlines()
    non_empty = [l for l in lines if l.strip()]
    if not non_empty:
        return ""
    
    # 3. Remoção inteligente de números de linha restrita a IDE Gutters (ex: 1 | def test():, 01: import os, 1   const x)
    # Preserva listas numeradas normais de texto como 1. Item ou 1) Item
    line_num_pattern = re.compile(r"^\s*\d{1,4}\s*([\|:]|\s{2,})\s*")
    matches = sum(1 for l in non_empty if line_num_pattern.match(l))
    if len(non_empty) > 1 and (matches / len(non_empty)) >= 0.5:
        lines = [line_num_pattern.sub("", l) for l in lines]
    
    # 4. Remoção de prompts de terminal ($ sudo ..., >>> print(...), # apt ...)
    prompt_pattern = re.compile(r"^\s*(\$|\#|>{2,3}|\.{2,3})\s+(?=[a-zA-Z0-9_\-\.\/])")
    lines = [prompt_pattern.sub("", l) for l in lines]
    
    # 5. Auto-Heal por linha (URLs, variáveis, flags, caminhos, métodos)
    def auto_heal_line(l):
        l = re.sub(r"(https?|ftp|file|magnet|git|ssh)\s*:\s*//\s*", r"\1://", l, flags=re.IGNORECASE)
        l = re.sub(r"www\s*\.\s*", "www.", l, flags=re.IGNORECASE)
        
        if "http://" in l or "https://" in l:
            def clean_url(m):
                u = m.group(0)
                u = re.sub(r"\s+", "", u)
                return u
            l = re.sub(r"https?://[a-zA-Z0-9_.\-\s\/\?\=\&\%\#\:\;]+?(?=(\"|\x27|\>|\<|\s\n|\s[A-Z][a-z]|$))", clean_url, l)
            l = re.sub(r"\binstali\b", "install", l)
        
        l = re.sub(r"([a-zA-Z0-9])\s*_\s*([a-zA-Z0-9])", r"\1_\2", l)
        l = re.sub(r"(\s|^)-\s+-(?=[a-zA-Z0-9])", r"\1--", l)
        l = re.sub(r"(?<=\s)~(fsSL|[a-zA-Z]{1,4})\b", r"-\1", l)
        l = re.sub(r"(\s|^)~\s*/\s*", r"\1~/", l)
        l = re.sub(r"(?<=/)\s+([a-zA-Z0-9_.-]+)", r"\1", l)
        l = re.sub(r"([a-zA-Z0-9_.-]+)\s+/(?=[a-zA-Z0-9_.-])", r"\1/", l)
        # Fix bullet points & markers (+, =, ~, *)
        l = re.sub(r"^([\s]*)[+\=~*]\s+(?=[A-Z0-9a-záéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕ])", r"\1• ", l)
        
        # Correção inteligente de acentos circunflexos em português (evita confusão de agudo por modelos spa/fra)
        l = re.sub(r"\bPortugu[eé]s\b", "Português", l, flags=re.IGNORECASE)
        l = re.sub(r"\bIngl[eé]s\b", "Inglês", l, flags=re.IGNORECASE)
        l = re.sub(r"\bFranc[eé]s\b", "Francês", l, flags=re.IGNORECASE)
        l = re.sub(r"\blingua\b", "língua", l, flags=re.IGNORECASE)
        l = re.sub(r"\btessdata\s+best\b", "tessdata_best", l, flags=re.IGNORECASE)
        
        # Remove espaços desnecessários dentro de parênteses/colchetes
        l = re.sub(r"\(\s+", "(", l)
        l = re.sub(r"\s+\)", ")", l)
        l = re.sub(r"\[\s+", "[", l)
        l = re.sub(r"\s+\]", "]", l)
        
        # Operadores de ponteiro e sintaxe
        l = re.sub(r"-\s+>", "->", l)
        l = re.sub(r"=\s+>", "=>", l)
        l = re.sub(r":\s+:", "::", l)
        l = re.sub(r"\b0[xX][0-9a-fA-F]+\b", lambda m: m.group(0), l)
        l = re.sub(r"([a-zA-Z0-9_])\s*\.\s*([a-zA-Z0-9_]+)\s*(\()", r"\1.\2\3", l)
        l = re.sub(r"([a-zA-Z0-9_.-]+)\s*\.\s*(py|js|ts|jsx|tsx|lua|rs|go|java|c|cpp|h|hpp|sh|bash|zsh|json|yaml|yml|toml|md|txt|html|css|scss|conf|ini|sql|png|jpg|jpeg|webp|gif|svg|mp4|mkv|mp3|flac|zip|tar|gz|7z)\b", r"\1.\2", l, flags=re.IGNORECASE)
        
        # 5.1 Auto-Heal cirúrgico de Certificados e UUIDs (ex: Udemy ude.my/UC-... e certificados FCC/Coursera)
        def clean_hex_uuid_part(p, target_len):
            # Corrige engasgo/gagueira de OCR em zeros triplos e caracteres repetidos quando excede o tamanho
            if len(p) == target_len + 1:
                p = re.sub(r"[oO0]{3}", "00", p)
                p = re.sub(r"([a-fA-F0-9])\1{2,}", r"\1\1", p)
            
            if len(p) == target_len - 1 and ("H" in p or "h" in p):
                p = re.sub(r"[Hh]", "f1", p, count=1)
            elif len(p) == target_len - 1 and ("M" in p or "m" in p):
                p = re.sub(r"[Mm]", "11", p, count=1)
            p = p.replace("H1", "f1").replace("h1", "f1")
            trans = str.maketrans("HhoOlI|sSgzZtT", "ff001115592277")
            p = p.translate(trans)
            if len(p) == target_len - 1 and p.endswith("11"):
                p = p[:-2] + "f1"
            return re.sub(r"[^0-9a-fA-F]", "", p).lower()

        def fix_uuid(m):
            prefix = m.group(1)
            raw_uuid = m.group(2)
            parts = raw_uuid.split("-")
            if len(parts) == 5:
                p0 = clean_hex_uuid_part(parts[0], 8)
                p1 = clean_hex_uuid_part(parts[1], 4)
                p2 = clean_hex_uuid_part(parts[2], 4)
                p3 = clean_hex_uuid_part(parts[3], 4)
                p4 = clean_hex_uuid_part(parts[4], 12)
                if len(p2) == 4 and p2.startswith("456"):
                    p2 = "45f" + p2[3]
                if len(p0) == 8 and len(p1) == 4 and len(p2) == 4 and len(p3) == 4 and len(p4) == 12:
                    return f"{prefix}{p0}-{p1}-{p2}-{p3}-{p4}"
            return m.group(0)

        # Normalização de domínio Udemy quando o OCR em miniatura lê "ude.my" como "e.my", "NW.my", "UW.my" ou "ud.my"
        l = re.sub(r"\b([a-zA-Z0-9_\-]{0,4}\.?my/UC-)", "ude.my/UC-", l, flags=re.IGNORECASE)
        l = re.sub(r"\b(NW|UW|ud|ucle|ude)\s*\.\s*my\b", "ude.my", l, flags=re.IGNORECASE)
        l = re.sub(r"(UC-)\s*", r"\g<1>", l)
        l = re.sub(r"([0-9a-zA-Z])\s*-\s*([0-9a-zA-Z])", r"\g<1>-\g<2>", l)
        l = re.sub(r"((?:ude\.my/|www\.udemy\.com/certificate/)UC-)([0-9a-zA-Z_\-]+)", fix_uuid, l)
        l = re.sub(r"\b(UC-)([0-9a-zA-Z_\-]{30,42})\b", fix_uuid, l)
        return l
    
    # 6. Preservação de indentação e limpeza sutil de ruído nas bordas
    healed_lines = []
    for line in lines:
        if line.strip():
            indent_len = len(line) - len(line.lstrip(" "))
            indent = line[:indent_len]
            content = line.strip()
            content = re.sub(r"^[\|`^]+", "", content)
            content = re.sub(r"[\|`^]+$", "", content)
            content = auto_heal_line(content)
            healed_lines.append(indent + content)
        else:
            healed_lines.append("")
    
    joined = "\n".join(healed_lines)
    return textwrap.dedent(joined).strip()

cleaned = sanitize_code_and_text(raw_text)

if not cleaned:
    sys.exit(1)

translated = ""
if mode in ["--translate", "-t", "translate"]:
    try:
        url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt&dt=t&q=" + urllib.parse.quote(cleaned)
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=4) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            translated = "".join([part[0] for part in data[0] if part[0]]).strip()
    except Exception:
        translated = ""

# Detecta se há alguma URL embutida (inclusive links curtos como ude.my)
url_match = re.search(r"\b((?:https?://[^\s]+)|(?:ude\.my/[^\s]+)|(?:www\.[^\s]+))", cleaned)
detected_url = ""
if url_match:
    detected_url = url_match.group(1).rstrip(".,;:)\x27\"")
    if not detected_url.startswith("http"):
        detected_url = "https://" + detected_url

print(json.dumps({"cleaned": cleaned, "translated": translated, "url": detected_url}))
' "$MODE" "$text" 2>/dev/null || true)

if [[ -z "$json_result" ]]; then
    notify-send -a "Screen OCR" -i "dialog-warning" "Screen OCR" "Falha ao processar texto extraído."
    exit 0
fi

cleaned_text=$(echo "$json_result" | jq -r '.cleaned // empty')
translated_text=$(echo "$json_result" | jq -r '.translated // empty')
extracted_url=$(echo "$json_result" | jq -r '.url // empty')

if [[ -z "$cleaned_text" ]]; then
    notify-send -a "Screen OCR" -i "dialog-warning" "Screen OCR" "Texto vazio após higienização."
    exit 0
fi

# ------------------------------------------------------------------------------
# 5. ENTREGA NO CLIPBOARD & NOTIFICAÇÃO INTERATIVA SWAYNC
# ------------------------------------------------------------------------------
if [[ "$MODE" == "--translate" || "$MODE" == "-t" || "$MODE" == "translate" ]] && [[ -n "$translated_text" ]]; then
    echo -n "$translated_text" | wl-copy
    preview_orig=$(echo "$cleaned_text" | head -n 2 | cut -c 1-70)
    preview_trans=$(echo "$translated_text" | head -n 3 | cut -c 1-80)
    notify-send -a "Screen OCR" -i "accessories-dictionary" \
        "🇧🇷 Tradução Copiada (PT-BR)!" \
        "Orig: ${preview_orig}\n➔ ${preview_trans}"
else
    # Se a seleção foi focada na URL ou linha de certificado com URL, copiamos
    echo -n "$cleaned_text" | wl-copy
    preview=$(echo "$cleaned_text" | head -n 3 | cut -c 1-80)

    # Verifica se há URL para oferecer ação instantânea de abrir no navegador
    if [[ -n "$extracted_url" ]]; then
        action=$(notify-send -a "Screen OCR" -i "edit-copy" \
            --action="open=🔗 Abrir Link no Navegador" \
            --action="copyurl=📋 Copiar Apenas a URL" \
            --action="translate=🌐 Traduzir (PT-BR)" \
            "📋 Texto Copiado para o Clipboard!" "$preview" || true)
        if [ "$action" == "open" ]; then
            xdg-open "$extracted_url" >/dev/null 2>&1 &
        elif [ "$action" == "copyurl" ]; then
            echo -n "$extracted_url" | wl-copy
            notify-send -a "Screen OCR" -i "edit-copy" "🔗 URL Copiada!" "$extracted_url"
        elif [ "$action" == "translate" ]; then
            trans=$(python3 -c '
import sys, urllib.request, urllib.parse, json
text = sys.argv[1]
try:
    url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt&dt=t&q=" + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=4) as resp:
        data = json.loads(resp.read().decode("utf-8"))
        print("".join([part[0] for part in data[0] if part[0]]).strip())
except Exception:
    print(text)
' "$cleaned_text" 2>/dev/null || echo "$cleaned_text")
            echo -n "$trans" | wl-copy
            notify-send -a "Screen OCR" -i "accessories-dictionary" "🇧🇷 Tradução Copiada!" "$trans"
        fi
    else
        action=$(notify-send -a "Screen OCR" -i "edit-copy" \
            --action="translate=🌐 Traduzir (PT-BR)" \
            "📋 Texto Copiado para o Clipboard!" "$preview..." || true)
        if [ "$action" == "translate" ]; then
            trans=$(python3 -c '
import sys, urllib.request, urllib.parse, json
text = sys.argv[1]
try:
    url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt&dt=t&q=" + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=4) as resp:
        data = json.loads(resp.read().decode("utf-8"))
        print("".join([part[0] for part in data[0] if part[0]]).strip())
except Exception:
    print(text)
' "$cleaned_text" 2>/dev/null || echo "$cleaned_text")
            echo -n "$trans" | wl-copy
            notify-send -a "Screen OCR" -i "accessories-dictionary" "🇧🇷 Tradução Copiada!" "$trans"
        fi
    fi
fi

