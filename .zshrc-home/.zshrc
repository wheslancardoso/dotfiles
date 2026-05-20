# 🚀 Super Zsh Config - Antigravity Edition

# Path do Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Plugins
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

# 🌟 Starship Prompt
eval "$(starship init zsh)"

# 🎨 Aliases Modernos
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lbh --icons --group-directories-first'
    alias la='eza -labh --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias dog='bat' # Versão completa com line numbers
fi

# 🔍 FZF Enhancements
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color='hl:#76c1ff,hl+:#76c1ff'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# ⌨️ Vi Mode
export KEYTIMEOUT=1

# 📂 Yazi Wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# 🛠️ Mise & Dev
eval "$(mise activate zsh)"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Custom Bin Path
export PATH="/home/lan/.local/bin:$PATH"

# 🔑 Keyring
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(gnome-keyring-daemon --start --components=secrets,pkcs11)
    export SSH_AUTH_SOCK
fi
