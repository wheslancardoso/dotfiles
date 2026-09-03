# 🚀 Super Zsh Config - Ultimate Antigravity Edition

# --- Path & Environment ---
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"

# Adicionando binários locais ao PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Android SDK (suporte a lowercase e uppercase)
for p in "$HOME/android/sdk" "$HOME/Android/Sdk"; do
    if [ -d "$p" ]; then
        export ANDROID_HOME="$p"
        export PATH="$PATH:$ANDROID_HOME/emulator"
        export PATH="$PATH:$ANDROID_HOME/platform-tools"
        export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
        export PATH="$PATH:$ANDROID_HOME/build-tools"
        break
    fi
done

# --- Plugins (Oh My Zsh) ---
plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    vi-mode
    fzf
    sudo
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

# --- Prompt & Navegação ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- Aliases de Produtividade ---
# Modern Tools
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lbh --icons --group-directories-first'
    alias la='eza -labh --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias dog='bat'
fi

# Git & Dev
alias lg='lazygit'
alias ld='lazydocker'
alias gs='git status'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias vim='nvim'

# 👑 Vim King & Ajuda Interativa
alias vk='$HOME/dotfiles/scripts/vim-king.sh'
alias vim-king='$HOME/dotfiles/scripts/vim-king.sh'

# 🚀 Vibe Coding & Layouts Zellij
alias vibe='zellij --layout vibe'
alias fullstack='zellij --layout fullstack'
alias mobile='zellij --layout mobile'

# 📱 Mobile Dev (scrcpy sem lag)
alias scrcpy-dev='scrcpy --always-on-top --window-title "Mobile Emulator Device"'

# 🧹 Organizador Master
alias organizar='python3 ~/dotfiles/scripts/organizador/main.py'

# Docker
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'

# --- Utilitários ---
# Yazi CWD Wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Mise (SDK Manager)
eval "$(mise activate zsh)"

# Keyring
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(gnome-keyring-daemon --start --components=secrets,pkcs11)
    export SSH_AUTH_SOCK
fi

# --- Vi Mode Settings ---
export KEYTIMEOUT=1
# Bindings para busca no histórico com setas ou j/k
bindkey '^[[A' zsh-history-substring-search-up
bindkey '^[[B' zsh-history-substring-search-down
bindkey -M vicmd 'k' zsh-history-substring-search-up
bindkey -M vicmd 'j' zsh-history-substring-search-down
