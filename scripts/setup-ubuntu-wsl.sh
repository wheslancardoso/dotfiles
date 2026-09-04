#!/usr/bin/env bash
# ==============================================================================
# 🚀 Setup de Desenvolvimento Definitivo para Ubuntu 22.04 LTS (WSL2)
# Replicando a suíte de alta produtividade (Arch / Vibe Coding / Mise / LazyVim)
# ==============================================================================

set -euo pipefail

# --- Cores & Utilitários de Log ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

DOTFILES_DIR="${HOME}/dotfiles"
BIN_DIR="${HOME}/.local/bin"
SHARE_DIR="${HOME}/.local/share"

mkdir -p "${BIN_DIR}" "${SHARE_DIR}"
export PATH="${BIN_DIR}:${PATH}"

# Detectar se sudo sem senha está disponível
has_sudo() {
    sudo -n true 2>/dev/null
}

# --- 1. Pacotes de Sistema (APT) & Docker ---
setup_system_and_docker() {
    info "Verificando permissões de sudo para instalação de pacotes APT e Docker..."
    if ! has_sudo; then
        warn "Sudo sem senha não está ativo nesta sessão."
        warn "Para configurar Sudo NOPASSWD, execute no terminal do WSL:"
        echo -e "${YELLOW}  echo \"\$USER ALL=(ALL:ALL) NOPASSWD: ALL\" | sudo tee /etc/sudoers.d/99-\$USER-nopasswd && sudo chmod 440 /etc/sudoers.d/99-\$USER-nopasswd${NC}"
        return 0
    fi

    info "Atualizando repositórios APT e instalando dependências base de desenvolvimento..."
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        zsh \
        unzip \
        tar \
        gzip \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        jq \
        procps \
        net-tools \
        libssl-dev \
        libffi-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        docker.io \
        docker-compose-v2

    ok "Pacotes APT essenciais instalados com sucesso!"

    # Configuração do Docker
    info "Configurando serviço do Docker e permissões de grupo para ${USER}..."
    if getent group docker >/dev/null; then
        sudo usermod -aG docker "${USER}"
    fi

    # Iniciar serviço do docker se o systemd estiver ativo
    if pidof systemd >/dev/null 2>&1 || [ -d /run/systemd/system ]; then
        sudo systemctl enable --now docker.service 2>/dev/null || true
        sudo systemctl enable --now docker.socket 2>/dev/null || true
    else
        sudo service docker start 2>/dev/null || true
    fi
    ok "Docker configurado e adicionado ao grupo do usuário!"
}

