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
# Base de Dados Unificada e Enriquecida de Atalhos, Ações e Comandos:
# Formato: ATALHO/TECLA \t CATEGORIA \t TÍTULO \t DESCRIÇÃO \t TAGS_BUSCA \t AÇÃO
generate_database() {
cat << 'EOF'
🤖 Perguntar para a IA	🧠 Assistente	Tirar Dúvida com IA do Sistema	Abre o assistente de IA para responder qualquer dúvida de comandos ou atalhos.	ia duvida ajuda pergunta prompt sistema comando terminal	terminal_ia
c p	📂 Yazi	Copiar Caminho Absoluto	Copia o caminho completo (ex: /mnt/dados/pasta/arquivo.iso) direto pro Clipboard.	copiar caminho path localizacao pasta arquivo absoluto fullpath endereco clipboard wayland wl-copy yazi	copy_key
c f	📂 Yazi	Copiar Nome do Arquivo	Copia apenas o nome do arquivo com a extensão (ex: video.mp4).	copiar nome filename title nome arquivo name clipboard yazi	copy_key
c d	📂 Yazi	Copiar Caminho da Pasta	Copia o diretório/pasta onde você está navegando no Yazi.	copiar pasta dirpath dirname diretorio caminho pasta localizacao yazi	copy_key
F2 ou r	📂 Yazi	Renomear Inteligente	Limpa o nome mantendo a extensão (.mp4/.pdf/.iso) intacta para digitação direta.	renomear rename mudar nome editar nome titulo f2 r stem preservar extensao yazi	copy_key
r e	📂 Yazi	Mudar Extensão do Arquivo	Permite alterar o formato/extensão (.mkv -> .mp4, .txt -> .md).	mudar extensao trocar extensao formato rename ext all yazi	copy_key
u ou Ctrl+Z	📂 Yazi	Desfazer Renomeação (Undo)	Restaura o nome anterior do arquivo caso tenha errado ao renomear.	desfazer undo reverter voltar cancelar erro renomear nome anterior yazi	copy_key
y	📂 Yazi	Copiar Arquivo Físico (Yank)	Copia o arquivo selecionado para colar com 'p' em qualquer outra pasta.	copiar arquivo duplicar transferir yank paste yazi	copy_key
x	📂 Yazi	Recortar Arquivo Físico (Cut)	Recorta o arquivo para mover com 'p' para outra pasta.	recortar cortar mover transferir cut yazi	copy_key
p	📂 Yazi	Colar Arquivo(s)	Cola os arquivos copiados ou recortados na pasta atual.	colar paste inserir descarregar yazi	copy_key
d d	📂 Yazi	Mover para a Lixeira (Trash)	Envia o arquivo para a lixeira segura sem risco de perda permanente.	lixeira trash apagar deletar remover excluir dd lixeira segura yazi	copy_key
D	📂 Yazi	Deletar Permanentemente	Apaga o arquivo em definitivo do disco sem passar pela lixeira.	deletar permanente apagar direto excluir definitivo sem lixeira yazi	copy_key
Ctrl + Y	📂 Yazi	Arrastar Arquivo (Drag & Drop)	Abre o seletor visual para arrastar arquivos com o mouse pro Brave, Discord ou WhatsApp.	arrastar soltar drag drop ripdrag navegador discord whatsapp anexar yazi	copy_key
Ctrl + D	📂 Yazi	Comparar Arquivos (Diff)	Abre visualizador de diferenças entre dois arquivos selecionados.	diff comparar diferenca alteracoes versao yazi	copy_key
c z	📂 Yazi	Comprimir para .ZIP (Rápido)	Compacta arquivos ou pastas selecionadas em .zip.	compactar comprimir zip zipar empacotar rapido yazi	copy_key
c 7	📂 Yazi	Comprimir para .7Z (Ultra LZMA2)	Compacta com compressão máxima multi-thread 7-Zip.	compactar comprimir 7z 7zip lzma2 ultra maximo yazi	copy_key
c t	📂 Yazi	Comprimir para .TAR.GZ (Linux)	Compacta no formato padrão do ecossistema Unix/Linux.	compactar comprimir tar targz tar.gz linux gzip yazi	copy_key
X ou e s	📂 Yazi	Extrair para Subpasta Limpa	Descompacta o arquivo criando automaticamente uma pasta com o nome dele (1 toque).	extrair descompactar unzip extract subpasta descompactar limpo yazi	copy_key
e x	📂 Yazi	Extrair Conteúdo Aqui	Descompacta todos os arquivos diretamente na pasta atual.	extrair aqui extract here descompactar solto yazi	copy_key
z	📂 Yazi	Pulo Rápido por Pastas (Zoxide)	Aperte 'z', digite parte do nome da pasta (ex: down, dev) e pule na hora.	pular navegar zoxide jump ir para pasta z yazi	copy_key
Z	📂 Yazi	Busca Recursiva Fuzzy (FZF)	Busca ultra-rápida em profundidade com preview e toggle de ocultos (Ctrl+H).	buscar pesquisar fzf fuzzy recursivo localizar arquivo achar yazi	copy_key
M m	📂 Yazi	Montar / Ejetar Discos e Pen-drives	Gerenciador de montagem e ejeção segura de mídias USB e partições.	montar ejetar pendrive usb disco hd externo mount unmount yazi	copy_key
M B	📂 Yazi	Enviar ISOs para o Ventoy	Copia imagens de boot diretamente para o pen-drive Ventoy Multiboot.	enviar copiar iso ventoy boot pendrive multiboot yazi	copy_key
M u	📂 Yazi	Reparar Pen-drive (NTFS/FAT)	Corrige dirty-bit e partições corrompidas de pen-drives e HDs externos.	reparar destravar corrigir pendrive chkdsk fsck ntfs fat exfat yazi	copy_key
M o	📂 Yazi	Organizar Downloads / Inbox	Aciona o Organizador Master para triagem e categorização automática.	organizar arrumar triagem inbox downloads classificar yazi	copy_key
M d	📂 Yazi	Diagnóstico do Sistema (Doctor)	Testa a saúde das pastas e integridade da taxonomia.	doctor diagnostico verificar integridade pastas yazi	copy_key
M a ou M y	📂 Yazi	Baixar Mídia Nesta Pasta	Baixa vídeo ou áudio do link copiado diretamente na pasta atual via yt-dlp.	baixar download video musica youtube link clipboard yt-dlp yazi	copy_key
M g	📂 Yazi	Abrir Lazygit Nesta Pasta	Abre interface gráfica de Git no diretório atual.	git lazygit commits branches diff yazi	copy_key
M t	📂 Yazi	Abrir Terminal Nesta Pasta	Abre uma nova janela do terminal no diretório atual.	terminal console abrir pasta kitty yazi	copy_key
. (ponto)	📂 Yazi	Mostrar / Ocultar Ocultos	Alterna a exibição de dotfiles e pastas ocultas.	ocultos dotfiles ponto mostrar esconder toggle hidden yazi	copy_key
g i	📂 Yazi	Ir para 00_Inbox_Triagem	Navega para a pasta de downloads e triagem.	ir inbox downloads triagem pasta goto jump yazi	copy_key
g p	📂 Yazi	Ir para 01_Pessoal	Navega para a pasta de documentos pessoais e finanças.	ir pessoal documentos financas saude goto jump yazi	copy_key
g e	📂 Yazi	Ir para 03_Estudos_Carreira	Navega para a pasta de estudos, concursos e livros.	ir estudos concursos livros carreira tce goto jump yazi	copy_key
g v	📂 Yazi	Ir para 04_Dev	Navega para a pasta de desenvolvimento e código.	ir dev programacao codigo git projetos goto jump yazi	copy_key
g m	📂 Yazi	Ir para 05_Midias	Navega para a pasta de vídeos, músicas e design.	ir midias videos musicas design fotos goto jump yazi	copy_key
g j	📂 Yazi	Ir para 06.4_Games	Navega para a pasta de jogos e emuladores.	ir games jogos emuladores roms goto jump yazi	copy_key
g b	📂 Yazi	Ir para 06.3_ISOs_e_Boot	Navega para a pasta de ISOs do Ventoy e instaladores.	ir boot isos ventoy instaladores sistemas goto jump yazi	copy_key
g G	📂 Yazi	Ir para Google Drive 5TB	Navega para o Google Drive virtual montado em ~/gdrive.	ir drive gdrive nuvem 5tb google drive goto jump yazi	copy_key
g .	📂 Yazi	Ir para ~/dotfiles	Navega para a pasta do repositório de configurações do sistema.	ir dotfiles configs configuracoes sistema goto jump yazi	copy_key
→ (Seta Direita)	🎬 MPV	Avançar 10 Segundos	Seek ultra-rápido de 10s otimizado para YouTube e vídeos locais.	avancar pular adiantar frente 10s dez segundos youtube seek mpv	copy_key
← (Seta Esquerda)	🎬 MPV	Voltar 10 Segundos	Retrocede 10s no player sem engasgos.	voltar retroceder tras 10s dez segundos youtube seek mpv	copy_key
↑ (Seta Cima)	🎬 MPV	Avançar 30 Segundos	Pula 30 segundos à frente no vídeo.	avancar pular adiantar frente 30s trinta segundos seek mpv	copy_key
↓ (Seta Baixo)	🎬 MPV	Voltar 30 Segundos	Retrocede 30 segundos no vídeo.	voltar retroceder tras 30s trinta segundos seek mpv	copy_key
Shift + →	🎬 MPV	Avançar 1 Minuto (60s)	Salto de 1 minuto na linha do tempo.	avancar pular frente 1m 60s um minuto seek mpv	copy_key
Shift + ←	🎬 MPV	Voltar 1 Minuto (60s)	Retrocesso de 1 minuto na linha do tempo.	voltar retroceder tras 1m 60s um minuto seek mpv	copy_key
Ctrl + →	🎬 MPV	Avançar 5 Minutos (300s)	Salto longo de 5 minutos com carregamento assíncrono.	avancar pular frente 5m 300s cinco minutos seek mpv	copy_key
Ctrl + ←	🎬 MPV	Voltar 5 Minutos (300s)	Retrocesso longo de 5 minutos direto da memória RAM.	voltar retroceder tras 5m 300s cinco minutos seek mpv	copy_key
[ ou ]	🎬 MPV	Ajustar Velocidade	Ajusta a velocidade (1.1x, 1.25x...) com correção de pitch (sem voz de esquilo).	velocidade acelerar desacelerar rapido devagar speed 1.25x 1.5x 2x mpv	copy_key
BS (Backspace)	🎬 MPV	Resetar Velocidade (1.0x)	Retorna a reprodução para a velocidade normal instantaneamente.	resetar velocidade normal 1.0x padrao padronizar mpv	copy_key
Alt + I ou Ctrl + N	🎬 MPV	Modo Imersão (sub-skip)	Acelera automaticamente nos momentos de silêncio e desacelera nas falas.	imersao ingles silencio acelerar silêncios subskip sub-skip mpv	copy_key
TAB	🎬 MPV	Pular Abertura / Intro	Salta a vinheta inicial de séries e animes com 1 tecla estilo Netflix.	pular abertura intro vinheta netflix anime serie skip intro mpv	copy_key
V (Shift + v)	🎬 MPV	Remover Legenda Forçada	Mata legendas forçadas indesejadas e filtra apenas trilhas limpas.	legenda forçada forced sub killer limpar sumir legenda mpv	copy_key
Ctrl + Z	🎬 MPV	Sincronizar Legenda por Voz	Reconhecimento de áudio (ffsubsync) para sincronizar legendas atrasadas/adiantadas.	sincronizar legenda audio voz atrasada adiantada ffsubsync sync mpv	copy_key
Ctrl + S	🎬 MPV	Baixar Legendas Online	Busca e baixa legendas em português/inglês direto do OpenSubtitles.	baixar legenda download subtitles opensubtitles legenda pt legendas mpv	copy_key
N	🎬 MPV	Modo Noturno de Áudio	Comprime explosões e clareia sussurros e diálogos (Dynamic Range Compression).	modo noturno normalizar volume audio noite vozes explosoes mpv	copy_key
Alt + B	🎬 MPV	Máscara Anti-Hardsub	Gera tarja preta sobre legendas gravadas no vídeo para sobrepor novas.	hardsub mascara tarja preta cobrir legenda gravada mpv	copy_key
Ctrl + 1 / 2 / 3	🎬 MPV	Shaders Anime4K	Aplica redes neurais para restaurar traços e upscaling em tempo real de animes.	anime4k shaders anime qualidade imagem upscaling ia desenho mpv	copy_key
Ctrl + 4 / 5	🎬 MPV	Shaders Cinema IA (FSRCNNX)	Super-resolução neural 16-Core para filmes e séries live-action.	cinema shaders filme serie fsrcnnx ia upscaling 4k hd mpv	copy_key
F1 ou ? ou h	🎬 MPV	Ajuda HUD do Player	Abre painel na tela do vídeo com todas as teclas do MPV.	ajuda cheatsheet teclas atalhos hud tela player mpv	copy_key
SUPER + H ou SUPER + /	🚀 Hyprland	Buscador Universal de Atalhos	Abre a busca interativa de atalhos, comandos e IA do sistema (Este Menu).	ajuda buscador atalhos help cheatsheet comandos teclas super h super /	cheat-keys.sh --rofi
SUPER + Return	🚀 Hyprland	Abrir Terminal Principal	Inicia o terminal Kitty padrão com aceleração de GPU e velocidade máxima.	abrir terminal kitty console prompt super enter return	kitty
SUPER + Shift + Return	🚀 Hyprland	Terminal Suspenso (Quake)	Desce um terminal flutuante do topo da tela e recolhe com a mesma tecla.	terminal suspenso quake dropdown flutuante scratchpad terminal	scratchpad-term.sh
SUPER + B	🚀 Hyprland	Abrir Navegador Brave	Abre o navegador Brave blindado e otimizado com aceleração de hardware.	abrir navegador internet browser brave chrome web google	brave
SUPER + D	🚀 Hyprland	Lançador de Apps (Rofi)	Lançador de aplicativos e programas instalados com busca fuzzy.	lancar abrir programa aplicativo launcher rofi menu apps	rofi -show drun
SUPER + E	🚀 Hyprland	Abrir Yazi (Explorador)	Abre o gerenciador de arquivos rápido no grid de janelas.	abrir yazi gerenciador arquivos pastas explorer tiling	open-yazi-tiled.sh
SUPER + Shift + E	🚀 Hyprland	Abrir Yazi Flutuante	Abre o Yazi em uma janela flutuante centralizada.	abrir yazi flutuante janela popup 50%	open-yazi.sh
SUPER + Q	🚀 Hyprland	Fechar Janela Ativa	Fecha a janela atualmente em foco de forma suave (killactive).	fechar janela sair encerrar app close killactive	closewindow
SUPER + Shift + Q	🚀 Hyprland	Forçar Fechamento (Kill)	Mata o processo travado imediatamente com sinal SIGKILL.	matar processo travar travar forcar kill encerrar forçado	KillActiveProcess.sh
SUPER + Backspace	🚀 Hyprland	Mira para Matar Janela	Ativa cursor de mira para clicar em qualquer janela travada e fechá-la.	mira matar janela travar hyprkill xkill clique fechar	hyprkill.sh
SUPER + F	🚀 Hyprland	Tela Cheia (Fullscreen)	Expande a janela ativa para ocupar 100% da tela.	tela cheia fullscreen maximizar total tela	fullscreen 0
SUPER + Ctrl + F	🚀 Hyprland	Maximizar Janela	Maximiza a janela preservando a barra Waybar e espaçamentos.	maximizar janela manter barra gaps fullscreen 1	fullscreen 1
SUPER + Shift + Space	🚀 Hyprland	Alternar Flutuante / Tiling	Alterna a janela ativa entre modo livre flutuante e modo em grade.	flutuante grade tiling janela solta togglefloating	togglefloating
SUPER + V	🚀 Hyprland	Histórico Rápido Clipboard	Menu rápido com histórico de textos copiados para colar em 2ms (Cliphist).	clipboard area de transferencia historico copiar colar texto cliphist	ClipManager.sh
ALT + V	🚀 Hyprland	Painel Avançado CopyQ	Área de transferência profissional com abas, imagens salvas e busca permanente.	copyq clipboard avancado abas imagens historico permanente	copyq-toggle.sh
SUPER + Shift + S ou Print	🚀 Hyprland	Captura de Tela (Flameshot)	Screenshot de região da tela com setas, caixas, texto, blur e cópia direta.	screenshot print printscreen captura foto tela recorte flameshot	flameshot gui
SUPER + Shift + R	🚀 Hyprland	Gravação de Tela (Vídeo/GIF)	Grava vídeo da tela com som do sistema ou microfone via wf-recorder.	gravar gravacao video tela record gravador som audio microfone gif mp4	screen-record.sh
SUPER + Shift + T	🚀 Hyprland	Screen OCR (Copiar Texto)	Reconhece e extrai texto de qualquer região da tela direto pro Ctrl+V.	ocr copiar texto imagem extrair texto ler tela tesseract	ocr-screen.sh
SUPER + Shift + P	🚀 Hyprland	Conta-Gotas / Cor HEX	Lupa de precisão para copiar o código hexadecimal de qualquer cor da tela.	cor hex conta gotas color picker cor tela hyprpicker	hyprpicker
SUPER + Shift + A	🚀 Hyprland	Alternar Som (Caixas ↔ Fones)	Muda a saída de áudio instantaneamente sem abrir painel de configurações.	som audio fone headset caixa alternar saida autofalante pipewire	audio-switch.sh
SUPER + ALT + A	🚀 Hyprland	Presets de Áudio e Graves	Menu com perfis de equalização (Bass Boost, Dolby Atmos, Podcasts).	equalizador grave bass boost dolby atmos som presets easyeffects	audio-preset-switch.sh menu
SUPER + ALT + M	🚀 Hyprland	Mudo do Microfone	Alterna o mudo do microfone global com notificação visual.	microfone mutar desmutar mudo mic som silenciar	Volume.sh --toggle-mic
SUPER + Shift + F	🚀 Hyprland	Busca Instantânea (FSearch)	Localizador de arquivos no disco em 0,001s (estilo Everything do Windows).	buscar arquivos achar fsearch everything pesquisar disco	fsearch
SUPER + ALT + B	🚀 Hyprland	Menu Bluetooth Rápido	Conecta fones e dispositivos Bluetooth diretamente pelo menu Rofi.	bluetooth fone conectar parear dispositivos sem fio	rofi-bluetooth.sh
SUPER + ALT + W	🚀 Hyprland	Menu Wi-Fi Rápido	Gerencia redes sem fio com medidor de sinal gráfico.	wifi rede internet sem fio conectar ssid senha	rofi-wifi.sh
SUPER + ALT + G	🚀 Hyprland	Google Drive 5TB (Montar)	Monta o disco virtual na nuvem em ~/gdrive sob demanda via Rclone.	google drive gdrive nuvem 5tb montar conectar rclone	gdrive-mount.sh toggle
SUPER + C	🚀 Hyprland	Calculadora com Moedas	Calculadora com conversão de moedas (Dólar, Euro, Real) e unidades ao vivo.	calculadora calcular dolar euro real cotacao moedas contas	gnome-calculator
SUPER + ALT + C	🚀 Hyprland	Calculadora Científica	Calculadora de alta precisão para engenharia, matemática e finanças.	calculadora cientifica qalculate matematica engenharia contas	qalculate-gtk
SUPER + ;	🚀 Hyprland	Seletor de Emojis	Menu Rofi para pesquisar e colar emojis, símbolos matemáticos e kaomojis.	emoji simbolo carinha emoticon emoji picker	RofiEmoji.sh
SUPER + Space	🚀 Hyprland	Trocar Layout Teclado	Alterna entre US Internacional, ABNT2 e US Desenvolvedor.	teclado layout abnt2 us internacional trocar teclado idioma	KeyboardLayout.sh
SUPER + M	🚀 Hyprland	Spotify Flutuante	Exibe ou recolhe o Spotify em janela flutuante com blur.	spotify musica player dropdown scratchpad	spotify-toggle.sh
SUPER + Ctrl + Space	🚀 Hyprland	Play / Pause Global	Pausa ou retoma áudio de qualquer aplicativo (Spotify, Browser, MPV).	play pause pausar tocar midia musica video	MediaControl.sh --play-pause
SUPER + Ctrl + ]	🚀 Hyprland	Próxima Música	Avança para a próxima música em reprodução no sistema.	proxima musica faixa next track avancar musica	MediaControl.sh --next
SUPER + Ctrl + [	🚀 Hyprland	Música Anterior	Volta para a música anterior em reprodução no sistema.	musica anterior voltar faixa prev track	MediaControl.sh --prev
SUPER + Shift + L	🚀 Hyprland	Letras / Karaokê (sptlrx)	Janela flutuante com letras de músicas sincronizadas em tempo real.	letras karaoke sincronizado sptlrx letra musica	lyrics-toggle.sh
SUPER + W	🚀 Hyprland	Mudar Wallpaper & Paleta	Seletor visual de papéis de parede que sincroniza o tema Wallust.	wallpaper papel de parede fundo wallust tema cores	WallpaperSelect.sh
SUPER + N	🚀 Hyprland	Luz Noturna f.lux	Alterna o filtro de luz azul para descanso visual noturno.	luz noturna flux filtro azul noite descanso visual	Hyprsunset.sh toggle
SUPER + ALT + N	🚀 Hyprland	Temperatura da Tela	Escolha a temperatura da tela (3000K, 4000K, 5000K, etc.).	temperatura tela cores calor quente fria luz noturna	Hyprsunset.sh menu
SUPER + Tab	🚀 Hyprland	Seletor de Janelas Abertas	Busca rápida entre janelas ativas com miniaturas e workspace.	janelas abertas alternar switcher rofi window	rofi -show window
ALT + Tab	🚀 Hyprland	Janela Anterior (0ms)	Bate-e-volta instantâneo entre as duas últimas janelas usadas.	alt tab alternar janela anterior voltar foco	workspace previous
SUPER + 1 a 9	🚀 Hyprland	Mudar Workspace	Vai diretamente para a área de trabalho escolhida de 1 a 9.	workspace area de trabalho mudar tela desktop 1 2 3 4 5	workspace
SUPER + Shift + 1 a 9	🚀 Hyprland	Mover para Workspace	Transfere a janela ativa para a área de trabalho escolhida de 1 a 9.	mover janela workspace transferir desktop	movetoworkspace
Ctrl + Alt + L	🚀 Hyprland	Bloquear Tela (Hyprlock)	Bloqueia a sessão com tela de autenticação segura.	bloquear tela lock trancar hyprlock seguranca	hyprlock
SUPER + P ou Ctrl+Alt+Del	🚀 Hyprland	Menu de Energia / Desligar	Opções de Desligar, Reiniciar, Suspender, Bloquear e Logout (Wlogout).	desligar reiniciar suspender sair logout menu energia wlogout	wlogout
criar-boot	⚡ Terminal	Cockpit Ventoy Multiboot	Menu interativo para formatar pen-drives e gerenciar ISOs de boot.	criar boot ventoy formatar pendrive usb multiboot instalador iso medicat	criar-boot
organizar --all	⚡ Terminal	Organização Master de Arquivos	Triagem e categorização automática em lote de toda a Inbox.	organizar arrumar triagem inbox downloads classificar pastas	organizar --all
organizar --doctor	⚡ Terminal	Diagnóstico de Pastas (Doctor)	Audita e pontua a taxonomia do sistema no padrão ouro.	doctor diagnostico integridade pastas auditoria	organizar --doctor
organizar --dedup	⚡ Terminal	Deduplicação de Arquivos	Localiza arquivos duplicados e envia cópias excedentes para a quarentena.	duplicados dedup apagar copias hash sha256	organizar --dedup
sys-update	⚡ Terminal	Atualização do Arch Linux	Atualização completa com snapshot Snapper prévio e checagem de chaves.	atualizar sistema pacman yay update upgrade arch safe update	sys-maintenance.sh
cleanup	⚡ Terminal	Faxina Inteligente do Sistema	Limpa caches antigos do pacman, arquivos temporários e logs antigos.	limpar faxina lixo cache pacman orfaos espaco em disco	sys-maintenance.sh
dl <url>	⚡ Terminal	Download de Vídeo / Áudio (yt-dlp)	Baixa vídeos (YouTube, Instagram, TikTok) ou áudio do Spotify em alta qualidade.	baixar video download musica youtube spotify instagram tiktok dl	dl
fix-pendrive	⚡ Terminal	Reparar Pen-drives e Discos	Corrige dirty-bit e erros de sistema de arquivos em pen-drives sem formatar.	reparar destravar consertar pendrive disco ntfs fat exfat	fix-pendrive.sh
fix-audio	⚡ Terminal	Reiniciar Servidor de Som	Restaura o áudio caso ocorra travamento, estalos ou desconexão.	reiniciar som audio estalo travar pipewire wireplumber	fix-audio.sh
fix-pacman	⚡ Terminal	Destravar Pacman (db.lck)	Remove travas residuais de instalações interrompidas do Pacman.	destravar pacman db.lck lock travado erro pacman	fix-pacman.sh
fix-keys	⚡ Terminal	Reparar Chaves PGP do Arch	Atualiza e recarrega os chaveiros de segurança do sistema.	chaves pgp erro chave assinatura keyring arch linux	fix-keys.sh
gdrive-sync	⚡ Terminal	Sincronização Nuvem (5TB)	Sincroniza as pastas principais de trabalho e vida com o Google Drive.	sincronizar nuvem backup google drive gdrive rclone	gdrive-sync.sh
rsync-turbo	⚡ Terminal	Transferência com Retomada	Cópia ultra-rápida imune a quedas de cabo ou energia com barra real.	copiar rsync turbo transferencia segura barra progresso	rsync-turbo
pdf-edit <doc.pdf>	⚡ Terminal	Editor Profissional de PDF	Abre o Master PDF Editor para editar texto, imagens e assinaturas.	pdf editor editar assinar preencher texto master pdf	masterpdfeditor5
remover-marca-dagua	⚡ Terminal	Remover Marcas d'Água de PDF	Limpeza visual de editais, CPFs e apostilas em lote.	marca dagua cpf edital apostila pdf remover limpar	remover-marca-dagua.py
vibe	⚡ Terminal	Ambiente Vibe Coding	Abre layout Zellij com LazyVim (70%) + Terminal de IA (30%).	programar vibe coding dev zellij neovim ia layout	vibe
lg	⚡ Terminal	Abrir LazyGit	Interface TUI completa para Git, branches, diffs e commits.	git lazygit interface terminal commits branches	lazygit
Space (no Neovim)	💻 LazyVim	Tecla Líder (Leader Key)	Prefixo principal de todos os comandos do editor.	leader tecla lider space neovim lazyvim	copy_key
Space f f	💻 LazyVim	Buscar Arquivo no Projeto	Localizador rápido de arquivos por nome (Telescope / Snacks Picker).	buscar arquivo find files telescope neovim lazyvim	copy_key
Space s g	💻 LazyVim	Buscar Texto no Projeto (Grep)	Busca textual profunda em tempo real em todos os arquivos (Live Grep).	buscar texto live grep ripgrep pesquisar codigo neovim	copy_key
Space e	💻 LazyVim	Árvore de Arquivos (Neo-tree)	Explorador de arquivos lateral integrado.	arvore arquivos explorer neo-tree neotree neovim	copy_key
Space g g	💻 LazyVim	Abrir LazyGit no Editor	Gerenciamento Git sem sair do Neovim.	git lazygit editor neovim	copy_key
Ctrl + p (Zellij)	💻 Zellij	Modo Painéis (Panes)	n (novo painel), x (fechar), f (fullscreen), setas (redimensionar).	paineis panes split dividir tela zellij	copy_key
Ctrl + t (Zellij)	💻 Zellij	Modo Abas (Tabs)	n (nova aba), x (fechar aba), 1..9 (trocar de aba).	abas tabs nova aba zellij	copy_key
ALT + h / j / k / l	💻 Zellij	Navegação entre Painéis	Muda o foco entre os painéis do terminal sem apertar prefixos.	navegar paineis foco terminal zellij	copy_key
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

  # Renderiza a lista com todas as palavras-chave invisíveis pesquisáveis
  selected=$(generate_database | awk -F'\t' '{printf "%-22s │ %-12s │ %-38s │ %s  \033[30m[%s]\033[0m\n", $1, $2, $3, $4, $5}' | \
    rofi -dmenu -i -normalize-match -matching normal -tokenize "${theme_arg[@]}" -p "🔍 Digite qualquer ação ou atalho:") || exit 0

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
