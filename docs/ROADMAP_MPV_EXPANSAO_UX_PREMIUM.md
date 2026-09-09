# 🎬 ROADMAP: Expansão de UX & Anti-Atrito MPV Premium

> **Data de Registro:** 09 de Setembro de 2026  
> **Previsão de Execução:** 12 de Setembro de 2026 (Daqui a 3 dias)  
> **Objetivo:** Elevar o MPV do "God Mode" de automação/scripts para a experiência visual comercial completa (nível Netflix, IINA e Crunchyroll), sem perder a leveza e a aceleração gráfica por hardware.

---

## 📍 1. Diagnóstico do Setup Atual (O que já temos)

* ✅ **Pipeline Gráfico Moderno:** `vo=gpu-next` (libplacebo), `gpu-api=auto`, `scale=ewa_lanczos`.
* ✅ **Áudio:** Correção de pitch automática para velocidades aceleradas (`audio-pitch-correction=yes`).
* ✅ **Histórico & Smart-Resume:** `smart-resume.lua` com banco de dados JSON, auto-skip inteligente de episódios concluídos (>85%) com contagem de 4s cancelável via `Esc`/`Espaço`.
* ✅ **Dashboard no Hyprland:** `continuar.sh` via Rofi (`Super + Ctrl + C` / `Super + Alt + P`) e FZF.
* ✅ **Automação de Séries:** `autoload.lua` com suporte a **Multi-Season** contínuo e `auto-next.lua`.
* ✅ **Superinteligência de Idiomas:** `smart-lang.lua` (troca de áudio sincronizada, modo imersão e Dual Sub para estudo).
* ✅ **Ferramental Acústico e Legendas:** `sub-sync.lua` (ffsubsync), `forced-sub-killer.lua`, `skip-intro.lua`, `sub-skip.lua`, `night-mode.lua` e `hardsub-mask.lua`.

---

## 🚀 2. Fases de Expansão (Para Executar em 3 Dias)

---

### 🎨 FASE 1: A Camada de Interface & Miniaturas (Prioridade Alta)
*Transforma o visual espartano em uma experiência fluida com controles ao passar o mouse e pré-visualização de quadros.*

1. **`uosc` (Universal OSC):**
   * **O que faz:** Substitui o OSC padrão cinza do MPV por uma barra de progresso minimalista, controles com fade-in suave, controle de volume fino, gavetas de playlists e menus de contexto no botão direito.
   * **Instalação:**
     ```bash
     yay -S mpv-uosc
     # ou via git clone:
     # git clone https://github.com/tomasklaen/uosc ~/.config/mpv/scripts/uosc
     ```
   * **Configuração:** O arquivo `~/.config/mpv/script-opts/uosc.conf` já existe no repositório.

2. **`thumbfast` (Miniaturas em Tempo Real na Barra de Progresso):**
   * **O que faz:** Ao passar o mouse pela linha do tempo, exibe uma janela flutuante com a miniatura exata daquele segundo do vídeo (estilo YouTube/Netflix).
   * **Instalação:**
     ```bash
     yay -S mpv-thumbfast
     # ou download direto:
     # curl -Lo ~/.config/mpv/scripts/thumbfast.lua https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua
     ```
   * **Sinergia:** O `uosc` reconhece o `thumbfast` automaticamente com zero configuração adicional.

3. **`Anime4K` (Shaders GLSL de Upscaling Inteligente):**
   * **O que faz:** Upscaling neural em tempo real otimizado para animações e desenhos, eliminando ruídos de compressão e deixando linhas 1080p e 720p nítidas em 4K.
   * **Instalação:**
     * Baixar os shaders para `~/.config/mpv/shaders/Anime4K/`.
   * **Atalhos recomendados no `input.conf`:**
     * `Ctrl+1`: Ativar Perfil A (Alta qualidade / Traço limpo).
     * `Ctrl+2`: Ativar Perfil B (Restauração de vídeo antigo).
     * `Ctrl+0`: Desativar Shaders (Voltar ao `ewa_lanczos` nativo).

---

### 🀄 FASE 2: Estudo de Idiomas de Alta Produtividade (Prioridade Média)

1. **`mpvacious` (Subs2SRS / Integração Anki):**
   * **O que faz:** Com um único atalho (`Ctrl+m`), recorta o áudio exato da frase da legenda atual, tira um screenshot da cena e cria um flashcard instantâneo no **Anki** com áudio, texto e imagem.
   * **Pré-requisitos:**
     * Anki aberto em segundo plano com o plugin **AnkiConnect** (código: `2055492159`).
   * **Instalação:**
     ```bash
     git clone https://github.com/Ajatt-Tools/mpvacious ~/.config/mpv/scripts/mpvacious
     ```

2. **`seek-to.lua`:**
   * **O que faz:** Permite digitar o timestamp exato para pular direto (ex: digitar `12:34` e ir para aquele momento).

3. **`quality-menu.lua`:**
   * **O que faz:** Se você abrir streams ou links do YouTube/Vimeo direto no MPV via `yt-dlp`, abre um menu na tela para trocar a resolução (1080p, 4K, 720p) e codec em tempo real.

---

### 🎮 FASE 3: Social & Qualidade de Vida (Prioridade Baixa)

1. **`mpv-discord-rpc`:**
   * **O que faz:** Mostra no seu perfil do Discord o anime/filme que você está assistindo, com capa, tempo decorrido e tempo restante.
2. **`reload.lua`:**
   * **O que faz:** Tecla `Ctrl+r` para recarregar o stream sem perder a posição de reprodução caso haja queda de conexão.

---

## 🛠️ 3. Checklist de Execução Concluído (09/09/2026)

Fase 1 e melhorias de UX implementadas e ativas no sistema:

- [x] Instalar `uosc` (v5.13.0) e `thumbfast` integrados nativamente no MPV com fontes OTF/TTF.
- [x] Baixar os shaders do `Anime4K` (v4.0.1) para `~/.config/mpv/shaders/Anime4K/`.
- [x] Mapear as teclas de perfil do Anime4K (`Ctrl+1`, `Ctrl+2`, `Ctrl+3`, `Ctrl+0`) no `input.conf`.
- [x] Adicionar `quality-menu.lua` (`Ctrl+q` / `Alt+q`) para troca dinâmica de resolução em streams.
- [x] Adicionar `reload.lua` (`Ctrl+r`) para recarregar streams mantendo a posição exata.
- [x] Corrigir opções legadas no `mpv.conf` (`sub-forced-events-only`) e `uosc.conf`.
- [x] Atualizar rotina de deploy no `setup.sh` para links de pastas (`uosc`, `shaders`, `fonts`).
- [x] Testar inicialização e compilação dos shaders GLSL do MPV (0 erros, 0 warnings).
- [x] Comitar e sincronizar no repositório `dotfiles`.
