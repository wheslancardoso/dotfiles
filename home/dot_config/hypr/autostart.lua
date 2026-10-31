-- Autostart Applications & Services
local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"

hl.on("hyprland.start", function()
    -- 1. Script de inicialização primária (se necessário)
    hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")

    -- 2. Wallpaper Daemon & Restauração Inteligente
    hl.exec_cmd("awww-daemon --format xrgb")
    hl.exec_cmd([[bash -c 'wp=$(cat ~/.cache/current_wallpaper 2>/dev/null); [ -f "$wp" ] || wp="$HOME/pictures/wallpapers/Night_City.png"; [ -f "$wp" ] || wp="$HOME/Pictures/wallpapers/Night_City.png"; [ -f "$wp" ] || wp="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"; awww query || awww-daemon --format xrgb; awww img "$wp"; "$HOME/.config/hypr/scripts/WallustSwww.sh" "$wp" &']])

    -- 3. Ambiente do Sistema & D-Bus / Systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_USE_PORTAL GNOME_KEYRING_CONTROL GNOME_KEYRING_PID SSH_AUTH_SOCK")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh,pkcs11")

    -- 4. Terminal Flutuante Scratchpad em Segundo Plano
    hl.exec_cmd('kitty --class="scratchpad_term" &')

    -- 5. Daemons de UI, Bandeja & Rede
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd(scriptsDir .. "/waybar-watchdog.sh")
    hl.exec_cmd("qs -c overview")
    hl.exec_cmd("qs")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(scriptsDir .. "/Hyprsunset.sh init")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd(scriptsDir .. "/KeybindsLayoutInit.sh")

    -- 6. Clipboard Managers (Cliphist + CopyQ)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("copyq")

    -- 7. Pipeline de Áudio, Equalização & Notificações
    hl.exec_cmd([[bash -c 'amixer -c 1 set Headphone 100% unmute 2>/dev/null; amixer -c 1 set Master 100% unmute 2>/dev/null; amixer -c 1 set Front 100% unmute 2>/dev/null || true']])
    hl.exec_cmd([[bash -c 'sleep 2; easyeffects --hide-window & sleep 2; easyeffects -l "Bass Multiplying + Perfect EQ" 2>/dev/null; easyeffects -l "Podcast_Studio_Mic" 2>/dev/null || true']])
    hl.exec_cmd(UserScripts .. "/MusicNotification.sh")

    -- 8. Integrações & Utilitários
    hl.exec_cmd("hyprpm reload -n || true")
    hl.exec_cmd("kdeconnect-indicator &")
    hl.exec_cmd("python3 " .. home .. "/dotfiles/scripts/capslock-indicator.py &")
end)
