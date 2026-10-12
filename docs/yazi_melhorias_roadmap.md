# 🏛️ Yazi God-Tier Edition — O Guia Definitivo de Melhorias & Engenharia

> **Objetivo:** Transformar o Yazi no gerenciador de arquivos mais poderoso, veloz e completo já concebido no ecossistema Linux/Hyprland, superando qualquer alternativa gráfica (Dolphin, Nautilus) e terminal (Ranger, Nnn, LF).

---

## 📑 ÍNDICE DE CAPACIDADES DE ELITE

1. [Acesso Rápido & Bookmarks Dinâmicos](#1-acesso-rápido--bookmarks-dinâmicos)
2. [Linemodes, Metadados & Datas de Modificação](#2-linemodes-metadados--datas-de-modificação)
3. [Submenu Mnemônico de Ordenação](#3-submenu-mnemônico-de-ordenação)
4. [Manipulação Multimídia & Conversão 1-Toque (FFmpeg)](#4-manipulação-multimídia--conversão-1-toque)
5. [OCR Forense em Imagens & Prints (Tesseract)](#5-ocr-forense-em-imagens--prints)
6. [Compartilhamento LAN com Servidor Web & QR Code](#6-compartilhamento-lan-com-servidor-web--qr-code)
7. [Integridade & Hashes Forenses (SHA256 / MD5)](#7-integridade--hashes-forenses)
8. [Área de Transferência Wayland de Elite (wl-copy)](#8-área-de-transferência-wayland-de-elite)
9. [Lixeira Segura & Proteção de Dados (trash-cli)](#9-lixeira-segura--proteção-de-dados)
10. [Raio-X de Armazenamento & Análise de Disco (GDU)](#10-raio-x-de-armazenamento--análise-de-disco)
11. [Higienização de Dev & Limpeza de Lixo Órfão](#11-higienização-de-dev--limpeza-de-lixo-órfão)

---

## 📌 1. Acesso Rápido & Bookmarks Dinâmicos

### A. Saltos Diretos Canônicos (`g` de Go)
- `g` + `h`: `$HOME` (`~`)
- `g` + `d`: `~/Downloads`
- `g` + `D`: `~/Documentos`
- `g` + `i`: `~/Imagens`
- `g` + `m`: `~/Músicas`
- `g` + `v`: `~/Vídeos`
- `g` + `c`: `~/.config`
- `g` + `t`: `/tmp`
- `g` + `/`: Raiz do sistema `/`
- `g` + `u`: `/run/media` (Pen-drives e HDs externos)
- `g` + `p`: `/mnt/dados/01_Pessoal`
- `g` + `e`: `/mnt/dados/03_Estudos_Carreira`
- `g` + `x`: `/mnt/dados/04_Dev`
- `g` + `G`: `~/gdrive` (Google Drive 5TB)
- `g` + `.`: `~/dotfiles`

### B. Marcadores / Favoritos Dinâmicos Persistentes (Bookmarks Engine)
- `b` + `a`: **Adicionar aos Favoritos** (salva a pasta atual em `~/.config/yazi/bookmarks.json` com nome legível).
- `b` + `b` ou `'`: **Abrir Menu Flutuante de Favoritos** (navegação fuzzy com FZF ou menu popup Yazi).
- `b` + `d`: **Remover dos Favoritos** (menu para excluir marcação).

---

## 📅 2. Linemodes, Metadados & Datas de Modificação

### A. Alternância Instantânea de Linemode (1 toque)
- `m` + `t`: **Data de Modificação (`mtime`)** formatada (ex: `12 Out 14:30` ou `2026-10-12`).
- `m` + `s`: **Tamanho** dos arquivos (`14.2 MB`, `340 KB`).
- `m` + `p`: **Permissões Unix** (`rwxr-xr-x`).
- `m` + `o`: **Proprietário e Grupo** (`lan:lan`).
- `m` + `n`: **Modo Limpo** (oculta coluna lateral).

### B. Linemode Híbrido em Lua (Tamanho + Data Recente)
Renderizador inteligente no `init.lua` que exibe simultaneamente:
`[ Ícone ] Nome do Arquivo                       12.4 MB  │  Hoje 14:20`

### C. Rodapé com Metadados Completos
Exibir na status bar inferior: Data de criação (`btime`), Data de modificação (`mtime`), Permissões octais (`0755`), Tamanho exato em bytes e Espaço livre no disco/partição.

---

## 🔄 3. Submenu Mnemônico de Ordenação (`o` de Order)

- `o` + `m`: **Por Data de Modificação** (mais recentes no topo).
- `o` + `s`: **Por Tamanho** (maiores arquivos no topo).
- `o` + `n`: **Por Nome / Alfabético** (A-Z).
- `o` + `e`: **Por Extensão / Tipo**.
- `o` + `c`: **Por Data de Criação**.
- `o` + `r`: **Inverter Direção** (Crescente ↔ Decrescente).
- `o` + `d`: **Alternar Pastas no Topo** (Diretórios primeiro ↔ Misturados).
- *Feedback Visual:* Ícone dinâmico no cabeçalho indicando a ordenação ativa (`[󰁞 Mtime]`, `[󰉉 Size]`, etc.).

---

## 🎬 4. Manipulação Multimídia & Conversão 1-Toque (FFmpeg)

Disparado pelo prefixo `M` + `m` (Mídia):
- `M` + `m` + `w`: Converter imagem selecionada para **WebP** otimizado (alta compressão para web).
- `M` + `m` + `p`: Converter imagem para **PNG** (sem perda).
- `M` + `m` + `j`: Converter imagem para **JPG**.
- `M` + `m` + `a`: **Extrair Áudio de Vídeo** direto para `.mp3` (320kbps) ou `.opus`.
- `M` + `m` + `g`: **Gerar GIF** de alta qualidade a partir de vídeo com paleta otimizada.
- `M` + `m` + `c`: **Comprimir Vídeo** para tamanho leve compatível com Discord/WhatsApp (H.264/CRF 28).

---

## 👁️ 5. OCR Forense em Imagens & Prints (Tesseract)

- `M` + `o`: **Reconhecimento Óptico de Caracteres (OCR)**.
  - Selecione uma foto, print de documento, apostila ou print de código e pressione `M o`.
  - O script roda `tesseract` em segundo plano com suporte a Português + Inglês (`por+eng`), extrai todo o texto da imagem e copia **diretamente para a área de transferência (`wl-copy`)**, disparando notificação desktop: *"Texto extraído (X linhas) copiado!"*.

---

## 🌐 6. Compartilhamento LAN com Servidor Web & QR Code

- `M` + `w`: **Subir Servidor Web Local Instantâneo na Pasta Atual**.
  - Inicia um servidor HTTP local na porta `8080` (via Python ou miniserve).
  - Detecta o IP local da máquina (`192.168.x.x`).
  - Renderiza um **QR Code em ASCII direto no terminal** (`qrencode -t ANSI256`).
  - Você aponta a câmera do celular (iPhone ou Android) ou de outro PC na rede e baixa qualquer arquivo da pasta instantaneamente sem precisar de cabo, nuvem ou WhatsApp!

---

## 🔒 7. Integridade & Hashes Forenses (SHA256 / MD5)

- `c` + `s`: **Calcular SHA256**.
  - Calcula o hash SHA-256 do arquivo sob o cursor, exibe no modal e copia automaticamente para o clipboard (`wl-copy`).
- `c` + `m`: **Calcular MD5** (para verificações rápidas legadas).

---

## 📋 8. Área de Transferência Wayland de Elite (wl-copy)

- `y` + `c`: **Copiar Conteúdo do Arquivo de Texto** direto para o clipboard sem precisar abrir o Neovim.
- `y` + `i`: **Copiar Imagem como Bitmap para o Clipboard** (`wl-copy -t image/png`), permitindo colar com `Ctrl+V` instantaneamente no WhatsApp Web, Telegram, Discord, Figma ou GIMP.
- `y` + `b`: **Copiar como Base64** (ideal para desenvolvimento web).

---

## 🗑️ 9. Lixeira Segura & Proteção de Dados (trash-cli)

- `d`: Move o arquivo para a **Lixeira do Sistema** (`trash-put`) com confirmação rápida.
- `D`: **Exclusão Permanente** com confirmação de segurança (para arquivos gigantes ou lixo descartável).
- `u` + `t`: **Restaurar da Lixeira** (`trash-restore` interativo com FZF para recuperar arquivos apagados por engano).
- `e` + `t`: **Esvaziar Lixeira** com confirmação.

---

## 📊 10. Raio-X de Armazenamento & Análise de Disco (GDU)

- `Space`: **Calcular Tamanho da Pasta** sob o cursor em segundo plano.
- `d` + `u`: **Abrir GDU** (Disk Usage TUI ultrarrápido) no diretório atual para auditar visualmente quais arquivos e pastas estão consumindo gigabytes.

---

## 🧹 11. Higienização de Dev & Limpeza de Lixo Órfão

- `M` + `c`: **Menu de Higienização de Projetos Dev**:
  - Limpar `node_modules` órfãos.
  - Limpar `target/` de Rust.
  - Limpar `__pycache__` e `.venv` expirados.
  - Limpar arquivos `.DS_Store`, `.tmp`, backups `~`.

---

## 🗺️ Mapa de Teclas Mnemônico Unificado

| Prefixo | Significado | Exemplo de Ação |
| :--- | :--- | :--- |
| `g` + `<tecla>` | **Go (Navegar)** | `g h` (Home), `g d` (Downloads), `g c` (Config), `g x` (Dev) |
| `b` + `<tecla>` | **Bookmarks (Favoritos)** | `b a` (Add), `b b` (Browse), `b d` (Delete) |
| `o` + `<tecla>` | **Order (Ordenar)** | `o m` (Modificação), `o s` (Tamanho), `o n` (Nome) |
| `m` + `<tecla>` | **Linemode (Metadados)** | `m t` (Data/mtime), `m s` (Tamanho), `m p` (Permissões) |
| `M` + `<tecla>` | **Master (Ações do Sistema)** | `M o` (OCR), `M w` (QR Code Web), `M m` (Multimídia) |
| `c` + `<tecla>` | **Copy / Checksum** | `c p` (Caminho), `c s` (SHA256), `c f` (Nome) |
| `y` + `<tecla>` | **Yank (Conteúdo)** | `y c` (Conteúdo texto), `y i` (Imagem pro clipboard) |
| `d` / `u` | **Delete & Undo** | `d` (Lixeira), `u t` (Restaurar da Lixeira) |
