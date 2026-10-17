# 🪟 Guia Rápido Pós-Instalação: Windows 11, Partição D: e Skyrim Master (202 Mods)

> **Este guia foi salvo para acesso imediato no seu disco local e na nuvem:**
> - No Windows: `D:\GUIA_WINDOWS_E_SKYRIM.html` (Abra no navegador com 2 cliques)
> - No Google Drive: `gdrive:GUIA_WINDOWS_E_SKYRIM.md` (Acesse pelo celular ou PC)
> - No GitHub: `dotfiles/windows/GUIA_POS_INSTALACAO_WINDOWS_E_SKYRIM.md`

---

## ⚡ Sumário das Etapas
1. [Passo 1: Montar a Partição D:\ com o WinBtrfs](#-passo-1-fazer-o-windows-enxergar-a-partição-com-os-mods)
2. [Passo 2: Instalar o Skyrim no Windows Nativo](#-passo-2-instalar-o-skyrim-no-windows)
3. [Passo 3: Carregar os 202 Mods no Mod Organizer 2 (MO2)](#-passo-3-gerenciar-e-ativar-os-202-mods-com-o-mod-organizer-2-mo2)
4. [Passo 4: Restaurar os 12 Saves de Personagem](#-passo-4-restaurar-seus-saves-de-personagem)
5. [Passo 5: Instalar Programas em Lote e GlazeWM](#-passo-5-setup-do-resto-do-windows-programas--tiling-wm)

---

## 💽 Passo 1: Fazer o Windows enxergar a partição com os Mods

A partição de dados de 203 GB (`/mnt/dados`) contém o instalador (22.6 GB) e os 202 mods (19.3 GB) em formato BTRFS. Para montá-la como **Disco Local (D:)** no Windows:

1. Baixe o driver gratuito de código aberto **WinBtrfs**:
   - **Link Direto**: [btrfs-1.10.zip (GitHub Oficial)](https://github.com/maharmstone/btrfs/releases/download/v1.10/btrfs-1.10.zip)
   - *(Também está salvo no seu Google Drive em `06_Backups_ISOs_e_Sistemas/06.1_Instaladores_e_APKs/btrfs-1.10.zip`)*
2. Extraia o arquivo `btrfs-1.10.zip`.
3. Clique com o botão direito no arquivo **`btrfs.inf`** e selecione **"Instalar"** (no Windows 11: clique em *Mostrar mais opções ➔ Instalar*).
4. Reinicie o computador.
5. **Resultado**: A partição aparecerá instantaneamente no Windows Explorer como **Disco Local (D:)** com velocidade máxima do NVMe (3.500 MB/s).

---

## 🎮 Passo 2: Instalar o Skyrim no Windows

1. Abra a pasta do instalador no Windows Explorer:
   ```text
   D:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\05_Instaladores\Skyrim_Anniversary_Edition_FitGirl_Repack
   ```
2. Dê dois cliques em **`setup.exe`**.
3. **Dica de Ouro**: Instale em uma pasta fora de `Program Files` para o Windows não restringir permissões de mods:
   - Caminho recomendado: `C:\Games\Skyrim Special Edition` (ou `D:\Games\Skyrim Special Edition`).
4. Marque as opções para instalar o DirectX e os pacotes Visual C++ Redistributables inclusos no setup.
5. **Zero Bug de Mouse**: No Windows nativo, o DirectInput/Raw Input comunica diretamente com o hardware — o cursor funciona 100% fluido em todos os menus.

---

## 🧩 Passo 3: Gerenciar e Ativar os 202 Mods com o Mod Organizer 2 (MO2)

1. Baixe o instalador portátil do **Mod Organizer 2**:
   - [Página de Releases do MO2 no GitHub](https://github.com/ModOrganizer2/modorganizer/releases) (ou no Nexus Mods).
2. Extraia/instale em `C:\Games\MO2` (ou `D:\Games\MO2`).
3. Ao abrir o MO2 pela primeira vez:
   - Escolha **Portable Instance**.
   - Selecione o jogo **Skyrim Special Edition**.
4. **Conectar os 202 Mods Instantaneamente**:
   - No MO2, clique no ícone de chave inglesa (**Settings**) ➔ aba **Paths**.
   - No campo **Directory for downloads**, selecione a pasta:
     ```text
     D:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\02_Mods_e_Patches\Skyrim_AE
     ```
   - *Pronto! Todos os 202 arquivos `.7z`/`.zip` aparecerão na aba lateral **Downloads** do MO2 prontos para instalação com duplo clique.*
5. **Ordem de Instalação Recomendada**:
   Abra o arquivo `D:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\02_Mods_e_Patches\Skyrim_AE\ORDEM_E_MANIFESTO_MODS.md` e ative pelas 6 camadas:
   - **1. Core & Engine**: SKSE64, Address Library, Engine Fixes, Scrambled Bugs, PapyrusExtender, CrashLogger.
   - **2. Interface & HUD**: SkyUI, TrueHUD, dMenu, Infinity UI, Dear Diary Dark Mode.
   - **3. Gráficos & Texturas**: Skyland AIO (6.6 GB), SMIM, Lux, Lux Via, Cathedral Weathers, Happy Little Trees, Realistic Water Two.
   - **4. Jogabilidade & Magias**: Ordinator, Apocalypse, Odin, Summermyst, Wintersun, Andromeda, Valhalla Combat.
   - **5. Câmera & Animações**: SmoothCam, True Directional Movement (TDM), TK Dodge, Open Animation Replacer (OAR).
   - **6. NPCs & Quests**: Interesting NPCs (3DNPC - 2.2 GB), Serana Dialogue Add-On (SDA), JK's Skyrim, Bijin NPCs.

---

## 💾 Passo 4: Restaurar seus Saves de Personagem

Seus 12 arquivos de save (`.ess` e `.skse`) foram resgatados do Linux e estão em:
```text
D:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\01_Saves_e_Backups\Skyrim_Saves
```
1. No Windows, pressione `Win + R`, cole o caminho abaixo e dê Enter:
   ```text
   %USERPROFILE%\Documents\My Games\Skyrim Special Edition\Saves
   ```
2. Copie todos os arquivos `.ess` e `.skse` da pasta de backup para dentro dessa pasta.
3. Inicie o jogo pelo MO2 (selecionando **SKSE** no menu superior direito do MO2).
4. No menu principal do Skyrim, clique em **Load Game** e seu personagem (`lanworkingclean` / `Save2_...`) estará pronto para continuar a jornada.

---

## ⚡ Passo 5: Setup do Resto do Windows (Programas + Tiling WM)

No seu disco `D:\` (ou clonando seu repositório `dotfiles`), abra o PowerShell como Administrador e execute:
1. `D:\dotfiles\windows\scripts\Instalar-Programas-PC.bat`:
   - Escolha a opção `[1]` para instalar silenciosamente via Winget: Chrome, Brave, VS Code, Git, Python, NanaZip, Steam, Ludusavi, Discord, etc.
2. `D:\dotfiles\windows\scripts\Configurar-GlazeWM.bat`:
   - Configura o **GlazeWM** com a barra Zebar para você usar os mesmos atalhos do Hyprland no Windows (`Alt + H/J/K/L`).
