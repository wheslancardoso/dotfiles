#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" " = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
" SHIFT K" "Searchable Keybinds" "(Search all Keybinds via rofi)" \
" SHIFT E" "KooL Hyprland Settings Menu" "" \
"" "" "" \
" enter" "Terminal" "(kitty)" \
" SHIFT enter" "DropDown Terminal" " Q to close" \
" B" "Launch Browser" "(Default browser)" \
" A" "Desktop Overview" "(AGS - if opted to install)" \
" D" "Application Launcher" "(rofi-wayland)" \
" E" "Open File Manager" "(Thunar)" \
" S" "Google Search using rofi" "(rofi)" \
" T" "Global theme switcher" "(rofi)" \
" Q" "close active window" "(not kill)" \
" Shift Q " "kills an active window" "(kill)" \
" ALT mouse scroll up/down   " "Desktop Zoom" "Desktop Magnifier" \
" Alt V" "Clipboard Manager" "(cliphist)" \
" W" "Choose wallpaper" "(Wallpaper Menu)" \
" Shift W" "Choose wallpaper effects" "(imagemagick + awww)" \
"CTRL ALT W" "Random wallpaper" "(via awww)" \
" CTRL ALT B" "Hide/UnHide Waybar" "waybar" \
" CTRL B" "Choose waybar styles" "(waybar styles)" \
" ALT B" "Choose waybar layout" "(waybar layout)" \
" ALT R" "Reload Waybar swaync Rofi" "CHECK NOTIFICATION FIRST!!!" \
" SHIFT N" "Launch Notification Panel" "swaync Notification Center" \
" Print" "screenshot" "(grim)" \
" Shift Print" "screenshot region" "(grim + slurp)" \
" Shift S" "screenshot region" "(swappy)" \
" CTRL Print" "screenshot timer 5 secs " "(grim)" \
" CTRL SHIFT Print" "screenshot timer 10 secs " "(grim)" \
"ALT Print" "Screenshot active window" "active window only" \
"CTRL ALT P" "power-menu" "(wlogout)" \
"CTRL ALT L" "screen lock" "(hyprlock)" \
"CTRL ALT Del" "Hyprland Exit" "(NOTE: Hyprland Will exit immediately)" \
" SHIFT F" "Fullscreen" "Toggles to full screen" \
" CTL F" "Fake Fullscreen" "Toggles to fake full screen" \
" ALT L" "Toggle Dwindle | Master Layout" "Hyprland Layout" \
" SPACEBAR" "Toggle float" "single window" \
" ALT SPACEBAR" "Toggle all windows to float" "all windows" \
" ALT O" "Toggle Blur" "normal or less blur" \
" CTRL O" "Toggle Opaque ON or OFF" "on active window only" \
" Shift A" "Animations Menu" "Choose Animations via rofi" \
" CTRL R" "Rofi Themes Menu" "Choose Rofi Themes via rofi" \
" CTRL Shift R" "Rofi Themes Menu v2" "Choose Rofi Themes via Theme Selector (modified)" \
" SHIFT G" "Gamemode! All animations OFF or ON" "toggle" \
" ALT E" "Rofi Emoticons" "Emoticon" \
" H" "Launch this Quick Cheat Sheet" "" \
"" "" "" \
"── YAZI ──" "── ATALHOS DO YAZI ──" "──────────" \
"j / k" "Mover para baixo / cima" "(Navegação Básica)" \
"h / l" "Voltar pasta / Entrar na pasta" "(Navegação Básica)" \
"Enter" "Abrir arquivo (app padrão)" "(Navegação Básica)" \
"z" "Pulo inteligente (zoxide)" "(Navegação Básica)" \
"q" "Sair do Yazi" "(Navegação Básica)" \
"" "" "" \
"r" "Renomear" "(Gestão de Arquivos)" \
"R" "Bulk Rename (Editar lista no Neovim)" "(Gestão de Arquivos)" \
"ctrl + r" "Smart Bulk Rename (Interface inteligente)" "(Gestão de Arquivos)" \
"a + i" "Criar novo Arquivo (Insert)" "(Gestão de Arquivos)" \
"a + d" "Criar novo Diretório" "(Gestão de Arquivos)" \
"y" "Copiar (yank) arquivo(s)" "(Gestão de Arquivos)" \
"x" "Recortar (cut) arquivo(s)" "(Gestão de Arquivos)" \
"p" "Colar arquivo(s)" "(Gestão de Arquivos)" \
"d + d" "Mover para a Lixeira (Trash)" "(Gestão de Arquivos)" \
"D" "Deletar permanentemente" "(Gestão de Arquivos)" \
"f" "Filtrar arquivos (Busca rápida)" "(Gestão de Arquivos)" \
"f + g" "Buscar conteúdo (fzf + ripgrep)" "(Gestão de Arquivos)" \
"" "" "" \
"a + e" "Extrair (detecta formato auto)" "(Compressão e Extração)" \
"a + c" "Compactar para .zip" "(Compressão e Extração)" \
"" "" "" \
"F10" "Ver este Guia" "(Utilitários)" \
"Y" "Copiar Caminho para clipboard" "(Utilitários)" \
". + s" "Calcular tamanho da pasta" "(Utilitários)" \
"T" "Abrir Terminal nesta pasta" "(Utilitários)" \
"." "Mostrar/Ocultar arquivos ocultos" "(Utilitários)" \
"v" "Seleção visual (como no Vim)" "(Utilitários)" \
"Space" "Selecionar arquivo individual" "(Utilitários)" \
"" "" "" \
"More tips:" "https://github.com/JaKooLit/Hyprland-Dots/wiki" ""\
