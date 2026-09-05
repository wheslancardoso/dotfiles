#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# 📋 Guia Mestre de Atalhos & KeyHints (Arch + Hyprland + Yazi + Dev)
# Atalho: SUPER + H (ou SUPER + SHIFT + H / SUPER + /)

BACKEND=wayland

# Fecha instâncias anteriores de rofi ou yad se estiverem abertas
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad com todos os atalhos originais do KooL, Superpoderes do Rice e Yazi
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet - Guia Mestre de Atalhos" \
    --no-buttons \
    --list \
    --width=960 \
    --height=720 \
    --column="Atalho / Tecla": \
    --column="Descrição": \
    --column="Comando / Ação": \
    --timeout-indicator=bottom \
"ESC" "Fechar este guia" "Sair" \
" = " "Tecla SUPER (Tecla Windows)" "(SUPER / MOD)" \
" H ou  SHIFT H" "Abrir este Cheat Sheet" "KeyHints.sh" \
" SHIFT K" "Buscar Atalhos Interativamente" "(Pesquisar atalhos no rofi)" \
" SHIFT E" "Menu de Configurações KooL Hyprland" "Kool_Quick_Settings.sh" \
"" "" "" \
"── SUPERPODERES DO SEU RICE ──" "── FERRAMENTAS INTEGRADAS ──" "────────────────────────" \
" M" "Spotify Dropdown Scratchpad (Flutuante)" "spotify-toggle.sh" \
" ALT B" "Bluetooth Rápido (Ligar/Desligar/Fones)" "rofi-bluetooth.sh" \
" ALT W" "Wi-Fi Rápido (Conectar redes sem janelas)" "rofi-wifi.sh" \
" SHIFT R ou  ALT R" "Gravação de Tela (MP4/GIF com áudio)" "screen-record.sh" \
" SHIFT A ou  ALT A" "Alternar Saída de Som (Caixa <-> Fone)" "audio-switch.sh" \
" ALT M" "Silenciar/Ativar Microfone (Mic Mute)" "Volume.sh --toggle-mic" \
" SHIFT T" "Screen OCR (Copiar texto de qualquer imagem)" "ocr-screen.sh" \
" SHIFT P" "Conta-gotas de Cor Hex direto pro clipboard" "hyprpicker" \
" C" "Calculadora + Conversor de Moedas ao vivo" "gnome-calculator" \
" ALT C" "Calculadora Científica / Financeira" "qalculate-gtk" \
" SPACE" "Trocar Teclado (US-Intl / PT-BR / US-Dev)" "KeyboardLayout.sh" \
" SHIFT M" "Configurar Monitores / Resolução / Projetar" "nwg-displays" \
"ALT V ou  V" "Área de Transferência com busca e histórico" "CopyQ" \
" Tab" "Seletor Visual de Janelas abertas" "Rofi Window Switcher" \
" ~ (til) ou  U" "Terminal Dropdown Suspenso (Quake Style)" "scratchpad-term.sh" \
" E" "Explorador de Arquivos Yazi (Modo Tiling)" "open-yazi-tiled.sh" \
" SHIFT E" "Explorador de Arquivos Yazi (Flutuante)" "open-yazi.sh" \
" SHIFT D" "Upload Rápido de Documentos (CNH, RG, Comprovantes)" "open-acesso-rapido.sh" \
" ALT S" "Sincronizar Saves de Jogos na Nuvem" "sync-ludusavi.sh" \
" ALT D" "Download Vídeo/Spotify (yt-dlp + spotdl)" "media-download.sh" \
"cleanup" "Faxina Inteligente do Arch (Órfãos/Cache)" "sys-maintenance.sh" \
"sys-update" "Atualização Completa e Segura do Sistema" "sys-maintenance.sh" \
"dl [url]" "Download Mídia/Spotify no Terminal" "media-download.sh" \
"fix-pendrive" "Destravar & Reparar Pen-drive (Terminal)" "fix-pendrive.sh" \
"fix-suspend" "Blindagem e Diagnóstico de Suspensão" "fix-suspend.sh" \
"fix-pacman" "Destravar db.lck do Pacman" "fix-pacman.sh" \
"fix-keys" "Reparar Chaves PGP do Arch" "fix-keys.sh" \
"fix-audio" "Reiniciar Servidor de Áudio PipeWire" "fix-audio.sh" \
"" "" "" \



