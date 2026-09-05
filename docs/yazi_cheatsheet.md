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

## 🚀 Saltos Rápidos (GOTO no /mnt/dados)
- `g` + `i`      : `00_Inbox` (Downloads)
- `g` + `p`      : `01_Pessoal` (Documentos / Finanças)
- `g` + `e`      : `03_Estudos_Carreira`
- `g` + `v`      : `04_Dev` (Projetos e Códigos)
- `g` + `j`      : `06.4_Games` (Jogos & Emuladores)
- `g` + `m`      : `05_Midias` (Fotos & Vídeos)
- `g` + `D`      : `/mnt/dados` (Raiz da partição)
- `g` + `.`      : `~/dotfiles`
- `g` + `h`      : `~` (Home)

---

## ⚡ Ações Master (`Shift+M`)
- `M` + `o`      : **Organizar Agora** (`organizar --all`)
- `M` + `d`      : **Doctor Diagnóstico** (`organizar --doctor`)
- `M` + `s`      : **Backup Saves** (`sync-ludusavi.sh backup`)
- `M` + `g`      : **Abrir Lazygit** na pasta atual
- `M` + `t`      : **Abrir Terminal** na pasta atual

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
- `r` / `R`      : Renomear / Bulk Rename com Neovim
- `d` / `D`      : Enviar para Lixeira / Deletar permanente
- `.`            : Mostrar/Ocultar arquivos ocultos
- `q`            : Sair do Yazi
