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

# 🎨 Catppuccin Mocha - Syntax Highlighting de Alto Contraste
set -g fish_color_normal cdd6f4
set -g fish_color_command a6e3a1 --bold
set -g fish_color_keyword cba6f7 --bold
set -g fish_color_quote f9e2af
set -g fish_color_redirection fab387
set -g fish_color_end f9e2af
set -g fish_color_error f38ba8 --bold
set -g fish_color_param 89b4fa
set -g fish_color_comment 6c7086
set -g fish_color_selection --background=313244
set -g fish_color_search_match --background=313244
set -g fish_color_operator 94e2d5
set -g fish_color_escape fab387
set -g fish_color_autosuggestion 7f849c
set -g fish_color_cancel f38ba8
set -g fish_pager_color_prefix 89b4fa --bold
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description 6c7086

# Aliases
alias vim="nvim"
alias lg="lazygit"
alias ld="lazydocker"
alias vk="$HOME/dotfiles/scripts/vim-king.sh"
alias vim-king="$HOME/dotfiles/scripts/vim-king.sh"
alias vibe="zellij --layout vibe"
alias fullstack="zellij --layout fullstack"
alias mobile="zellij --layout mobile"
# 🧹 Organizador Master & Taxonomia
alias organizar="python3 $HOME/dotfiles/scripts/organizador/main.py"
alias vincular_linux="bash $HOME/dotfiles/scripts/vincular_linux.sh"

# 📦 Descompactador Universal (x arquivo.zip/tar/7z/rar)
alias x="bash $HOME/dotfiles/scripts/yazi-archive.sh extract-sub"

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
alias dl="bash $HOME/dotfiles/scripts/media-download.sh"

# 🎧 Presets de Áudio (EasyEffects & Graves Hip-Hop)
alias bass="bash $HOME/dotfiles/scripts/audio-preset-switch.sh bass"
alias hiphop="bash $HOME/dotfiles/scripts/audio-preset-switch.sh bass"
alias bass-max="bash $HOME/dotfiles/scripts/audio-preset-switch.sh bass-max"
alias bass808="bash $HOME/dotfiles/scripts/audio-preset-switch.sh bass-max"
alias dolby="bash $HOME/dotfiles/scripts/audio-preset-switch.sh dolby"
alias audio-flat="bash $HOME/dotfiles/scripts/audio-preset-switch.sh flat"
alias audio-menu="bash $HOME/dotfiles/scripts/audio-preset-switch.sh menu"
alias presets="bash $HOME/dotfiles/scripts/audio-preset-switch.sh menu"
alias fix-spicetify="bash $HOME/dotfiles/scripts/setup-spicetify.sh"
alias spicetify-setup="bash $HOME/dotfiles/scripts/setup-spicetify.sh"
alias spt="spotify-player"
alias spotify-tui="spotify-player"

# 🧹 Manutenção & Otimização do Arch (Safe Update & Auto-Cura)
alias clean-system="bash $HOME/dotfiles/scripts/clean-system.sh"
alias pacup="bash $HOME/dotfiles/scripts/safe-update.sh"
alias safe-update="bash $HOME/dotfiles/scripts/safe-update.sh"

# 🛠️ Ferramentas de Auto-Cura (Zero Dor de Cabeça no Arch)
alias fix-pacman="bash $HOME/dotfiles/scripts/fix-pacman.sh"
alias fix-keys="bash $HOME/dotfiles/scripts/fix-keys.sh"
alias fix-mirrors="bash $HOME/dotfiles/scripts/fix-mirrors.sh"
alias fix-audio="bash $HOME/dotfiles/scripts/fix-audio.sh"
alias audio-presets="bash $HOME/dotfiles/scripts/setup-audio-presets.sh"
alias fix-bass="bash $HOME/dotfiles/scripts/setup-audio-presets.sh"
alias fix-pendrive="bash $HOME/dotfiles/scripts/fix-pendrive.sh"
alias fix-ntfs="bash $HOME/dotfiles/scripts/fix-pendrive.sh"
alias fix-suspend="bash $HOME/dotfiles/scripts/fix-suspend.sh"

