# ⌨️ Mapa Mestre de Atalhos & Keybindings (Arch + Hyprland + Zellij + Neovim)

> **O guia de consulta rápida unificado para navegar por todo o sistema sem encostar no mouse.**

---

## 🌌 1. Hyprland (Gerenciador de Janelas Tiling)

*A tecla **`Super`** (Windows key) é a tecla mestre do Hyprland.*

| Atalho | Ação |
|---|---|
| `Super + Q` | Fechar janela ativa (**Kill**) |
| `Super + Return` | Abrir terminal (**Ghostty / Kitty / Alacritty**) |
| `Super + E` | Abrir explorador de arquivos (**Yazi / Thunar**) |
| `Super + Space` | Abrir menu de aplicativos (**Rofi Launcher**) |
| `Super + V` | Histórico da área de transferência (**Cliphist / Rofi**) |
| `Super + F` | Janela em tela cheia (**Fullscreen Toggle**) |
| `Super + Shift + Space` | Alternar janela flutuante (**Floating Toggle**) |
| `Super + H / J / K / L` | Mover foco entre janelas (Esquerda, Abaixo, Acima, Direita) |
| `Super + Shift + H / J / K / L` | Mover janela de posição no layout tiling |
| `Super + 1` a `9` | Mudar para a Área de Trabalho (Workspace) correspondente |
| `Super + Shift + 1` a `9` | Mover janela atual para a Workspace correspondente |
| `Super + Shift + S` | Captura de tela com seleção de área (**Grim + Slurp**) |
| `Super + Shift + R` | Gravação de tela em MP4/GIF com áudio (**wf-recorder**) |
| `Super + Shift + T` | Extração de texto da tela via OCR (**Tesseract**) |
| `Super + Shift + P` | Conta-gotas / Seletor de cor HEX da tela (**Hyprpicker**) |
| `Super + Shift + A` | Alternar saída de áudio (Caixas de Som <-> Fone/Headset) |
| `Super + C` | Calculadora flutuante com conversão de moedas ao vivo |
| `Super + Space` | Alternar layout de teclado (US-Intl, PT-BR ABNT2, US-Dev) |
| `Super + H` | **Cheat Sheet Mestre** com todos os atalhos do sistema (Yad GUI) |
| `Super + Shift + D` | **Upload Rápido de Documentos** (Acesso Rápido - CNH, RG, Comprovantes em janela flutuante) |
| `Super + Alt + S` | **Sincronização de Saves de Jogos** (Ludusavi Cloud Backup com notificação nativa) |
| `Super + Shift + M` | Gerenciador de Monitores e Projeção (**nwg-displays**) |
| `Alt + V` | Gerenciador e histórico da área de transferência (**CopyQ**) |
| `Super + M` | **Spotify Dropdown Scratchpad** (Desce janela flutuante com blur Catppuccin e esconde ao apertar de novo) |
| `Super + Ctrl + Space` | Play / Pause do Spotify em segundo plano |
| `Super + Ctrl + ]` / `[` | Próxima faixa / Faixa anterior do Spotify |
| `Ctrl + Alt + P` | Menu de saída / Desligar / Reiniciar (**Wlogout**) |



---

## 🪟 2. Zellij (Multiplexador de Terminal Moderno)

*Os atalhos padrão utilizam a tecla **`Alt`** para navegação estilo Vim:*

| Atalho | Ação |
|---|---|
| `Alt + h` | Mover foco para o painel à esquerda |
| `Alt + l` | Mover foco para o painel à direita |
| `Alt + j` | Mover foco para o painel abaixo |
| `Alt + k` | Mover foco para o painel acima |
| `Alt + =` | Aumentar tamanho do painel ativo |
| `Alt + -` | Diminuir tamanho do painel ativo |
| `Alt + [` | Alternar layout de divisão de tela |
| `Alt + /` | Abrir menu flutuante de ajuda do Zellij |
| `Ctrl + p` + `n` | Criar novo painel |
| `Ctrl + p` + `x` | Fechar painel atual |
| `Ctrl + t` + `n` | Criar nova aba |
| `Ctrl + t` + `x` | Fechar aba atual |
| `Ctrl + q` | Desconectar / Fechar sessão Zellij |

### 🚀 Layouts Pré-configurados:
- `vibe` : **LazyVim (70%)** + **Antigravity CLI (30%)** + **Terminal Runner**
- `fullstack` : **LazyVim (65%)** + **Antigravity CLI** + **Docker / DB Runner**
- `mobile` : **LazyVim Mobile** + **Antigravity CLI** + **Metro / Flutter Logs**

---

## 📂 3. Yazi (Explorador de Arquivos Terminal Power-User)

