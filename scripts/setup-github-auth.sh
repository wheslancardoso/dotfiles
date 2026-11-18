#!/usr/bin/env bash
# ==============================================================================
# Autenticação Segura GitHub via Arquivo Cifrado (OpenSSL AES-256-CBC + PBKDF2)
# Nunca grava tokens ou senhas em texto claro no repositório.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
COMMON_SH="$DOTFILES_DIR/scripts/setup/common.sh"

if [ -f "$COMMON_SH" ]; then
    # shellcheck source=/dev/null
    source "$COMMON_SH"
else
    info() { printf "[INFO] %s\n" "$1"; }
    ok()   { printf "[OK] %s\n" "$1"; }
    warn() { printf "[WARN] %s\n" "$1"; }
    erro() { printf "[ERRO] %s\n" "$1"; exit 1; }
    has_cmd() { command -v "$1" >/dev/null 2>&1; }
fi

MODE="setup"
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"
ENC_FILE="${GITHUB_PAT_ENC_FILE:-$DOTFILES_DIR/secrets/github.pat.enc}"
GH_USER="${GITHUB_USER:-wheslancardoso}"
GH_EMAIL="${GITHUB_EMAIL:-wheslancardoso1@gmail.com}"

for arg in "$@"; do
    case "$arg" in
        --encrypt|-e) MODE="encrypt" ;;
        --non-interactive|-y|--yes) NON_INTERACTIVE=true ;;
        --file=*) ENC_FILE="${arg#*=}" ;;
        --user=*) GH_USER="${arg#*=}" ;;
        --email=*) GH_EMAIL="${arg#*=}" ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/setup-github-auth.sh [opções]
  (padrão)            Descriptografa secrets/github.pat.enc, configura ~/.git-credentials e gh CLI
  --encrypt, -e       Lê o PAT (stdin ou prompt oculto), pede passphrase 2x e grava secrets/github.pat.enc
  --non-interactive   Não solicita passphrase interativamente (requer DOTFILES_SECRET_KEY)
  --file=<caminho>    Caminho alternativo para o arquivo cifrado (padrão: secrets/github.pat.enc)
  --user=<usuario>    Usuário GitHub (padrão: wheslancardoso)
  --email=<email>     E-mail GitHub (padrão: wheslancardoso1@gmail.com)
  --help, -h          Mostra esta ajuda
EOF
            exit 0
            ;;
        *) warn "Argumento desconhecido ignorado: $arg" ;;
    esac
done

if ! has_cmd openssl; then
    warn "openssl não encontrado; pulando autenticação GitHub cifrada."
    exit 0
fi

encrypt_token() {
    local token=""
    local pass1=""
    local pass2=""

    if [ ! -t 0 ]; then
        IFS= read -r token || true
    else
        read -rsp "Cole o GitHub Personal Access Token (PAT): " token
        printf "\n"
    fi

    token="${token//$'\r'/}"
    token="${token//$'\n'/}"
    if [ -z "$token" ]; then
        erro "Token vazio. Operação abortada."
    fi

    if [ -n "${DOTFILES_SECRET_KEY:-}" ]; then
        pass1="$DOTFILES_SECRET_KEY"
    else
        read -rsp "Digite a passphrase de criptografia: " pass1
        printf "\n"
        read -rsp "Confirme a passphrase: " pass2
        printf "\n"
        if [ -z "$pass1" ] || [ "$pass1" != "$pass2" ]; then
            unset token pass1 pass2
            erro "Passphrases vazias ou não conferem."
        fi
    fi

    mkdir -p "$(dirname "$ENC_FILE")"
    export DOTFILES_PASS="$pass1"
    if printf '%s' "$token" | openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -a -pass env:DOTFILES_PASS -out "$ENC_FILE"; then
        chmod 600 "$ENC_FILE"
        unset token pass1 pass2 DOTFILES_PASS
        ok "Token cifrado com sucesso em $ENC_FILE (seguro para versionamento)."
    else
        unset token pass1 pass2 DOTFILES_PASS
        erro "Falha ao cifrar o token com openssl."
    fi
}

setup_github_auth() {
    if [ ! -f "$ENC_FILE" ]; then
        warn "Arquivo cifrado $ENC_FILE não encontrado; pulando autenticação GitHub automática."
        return 0
    fi

    local pass="${DOTFILES_SECRET_KEY:-}"
    if [ -z "$pass" ]; then
        if [ "$NON_INTERACTIVE" = true ] || [ ! -t 0 ]; then
            warn "DOTFILES_SECRET_KEY não definida em modo não-interativo; pulando descriptografia de $ENC_FILE."
            return 0
        fi
        read -rsp "Digite a passphrase para descriptografar $ENC_FILE: " pass
        printf "\n"
    fi

    if [ -z "$pass" ]; then
        warn "Passphrase vazia; pulando autenticação GitHub."
        return 0
    fi

    local token=""
    export DOTFILES_PASS="$pass"
    if ! token="$(openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -a -pass env:DOTFILES_PASS -in "$ENC_FILE" 2>/dev/null)"; then
        unset pass DOTFILES_PASS token
        warn "Falha ao descriptografar $ENC_FILE (passphrase incorreta?); seguindo sem quebrar o setup."
        return 0
    fi
    unset pass DOTFILES_PASS

    token="${token//$'\r'/}"
    token="${token//$'\n'/}"
    if [ -z "$token" ]; then
        unset token
        warn "Token descriptografado vazio; pulando."
        return 0
    fi

    if has_cmd git; then
        git config --global credential.helper store
        if [ -z "$(git config --global user.name 2>/dev/null || true)" ]; then
            git config --global user.name "$GH_USER"
        fi
        if [ -z "$(git config --global user.email 2>/dev/null || true)" ]; then
            git config --global user.email "$GH_EMAIL"
        fi

        local cred_file="$HOME/.git-credentials"
        local tmp_cred
        umask 077
        touch "$cred_file"
        chmod 600 "$cred_file"
        tmp_cred="$(mktemp)"
        grep -vE '^https://[^@]*@github\.com/?$' "$cred_file" > "$tmp_cred" 2>/dev/null || true
        printf 'https://%s:%s@github.com\n' "$GH_USER" "$token" >> "$tmp_cred"
        mv "$tmp_cred" "$cred_file"
        chmod 600 "$cred_file"
        ok "Credencial GitHub configurada em ~/.git-credentials (chmod 600)."
    fi

    if has_cmd gh; then
        if printf '%s\n' "$token" | gh auth login --with-token >/dev/null 2>&1; then
            ok "GitHub CLI (gh) autenticado."
        else
            warn "Não foi possível autenticar gh CLI (verifique rede/token)."
        fi
    fi

    unset token
}

if [ "$MODE" = "encrypt" ]; then
    encrypt_token
else
    setup_github_auth
fi
