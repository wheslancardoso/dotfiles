# 🚀 GUIA DEFINITIVO DO YAZI POWER-USER
### Gerenciador de Arquivos Terminal de Alta Velocidade — Configuração & Atalhos Mestre

> **Filosofia Zero Fricção**: Uma experiência de gerenciamento de arquivos mais rápida e poderosa que qualquer gerenciador gráfico, com compactação e extração instantâneas em 1 a 2 toques, saltos diretos para qualquer pasta do seu `/mnt/dados` e integração total com o **Organizador Master**.

---

## ⚡ 1. Por que o Yazi é Imbatível?

O **Yazi** é desenvolvido em Rust com arquitetura totalmente assíncrona (não trava nem lendo pastas com 100.000 itens). Em nossa configuração personalizada no dotfiles, ele recebeu três superpoderes exclusivos:
1. **Motor de Compactação & Extração Universal (`yazi-archive.sh`)**: Suporte nativo a `.zip`, `.7z`, `.tar.gz`, `.tar.xz`, `.rar`, etc., com fallbacks triplos (7zip → unzip/tar → Python3 nativo) para nunca falhar.
2. **Limpeza de Atalhos Inúteis**: O Yazi original travava a tecla `c` com múltiplos atalhos redundantes de cópia. Nós liberamos a tecla `c` para **Compressão**, tornando a experiência limpa e ergonômica.
3. **Atalhos GOTO Diretos para seu Drive**: Salte para qualquer setor do `/mnt/dados` com dois toques (`g i`, `g v`, `g j`, etc.).
4. **Integração Master**: Acione o Organizador Master (`M o`), faça backup de saves (`M s`) ou abra o Lazygit (`M g`) diretamente de qualquer pasta no Yazi.

---

## 📦 2. Compactação & Extração Ultrarrápida

Esqueça o terminal manual ou menus lentos. Tudo é feito com teclas mnemônicas imediatas.

### 🗜️ Compactar Arquivos ou Pastas Selecionadas (Prefixo `c`)
*Selecione os arquivos com `Space` (ou posicione o cursor sobre a pasta/arquivo) e pressione:*

| Atalho | Formato / Ação | Descrição & Caso de Uso |
|---|---|---|
| `c` `z` | **.ZIP** (Padrão) | Compacta instantaneamente para `.zip`. Máxima compatibilidade com Windows, celular e nuvem. |
| `c` `7` | **.7Z** (Ultra LZMA2) | Compacta com taxa máxima de compressão do 7-Zip. Ideal para backups grandes e roms. |
| `c` `t` | **.TAR.GZ** | Padrão Linux / DevOps. Preserva permissões Unix e links simbólicos. |
| `c` `c` | **Personalizado** | Abre prompt interativo para digitar o nome desejado e escolher o formato. |

> **Dica**: Se você estiver sobre um arquivo chamado `relatorio.pdf` e apertar `c z`, ele cria automaticamente `relatorio.zip` na mesma pasta sem fazer perguntas desnecessárias!

---

### 📂 Extrair Arquivos Compactados (Prefixo `e` ou Tecla Rápida `X`)
*Posicione o cursor sobre qualquer `.zip`, `.rar`, `.7z`, `.tar.gz`, `.iso`, etc. e pressione:*

| Atalho | Modo de Extração | Comportamento Anti-Poluição |
|---|---|---|
| `X` *(maiúsculo)* | **Extrair para Subpasta** | **(Recomendado - 1 toque)** Cria uma subpasta com o nome do arquivo e extrai tudo dentro. Evita espalhar 500 arquivos soltos no seu diretório! |
| `e` `s` | **Extrair para Subpasta** | Mesmo comportamento seguro acima, via acorde mnemônico (*Extract Sub*). |
| `e` `x` | **Extrair Aqui** | Extrai o conteúdo diretamente no diretório atual (*Extract Here*). |
| `<Enter>` ou `o` | **Abertura Inteligente** | Em arquivos compactados, o Yazi executa automaticamente a extração limpa para subpasta! |
| `<Shift+Enter>` ou `O` | **Menu de Escolha** | Mostra menu interativo: 1. Extrair para subpasta, 2. Extrair aqui, 3. Abrir com app padrão. |

---

## 📋 3. Cópia de Metadados, Clipboard & Drag & Drop

Liberamos a tecla `c` para compressão e reorganizamos as cópias para atalhos intuitivos:

| Atalho | Ação | Exemplo de Saída na Área de Transferência |
|---|---|---|
| `c` `p` | Copiar **Caminho Completo** | `/mnt/dados/04_Dev/meu-projeto/main.py` |
| `c` `f` | Copiar **Nome do Arquivo** | `main.py` |
| `c` `d` | Copiar **Caminho da Pasta** | `/mnt/dados/04_Dev/meu-projeto` |
| `<Ctrl+y>` | **Arrastar e Soltar (Drag & Drop)** | Abre caixinha flutuante com `ripdrag` para arrastar com mouse direto para Discord, Chrome, Drive, Telegram! |

