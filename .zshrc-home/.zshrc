# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    vi-mode
    fzf
    sudo
    zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings and enhancements
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color='hl:#76c1ff,hl+:#76c1ff'"

# Keytimeout for faster mode switching in vi-mode
export KEYTIMEOUT=1

# Zsh History Substring Search bindings
# Set up arrow keys for substring search in history
bindkey '^[[A' zsh-history-substring-search-up
bindkey '^[[B' zsh-history-substring-search-down
# Bind k and j in vicmd mode
bindkey -M vicmd 'k' zsh-history-substring-search-up
bindkey -M vicmd 'j' zsh-history-substring-search-down

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# Inicializar gnome-keyring e exportar variáveis se não estiverem presentes
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(gnome-keyring-daemon --start --components=secrets,pkcs11)
    export SSH_AUTH_SOCK
fi

# Set up Mise (modern asdf alternative)
eval "$(mise activate zsh)"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
eval "$(mise activate zsh)"


# Added by Antigravity CLI installer
export PATH="/home/lan/.local/bin:$PATH"
