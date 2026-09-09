# 🎬 MPV God Mode: Arquitetura, Imersão em Inglês & Inteligência de Legendas

> **Status:** 🚀 100% Concluído & Integrado aos Dotfiles  
> **Objetivo:** Transformar o `mpv` no ecossistema definitivo para o Arch Linux + Hyprland, unindo visual futurista, consumo eficiente de séries, imersão acelerada em inglês (densidade linguística) e resolução definitiva para problemas de legendas (forçadas, desincronizadas ou queimadas).

---

## 📋 Checklist de Implementação

- [x] **1. Core Engine & Configuração de Alta Fidelidade (`home/dot_config/mpv/mpv.conf`)**
  - [x] Renderização com `vo=gpu-next` e aceleração por hardware nativa (`hwdec=auto-safe` / VA-API).
  - [x] Correção de pitch de áudio (`audio-pitch-correction=yes`) para reprodução limpa a 1.25x+ sem voz de esquilo.
  - [x] Buffer inteligente e generoso (`demuxer-readahead-secs=30`, `demuxer-max-bytes=500M`) para stream e pré-carregamento de legendas.
  - [x] Memória de reprodução ativada (`save-position-on-quit=yes`).
  - [x] Manter player aberto ao final do episódio (`keep-open=yes`) para encadear na playlist.
  - [x] Otimização para Hyprland (sem bordas de janela padrão, modo tela cheia fluido).

- [x] **2. Interface Futurista & Navegação (`uosc` + `thumbfast`)**
  - [x] Instalação e integração do `uosc` (menus contextuais OSD, seletor visual de áudio, legendas e velocidade).
  - [x] Integração do gerador de miniaturas na linha do tempo (`thumbfast`).
  - [x] Menu de contexto sob botão direito com controle de trilhas e capítulos.

- [x] **3. Gestor Autônomo de Séries & Fila (`autoload.lua`)**
  - [x] Script para detecção automática de episódios na mesma pasta.
  - [x] Ordenação numérica natural de episódios (S01E01, S01E02...).
  - [x] Atalhos de playlist rápidos: `ENTER` para menu de episódios, `<` e `>` para anterior/próximo episódio.

- [x] **4. Motor de Imersão em Inglês & Densidade de Estudo (`sub-skip.lua`)**
  - [x] Detecção de silêncio e aceleração dinâmica:
    - Com diálogo/legenda ativa: velocidade padrão (ex: 1.0x ou 1.25x).
    - Sem diálogo (silêncios, intervalos): acelera para 2.5x - 3.0x ou pula para a próxima fala.
  - [x] Atalhos rápidos de ativação:
    - `Alt+i` ou `Ctrl+n`: Ligar / Desligar o modo imersão.
    - `Alt+m`: Alternar entre modo "Acelerar no silêncio" e modo "Pular direto pro diálogo".
    - `Alt+]` e `Alt+[`: Ajustar a velocidade rápida do silêncio.

- [x] **5. Inteligência de Legendas & Fim das Legendas Forçadas**
  - [x] **Fim das Legendas Forçadas Indesejadas:**
    - `sub-forced-only=no` no `mpv.conf`.
    - Script e atalho inteligente (`Shift+v` / `V`) para forçar o descarte de qualquer trilha marcada como `forced` ou `default` (sem conflito com CopyQ).
  - [x] **Sincronização Fácil e Inteligente:**
    - Ajuste fino rápido em tempo real (`z` atrasa 50ms, `Z` adianta 50ms).
    - Tecla `Alt+z` para resetar o delay de legenda a zero.
    - Suporte a script de alinhamento por áudio (`ffsubsync`).
  - [x] **Solução para Hardsub (Legenda Queimada no Vídeo):**
    - Filtro de máscara sutil (`drawbox` com opacidade/blur) ativável por tecla (`Alt+b`) para cobrir legendas queimadas que atrapalham a leitura de uma segunda legenda em inglês.

- [x] **5.5. 🧠 Smart-Lang: Super-Inteligência de Idioma & Dual Audio (`smart-lang.lua`)**
  - [x] **Auto-Select Inteligente:** Ao abrir qualquer vídeo, pontua e seleciona automaticamente a MELHOR legenda para imersão em inglês (prioriza EN Full > EN SDH > EN qualquer > PT). Descarta forçadas, comentários e Signs/Songs automaticamente.
  - [x] **Dual Audio Link Automático:** Ao trocar de áudio com `a`/`A`, a legenda troca JUNTO para o idioma correspondente. Áudio EN → Legenda EN. Áudio PT → Legenda PT. Áudio JA → Legenda EN.
  - [x] **Modo Imersão (`Alt+e`):** Configura tudo em 1 tecla: Áudio EN + Legenda EN. Zero cliques extras.
  - [x] **Modo Nativo (`Alt+p`):** Configura tudo em 1 tecla: Áudio PT + Legenda PT.
  - [x] **Dual Subtitles (`Ctrl+e`):** Ativa legendas duplas lado a lado: EN embaixo + PT em cima. Perfeito para estudo comparativo.
  - [x] **Auto-Download:** Se o vídeo não tem nenhuma legenda boa, o script tenta baixar automaticamente via `subliminal` em background (sem apertar nada!).

