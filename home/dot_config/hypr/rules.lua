-- Window & Layer Rules Configuration

local function wr(match_tbl, actions_tbl)
    local rule = { match = match_tbl }
    for k, v in pairs(actions_tbl) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

local function lr(namespace, actions_tbl)
    local rule = { match = { namespace = namespace } }
    for k, v in pairs(actions_tbl) do
        rule[k] = v
    end
    hl.layer_rule(rule)
end

-- ==============================================================================
-- 🏷️ TAGS DE CATEGORIAS DE APLICATIVOS
-- ==============================================================================
wr({ class = "^([Ff]irefox|org\\.mozilla\\.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" }, { tag = "+browser" })
wr({ class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, { tag = "+browser" })
wr({ class = "^(chrome-.+-Default)$" }, { tag = "+browser" })
wr({ class = "^([Cc]hromium)$" }, { tag = "+browser" })
wr({ class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" }, { tag = "+browser" })
wr({ class = "^(Brave-browser(-beta|-dev|-unstable)?)$" }, { tag = "+browser" })
wr({ class = "^([Tt]horium-browser|[Cc]achy-browser)$" }, { tag = "+browser" })
wr({ class = "^(zen-alpha|zen)$" }, { tag = "+browser" })

wr({ class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" }, { tag = "+notif" })

wr({ title = "^(KooL Quick Cheat Sheet)$" }, { tag = "+KooL_Cheat" })
wr({ title = "^(KooL Hyprland Settings)$" }, { tag = "+KooL_Settings" })
wr({ class = "^(nwg-displays|nwg-look)$" }, { tag = "+KooL-Settings" })

wr({ class = "^(Alacritty|kitty|kitty-dropterm)$" }, { tag = "+terminal" })

wr({ class = "^([Tt]hunderbird|org\\.mozilla\\.Thunderbird)$" }, { tag = "+email" })
wr({ class = "^(eu\\.betterbird\\.Betterbird)$" }, { tag = "+email" })
wr({ class = "^(org\\.gnome\\.Evolution)$" }, { tag = "+email" })

wr({ class = "^(codium|codium-url-handler|VSCodium)$" }, { tag = "+projects" })
wr({ class = "^(VSCode|code|code-url-handler)$" }, { tag = "+projects" })
wr({ class = "^(jetbrains-.+)$" }, { tag = "+projects" })
wr({ class = "^(dev\\.zed\\.Zed|antigravity)$" }, { tag = "+projects" })

wr({ class = "^(com\\.obsproject\\.Studio)$" }, { tag = "+screenshare" })

wr({ class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" }, { tag = "+im" })
wr({ class = "^([Ff]erdium)$" }, { tag = "+im" })
wr({ class = "^([Ww]hatsapp-for-linux)$" }, { tag = "+im" })
wr({ class = "^(org\\.telegram\\.desktop|io\\.github\\.tdesktop_x64\\.TDesktop)$" }, { tag = "+im" })
wr({ class = "^(teams-for-linux)$" }, { tag = "+im" })
wr({ class = "^(im\\.riot\\.Riot|Element)$" }, { tag = "+im" })

wr({ class = "^(gamescope)$" }, { tag = "+games" })
wr({ class = "steam_app_\\d+" }, { tag = "+games" })

wr({ class = "^([Ss]team)$" }, { tag = "+gamestore" })
wr({ title = "^([Ll]utris)$" }, { tag = "+gamestore" })
wr({ class = "^(com\\.heroicgameslauncher\\.hgl)$" }, { tag = "+gamestore" })
wr({ class = "^([Hh]ydra|hydralauncher)$" }, { tag = "+gamestore" })

wr({ class = "^([Tt]hunar|org\\.gnome\\.Nautilus|[Pp]cmanfm-qt)$" }, { tag = "+file-manager" })
wr({ class = "^(app\\.drey\\.Warp)$" }, { tag = "+file-manager" })

wr({ class = "^([Ww]aytrogen)$" }, { tag = "+wallpaper" })
wr({ class = "^([Aa]udacious)$" }, { tag = "+multimedia" })
wr({ class = "^([Mm]pv|vlc)$" }, { tag = "+multimedia_video" })

wr({ title = "^(ROG Control)$" }, { tag = "+settings" })
wr({ class = "^(wihotspot(-gui)?)$" }, { tag = "+settings" })
wr({ class = "^([Bb]aobab|org\\.gnome\\.[Bb]aobab)$" }, { tag = "+settings" })
wr({ class = "^(gnome-disks|wihotspot(-gui)?)$" }, { tag = "+settings" })
wr({ title = "Kvantum Manager" }, { tag = "+settings" })
wr({ class = "^(file-roller|org\\.gnome\\.FileRoller)$" }, { tag = "+settings" })
wr({ class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, { tag = "+settings" })
wr({ class = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol|com\\.saivert\\.pwvucontrol)$" }, { tag = "+settings" })
wr({ class = "^(qt5ct|qt6ct)$" }, { tag = "+settings" })
wr({ class = "xdg-desktop-portal-gtk" }, { tag = "+settings" })
wr({ class = "^(org\\.kde\\.polkit-kde-authentication-agent-1)$" }, { tag = "+settings" })
wr({ class = "^([Rr]ofi)$" }, { tag = "+settings" })
wr({ class = "^(btrfs-assistant)$" }, { tag = "+settings" })
wr({ class = "^(timeshift-gtk)$" }, { tag = "+settings" })

wr({ class = "^(gnome-system-monitor|org\\.gnome\\.SystemMonitor|io\\.missioncenter\\.MissionCenter)$" }, { tag = "+viewer" })
wr({ class = "^(evince)$" }, { tag = "+viewer" })
wr({ class = "^(eog|org\\.gnome\\.Loupe)$" }, { tag = "+viewer" })

-- ==============================================================================
-- 🎨 REGRAS BASEADAS EM TAGS
-- ==============================================================================
wr({ tag = "multimedia_video" }, { no_blur = true, opacity = 1.0 })
wr({ tag = "multimedia" }, { no_blur = true, opacity = 1.0 })
wr({ tag = "KooL_Cheat" }, { center = true, float = true, size = "(monitor_w*0.65) (monitor_h*0.9)" })
wr({ tag = "KooL-Settings" }, { center = true, float = true })
wr({ tag = "wallpaper" }, { float = true, center = true, size = "(monitor_w*0.7) (monitor_h*0.7)" })
wr({ tag = "settings" }, { float = true, center = true, size = "(monitor_w*0.7) (monitor_h*0.7)", opacity = "0.8 0.7 1.0" })
wr({ tag = "viewer" }, { float = true, center = true, opacity = "0.82 0.75 1.0" })
wr({ tag = "browser" }, { opacity = "0.99 0.8 1.0" })
wr({ tag = "projects" }, { opacity = "0.9 0.8 1.0" })
wr({ tag = "im" }, { opacity = "0.94 0.86 1.0" })
wr({ tag = "file-manager" }, { opacity = "0.9 0.8 1.0" })
wr({ tag = "terminal" }, { opacity = "0.9 0.7 1.0" })
wr({ tag = "games" }, { no_blur = true, fullscreen = 0 })

-- ==============================================================================
-- 🪟 REGRAS ESPECÍFICAS DE APLICATIVOS (USERCONFIGS)
-- ==============================================================================
-- CopyQ Clipboard Manager
wr({ class = "^(com\\.github\\.hluk\\.copyq|copyq|CopyQ)$" }, { float = true, center = true, size = "55% 65%" })

-- Yazi Floating File Manager
wr({ class = "^(yazi_picker|floating_yazi)$" }, { float = true, center = true, size = "52% 62%", opacity = "0.95 0.90", rounding = 12 })
wr({ title = "^(yazi-float)$" }, { float = true, center = true, size = "52% 62%", opacity = "0.95 0.90", rounding = 12, border_color = "rgb(76c1ff)" })

-- EasyEffects
wr({ class = "^(com\\.github\\.wwmm\\.easyeffects)$" }, { float = true, center = true, size = "70% 70%" })

-- Gamescope
wr({ class = "^(gamescope)$" }, { workspace = "8", fullscreen = 1, immediate = true })

-- Picture-in-Picture
wr({ title = "^(Picture-in-Picture)$" }, { float = true, pin = true, move = "72% 7%", opacity = "0.95 0.75", keep_aspect_ratio = true, size = "(monitor_w*0.3) (monitor_h*0.3)" })

-- Vesktop / Discord
wr({ class = "^(Vesktop|vesktop)$" }, { opacity = "0.98 0.98" })

-- Scratchpad Dropdown Terminal
wr({ class = "^(scratchpad_term)$" }, { float = true, center = true, size = "74% 70%", workspace = "special:scratchpad" })

-- Spotify Dropdown Scratchpad
wr({ class = "^(Spotify|spotify)$" }, { float = true, center = true, size = "66% 72%", opacity = "0.94 0.88", rounding = 14 })

-- TecConcursos Dropdown Scratchpad
wr({ class = "^(brave-www\\.tecconcursos\\.com\\.br.*|tecconcursos)$" }, { float = true, center = true, size = "74% 80%", opacity = "0.98 0.94", rounding = 14 })

-- WhatsApp Web Dropdown Scratchpad
wr({ class = "^(whatsapp-webapp|brave-web\\.whatsapp.*)$" }, { float = true, center = true, size = "78% 84%", opacity = "0.98 0.94", rounding = 14 })

-- Oráculo de IA Dropdown Scratchpad
wr({ class = "^(ai-oracle)$" }, { float = true, center = true, size = "74% 82%", opacity = "0.98 0.94", rounding = 14 })

-- Calculadora & Qalculate
wr({ class = "^(org\\.gnome\\.Calculator|gnome-calculator)$" }, { float = true, center = true, size = "430 640" })
wr({ class = "^(qalculate-gtk)$" }, { float = true, center = true, size = "620 680" })

-- Calendário & Relógio
wr({ class = "^(org\\.gnome\\.Calendar|gnome-calendar)$" }, { float = true, center = true, size = "58% 64%" })
wr({ class = "^(org\\.gnome\\.clocks|gnome-clocks)$" }, { float = true, center = true, size = "50% 58%" })

-- Remmina & VoIP
wr({ class = "^(org\\.remmina\\.Remmina|remmina)$" }, { float = true, center = true, size = "68% 72%" })
wr({ class = "^(microsip\\.exe|MicroSIP|linphone)$" }, { float = true, size = "340 560" })

-- Virt-Manager & Viewers
wr({ class = "^(virt-manager)$" }, { float = true, center = true, size = "65% 70%" })
wr({ class = "^(virt-viewer|remote-viewer)$" }, { float = true, center = true, size = "72% 76%" })

-- Safe-Update
wr({ class = "^(safe-update)$" }, { float = true, center = true, size = "60% 65%" })

-- AB Download Manager
wr({ class = "^(com-abdownloadmanager-desktop-AppKt|ABDownloadManager|abdownloadmanager)$" }, { float = true, center = true, size = "64% 68%" })

-- Cheat Sheet & Ferramentas do Sistema
wr({ title = "^(.*Cheat Sheet.*)$" }, { float = true, center = true, size = "62% 70%" })
wr({ class = "^(nwg-displays)$" }, { float = true, center = true, size = "68% 70%" })
wr({ class = "^(GParted|gparted)$" }, { float = true, center = true, size = "68% 70%" })
wr({ class = "^(org\\.gnome\\.baobab|baobab)$" }, { float = true, center = true, size = "64% 65%" })
wr({ class = "^(io\\.github\\.celluloid_player\\.Celluloid|celluloid)$" }, { float = true, center = true, size = "68% 70%" })
wr({ class = "^(org\\.kde\\.kdeconnect.*|kdeconnect.*)$" }, { float = true, center = true })
wr({ class = "^(org\\.qbittorrent\\.qBittorrent|qbittorrent)$" }, { float = true, center = true, size = "68% 70%" })
wr({ class = "^(quickgui)$" }, { float = true, center = true, size = "62% 66%" })
wr({ class = "^(flameshot)$" }, { float = true, center = true, pin = true, no_anim = true })
wr({ class = "^(imv)$" }, { float = true, center = true, size = "68% 70%" })
wr({ class = "^(localsend|LocalSend|localsend_app)$" }, { float = true, center = true, size = "60% 68%" })
wr({ title = "^(btop)$" }, { float = true, center = true, size = "70% 72%", opacity = "0.95 0.90", rounding = 12 })
wr({ class = "^(fsearch|FSearch|io\\.github\\.cboxdoerfer\\.FSearch)$" }, { float = true, center = true, size = "62% 66%", opacity = "0.95 0.90", rounding = 12 })
wr({ class = "^(organizador-terminal)$" }, { float = true, center = true, size = "68% 72%", opacity = "0.95 0.90", rounding = 12 })
wr({ class = "^(io\\.bassi\\.Amberol|amberol)$" }, { float = true, center = true, size = "440 680", opacity = "0.98 0.95", rounding = 16 })
wr({ class = "^(sptlrx-lyrics)$" }, { float = true, center = true, size = "520 680", opacity = "0.96 0.90", rounding = 16 })
wr({ title = "^(AmateurStream.*)$" }, { float = true, size = "720 405", pin = true, rounding = 12 })

-- Jogos (Skyrim Special & Anniversary Edition)
wr({ title = "^(Skyrim.*|The Elder Scrolls V.*)$" }, { workspace = "8", fullscreen = 1, immediate = true })
wr({ initial_title = "^(Skyrim.*|The Elder Scrolls V.*)$" }, { workspace = "8" })
wr({ class = "^([Ss]kyrim.*|[Ss]kyrim[Ss][Ee]\\.exe)$" }, { workspace = "8", fullscreen = 1, immediate = true })

-- Diálogos do Sistema & Popups
-- Fullscreen: opacidade 100% sólida (elimina desbotamento acinzentado) e inibição de idle
wr({ fullscreen = true }, { opacity = "1.0 1.0 1.0", idle_inhibit = "fullscreen" })
wr({ title = "^(Authentication Required)$" }, { float = true, center = true })
wr({ title = "^(Add Folder to Workspace)$" }, { float = true, center = true, size = "(monitor_w*0.7) (monitor_h*0.6)" })
wr({ title = "^(Save As)$" }, { float = true, center = true, size = "(monitor_w*0.7) (monitor_h*0.6)" })
wr({ initial_title = "Open Files" }, { float = true, size = "(monitor_w*0.7) (monitor_h*0.6)" })
wr({ title = "^(SDDM Background)$" }, { float = true, center = true, size = "(monitor_w*0.16) (monitor_h*0.12)" })
wr({ class = "^(yad)$" }, { float = true, center = true, size = "(monitor_w*0.2) (monitor_h*0.2)" })
wr({ class = "^(hyprland-donate-screen)$" }, { float = true, center = true })
wr({ class = "^(gedit|org\\.gnome\\.TextEditor|mousepad)$" }, { opacity = "0.8 0.7" })
wr({ class = "^(deluge)$" }, { opacity = "0.9 0.8" })
wr({ class = "^(seahorse)$" }, { opacity = "0.9 0.8" })
wr({ class = "^(jetbrains-.*)" }, { no_initial_focus = true })
wr({ title = "^(wind.*)$" }, { no_initial_focus = true })
wr({ class = "^([Ww]hatsapp-for-linux|ZapZap|com\\.rtosta\\.zapzap)$" }, { center = true, size = "(monitor_w*0.6) (monitor_h*0.7)" })
wr({ class = "^(thunar)$", title = "^(File Operation Progress)$" }, { float = true, center = true, size = "(monitor_w*0.26) (monitor_h*0.18)" })
wr({ class = "([Zz]oom|onedriver|onedriver-launcher)" }, { float = true })
wr({ class = "^(mpv|com\\.github\\.rafostar\\.Clapper)$" }, { float = true })
wr({ class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" }, { float = true })
wr({ class = "^(com\\.heroicgameslauncher\\.hgl)$", title = "negative:(Heroic Games Launcher)" }, { float = true })
wr({ class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, { float = true })

-- Fixes de Estabilidade do Compositor (XWayland Drags & Eventos de Maximize)
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- ==============================================================================
-- 🌫️ LAYER RULES (Glassmorphism & Frosted Blur)
-- ==============================================================================
lr("wlogout", { blur = true, ignore_alpha = 0.5 })
lr("rofi", { blur = true, ignore_alpha = 0.5 })
lr("notifications", { blur = true, ignore_alpha = 0.5 })
lr("swaync-control-center", { blur = true, ignore_alpha = 0.5 })
lr("swaync-notification-window", { blur = true, ignore_alpha = 0.5 })
lr("quickshell:overview", { blur = true, ignore_alpha = 0.5 })
