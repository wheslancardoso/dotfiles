source /usr/share/cachyos-fish-config/cachyos-config.fish 2>/dev/null; or true

# Environment variables
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"
set -gx PATH "$HOME/.local/bin" "$HOME/bin" $PATH

# Android SDK
if test -d "$HOME/Android/Sdk"
    set -gx ANDROID_HOME "$HOME/Android/Sdk"
    set -gx PATH $PATH "$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools" "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/build-tools"
end

# Integrations
if command -v starship >/dev/null
    starship init fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
end

if command -v mise >/dev/null
    mise activate fish | source
end

# Aliases
alias vim="nvim"
alias lg="lazygit"
alias ld="lazydocker"
alias vk="$HOME/dotfiles/scripts/vim-king.sh"
alias vim-king="$HOME/dotfiles/scripts/vim-king.sh"
alias vibe="zellij --layout vibe"
alias fullstack="zellij --layout fullstack"
alias mobile="zellij --layout mobile"
alias scrcpy-dev='scrcpy --always-on-top --window-title "Mobile Emulator Device"'
alias organizar="python3 $HOME/dotfiles/scripts/organizador/main.py"

# Yazi CWD Wrapper (troca de pasta automaticamente ao sair)
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Manutenção do Sistema Arch Linux
alias cleanup="bash $HOME/dotfiles/scripts/sys-maintenance.sh cleanup"
alias sys-update="bash $HOME/dotfiles/scripts/sys-maintenance.sh update"
