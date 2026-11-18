#!/usr/bin/env bash
# ==============================================================================
# Módulo 05: Bootstrap AGR Dev (Arch) + Sync Antigravity (~/.gemini) + agr-docs
# Idempotente e modular. Coordena com /home/lanwsl/projetos_agr/agr-docs/agr.sh.
# ==============================================================================
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

AGR_DOCS_DIR="${AGR_DOCS_DIR:-$HOME/projetos_agr/agr-docs}"
AGR_CLONE_PORTAIS="${AGR_CLONE_PORTAIS:-false}"
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"

for arg in "$@"; do
    case "$arg" in
        --clone-portais) AGR_CLONE_PORTAIS=true ;;
        --non-interactive|-y|--yes) NON_INTERACTIVE=true ;;
        --agr-docs=*) AGR_DOCS_DIR="${arg#*=}" ;;
        *) ;;
    esac
done

install_agr_arch_packages() {
    if ! has_cmd pacman; then
        warn "pacman não encontrado; pulando instalação de pacotes AGR do Arch."
        return 0
    fi

    local agr_pkgs=(
        jdk8-openjdk jdk17-openjdk maven
        mariadb mariadb-clients
        chromium
        tmux iproute2 lsof openbsd-netcat
        cifs-utils smbclient
        git curl unzip jq python
    )

    info "Instalando dependências de desenvolvimento AGR no Arch Linux..."
    sudo pacman -S --needed --noconfirm "${agr_pkgs[@]}" || {
        for pkg in "${agr_pkgs[@]}"; do
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Falha ao instalar pacote AGR: $pkg"
        done
    }

    # Chromium / Edge symlink fallback para Puppeteer/E2E se necessário
    if has_cmd chromium && [ ! -e /usr/bin/google-chrome ] && has_cmd yay; then
        info "Chromium instalado em $(command -v chromium) para testes E2E."
    fi

    ok "Pacotes base AGR instalados."
}

setup_agr_mise_runtimes() {
    export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
    if ! has_cmd mise; then
        warn "mise não encontrado; runtimes Node/Java/Maven dependerão dos pacotes do sistema."
        return 0
    fi

    info "Provisionando runtimes AGR via mise (Java 17/8, Maven 3.8.7, Node LTS & 14, pnpm)..."
    mkdir -p "$HOME/.config/mise"
    if [ ! -f "$HOME/.config/mise/config.toml" ] && [ -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" ]; then
        cp -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" "$HOME/.config/mise/config.toml"
    fi

    mise install -y 2>/dev/null || warn "Algum runtime padrão do mise falhou."
    # Runtimes específicos usados pelos Portais 1 e 2 da AGR (Angular 7/13 + Java 8)
    mise install -y "node@14.21.3" 2>/dev/null || warn "Não foi possível instalar node@14.21.3 via mise."
    mise install -y "java@temurin-8" 2>/dev/null || warn "Não foi possível instalar java@temurin-8 via mise (jdk8-openjdk via pacman disponível)."
    ok "Runtimes AGR via mise sincronizadas."
}

setup_mariadb_local() {
    if ! has_cmd mariadb-install-db && ! has_cmd mysql_install_db; then
        return 0
    fi

    if [ ! -d /var/lib/mysql/mysql ]; then
        info "Inicializando diretório de dados local do MariaDB..."
        sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql 2>/dev/null || \
            warn "mariadb-install-db falhou; verifique manualmente."
    fi

    if has_systemd && systemctl list-unit-files mariadb.service >/dev/null 2>&1; then
        sudo systemctl enable --now mariadb.service 2>/dev/null || warn "Não foi possível iniciar mariadb.service."
        ok "MariaDB local habilitado."
    fi
}

setup_antigravity_sync() {
    local antigravity_script="$DOTFILES_DIR/scripts/setup-antigravity.sh"
    if [ -f "$antigravity_script" ]; then
        info "Sincronizando Antigravity (~/.gemini/config: MCPs, rules, skills, plugins)..."
        bash "$antigravity_script" || warn "setup-antigravity.sh retornou aviso."
    else
        warn "Script $antigravity_script não encontrado."
    fi

    # Garante também symlinks/diretórios de compatibilidade em ~/.gemini/antigravity e ~/.gemini/config
    mkdir -p "$HOME/.gemini/config/rules" "$HOME/.gemini/config/skills"
    ok "Sincronização Antigravity (~/.gemini) concluída."
}

integrate_agr_docs() {
    if [ ! -d "$AGR_DOCS_DIR" ]; then
        for candidate in "$HOME/projetos_agr/agr-docs" "$HOME/projetos/agr-docs" "$HOME/agr-docs"; do
            if [ -d "$candidate" ] && [ -f "$candidate/agr.sh" ]; then
                AGR_DOCS_DIR="$candidate"
                break
            fi
        done
    fi

    if [ ! -d "$AGR_DOCS_DIR" ]; then
        warn "Repositório agr-docs não encontrado em $AGR_DOCS_DIR (clone-o em ~/projetos_agr/agr-docs e rode './agr.sh setup'). Pulei o bootstrap do agr-docs."
        return 0
    fi

    local agr_cli="$AGR_DOCS_DIR/agr.sh"
    if [ ! -f "$agr_cli" ]; then
        warn "CLI $agr_cli não encontrado em $AGR_DOCS_DIR."
        return 0
    fi

    chmod +x "$agr_cli" 2>/dev/null || true

    info "Executando bootstrap Linux do agr-docs ($agr_cli setup)..."
    local setup_flags=()
    [ "$NON_INTERACTIVE" = true ] && setup_flags+=(--non-interactive)
    (cd "$AGR_DOCS_DIR" && bash "$agr_cli" setup "${setup_flags[@]}") || warn "agr.sh setup retornou aviso."

    # Configura credenciais GitLab para clonagem unattended se gitlab.txt ou env vars existirem
    if [ -f "$AGR_DOCS_DIR/gitlab.txt" ] || { [ -n "${GITLAB_USER:-}" ] && [ -n "${GITLAB_TOKEN:-${GITLAB_PASS:-}}" ]; }; then
        info "Configurando autenticação GitLab via agr-docs (git-auth)..."
        (cd "$AGR_DOCS_DIR" && bash "$agr_cli" git-auth --non-interactive) || warn "agr.sh git-auth retornou aviso."
    else
        info "Arquivo $AGR_DOCS_DIR/gitlab.txt não encontrado; pulando git-auth automático."
    fi

    if [ "$AGR_CLONE_PORTAIS" = true ]; then
        info "Clonando/atualizando portais AGR via agr-docs (clonar todos)..."
        (cd "$AGR_DOCS_DIR" && bash "$agr_cli" clonar todos --non-interactive) || warn "agr.sh clonar retornou aviso."
        info "Gerando rules nos repositórios AGR (rules)..."
        (cd "$AGR_DOCS_DIR" && bash "$agr_cli" rules) || warn "agr.sh rules retornou aviso."
    fi

    info "Validando ambiente AGR via agr-docs (validar)..."
    (cd "$AGR_DOCS_DIR" && bash "$agr_cli" validar) || warn "agr.sh validar encontrou pendências (verifique saída acima)."
    ok "Integração com agr-docs finalizada."
}

install_agr_arch_packages
setup_agr_mise_runtimes
setup_mariadb_local
setup_antigravity_sync
integrate_agr_docs

ok "Módulo 05 (AGR + Antigravity) concluído."
