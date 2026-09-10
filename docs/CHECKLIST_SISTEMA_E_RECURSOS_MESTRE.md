# 📋 Checklist Mestre de Recursos, Otimizações & Superpoderes do Sistema

> **Ecossistema:** Arch Linux (CachyOS) · Hyprland Wayland · Ryzen 7 5700X · RTX 5060 8GB · 32GB RAM  
> **Status:** 100% Operacional & Integrado  
> **Repositório Central:** `~/dotfiles`

---

## 🧭 Índice do Checklist
1. [📥 Downloaders & Mídia Avançada (Apex God Mode)](#1--downloaders--mídia-avançada-apex-god-mode)
2. [🎬 MPV Cinema & Imersão Absoluta](#2--mpv-cinema--imersão-absoluta)
3. [🔍 Produtividade Cirúrgica & OCR God Mode](#3--produtividade-cirúrgica--ocr-god-mode)
4. [⚡ Scratchpads & WebApps em Dropdown](#4--scratchpads--webapps-em-dropdown)
5. [🧹 Organização de Arquivos & Gerenciamento Ninja](#5--organização-de-arquivos--gerenciamento-ninja)
6. [☁️ Nuvem, Backup & Sincronização Automática](#6-️-nuvem-backup--sincronização-automática)
7. [🚀 Otimizações de Hardware, Kernel & Baixa Latência](#7--otimizações-de-hardware-kernel--baixa-latência)
8. [🎮 Gaming, Emuladores & Proton-GE](#8--gaming-emuladores--proton-ge)
9. [🎙️ Áudio, Captura & Comunicação](#9-️-áudio-captura--comunicação)
10. [🛡️ Atalhos Globais Cruciais (Quick Reference)](#10-️-atalhos-globais-cruciais-quick-reference)

---

## 1. 📥 Downloaders & Mídia Avançada (Apex God Mode)

- [x] **Apex Downloader (`apex` / `dl`)**
  - **Local:** `/home/lan/projects/apex-dl/bin/apex` (symlink em `~/.local/bin/apex` e espelhado em `~/dotfiles/scripts/media-download.sh`).
  - **Single-Pass Engine:** Download direto de áudio/vídeo em alta resolução sem múltiplos encodes redundantes.
  - **Transcrições em Lote Inteligentes:**
    - Arquivo de progresso com auto-resume (`.transcript_archive.txt`), nunca reprocessa vídeos já transcritos.
    - Separação limpa de saídas em pastas `Markdown/` (com sumário, timestamps e metadados) e `Texto_Puro/` (para LLMs/RAG).
    - Silenciamento inteligente de clipboard em processamentos em lote.
  - **Suporte Multiplataforma:** YouTube, TikTok, Instagram, Twitter/X, Twitch e mais de 1.800 sites via `yt-dlp`.
  - **spotDL / Music Engine:** Download de faixas e playlists do Spotify com metadados e capas integradas.

---

## 2. 🎬 MPV Cinema & Imersão Absoluta

- [x] **Upscaling & Shaders AI:**
  - `FSRCNNX` (Cinema Neural AI Upscaler): ativado via `Ctrl+4` / `Ctrl+5`.
  - `Anime4K`: shaders dedicados para traços perfeitos e restauração de linhas em animações.
- [x] **Interface Moderna uosc (v5.13.0):**
  - Barra de progresso minimalista e responsiva, menus de áudio, legendas e shaders com design premium.
- [x] **Thumbfast:**
  - Hover de timeline com visualização instantânea de miniaturas (thumbnails em tempo real).
- [x] **Controle Preciso de Velocidade:**
  - `[` e `]` ajustam velocidade em passos suaves de `±0.1x`.
  - `{` e `}` ajustam em passos rápidos de `±0.25x`.
  - `Backspace` redefine instantaneamente para `1.0x`.
- [x] **Performance & Streaming:**
  - Decodificação por hardware zero-copy (`hwdec=auto-safe`).
  - Sincronia perfeita de áudio/vídeo (`video-sync=audio`) e descarte limpo de quadros no renderizador (`framedrop=vo`).
  - Buffer de streaming de 1GB (`demuxer-max-bytes=1024MiB`, `demuxer-max-back-bytes=512MiB`) para reprodução sem engasgos de URLs externas.
  - Perfil de cor calibrado para painéis AMOLED/OLED.
  - Recorte dinâmico de barras pretas com tecla `C` (`dynamic-crop`).

---

## 3. 🔍 Produtividade Cirúrgica & OCR God Mode

- [x] **OCR God Mode (`Super + Shift + T`):**
  - Captura qualquer região da tela com `slurp` + `grim`.
  - Pré-processamento via `ImageMagick` (upscaling para 300 DPI, threshold de contraste e remoção de ruídos).
  - Reconhecimento duplo: texto via `tesseract` (português + inglês) e leitura instantânea de **QR Codes** via `zbarimg`.
  - **Auto-Heal Engine:** Corrige automaticamente quebras de linhas indesejadas em URLs, comandos bash/shell, flags de CLI, formatações snake_case e preserva estritamente listas numeradas (`1.` e `1)`).
- [x] **OCR Tradutor Instantâneo (`Super + Alt + T`):**
  - Captura o texto de qualquer idioma na tela e traduz em tempo real para Português (PT-BR) com notificação rica via `notify-send`.
- [x] **Notificação de Código 2FA de E-mail (`email-code-notify.sh`):**
  - Monitora e extrai automaticamente códigos de verificação de duas etapas recebidos por e-mail, exibindo uma notificação clicável que joga o código direto no clipboard.
- [x] **Luz Noturna Inteligente (Eye Comfort):**
  - Redução de luz azul via `gammastep` / `hyprsunset` para preservação circadiana durante noites de estudo ou código.
- [x] **CopyQ Clipboard Manager (`Super + V`):**
  - Histórico persistente de clipboard, suporte a imagens, textos ricos e busca instantânea.
- [x] **Color Picker (`Super + Shift + P`):**
  - `hyprpicker` com cópia instantânea do código HEX ou RGB para o clipboard.
- [x] **Captura de Tela & Gravação:**
  - `Flameshot` / `Grimblast`: captura estática (`Print` / `Super + Shift + S`).
  - `wf-recorder`: gravação de tela com ou sem áudio (`Super + Shift + R` / `Super + Alt + R`).

---

## 4. ⚡ Scratchpads & WebApps em Dropdown

- [x] **Spotify Scratchpad (`Super + M`):**
  - Dropdown flutuante instantâneo para controle de música sem poluir seus workspaces de trabalho.
  - Sincronização com `spicetify` e letras em tempo real via `sptlrx` (`lyrics-toggle.sh`).
- [x] **TecConcursos Scratchpad (`Super + T`):**
  - WebApp dedicado via Brave (`--app=https://www.tecconcursos.com.br`).
  - Proporção calibrada de **80% de largura por 88% de altura**, centralizado na tela para máxima legibilidade de questões.
- [x] **Terminal Quake / Scratchpad de Apoio:**
  - Dropdown de terminal para tarefas rápidas de CLI sem necessidade de criar nova janela ou workspace.

---

## 5. 🧹 Organização de Arquivos & Gerenciamento Ninja

- [x] **Organizador Master de Arquivos (Python Core):**
  - Localizado em `~/dotfiles/scripts/organizador/`.
  - Regras determinísticas de taxonomia (pastas ordinais `00_INBOX` até `06_SISTEMA_E_CONFIG`).
  - Nomenclatura ISO (`YYYY-MM-DD_Descricao_v01`) e categorização por extensão e conteúdo.
- [x] **Yazi Power User (`yazi`):**
  - Navegador de arquivos no terminal mais rápido do mundo (Rust + Lua).
  - **Scripts auxiliares integrados:**
    - `yazi-archive.sh`: compactação e extração multi-threaded com `7z`, `zstd`, `ouch` e `zip`.
    - `yazi-ventoy.sh`: envio direto de ISOs para pendrive Ventoy.
    - `yazi-rsync.sh`: sincronização robusta com barra de progresso.
  - Pré-visualização de imagens, PDFs, vídeos, fontes e arquivos de código com syntax highlighting.

---

## 6. ☁️ Nuvem, Backup & Sincronização Automática

- [x] **Google Drive 5TB Rclone VFS (`Super + Alt + G`):**
  - Montagem de alta performance em espaço de usuário via `rclone mount`.
  - Cache local agressivo com VFS (`vfs-cache-mode full`) permitindo leitura e gravação transparente como se fosse um disco NVMe local.
- [x] **Ludusavi Cloud Game Saves (`Super + Alt + S`):**
  - Backup automatizado de saves de mais de 10.000 jogos de PC e emuladores.
  - Sincronização direta com a nuvem / Google Drive (`sync-ludusavi.sh`).
- [x] **Pre-Formatting & Dotfiles Backup:**
  - Scripts para arquivamento de chaves SSH, configs sensíveis e repositório Git centralizado em `~/dotfiles`.

---

## 7. 🚀 Otimizações de Hardware, Kernel & Baixa Latência

- [x] **Kernel CachyOS & BORE Scheduler:**
  - Kernel com foco em responsividade e ultra-baixa latência de desktop e jogos.
  - Escalonador BORE (Burst-Oriented Response Enhancer).
- [x] **AMD P-State EPP (`amd_pstate=active`):**
  - Gerenciamento autônomo de clock e energia por hardware no Ryzen 7 5700X.
- [x] **Otimizações NVMe:**
  - Scheduler I/O configurado como `none` (bypass de overhead para SSDs NVMe Gen3/Gen4).
  - `fstrim.timer` ativo semanalmente para preservação das células NAND.
- [x] **Profile-Sync-Daemon (`psd`):**
  - O perfil do navegador Brave roda **100% carregado na memória RAM (tmpfs)**.
  - Escrita no disco reduzida em 90%, carregamento instantâneo de abas e histórico.
  - Sincronização periódica segura de volta ao SSD.
- [x] **Compilação em RAM (makepkg tmpfs):**
  - Builds de pacotes do AUR executados em `/tmp/makepkg` (RAM), poupando ciclos de escrita no NVMe e reduzindo tempo de compilação.
- [x] **Gerenciador de Processos `ananicy-cpp`:**
  - Ajuste dinâmico de `nice` e `ionice` em tempo real para priorizar jogos, reprodutores de vídeo e apps em foco, penalizando processos de fundo.
- [x] **ZRAM 8GB com Compressão `zstd`:**
  - Swap ultrarrápido comprimido direto na RAM, evitando travamentos de disco por Out-Of-Memory (OOM).

---

## 8. 🎮 Gaming, Emuladores & Proton-GE

- [x] **Stack de Emulação Completa:**
  - **RPCS3 (PS3):** Vulkan nativo, LLVM Recompiler, desempenho superior ao Windows.
  - **PCSX2 (PS2):** Vulkan backend, upscaling 4K/1080p, deinterlacing e patches de widescreen 60fps.
  - **Xenia (Xbox 360):** Execução via Proton/Wine com compatibilidade DX12/Vulkan.
  - **Ryujinx / Eden (Nintendo Switch):** Shaders assíncronos e estabilidade de frames.
- [x] **GameMode & MangoHud:**
  - `gamemoderun`: prioridade de CPU, perfil de GPU de alto desempenho e inibição de screensaver.
  - `MangoHud`: telemetria detalhada de FPS, frametime, temperatura da GPU/CPU e uso de VRAM (toggle via `Shift_R + F12`).
- [x] **Proton-GE & Wine-CachyOS:**
  - Runners otimizados com suporte a Fsync, Wayland nativo e compatibilidade total com repacks FitGirl/DODI e Steam.

---

## 9. 🎙️ Áudio, Captura & Comunicação

- [x] **PipeWire & WirePlumber:**
  - Servidor de áudio profissional com baixa latência (sub-5ms) e suporte a Bluetooth LDAC/aptX.
- [x] **Seletor Rápido de Áudio (`audio-switch.sh` & `audio-preset-switch.sh`):**
  - Alternância instantânea entre Caixas de Som e Headphone sem abrir painéis de controle.
- [x] **Supressão de Ruído por IA (DeepFilterNet / EasyEffects):**
  - Filtro em tempo real para microfone eliminando ruídos de teclado mecânico, cliques e ruído ambiente no Discord/Vesktop.
- [x] **Vesktop (Discord Wayland Nativo):**
  - Compartilhamento de tela em 60fps com áudio do sistema funcionando perfeitamente em Wayland.

---

## 10. 🛡️ Atalhos Globais Cruciais (Quick Reference)

| Atalho | Ação / Ferramenta |
|---|---|
| `Super + Return` | Abrir Terminal Foot / Kitty |
| `Super + Space` | Rofi Application Launcher |
| `Super + M` | **Spotify Scratchpad** (Dropdown) |
| `Super + T` | **TecConcursos Scratchpad** (Dropdown 80%x88%) |
| `Super + Shift + T` | **OCR God Mode** (Extrai texto + QR Code + Auto-Heal) |
| `Super + Alt + T` | **OCR Tradutor** (Captura texto e traduz para PT-BR) |
| `Super + V` | **CopyQ** (Histórico de Clipboard) |
| `Super + Shift + P` | **Hyprpicker** (Conta-gotas / Color Picker) |
| `Super + Shift + S` / `Print` | **Flameshot** (Screenshot seletivo) |
| `Super + Shift + R` | **wf-recorder** (Gravar tela) |
| `Super + Alt + G` | **Google Drive 5TB** (Montar via Rclone VFS) |
| `Super + Alt + S` | **Ludusavi** (Sincronizar saves de jogos) |
| `Shift_R + F12` | **MangoHud** (Ativar/Desativar telemetria gamer) |

---

<div align="center">
  <b>Ecossistema Top 1% configurado para máxima produtividade, performance e lazer. 🚀</b>
</div>