> 📖 **Guia Dedicado**: Confira o [GUIA_YAZI_POWERUSER.md](file:///home/lan/dotfiles/docs/GUIA_YAZI_POWERUSER.md) para todos os detalhes e workflows avançados.

### 📦 Compressão & Extração Instantânea
| Atalho | Ação |
|---|---|
| `c` + `z` | **Compactar para .ZIP** (Rápido e compatível com tudo) |
| `c` + `7` | **Compactar para .7Z** (Ultra compressão LZMA2) |
| `c` + `t` | **Compactar para .TAR.GZ** (Linux padrão) |
| `c` + `c` | **Compactar Personalizado** (Prompt para nome e formato) |
| `X` *(maiúsculo)* | **Extrair para Subpasta** (Limpo - 1 toque sem espalhar arquivos) |
| `e` + `s` | **Extrair para Subpasta** (Extract Sub) |
| `e` + `x` | **Extrair Aqui** (Extract Here) |
| `<Enter>` | Em arquivos compactados, extrai automaticamente para subpasta! |

### 🚀 Saltos Rápidos no Drive (`/mnt/dados`)
| Atalho | Destino |
|---|---|
| `g` + `i` | `/mnt/dados/00_Inbox` (Downloads & Triagem) |
| `g` + `p` | `/mnt/dados/01_Pessoal` (Documentos & Finanças) |
| `g` + `e` | `/mnt/dados/03_Estudos_Carreira` |
| `g` + `v` | `/mnt/dados/04_Dev` (Códigos & Git) |
| `g` + `j` | `/mnt/dados/06.4_Games` (Jogos & Emuladores) |
| `g` + `m` | `/mnt/dados/05_Midias` (Fotos & Vídeos) |
| `g` + `D` | `/mnt/dados` (Raiz da partição) |
| `g` + `.` | `~/dotfiles` (Configurações) |

### ⚡ Ações Master & Sistema (`Shift+M`)
| Atalho | Ação |
|---|---|
| `M` + `o` | **Organizar Tudo** (`organizar --all` do Organizador Master) |
| `M` + `d` | **Doctor Diagnóstico** (`organizar --doctor`) |
| `M` + `s` | **Backup Saves de Jogos** (`sync-ludusavi.sh backup`) |
| `M` + `g` | **Abrir Lazygit** na pasta atual |
| `M` + `t` | **Abrir Terminal** na pasta atual |

### 📋 Copiar Metadados & Operações Básicas
| Atalho | Ação |
|---|---|
| `c` + `p` | Copiar Caminho Completo para a Área de Transferência |
| `c` + `f` | Copiar Nome do Arquivo |
| `c` + `d` | Copiar Caminho da Pasta Pai |
| `Space` | Selecionar / desselecionar arquivo individual |
| `v` | Seleção visual contínua |
| `y` / `x` / `p` | Copiar / Recortar / Colar arquivos |
| `d` / `D` | Enviar para Lixeira / Deletar permanentemente |
| `a` | Criar novo arquivo (termine com `/` para criar pasta) |
| `r` / `R` | Renomear arquivo / Bulk Rename com Neovim |
| `.` | Alternar exibição de arquivos ocultos (dotfiles) |
| `q` | Sair do Yazi mantendo o diretório no shell |

---

## 💻 4. Neovim & LazyVim (Editor de Desenvolvimento)

*A tecla **`Leader`** principal é o **`Espaço`**.*

### ⚡ Navegação & Busca Ultra-Rápida
| Atalho | Ação |
|---|---|
| `s` + `2 letras` | **Flash Jump**: Salta o cursor para qualquer palavra na tela instantaneamente |
| `S` | Flash Jump em modo reverso / árvores de sintaxe |
| `<leader>1` a `<leader>4` | Alternar instantaneamente entre arquivos fixados no **Harpoon** |
| `<leader>ha` | Adicionar arquivo atual ao **Harpoon** |
| `<leader>hh` | Abrir menu visual do **Harpoon** |
| `<leader>ff` | Buscar arquivos por nome no projeto (**Telescope**) |
| `<leader>sg` | Buscar texto em todos os arquivos (**Live Grep**) |
| `<leader>fb` | Listar buffers abertos |
| `<leader>e` | Abrir/Fechar árvore de arquivos lateral (**Neo-tree**) |
| `<S-h>` / `<S-l>` | Buffer anterior / próximo buffer |
| `<leader>bd` | Fechar buffer atual |
| `<C-s>` | Salvar arquivo |
| `<leader>qq` | Fechar todas as janelas e sair do Neovim |

### 🔲 Manipulação de Texto, Surround & Edição
| Atalho | Ação |
|---|---|
| `ysiw"` | Envolve a palavra sob o cursor com `"aspas"` |
| `cs"'` | Troca aspas duplas por `'aspas simples'` |
| `ds"` | Remove as `"aspas"` ao redor |
| `ysit<div>` | Envolve bloco com a tag HTML `<div>...</div>` |
| `gS` | **Split & Join**: Alterna array/objeto entre 1 linha e múltiplas linhas |
| `ga=` | **Align**: Alinha bloco de código pelo sinal de igual `=` |
| `<A-j>` / `<A-k>` | Mover linha selecionada para cima ou para baixo |
| `<leader>re` | **Refactoring**: Extrair função da seleção |
| `<leader>rv` | **Refactoring**: Extrair variável da seleção |
| `<leader>ri` | **Refactoring**: Fazer inline de variável |

### 🌿 Git & Controle de Versão
| Atalho | Ação |
|---|---|
| `<leader>gg` | Abrir interface do **LazyGit** em popup flutuante |
| `<leader>gd` | Abrir **Diffview** (comparativo de mudanças do projeto) |
| `<leader>gh` | Abrir **Histórico de Commits** do arquivo atual |
| `<leader>gq` | Fechar Diffview |
| `[c` / `]c` | Pular para a alteração Git anterior / próxima alteração |
| `<leader>ghs` | Dar stage apenas no bloco (hunk) sob o cursor |
| `<leader>ghr` | Resetar/descartar alterações do bloco (hunk) atual |
| `<leader>ghp` | Visualizar diff do bloco (hunk) em popup |

### 🗄️ Bancos de Dados & APIs REST
| Atalho | Ação |
|---|---|
| `<leader>D` | Abrir gerenciador de **Bancos de Dados (Dadbod UI)** |
| `<leader>Da` | Adicionar nova conexão de banco (Postgres, MySQL, SQLite) |
| `<leader>Rr` | Executar **Requisição HTTP (Kulala)** sob o cursor |
| `<leader>Rt` | Alternar entre visualização de Body e Headers HTTP |
| `<leader>Rc` | Copiar requisição como comando `curl` |

### ☕ Inteligência de Código (LSP) & Debugging (DAP)
| Atalho | Ação |
|---|---|
| `gd` | Ir para a Definição da função/classe |
| `gr` | Listar todas as Referências |
| `K` | Ver documentação/Assinatura da função |
| `<leader>ca` | **Code Actions**: Correções rápidas, gerar getters/setters/construtor |
| `<leader>cr` | Renomear símbolo em todo o projeto |
| `<leader>xx` | Diagnóstico de erros e avisos (**Trouble**) |
| `<leader>st` | Buscar todos os **TODOs** e **FIXMEs** no projeto |
| `<leader>co` | Organizar imports (Java / TypeScript) |
| `<leader>db` | Alternar Breakpoint de depuração |
| `<leader>dc` | Iniciar / Continuar Depuração (DAP) |
| `<leader>du` | Abrir painel visual do Debugger (variáveis e stack) |
| `<leader>di` / `<leader>do` | Step Into / Step Over na depuração |

---

## 🐚 5. Aliases do Terminal (Zsh & Fish)

| Alias | O que faz |
|---|---|
| `vibe` | Inicia sessão de Vibe Coding no Zellij (LazyVim + IA) |
| `fullstack` | Inicia layout Fullstack (LazyVim + IA + Server/DB) |
| `mobile` | Inicia layout Mobile (LazyVim + IA + Metro/Flutter) |
| `scrcpy-dev` | Abre tela do celular físico em janela flutuante no Hyprland |
| `organizar` | Executa a suíte de organização de arquivos (`00_` a `06_`) |
| `organizar --doctor` | Diagnóstico de saúde da taxonomia (Nota 100/100 Padrão Ouro) |
| `organizar --dedup` | Busca e quarentena de arquivos duplicados por hash SHA-256 |
| `organizar --watch` | Inicia daemon de monitoramento contínuo em tempo real |
| `vincular_linux` | Vincula diretórios da `$HOME` à partição `/mnt/dados` |
| `lg` | Abre o **LazyGit** |
| `ld` | Abre o **LazyDocker** |
| `z [pasta]` | Salta instantaneamente para qualquer pasta recente (**Zoxide**) |
| `ll` / `la` / `lt` | Listagem rica de arquivos com ícones (**Eza**) |
| `cat [arquivo]` | Leitura de arquivo com realce de sintaxe (**Bat**) |
| `y` | Abre o **Yazi** e muda o diretório do terminal ao sair |
| `pacup` / `safe-update` | Atualização blindada (chaveiro PGP atualizado antes e snapshot Btrfs) |
| `fix-pacman` | Destrava o banco de dados `/var/lib/pacman/db.lck` com segurança |
| `fix-keys` | Repara e atualiza as chaves PGP oficiais do Arch Linux |
| `fix-mirrors` | Ranqueia os mirrors mais rápidos do Brasil e América do Sul |
| `fix-audio` | Reinicia PipeWire e WirePlumber em caso de estalos ou falha |
| `fix-pendrive` | Desbloqueia e repara pen-drives NTFS (dirty-bit) e FAT32 |
| `fix-suspend` | Diagnóstico e proteção para o PC nunca acordar sozinho |
| `clean-system` | Faxina geral de caches, logs antigos e pacotes órfãos |
| `trash-empty` | Esvazia a lixeira do sistema de forma segura |
| `perf` / `quiet` | Alterna entre performance máxima e silêncio das ventoinhas |



