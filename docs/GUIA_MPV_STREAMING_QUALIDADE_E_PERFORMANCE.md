# ⚡ MPV: Guia de Streaming, Desempenho de Rede & Seletor de Resolução

> **Data de Atualização:** 12 de Setembro de 2026  
> **Status:** 🚀 100% Otimizado, Documentado e Integrado ao Sistema  
> **Objetivo:** Documentação técnica completa sobre o motor de streaming web, buffer em RAM, seletor de resolução sem atrito (`quality-menu`), limites de reprodução (1080p vs 4K) e instruções para personalizações ou reversões futuras.

---

## 📑 Sumário

1. [Arquitetura de Streaming & Zero Buffering](#1-arquitetura-de-streaming--zero-buffering)
2. [Configuração de Resolução Padrão (Máximo 1080p)](#2-configuração-de-resolução-padrão-máximo-1080p)
3. [Seletor Interativo de Qualidade (`Ctrl + q` / `Alt + q`)](#3-seletor-interativo-de-qualidade-ctrl--q--alt--q)
4. [Diagnóstico Técnico: O Caso do `player_client=android`](#4-diagnóstico-técnico-o-caso-do-player_clientandroid)
5. [Shaders de Nitidez & IA (CAS, FSRCNNX e Anime4K)](#5-shaders-de-nitidez--ia-cas-fsrcnnx-e-anime4k)
6. [Tabela de Arquivos & Como Modificar/Reverter](#6-tabela-de-arquivos--como-modificarreverter)

---

## 🚀 1. Arquitetura de Streaming & Zero Buffering

O MPV está configurado com um pipeline de rede de ultra-alta velocidade diretamente no `mpv.conf`, projetado para carregar vídeos instantaneamente mesmo em conexões instáveis:

* **Buffer em RAM Generoso:**
  * `demuxer-max-bytes=2048M`: Reserva até **2 GB de memória RAM** para pré-carregar minutos à frente do vídeo.
  * `demuxer-max-back-bytes=512M`: Mantém **512 MB de histórico em RAM**, permitindo voltar trechos do vídeo (`Left`, `Shift+Left`) instantaneamente, sem precisar baixar novamente da internet.
  * `cache-secs=300`: Pré-carrega até 5 minutos à frente.
* **Auto-Reconexão Silenciosa (Zero Travamentos):**
  * `stream-lavf-o=reconnect=1,reconnect_streamed=1,reconnect_delay_max=5,reconnect_on_http_error=4xx,5xx,reconnect_on_network_error=1`
  * Se o Wi-Fi oscilar ou a CDN do site der timeout, o FFmpeg tenta reconectar automaticamente em background sem interromper o playback.
* **Multi-Threaded Fragment Downloader:**
  * `concurrent-fragments=8` e `buffer-size=16M`: Baixa 8 blocos de vídeo em paralelo para saturar a velocidade da sua internet.

---

## 📺 2. Configuração de Resolução Padrão (Máximo 1080p)

Por padrão, o MPV agora limita a resolução automática em **1080p a 60fps**, impedindo o consumo excessivo de dados ou processamento com 4K/1440p indesejados.

### Como funciona no `mpv.conf`:
```conf
# Formato de Vídeo Otimizado (Máximo 1080p 60fps - evita 4K desnecessário)
ytdl-format="bestvideo[height<=?1080][fps<=?60]+bestaudio/best"
```

### 🔄 Como alterar essa preferência no futuro:

* **Para liberar 4K e resoluções máximas ilimitadas:**
  ```conf
  ytdl-format="bestvideo+bestaudio/best"
  ```
* **Para limitar em 1440p (2K):**
  ```conf
  ytdl-format="bestvideo[height<=?1440]+bestaudio/best"
  ```
* **Para limitar em 720p (modo ultra econômico):**
  ```conf
  ytdl-format="bestvideo[height<=?720]+bestaudio/best"
  ```

---

## 🎛️ 3. Seletor Interativo de Qualidade (`Ctrl + q` / `Alt + q`)

O script `quality-menu` foi configurado para oferecer uma experiência limpa e livre de confusão técnica.

### 🎮 Atalhos:
* **`Ctrl + q`**: Abre o menu de resoluções de vídeo na tela (OSD/HUD).
* **`Alt + q`**: Abre o menu de seleção de trilha de áudio.
* **Mouse / uosc**: Ao passar o mouse na barra inferior, clicar no ícone de vídeo também abre o seletor.
* **Navegação no Menu:** Setas `Cima` / `Baixo` ou `Scroll do Mouse` para navegar; `Enter` ou `Clique Esquerdo` para escolher; `Esc` ou `Clique Direito` para fechar.

### 🧹 Por que o menu é simplificado?
Tradicionalmente, ao consultar vídeos do YouTube, o `yt-dlp` retorna uma lista confusa com mais de 20 opções técnicas repetidas (`vp9`, `av01`, `avc1.4d401e`, `mp4_dash`, etc.) para a mesma resolução.

Com o arquivo [`quality-menu.conf`](file:///home/lan/dotfiles/home/dot_config/mpv/script-opts/quality-menu.conf), ativamos `fetch_formats=no` e pré-definimos os perfis limpos:

| Opção no Menu | Seletor Interno MPV | Benefício |
|---|---|---|
| **1080p (Full HD)** | `bestvideo[height<=?1080]` | Qualidade máxima Full HD com o codec de maior eficiência (AV1/VP9) |
| **720p (HD 60fps)** | `bestvideo[height<=?720]` | Equilíbrio perfeito entre nitidez e fluidez |
| **480p (SD)** | `bestvideo[height<=?480]` | Ideal para vídeos informativos / podcasts visuais |
| **360p (Econômico)** | `bestvideo[height<=?360]` | Economia de dados |
| **240p (Super Leve)** | `bestvideo[height<=?240]` | Conexões extremamente lentas |
| **144p (Mínimo)** | `bestvideo[height<=?144]` | Consumo mínimo de banda |

> **Nota:** Ao escolher uma resolução, o MPV seleciona **automaticamente o codec de maior qualidade e o melhor bitrate** para ela, sem que você precise saber a diferença entre VP9, AV1 ou H.264.

---

## 🔍 4. Diagnóstico Técnico: O Caso do `player_client=android`

Durante testes anteriores, o parâmetro `--extractor-args "youtube:player_client=android,web"` havia sido adicionado às configurações do `yt-dlp`.

### O que ocorreu:
1. O YouTube ativou recentemente restrições experimentais (SABR) para o cliente Android em vários servidores, ocultando as URLs dos streams de 1080p, 720p e 480p nesse cliente.
2. Ao receber a requisição como cliente Android, o YouTube respondia com **apenas 1 formato legado: 360p altamente comprimido** (AVC1 a 400kbps com artefatos de bloco).
3. Isso fez com que os vídeos ficassem com imagem pixelada e o menu `quality-menu` ficasse sem opções para trocar.

### A Correção:
* O argumento `player_client=android` foi totalmente removido do [`mpv.conf`](file:///home/lan/dotfiles/home/dot_config/mpv/mpv.conf) e do [`yt-dlp/config`](file:///home/lan/dotfiles/home/dot_config/yt-dlp/config).
* O MPV agora utiliza o cliente desktop Web padrão, obtendo todos os streams em AV1, VP9 e H.264 com áudio Opus 48kHz nativo em máxima fidelidade.

---

## ✨ 5. Shaders de Nitidez & IA (CAS, FSRCNNX e Anime4K)

Para vídeos em 720p ou 1080p que precisem de um ganho visual extra na sua tela:

* **`Ctrl + 6` (FidelityFX CAS):** Algoritmo de nitidez adaptativa da AMD (Contrast Adaptive Sharpening). Remove o efeito embaçado de compressão web sem gerar ruídos ou contornos exagerados.
* **`Ctrl + 4` / `Ctrl + 5` (FSRCNNX Neural Network):** Upscaling neural para filmes e séries live-action (versões 16-Core e 8-Core).
* **`Ctrl + 1` / `Ctrl + 2` / `Ctrl + 3` (Anime4K Suite):** Restauração e upscaling inteligente para animes e desenhos animados.
* **`Ctrl + 0`:** Desativa todos os shaders ativos e retorna ao modo nativo.

---

## 📁 6. Tabela de Arquivos & Como Modificar/Reverter

| Finalidade | Caminho no Repositório (`dotfiles`) | Caminho Ativo no Sistema |
|---|---|---|
| **Configuração Principal do MPV** | `home/dot_config/mpv/mpv.conf` | `~/.config/mpv/mpv.conf` |
| **Atalhos de Teclado & Mouse** | `home/dot_config/mpv/input.conf` | `~/.config/mpv/input.conf` |
| **Opções do Menu de Qualidade** | `home/dot_config/mpv/script-opts/quality-menu.conf` | `~/.config/mpv/script-opts/quality-menu.conf` |
| **Configuração Global do yt-dlp** | `home/dot_config/yt-dlp/config` | `~/.config/yt-dlp/config` |
| **Script Lua do Quality Menu** | `home/dot_config/mpv/scripts/quality-menu.lua` | `~/.config/mpv/scripts/quality-menu.lua` |

### 🛠️ Como reverter o menu para listar todos os codecs brutos (Modo Avançado):
Se um dia você quiser que o menu volte a exibir todos os formatos e codecs detalhados (`vp9`, `av01`, etc.):
1. Abra `~/.config/mpv/script-opts/quality-menu.conf` (ou no repositório em `home/dot_config/mpv/script-opts/quality-menu.conf`).
2. Mude `fetch_formats=no` para `fetch_formats=yes`.
3. Salve o arquivo. O menu passará a consultar o `yt-dlp` em tempo real.
