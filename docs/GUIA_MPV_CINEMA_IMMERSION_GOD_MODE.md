# 🎬 MPV God Mode: Arquitetura, Imersão em Inglês & Inteligência de Legendas

> **Status:** 📐 Planejado & Em Execução  
> **Objetivo:** Transformar o `mpv` no ecossistema definitivo para o Arch Linux + Hyprland, unindo visual futurista, consumo eficiente de séries, imersão acelerada em inglês (densidade linguística) e resolução definitiva para problemas de legendas (forçadas, desincronizadas ou queimadas).

---

## 📋 Checklist de Implementação

- [ ] **1. Core Engine & Configuração de Alta Fidelidade (`home/dot_config/mpv/mpv.conf`)**
  - [ ] Renderização com `vo=gpu-next` e aceleração por hardware nativa (`hwdec=auto-safe` / VA-API).
  - [ ] Correção de pitch de áudio (`audio-pitch-correction=yes`) para reprodução limpa a 1.25x+ sem voz de esquilo.
  - [ ] Buffer inteligente e generoso (`demuxer-readahead-secs=30`, `demuxer-max-bytes=500M`) para stream e pré-carregamento de legendas.
  - [ ] Memória de reprodução ativada (`save-position-on-quit=yes`).
  - [ ] Manter player aberto ao final do episódio (`keep-open=yes`) para encadear na playlist.
  - [ ] Otimização para Hyprland (sem bordas de janela padrão, modo tela cheia fluido).

- [ ] **2. Interface Futurista & Navegação (`uosc` + `thumbfast`)**
  - [ ] Instalação e integração do `uosc` (menus contextuais OSD, seletor visual de áudio, legendas e velocidade).
  - [ ] Integração do gerador de miniaturas na linha do tempo (`thumbfast`).
  - [ ] Menu de contexto sob botão direito com controle de trilhas e capítulos.

- [ ] **3. Gestor Autônomo de Séries & Fila (`autoload.lua`)**
  - [ ] Script para detecção automática de episódios na mesma pasta.
  - [ ] Ordenação numérica natural de episódios (S01E01, S01E02...).
  - [ ] Atalhos de playlist rápidos: `ENTER` para menu de episódios, `<` e `>` para anterior/próximo episódio.

- [ ] **4. Motor de Imersão em Inglês & Densidade de Estudo (`sub-skip.lua`)**
  - [ ] Detecção de silêncio e aceleração dinâmica:
    - Com diálogo/legenda ativa: velocidade padrão (ex: 1.0x ou 1.25x).
    - Sem diálogo (silêncios, intervalos): acelera para 2.5x - 3.0x ou pula para a próxima fala.
  - [ ] Atalhos rápidos de ativação:
    - `Alt+i` ou `Ctrl+n`: Ligar / Desligar o modo imersão.
    - `Alt+m`: Alternar entre modo "Acelerar no silêncio" e modo "Pular direto pro diálogo".
    - `Alt+]` e `Alt+[`: Ajustar a velocidade rápida do silêncio.

- [ ] **5. Inteligência de Legendas & Fim das Legendas Forçadas**
  - [ ] **Fim das Legendas Forçadas Indesejadas:**
    - `sub-forced-only=no` no `mpv.conf`.
    - Script e atalho inteligente (`Alt+v`) para forçar o descarte de qualquer trilha marcada como `forced` ou `default`.
  - [ ] **Sincronização Fácil e Inteligente:**
    - Ajuste fino rápido em tempo real (`z` atrasa 50ms, `Z` adianta 50ms).
    - Tecla `Alt+z` para resetar o delay de legenda a zero.
    - Suporte a script de alinhamento por áudio (`ffsubsync`).
  - [ ] **Solução para Hardsub (Legenda Queimada no Vídeo):**
    - Filtro de máscara sutil (`drawbox` com opacidade/blur) ativável por tecla (`Alt+b`) para cobrir legendas queimadas que atrapalham a leitura de uma segunda legenda em inglês.

- [ ] **6. Mapeamento Mestre de Atalhos (`home/dot_config/mpv/input.conf`)**
  - [ ] Atalhos ergonômicos, intuitivos e sem conflitos com o Hyprland.
  - [ ] Controle de velocidade nos colchetes (`[` e `]`), volta com `BS`.
  - [ ] Ajustes de áudio e balanceamento estéreo.

- [ ] **7. Automação de Instalação no `setup.sh`**
  - [ ] Adicionar bloco de instalação das dependências (`mpv`, `mpv-uosc`, `mpv-thumbfast`, `ffmpeg`) no setup do sistema.
  - [ ] Vinculação automática das configurações via dotfiles.

---

## 🧠 Arquitetura dos Problemas Resolvidos

### 1. O Problema da Legenda Forçada (Softsub vs Hardsub)
* **Softsub Forced:** Arquivos MKV que vêm com a flag `forced=1` na legenda em português. O MPV normalmente obedece essa flag ignorando a escolha do usuário. Com `sub-forced-only=no` e sanitização de trilha, o MPV respeita a prioridade do usuário (ou nenhuma legenda, ou inglês).
* **Hardsub:** Vídeos com legenda gravada direto nos pixels. Criamos um filtro de máscara dinâmico ajustável com `Alt+b` para ofuscar o rodapé inferior caso o usuário queira sobrepor legenda limpa em inglês.

### 2. O Problema da Desincronização
* Permite ajuste manual instantâneo por milissegundos sem pausar a reprodução.
* Integração com algoritmos de correlação cruzada de áudio para sincronizar automaticamente arquivos `.srt` baixados da internet com o stream real do vídeo.
