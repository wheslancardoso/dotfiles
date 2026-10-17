# 🪟 Guia Rápido Pós-Instalação: Windows 11, Dual Boot Perfeito, Partição D: e Skyrim Master (202 Mods)

> **Este guia foi salvo para acesso imediato no seu disco local e na nuvem:**
> - No Windows: `D:\GUIA_WINDOWS_E_SKYRIM.html` (Abra no navegador com 2 cliques)
> - No Google Drive: `gdrive:GUIA_WINDOWS_E_SKYRIM.md` (Acesse pelo celular ou PC)
> - No GitHub: `dotfiles/windows/GUIA_POS_INSTALACAO_WINDOWS_E_SKYRIM.md`

---

## ⚡ Sumário das Etapas
0. [Passo 0: Dual Boot & Sincronização Perfeita (Relógio UTC, Limine e Anti-Fast Startup)](#-passo-0-dual-boot--sincronização-perfeita)
1. [Passo 1: Montar a Partição D:\ com o WinBtrfs](#-passo-1-fazer-o-windows-enxergar-a-partição-com-os-mods)
2. [Passo 2: Instalar o Skyrim no Windows Nativo](#-passo-2-instalar-o-skyrim-no-windows)
3. [Passo 3: Carregar os 202 Mods no Mod Organizer 2 (MO2)](#-passo-3-gerenciar-e-ativar-os-202-mods-com-o-mod-organizer-2-mo2)
4. [Passo 4: Restaurar os 12 Saves de Personagem](#-passo-4-restaurar-seus-saves-de-personagem)
5. [Passo 5: Instalar Programas em Lote e GlazeWM](#-passo-5-setup-do-resto-do-windows-programas--tiling-wm)

---

## 🛡️ Passo 0: Dual Boot & Sincronização Perfeita

O Linux (CachyOS) e o Windows possuem diferenças históricas em como tratam o relógio da placa-mãe (RTC) e o desligamento do sistema. Nós já deixamos tudo pré-configurado no bootloader e criamos um script de 1 clique para resolver todos os problemas no Windows.

### 1. Bootloader Limine (Menu de Inicialização)
- O Limine já foi configurado para exibir o menu por **5 segundos** a cada inicialização.
- O menu exibirá automaticamente:
  - **CachyOS** (Linux Kernel padrão e LTS + Snapshots de rollback)
  - **Other systems and bootloaders ➔ Windows 11**
- O Limine possui a função `remember_last_entry: yes`: se você iniciou o Windows da última vez, ele já iniciará selecionado no próximo boot.

> [!TIP]
> Se após a instalação o Windows tentar tomar a prioridade de boot (iniciando direto sem passar pelo Limine):
> 1. Basta entrar na BIOS da placa-mãe (tecla `Del` ou `F2` ao ligar) e colocar **Limine** como Opção de Boot #1.
> 2. Ou execute o script `D:\scripts_windows\Configurar-DualBoot-Fixes.bat` dentro do Windows com privilégios de Administrador.

### 2. Correção do Relógio (UTC / RealTimeIsUniversal)
- Por padrão, o Linux usa horário UTC no relógio da placa-mãe, enquanto o Windows usa horário local. Isso causava o incômodo clássico do relógio atrasar ou adiantar 3 horas ao alternar de sistema operacional.
- O script `Configurar-DualBoot-Fixes.bat` ativa a chave nativa da Microsoft `RealTimeIsUniversal = 1`.
- **Resultado:** Tanto o Linux quanto o Windows operam 100% sincronizados em UTC. O horário fica sempre idêntico e exato ao segundo em ambos os sistemas.

### 3. Desativação do Fast Startup (Fim das partições bloqueadas)
- O "Fast Startup" do Windows não desliga o computador de verdade; ele hiberna o kernel e deixa as partições NTFS em estado "dirty" (bloqueadas).
- O script desativa o Fast Startup (`powercfg /h off` e `HiberbootEnabled = 0`), garantindo que o Windows faça desligamentos limpos e seguros, permitindo que o Linux leia e escreva na partição do Windows sem nenhum risco de corrupção.

### 4. Como aplicar as correções no Windows:
1. Abra a pasta `D:\scripts_windows\` no Windows Explorer.
2. Dê dois cliques no arquivo:
   ```text
   D:\scripts_windows\Configurar-DualBoot-Fixes.bat
   ```
3. O script solicitará permissão de Administrador e aplicará todas as 5 correções automaticamente em menos de 3 segundos!

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

> [!NOTE]
> Você também pode instalar o WinBtrfs diretamente abrindo `Instalar-Programas-PC.bat` e escolhendo a opção `[0]`.

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

No seu disco `D:\scripts_windows\` (ou clonando seu repositório `dotfiles`), execute com duplo clique:

### Opção A: Instalação Rápida do Pacote Essencial (12 Apps)
- Dê duplo clique em `D:\scripts_windows\Instalar-Pacote-Essencial.bat`.
- Instala automaticamente: Anki, WinRAR, PotPlayer, VLC, mpv, ImageGlass, qBittorrent, Foxit PDF Reader, Flameshot, CopyQ, Spotify e f.lux.

### Opção B: Central Completa de Instalação & Otimização
- Dê duplo clique em `D:\scripts_windows\Instalar-Programas-PC.bat`.
- Menu de opções:
  - `[0]` Instalar Driver WinBtrfs
  - `[1]` Instalar Stack Completo (GlazeWM + Dev Tools + Programas)
  - `[4]` Otimização e Debloat do Windows (Chris Titus WinUtil)
  - `[5]` Ativação Oficial Windows/Office (MAS - Massgrave)
  - `[7]` Instalar Pacote Essencial (12 Apps)
  - `[8]` Aplicar Correções de Dual Boot (Relógio UTC, Fast Startup, Limine)
  - `[9]` Instalar Runtimes de Jogos (Visual C++ AIO 2005-2022 + DirectX + .NET)
  - `[10]` Desativar Windows Defender e Windows Update Definitivamente

---

## 🛠️ Dica de Ouro sobre Drivers (Adeus Driver Booster)

> [!CAUTION]
> **Por que NUNCA usar Driver Booster / IObit:**
> Programas como Driver Booster instalam bloatware, adware de segundo plano, telemetria chinesa e frequentemente instalam drivers genéricos ou incompatíveis com o chipset que geram micro-travamentos e Telas Azuis (BSOD).

### Como instalar drivers com 100% de estabilidade:
1. **Primeira Varredura Automática:**
   Assim que instalar o Windows, conecte a internet e faça uma única verificação inicial do Windows Update para baixar os drivers oficiais certificados WHQL (Chipset, Áudio Realtek, Wi-Fi e Bluetooth) assinados pelo fabricante da placa-mãe.
2. **Placa de Vídeo (GPU):**
   Baixe o driver limpo oficial direto da fabricante:
   - **NVIDIA:** Baixe o NVIDIA App ou Game Ready Driver limpo.
   - **AMD:** Baixe o AMD Adrenalin oficial.
3. **Se faltar algum driver:**
   Use o **Snappy Driver Installer Origin (SDIO)** ([Página Oficial](https://www.snappy-driver-installer.org/)) — 100% open-source, gratuito, sem nenhum anúncio ou malware.
4. **Após instalar os drivers:**
   Execute a opção `[10]` do script para **desativar o Windows Update e o Defender** permanentemente, travando o sistema no estado perfeito.
