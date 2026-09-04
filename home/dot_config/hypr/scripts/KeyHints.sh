#!/usr/bin/env bash
# 📋 KooL & Antigravity Master Quick Cheat Sheet
# Atalho: SUPER + SHIFT + H ou SUPER + /

BACKEND=wayland

# Fecha instâncias anteriores de rofi ou yad se estiverem abertas
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Abre a janela YAD com todos os atalhos e utilitários
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet - Guia de Atalhos" \
    --no-buttons \
    --list \
    --width=920 \
    --height=700 \
    --column="Atalho": \
    --column="Descrição": \
    --column="Comando / Ação": \
    --timeout-indicator=bottom \
"ESC" "Fechar este guia" "Sair" \
" = " "Tecla SUPER (Tecla Windows)" "(SUPER / MOD)" \
" SHIFT H ou  /" "Abrir este Cheat Sheet" "KeyHints.sh" \
"" "" "" \
"── SUPERPODERES ──" "── RECURSOS DO SEU RICE ──" "────────────────────" \
" SHIFT R ou  ALT R" "Gravação de Tela (MP4/GIF com áudio)" "screen-record.sh" \
" SHIFT A ou  ALT A" "Alternar Saída de Som (Caixa <-> Fone)" "audio-switch.sh" \
" SHIFT T" "Screen OCR (Copiar texto de qualquer imagem)" "ocr-screen.sh" \
" SHIFT P" "Conta-gotas de Cor Hex direto pro clipboard" "hyprpicker" \
" C" "Calculadora + Conversão de Moedas ao vivo" "gnome-calculator" \
" ALT C" "Calculadora Científica / Financeira" "qalculate-gtk" \
" SPACE" "Trocar Teclado (US-Intl / PT-BR / US-Dev)" "KeyboardLayout.sh" \
"ALT V ou  V" "Área de Transferência com busca e histórico" "CopyQ" \
" Tab" "Seletor Visual de Janelas abertas" "Rofi Window Switcher" \
" ~ (til) ou  U" "Terminal Dropdown Suspenso (Quake Style)" "Scratchpad Terminal" \
" E" "Explorador de Arquivos Yazi (Modo Tiling)" "open-yazi-tiled.sh" \
" SHIFT E" "Explorador de Arquivos Yazi (Flutuante)" "open-yazi.sh" \
"" "" "" \
"── NAVEGAÇÃO VIM ──" "── VIM NAVIGATION (SEM MOUSE) ──" "────────────────────" \
" H / J / K / L" "Mover FOCO entre janelas (Esq, Baixo, Cima, Dir)" "movefocus l/d/u/r" \
" CTRL H / J / K / L" "Mover POSIÇÃO da janela no grid tiling" "movewindow l/d/u/r" \
" ALT H / J / K / L" "Redimensionar Janela ativamente" "resizeactive" \
" + Botão Esquerdo" "Arrastar para mover qualquer janela" "movewindow (mouse)" \
" + Botão Direito" "Arrastar para redimensionar qualquer janela" "resizewindow (mouse)" \
" + Botão Meio" "Alternar entre flutuante e ladrilhado" "togglefloating (mouse)" \
"" "" "" \
"── JANELAS & WORKSPACES ──" "── GERENCIAMENTO HYPRLAND ──" "────────────────────" \
" Q" "Fechar janela ativa" "killactive" \
" F" "Tela cheia total (Fullscreen)" "fullscreen 0" \
" SHIFT F" "Tela cheia mantendo Waybar (Fake Fullscreen)" "fullscreen 1" \
" SHIFT SPACE" "Alternar janela entre flutuante e ladrilhado" "togglefloating" \
" 1 a 9" "Mudar para Área de Trabalho (Workspace)" "workspace 1..9" \
" SHIFT 1 a 9" "Mover janela para Área de Trabalho" "movetoworkspace 1..9" \
" D" "Menu de Aplicativos principal" "Rofi Launcher" \
" Return (Enter)" "Abrir Terminal principal" "Kitty Terminal" \
" B" "Abrir Navegador Web" "Browser" \
" Shift S" "Print de área da tela para edição" "grim + slurp + swappy" \
" Shift G" "Ativar/Desativar Modo Gamer (GameMode)" "gamemode" \
"CTRL ALT L" "Bloquear Tela com senha" "hyprlock" \
" M" "Menu de Saída / Desligar / Suspender" "wlogout" \
"" "" "" \
"── DEV & MANUTENÇÃO ──" "── COMANDOS DO TERMINAL ZSH ──" "────────────────────" \
"clean-system" "Faxina geral (órfãos, caches pacman, logs 7d)" "Terminal" \
"pacup" "Atualização completa do sistema e AUR" "Terminal" \
"db-up / db-down" "Subir/Parar suíte Docker (Postgres, Redis, Mongo)" "Docker Compose" \
"lsql" "LazySQL: Cliente de banco no terminal" "CLI" \
"dbeaver / db" "DBeaver: Cliente gráfico universal de banco" "GUI" \
"bruno / api" "Bruno: Testador e client de APIs / REST" "GUI" \
"vibe" "Ambiente Vibe Coding (LazyVim + Antigravity CLI)" "Zellij" \
"organizar" "Suíte Organizador Master de Arquivos" "Python" \
"m / mi / mu" "Gerenciador de Runtimes Mise (Node, Bun, Go, Java)" "Mise" \
"" "" "" \
"── NAVEGAÇÃO YAZI ──" "── ATALHOS DO EXPLORADOR YAZI ──" "────────────────────" \
"h / l" "Voltar pasta / Entrar na pasta ou arquivo" "Yazi" \
"j / k" "Mover cursor para baixo / cima" "Yazi" \
"Space" "Selecionar/Desselecionar arquivo atual" "Yazi" \
"v" "Seleção visual contínua (estilo Vim)" "Yazi" \
"y / x / p" "Copiar / Recortar / Colar arquivos" "Yazi" \
"d + d" "Enviar para Lixeira (Trash)" "Yazi" \
"D" "Deletar permanentemente (sem lixeira)" "Yazi" \
"r / R" "Renomear simples / Bulk Rename no Neovim" "Yazi" \
"f / f + g" "Filtro rápido / Busca de conteúdo (fzf + rg)" "Yazi" \
"z" "Pulo inteligente para pastas recentes (zoxide)" "Yazi" \
"T" "Abrir terminal Kitty nesta pasta" "Yazi" \
"Y" "Copiar caminho absoluto do arquivo pro clipboard" "Yazi" \
"q" "Fechar Yazi" "Yazi"