- [x] **6. Mapeamento Mestre de Atalhos (`home/dot_config/mpv/input.conf`)**
  - [x] Atalhos ergonômicos, intuitivos e sem conflitos com o Hyprland.
  - [x] Controle de velocidade nos colchetes (`[` e `]`), volta com `BS`.
  - [x] Ajustes de áudio e balanceamento estéreo.

- [x] **7. Automação de Instalação no `setup.sh`**
  - [x] Adicionar bloco de instalação das dependências (`mpv`, `mpv-uosc`, `mpv-thumbfast`, `ffmpeg`) no setup do sistema.
  - [x] Vinculação automática das configurações via dotfiles.

---

## 🧠 Arquitetura dos Problemas Resolvidos

### 1. O Problema da Legenda Forçada (Softsub vs Hardsub)
* **Softsub Forced:** Arquivos MKV que vêm com a flag `forced=1` na legenda em português. O MPV normalmente obedece essa flag ignorando a escolha do usuário. Com `sub-forced-only=no` e sanitização de trilha, o MPV respeita a prioridade do usuário (ou nenhuma legenda, ou inglês).
* **Hardsub:** Vídeos com legenda gravada direto nos pixels. Criamos um filtro de máscara dinâmico ajustável com `Alt+b` para ofuscar o rodapé inferior caso o usuário queira sobrepor legenda limpa em inglês.

### 2. O Problema da Desincronização Resolvido em Definitivo
* **Sincronização por Voz Universal (`Ctrl + z`):** Funciona tanto com arquivos `.srt` externos quanto com **legendas embutidas dentro do MKV/MP4** (o script extrai a trilha interna e roda o alinhador acústico `ffsubsync` sem você abrir terminal).
* **Correção Instantânea de Framerate Drift (`Ctrl + [` e `Ctrl + ]`):**
  * `Ctrl + [`: Converte de **25.0 fps para 23.976 fps** (atraso progressivo de 4.1%).
  * `Ctrl + ]`: Converte de **23.976 fps para 25.0 fps** (avanço progressivo de 4.3%).
  * `Ctrl + Backspace`: Reseta a velocidade da legenda.
* **Ajuste Manual Fino em Tempo Real:** `z` e `Z` (passos de 50ms), e `Alt + z` para zerar.
* **Cache Inteligente:** Legendas sincronizadas ficam salvas em `~/.cache/mpv_synced_subs/` para abrirem instantaneamente nas próximas vezes.

### 3. Download Automático de Legendas (1 Clique + Automático)
* Tecla **`Ctrl + s`**: Consulta a API do OpenSubtitles buscando a melhor legenda em Inglês ou Português compatível com o release do vídeo e já aplica na tela.
* **Smart-Lang Auto-Download:** Se ao abrir um vídeo ele não tiver NENHUMA legenda em EN ou PT, o `smart-lang.lua` baixa automaticamente via `subliminal` sem você apertar nada.

### 4. Pular Aberturas e Encerramentos (Netflix Style)
* Script `skip-intro.lua`: Ao detectar capítulos de abertura (*Opening, Intro, Abertura, Recap*), avisa na tela e permite pular instantaneamente pressionando **`Tab`**.

### 5. O Problema de Memorizar os Atalhos (Zero Esforço)
* **HUD Visual Integrado:** Pressione **`?`** ou **`F1`** ou **`h`** durante o vídeo e veja uma tela semi-transparente com todos os atalhos organizados por categoria.
* **Menu de Contexto do Mouse:** Clique com o botão direito (`MBTN_RIGHT`) para controlar áudio, legendas, velocidade e capítulos graficamente via `uosc`.
* **Central de Atalhos do Hyprland:** O menu `SUPER + H` (`KeyHints.sh`) agora lista todos os atalhos do MPV God Mode.

### 6. Modo Noturno (Speech Clarity)
* Tecla **`n`**: Aplica o filtro dinâmico de áudio (`dynaudnorm`) que nivela o volume: vozes sussurradas ficam cristalinas e explosões estrondosas são suavizadas.

