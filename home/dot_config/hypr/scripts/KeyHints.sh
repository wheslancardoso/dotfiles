#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# ==============================================================================
# 📋 Guia Mestre de Atalhos - Cheat Sheet Definitivo
# Hyprland + Yazi + LazyVim + Zellij + Sistema + Produtividade
# Atalho: SUPER + H (ou SUPER + SHIFT + H / SUPER + /)
# ==============================================================================

BACKEND=wayland

# Fecha instâncias anteriores de rofi ou yad se estiverem abertas
pidof rofi >/dev/null && pkill rofi
pidof yad >/dev/null && pkill yad

# Launch yad com todos os atalhos organizados por categorias
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet - Guia Mestre de Atalhos" \
    --no-buttons \
    --list \
    --width=1040 \
    --height=780 \
    --column="Atalho / Tecla": \
    --column="Descrição": \
    --column="Comando / Ação": \
    --timeout-indicator=bottom \
"ESC" "Fechar este guia" "Sair" \
" = " "Tecla SUPER (Tecla Windows)" "(SUPER / MOD)" \
" H ou  /" "Abrir este Cheat Sheet Completo" "KeyHints.sh" \
" SHIFT K" "Buscar Atalhos Interativamente" "(Pesquisar atalhos no rofi)" \
" SHIFT E" "Menu de Configurações KooL Hyprland" "Kool_Quick_Settings.sh" \
"" "" "" \
"── 🚀 ATALHOS ESSENCIAIS E SISTEMA ──" "── HYPRLAND CORE ──" "────────────────────────" \
" enter" "Abrir Terminal Principal" "kitty" \
" SHIFT enter" "Dropdown Terminal Suspenso (Quake)" "scratchpad-term.sh" \
" ~ (til) ou  U" "Dropdown Terminal Alternativo" "scratchpad-term.sh" \
" B" "Abrir Navegador Web" "Brave Browser" \
" D" "Menu de Aplicativos (Launcher)" "rofi -show drun" \
" Q" "Fechar Janela Ativa" "closewindow" \
" Shift Q" "Forçar Encerramento da Janela (Kill)" "killactive" \
" F" "Tela Cheia Total (Fullscreen)" "fullscreen 0" \
" SHIFT F" "Maximizar Janela (Mantém Waybar e Gaps)" "fullscreen 1" \
" SHIFT SPACE" "Alternar Janela Ativa Flutuante / Tiling" "togglefloating" \
" ALT SPACE" "Alternar Todas as Janelas para Flutuante" "togglefloating (all)" \
"CTRL ALT L" "Bloquear Tela" "hyprlock" \
"CTRL ALT Del" "Sair do Hyprland / Logout" "wlogout" \
"CTRL ALT P" "Menu de Energia e Desligamento" "wlogout" \
"" "" "" \
"── 📋 CLIPBOARD E PRODUTIVIDADE ──" "── WORKFLOW RÁPIDO ──" "────────────────────────" \
"ALT V ou  ALT V" "Painel Avançado CopyQ (Abas, Snippets, Imagens)" "copyq-toggle.sh" \
" V" "Busca Rápida de Clipboard (Cliphist Fuzzy 2ms)" "ClipManager.sh" \
" M" "Spotify Dropdown Player (Scratchpad Flutuante)" "spotify-toggle.sh" \
" C" "Calculadora Gnome (Moedas, Unidades ao vivo)" "gnome-calculator" \
" ALT C" "Calculadora Científica e Financeira" "qalculate-gtk" \
" ;" "Seletor de Emojis e Símbolos Rápidos" "RofiEmoji.sh" \
" SPACE" "Trocar Layout do Teclado (US-Intl / PT-BR / US-Dev)" "KeyboardLayout.sh" \
" SHIFT A" "Alternar Saída de Som (Caixas ↔ Headset)" "audio-switch.sh" \
" ALT M" "Silenciar / Ativar Microfone (Mic Mute)" "Volume.sh --toggle-mic" \
" ALT B" "Menu Bluetooth Rápido (Conectar Fones)" "rofi-bluetooth.sh" \
" ALT W" "Menu Wi-Fi Rápido (Redes sem abrir abas)" "rofi-wifi.sh" \
" SHIFT D" "Upload Rápido de Documentos (CNH, RG, etc)" "open-acesso-rapido.sh" \
" ALT S" "Sincronizar Saves de Jogos na Nuvem" "sync-ludusavi.sh" \
" ALT G" "Google Drive 5TB Virtual (Montar/Desmontar)" "gdrive-mount.sh toggle" \
" ALT D" "Download de Vídeo ou Música do Clipboard" "media-download.sh" \
" CTRL D" "Baixar Música que está Tocando Agora" "media-download.sh --now" \
"" "" "" \
"── 📸 CAPTURAS DE TELA E GRAVAÇÃO ──" "── SCREENSHOTS E MÍDIA ──" "────────────────────────" \
" SHIFT S ou Print" "Captura com Anotações, Setas e Destaque" "flameshot gui" \
" Print" "Capturar Tela Inteira Direto para Screenshots" "ScreenShot.sh --now" \
"ALT Print" "Capturar Janela Ativa" "ScreenShot.sh --in5" \
" CTRL Print" "Captura com Timer de 5 Segundos" "ScreenShot.sh --in5" \
" CTRL SHIFT Print" "Captura com Timer de 10 Segundos" "ScreenShot.sh --in10" \
" SHIFT R ou  ALT R" "Gravação de Tela em Vídeo/GIF com Áudio" "screen-record.sh" \
" SHIFT P" "Conta-gotas de Cor Hex direto pro Clipboard" "hyprpicker" \
" SHIFT T" "Screen OCR (Copiar texto de qualquer imagem/vídeo)" "ocr-screen.sh" \
"" "" "" \
"── 🪟 NAVEGAÇÃO E JANELAS ──" "── VIM KEYS E MULTITAREFA ──" "────────────────────────" \
" H / J / K / L" "Mover FOCO entre Janelas (Esq, Baixo, Cima, Dir)" "movefocus l/d/u/r" \
" CTRL H / J / K / L" "Mover POSIÇÃO da Janela no Grid Tiling" "movewindow l/d/u/r" \
" R" "Modo Redimensionamento Interativo (H/J/K/L ou Setas)" "submap resize" \
" ALT H / J / K / L" "Redimensionar Tamanho Rápido sem Sair" "resizeactive" \
"ALT Tab" "Voltar para o Último Workspace Visitado (Back-and-Forth)" "workspace previous" \
" Tab" "Seletor Visual de Janelas com Miniaturas" "Rofi Window Switcher" \
" 1 .. 9" "Mudar para Área de Trabalho (Workspace) 1 a 9" "workspace 1..9" \
" SHIFT 1 .. 9" "Mover Janela Ativa para Área de Trabalho 1 a 9" "movetoworkspace 1..9" \
" Scroll Mouse" "Navegar entre Áreas de Trabalho Rápido" "workspace +/-" \
" + Botão Esquerdo" "Arrastar para Mover Qualquer Janela" "movewindow (mouse)" \
" + Botão Direito" "Arrastar para Redimensionar Qualquer Janela" "resizewindow (mouse)" \
" + Botão Meio" "Alternar Janela entre Flutuante e Tiling" "togglefloating (mouse)" \
"Borda da Janela (Mouse)" "Área de 20px nas Bordas para Redimensionar" "resize_on_border" \
" ALT scroll mouse" "Zoom do Desktop / Lupa de Acessibilidade" "Desktop Magnifier" \
"" "" "" \
"── 📂 YAZI: EXPLORADOR DE ARQUIVOS ──" "── CONTROLES E NAVEGAÇÃO ──" "────────────────────────" \
" E" "Abrir Yazi (Modo Tiling / Ladrilhado)" "open-yazi-tiled.sh" \
" SHIFT E" "Abrir Yazi (Janela Flutuante Centralizada)" "open-yazi.sh" \
"h / j / k / l" "Navegar (Voltar Pasta, Baixo, Cima, Entrar)" "Navegação Vim" \
"Enter ou l" "Abrir Arquivo / Entrar Inteligente" "smart-enter" \
"Space" "Selecionar / Deselecionar Arquivo Individual" "Toggle Select" \
"v" "Seleção Visual Contínua" "Visual Select" \
"y" "Copiar Arquivo(s) Selecionado(s)" "Yank" \
"x" "Recortar Arquivo(s) Selecionado(s)" "Cut" \
"p" "Colar Arquivo(s)" "Paste" \
"d d" "Mover para a Lixeira (Trash)" "Trash" \
"D" "Deletar Arquivo Permanentemente (Sem lixeira)" "Permanent Delete" \
"r" "Renomear Arquivo ou Pasta" "Rename" \
"R" "Bulk Rename (Editar Lista em Massa no Neovim)" "Bulk Rename" \
"a" "Criar Novo Arquivo (ou pasta adicionando /)" "Create" \
"z" "Pulo Rápido Inteligente por Diretórios (Zoxide)" "zoxide" \
"Z" "Busca Recursiva de Arquivos Fuzzy (FZF)" "fzf search" \
"f" "Filtro Rápido na Pasta Atual" "Filter" \
"c p" "Copiar Caminho Absoluto do Arquivo" "copy path" \
"c f" "Copiar Apenas o Nome do Arquivo" "copy filename" \
"c d" "Copiar Caminho do Diretório Atual" "copy dirpath" \
"CTRL + y" "Arrastar Arquivo para Browser/Discord (Ripdrag)" "Drag e Drop" \
"CTRL + d" "Comparar Diferença entre Arquivos (Diff)" "diff plugin" \
"c m" "Alterar Permissões de Arquivo (Chmod Interativo)" "chmod plugin" \
"M m" "Gerenciador de Discos e Pen-drives (Mount/Eject)" "mount plugin" \
"c z" "Comprimir Selecionados para .ZIP" "yazi-archive.sh" \
"c 7" "Comprimir Selecionados para .7Z (Ultra LZMA2)" "yazi-archive.sh" \
"c t" "Comprimir para .TAR.GZ (Linux)" "yazi-archive.sh" \
"c c" "Comprimir com Nome Personalizado" "yazi-archive.sh" \
"e s ou X" "Extrair Arquivo para Subpasta Limpa (1 Toque)" "yazi-archive.sh" \
"e x" "Extrair Conteúdo na Pasta Atual (Here)" "yazi-archive.sh" \
"g i / g p / g v" "Pulos Rápidos: 00_Inbox / 01_Pessoal / 04_Dev" "cd /mnt/dados/..." \
"g j / g m / g D" "Pulos Rápidos: Games / Mídias / Raiz /mnt/dados" "cd /mnt/dados/..." \
"g G / g ." "Pulos Rápidos: Google Drive 5TB / ~/dotfiles" "cd ~/gdrive | ~/dotfiles" \
"M o" "Organizar Downloads / Inbox Agora" "organizar --all" \
"M d" "Diagnóstico do Sistema de Arquivos" "organizar --doctor" \
"M u" "Destravar / Reparar Pen-drive Danificado" "fix-pendrive.sh" \
"M s" "Backup Saves de Jogos na Nuvem" "sync-ludusavi.sh" \
"M g" "Abrir Lazygit na Pasta Atual" "lazygit" \
"M l" "Enviar via LocalSend (AirDrop Celular/PC)" "localsend" \
"M y" "Baixar Mídia do Clipboard para a Pasta Atual" "media-download.sh" \
"M t" "Abrir Terminal Kitty na Pasta Atual" "kitty" \
"." "Mostrar / Ocultar Arquivos Ocultos (.dotfiles)" "toggle hidden" \
"~ ou F1" "Manual de Ajuda Completo Integrado do Yazi" "help menu" \
"" "" "" \
"── 💻 DESENVOLVIMENTO (LAZYVIM E ZELLIJ) ──" "── VIBE CODING ──" "────────────────────────" \
"vibe" "Iniciar Ambiente Completo Vibe Coding" "Zellij + Neovim" \
"Space (no Neovim)" "Tecla Líder do Editor (Leader Key)" "Leader" \
"Space e" "Abrir / Fechar Explorador Neo-tree" "File Explorer" \
"Space f f" "Localizar Arquivos no Projeto por Nome" "Find Files" \
"Space f g" "Buscar Texto em Todos os Arquivos (Live Grep)" "Live Grep" \
"Space f b" "Alternar entre Buffers / Arquivos Abertos" "Buffers" \
"Space g g" "Abrir Git / Lazygit dentro do Editor" "Lazygit" \
"Space c a" "Menu de Ações Rápidas de Código (LSP)" "Code Actions" \
"Space c r" "Renomear Símbolo em Todo o Projeto (Refactor)" "LSP Rename" \
"Space d b" "Marcar / Desmarcar Breakpoint de Debug" "Debugger DAP" \
"Space t t" "Abrir Terminal Flutuante Embutido" "Toggle Terminal" \
"K (no Neovim)" "Ver Documentação da Função / Hover LSP" "Hover Docs" \
"g d / g r" "Ir para a Definição / Ver Referências" "LSP Navigation" \
"CTRL p (Zellij)" "Modo Painéis: n (novo), x (fechar), f (fullscreen)" "Panes" \
"CTRL t (Zellij)" "Modo Abas: n (nova), x (fechar), 1..9 (trocar)" "Tabs" \
"ALT h / j / k / l" "Navegar entre Painéis Zellij sem Prefixo" "Direct Move" \
"ALT n" "Criar Novo Painel Rápido no Zellij" "New Pane" \
"ALT [ e ALT ]" "Trocar de Aba Rapidamente no Zellij" "Switch Tab" \
"db-up / db-down" "Subir ou Parar Bancos Docker (Postgres, Mongo, Redis)" "Docker Dev" \
"lsql / dbeaver" "Gerenciadores de Banco de Dados CLI / GUI" "Database" \
"" "" "" \
"── ⚡ COMANDOS RÁPIDOS NO TERMINAL ──" "── CLI TOOLS E SCRIPTS ──" "────────────────────────" \
"brave-sync" "Copiar Código de 25 Palavras do Brave Sync" "brave-sync.sh" \
"sys-update" "Atualização Completa e Segura do Sistema" "sys-maintenance.sh" \
"cleanup" "Faxina Inteligente (Caches Pacman, Órfãos, Logs 7d)" "sys-maintenance.sh" \
"dl [link/url]" "Download de Vídeo (YT, Insta, TikTok) ou Spotify" "media-download.sh" \
"organizar" "Suíte de Organização Automática Padrão Ouro" "organizar --all" \
"organizar --doctor" "Diagnóstico e Nota 100/100 das Pastas" "organizar" \
"organizar --dedup" "Deduplicação de Arquivos por Hash SHA-256" "organizar" \
"fix-pendrive" "Destravar e Reparar Pen-drives (NTFS/FAT/exFAT)" "fix-pendrive.sh" \
"fix-audio" "Reiniciar e Recuperar Servidor PipeWire / WirePlumber" "fix-audio.sh" \
"fix-pacman" "Remover Lock db.lck Travado do Pacman" "fix-pacman.sh" \
"fix-keys" "Reparar e Baixar Chaves PGP do Arch Linux" "fix-keys.sh" \
"fix-suspend" "Blindagem de Suspensão e Despertar do Sistema" "fix-suspend.sh" \
"m / mi / mu" "Gerenciador Rápido de Runtimes Mise (Node, Bun, Go)" "mise" \
"" "" "" \
"── 🎨 ESTILO, WALLPAPER E WAYBAR ──" "── PERSONALIZAÇÃO VISUAL ──" "────────────────────────" \
" W" "Menu de Seleção de Wallpapers" "Rofi Wallpapers" \
" SHIFT W" "Menu de Efeitos e Filtros no Wallpaper" "awww effects" \
"CTRL ALT W" "Sortear Wallpaper Aleatório da Coleção" "awww random" \
" CTRL ALT B" "Ocultar / Exibir Barra Waybar" "waybar toggle" \
" CTRL B" "Menu de Estilos Visuais da Waybar" "waybar styles" \
" ALT B" "Menu de Layouts da Waybar" "waybar layouts" \
" ALT R" "Recarregar Waybar, SwayNC e Temas" "Refresh.sh" \
" SHIFT N" "Abrir Central de Notificações SwayNC" "swaync-client" \
" T" "Seletor Global de Temas do Sistema" "Theme Selector" \
" SHIFT G" "Modo Jogo (GameMode - Desativa Blur e Efeitos)" "gamemode" \
"" "" "" \
"Guia Oficial e Wiki:" "https://github.com/JaKooLit/Hyprland-Dots/wiki" "JaKooLit Dots"
