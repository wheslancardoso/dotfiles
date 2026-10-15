# 🛡️ GUIA DEFINITIVO: SKYRIM SE/AE NO LINUX (CACHYOS / PROTON / HYPRLAND)
## Lições Aprendidas na Auditoria Forense, Causas da Tela Preta & Checklist Anti-Falha para Novas Instalações

> **Autor:** Engenharia de Sistemas & Pair Programming  
> **Data:** 15 de Outubro de 2026  
> **Ambiente de Referência:** CachyOS Linux (Kernel CachyOS-Bore), Hyprland (Wayland), Proton-GE / Wine-GE, Heroic Games Launcher, GPU NVIDIA RTX 4060/5060, Skyrim Anniversary Edition (v1.6.318.0).  
> **Objetivo Deste Documento:** Registrar exaustivamente o raio-x técnico da batalha de resolução do problema de **tela preta (Black Screen) na gameplay 3D** e **crashes de inicialização**, fornecendo um protocolo rigoroso para garantir que novas instalações ou modpacks funcionem de primeira no Linux sem perda de tempo.

---

## 📑 ÍNDICE
1. [Resumo Executivo do Problema (O Cenário da Crise)](#1-resumo-executivo-do-problema-o-cenário-da-crise)
2. [As 4 Causas-Raízes Descobertas (Raio-X Técnico Profundo)](#2-as-4-causas-raízes-descobertas-raio-x-técnico-profundo)
   - [2.1 O "DLSS5-Feed" e o ReShade 6.8 no Wine/DXVK](#21-o-dlss5-feed-e-o-reshade-68-no-winedxvk)
   - [2.2 Injeção de DLLs Nativas do Windows (`d3d11.dll`, `dxgi.dll`) vs DXVK](#22-injeção-de-dlls-nativas-do-windows-d3d11dll-dxgidll-vs-dxvk)
   - [2.3 Mod de Iluminação Incompleto (O Caso Lux & Meshes Desamparadas)](#23-mod-de-iluminação-incompleto-o-caso-lux--meshes-desamparadas)
   - [2.4 Congelamento de ImageSpace / Pós-Processamento da Creation Engine](#24-congelamento-de-imagespace--pós-processamento-da-creation-engine)
3. [Outros Conflitos Críticos Identificados nos Crash Logs](#3-outros-conflitos-críticos-identificados-nos-crash-logs)
   - [3.1 O Crash Periódico aos 60 Segundos (Sneak Tools)](#31-o-crash-periódico-aos-60-segundos-sneak-tools)
   - [3.2 SKSE Plugins Compilados para Versões Incompatíveis da Engine](#32-skse-plugins-compilados-para-versões-incompatíveis-da-engine)
   - [3.3 O Falso Bloqueio do The Completionist](#33-o-falso-bloqueio-do-the-completionist)
4. [A Descoberta das Ferramentas de Injeção de Entrada no Wayland/Hyprland](#4-a-descoberta-das-ferramentas-de-injeção-de-entrada-no-waylandhyprland)
5. [Guia Passo a Passo: Checklist de Instalação à Prova de Falhas no Linux](#5-guia-passo-a-passo-checklist-de-instalação-à-prova-de-falhas-no-linux)
6. [Tabela Rápida de Diagnóstico de Sintomas](#6-tabela-rápida-de-diagnóstico-de-sintomas)
7. [Script Utilitário de Sanidade (`skyrim_doctor.py`)](#7-script-utilitário-de-sanidade-skyrim_doctorpy)

---

## 1. RESUMO EXECUTIVO DO PROBLEMA (O CENÁRIO DA CRISE)

### O Sintoma
Ao iniciar o jogo pelo Heroic Games Launcher ou terminal:
1. O jogo ou crashava imediatamente no início com `EXCEPTION_ACCESS_VIOLATION` em `d3d11.dll+00BD9A6`.
2. Se abria, no menu principal o logo do dragão aparecia perfeitamente, a música tocava e o cursor funcionava.
3. Porém, ao clicar em "Continue" ou carregar um savegame:
   - A barra de carregamento e as dicas passavam normalmente.
   - Entrava na gameplay: **áudio espacial funcionando, passos audíveis, menu TAB e MCM abrindo, compasso (bússola) e barras de vida/magicka/vigor visíveis**, mas **o mundo 3D inteiro ficava 100% PRETO**.
   - Nenhuma luz, terreno, personagem ou textura aparecia na tela.

---

## 2. AS 4 CAUSAS-RAÍZES DESCOBERTAS (RAIO-X TÉCNICO PROFUNDO)

### 2.1 O "DLSS5-Feed" e o ReShade 6.8 no Wine/DXVK
* **O que era:** Na raiz do jogo havia arquivos de uma tentativa de injetar upscaling/DLSS via ReShade:
  - `dlss5-feed.addon64`, `renodx-dlss5.addon64`
  - Shaders complexos: `Lumenite_Kernel.fx`, `DLSS5_Feed.fx`, `lumenite_ColorManagement.fxh`
  - `nvngx_dlss.dll` e `nvngx_dlssnr.dll`
* **Por que quebra no Linux:**
  No Windows, o driver proprietário intercepta a pipeline DX11 nativa. No Linux via **Proton**, o DirectX 11 é traduzido em tempo real para **Vulkan** através da camada **DXVK**. Shaders de terceiros criados para interceptar backbuffers brutos do DirectX 11 (especialmente addons que calculam luminância via kernels computacionais) falham ao mapear buffers de swapchain do DXVK.
  O shader `Lumenite_Kernel.fx` aplicava uma multiplicação por `0.0` nos canais RGB de saída do viewport 3D enquanto a camada de UI (SWF/Scaleform) rodava em um render target separado — por isso a UI aparecia viva e o 3D ficava totalmente negro.
* **Ação Corretiva:** Isolar todos os `.addon64`, `.fx`, `.fxh` e DLLs do DLSS5 para uma pasta de backup fora da raiz do jogo (`dlss5_full_backup/`).

### 2.2 Injeção de DLLs Nativas do Windows (`d3d11.dll`, `dxgi.dll`) vs DXVK
* **O que era:** Arquivos `d3d11.dll`, `dxgi.dll` e `d3dcompiler_47.dll` soltos na raiz de `Skyrim-AE/`.
* **O Conflito:**
  Quando o executável `SkyrimSE.exe` sobe dentro do Proton, o Windows Loader dá prioridade para bibliotecas locais que estejam no mesmo diretório do `.exe`. Ao encontrar `d3d11.dll` modificado na raiz, o jogo ignorava o `d3d11.dll` do **DXVK** fornecido pelo GE-Proton.
  Isso gerava o crash `EXCEPTION_ACCESS_VIOLATION` com ponteiro `0xFFFFFFFFFFFFFFFF` em `d3d11.dll+00BD9A6` (falha catastrófica de vtable de swapchain).
* **Regra de Ouro no Linux:** **NUNCA** deixe `d3d11.dll` ou `dxgi.dll` soltos na raiz do jogo no Linux, exceto se você souber exatamente como configurar o `WINEDLLOVERRIDES="dxgi=n,b"` sem colidir com o DXVK. O DXVK oficial embutido no Proton GE é imensamente superior e estável.

### 2.3 Mod de Iluminação Incompleto (O Caso Lux & Meshes Desamparadas)
* **O que era:** A pasta `Data/` continha diversos plugins do ecossistema **Lux** (`Lux.esp`, `Lux - USSEP patch.esp`, `Lux - Eli's Breezehome patch.esp`, etc.) e dezenas de meshes soltas terminadas em `_Lux.nif`.
* **A Falha Oculta:** O mod mestre essencial `Lux - Resources.esp` **NÃO ESTAVA PRESENTE**.
* **Impacto na Engine:**
  Em Skyrim, o Lux substitui as lâmpadas e splitters de luz estáticos por malhas customizadas que leem emissores de luz definidos no `Lux - Resources.esp`. Sem o mestre ativo, a engine atribui intensidade `0.0` (black body) para os emissores desamparados. Além disso, as meshes soltas aplicavam flags de iluminação que escureciam os cômodos e exteriores para luz nula.
* **Ação Corretiva:** Retirar todos os `.esp/.esm` do Lux e mover para quarentena (`lux_esp_backup/`), além de expurgar as malhas `_Lux.nif` soltas de `Data/meshes/`.

### 2.4 Congelamento de ImageSpace / Pós-Processamento da Creation Engine
* **A Causa do Silêncio Gráfico:**
  Mesmo após remover o ReShade e os mods problemáticos, ao carregar o savegame existente, a tela continuava preta.
  A Creation Engine possui uma pilha de pós-processamento chamada **ImageSpace Modifiers** (ISMs). Quando você entra em menus, toma dano de veneno, fica cego ou passa por efeitos de fade-in/fade-out cinematográficos, a engine aplica um modificador de matriz de cor.
  No save anterior, o jogo havia sido salvo ou dessincronizado no meio de uma transição de tela preta (provocada pelo shader que falhou anteriormente). Esse modificador ficou **gravado dentro do bloco de dados do savegame (.ess)**!
* **A Cura pelo Console:**
  O comando `teofis` (*Toggle End Of Frame Image Space*) instrui a Creation Engine a desativar temporariamente todos os passes de pós-processamento de final de quadro (bloom, blur, DoF, tonemapping e filtros de tela). No instante em que `teofis` foi acionado:
  - O mundo 3D saltou na tela com 100% de nitidez e luz natural.
  - Ao alternar novamente e andar pelo mapa para acionar um novo gatilho de célula (ex: Riverwood exterior), a engine recalculou o ImageSpace default e limpou o modificador corrompido do save.

---

## 3. OUTROS CONFLITOS CRÍTICOS IDENTIFICADOS NOS CRASH LOGS

Ao longo da depuração forense dos relatórios do `CrashLoggerSSE`, outros 3 problemas gravíssimos foram dissecados e resolvidos:

### 3.1 O Crash Periódico aos 60 Segundos (Sneak Tools)
* **Log:**
  ```text
  Unhandled exception "EXCEPTION_ACCESS_VIOLATION" at 0x6FFFF6CBB4D0 SkyrimSE.exe+104B4D0 mov rax, [rcx]
  Base Register: rcx = 0x000000015AE5F030
  Process Uptime: 00:01:36 (96092ms)
  Thread Context: Stack trace apontando para Papyrus VM / SneakTools
  ```
* **Causa:** O mod `Sneak Tools` roda um script contínuo que varre o inventário do jogador a cada 60 segundos procurando se ele equipou uma "Dark Brotherhood Mask" ou capuz para mascarar a identidade. Na versão AE 1.6.318, o offset do `PlayerCharacter` mudou em relação ao Skyrim 1.5.97, fazendo o ponteiro tentar ler memória protegida do sistema.
* **Solução:** O mod `Sneak Tools.esp` foi desmarcado da `plugins.txt`.

### 3.2 SKSE Plugins Compilados para Versões Incompatíveis da Engine
* **Contexto:** Skyrim SE sofreu fragmentação profunda de versões:
  - `1.5.97` (Special Edition Clássico)
  - `1.6.318 / 1.6.353` (Início da Anniversary Edition)
  - `1.6.640` (Versão intermediária estável do GOG/Steam)
  - `1.6.1170` (Versão atual da Steam)
* **O Perigo:** Se um plugin `.dll` em `Data/SKSE/Plugins/` tiver sido compilado usando endereçamento de memória do 1.6.640 ou 1.6.1170 e você rodar no executável 1.6.318, o SKSE aborta a inicialização ou a engine sofre crash instantâneo com erro de offset.
* **Ação Tomada:** Todos os plugins incompatíveis foram isolados na pasta `Data/SKSE/Plugins_incompatible_ae/`, mantendo em `Plugins/` apenas os que possuem suporte comprovado ao runtime 1.6.318 (como `CrashLogger`, `MoreInformativeConsole`, `InfinityUI`, `TrueDirectionalMovement`, etc.).

### 3.3 O Falso Bloqueio do The Completionist
* **O Erro:** Caixa de diálogo do Windows pulando na tela: `Completionist.esp not found in load order. Exit process?`.
* **Causa:** O autor do mod `Completionist.dll` colocou uma trava em C++ que aborta o jogo com `exit()` se o respectivo `.esp` não for detectado na `plugins.txt`.
* **Solução:** Como o `.esp` não estava instalado, renomeou-se o arquivo para `Completionist.dll.disabled`.

---

## 4. A DESCOBERTA DAS FERRAMENTAS DE INJEÇÃO DE ENTRADA NO WAYLAND/HYPRLAND

Durante a investigação sob o Hyprland (Wayland), ferramentas antigas do X11 como `xdotool` e simuladores convencionais como `wtype` não conseguiram enviar teclas com foco para dentro da janela gráfica do Wine/Proton em fullscreen.

Para solucionar isso sem depender de janelas ativas, criamos um emulador direto do subsistema de kernel Linux **`/dev/uinput` via Python**:
* Cria um dispositivo de teclado de hardware virtual no nível do kernel (`UI_DEV_CREATE`).
* Emite eventos `EV_KEY` e `EV_SYN` de baixíssimo nível que são lidos pelo compositor Wayland e repassados ao Proton como se um teclado físico real estivesse sendo pressionado.
* Isso permitiu interagir com os menus do jogo, dispensar mensagens de aviso e abrir o console (`~`) para digitar os comandos de recuperação mesmo com a tela escura.

---

## 5. GUIA PASSO A PASSO: CHECKLIST DE INSTALAÇÃO À PROVA DE FALHAS NO LINUX

Se você for instalar o Skyrim do zero novamente, reinstalar pelo Heroic Games Launcher ou clonar para outra máquina com Linux, siga **ESTA ORDEM EXATA**:

### Passo 1: Preparação Limpa do Diretório
- [ ] Garanta que a raiz do jogo **NÃO contenha**:
  - `dxgi.dll`
  - `d3d11.dll`
  - `d3dcompiler_47.dll`
  - Arquivos `.addon64` ou pastas `reshade-shaders/`
- [ ] O executável principal deve ser lançado pelo `skse64_loader.exe` configurado no Heroic/Lutris, **nunca** diretamente pelo `SkyrimSE.exe` vanilla se você usa mods de script.

### Passo 2: Configuração do Heroic Games Launcher / Proton
- [ ] **Runner recomendado:** `GE-Proton` mais recente (ex: `GE-Proton9-25` ou `Proton-CachyOS`).
- [ ] **DXVK:** Ativado por padrão no Proton.
- [ ] **Variáveis de Ambiente Recomendadas no Heroic:**
  ```bash
  WINEDLLOVERRIDES="steam_api64=n,b"
  ```
  *(Se for versão GOG, utilize o prefixo limpo sem necessidade de emuladores Steam)*.
- [ ] No arquivo de configuração do jogo no Heroic (`~/.config/heroic/GamesConfig/<ID>.json`):
  - Defina `"disableUMU": true` se você estiver usando um script wrapper personalizado ou executável customizado.

### Passo 3: Saneamento do Prefixo Wine e Arquivos `.ini`
O prefixo fica em:
`~/Games/Heroic/Prefixes/shared/pfx/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition/`
- [ ] **`SkyrimPrefs.ini`:**
  - `bFull Screen=0`
  - `bBorderless=1`
  - `iSize W=1920` (ou sua resolução nativa)
  - `iSize H=1080`
  - `bUse64bitsHDRRenderTarget=1`
- [ ] **`plugins.txt`:**
  - Deve ficar localizado em:
    `drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/plugins.txt`
  - Todo mod ativo deve conter o asterisco `*` antes do nome:
    ```text
    *Skyrim.esm
    *Update.esm
    *Dawnguard.esm
    *HearthFires.esm
    *Dragonborn.esm
    *ccBGSSSE001-Fish.esm
    *Unofficial Skyrim Special Edition Patch.esp
    *SkyUI_SE.esp
    ```

### Passo 4: Verificação da Tríade de Mods de Iluminação
- [ ] Se for usar mods como **Lux**, **ELFX** ou **RLO**:
  - **NUNCA** ative patches de compatibilidade sem o mod mestre correspondente (`Lux.esp` exige `Lux - Resources.esp` carregado antes).
  - Nunca deixe malhas (`meshes/*.nif`) soltas se o plugin principal que as alimenta estiver ausente.

### Passo 5: Verificação de Versão de SKSE Plugins (`Data/SKSE/Plugins/*.dll`)
- [ ] Execute sempre uma checagem de versão:
  - Verifique na página do mod no Nexus se o arquivo baixado é explicitamente para a sua versão da engine (ex: `v1.6.318` ou `v1.6.640` ou `v1.6.1170`).
  - Se um mod não tiver versão para seu build, procure pelo equivalente **CommonLibSSE-NG** (que possui autodetecção dinâmica de versão).

---

## 6. TABELA RÁPIDA DE DIAGNÓSTICO DE SINTOMAS

| Sintoma Observado | Causa Mais Provável | Ação Imediata |
| :--- | :--- | :--- |
| **Crash nos primeiros 2 segundos (nem abre a janela)** | `d3d11.dll` ou `dxgi.dll` incompatível na raiz; ou DLL do SKSE com offset inexistente. | Exclua `d3d11.dll` da raiz e verifique o último log em `Documents/.../SKSE/CrashLogger/`. |
| **Crash aos 60s exatos de jogo** | Mod com timer de inventário/script periódico inválido (ex: `Sneak Tools`). | Desative o mod problemático na `plugins.txt`. |
| **Menu inicial funciona, mas a gameplay fica 100% preta com som e HUD ativos** | Shader/ReShade externo tentando ler buffer de swapchain incorreto; ou ImageSpace travado. | Remova pastas do ReShade/DLSS5. Abra o console (`~`) e execute `teofis` para resetar o pós-processamento. |
| **Caixa de diálogo do Windows avisando que um `.esp` não foi encontrado** | Mod do SKSE com checagem rígida de dependência (ex: `Completionist.dll`). | Instale o `.esp` faltante ou renomeie a dll para `.dll.disabled`. |
| **Janela não ganha foco ou input no Hyprland** | Conflito de captura do compositor Wayland com janelas em modo exclusivo. | Configure `bFull Screen=0` e `bBorderless=1` no `SkyrimPrefs.ini`. |

---

## 7. SCRIPT UTILITÁRIO DE SANIDADE (`skyrim_doctor.py`)

Para não precisar fazer tudo na mão no futuro, o script em:
[`/home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py`](file:///home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py)

Executa automaticamente:
1. Varredura por DLLs perigosas na raiz (`d3d11.dll`, `dxgi.dll`).
2. Sincronização e verificação de integridade do `plugins.txt` entre os diretórios `Public` e `steamuser` do Proton.
3. Checagem de integridade das bibliotecas do SKSE.
4. Lançamento isolado do jogo com os overrides de biblioteca corretos.

---
*Fim do Relatório Técnico. Este documento deve ser consultado sempre antes de realizar grandes atualizações de mods ou reinstalações no ecossistema Linux.*