"── APLICATIVOS BÁSICOS ──" "── ATALHOS DO HYPRLAND ──" "────────────────────────" \
" enter" "Abrir Terminal" "(kitty)" \
" SHIFT enter" "DropDown Terminal Alternativo" " Q para fechar" \
" B" "Abrir Navegador Web" "(Navegador Padrão)" \
" D" "Menu de Aplicativos (Launcher)" "(rofi-wayland)" \
" V" "Histórico Rápido de Clipboard (Fuzzy 2ms)" "ClipManager.sh" \
"ALT V" "Painel Avançado de Clipboard / Snippets" "copyq toggle" \
" S" "Busca no Google via Rofi" "(rofi)" \
" T" "Seletor Global de Temas" "(rofi)" \
" Q" "Fechar janela ativa" "(close)" \
" Shift Q" "Forçar encerramento da janela (Kill)" "(kill)" \
" ALT scroll mouse" "Zoom do Desktop / Lupa" "Desktop Magnifier" \
"" "" "" \
"── NAVEGAÇÃO VIM ──" "── NAVEGAÇÃO SEM MOUSE ──" "────────────────────────" \
" H / J / K / L" "Mover FOCO entre janelas (Esq, Baixo, Cima, Dir)" "movefocus l/d/u/r" \
" CTRL H / J / K / L" "Mover POSIÇÃO da janela no grid tiling" "movewindow l/d/u/r" \
" ALT H / J / K / L" "Redimensionar Janela ativamente" "resizeactive" \
" + Botão Esquerdo" "Arrastar para mover qualquer janela" "movewindow (mouse)" \
" + Botão Direito" "Arrastar para redimensionar qualquer janela" "resizewindow (mouse)" \
" + Botão Meio" "Alternar entre flutuante e ladrilhado" "togglefloating (mouse)" \
"" "" "" \
"── WALLPAPER & ESTILO ──" "── PERSONALIZAÇÃO VISUAL ──" "────────────────────────" \
" W" "Escolher Wallpaper" "(Menu de Wallpapers)" \
" Shift W" "Escolher Efeitos de Wallpaper" "(imagemagick + awww)" \
"CTRL ALT W" "Wallpaper Aleatório" "(via awww)" \
" CTRL ALT B" "Ocultar / Exibir Waybar" "waybar toggle" \
" CTRL B" "Escolher Estilos da Waybar" "(waybar styles)" \
" ALT B" "Escolher Layouts da Waybar" "(waybar layout)" \
" ALT R" "Recarregar Waybar, SwayNC e Rofi" "Refresh.sh" \
" SHIFT N" "Abrir Painel de Notificações" "SwayNC Notification Center" \
" Shift A" "Menu de Animações" "Rofi Animations" \
" CTRL R" "Menu de Temas do Rofi" "Rofi Themes" \
" CTRL Shift R" "Menu de Temas do Rofi v2" "Theme Selector" \
" ALT E" "Seletor de Emojis" "Rofi Emoticons" \
"" "" "" \
"── CAPTURAS DE TELA (PRINTS) ──" "── SCREENSHOTS ──" "────────────────────────" \
" Print" "Capturar tela inteira" "(grim)" \
" Shift Print" "Capturar região selecionada" "(grim + slurp)" \
" Shift S ou Print" "Capturar região e editar com anotações" "(flameshot)" \
" CTRL Print" "Captura com timer de 5 segundos" "(grim)" \
" CTRL SHIFT Print" "Captura com timer de 10 segundos" "(grim)" \
"ALT Print" "Capturar apenas a janela ativa" "active window" \
"" "" "" \
"── GERENCIAMENTO DE JANELAS ──" "── LAYOUT & DISPLAY ──" "────────────────────────" \
" SHIFT F" "Tela Cheia Total (Fullscreen)" "fullscreen toggle" \
" CTL F" "Tela Cheia Mantendo Barra (Fake Fullscreen)" "fake fullscreen" \
" ALT L" "Alternar Layout Dwindle | Master" "Hyprland Layout" \
" SPACEBAR" "Alternar janela flutuante" "single window" \
" ALT SPACEBAR" "Alternar todas as janelas para flutuante" "all windows" \
" ALT O" "Alternar Blur (Desfoque normal ou reduzido)" "blur toggle" \
" CTRL O" "Alternar Opacidade ON/OFF" "active window opacity" \
" SHIFT G" "GameMode (Desativa animações para alto FPS)" "gamemode toggle" \
"CTRL ALT P" "Menu de Energia" "(wlogout)" \
"CTRL ALT L" "Bloquear Tela" "(hyprlock)" \
"CTRL ALT Del" "Sair do Hyprland" "(Exit imediato)" \
"" "" "" \
"── DEV & MANUTENÇÃO ──" "── COMANDOS DO TERMINAL ZSH ──" "────────────────────────" \
"clean-system" "Faxina geral (órfãos, caches pacman, logs 7d)" "Terminal" \
"pacup" "Atualização completa do sistema e AUR" "Terminal" \
"db-up / db-down" "Subir/Parar suíte Docker (Postgres, Redis, Mongo)" "Docker Compose" \
"lsql / dbeaver" "Clientes de Banco de Dados (CLI / GUI)" "Terminal / GUI" \
"bruno / api" "Testador de APIs e REST" "GUI" \
"vibe" "Ambiente Vibe Coding (LazyVim + Antigravity CLI)" "Zellij" \
"organizar" "Suíte Organizador Master de Arquivos" "Python" \
"organizar --doctor" "Diagnóstico e Nota 100/100 Padrão Ouro" "Auditoria" \
"organizar --dedup" "Buscar Duplicatas por Hash SHA-256" "Deduplicador" \
"organizar --watch" "Triagem Automática em Segundo Plano" "Daemon" \
"m / mi / mu" "Gerenciador de Runtimes Mise (Node, Bun, Go, Java)" "Mise" \
"" "" "" \
"── YAZI: NAVEGAÇÃO BÁSICA ──" "── ATALHOS DO YAZI ──" "────────────────────────" \
"j / k" "Mover para baixo / cima" "(Navegação Básica)" \
"h / l" "Voltar pasta / Entrar na pasta" "(Navegação Básica)" \
"Enter" "Abrir arquivo (app padrão)" "(Navegação Básica)" \
"z" "Pulo inteligente (zoxide)" "(Navegação Básica)" \
"q" "Sair do Yazi" "(Navegação Básica)" \
"" "" "" \
"── YAZI: GESTÃO DE ARQUIVOS ──" "── ATALHOS DO YAZI ──" "────────────────────────" \
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
"── YAZI: COMPRESSÃO & EXTRAS ──" "── ATALHOS DO YAZI ──" "────────────────────────" \
"a + e" "Extrair (detecta formato auto)" "(Compressão e Extração)" \
"a + c" "Compactar para .zip" "(Compressão e Extração)" \
"F10" "Ver Guia de Atalhos do Yazi" "(Utilitários)" \
"Y" "Copiar Caminho para clipboard" "(Utilitários)" \
". + s" "Calcular tamanho da pasta" "(Utilitários)" \
"T" "Abrir Terminal nesta pasta" "(Utilitários)" \
"." "Mostrar/Ocultar arquivos ocultos" "(Utilitários)" \
"v" "Seleção visual (como no Vim)" "(Utilitários)" \
"Space" "Selecionar arquivo individual" "(Utilitários)" \
"M y" "Baixar Mídia/Spotify para pasta atual" "(Yazi Power-User)" \
"M l" "Enviar via LocalSend (AirDrop P2P)" "(Yazi Power-User)" \
"Ctrl + y" "Arrastar arquivo (Drag & Drop p/ apps)" "(ripdrag)" \
"" "" "" \
"More tips:" "https://github.com/JaKooLit/Hyprland-Dots/wiki" ""
