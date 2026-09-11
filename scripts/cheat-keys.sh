#!/usr/bin/env bash
# /* ---- 💫 Ultimate Antigravity & Power-User Suite 💫 ---- */
# ⌨️ cheat-keys.sh: Buscador Universal de Atalhos, Comandos e Ferramentas (FZF + Rofi)
# Uso no terminal: keys [termo_opcional]  ou  ajuda [termo_opcional]
# Uso no Hyprland: cheat-keys.sh --rofi

set -euo pipefail

MODE="fzf"
QUERY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --rofi)
      MODE="rofi"
      shift
      ;;
    *)
      QUERY="$QUERY $1"
      shift
      ;;
  esac
done
QUERY="$(echo "$QUERY" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Base de Dados Unificada de Atalhos e Comandos:
# Formato: ATALHO/COMANDO \t CONTEXTO \t DESCRIÇÃO \t DETALHES
generate_database() {
cat << 'EOF'
🤖 Perguntar para a IA	🧠 Assistente	Tirar dúvida sobre atalhos, comandos ou sistema	Abre o assistente de IA para responder qualquer dúvida de forma rápida e inteligente.	terminal_ia
c p	📂 Yazi	Copiar Caminho Absoluto do Arquivo	Copia o caminho completo (ex: /mnt/dados/pasta/arquivo.iso) direto para a Área de Transferência.	copy_key
c f	📂 Yazi	Copiar apenas o Nome do Arquivo	Copia somente o nome do arquivo com a extensão (ex: video.mp4) para o Clipboard.	copy_key
c d	📂 Yazi	Copiar Caminho da Pasta Atual	Copia o diretório onde você está navegando no Yazi.	copy_key
F2 ou r	📂 Yazi	Renomear Inteligente (Preserva Extensão)	Abre o prompt de renomear limpando o nome e mantendo a extensão (.mp4/.pdf/.iso) intacta.	copy_key
r e	📂 Yazi	Mudar Extensão do Arquivo	Permite alterar o formato/extensão (.mkv -> .mp4, .txt -> .md).	copy_key
u ou Ctrl+Z	📂 Yazi	Desfazer Última Renomeação (Undo)	Restaura o nome anterior do arquivo caso tenha errado ao renomear.	copy_key
y	📂 Yazi	Copiar Arquivo Físico (Yank)	Copia o arquivo selecionado para colar com 'p' em qualquer outra pasta.	copy_key
x	📂 Yazi	Recortar Arquivo Físico (Cut)	Recorta o arquivo para mover com 'p' para outra pasta.	copy_key
p	📂 Yazi	Colar Arquivo(s) Copiados/Recortados	Cola os arquivos transferidos no diretório atual.	copy_key
d d	📂 Yazi	Mover para a Lixeira (Trash Seguro)	Envia o arquivo para a lixeira sem risco de perda permanente.	copy_key
D	📂 Yazi	Deletar Permanentemente (Sem Lixeira)	Apaga o arquivo em definitivo do disco.	copy_key
Ctrl + Y	📂 Yazi	Arrastar Arquivo para Browser/Discord (Drag & Drop)	Abre o seletor visual para arrastar arquivos com o mouse para o Brave, WhatsApp ou Discord.	copy_key
Ctrl + D	📂 Yazi	Comparar Diferenças de Arquivos (Diff)	Abre visualizador de diferenças entre o arquivo focado e outro selecionado.	copy_key
c z	📂 Yazi	Comprimir para .ZIP (Rápido)	Compacta arquivos ou pastas selecionadas em .zip.	copy_key
c 7	📂 Yazi	Comprimir para .7Z (Ultra LZMA2)	Compacta com compressão máxima multi-thread 7-Zip.	copy_key
c t	📂 Yazi	Comprimir para .TAR.GZ (Linux)	Compacta no formato padrão do ecossistema Unix/Linux.	copy_key
X ou e s	📂 Yazi	Extrair para Subpasta Limpa (1 Toque)	Descompacta o arquivo criando automaticamente uma pasta com o nome dele.	copy_key
e x	📂 Yazi	Extrair Conteúdo Aqui	Descompacta todos os arquivos diretamente na pasta atual.	copy_key
z	📂 Yazi	Pulo Rápido por Diretórios (Zoxide)	Aperte 'z', digite parte do nome da pasta (ex: down, dev) e pule na hora.	copy_key
Z	📂 Yazi	Busca Recursiva Fuzzy de Arquivos (FZF)	Busca ultra-rápida em profundidade com preview e toggle de ocultos (Ctrl+H).	copy_key
M m	📂 Yazi	Montar / Ejetar Pen-drives e Discos	Gerenciador de montagem e ejeção segura de mídias USB e partições.	copy_key
M B	📂 Yazi	Enviar ISOs Selecionadas para o Ventoy	Copia imagens de boot diretamente para o pen-drive Ventoy Multiboot.	copy_key
M u	📂 Yazi	Destravar / Reparar Pen-drive (NTFS/FAT/exFAT)	Corrige partições corrompidas de pen-drives e HDs externos.	copy_key
M o	📂 Yazi	Organizar Downloads / Inbox Agora	Aciona o Organizador Master para triagem e categorização automática.	copy_key
M d	📂 Yazi	Diagnóstico do Sistema (Doctor)	Testa a saúde das pastas e integridade da taxonomia.	copy_key
M a ou M y	📂 Yazi	Baixar Mídia do Clipboard Nesta Pasta	Baixa vídeo ou áudio do link copiado diretamente no diretório atual via yt-dlp.	copy_key
M g	📂 Yazi	Abrir Lazygit Nesta Pasta	Abre interface gráfica de Git no diretório atual.	copy_key
M t	📂 Yazi	Abrir Terminal Kitty Nesta Pasta	Abre uma nova aba/janela do terminal no diretório atual.	copy_key
. (ponto)	📂 Yazi	Mostrar / Ocultar Arquivos Ocultos	Alterna a exibição de dotfiles e pastas ocultas.	copy_key
g i	📂 Yazi	Pulo Rápido: 00_Inbox_Triagem	Navega para a pasta de downloads e triagem.	copy_key
g p	📂 Yazi	Pulo Rápido: 01_Pessoal	Navega para a pasta de documentos pessoais e finanças.	copy_key
g e	📂 Yazi	Pulo Rápido: 03_Estudos_Carreira	Navega para a pasta de estudos, concursos e livros.	copy_key
g v	📂 Yazi	Pulo Rápido: 04_Dev	Navega para a pasta de desenvolvimento e código.	copy_key
g m	📂 Yazi	Pulo Rápido: 05_Midias	Navega para a pasta de vídeos, músicas e design.	copy_key
g j	📂 Yazi	Pulo Rápido: 06.4_Games	Navega para a pasta de jogos e emuladores.	copy_key
g b	📂 Yazi	Pulo Rápido: 06.3_ISOs_e_Boot	Navega para a pasta de ISOs do Ventoy e instaladores.	copy_key
g G	📂 Yazi	Pulo Rápido: Google Drive 5TB	Navega para o Google Drive virtual montado em ~/gdrive.	copy_key
g .	📂 Yazi	Pulo Rápido: ~/dotfiles	Navega para a pasta do repositório de dotfiles.	copy_key
→ (Seta Direita)	🎬 MPV	Avançar 10 Segundos (Instantâneo)	Seek ultra-rápido de 10s otimizado para YouTube e vídeos locais.	copy_key
← (Seta Esquerda)	🎬 MPV	Voltar 10 Segundos (Instantâneo)	Retrocede 10s no player sem engasgos.	copy_key
↑ (Seta Cima)	🎬 MPV	Avançar 30 Segundos	Pula 30 segundos à frente no vídeo.	copy_key
↓ (Seta Baixo)	🎬 MPV	Voltar 30 Segundos	Retrocede 30 segundos no vídeo.	copy_key
Shift + →	🎬 MPV	Avançar 1 Minuto (60s)	Salto de 1 minuto na linha do tempo.	copy_key
Shift + ←	🎬 MPV	Voltar 1 Minuto (60s)	Retrocesso de 1 minuto na linha do tempo.	copy_key
Ctrl + →	🎬 MPV	Avançar 5 Minutos (300s)	Salto longo de 5 minutos com carregamento assíncrono.	copy_key
Ctrl + ←	🎬 MPV	Voltar 5 Minutos (300s)	Retrocesso longo de 5 minutos direto da memória RAM.	copy_key
[ ou ]	🎬 MPV	Velocidade Precisa (1.1x, 1.25x...)	Ajusta a velocidade com correção tonal de estúdio (sem voz de esquilo).	copy_key
BS (Backspace)	🎬 MPV	Resetar Velocidade para 1.0x	Retorna a reprodução para a velocidade normal instantaneamente.	copy_key
Alt + I ou Ctrl + N	🎬 MPV	Modo Imersão em Inglês (sub-skip)	Acelera automaticamente nos momentos de silêncio e desacelera nas falas.	copy_key
TAB	🎬 MPV	Pular Abertura / Vinheta (Netflix Style)	Salta a vinheta inicial de séries e animes com 1 tecla.	copy_key
V (Shift + v)	🎬 MPV	Forced-Sub Killer	Mata legendas forçadas indesejadas e filtra apenas trilhas limpas.	copy_key
Ctrl + Z	🎬 MPV	Sincronizar Legendas por Voz (ffsubsync)	Reconhecimento de áudio inteligente para sincronizar legendas dessincronizadas.	copy_key
Ctrl + S	🎬 MPV	Baixar Legendas Automáticas	Busca e baixa legendas em português/inglês direto do OpenSubtitles.	copy_key
N	🎬 MPV	Modo Noturno de Áudio (Normalizador)	Comprime explosões e clareia sussurros e diálogos.	copy_key
Alt + B	🎬 MPV	Máscara Anti-Hardsub	Gera tarja preta inteligente sobre legendas gravadas no vídeo para sobrepor novas.	copy_key
Ctrl + 1 / 2 / 3	🎬 MPV	Shaders Anime4K (IA para Animes)	Aplica redes neurais para restaurar traços e upscaling em tempo real.	copy_key
Ctrl + 4 / 5	🎬 MPV	Shaders Cinema IA FSRCNNX	Super-resolução neural 16-Core para filmes e séries live-action.	copy_key
F1 ou ? ou h	🎬 MPV	Cheatsheet Visual do Player	Abre painel HUD translúcido na tela do vídeo com todas as teclas do MPV.	copy_key
SUPER + H ou SUPER + /	🚀 Hyprland	Buscador Universal de Atalhos (Este Menu)	Abre a busca interativa de atalhos, comandos e IA do sistema.	cheat-keys.sh --rofi
SUPER + Return	🚀 Hyprland	Abrir Terminal Principal (Kitty)	Inicia o terminal padrão de alta performance com GPU acelerada.	kitty
SUPER + Shift + Return	🚀 Hyprland	Terminal Dropdown Suspenso (Quake)	Desce um terminal flutuante do topo da tela e recolhe com a mesma tecla.	scratchpad-term.sh
SUPER + B	🚀 Hyprland	Abrir Navegador Brave	Abre o navegador Brave blindado e otimizado com aceleração de hardware.	brave
SUPER + D	🚀 Hyprland	Menu de Aplicativos (Launcher Rofi)	Lançador de aplicativos e programas instalados com busca fuzzy.	rofi -show drun
SUPER + E	🚀 Hyprland	Abrir Yazi (Explorador Tiling)	Abre o gerenciador de arquivos rápido no grid de janelas.	open-yazi-tiled.sh
SUPER + Shift + E	🚀 Hyprland	Abrir Yazi Flutuante (Popup 50%)	Abre o Yazi em uma janela flutuante centralizada.	open-yazi.sh
SUPER + Q	🚀 Hyprland	Fechar Janela Ativa	Fecha a janela atualmente em foco de forma suave (killactive).	closewindow
SUPER + Shift + Q	🚀 Hyprland	Forçar Fechamento de Processo (Kill)	Mata o processo travado imediatamente com sinal SIGKILL.	KillActiveProcess.sh
SUPER + Backspace	🚀 Hyprland	Mira para Matar Janela (Hyprkill)	Ativa cursor de mira para clicar em qualquer janela travada e fechá-la.	hyprkill.sh
SUPER + F	🚀 Hyprland	Tela Cheia Total (Fullscreen)	Expande a janela ativa para ocupar 100% da tela.	fullscreen 0
SUPER + Ctrl + F	🚀 Hyprland	Maximizar Janela (Mantém Barra/Gaps)	Maximiza a janela preservando a barra Waybar e espaçamentos.	fullscreen 1
SUPER + Shift + Space	🚀 Hyprland	Alternar Janela Flutuante / Tiling	Alterna a janela ativa entre modo livre flutuante e modo em grade.	togglefloating
SUPER + V	🚀 Hyprland	Histórico Rápido do Clipboard (Cliphist)	Menu rápido com histórico de textos copiados para colar em 2ms.	ClipManager.sh
ALT + V	🚀 Hyprland	Painel Avançado de Clipboard (CopyQ)	Área de transferência profissional com abas, imagens salvas e busca.	copyq-toggle.sh
SUPER + Shift + S ou Print	🚀 Hyprland	Captura de Tela com Anotações (Flameshot)	Screenshot de região da tela com setas, caixas, texto, blur e cópia direta.	flameshot gui
SUPER + Shift + R	🚀 Hyprland	Gravação de Tela em Vídeo/GIF	Grava vídeo da tela com som do sistema ou microfone.	screen-record.sh
SUPER + Shift + T	🚀 Hyprland	Screen OCR (Copiar Texto da Imagem)	Reconhece e extrai texto de qualquer região da tela direto pro Ctrl+V.	ocr-screen.sh
SUPER + Shift + P	🚀 Hyprland	Conta-Gotas / Seletor de Cores HEX	Lupa de precisão para copiar o código hexadecimal de qualquer cor da tela.	hyprpicker
SUPER + Shift + A	🚀 Hyprland	Alternar Saída de Som (Caixas ↔ Fones)	Muda a saída de áudio instantaneamente sem abrir painel de configurações.	audio-switch.sh
SUPER + ALT + A	🚀 Hyprland	Presets de Áudio e Graves (EasyEffects)	Menu com perfis de equalização (Bass Boost, Dolby Atmos, Podcasts).	audio-preset-switch.sh menu
SUPER + ALT + M	🚀 Hyprland	Silenciar / Desmutar Microfone	Alterna o mudo do microfone global com notificação visual.	Volume.sh --toggle-mic
SUPER + Shift + F	🚀 Hyprland	Busca Instantânea de Arquivos (FSearch)	Localizador de arquivos no disco em 0,001s (estilo Everything do Windows).	fsearch
SUPER + ALT + B	🚀 Hyprland	Menu Bluetooth Rápido	Conecta fones e dispositivos Bluetooth diretamente pelo menu Rofi.	rofi-bluetooth.sh
SUPER + ALT + W	🚀 Hyprland	Menu Wi-Fi Rápido	Gerencia redes sem fio com medidor de sinal gráfico.	rofi-wifi.sh
SUPER + ALT + G	🚀 Hyprland	Conectar / Desconectar Google Drive 5TB	Monta o disco virtual na nuvem em ~/gdrive sob demanda.	gdrive-mount.sh toggle
SUPER + C	🚀 Hyprland	Calculadora Rápida GNOME	Calculadora com conversão de moedas (Dólar, Euro, Real) ao vivo.	gnome-calculator
SUPER + ALT + C	🚀 Hyprland	Calculadora Científica (Qalculate)	Calculadora de alta precisão para engenharia, matemática e finanças.	qalculate-gtk
SUPER + ;	🚀 Hyprland	Seletor de Emojis e Símbolos	Menu Rofi para pesquisar e colar emojis, símbolos matemáticos e kaomojis.	RofiEmoji.sh
SUPER + Space	🚀 Hyprland	Trocar Layout do Teclado	Alterna entre US Internacional, ABNT2 e US Desenvolvedor.	KeyboardLayout.sh
SUPER + M	🚀 Hyprland	Spotify Flutuante (Scratchpad)	Exibe ou recolhe o Spotify em janela flutuante com blur.	spotify-toggle.sh
SUPER + Ctrl + Space	🚀 Hyprland	Play / Pause Global de Mídia	Pausa ou retoma áudio de qualquer aplicativo (Spotify, Browser, MPV).	MediaControl.sh --play-pause
SUPER + Ctrl + ]	🚀 Hyprland	Próxima Faixa de Mídia	Avança para a próxima música em reprodução no sistema.	MediaControl.sh --next
SUPER + Ctrl + [	🚀 Hyprland	Faixa Anterior de Mídia	Volta para a música anterior em reprodução no sistema.	MediaControl.sh --prev
SUPER + Shift + L	🚀 Hyprland	Letras Sincronizadas / Karaokê (sptlrx)	Janela flutuante com letras de músicas em tempo real.	lyrics-toggle.sh
SUPER + W	🚀 Hyprland	Mudar Wallpaper & Paleta do Sistema	Seletor visual de papéis de parede que sincroniza o tema Wallust.	WallpaperSelect.sh
SUPER + N	🚀 Hyprland	Luz Noturna f.lux (Pausar / Retomar)	Alterna o filtro de luz azul para descanso visual noturno.	Hyprsunset.sh toggle
SUPER + ALT + N	🚀 Hyprland	Menu de Temperaturas de Luz Noturna	Escolha a temperatura da tela (3000K, 4000K, 5000K, etc.).	Hyprsunset.sh menu
SUPER + Tab	🚀 Hyprland	Seletor Visual de Janelas Abertas	Busca rápida entre janelas ativas com miniaturas e workspace.	rofi -show window
ALT + Tab	🚀 Hyprland	Alternar para Janela Anterior (0ms)	Bate-e-volta instantâneo entre as duas últimas janelas usadas.	workspace previous
SUPER + 1 a 9	🚀 Hyprland	Mudar para Área de Trabalho (Workspace)	Vai diretamente para o workspace escolhido de 1 a 9.	workspace
SUPER + Shift + 1 a 9	🚀 Hyprland	Mover Janela para Área de Trabalho	Transfere a janela ativa para o workspace escolhido de 1 a 9.	movetoworkspace
Ctrl + Alt + L	🚀 Hyprland	Bloquear Tela (Hyprlock)	Bloqueia a sessão com tela de autenticação segura.	hyprlock
SUPER + P ou Ctrl+Alt+Del	🚀 Hyprland	Menu de Energia e Desligamento (Wlogout)	Opções de Desligar, Reiniciar, Suspender, Bloquear e Logout.	wlogout
criar-boot	⚡ Terminal	Cockpit Ventoy Multiboot	Menu interativo para formatar pen-drives e gerenciar ISOs de boot.	criar-boot
organizar --all	⚡ Terminal	Organização Master de Arquivos	Triagem e categorização automática em lote de toda a Inbox.	organizar --all
organizar --doctor	⚡ Terminal	Diagnóstico e Auditoria de Pastas	Audita e pontua a taxonomia do sistema no padrão ouro.	organizar --doctor
organizar --dedup	⚡ Terminal	Deduplicação de Arquivos (SHA-256)	Localiza arquivos duplicados e envia cópias excedentes para a quarentena.	organizar --dedup
sys-update	⚡ Terminal	Atualização Blindada do Arch Linux	Atualização com snapshot Snapper prévio e checagem de integridade.	sys-maintenance.sh
cleanup	⚡ Terminal	Faxina Inteligente do Sistema	Limpa caches antigos do pacman, arquivos temporários e logs antigos.	sys-maintenance.sh
dl <url>	⚡ Terminal	Downloader Universal de Mídia (yt-dlp)	Baixa vídeos (YouTube, Instagram, TikTok) ou áudio do Spotify em alta qualidade.	dl
fix-pendrive	⚡ Terminal	Reparar Pen-drives NTFS/FAT/exFAT	Corrige dirty-bit e erros de sistema de arquivos em pen-drives sem formatar.	fix-pendrive.sh
fix-audio	⚡ Terminal	Reiniciar Servidor PipeWire / WirePlumber	Restaura o áudio caso ocorra travamento ou estalos.	fix-audio.sh
fix-pacman	⚡ Terminal	Destravar Pacman (db.lck)	Remove travas residuais de instalações interrompidas com checagem de processo.	fix-pacman.sh
fix-keys	⚡ Terminal	Reparar Chaves PGP do Arch Linux	Atualiza e recarrega os chaveiros de segurança do sistema.	fix-keys.sh
gdrive-sync	⚡ Terminal	Sincronização Seletiva Nuvem (5TB)	Sincroniza as pastas principais de trabalho e vida com o Google Drive.	gdrive-sync.sh
rsync-turbo	⚡ Terminal	Transferência de Arquivos com Retomada	Cópia ultra-rápida imune a quedas de cabo ou energia com barra real.	rsync-turbo
pdf-edit <doc.pdf>	⚡ Terminal	Editor Profissional de PDF	Abre o Master PDF Editor para editar texto, imagens e assinaturas.	masterpdfeditor5
remover-marca-dagua	⚡ Terminal	Remover Marcas d'Água e CPFs	Limpeza visual de editais e apostilas em lote.	remover-marca-dagua.py
vibe	⚡ Terminal	Ambiente Completo Vibe Coding	Abre layout Zellij com LazyVim (70%) + Terminal de IA (30%).	vibe
lg	⚡ Terminal	Abrir LazyGit	Interface TUI completa para Git, branches, diffs e commits.	lazygit
Space (no Neovim)	💻 LazyVim	Tecla Líder (Leader Key)	Prefixo principal de todos os comandos do editor.	copy_key
Space f f	💻 LazyVim	Buscar Arquivo no Projeto por Nome	Localizador rápido de arquivos (Telescope / Snacks Picker).	copy_key
Space s g	💻 LazyVim	Buscar Texto no Projeto (Live Grep)	Busca textual profunda em tempo real em todos os arquivos.	copy_key
Space e	💻 LazyVim	Abrir/Fechar Árvore de Arquivos (Neo-tree)	Explorador de arquivos lateral integrado.	copy_key
Space g g	💻 LazyVim	Abrir LazyGit dentro do Editor	Gerenciamento Git sem sair do Neovim.	copy_key
Ctrl + p (Zellij)	💻 Zellij	Modo Painéis (Panes)	n (novo painel), x (fechar), f (fullscreen), setas (redimensionar).	copy_key
Ctrl + t (Zellij)	💻 Zellij	Modo Abas (Tabs)	n (nova aba), x (fechar aba), 1..9 (trocar de aba).	copy_key
ALT + h / j / k / l	💻 Zellij	Navegação Direta entre Painéis	Muda o foco entre os painéis do terminal sem apertar prefixos.	copy_key
EOF
}

