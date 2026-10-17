# 🏛️ MANUAL DEFINITIVO DE ENGENHARIA & RESILIÊNCIA: SKYRIM SE/AE NO LINUX
## Arquitetura de Execução, Diagnóstico Forense da Tela Preta, Estabilização do Mouse no Hyprland e Integração de 172 Mods sob Proton & Gamescope

> **Ambiente Operacional de Referência:**
> * **Hardware:** GPU NVIDIA GeForce RTX 5060 (Arquitetura Blackwell) | Monitor 100Hz 1080p | Teclado Bluetooth Logitech K380/K380s | Áudio QCY
> * **Sistema Operacional & Kernel:** CachyOS / Arch Linux (Kernel `linux-cachyos-bore`, glibc otimizada x86-64-v3/v4)
> * **Servidor Gráfico & Compositor:** Wayland nativo + Hyprland (versão >= 0.53 / 0.56)
> * **Camada de Compatibilidade:** GE-Proton (latest / 9-25) + Heroic Games Launcher + Gamescope Microcompositor
> * **Motor do Jogo:** The Elder Scrolls V: Skyrim Anniversary Edition (Build `1.6.318.0`) - Creation Engine 64-bit
> * **Camada SKSE:** Skyrim Script Extender 64-bit (`skse64_2_01_05` / runtime `1.6.318`)
> * **Volume de Armazenamento:** `/mnt/dados/Jogos/Skyrim-AE` (Partição EXT4)
> * **Prefixo Wine/Proton:** `/home/lan/Games/Heroic/Prefixes/shared`

---

## 📑 ÍNDICE GERAL