---

## 🌐 4. Adeus ao Thunar / Nautilus: Como Funciona o Download na Web com Yazi?

### 😡 A Raiva Histórica do GTK File Chooser (Thunar / Nautilus)
No Linux tradicional com XFCE ou GNOME, quando um navegador abre a janela de "Salvar Como", existe um comportamento irritante conhecido como *type-ahead search*:
- O foco da janela cai na lista de arquivos em vez do campo de nome.
- Ao começar a digitar o nome que você quer dar ao arquivo, o gerenciador trava tudo e começa a pesquisar palavras dentro da pasta!
- A janela é pesada, cheia de abas desnecessárias e atrito.

### 🛡️ A Solução Definitiva do nosso Ecossistema (2 Camadas Anti-Atrito):

#### 🚀 Camada 1: O Fluxo Recomendado — Zero Diálogos (Downloads Automáticos)
No seu navegador (Zen Browser, Firefox, Chrome, Brave):
1. Deixe ativada a opção: **"Salvar arquivos automaticamente em Downloads"** (sem perguntar a cada download).
2. Como `~/Downloads` é um link simbólico que aponta diretamente para `/mnt/dados/00_Inbox`, você clica em baixar e o arquivo cai direto no disco em **0 segundos**, sem nenhuma janela saltando na sua cara.
3. Depois, basta dar `Super + E` (Yazi flutuante) e teclar `g i` para triar o arquivo, ou deixar o **Organizador Master** fazer isso por você em segundo plano!

#### 🗂️ Camada 2: Quando o Site/App EXIGE Escolher Onde Salvar ou Fazer Upload
Quando você clica em *"Salvar Como..."*, ou clica em *"Enviar Arquivo / Upload"* no Discord, Telegram ou no navegador:
1. O **Hyprland** intercepta a chamada através do `xdg-desktop-portal-termfilechooser`.
2. Em vez de Thunar ou Nautilus, **uma janela flutuante e elegante do terminal com o Yazi surge no centro da tela** (`yazi_picker`)!
3. **Se for Upload**: Você navega na velocidade da luz com `j`/`k`, salta de pasta com `g i`, `g v`, `g p` ou busca com `z` (zoxide), aperta `<Enter>` e a janela fecha instantaneamente entregando o arquivo para o app.
4. **Se for Salvar Como**: O Yazi abre na pasta com o nome sugerido já selecionado:
   - Se quiser o nome padrão: apenas tecle `<Enter>`.
   - Se quiser mudar de pasta: salte com `g p` ou `g i`.
   - Se quiser renomear: tecle `r`, digite o nome e tecle `<Enter>`.
   - Se quiser cancelar: tecle `q` ou `<Esc>`.
5. **Zero travamentos, zero pesquisa indesejada no meio da digitação, 100% teclado e velocidade.**

#### 📂 Camada 3: Clicar em "Mostrar na Pasta" no Navegador
Quando um download termina e você clica em *"Mostrar na pasta"* no Chrome/Firefox, o sistema consulta o padrão `inode/directory` configurado em `mimeapps.list`. Registramos o `yazi.desktop`, logo o **Yazi flutuante abre exatamente no diretório do arquivo com ele focado**!

#### 🐚 Camada 4: O Atalho `y` no Terminal (CD Automático ao Sair)
Se você estiver no terminal (Zsh, Bash ou Fish) e digitar apenas `y`:
- O Yazi abre no diretório atual.
- Você navega para qualquer lugar do disco (`g v`, `g j`, etc.).
- Ao apertar `q`, seu terminal **já estará dentro da pasta onde você parou no Yazi**! Nunca mais digite caminhos gigantescos de `cd`.

---

## 🚀 5. Navegação Rápida (GOTO Jumps no `/mnt/dados`)

Vá para qualquer lugar da sua máquina em fração de segundo digitando `g` seguido da inicial da pasta:

| Atalho | Destino no Sistema | Conteúdo da Pasta |
|---|---|---|
| `g` `i` | `/mnt/dados/00_Inbox` | Downloads, triagem e entrada de arquivos |
| `g` `p` | `/mnt/dados/01_Pessoal` | Documentos, finanças, compras e arquivos pessoais |
| `g` `e` | `/mnt/dados/03_Estudos_Carreira` | Livros, cursos, certificações e portfólio |
| `g` `v` | `/mnt/dados/04_Dev` | Todos os projetos de programação e repositórios Git |
| `g` `j` | `/mnt/dados/06.4_Games` | Jogos, emuladores (Switch/PCSX2), mods e saves |
| `g` `m` | `/mnt/dados/05_Midias` | Fotos, vídeos, músicas e gravações OBS |
| `g` `D` | `/mnt/dados` | Raiz principal da partição de dados |
| `g` `.` | `~/dotfiles` | Repositório de configurações do seu sistema |
| `g` `h` | `~` | Sua pasta Home (`/home/lan`) |
| `g` `c` | `~/.config` | Diretório de configs do Linux |
| `g` `d` | `~/Downloads` | Pasta de Downloads do usuário |
| `g` `g` | *(Topo da Lista)* | Padrão Vim: vai para o primeiro item do diretório |
| `G` | *(Fim da Lista)* | Padrão Vim: vai para o último item do diretório |