# ------------------------------------------------------------------------------
# MODO ROFI INTERATIVO (GUI WAYLAND)
# ------------------------------------------------------------------------------
if [ "$MODE" = "rofi" ]; then
  # Se já estiver aberto, fecha imediatamente (toggle limpo)
  if pidof rofi >/dev/null 2>&1 && pgrep -f "cheat-keys.sh" >/dev/null 2>&1; then
    killall -q rofi || true
    exit 0
  fi

  theme_arg=()
  if [ -f "$HOME/.config/rofi/config-keybinds.rasi" ]; then
    theme_arg=(-theme "$HOME/.config/rofi/config-keybinds.rasi")
  elif [ -f "$HOME/.config/rofi/config-search.rasi" ]; then
    theme_arg=(-theme "$HOME/.config/rofi/config-search.rasi")
  fi

  # Renderiza a lista formatada
  selected=$(generate_database | awk -F'\t' '{printf "%-26s │ %-14s │ %-45s │ %s\n", $1, $2, $3, $4}' | \
    rofi -dmenu -i "${theme_arg[@]}" -p "🔍 Atalhos / Perguntar (Digite qualquer coisa):") || exit 0

  if [ -z "$selected" ]; then
    exit 0
  fi

  # Trata caso de pergunta de IA ou comando
  if [[ "$selected" == *"Perguntar para a IA"* ]]; then
    question=$(rofi -dmenu -i -p "🤖 Pergunte qualquer dúvida sobre atalhos/sistema:")
    if [ -n "$question" ]; then
      notify-send -u normal -i help-browser "Assistente IA" "Consultando: $question..."
      kitty --title="IA Quick Assistant" -e bash -c "echo -e '\033[1;36m=== 🤖 RESPOSTA DA IA ===\033[0m\n'; if command -v agy &>/dev/null; then agy \"$question\"; else echo -e 'Pergunta: $question\n\nVerifique os atalhos com SUPER+H ou consulte a documentação em ~/dotfiles/docs/'; fi; echo -e '\n\033[0;90mPressione ENTER para fechar...\033[0m'; read" &
    fi
    exit 0
  fi

  # Extrai a tecla e a ação
  key=$(echo "$selected" | awk -F'│' '{print $1}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  desc=$(echo "$selected" | awk -F'│' '{print $3}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  
  # Busca a ação correspondente no banco
  action=$(generate_database | grep -F "$key" | head -n1 | cut -f5 || true)

  # Se for uma ação executável direta (ex: kitty, flameshot, brave, rofi, scripts)
  if [[ -n "$action" && "$action" != "copy_key" && "$action" != "terminal_ia" && "$action" != "workspace"* && "$action" != "fullscreen"* && "$action" != "togglefloating"* && "$action" != "closewindow"* ]]; then
    notify-send -u low -i input-keyboard "Executando Ação" "$desc ($key)"
    bash -c "$action" &
    exit 0
  fi

  # Caso contrário, copia o atalho/comando para a área de transferência
  if command -v wl-copy &>/dev/null; then
    echo -n "$key" | wl-copy
    notify-send -u low -i input-keyboard "Atalho Copiado!" "Tecla: $key\n$desc"
  fi
  exit 0
fi

# Modo Terminal (FZF God-Mode)
if ! command -v fzf &>/dev/null; then
  echo -e "\033[1;36m=== ⌨️  BUSCADOR DE ATALHOS & COMANDOS ===\033[0m"
  generate_database | awk -F'\t' '{printf "\033[1;33m%-24s\033[0m \033[1;34m[%-10s]\033[0m %s\n", $1, $2, $3}'
  exit 0
fi

# Render com FZF
preview_cmd='
  line="{}"
  key=$(echo "$line" | cut -f1)
  ctx=$(echo "$line" | cut -f2)
  desc=$(echo "$line" | cut -f3)
  det=$(echo "$line" | cut -f4)
  echo -e "\033[1;35m════════════════════════════════════════════════════════════════\033[0m"
  echo -e " \033[1;32mTecla / Comando:\033[0m  \033[1;37m$key\033[0m"
  echo -e " \033[1;34mContexto:\033[0m         \033[1;36m$ctx\033[0m"
  echo -e " \033[1;33mResumo:\033[0m           \033[1;37m$desc\033[0m"
  echo -e "\033[1;35m────────────────────────────────────────────────────────────────\033[0m"
  echo -e " \033[1;37mDetalhes & Uso:\033[0m"
  echo -e " $det"
  echo -e "\033[1;35m════════════════════════════════════════════════════════════════\033[0m"
  echo ""
  echo -e "\033[0;90m[Enter] Copiar atalho/comando pro Clipboard  |  [Esc] Sair\033[0m"
'

selected=$(generate_database | fzf \
  --delimiter='\t' \
  --with-nth=1,2,3 \
  --query="$QUERY" \
  --prompt="⌨️  Buscar atalho/comando: " \
  --header="Pressione ENTER para copiar o atalho ou ESC para sair" \
  --header-first \
  --preview="$preview_cmd" \
  --preview-window=right:55%:wrap \
  --height=60% \
  --layout=reverse \
  --border)

if [ -n "$selected" ]; then
  key_cmd=$(echo "$selected" | cut -f1)
  desc=$(echo "$selected" | cut -f3)
  if command -v wl-copy &>/dev/null; then
    echo -n "$key_cmd" | wl-copy
    echo -e "\033[1;32m✔ Copiado para a área de transferência:\033[0m \033[1;37m$key_cmd\033[0m ($desc)"
  elif command -v xclip &>/dev/null; then
    echo -n "$key_cmd" | xclip -selection clipboard
    echo -e "\033[1;32m✔ Copiado para a área de transferência:\033[0m \033[1;37m$key_cmd\033[0m ($desc)"
  else
    echo -e "\033[1;33mAtalho selecionado:\033[0m $key_cmd ($desc)"
  fi
fi