# --- 2. CLI Moderna & Ferramentas de Alta Performance ---
setup_modern_cli() {
    info "Instalando ferramentas modernas de terminal em ${BIN_DIR}..."

    # 1. Chezmoi
    if ! command -v chezmoi &>/dev/null; then
        info "Instalando Chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${BIN_DIR}"
        ok "Chezmoi instalado!"
    else
        ok "Chezmoi já instalado."
    fi

    # 2. Neovim (v0.10+ Release Oficial Linux x86_64)
    if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -n 1)" =~ "v0.[0-8]." ]]; then
        info "Instalando Neovim 0.10+ (Release Oficial)..."
        local nvim_tmp
        nvim_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" -o "${nvim_tmp}/nvim.tar.gz"
        rm -rf "${SHARE_DIR}/nvim-linux-x86_64"
        tar -xzf "${nvim_tmp}/nvim.tar.gz" -C "${SHARE_DIR}"
        ln -sfn "${SHARE_DIR}/nvim-linux-x86_64/bin/nvim" "${BIN_DIR}/nvim"
        rm -rf "${nvim_tmp}"
        ok "Neovim instalado: $(nvim --version | head -n 1)"
    else
        ok "Neovim já está na versão adequada: $(nvim --version | head -n 1)"
    fi

    # 3. Starship Prompt
    if ! command -v starship &>/dev/null; then
        info "Instalando Starship Prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y -b "${BIN_DIR}"
        ok "Starship instalado!"
    else
        ok "Starship já instalado."
    fi

    # 4. Zoxide
    if ! command -v zoxide &>/dev/null; then
        info "Instalando Zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | BIN_DIR="${BIN_DIR}" bash
        ok "Zoxide instalado!"
    else
        ok "Zoxide já instalado."
    fi

    # 5. FZF
    if [ ! -d "${HOME}/.fzf" ]; then
        info "Instalando FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
        "${HOME}/.fzf/install" --bin --no-update-rc
        ln -sfn "${HOME}/.fzf/bin/fzf" "${BIN_DIR}/fzf"
        ok "FZF instalado!"
    else
        ok "FZF já instalado."
    fi

    # 6. Ripgrep (rg)
    if ! command -v rg &>/dev/null; then
        info "Instalando Ripgrep..."
        local rg_tmp
        rg_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz" -o "${rg_tmp}/rg.tar.gz"
        tar -xzf "${rg_tmp}/rg.tar.gz" -C "${rg_tmp}"
        cp "${rg_tmp}/ripgrep-14.1.1-x86_64-unknown-linux-musl/rg" "${BIN_DIR}/rg"
        chmod +x "${BIN_DIR}/rg"
        rm -rf "${rg_tmp}"
        ok "Ripgrep instalado!"
    else
        ok "Ripgrep já instalado."
    fi

    # 7. FD (fd)
    if ! command -v fd &>/dev/null; then
        info "Instalando Fd..."
        local fd_tmp
        fd_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz" -o "${fd_tmp}/fd.tar.gz"
        tar -xzf "${fd_tmp}/fd.tar.gz" -C "${fd_tmp}"
        cp "${fd_tmp}/fd-v10.2.0-x86_64-unknown-linux-musl/fd" "${BIN_DIR}/fd"
        chmod +x "${BIN_DIR}/fd"
        rm -rf "${fd_tmp}"
        ok "Fd instalado!"
    else
        ok "Fd já instalado."
    fi

    # 8. Bat (bat)
    if ! command -v bat &>/dev/null; then
        info "Instalando Bat..."
        local bat_tmp
        bat_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz" -o "${bat_tmp}/bat.tar.gz"
        tar -xzf "${bat_tmp}/bat.tar.gz" -C "${bat_tmp}"
        cp "${bat_tmp}/bat-v0.24.0-x86_64-unknown-linux-musl/bat" "${BIN_DIR}/bat"
        chmod +x "${BIN_DIR}/bat"
        rm -rf "${bat_tmp}"
        mkdir -p "$(bat --config-dir)/themes"
        curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" -o "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme" 2>/dev/null || true
        bat cache --build 2>/dev/null || true
        ok "Bat instalado com tema Catppuccin Mocha!"
    else
        ok "Bat já instalado."
    fi

    # 9. Eza (eza)
    if ! command -v eza &>/dev/null; then
        info "Instalando Eza..."
        local eza_tmp
        eza_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/eza-community/eza/releases/download/v0.20.19/eza_x86_64-unknown-linux-musl.tar.gz" -o "${eza_tmp}/eza.tar.gz"
        tar -xzf "${eza_tmp}/eza.tar.gz" -C "${eza_tmp}"
        cp "${eza_tmp}/eza" "${BIN_DIR}/eza"
        chmod +x "${BIN_DIR}/eza"
        rm -rf "${eza_tmp}"
        ok "Eza instalado!"
    else
        ok "Eza já instalado."
    fi

    # 10. Git-Delta (delta)
    if ! command -v delta &>/dev/null; then
        info "Instalando Delta (Git syntax highlighter)..."
        local delta_tmp
        delta_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-musl.tar.gz" -o "${delta_tmp}/delta.tar.gz"
        tar -xzf "${delta_tmp}/delta.tar.gz" -C "${delta_tmp}"
        cp "${delta_tmp}/delta-0.18.2-x86_64-unknown-linux-musl/delta" "${BIN_DIR}/delta"
        chmod +x "${BIN_DIR}/delta"
        rm -rf "${delta_tmp}"
        ok "Delta instalado!"
    else
        ok "Delta já instalado."
    fi

    # 11. Zellij
    if ! command -v zellij &>/dev/null; then
        info "Instalando Zellij..."
        local zj_tmp
        zj_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/zellij-org/zellij/releases/download/v0.41.2/zellij-x86_64-unknown-linux-musl.tar.gz" -o "${zj_tmp}/zellij.tar.gz"
        tar -xzf "${zj_tmp}/zellij.tar.gz" -C "${zj_tmp}"
        cp "${zj_tmp}/zellij" "${BIN_DIR}/zellij"
        chmod +x "${BIN_DIR}/zellij"
        rm -rf "${zj_tmp}"
        ok "Zellij instalado!"
    else
        ok "Zellij já instalado."
    fi

    # 12. Lazygit
    if ! command -v lazygit &>/dev/null; then
        info "Instalando Lazygit..."
        local lg_tmp
        lg_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz" -o "${lg_tmp}/lazygit.tar.gz"
        tar -xzf "${lg_tmp}/lazygit.tar.gz" -C "${lg_tmp}"
        cp "${lg_tmp}/lazygit" "${BIN_DIR}/lazygit"
        chmod +x "${BIN_DIR}/lazygit"
        rm -rf "${lg_tmp}"
        ok "Lazygit instalado!"
    else
        ok "Lazygit já instalado."
    fi

    # 13. Lazydocker
    if ! command -v lazydocker &>/dev/null; then
        info "Instalando Lazydocker..."
        local ld_tmp
        ld_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Linux_x86_64.tar.gz" -o "${ld_tmp}/lazydocker.tar.gz"
        tar -xzf "${ld_tmp}/lazydocker.tar.gz" -C "${ld_tmp}"
        cp "${ld_tmp}/lazydocker" "${BIN_DIR}/lazydocker"
        chmod +x "${BIN_DIR}/lazydocker"
        rm -rf "${ld_tmp}"
        ok "Lazydocker instalado!"
    else
        ok "Lazydocker já instalado."
    fi

    # 14. Fastfetch
    if ! command -v fastfetch &>/dev/null; then
        info "Instalando Fastfetch..."
        local ff_tmp
        ff_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/2.38.0/fastfetch-linux-amd64.tar.gz" -o "${ff_tmp}/ff.tar.gz"
        tar -xzf "${ff_tmp}/ff.tar.gz" -C "${ff_tmp}"
        cp "${ff_tmp}/fastfetch-linux-amd64/usr/bin/fastfetch" "${BIN_DIR}/fastfetch"
        chmod +x "${BIN_DIR}/fastfetch"
        rm -rf "${ff_tmp}"
        ok "Fastfetch instalado!"
    else
        ok "Fastfetch já instalado."
    fi

    # 15. Tree-Sitter (v0.24.4 compatível com GLIBC 2.35 do Ubuntu 22.04)
    if ! command -v tree-sitter &>/dev/null; then
        info "Instalando Tree-Sitter CLI..."
        curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/v0.24.4/tree-sitter-linux-x64.gz" | gunzip > "${BIN_DIR}/tree-sitter"
        chmod +x "${BIN_DIR}/tree-sitter"
        ok "Tree-Sitter instalado!"
    else
        ok "Tree-Sitter já instalado."
    fi

    # Espelhar binários para /usr/local/bin para que fiquem visíveis universalmente
    if has_sudo; then
        sudo ln -sfn "${BIN_DIR}"/* /usr/local/bin/ 2>/dev/null || true
    fi
}

# --- 3. Zsh, Oh My Zsh & Plugins ---
setup_zsh_and_plugins() {
    info "Configurando Oh My Zsh e plugins..."
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        info "Instalando Oh My Zsh..."
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
        ok "Oh My Zsh instalado!"
    else
        ok "Oh My Zsh já instalado."
    fi

    local zsh_custom="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

    # Plugins
    if [ ! -d "${zsh_custom}/plugins/zsh-autosuggestions" ]; then
        info "Instalando plugin zsh-autosuggestions..."
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${zsh_custom}/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "${zsh_custom}/plugins/zsh-syntax-highlighting" ]; then
        info "Instalando plugin zsh-syntax-highlighting..."
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${zsh_custom}/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -d "${zsh_custom}/plugins/fzf-tab" ]; then
        info "Instalando plugin fzf-tab..."
        git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git "${zsh_custom}/plugins/fzf-tab"
    fi

    ok "Plugins do Zsh instalados!"

    # Trocar shell padrão para zsh se zsh estiver instalado
    if command -v zsh &>/dev/null; then
        local zsh_path
        zsh_path="$(which zsh)"
        if [ "${SHELL:-}" != "${zsh_path}" ]; then
            info "Definindo ${zsh_path} como shell padrão..."
            if has_sudo; then
                sudo chsh -s "${zsh_path}" "${USER}" || chsh -s "${zsh_path}" || true
                ok "Shell padrão alterado para Zsh!"
            else
                chsh -s "${zsh_path}" || warn "Execute 'chsh -s ${zsh_path}' no terminal para tornar o Zsh seu shell padrão."
            fi
        fi
    fi
}

# --- 4. Dotfiles & Chezmoi (Modo Symlink) ---
setup_dotfiles_chezmoi() {
    info "Configurando e aplicando Dotfiles com Chezmoi..."
    mkdir -p "${HOME}/.config" "${HOME}/.local/share"

    ln -sfn "${DOTFILES_DIR}" "${HOME}/.local/share/chezmoi"

    # Inicializar e aplicar Chezmoi
    info "Aplicando Chezmoi em modo symlink..."
    chezmoi init --source "${DOTFILES_DIR}" --apply --mode symlink --force

    # Garantir que ~/.bashrc também aponte ou carregue o dot_bashrc
    if [ ! -L "${HOME}/.bashrc" ] && [ -f "${DOTFILES_DIR}/home/dot_bashrc" ]; then
        if [ -f "${HOME}/.bashrc" ] && ! grep -q "Super Bash Config" "${HOME}/.bashrc"; then
            cp "${HOME}/.bashrc" "${HOME}/.bashrc.bak"
        fi
        ln -sf "${DOTFILES_DIR}/home/dot_bashrc" "${HOME}/.bashrc"
    fi

    # Garantir symlink do .gitconfig
    if [ -f "${DOTFILES_DIR}/home/dot_gitconfig" ]; then
        ln -sf "${DOTFILES_DIR}/home/dot_gitconfig" "${HOME}/.gitconfig"
    fi

    ok "Dotfiles aplicados com sucesso via symlinks!"
}

# --- 5. Runtimes de Desenvolvimento via Mise ---
setup_mise_and_runtimes() {
    info "Configurando Mise e runtimes de desenvolvimento..."
    if ! command -v mise &>/dev/null; then
        info "Instalando Mise..."
        curl -fsSL https://mise.run | sh
        ok "Mise instalado!"
    fi

    mkdir -p "${HOME}/.config/mise"
    if [ -f "${DOTFILES_DIR}/home/dot_config/mise/config.toml" ]; then
        ln -sf "${DOTFILES_DIR}/home/dot_config/mise/config.toml" "${HOME}/.config/mise/config.toml"
    fi

    info "Instalando runtimes definidas no config.toml do Mise (Node LTS, Bun, Pnpm, Python 3.12, Go, Java)..."
    "${BIN_DIR}/mise" install -y || warn "Algum runtime pode precisar de conexão ativa ou dependências nativas para compilar."

    ok "Runtimes do Mise sincronizadas com sucesso!"
}

# --- 6. Bootstrap do LazyVim ---
setup_lazyvim() {
    info "Inicializando plugins do LazyVim via Neovim..."
    if command -v nvim &>/dev/null && [ -d "${HOME}/.config/nvim" ]; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        ok "LazyVim sincronizado!"
    fi
}

# --- Execução Principal ---
main() {
    echo -e "${BOLD}${BLUE}"
    echo "=================================================================="
    echo " 🚀 Provisionamento Definitivo do WSL2 Ubuntu 22.04"
    echo "=================================================================="
    echo -e "${NC}"

    case "${1:-all}" in
        --system)
            setup_system_and_docker
            ;;
        --cli)
            setup_modern_cli
            ;;
        --zsh)
            setup_zsh_and_plugins
            ;;
        --dotfiles)
            setup_dotfiles_chezmoi
            ;;
        --mise)
            setup_mise_and_runtimes
            ;;
        all|*)
            setup_system_and_docker
            setup_modern_cli
            setup_zsh_and_plugins
            setup_dotfiles_chezmoi
            setup_mise_and_runtimes
            setup_lazyvim
            ;;
    esac

    echo -e "${BOLD}${GREEN}"
    echo "=================================================================="
    echo " 🎉 Ambiente WSL2 Ubuntu 22.04 Preparado com Sucesso!"
    echo "=================================================================="
    echo -e "${NC}"
    echo -e "Para testar e entrar no ecossistema:"
    echo -e "1. ${BLUE}zsh${NC}                     : Entra no shell Zsh com Starship e plugins"
    echo -e "2. ${BLUE}nvim${NC}                    : Abre o LazyVim 0.10+ configurado"
    echo -e "3. ${BLUE}zellij --layout vibe${NC}    : Inicia o ambiente Vibe Coding"
    echo -e "4. ${BLUE}lazygit${NC} / ${BLUE}lg${NC}           : TUI Git com Catppuccin e Delta"
    echo -e "5. ${BLUE}mise list${NC}               : Exibe as linguagens ativas (Node, Bun, Python, Go, Java)"
    echo -e "=================================================================="
}

main "$@"