# ⌨️ Buscador Universal de Atalhos & Comandos
alias keys="bash $HOME/dotfiles/scripts/cheat-keys.sh"
alias ajuda="bash $HOME/dotfiles/scripts/cheat-keys.sh"
alias atalhos="bash $HOME/dotfiles/scripts/cheat-keys.sh"

# 🦁 Brave Sync
alias brave-sync="bash $HOME/dotfiles/scripts/brave-sync.sh"

# ☁️ Google Drive 5TB (Rclone VFS)
alias gdrive="bash $HOME/dotfiles/scripts/gdrive-mount.sh"

# 🐳 Docker Databases Suite
alias db-up="docker compose -f ~/dotfiles/dev/databases/docker-compose.yml up -d"
alias db-down="docker compose -f ~/dotfiles/dev/databases/docker-compose.yml down"
alias db-status="docker compose -f ~/dotfiles/dev/databases/docker-compose.yml ps"
alias db-logs="docker compose -f ~/dotfiles/dev/databases/docker-compose.yml logs -f"
alias db-reset="docker compose -f ~/dotfiles/dev/databases/docker-compose.yml down -v"

# ⚡ Mise (SDK & Runtime Manager) Power Aliases
alias m="mise"
alias mi="mise install"
alias mu="mise use"
alias mls="mise list"
alias mout="mise outdated"
alias mup="mise upgrade"

# 🗑️ Lixeira Inteligente (trash-cli)
alias tp="trash-put"
alias trash="trash-put"
alias tl="trash-list"
alias trash-list="trash-list"
alias trestore="trash-restore"
alias trash-restore="trash-restore"
alias tempty="trash-empty"
alias trash-empty="trash-empty"

# 🎛️ Modos de Energia & Silêncio (power-profiles-daemon)
alias perf='powerprofilesctl set performance 2>/dev/null; and notify-send -u low -i preferences-system-power "Energia" "Modo Performance Máxima Ativado"; or true'
alias balanced='powerprofilesctl set balanced 2>/dev/null; and notify-send -u low -i preferences-system-power "Energia" "Modo Equilibrado Ativado"; or true'
alias quiet='powerprofilesctl set power-saver 2>/dev/null; and notify-send -u low -i preferences-system-power "Energia" "Modo Silêncio Ativado"; or true'
alias saver='powerprofilesctl set power-saver 2>/dev/null; and notify-send -u low -i preferences-system-power "Energia" "Modo Economia Ativado"; or true'

# 📋 clip: Tubulação direta pro Clipboard do Hyprland
function clip
    if not isatty stdin
        if command -v wl-copy >/dev/null
            wl-copy
        else if command -v xclip >/dev/null
            xclip -selection clipboard
        end
    else if test (count $argv) -gt 0
        if command -v wl-copy >/dev/null
            echo -n "$argv" | wl-copy
        else if command -v xclip >/dev/null
            echo -n "$argv" | xclip -selection clipboard
        end
    else
        echo "Uso: comando | clip   OU   clip \"texto a copiar\""
    end
end

# 📱 qr: Gerador Instantâneo de QR Code no terminal
function qr
    set text ""
    if not isatty stdin
        set text (command cat)
    else if test (count $argv) -gt 0
        set text "$argv"
    else
        if command -v wl-paste >/dev/null
            set text (wl-paste)
        else if command -v xclip >/dev/null
            set text (xclip -selection clipboard -o)
        end
    end

    if test -z "$text"
        echo "Uso: qr <texto/url>  OU  comando | qr  OU  apenas 'qr' (lê do clipboard)"
        return 1
    end

    if command -v qrencode >/dev/null
        echo ""
        qrencode -t ANSIUTF8 "$text"
        echo ""
        echo "📱 Aponte a câmera do celular para escanear"
    else
        echo "Instalando qrencode..."
        sudo pacman -S --noconfirm qrencode 2>/dev/null; and qrencode -t ANSIUTF8 "$text"
    end
end

