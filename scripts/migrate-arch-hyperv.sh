#!/usr/bin/env bash
# ==============================================================================
# Entrypoint Unificado de Migração: Arch Linux + Hyprland (Hyper-V / Windows AD)
# Orquestra setup base, guest Hyper-V, integração AD/SMB, Antigravity e agr-docs.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
source "$DOTFILES_DIR/scripts/setup/common.sh"

export NON_INTERACTIVE=false
PROFILE="work"
HYPERV_FLAG="--hyperv"
WITH_AD=false
WITH_AGR=true
CLONE_PORTAIS=false
AD_ENV_FILE="${AD_SMB_ENV_FILE:-$HOME/.config/agr/ad-smb.env}"
AGR_DOCS_DIR="${AGR_DOCS_DIR:-$HOME/projetos_agr/agr-docs}"

for arg in "$@"; do
    case "$arg" in
        --non-interactive|-y|--yes)
            NON_INTERACTIVE=true
            ;;
        --work)
            PROFILE="work"
            ;;
        --full)
            PROFILE="full"
            ;;
        --profile=*)
            PROFILE="${arg#*=}"
            ;;
        --hyperv)
            HYPERV_FLAG="--hyperv"
            ;;
        --no-hyperv)
            HYPERV_FLAG="--no-hyperv"
            ;;
        --with-ad)
            WITH_AD=true
            ;;
        --ad-env=*)
            WITH_AD=true
            AD_ENV_FILE="${arg#*=}"
            ;;
        --skip-agr)
            WITH_AGR=false
            ;;
        --clone-portais)
            WITH_AGR=true
            CLONE_PORTAIS=true
            ;;
        --agr-docs=*)
            AGR_DOCS_DIR="${arg#*=}"
            ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/migrate-arch-hyperv.sh [opções]
  --non-interactive, -y   Executa sem prompts interativos
  --work                  Perfil enxuto de trabalho/VM (padrão: Hyprland + Dev/AGR + Hyper-V)
  --full                  Perfil completo do PC pessoal (445 pacotes)
  --profile=work|full|dev Define o perfil explicitamente
  --hyperv                Ativa otimizações de VM Hyper-V (padrão)
  --no-hyperv             Desativa modo Hyper-V (para hardware físico)
  --with-ad               Executa integração Windows AD/SMB (scripts/setup-ad-smb.sh)
  --ad-env=<arquivo>      Define arquivo de variáveis AD/SMB (implica --with-ad)
  --skip-agr              Pula bootstrap AGR / Antigravity / agr-docs
  --clone-portais         Clona todos os repositórios Portal 1 e 2 via agr-docs
  --agr-docs=<dir>        Caminho do repositório agr-docs (padrão: ~/projetos_agr/agr-docs)
  --help, -h              Mostra esta ajuda
EOF
            exit 0
            ;;
        *)
            warn "Argumento desconhecido ignorado: $arg"
            ;;
    esac
done

info "Iniciando migração Arch Linux + Hyprland (PROFILE=$PROFILE | Hyper-V / AGR)..."

SETUP_ARGS=("--profile=$PROFILE" "$HYPERV_FLAG")
[ "$NON_INTERACTIVE" = true ] && SETUP_ARGS+=(--non-interactive)

info "Etapa 1/4: Executando orquestrador base ($DOTFILES_DIR/setup.sh)..."
bash "$DOTFILES_DIR/setup.sh" "${SETUP_ARGS[@]}"

if [ "$HYPERV_FLAG" = "--hyperv" ]; then
    info "Etapa 2/4: Aplicando integração Hyper-V guest..."
    HV_ARGS=()
    [ "$NON_INTERACTIVE" = true ] && HV_ARGS+=(--non-interactive)
    bash "$DOTFILES_DIR/scripts/setup-hyperv.sh" "${HV_ARGS[@]}"
else
    info "Etapa 2/4: Modo Hyper-V desativado (--no-hyperv)."
fi

if [ "$WITH_AD" = true ] || [ -f "$AD_ENV_FILE" ]; then
    info "Etapa 3/4: Configurando integração Windows AD / SMB..."
    AD_ARGS=("--env-file=$AD_ENV_FILE")
    [ "$NON_INTERACTIVE" = true ] && AD_ARGS+=(--non-interactive)
    bash "$DOTFILES_DIR/scripts/setup-ad-smb.sh" "${AD_ARGS[@]}"
else
    info "Etapa 3/4: Integração AD/SMB opcional pulada (use --with-ad ou crie $AD_ENV_FILE)."
fi

if [ "$WITH_AGR" = true ]; then
    info "Etapa 4/4: Provisionando ambiente AGR + Antigravity + agr-docs..."
    AGR_ARGS=("--agr-docs=$AGR_DOCS_DIR")
    [ "$NON_INTERACTIVE" = true ] && AGR_ARGS+=(--non-interactive)
    [ "$CLONE_PORTAIS" = true ] && AGR_ARGS+=(--clone-portais)
    bash "$DOTFILES_DIR/scripts/setup/05-agr-antigravity.sh" "${AGR_ARGS[@]}"
else
    info "Etapa 4/4: Módulo AGR pulado (--skip-agr)."
fi

ok "Migração Arch Linux + Hyprland concluída!"
echo "Guia completo: $DOTFILES_DIR/docs/GUIA_MIGRACAO_ARCH_HYPERV_AGR.md"