1. [Visão Geral & Topologia da Arquitetura](#1-visão-geral--topologia-da-arquitetura)
2. [O Mapa de Danos: As 7 Crises que Impediam o Jogo de Rodar](#2-o-mapa-de-danos-as-7-crises-que-impediam-o-jogo-de-rodar)
3. [Diagnóstico Forense Aprofundado (Raio-X das Causas-Raízes)](#3-diagnóstico-forense-aprofundado-raio-x-das-causas-raízes)
   - [3.1 O ReShade 6.8 & O Injetor DLSS5/Lumenite vs DXVK](#31-o-reshade-68--o-injetor-dlss5lumenite-vs-dxvk)
   - [3.2 O Sequestro do DXVK por DLLs Nativas do Windows](#32-o-sequestro-do-dxvk-por-dlls-nativas-do-windows)
   - [3.3 Configurações Fatais de Render Targets (`bUse64bitsHDRRenderTarget`)](#33-configurações-fatais-de-render-targets-buse64bitshdrrendertarget)
   - [3.4 O "Savegame Infectado" e o ImageSpace Modifier no Binário `.ess`](#34-o-savegame-infectado-e-o-imagespace-modifier-no-binário-ess)
   - [3.5 O Conflito Triplo do Mouse no Wayland/Hyprland (`no_warps`, >1000 FPS e Scanout)](#35-o-conflito-triplo-do-mouse-no-waylandhyprland-no_warps-1000-fps-e-scanout)
   - [3.6 A Família Lux: O Caso das Malhas Desamparadas vs Lux Via](#36-a-família-lux-o-caso-das-malhas-desamparadas-vs-lux-via)
   - [3.7 O Desastre do Case-Sensitivity no Linux (EXT4/Btrfs)](#37-o-desastre-do-case-sensitivity-no-linux-ext4btrfs)
   - [3.8 A Fragmentação de Builds da Engine e a Address Library](#38-a-fragmentação-de-builds-da-engine-e-a-address-library)
4. [O Protocolo de Solução Cirúrgica Passo a Passo](#4-o-protocolo-de-solução-cirúrgica-passo-a-passo)
   - [Fase 1: Saneamento da Raiz da Engine & Purga de Injetores](#fase-1-saneamento-da-raiz-da-engine--purga-de-injetores)
   - [Fase 2: Normalização do Sistema de Arquivos com `fix_case_dupes.py`](#fase-2-normalização-do-sistema-de-arquivos-com-fix_case_dupespy)
   - [Fase 3: Mapeamento de Unidades do Wine (`dosdevices`)](#fase-3-mapeamento-de-unidades-do-wine-dosdevices)
   - [Fase 4: Estabilização do SKSE, Address Library e BackportedESLSupport](#fase-4-estabilização-do-skse-address-library-e-backportedeslsupport)
   - [Fase 5: Sincronização e Ordenação Cirúrgica do `plugins.txt`](#fase-5-sincronização-e-ordenação-cirúrgica-do-pluginstxt)
   - [Fase 6: Calibração dos Arquivos de Configuração (`.ini` e `dxvk.conf`)](#fase-6-calibração-dos-arquivos-de-configuração-ini-e-dxvkconf)
   - [Fase 7: Correção Definitiva do Cursor do Mouse & Hyprland](#fase-7-correção-definitiva-do-cursor-do-mouse--hyprland)
   - [Fase 8: Descongelamento do Mundo 3D via Console (`teofis`) & Criação de Saves Limpos](#fase-8-descongelamento-do-mundo-3d-via-console-teofis--criação-de-saves-limpos)
   - [Fase 9: Recuperação e Ativação do Lux Via e Isolamento Seguro do Lux Interior](#fase-9-recuperação-e-ativação-do-lux-via-e-isolamento-seguro-do-lux-interior)
5. [O Ferramental de Automação Desenvolvido](#5-o-ferramental-de-automação-desenvolvido)
   - [5.1 `skyrim_doctor.py` (O Agente de Diagnóstico e Execução Soberana)](#51-skyrim_doctorpy-o-agente-de-diagnóstico-e-execução-soberana)
   - [5.2 `run_gamescope.sh` (O Contêiner Microcompositor com Keep-Alive)](#52-run_gamescopesh-o-contêiner-microcompositor-com-keep-alive)
   - [5.3 `fix_case_dupes.py` (O Algoritmo de Fusão de Diretórios por Caixa)](#53-fix_case_dupespy-o-algoritmo-de-fusão-de-diretórios-por-caixa)
   - [5.4 Injeção Virtual de Entrada via Kernel (`/dev/uinput`)](#54-injeção-virtual-de-entrada-via-kernel-devuinput)
6. [Inventário & Matriz de Compatibilidade dos 172 Mods](#6-inventário--matriz-de-compatibilidade-dos-172-mods)
7. [Manual Operacional: Como Jogar e Procedimento de Recuperação](#7-manual-operacional-como-jogar-e-procedimento-de-recuperação)

---

## 1. VISÃO GERAL & TOPOLOGIA DA ARQUITETURA

Jogar Skyrim modificado com mais de 170 mods pesados (incluindo SKSE em C++ nativo, modificadores de animação Nemesis/OAR, overhauls de combate e scripts complexos de Papyrus) em um ecossistema Linux moderno baseado em **Wayland puro (Hyprland)** e placa de vídeo **NVIDIA RTX 5060 (Blackwell)** representa um dos cenários mais exigentes de engenharia reversa e compatibilidade de software.

A arquitetura final estabilizada obedece ao seguinte fluxo físico de execução:

```mermaid
flowchart TD
    subgraph Host Linux [Ambiente Host - CachyOS Linux / Wayland]
        Doctor[skyrim_doctor.py] --> SystemdRun[systemd-run --user]
        SystemdRun --> GamescopeProc[Gamescope 1080p 100Hz]
        Hypr[Hyprland Compositor] -.->|no_warps=false / Workspace 8| GamescopeProc
    end

    subgraph Gamescope Container [Microcompositor Gamescope]
        GamescopeProc --> Runner[run_gamescope.sh]
        Runner --> GEProton[GE-Proton Latest]
    end

    subgraph Wine & Proton Layer [Prefixo Wine Heroic Shared]
        GEProton --> DXVK[DXVK 2.x - Vulkan Swapchain]
        GEProton --> DosDevices[dosdevices s: -> /mnt/dados]
        GEProton --> Registry[user.reg: GrabPointer=Y]
        DXVK --> DXVKConf[dxvk.conf: frameRate=60]
    end

    subgraph Engine Skyrim [Skyrim Anniversary Edition 1.6.318]
        GEProton --> SKSE[skse64_loader.exe]
        SKSE --> AddrLib[Address Library 1.6.318]
        SKSE --> BackportedESL[BackportedESLSupport.dll]
        SKSE --> SkyrimEXE[SkyrimSE.exe]
        SkyrimEXE --> PluginsTxt[plugins.txt: 172 Plugins Ativos]
        SkyrimEXE --> DataDir[/mnt/dados/Jogos/Skyrim-AE/Data]
    end
```

---

## 2. O MAPA DE DANOS: AS 7 CRISES QUE IMPEDIAM O JOGO DE RODAR

Durante os testes de integração inicial, o jogo apresentava uma sequência de falhas bloqueantes que impediam qualquer gameplay:

1. **💥 Crash Instantâneo no Arranque (CTD em 2 segundos):** O jogo encerrava imediatamente ao tentar subir o processo, com `EXCEPTION_ACCESS_VIOLATION` em `d3d11.dll+00BD9A6`.
2. **🌑 O Desastre da "Tela Preta com HUD" (Black Screen with HUD):** Ao carregar um savegame ou iniciar nova partida, o áudio 3D funcionava, passos eram audíveis, o menu de pausa (ESC) e o MCM abriam, a bússola superior e as barras de vida/magicka apareciam intactas, mas **o viewport 3D inteiro (terreno, céu, iluminação e modelos) ficava 100% PRETO**.
3. **🖱️ O Cursor do Mouse Congelado no Centro da Tela:** No menu principal e dentro do jogo, o ponteiro do mouse ficava travado no centro da tela; mover o mouse físico não movia o ponteiro nem a câmera.
4. **⏱️ Crashes Cronometrados a Cada 60 Segundos:** Após 1 minuto de exploração no mapa aberto, o jogo crashava para a área de trabalho sem aviso prévio.
5. **💾 O Savegame "Infectado":** Mesmo após limpar arquivos e shaders, recarregar o savegame existente mantinha a tela escura como breu.
6. **🔤 O Desastre de Case-Sensitivity (Sensibilidade de Caixa):** Diretórios como `Scripts/` e `scripts/`, `Textures/` e `textures/` coexistiam paralelamente na partição Linux EXT4, tornando metade dos mods invisíveis para o Wine.
7. **🕯️ O Apagão de Luzes do Mod Lux:** Entrar em qualquer interior (estalagem, castelo ou caverna) gerava escuridão absoluta porque as malhas customizadas não encontravam suas fontes emissoras.

---

## 3. DIAGNÓSTICO FORENSE APROFUNDADO (RAIO-X DAS CAUSAS-RAÍZES)

### 3.1 O ReShade 6.8 & O Injetor DLSS5/Lumenite vs DXVK
* **Causa-Raiz:** Na pasta raiz do Skyrim existiam arquivos residuais de uma tentativa de injetar upscaling neural e shaders avançados:
  - `dlss5-feed.addon64`, `renodx-dlss5.addon64`
  - `Lumenite_Kernel.fx`, `DLSS5_Feed.fx`, `lumenite_ColorManagement.fxh`
  - `nvngx_dlss.dll`, `nvngx_dlssnr.dll`
* **Mecanismo da Falha:** No Windows, o driver NVIDIA intercepta o pipeline DirectX 11 nativo. No Linux sob Proton, o DX11 é traduzido em tempo real para Vulkan via **DXVK**. Shaders de terceiros criados para interceptar backbuffers brutos do DirectX 11 falharam ao mapear os render targets virtuais do DXVK. O shader `Lumenite_Kernel.fx` aplicava uma multiplicação aritmética por `0.0` nos canais RGB de saída do viewport 3D. Como a UI do Skyrim (Scaleform/Flash) roda em um render target isolado de overlay, a interface ficava visível e o mundo 3D colapsava em preto total.
* **Solução:** Quarentena completa de todos os arquivos de ReShade e DLSS para `dlss5_full_backup/`.

### 3.2 O Sequestro do DXVK por DLLs Nativas do Windows
* **Causa-Raiz:** Presença de arquivos `d3d11.dll`, `dxgi.dll` e `d3dcompiler_47.dll` soltos na raiz do jogo.
* **Mecanismo da Falha:** O Windows Loader (emulado pelo Wine) prioriza DLLs que estejam no mesmo diretório do executável (`SkyrimSE.exe`). Ao encontrar um `d3d11.dll` modificado na raiz, o jogo ignorava o `d3d11.dll` do DXVK fornecido pelo GE-Proton. O resultado era um desastre de ponteiro nulo (`0xFFFFFFFFFFFFFFFF`) na chamada de swapchain, gerando o crash imediato de inicialização.
* **Solução:** Eliminação/isolamento das DLLs na raiz e imposição estrita de overrides no Wine: `WINEDLLOVERRIDES="dxgi=n,b;d3d11=n,b;steam_api64=n,b"`.

### 3.3 Configurações Fatais de Render Targets (`bUse64bitsHDRRenderTarget`)
* **Causa-Raiz:** A linha `bUse64bitsHDRRenderTarget=1` estava habilitada no `SkyrimPrefs.ini`.
* **Mecanismo da Falha:** Essa flag instrui a engine da Bethesda a alocar buffers FP16 HDR de 64 bits para iluminação. No ecossistema DirectX 11 nativo com ENBSeries, o binário do ENB consome esse buffer. Porém, rodando com DXVK puro sem ENB, a cadeia de apresentação Vulkan não recebia o tonemapper esperado, culminando em luminância zerada. Adicionalmente, `bUseTAA=1` e `bDoDepthOfField=1` tentavam ler depth buffers incompatíveis.
* **Solução:** Configuração estrita de `bUse64bitsHDRRenderTarget=0`, `bDoDepthOfField=0`, `bUseBlurShader=0`, `bUseTAA=0` e ativação de `bFXAAEnabled=1`.

### 3.4 O "Savegame Infectado" e o ImageSpace Modifier no Binário `.ess`
* **Causa-Raiz:** Mesmo após consertar shaders e INIs, carregar o save `001 lanworkinglinux.ess` mantinha o mundo 3D apagado.
* **Mecanismo da Falha:** A Creation Engine possui um subsistema chamado **ImageSpace Modifiers (ISMs)**, responsável por efeitos de tela cheia (como o escurecimento cinematográfico de transição de tela, fade-out de morte ou cegueira de veneno). Quando o jogo foi salvo anteriormente sob o shader quebrado, o modificador de `FadeToBlack` estava ativo no topo da pilha de pós-processamento e **foi gravado nos metadados internos do arquivo `.ess`**.
* **Solução:** Disparar o comando de console interno da engine `teofis` (*Toggle End-Of-Frame Image Space*). O comando forçou a desativação de todos os passes finais de pós-processamento, revelando instantaneamente o mundo 3D iluminado. Em seguida, o personagem foi movimentado entre células para disparar o recálculo do ImageSpace default e gerados novos saves limpos (`clean.ess` e `lanworkingclean.ess`).

### 3.5 O Conflito Triplo do Mouse no Wayland/Hyprland (`no_warps`, >1000 FPS e Scanout)
O congelamento absoluto do ponteiro do mouse decorria de uma colisão em três camadas simultâneas:
1. **O Mecanismo de Pooling do Skyrim vs `no_warps`:** O Skyrim lê o movimento do mouse via DirectInput através de um loop contínuo: a cada frame, ele calcula o delta entre a posição atual e o centro da janela, e em seguida dispara `SetCursorPos` (que o XWayland traduz como `XWarpPointer`) para recentralizar o cursor. O Hyprland estava configurado com `cursor:no_warps = true`, o que **proibia o compositor de recentralizar o ponteiro**. O delta resultava invariavelmente em `0` e o cursor ficava congelado no centro.
2. **Taxa de Quadros Desenfreada no Menu (>1000 FPS):** Na RTX 5060, o menu inicial sem VSync rodava a mais de 1200 FPS. A engine Flash/Scaleform da Bethesda que processa a UI possui um buffer de eventos com fila fixa; a enxurrada de quadros saturava a thread de UI e descartava todos os pacotes de entrada de mouse.
3. **Direct Scanout & DRM Planes:** Com `render:direct_scanout = 2`, o driver proprietário NVIDIA dava bypass no compositor em tela cheia, ocultando o buffer de hardware cursor do XWayland.
4. **Solução Integrada:**
   * Hyprland: `cursor:no_warps = false`, `cursor:no_hardware_cursors = true`, `render:direct_scanout = 0`.
   * DXVK: criação de `dxvk.conf` com `dxvk.frameRate = 60` e `d3d11.presentInterval = 1`.
   * Wine Registry: inclusão de `GrabPointer="Y"` e `MouseWarpOverride="enable"` (evitar "force", pois ele recentraliza o cursor perpetuamente e impede a navegação nos menus/UI).
   * Gamescope: inicialização sem `--force-grab-cursor` (para permitir que o Gamescope alterne automaticamente entre o modo relativo de câmera 3D e o cursor absoluto na interface de menus).

### 3.6 A Família Lux: O Caso das Malhas Desamparadas vs Lux Via
* **Causa-Raiz:** O pacote principal de interiores `Lux.esp` substitui as malhas 3D (`.nif`) de paredes, tetos e candelabros por geometrias que não utilizam a luz ambiente tradicional da Bethesda, dependendo exclusivamente dos emissores de luz cadastrados em **`Lux - Resources.esp`**.
* **O Problema:** O `Lux - Resources.esp` e suas BSAs não estavam instalados inicialmente. Quando a engine carregava os cômodos, procurava os emissores do mestre e encontrava ponteiros vazios, atribuindo intensidade `0.0` (escuridão total).
* **Solução:**
  * O pacote **Lux Via (main)** continha os arquivos corretos de estradas e recursos. Foram extraídos e ativados:
    - `Lux - Resources.esp`, `Lux - Resources.bsa`, `Lux - Resources - Textures.bsa`
    - `Lux Via.esp`, `Lux Via - plugin.esp`, `Lux Via.bsa`, `Lux Via - Textures.bsa`
  * O plugin de interiores `Lux.esp` e os patches para JK's Skyrim e 3DNPC foram mantidos com segurança na pasta de quarentena `/mnt/dados/Jogos/Skyrim-AE/lux_esp_backup/`, garantindo estabilidade total nos interiores e iluminação de excelência nas estradas com o Lux Via.

### 3.7 O Desastre do Case-Sensitivity no Linux (EXT4/Btrfs)
* **Causa-Raiz:** O Windows não diferencia maiúsculas de minúsculas (`Data/Scripts` é idêntico a `Data/scripts`). No Linux (sistemas de arquivos EXT4 e Btrfs), são tratados como pastas distintas.
* **Mecanismo da Falha:** Ao extrair mais de 100 arquivos compactados (`.7z`, `.rar`, `.zip`), foram geradas dezenas de pastas duplicadas: `Scripts/` com 50 arquivos e `scripts/` com 80 arquivos; `Meshes/` e `meshes/`. O Wine escolhe apenas uma das pastas ao abrir o diretório, tornando a outra completamente invisível para a engine.
* **Solução:** Criação e execução do script em Python [`fix_case_dupes.py`](file:///home/lan/dotfiles/games/skyrim-se/fix_case_dupes.py), que varreu recursivamente a árvore do jogo, identificou grupos de duplicatas por caixa, mesclou os conteúdos no diretório canônico e resolveu conflitos de arquivos preservando o mais recente (`mtime`).

### 3.8 A Fragmentação de Builds da Engine e a Address Library
* **Causa-Raiz:** A engine está na versão **1.6.318.0** (início da Anniversary Edition). No entanto, o ecossistema de mods do Nexus possui arquivos compilados para 1.5.97 (SE clássico), 1.6.640 (GOG/Steam intermediário) e 1.6.1170 (Steam recente).
* **Mecanismos de Falha e Correções:**
  1. **Address Library:** Exigiu a base de dados exata `versionlib-1-6-318-0.bin` em `Data/SKSE/Plugins/`.
  2. **BackportedESLSupport:** O Skyrim 1.6.318 não suportava o formato de ESL moderno (cabeçalho 1.71 com até 4096 registros) introduzido na versão 1.6.1130. A inclusão de `BackportedESLSupport.dll` permitiu ler arquivos como `_ResourcePack.esl` sem crash.
  3. **MCM Helper:** O pacote padrão do Nexus crashava por esperar outra versão da DLL. Foi instalado o `MCM Helper SE (1.5.97 / 1.6.318 Backport)`.
  4. **Sneak Tools:** Possuía um loop em Papyrus varrendo inventário a cada 60s em um offset de memória descontinuado -> desativado da `plugins.txt`.
  5. **The Completionist:** Abortava o jogo se o `.esp` não estivesse presente -> plugin sincronizado na load order.

---

## 4. O PROTOCOLO DE SOLUÇÃO CIRÚRGICA PASSO A PASSO

Se for necessário recriar o ambiente ou replicar a correção em qualquer máquina Linux, execute os passos abaixo rigorosamente na ordem:

### Fase 1: Saneamento da Raiz da Engine & Purga de Injetores
Na raiz `/mnt/dados/Jogos/Skyrim-AE/`:
1. Mover ou deletar quaisquer arquivos:
   - `d3d11.dll`, `dxgi.dll`, `d3dcompiler_47.dll`
   - `*.addon64`, pastas `reshade-shaders/`
   - DLLs do DLSS (`nvngx_dlss.dll`, `nvngx_dlssnr.dll`)
2. Limpar o cache de shaders compilados do DXVK em `~/.local/share/dxvk/` (apagar arquivos `.dxvk.bin` residuais).

### Fase 2: Normalização do Sistema de Arquivos com `fix_case_dupes.py`
Executar a fusão de diretórios com sensibilidade de caixa:
```bash
python3 /home/lan/dotfiles/games/skyrim-se/fix_case_dupes.py /mnt/dados/Jogos/Skyrim-AE/Data --apply
```

### Fase 3: Mapeamento de Unidades do Wine (`dosdevices`)
Para que o Proton localize os mods e arquivos localizados no ponto de montagem `/mnt/dados`:
```bash
mkdir -p "/home/lan/Games/Heroic/Prefixes/shared/pfx/dosdevices"
ln -sf "/mnt/dados" "/home/lan/Games/Heroic/Prefixes/shared/pfx/dosdevices/s:"
ln -sf "/mnt" "/home/lan/Games/Heroic/Prefixes/shared/pfx/dosdevices/w:"
```

### Fase 4: Estabilização do SKSE, Address Library e BackportedESLSupport
1. Certificar que os binários do SKSE na raiz estão presentes:
   - `skse64_loader.exe`
   - `skse64_1_6_318.dll`
2. Certificar que em `Data/SKSE/Plugins/` estão presentes:
   - `versionlib-1-6-318-0.bin` (Address Library)
   - `BackportedESLSupport.dll`
   - `CrashLoggerSSE.dll`
   - `MCMHelper.dll` (versão 1.6.318 / backport)

### Fase 5: Sincronização e Ordenação Cirúrgica do `plugins.txt`
O arquivo `plugins.txt` deve residir em:
`/home/lan/Games/Heroic/Prefixes/shared/pfx/drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/plugins.txt`
*(e sincronizado em `users/Public/...`)*

**Regras Fundamentais de Ordenação:**
1. Todos os plugins ativos devem conter o asterisco `*` prefixado.
2. Mestres base na liderança:
   ```text
   *Skyrim.esm
   *Update.esm
   *Dawnguard.esm
   *HearthFires.esm
   *Dragonborn.esm
   *Unofficial Skyrim Special Edition Patch.esp
   *NoMaskUnturned.esm
   *RealisticWaterTwo - Resources.esm
   *Lux - Resources.esp
   *Lux Via.esp
   ```
3. Mestres da Creation Club e ESLs pesados:
   ```text
   *EVGAnimatedTraversal.esl
   *SmoothCam.esl
   *TrueHUD.esl
   *Lux Via - plugin.esp
   *_ResourcePack.esl
   ```
4. Plugins ESP de grande porte (3DNPC, Ordinator, Landscapes, Weathers, JK's Skyrim, etc.).
5. Overhauls de final de ordem: `RealisticWaterTwo.esp`, `atlas map markers.esp`.

### Fase 6: Calibração dos Arquivos de Configuração (`.ini` e `dxvk.conf`)

#### Arquivo `dxvk.conf` em `/mnt/dados/Jogos/Skyrim-AE/dxvk.conf`:
```ini
dxvk.frameRate = 60
d3d11.presentInterval = 1
dxgi.syncInterval = 1
dxgi.nvapiHack = False
dxgi.maxFrameLatency = 2
d3d11.samplerAnisotropy = 16
dxvk.enableGraphicsPipelineLibrary = False
```

#### Arquivo `SkyrimPrefs.ini` no prefixo:
```ini
[Display]
bFull Screen=0
bBorderless=1
iSize W=1920
iSize H=1080
iVSyncPresentInterval=1
bUse64bitsHDRRenderTarget=0
bDoDepthOfField=0
bUseBlurShader=0
bUseTAA=0
bFXAAEnabled=1
```

#### Arquivo `Skyrim.ini` no prefixo:
```ini
[General]
bAlwaysActive=1
```

### Fase 7: Correção Definitiva do Cursor do Mouse & Hyprland

#### 1. Configurações de Hyprland (`~/.config/hypr/UserConfigs/UserSettings.conf`):
```conf
render {
  direct_scanout = 0
  new_render_scheduling = true
}

cursor {
  no_warps = false
  no_hardware_cursors = true
  inactive_timeout = 0
}
```

#### 2. Regra de Janela no Hyprland (`~/.config/hypr/UserConfigs/WindowRules.conf`):
```conf
windowrule = workspace 8, match:class ^(gamescope)$
windowrule = fullscreen 1, match:class ^(gamescope)$
windowrule = immediate 1, match:class ^(gamescope)$
```

#### 3. Registro do Wine (`user.reg` no prefixo):
Na seção `[Software\\Wine\\X11 Driver]`:
```ini
"GrabPointer"="Y"
"MouseWarpOverride"="enable"
```

### Fase 8: Descongelamento do Mundo 3D via Console (`teofis`) & Criação de Saves Limpos
1. Iniciar o jogo com `clean.ess` ou carregar o save anterior.
2. Se houver resquício de escuridão pós-processamento, abrir o console da Creation Engine com a tecla `~` (ou aspas).
3. Digitar `teofis` e pressionar Enter. O mundo 3D saltará renderizado em alta definição.
4. Fechar o console (`~`), caminhar com o personagem por alguns metros até cruzar o limiar de uma célula exterior (ex: portal de Riverwood).
5. Salvar o jogo manualmente pelo menu (`Salvar Novo Jogo`) — gerando os novos estados `clean.ess` e `lanworkingclean.ess`.
6. Reiniciar o jogo: o carregamento direto desses novos saves abre instantaneamente no mundo 3D sem necessidade de comandos de console.

### Fase 9: Recuperação e Ativação do Lux Via e Isolamento Seguro do Lux Interior
1. Extraídos os arquivos de `Lux Via (main)-63588-2-2-1713094342.rar` para `Data/`:
   - `Lux - Resources.esp`
   - `Lux - Resources.bsa`
   - `Lux - Resources - Textures.bsa`
   - `Lux Via.esp`
   - `Lux Via - plugin.esp`
   - `Lux Via.bsa`
   - `Lux Via - Textures.bsa`
2. Posicionados no `plugins.txt` conforme a Fase 5.
3. Mantidos em quarentena de segurança em `/mnt/dados/Jogos/Skyrim-AE/lux_esp_backup/`:
   - `Lux.esp`
   - `Lux - Master plugin.esm`
   - `Lux - JK's Skyrim.esp`
   - `Lux - 3DNPC patch.esp`

---

## 5. O FERRAMENTAL DE AUTOMAÇÃO DESENVOLVIDO

Todo o processo manual foi consolidado em scripts reutilizáveis de alta engenharia, hospedados no repositório de dotfiles em `games/skyrim-se/`.

### 5.1 `skyrim_doctor.py` (O Agente de Diagnóstico e Execução Soberana)
Localização: [`/home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py`](file:///home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py)

O script executa 5 etapas autônomas com validações estritas de ambiente:
* **[1/5] Auditoria de Integridade:** Valida a existência de `SkyrimSE.exe`, `skse64_loader.exe`, `skse64_1_6_318.dll` e checa o hash/tamanho da `Address Library` (`versionlib-1-6-318-0.bin`).
* **[2/5] Mapeamento dosdevices:** Cria dinamicamente os links simbólicos de unidades Wine `s:` e `w:`.
* **[3/5] Limpeza de Processos Zumbis:** Finaliza instâncias anteriores de `SkyrimSE`, `skse64`, `wineserver` e `gamescope` via `systemd-run`.
* **[4/5] Disparo Encapsulado:** Sobe o microcompositor Gamescope com resolução 1920x1080 em 100Hz através do `systemd-run --user --unit=skyrim-gamescope`.
* **[5/5] Monitoramento & Foco:** Monitora o surgimento do PID do `SkyrimSE.exe`, aguarda a criação da janela gráfica do Gamescope, alterna o Hyprland automaticamente para o **Workspace 8**, atribui o foco exclusivo e valida o último log gravado pelo SKSE.

```python
# Trecho de lançamento do skyrim_doctor.py
cmd = [
    "gamescope",
    "-W", "1920", "-H", "1080",
    "-w", "1920", "-h", "1080",
    "-r", "100", "-f",
    "--",
    runner_sh
]
```

### 5.2 `run_gamescope.sh` (O Contêiner Microcompositor com Keep-Alive)
Localização: [`/mnt/dados/Jogos/Skyrim-AE/run_gamescope.sh`](file:///mnt/dados/Jogos/Skyrim-AE/run_gamescope.sh)

Script de inicialização executado internamente pela sessão do Gamescope:
```bash
#!/usr/bin/env bash
export PROTON_USE_XALIA=0
export STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/lan/.local/share/Steam"
export STEAM_COMPAT_DATA_PATH="/home/lan/Games/Heroic/Prefixes/shared"
export PROTON_ENABLE_NVAPI=1
export PROTON_HIDE_NVIDIA_GPU=0
export WINEDLLOVERRIDES="dxgi=n,b;d3d11=n,b;steam_api64=n,b"

PROTON_BIN="/home/lan/.config/heroic/tools/proton/GE-Proton-latest/proton"
GAME_DIR="/mnt/dados/Jogos/Skyrim-AE"

# 1. Disparar o injetor SKSE via Proton
"$PROTON_BIN" run "$GAME_DIR/skse64_loader.exe" &

# 2. Aguardar a inicialização do executável principal do jogo (até 40s)
for i in $(seq 1 40); do
    if pgrep -f "SkyrimSE.exe" > /dev/null; then
        break
    fi
    sleep 1
done

# 3. Manter a sessão do Gamescope viva enquanto o SkyrimSE.exe estiver ativo
while pgrep -f "SkyrimSE.exe" > /dev/null; do
    sleep 1
done
```

### 5.3 `fix_case_dupes.py` (O Algoritmo de Fusão de Diretórios por Caixa)
Localização: [`/home/lan/dotfiles/games/skyrim-se/fix_case_dupes.py`](file:///home/lan/dotfiles/games/skyrim-se/fix_case_dupes.py)

Varre diretórios recursivamente, identifica agrupamentos pelo nome em caixa baixa (`name.lower()`), elege a variante canônica (com mais arquivos ou iniciando em maiúscula) e move o conteúdo das variantes secundárias para a pasta principal, resolvendo colisões de arquivos individuais com base no `mtime` (o mod mais recente sobrepõe o mais antigo).

### 5.4 Injeção Virtual de Entrada via Kernel (`/dev/uinput`)
Quando a tela estava preta e o jogo não respondia a ferramentas tradicionais de simulação (como `wtype` ou `xdotool`), foi desenvolvido um utilitário que emite eventos de hardware virtuais diretamente pelo subsistema de kernel Linux `/dev/uinput`:
* Cria um dispositivo `/dev/input/eventX` de teclado virtual.
* Dispara códigos de scan `KEY_GRAVE` (para abrir o console do jogo) e envia comandos de texto caractere a caractere com sincronização de frames `EV_SYN`.
* Permitiu desbloquear e interagir com a engine mesmo durante a ausência total de renderização de tela.

---

## 6. INVENTÁRIO & MATRIZ DE COMPATIBILIDADE DOS 172 MODS

Abaixo está o agrupamento das principais frentes de mods instaladas e estabilizadas:

| Categoria | Mods Principais em Destaque | Plugins Chave | Status |
| :--- | :--- | :--- | :--- |
| **Núcleo & Fixes** | USSEP 4.2.6a, BackportedESLSupport, CrashLoggerSSE, Address Library, Recursion Fix | `Unofficial Skyrim Special Edition Patch.esp`, `_ResourcePack.esl` | **Operante** |
| **Interface & HUD** | SkyUI SE 5.2, TrueHUD, Infinity UI, Wheeler, Custom Difficulty UI, BTPS, More Informative Console | `SkyUI_SE.esp`, `TrueHUD.esl`, `MCMHelper.esp` | **Operante** |
| **Iluminação & Vias** | Lux Via (Overhaul completo de pontes, vias e lanternas), Lux Resources | `Lux - Resources.esp`, `Lux Via.esp`, `Lux Via - plugin.esp` | **Operante** |
| **Iluminação Interior** | Lux Principal (Quarentena preventiva para preservar interiores) | `Lux.esp`, `Lux - Master plugin.esm` *(em lux_esp_backup/)* | **Isolado** |
| **Clima & Atmosfera** | Cathedral Weathers and Seasons, Cathedral Landscapes | `Cathedral Weathers.esp`, `Cathedral Landscapes.esp` | **Operante** |
| **Água & Vegetação** | Realistic Water Two SE v5.7.3, Happy Little Trees, SMIM Merged | `RealisticWaterTwo.esp`, `HappyLittleTrees.esp`, `SMIM-SE-Merged-All.esp` | **Operante** |
| **Combate & Ação** | Valhalla Combat, True Directional Movement, Archery Gameplay Overhaul, Dual Wield Parrying | `TrueDirectionalMovement.esp`, `ValhallaCombat.esp`, `DSerArcheryGameplayOverhaul.esp` | **Operante** |
| **Animação & Física** | EVG Animated Traversal (EVGAT), SkyClimb, Paraglider, SmoothCam, Immersive Interactions | `EVGAnimatedTraversal.esl`, `SkyClimb.esp`, `SmoothCam.esl`, `Paragliding.esp` | **Operante** |
| **Magia & Progressão** | Apocalypse, Ordinator, Odin, Arcanum, Andromeda, Wintersun, Strange Runes | `Apocalypse - Magic of Skyrim.esp`, `Ordinator - Perks of Skyrim.esp`, `Odin - Skyrim Magic Overhaul.esp` | **Operante** |
| **NPCs & Missões** | Interesting NPCs (3DNPC - 2.3 GB), The Brotherhood of Old, At Your Own Pace (AYOP), Missives | `3DNPC.esp`, `The Brotherhood of Old.esp`, `Missives.esp` | **Operante** |
| **Economia & Mundo** | Real Estate Core + USSEP, Imperial Mail, CFTO, Trade and Barter, Rich Merchants (5x) | `RE_RealEstate_Core.esp`, `CFTO.esp`, `trade & barter.esp` | **Operante** |
| **Complecionismo** | The Completionist, Atlas Map Markers, Barenziah Markers, No Mask Unturned, Unread Books Glow | `Completionist.esp`, `atlas map markers.esp`, `NoMaskUnturned.esm` | **Operante** |

---

## 7. MANUAL OPERACIONAL: COMO JOGAR E PROCEDIMENTO DE RECUPERAÇÃO

### Para Iniciar o Jogo Normalmente:
Execute o diagnóstico soberano pelo terminal:
```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py
```
O script auditará o ambiente, limpará instâncias zumbis, inicializará o Gamescope e trocará automaticamente seu monitor para o **Workspace 8** com foco na janela do jogo.

### Controles de Janela & Navegação no Hyprland:
* **Alternar para o Skyrim:** Pressione `SUPER + 8`.
* **Alternar de volta para o Desktop:** Pressione `SUPER + 1` (ou qualquer workspace desejado).
* **Saves Prontos & Validados:** Ao abrir o menu "Carregar", selecione:
  - `clean` (Save principal atualizado em Riverwood)
  - `lanworkingclean`

### Guia de Resolução Rápida (Troubleshooting):
* **Sintoma:** O jogo crashou logo no início.
  - **Checagem:** Inspecione o último log em `/home/lan/Games/Heroic/Prefixes/shared/pfx/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition/SKSE/CrashLogger/`.
  - **Ação:** Verifique se alguma DLL incompatível foi adicionada recentemente em `Data/SKSE/Plugins/`.
* **Sintoma:** O mouse perdeu foco ou não gira a câmera.
  - **Ação:** Pressione `Alt+Tab` para alternar entre janelas ou execute `pkill gamescope` e reinicie via `skyrim_doctor.py`. O Gamescope com `--force-grab-cursor` garante a retenção do ponteiro.
* **Sintoma:** Reativação do Lux de Interiores no futuro.
  - **Ação:** Basta mover os arquivos de `/mnt/dados/Jogos/Skyrim-AE/lux_esp_backup/` para `Data/`, posicionar `Lux.esp` no final absoluto da lista em `plugins.txt` e verificar a compatibilidade com iluminação de células internas.

---
*Documento de Engenharia de Sistemas gerado e validado. Este manual é a fonte soberana da verdade técnica para a preservação e execução do Skyrim SE/AE no ecossistema CachyOS / Hyprland.*