---

## ⚡ 6. Ferramentas Master & Produtividade (Prefixo `M` - Shift+M)

Operações do sistema acionadas de dentro do Yazi:

| Atalho | Ação | Descrição |
|---|---|---|
| `M` `o` | **Organizar Tudo** | Executa o `organizar --all` do Organizador Master. Triagem automática da Inbox e Downloads! |
| `M` `d` | **Doctor Diagnóstico** | Roda `organizar --doctor` para verificar mounts, symlinks e integridade. |
| `M` `s` | **Backup de Saves** | Executa `sync-ludusavi.sh backup` sincronizando todos os saves de jogos para o Google Drive. |
| `M` `g` | **Abrir Lazygit** | Abre a interface do Lazygit na pasta atual para commits e push rápidos. |
| `M` `l` | **Enviar via LocalSend** | Dispara os arquivos selecionados direto para o seu celular ou outro PC via AirDrop local! |
| `M` `y` | **Baixar Mídia Aqui** | Baixa o vídeo/áudio da URL copiada direto para a pasta atual no Yazi (`yt-dlp`). |
| `M` `t` | **Abrir Terminal** | Abre uma nova janela do terminal exatamente no diretório selecionado. |
| `<F12>` | **Status / Verificação** | Emite notificação de integridade confirmando que as configurações estão ativas. |

### 🚀 Visualizadores de Alta Velocidade Integrados ao `<Enter>`:
- **Imagens (PNG, JPG, WebP, GIF)**: Abre em **0.01s** via **`imv`** (controlado por setas, zoom no scroll e Wayland nativo).
- **Documentos Markdown (`.md`)**: Abre estilizado no terminal via **`glow -p`** (cores Catppuccin e paginação).
- **PDFs**: Abre no **`zathura`** (renderização instantânea, atalhos Vim `j/k` e modo noturno com `Ctrl+r`).

---

## 🛠️ 7. Operações Básicas de Arquivos (Padrão Vim)

| Tecla | Ação | Detalhes |
|---|---|---|
| `j` / `k` | Mover cursor | Baixo / Cima |
| `h` / `l` | Navegar | Voltar pasta pai (`h`) / Entrar na pasta (`l`) |
| `<Space>` | Selecionar item | Alterna seleção do item atual e pula para o próximo |
| `v` | Seleção Visual | Inicia seleção contínua de blocos de arquivos estilo Neovim |
| `V` | Seleção Visual Inversa | Inverte ou cancela seleção visual |
| `<Ctrl+a>` | Selecionar Tudo | Marca todos os arquivos da pasta atual |
| `<Ctrl+r>` | Inverter Seleção | Inverte os arquivos selecionados |
| `y` | Copiar (Yank) | Marca os arquivos selecionados para copiar |
| `x` | Recortar (Cut) | Marca os arquivos selecionados para mover |
| `p` | Colar (Paste) | Cola os arquivos copiados/recortados na pasta atual |
| `P` | Colar Forçado | Cola sobrescrevendo arquivos existentes sem perguntar |
| `d` | Lixeira (Trash) | Move arquivos selecionados para a lixeira do sistema |
| `D` | Deletar Permanente | Remove imediatamente do disco (irrecuperável) |
| `a` | Criar Arquivo/Pasta | Digite o nome do arquivo. Se terminar com `/`, cria pasta! |
| `A` | Criação em Lote | Cria múltiplos arquivos de uma vez |
| `r` | Renomear | Renomeia o arquivo atual |
| `R` | **Bulk Rename** | Abre todos os arquivos selecionados no Neovim para renomear em massa com Regex! |
| `.` | Mostrar Ocultos | Alterna visibilidade de arquivos e pastas ocultas (`.dotfiles`) |
| `s` | Busca Rápida | Busca incremental instantânea via `fd` |
| `z` | Zoxide Jump | Salta para qualquer pasta já visitada pelo histórico |
| `q` | Fechar Yazi | Sai do gerenciador de arquivos |

---

## 🧩 8. Estrutura dos Arquivos de Configuração

Todas as configurações são versionadas no seu repositório de dotfiles:

```
dotfiles/
├── home/dot_config/yazi/
│   ├── keymap.toml       # Todos os atalhos e remapeamentos ([mgr].prepend_keymap)
│   ├── yazi.toml         # Regras de abertura, apps padrão e openers de extração
│   └── theme.toml        # Tema visual Catppuccin Mocha de alta definição
└── scripts/
    └── yazi-archive.sh   # Motor de compactação e extração universal com notificações
```

> **Simplicidade Absoluta**: Se você adicionar um novo atalho em `keymap.toml`, basta salvar o arquivo. O Yazi lê as mudanças em tempo real!
