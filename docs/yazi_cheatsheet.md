# 📂 Yazi Quick Cheat Sheet (Resumo Rápido)

> 📖 **Guia Completo**: Para explicação detalhada de cada função, consulte o [GUIA_YAZI_POWERUSER.md](file:///home/lan/dotfiles/docs/GUIA_YAZI_POWERUSER.md).

---

## 📦 Compactação & Extração Instantânea
- `c` + `z`      : **Compactar para .ZIP** (Rápido e compatível)
- `c` + `7`      : **Compactar para .7Z** (Ultra compressão LZMA2)
- `c` + `t`      : **Compactar para .TAR.GZ** (Linux padrão)
- `c` + `c`      : **Compactar Personalizado** (Prompt para nome e formato)
- `X` *(maiúsc)* : **Extrair para Subpasta** (Limpo - 1 toque)
- `e` + `s`      : **Extrair para Subpasta**
- `e` + `x`      : **Extrair Aqui**
- `Enter`        : Em arquivo compactado, extrai automaticamente para subpasta!

---

## 🔍 Busca Cirúrgica & Navegação Instantânea
- `Z` *(Shift+Z)* : **Busca Recursiva FZF Turbo** (com `Ctrl+H` alterna ocultos, `Ctrl+D` só pastas, `Ctrl+F` só arquivos, preview Bat/Tree)
- `z` *(minúsc)* : **Salto Zoxide no Yazi** (Digite `down`, `mus`, `dev` e dê Enter para pular instantaneamente)
- `s`            : **Busca por Nome (`fd`)** (Lista os arquivos encontrados diretamente na árvore do Yazi)
- `S`            : **Busca por Conteúdo (`ripgrep`)** (Pesquisa texto dentro dos arquivos recursivamente)
- `f`            : **Filtro Rápido** (Filtra a pasta atual em tempo real enquanto você digita)
- `yf [termo]`   : *(No Terminal)* **Busca Pá-Pum** (Abre o Yazi focado diretamente no arquivo selecionado)

---

## 📌 Favoritos Dinâmicos & Saltos Rápidos
- `b` + `a`      : **Favoritar Pasta Atual** (Salva com apelido personalizável)
- `b` + `b` ou `'`: **Abrir Menu de Favoritos** (FZF com preview da árvore de pastas)
- `b` + `d`      : **Remover Pasta dos Favoritos**
- `g` + `h`      : `~` (Home)
- `g` + `d`      : `~/Downloads`
- `g` + `D`      : `~/Documentos`
- `g` + `I`      : `~/Imagens`
- `g` + `V`      : `~/Vídeos`
- `g` + `c`      : `~/.config`
- `g` + `t`      : `/tmp` (Temporários)
- `g` + `/`      : `/` (Raiz do sistema)
- `g` + `i`      : `00_Inbox` (Downloads /mnt/dados)
- `g` + `p`      : `01_Pessoal` (Documentos / Finanças)
- `g` + `e`      : `03_Estudos_Carreira`
- `g` + `v` / `x`: `04_Dev` (Projetos e Códigos)
- `g` + `j`      : `06.4_Games` (Jogos & Emuladores)
- `g` + `m`      : `05_Midias` (Fotos & Vídeos)
- `g` + `u`      : `/run/media` (Pen-drives / USB)
- `g` + `0`      : `/mnt/dados` (Raiz da partição de dados)
- `g` + `.`      : `~/dotfiles`

---

## 📅 Metadados & Linemodes (Modos de Linha)
- `m` + `t`      : **Exibir Data de Modificação (`mtime`)** (Horário/data de alteração)
- `m` + `s`      : **Exibir Tamanho dos Arquivos** (Modo padrão)
- `m` + `p`      : **Exibir Permissões Unix** (`rwxr-xr-x`)
- `m` + `o`      : **Exibir Proprietário e Grupo** (`lan:lan`)
- `m` + `n`      : **Ocultar Metadados** (Modo limpo, apenas nomes)

---

## 🔄 Ordenação Mnemônica Instantânea (`o`)
- `o` + `M`      : **Ordenar por Modificação (Recentes Primeiro)**
- `o` + `m`      : **Ordenar por Modificação (Antigos Primeiro)**
- `o` + `s`      : **Ordenar por Tamanho (Maiores no Topo)**
- `o` + `S`      : **Ordenar por Tamanho (Menores no Topo)**
- `o` + `n` / `a`: **Ordenar por Nome (Alfabético A-Z)**
- `o` + `e`      : **Ordenar por Extensão / Tipo**
- `o` + `c`      : **Ordenar por Data de Criação**
- `o` + `r`      : **Inverter Ordem Atual** (Crescente ↔ Decrescente)
- `o` + `d`      : **Alternar Pastas no Topo** (Diretórios primeiro ↔ Misturados)

---

## 🏛️ Ações de Elite & Forense
- `O` *(Shift+O)*: **OCR Forense em Imagens** (Tesseract extrai o texto da imagem/print e copia pro clipboard)
- `M` + `w`      : **AirDrop Web Local + QR Code** (Sobe servidor HTTP e gera QR no terminal para o celular baixar)
- `c` + `s`      : **Calcular SHA-256** (Calcula checksum e copia o hash pro clipboard)
- `y` + `c`      : **Copiar Conteúdo do Arquivo** (Copia texto direto pro clipboard sem abrir editor)
- `y` + `i`      : **Copiar Imagem Bitmap** (Copia como PNG pro clipboard para colar com `Ctrl+V` em apps)
- `d` + `u`      : **Raio-X de Uso de Disco (GDU)** (Analisa espaço ocupado visualmente)
- `u` + `t`      : **Restaurar da Lixeira** (`trash-restore` com busca interativa)
- `M` + `M` + `w`: **Converter Imagem para WebP** (Alta compressão para web)
- `M` + `M` + `a`: **Extrair Áudio para MP3** (Converte vídeo em áudio 320kbps)
- `M` + `M` + `g`: **Gerar GIF Otimizado** (A partir de vídeo com paleta de alta definição)

---

## ⚡ Ações Master (`Shift+M`)
- `M` + `o`      : **Organizar Agora** (`organizar --all`)
- `M` + `d`      : **Doctor Diagnóstico** (`organizar --doctor`)
- `M` + `a` / `y`: **Apex Downloader** (Baixar mídia direto na pasta atual)
- `M` + `s`      : **Backup Saves** (`sync-ludusavi.sh backup`)
- `M` + `g`      : **Abrir Lazygit** na pasta atual
- `M` + `t`      : **Abrir Terminal** na pasta atual
- `Enter` em áudios : **Toca no Amberol Hi-Fi Player** (`SUPER + SHIFT + L` abre letras/karaokê)

---

## 📋 Copiar Metadados
- `c` + `p`      : Copiar Caminho Completo (ex: `/mnt/dados/04_Dev/app.py`)
- `c` + `f`      : Copiar Nome do Arquivo (ex: `app.py`)
- `c` + `d`      : Copiar Pasta Pai (ex: `/mnt/dados/04_Dev`)

---

## 🛠️ Operações Básicas
- `j` / `k`      : Mover para baixo / cima
- `h` / `l`      : Voltar pasta / Entrar na pasta
- `Space`        : Selecionar arquivo individual (pula para o próximo)
- `v`            : Seleção visual contínua
- `y` / `x` / `p`: Copiar / Recortar / Colar
- `a`            : Criar arquivo (termine com `/` para criar pasta)
- `c` + `k` / `Ctrl+N`: **Criar Nova Pasta** (Prompt limpo, sem precisar digitar barra `/` no final!)
- `r` ou `<F2>`  : **Renomear** (Mantém o nome original com cursor antes da extensão pronto pra editar)
- `R`            : **Renomear do Zero** (Limpa o nome mantendo a extensão original)
- `r` + `e`      : **Mudar Extensão** (Permite alterar ou remover `.mkv`, `.mp4`, `.pdf` com facilidade)
- `c` + `r`      : **Colar do Clipboard** (Pega o título copiado no `Ctrl+C` do navegador e renomeia DIRETO preservando a extensão!)
- `r` + `p`      : Atalho alternativo para colar título do clipboard direto
- `r` + `i`      : Prompt interativo tradicional (estilo shell/bash com suporte a `Ctrl+V`)
- `u` ou `Ctrl+Z`: **Desfazer Última Renomeação (Undo)** (Volta o nome anterior instantaneamente se você errar!)
- `d` / `D`      : Enviar para Lixeira / Deletar permanente
- `.`            : Mostrar/Ocultar arquivos ocultos
- `q`            : Sair do Yazi

