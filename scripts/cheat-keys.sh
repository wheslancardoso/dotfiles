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
ALT + Tab	Hyprland	Ciclo Rápido de Janelas (0ms)	Alterna o foco instantaneamente entre as janelas abertas sem menus lentos na tela.
ALT + SHIFT + Tab	Hyprland	Ciclo Reverso de Janelas	Volta o foco para a janela anterior no ciclo nativo do Hyprland.
SUPER + Tab	Hyprland	Seletor Visual de Janelas (Rofi)	Abre busca interativa de janelas abertas com ícones e identificador do Workspace.
SUPER + A	Hyprland	Desktop Overview (Mission Control)	Visualização em mosaico com miniaturas de todas as janelas e workspaces abertos.
CTRL + SHIFT + ESC	Hyprland	Gerenciador de Tarefas TUI (Btop)	Abre o btop instantaneamente em janela flutuante centralizada com tema Catppuccin.
SUPER + ESC	Hyprland	Gerenciador de Tarefas TUI (Btop)	Atalho alternativo com uma mão só para abrir o btop flutuante.
SUPER + Return	Hyprland	Abrir Terminal	Abre o terminal padrão do sistema (Kitty / Ghostty).
SUPER + Q	Hyprland	Fechar Janela Ativa	Fecha a janela atualmente em foco (killactive).
SUPER + Backspace	Hyprland	Mata-Processo Travado (Force Kill)	Ativa o cursor de mira do Hyprland para matar qualquer janela/app que tenha travado.
SUPER + E	Hyprland	Explorador de Arquivos Yazi (Tiled)	Abre o Yazi no terminal em modo ladrilhado (tiling).
SUPER + SHIFT + E	Hyprland	Explorador de Arquivos Yazi (Float)	Abre o Yazi em uma janela flutuante centralizada com blur.
SUPER + D	Hyprland	Menu de Aplicativos (Launcher)	Abre o lançador de aplicativos Rofi para pesquisar qualquer programa.
SUPER + V	Hyprland	Histórico Rápido do Clipboard (2ms)	Abre o histórico de textos copiados do Cliphist via Rofi para colar com 1 toque.
ALT + V	Hyprland	Área de Transferência Avançada (CopyQ)	Painel de clipboard com abas, imagens salvas e histórico permanente.
SUPER + M	Hyprland	Spotify Dropdown Scratchpad	Desce o Spotify em janela flutuante com blur Catppuccin e esconde ao teclar de novo.
SUPER + CTRL + Space	Hyprland	Play / Pause Global de Mídia	Pausa ou continua qualquer áudio/vídeo rodando (Spotify, navegador, etc.).
SUPER + CTRL + ]	Hyprland	Próxima Faixa de Mídia	Avança a música ou vídeo em reprodução.
SUPER + CTRL + [	Hyprland	Faixa Anterior de Mídia	Volta a música ou vídeo em reprodução.
SUPER + SHIFT + S	Hyprland	Captura de Tela (Flameshot)	Abre a ferramenta de screenshot com anotações, setas, blur e upload.
SUPER + SHIFT + R	Hyprland	Gravação de Tela (MP4/GIF)	Inicia ou encerra a gravação de tela com áudio do sistema ou microfone.
SUPER + SHIFT + T	Hyprland	Screen OCR (Copiar Texto da Tela)	Permite selecionar qualquer região com texto na tela e copia o texto pro clipboard via Tesseract.
SUPER + SHIFT + P	Hyprland	Conta-Gotas / Color Picker	Mapeia qualquer pixel da tela e copia a cor HEX diretamente para a área de transferência.
SUPER + SHIFT + A	Hyprland	Alternar Saída de Som (Audio Sink)	Alterna o som instantaneamente entre Caixas de Som e Fones de Ouvido via PipeWire.
SUPER + ALT + M	Hyprland	Silenciar / Ativar Microfone	Muta ou desmuta o microfone do sistema com notificação visual.
SUPER + ALT + B	Hyprland	Bluetooth Rápido (Rofi Bluetooth)	Ligue/desligue bluetooth e conecte fones sem abrir janelas de configurações.
SUPER + ALT + W	Hyprland	Wi-Fi Rápido (Rofi Wi-Fi)	Conecte-se a redes Wi-Fi e visualize o sinal com medidor gráfico no Rofi.
SUPER + ALT + G	Hyprland	Google Drive 5TB Virtual (Rclone)	Conecta ou desconecta a unidade na nuvem de 5TB em ~/gdrive via streaming VFS on-demand.
SUPER + ALT + D	Hyprland	Menu Media Downloader (yt-dlp)	Baixe qualquer vídeo ou música do YouTube, Instagram, TikTok, etc., pelo menu Rofi.
SUPER + CTRL + D	Hyprland	Baixar Mídia Tocando Agora (MPRIS)	Detecta o que está tocando no Spotify ou Navegador e baixa o arquivo em MP3/MP4 automaticamente.
SUPER + C	Hyprland	Calculadora com Conversão de Moedas	Calculadora rápida GNOME com suporte a conversão de moedas e unidades ao vivo.
SUPER + ALT + C	Hyprland	Calculadora Científica (Qalculate)	Calculadora avançada para matemática simbólica, engenharia e finanças.
SUPER + ;	Hyprland	Seletor de Emojis e Símbolos	Abre menu Rofi com emojis, glifos matemáticos e símbolos especiais.
SUPER + Space	Hyprland	Trocar Layout de Teclado	Alterna o teclado entre US Internacional (com dead keys), ABNT2 e US Puro Dev.
SUPER + H	Hyprland	Guia Visual de Atalhos (KeyHints)	Abre o Cheat Sheet visual com todos os atalhos e ferramentas do sistema.
SUPER + SHIFT + K	Hyprland	Buscador de Atalhos Hyprland	Pesquisa todos os atalhos nativos configurados no Hyprland via Rofi.
SUPER + SHIFT + M	Hyprland	Configurar Monitores (nwg-displays)	Ajuste resolução, posicionamento de telas e taxas de atualização graficamente.
SUPER + H / J / K / L	Hyprland	Mover Foco entre Janelas (Vim)	Mova o foco de tela para a Esquerda, Baixo, Cima ou Direita sem encostar no mouse.
SUPER + CTRL + H/J/K/L	Hyprland	Mover Posição da Janela (Tiling)	Reposiciona a janela atual para a esquerda, baixo, cima ou direita no grid.
SUPER + ALT + H/J/K/L	Hyprland	Redimensionar Janela Ativa	Aumenta ou diminui a largura e altura da janela selecionada.
SUPER + 1 a 10	Hyprland	Mudar para Área de Trabalho	Troca para o Workspace de 1 a 10 instantaneamente.
SUPER + SHIFT + 1 a 10	Hyprland	Mover Janela para Área de Trabalho	Leva a janela ativa para o Workspace de 1 a 10.
y	Zsh / Shell	Abrir Yazi e Mudar Diretório	Abre o explorador Yazi e ao sair com 'q' muda o diretório do terminal automaticamente.
Ctrl + Y ou Alt + Y	Zsh / Shell	Seletor Visual de Arquivos (Yazi)	Abre o Yazi no prompt para selecionar arquivos e injeta os caminhos no comando atual.
als ou aliases	Zsh / Shell	Busca Fuzzy de Aliases (FZF)	Pesquise qualquer alias do ZSH com preview ao vivo do comando equivalente.
alias-help	Zsh / Shell	Guia Categorizado de Aliases	Exibe tabela com os principais aliases do ZSH divididos por categoria.
clip [texto/pipe]	Zsh / Shell	Copiar para Área de Transferência	Ex: cat arquivo.txt | clip  ou  clip "meu texto". Compatível com Wayland (wl-copy).
qr [texto/url]	Zsh / Shell	Gerador Instantâneo de QR Code	Renderiza um QR code em UTF-8 no terminal para ler com a câmera do celular na hora.
brave-sync	Zsh / Shell	Copiar Código Brave Sync (25 palavras)	Copia o código de sincronização com a palavra do dia atualizada direto pro clipboard.
fif <termo>	Zsh / Shell	Buscar em Arquivos (Find In Files)	Ripgrep + FZF interativo com preview de código e abre no Neovim na linha exata.
fkill	Zsh / Shell	Matar Processo Interativo (FZF)	Busca qualquer processo rodando na máquina com preview e mata com 1 toque.
gdrive toggle	Zsh / Shell	Conectar/Desconectar Google Drive	Ativa ou desmonta a partição de 5TB do Google Drive em ~/gdrive.
dl <url>	Zsh / Shell	Downloader Universal de Mídia	Baixa músicas ou vídeos do YouTube, Spotify, TikTok, etc., na pasta atual via CLI.
organizar --doctor	Organizador	Diagnóstico de Pastas e Taxonomia	Testa e pontua a organização das pastas 00_ a 06_ no padrão ouro.
organizar --all	Organizador	Organização Completa de Arquivos	Executa a triagem, renomeação ISO e arquivamento em lote de todos os arquivos pendentes.
organizar --dedup	Organizador	Deduplicação de Arquivos	Localiza duplicatas exatas via hash SHA-256 e envia para quarentena segura.
pacup	Zsh / Shell	Atualização Blindada do Arch Linux	Atualiza keyring PGP primeiro, sincroniza pacotes oficiais + AUR e limpa órfãos.
cleanup	Zsh / Shell	Faxina Inteligente do Arch Linux	Remove caches antigos do pacman, arquivos temporários e logs antigos com segurança.
fix-pacman	Zsh / Shell	Destravar Pacman (db.lck)	Remove travas residuais de instalações interrompidas do Pacman com checagem de processo.
fix-keys	Zsh / Shell	Reparar Chaves PGP do Arch	Recarrega o chaveiro oficial do Arch Linux e reinstala chaves corrompidas.
fix-audio	Zsh / Shell	Reiniciar Servidor PipeWire	Reinicia serviços de som PipeWire e WirePlumber em caso de estalos ou desconexões.
fix-pendrive	Zsh / Shell	Reparar Pen-drive / HD Externo	Repara dirty-bit em partições NTFS e FAT32 de pen-drives sem formatar.
fix-suspend	Zsh / Shell	Diagnóstico de Suspensão / Sleep	Identifica e bloqueia dispositivos USB que impedem o PC de suspender ou acordam sozinhos.
tp <arquivo>	Zsh / Shell	Enviar para Lixeira Segura	Move arquivo para ~/.local/share/Trash (trash-put) sem risco de deleção irreversível.
tl	Zsh / Shell	Listar Lixeira	Exibe lista de todos os arquivos na lixeira com data e caminho de origem.
trestore	Zsh / Shell	Restaurar Arquivo da Lixeira	Restaura arquivo deletado para o local original através de menu interativo com número.
tempty	Zsh / Shell	Esvaziar Lixeira	Esvazia completamente a lixeira do sistema de forma segura.
vibe	Zsh / Shell	Layout Vibe Coding (Zellij)	Inicia layout com LazyVim (70%) + Antigravity CLI (30%) + Runner.
fullstack	Zsh / Shell	Layout Fullstack (Zellij)	Inicia layout com LazyVim + IA + Banco de Dados / Docker.
mobile	Zsh / Shell	Layout Mobile Dev (Zellij)	Inicia layout com LazyVim + IA + Emulador / Metro Bundler.
lg	Zsh / Shell	Abrir LazyGit	Interface TUI de alta produtividade para commits, diffs, branches e merges.
ld	Zsh / Shell	Abrir LazyDocker	Gerenciador TUI para inspecionar e controlar contêineres e imagens Docker.
z <pasta>	Zsh / Shell	Salto Inteligente de Diretório	Navegue para qualquer pasta usando histórico de uso do Zoxide (ex: z docs, z dev).
c z	Yazi	Compactar para .ZIP	No Yazi, compacta os arquivos selecionados para arquivo .zip.
c 7	Yazi	Compactar para .7Z	No Yazi, compacta com máxima taxa de compressão LZMA2.
c t	Yazi	Compactar para .TAR.GZ	No Yazi, compacta para o formato padrão do ecossistema Linux.
X (maiúsculo)	Yazi	Extrair para Subpasta Limpa	Extrai arquivo compactado diretamente em uma nova pasta com o nome do arquivo.
e s	Yazi	Extrair para Subpasta	Atalho alternativo para extrair sem espalhar arquivos.
e x	Yazi	Extrair Aqui (Extract Here)	Extrai o conteúdo do arquivo compactado na pasta atual.
g i	Yazi	Saltar para 00_Inbox	Navega instantaneamente para a pasta de downloads e triagem.
g p	Yazi	Saltar para 01_Pessoal	Navega para pasta de documentos pessoais, saúde e finanças.
g e	Yazi	Saltar para 03_Estudos	Navega para pasta de estudos, livros e carreira.
g v	Yazi	Saltar para 04_Dev	Navega para a pasta de desenvolvimento e repositórios Git.
g j	Yazi	Saltar para 06.4_Games	Navega para a pasta de jogos e emuladores.
g G	Yazi	Saltar para Google Drive 5TB	Navega direto para a raiz do Google Drive virtual montado (~/gdrive).
g .	Yazi	Saltar para Dotfiles	Navega para a pasta de configurações ~/dotfiles.
M o	Yazi	Organizar Tudo (Organizador Master)	Dispara a organização de arquivos pelo menu de ações master do Yazi.
M d	Yazi	Doctor Diagnóstico	Executa o diagnóstico da taxonomia pelo Yazi.
M s	Yazi	Backup de Saves (Ludusavi)	Sincroniza os saves dos seus jogos instalados para o Google Drive.
M y	Yazi	Baixar Mídia Nesta Pasta	Dispara download de vídeo/áudio da área de transferência para a pasta atual.
s <letras>	LazyVim	Flash Jump	Pula o cursor instantaneamente para qualquer palavra visível na tela no Neovim.
<leader>ff	LazyVim	Buscar Arquivo no Projeto	Abre busca interativa de arquivos por nome (Telescope) no Neovim.
<leader>sg	LazyVim	Buscar Texto em Arquivos (Grep)	Pesquisa texto em tempo real em todos os arquivos do projeto (Live Grep).
<leader>gg	LazyVim	Abrir LazyGit no Neovim	Abre o LazyGit em janela flutuante sobre o editor.
<leader>gd	LazyVim	Abrir Diffview	Visualização lado a lado de todas as modificações Git do projeto.
<leader>D	LazyVim	Gerenciador de Banco de Dados	Abre interface Dadbod UI para consultar Postgres, MySQL e SQLite.
<leader>Rr	LazyVim	Executar Requisição HTTP (Kulala)	Dispara chamada REST sob o cursor e exibe o JSON de retorno com headers.
ysiw"	LazyVim	Surround com Aspas Duplas	Envolve a palavra atual com aspas duplas ("palavra").
cs"'	LazyVim	Trocar Aspas Duplas por Simples	Altera o delimitador ao redor da palavra de " para '.
ds"	LazyVim	Remover Aspas	Deleta as aspas ao redor da palavra atual.
EOF
}

# Modo Rofi (GUI)
if [ "$MODE" = "rofi" ]; then
  selected=$(generate_database | awk -F'\t' '{printf "%-24s │ %-12s │ %s\n", $1, $2, $3}' | \
    rofi -dmenu -i -p "⌨️ Buscar Atalho ou Comando" -theme ~/.config/rofi/config-keybinds.rasi 2>/dev/null || \
    rofi -dmenu -i -p "⌨️ Buscar Atalho ou Comando")
  
  if [ -n "$selected" ]; then
    key_cmd=$(echo "$selected" | awk -F'│' '{print $1}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if command -v wl-copy &>/dev/null; then
      echo -n "$key_cmd" | wl-copy
      notify-send -u low -i input-keyboard "Atalho Copiado" "$key_cmd copiado para a área de transferência!" 2>/dev/null || true
    fi
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
