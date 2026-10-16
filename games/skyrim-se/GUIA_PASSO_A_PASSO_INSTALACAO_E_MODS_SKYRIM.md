# 🐉 GUIA DEFINITIVO: INSTALAÇÃO, DOWNLOAD VIA AB DOWNLOAD MANAGER & CONFIGURAÇÃO TOTAL DO SKYRIM NO LINUX

> **Ambiente Operacional Alvo:**  
> Arch Linux / CachyOS / EndeavourOS | Hyprland (Wayland) | GPU NVIDIA RTX Series (RTX 4060/5060)  
> Skyrim Anniversary Edition (`1.6.318.0`) | Heroic Games Launcher + GE-Proton + Gamescope  
> Modpack: 171 plugins ativos, 31 DLLs SKSE em C++ nativo, iluminação Lux Via, combate Valhalla e interface moderna.

---

## 📑 ÍNDICE

1. [Visão Geral & Métodos de Instalação](#1-visão-geral--métodos-de-instalação)
2. [Pré-Requisitos do Sistema Operacional](#2-pré-requisitos-do-sistema-operacional)
3. [Topologia de Diretórios Recomendada](#3-topologia-de-diretórios-recomendada)
4. [Download em Massa dos Mods com o AB Download Manager](#4-download-em-massa-dos-mods-com-o-ab-download-manager)
5. [Instalação e Extração dos Mods em Data/](#5-instalação-e-extração-dos-mods-em-data)
6. [Sanitização Crítica de Sensibilidade de Caixa (Case-Sensitivity no EXT4/Btrfs)](#6-sanitização-crítica-de-sensibilidade-de-caixa-case-sensitivity-no-ext4btrfs)
7. [Configuração do Motor Gráfico, DXVK, Arquivos .INI e Wine](#7-configuração-do-motor-gráfico-dxvk-arquivos-ini-e-wine)
8. [Ordem de Carregamento Canônica dos 171 Plugins (`plugins.txt`)](#8-ordem-de-carregamento-canônica-dos-171-plugins-pluginstxt)
9. [Integração com Hyprland & Microcompositor Gamescope](#9-integração-com-hyprland--microcompositor-gamescope)
10. [Lançamento e Teste em Tempo Real](#10-lançamento-e-teste-em-tempo-real)
11. [Cheat Sheet: Automação Total em 1 Comando](#11-cheat-sheet-automação-total-em-1-comando)

---

## 1. VISÃO GERAL & MÉTODOS DE INSTALAÇÃO

Este manual documenta o processo de ponta a ponta para baixar, instalar, sanitizar e rodar o Skyrim SE/AE no Linux sem atrito, oferecendo duas vias de execução:

1. **Via Totalmente Automatizada (Recomendada):** Utilizando o script mestre [`skyrim_master_installer.py`](file:///home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py), que executa todas as etapas (auditoria, validação, extração, sanitização, geração de load order e calibração de INIs) de forma autônoma.
2. **Via Manual Passo a Passo:** Detalhada neste documento para auditoria, inspeção ou reconstrução cirúrgica de etapas individuais.

---

## 2. PRÉ-REQUISITOS DO SISTEMA OPERACIONAL

Antes de iniciar, instale os utilitários de sistema obrigatórios:

```bash
# 1. Descompactador universal de alta performance
sudo pacman -S --needed p7zip jq

# 2. Microcompositor Gamescope (isolamento Wayland e captura de cursor)
sudo pacman -S --needed gamescope

# 3. Gerenciador de Downloads AB Download Manager (Interface gráfica e CLI)
# Se não estiver instalado, instale via AUR:
yay -S --needed ab-download-manager
```

Valide se o CLI do AB Download Manager está presente:
```bash
/opt/abdownloadmanager/bin/ABDownloadManagerCli --version
```

---

## 3. TOPOLOGIA DE DIRETÓRIOS RECOMENDADA

Para evitar caminhos quebrados e garantir que o Wine e os scripts localizem os arquivos, a estrutura padrão utilizada é:

```text
/mnt/dados/Jogos/Skyrim-AE/
├── SkyrimSE.exe               # Executável oficial da engine
├── skse64_loader.exe          # Injetor do Skyrim Script Extender
├── skse64_1_6_318.dll         # Binário de runtime do SKSE
├── dxvk.conf                  # Calibração de framerate e swapchain Vulkan
├── run_gamescope.sh           # Wrapper de execução encapsulado no Gamescope
├── Data/                      # Diretório de malhas, texturas, scripts e plugins
├── Downloads_Mods/            # Arquivo canônico dos 142 mods compactados (.zip, .7z, .rar)
└── lux_esp_backup/            # Quarentena segura do Lux de interiores

/home/lan/Games/Heroic/Prefixes/shared/   # Prefixo Wine do Heroic Games Launcher
└── pfx/
    ├── dosdevices/
    │   ├── s: -> /mnt/dados
    │   └── w: -> /mnt
    └── drive_c/users/steamuser/
        ├── AppData/Local/Skyrim Special Edition/plugins.txt
        └── Documents/My Games/Skyrim Special Edition/
            ├── Skyrim.ini
            ├── SkyrimPrefs.ini
            └── SKSE/
```

---

## 4. DOWNLOAD EM MASSA DOS MODS COM O AB DOWNLOAD MANAGER

O ecossistema conta com **142 arquivos de mods** mapeados individualmente no arquivo de manifesto:
[`skyrim_mods_manifest.json`](file:///home/lan/dotfiles/games/skyrim-se/skyrim_mods_manifest.json)

Cada entrada possui o nome limpo, nome exato do arquivo compactado, ID do Nexus Mods, tamanho em megabytes e link direto para a página do Nexus:

```json
{
  "name": "Cathedral Landscapes",
  "filename": "Landscapes - Cathedral Concept-21954-3-0-3-1708230043.7z",
  "nexus_id": 21954,
  "url": "https://www.nexusmods.com/skyrimspecialedition/mods/21954",
  "size_mb": 941.03
}
```

### 4.1 Validação dos Arquivos Já Baixados
Para checar quais arquivos já estão presentes na sua máquina e quais estão pendentes:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py check-downloads
```

O script varrerá:
- `/mnt/dados/Jogos/Skyrim-AE/Downloads_Mods`
- `/mnt/dados/00_Inbox_Triagem`
- `~/downloads`

Se todos os 142 arquivos estiverem baixados, você verá:
```text
=== [ 2. VALIDAÇÃO DOS ARQUIVOS DE MODS BAIXADOS ] ===
  ✓ 142 de 142 mods disponíveis localmente!
```

### 4.2 Enfileirando Downloads no AB Download Manager

Se você estiver configurando em uma máquina nova ou com arquivos ausentes:

#### Opção A: Enfileiramento Automático via CLI do AB Download Manager
O AB Download Manager CLI permite disparar downloads multithread diretamente pela linha de comando:

```bash
/opt/abdownloadmanager/bin/ABDownloadManagerCli download add http \
  --folder="/mnt/dados/Jogos/Skyrim-AE/Downloads_Mods" \
  --name="NomeDoArquivo.7z" \
  --link="<URL_DIRETA_OU_CDN>" \
  --start
```

O comando acima adiciona o item instantaneamente à fila do gerenciador, aloca múltiplas conexões paralelas para velocidade máxima e salva direto na pasta de mods.

#### Opção B: Monitoramento Gráfico
Abra a interface gráfica do AB Download Manager pelo launcher do sistema (`SUPER` -> digite `AB Download Manager`) ou pelo terminal:
```bash
/opt/abdownloadmanager/bin/ABDownloadManager &
```
Configure nas preferências do aplicativo o diretório de download padrão para `/mnt/dados/Jogos/Skyrim-AE/Downloads_Mods`.

---

## 5. INSTALAÇÃO E EXTRAÇÃO DOS MODS EM `Data/`

### 5.1 Execução Automatizada
Para extrair todos os mods compactados em ordem, preservando BSAs, scripts compilados, DLLs e texturas:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py install
```

### 5.2 O Caso Especial do Mod Lux Via (Tratamento de FOMOD)
Muitos mods vêm em formato FOMOD com subpastas de instalador que não devem ser despejadas brutas em `Data/`. O caso mais importante é o **Lux Via**:
* O arquivo `Lux Via (main)-63588-2-2-1713094342.rar` possui pastas como `00 Data/Lux Resources/No ENB Light/` e `00 Data/Lux Via/`.
* O instalador automatizado extrai cirurgicamente apenas os arquivos canônicos:
  - `Lux - Resources.esp`
  - `Lux - Resources.bsa`
  - `Lux - Resources - Textures.bsa`
  - `Lux Via.esp`
  - `Lux Via - plugin.esp`
  - `Lux Via.bsa`
  - `Lux Via - Textures.bsa`

### 5.3 Regra de Ouro: Isolamento do Lux de Interiores
O mod `Lux.esp` (iluminação de masmorras e casas) e seus patches para JK's Skyrim e 3DNPC **permanecem em quarentena** em:
`/mnt/dados/Jogos/Skyrim-AE/lux_esp_backup/`

> **Por quê?** Em sistemas Linux com DXVK, o Lux de interiores recalcula intensidades de luz em 0.0 sem ENB se houver qualquer divergência de malha interna, causando o bug da tela preta nos interiores. Mantê-lo em quarentena garante 100% de visibilidade nas casas e masmorras, enquanto o **Lux Via** cuida com primor das estradas e pontes de Tamriel.

---

## 6. SANITIZAÇÃO CRÍTICA DE SENSIBILIDADE DE CAIXA (CASE-SENSITIVITY NO EXT4/Btrfs)

No Windows (NTFS), `Data/Scripts/` e `Data/scripts/` são o mesmo diretório. No Linux (EXT4 e Btrfs), são duas pastas distintas. Mods descompactados criam pastas irmãs com caixas diferentes, e o Wine só enxerga uma delas, fazendo com que metade dos mods pareça "invisível".

Para normalizar toda a árvore de arquivos:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py sanitize
```

Este comando executa o algoritmo [`fix_case_dupes.py`](file:///home/lan/dotfiles/games/skyrim-se/fix_case_dupes.py), que:
1. Agrupa pastas pelo nome em minúsculo (`scripts`, `meshes`, `textures`, `skse`).
2. Elege o nome canônico.
3. Mescla todos os arquivos dentro do diretório principal.
4. Em caso de conflito de arquivos idênticos, preserva a versão mais recente (`mtime`).

---

## 7. CONFIGURAÇÃO DO MOTOR GRÁFICO, DXVK, ARQUIVOS .INI E WINE

Para aplicar todas as diretrizes anti-crash e anti-tela-preta de uma só vez:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py configure
```

### O que esta etapa calibra fisicamente na máquina:

#### 1. Unidades de Disco no Wine (`dosdevices`)
Cria os links simbólicos necessários no prefixo:
* `s:` -> `/mnt/dados`
* `w:` -> `/mnt`

#### 2. Limite de FPS e Sincronização no `dxvk.conf`
Localizado em `/mnt/dados/Jogos/Skyrim-AE/dxvk.conf`:
```ini
dxvk.frameRate = 60
d3d11.presentInterval = 1
dxgi.syncInterval = 1
dxgi.nvapiHack = False
dxgi.maxFrameLatency = 2
d3d11.samplerAnisotropy = 16
dxvk.enableGraphicsPipelineLibrary = False
```
*(Essencial: trava o menu e a gameplay em 60 FPS, impedindo que a RTX 5060 gere mais de 1000 FPS e sobrecarregue a thread de interface Flash/Scaleform da Bethesda).*

#### 3. Parâmetros Críticos no `SkyrimPrefs.ini`
Localizado no prefixo do usuário (`steamuser`):
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
> **ALERTA CRÍTICO:** `bUse64bitsHDRRenderTarget=0` é **MANDATÓRIO**. Se for 1, o swapchain FP16 do DXVK zera a iluminação e deixa a renderização 3D 100% preta com HUD visível.

#### 4. Modo Sempre Ativo no `Skyrim.ini`
```ini
[General]
bAlwaysActive=1
```
*(Garante que o áudio e a entrada continuem ativos ao alternar o foco para outros monitores ou janelas).*

#### 5. Captura de Ponteiro no Registro do Wine (`user.reg`)
Na chave `[Software\\Wine\\X11 Driver]`:
```ini
"GrabPointer"="Y"
"MouseWarpOverride"="force"
```

---

## 8. ORDEM DE CARREGAMENTO CANÔNICA DOS 171 PLUGINS (`plugins.txt`)

Para sincronizar a ordem exata testada e estável em todos os perfis do Proton:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py sync-plugins
```

O script atualiza simultaneamente:
- `drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/plugins.txt`
- `drive_c/users/Public/AppData/Local/Skyrim Special Edition/plugins.txt`

### Regras da Hierarquia da Load Order:
1. **Mestres Base da Engine:** `Skyrim.esm`, `Update.esm`, `Dawnguard.esm`, `HearthFires.esm`, `Dragonborn.esm`.
2. **Patch Principal & Recursos:** `Unofficial Skyrim Special Edition Patch.esp`, `RealisticWaterTwo - Resources.esm`.
3. **Mestre de Iluminação:** `Lux - Resources.esp` seguido de `Lux Via.esp`.
4. **Mestres Creation Club (.esm) & ESLs Pesados:** `EVGAnimatedTraversal.esl`, `SmoothCam.esl`, `TrueHUD.esl`, `Lux Via - plugin.esp`, `_ResourcePack.esl`.
5. **Plugins de Grande Escala:** `3DNPC.esp`, `Ordinator - Perks of Skyrim.esp`, `Cathedral Landscapes.esp`, `Cathedral Weathers.esp`, `JKs Skyrim.esp`.
6. **Interface, Combate e Mecânicas:** `SkyUI_SE.esp`, `MCMHelper.esp`, `ValhallaCombat.esp`, `TrueDirectionalMovement.esp`.
7. **Fechamento:** `RealisticWaterTwo.esp`, `atlas map markers.esp`.

---

## 9. INTEGRAÇÃO COM HYPRLAND & MICROCOMPOSITOR GAMESCOPE

### 9.1 Ajustes no Hyprland (`~/.config/hypr/UserConfigs/UserSettings.conf`)
Para garantir que o cursor do mouse não fique congelado no centro da tela e que a placa de vídeo não cause desync de plano DRM:

```conf
render {
  direct_scanout = 0           # Desativa bypass direto em tela cheia na NVIDIA
  new_render_scheduling = true
}

cursor {
  no_warps = false             # Permite que o jogo recentralize o ponteiro via SetCursorPos
  no_hardware_cursors = true   # Software cursors para não sumir no XWayland
  inactive_timeout = 0
}
```

### 9.2 Regra de Janela Dedicada (`~/.config/hypr/UserConfigs/WindowRules.conf`)
Fixa a janela do Skyrim no **Workspace 8**:

```conf
windowrule = workspace 8, match:class ^(gamescope)$
windowrule = fullscreen 1, match:class ^(gamescope)$
windowrule = immediate 1, match:class ^(gamescope)$
```

---

## 10. LANÇAMENTO E TESTE EM TEMPO REAL

Com tudo instalado e calibrado, inicie o jogo através do monitor de saúde soberano:

```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py
```

### O que o `skyrim_doctor.py` faz em tempo de execução:
1. Audita a presença dos binários e da `Address Library` (`versionlib-1-6-318-0.bin`).
2. Garante os links de `dosdevices`.
3. Limpa processos zumbis anteriores.
4. Lança o Gamescope encapsulado via `systemd-run --user`.
5. Monitora a subida do processo `SkyrimSE.exe`.
6. Alterna o Hyprland automaticamente para o **Workspace 8** e joga o foco na janela.

### Navegação:
* **Entrar no jogo:** `SUPER + 8`.
* **Voltar para o Desktop / Terminal:** `SUPER + 1` (ou qualquer workspace desejado).
* **Saves Limpos & Prontos:** Carregue `clean` ou `lanworkingclean`.

---

## 11. CHEAT SHEET: AUTOMAÇÃO TOTAL EM 1 COMANDO

Se você já possui os arquivos na pasta `Downloads_Mods` e deseja preparar a máquina completa do zero absoluto:

```bash
# Executa Auditoria -> Validação -> Instalação -> Sanitização -> Sync Plugins -> Configurações
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_master_installer.py all
```

E para iniciar a jogatina:
```bash
python3 /home/lan/dotfiles/games/skyrim-se/skyrim_doctor.py
```

---
*Manual homologado para o ecossistema CachyOS / Arch Linux com GPU NVIDIA RTX Série 50 e compositor Hyprland.*