### 7. Modo Binge-Watch Automático (Estilo Netflix)
* Script `auto-next.lua`: Quando um episódio de série atinge os 3 segundos finais, surge uma contagem na tela e o próximo episódio da pasta é iniciado automaticamente (pressione `Esc` para cancelar).

### 8. 🧠 Smart-Lang: Inteligência de Dual Audio & Seleção de Idioma (100% Full Auto)
* **O Problema:** Em vídeos Dual Audio (ex: Inglês e Português), ao trocar a faixa de áudio, a legenda continuava no idioma antigo ou desincronizada, obrigando o usuário a procurar trilhas e sincronizar manualmente.
* **A Solução:** O `smart-lang.lua` gerencia o ciclo completo de pontuação, download, alinhamento acústico e cache de forma **100% FULL AUTOMÁTICA (Zero Teclas Extras)**:
  * **Ao abrir o vídeo:** Identifica o áudio inicial (ex: EN). Se já assistiu antes, puxa a legenda sincronizada do cache em <100ms. Se for a 1ª vez, seleciona a melhor legenda em inglês (sem forçadas/comentários) e dispara o `ffsubsync` em background para cachear. Se o vídeo não tiver legenda, baixa pelo `subliminal`, sincroniza e projeta na tela.
  * **Ao trocar áudio (`a` ou botão direito uosc):**
    * Detecta a troca de trilha instantaneamente (com debounce inteligente para evitar spam se ciclar faixas).
    * Mapeia automaticamente o idioma: **Áudio EN → Legenda EN** | **Áudio PT → Legenda PT** | **Áudio JA → Legenda EN**.
    * Se já houver cache dessa legenda: carrega instantaneamente (<100ms).
    * Se não houver cache: seleciona a melhor trilha desse idioma e alinha em background com `ffsubsync` salvando no cache. Se o vídeo não tiver nenhuma legenda desse idioma, baixa via `subliminal` em background e sincroniza com a nova trilha de áudio!
  * **Atalhos Rápidos de Modo de Foco:**
    * **`Alt+e` (Immersion):** 1 tecla → Áudio EN + Legenda EN sincronizada. Foco total em fluência.
    * **`Alt+p` (Native):** 1 tecla → Áudio PT + Legenda PT sincronizada. Modo descanso.
    * **`Ctrl+e` (Dual Sub):** Legenda EN embaixo + PT no topo. Estudo comparativo.

---

## 📦 Dependências Registradas para Instalação Automática

Todas as ferramentas necessárias para a experiência MPV God Mode estão devidamente integradas e registradas nos scripts do ecossistema de dotfiles:

1. **Pacotes Nativos (`packages/pacman-native.txt`):**
   * `mpv`, `mpv-mpris`, `ffmpeg`, `python-pip`, `python-pipx`.
2. **Pacotes AUR (`packages/pacman-aur.txt`):**
   * `mpv-uosc` (interface moderna), `mpv-thumbfast` (miniaturas na timeline), `python-ffsubsync`, `python-subliminal`.
3. **Instalador Geral (`setup.sh`):**
   * Provisiona `ffsubsync` e `subliminal` automaticamente via `pipx` para isolamento e estabilidade total sem conflitos de sistema.
4. **Instalador WSL/Ubuntu (`scripts/setup-ubuntu-wsl.sh`):**
   * Inclui `python3-pip`, `pipx`, `aria2` e configuração automática de `ffsubsync` e `subliminal`.

---

## 🚀 Sinergia Apex Downloader + MPV God Mode

O ecossistema foi desenhado para eliminar 100% do atrito de ponta a ponta:

1. **Download com Áudio Original Garantido (Apex):**
   * Você pode buscar filmes diretamente pelo catálogo internacional: `dl -y "Inception"` ou opção `2` no menu do Apex.
   * O release vem em **1080p BluRay ou 4K com Áudio Original em Inglês (AAC / 5.1 Surround)** baixado em segundos via `aria2c` com 16 conexões.
2. **Fallback Inteligente no Pomfy:**
   * Se você tentar baixar um filme pelo Pomfy pedindo áudio em inglês (`--original` ou `[2]`), e o servidor do Pomfy só tiver a versão dublada em português:
   * O Apex **detecta antes de baixar**, emite um aviso amigável e aciona automaticamente o fallback para o release BluRay em inglês via YTS!
3. **Reprodução e Imersão Instantânea (MPV):**
   * Ao abrir o arquivo no MPV, o `smart-lang.lua` reconhece a faixa em inglês, busca a legenda correspondente, faz o alinhamento acústico com `ffsubsync` em background e armazena em cache permanente.



