# 🏛️ MANUAL MESTRE DE INSTALAÇÃO & RESTAURAÇÃO DEFINITIVA (SKYRIM SE/AE v1.6.1170)

> **Ambiente Alvo:** Windows 11 Enterprise LTSC / Linux (Wine/Proton)  
> **Gerenciador:** Mod Organizer 2 (Modo Portátil em `C:\Games\MO2`)  
> **Status da Lista:** 170 Mods Instalados | 135 Plugins Ativos | 100% Estabilizado (Zero Crash)  
> **Armazenamento de Dados:** Disco `F:\` (`/mnt/dados` no Linux) para sincronização com Google Drive.

---

## 🧭 1. ESTRUTURA ORGANIZACIONAL DA PASTA DADOS (`F:\`)

Todos os arquivos necessários para recriar o Skyrim do zero estão organizados no diretório soberano:
`F:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\`

```
06.4_Games_e_Emuladores/
├── 00_MANUAL_MESTRE_INSTALACAO_SKYRIM_AE.md       <- Este guia completo
├── 00_MANUAL_MESTRE_INSTALACAO_SKYRIM_AE.html     <- Versão visual para navegador/celular
│
├── 01_Saves_e_Backups/
│   └── Skyrim_Saves/                              <- Saves da jornada (incluindo o personagem "cj")
│
├── 02_Mods_e_Patches/
│   └── Skyrim_AE/
│       ├── 00_FERRAMENTAS/                        <- SSEEdit 4.1.5f e LOOT 0.29.2 prontos
│       ├── 00_CONFIGURACOES_E_AUTOMACAO/          <- Automação de 1 clique, perfis, INIs e binários
│       │   ├── setup_skyrim.ps1                   <- Script principal de restauração
│       │   ├── run_setup.bat                      <- Executável rápido de 2 cliques
│       │   ├── ModOrganizer.ini                   <- Configuração geral do MO2
│       │   ├── backup_profile/                    <- Plugins.txt, modlist.txt, loadorder.txt, INIs
│       │   ├── backup_root_patches/               <- SkyrimSE.exe blindado, SKSE 2.2.6 e Engine Fixes
│       │   └── backup_saves/                      <- Cópia de segurança dos saves
│       ├── 00_PATCHES_POS_EXTRACAO/               <- Correções de FaceGen (Bijin), Tundra e DLLs
│       ├── Mod.Organizer-2.5.2.exe                <- Instalador oficial do MO2 portátil
│       └── [Arquivos .7z, .zip e .rar dos mods]  <- Todos os 170 pacotes de mods originais
│
└── 05_Instaladores/
    ├── Skyrim_Anniversary_Edition_FitGirl_Repack/ <- Instalador base do jogo
    └── The Elder Scrolls V Skyrim Special Edition update 1.6.1130 - 1.6.1170/ <- Patch de atualização
```

---

## ⚡ 2. ROTEIRO DE INSTALAÇÃO DO ZERO (PASSO A PASSO)

Quando você for instalar o jogo novamente em qualquer máquina, siga rigorosamente as 5 etapas abaixo:

### 🎮 ETAPA 1: Instalação do Jogo Base & Atualização
1. Acesse `05_Instaladores\Skyrim_Anniversary_Edition_FitGirl_Repack\setup.exe`.
2. Instale o jogo obrigatoriamente no diretório padrão:
   `C:\Games\Skyrim Special Edition`
   *(Evite instalar dentro de `Program Files` para não sofrer com bloqueios de permissão do Windows UAC).*
3. Acesse `05_Instaladores\The Elder Scrolls V Skyrim Special Edition update 1.6.1130 - 1.6.1170\`.
4. Aplique a atualização para elevar os arquivos do jogo para a versão **1.6.1170**.

---

### 📦 ETAPA 2: Instalação do Mod Organizer 2
1. Acesse `02_Mods_e_Patches\Skyrim_AE\Mod.Organizer-2.5.2.exe`.
2. Instale em **Modo Portátil (Portable)** no caminho:
   `C:\Games\MO2`
3. Ao abrir pela primeira vez, aponte para o diretório do jogo (`C:\Games\Skyrim Special Edition`).
4. Feche o MO2.

---

### 📂 ETAPA 3: Extração dos Mods
Existem duas maneiras de popular a pasta `C:\Games\MO2\mods`:

* **Opção Rápida (Script Automático):**  
  Execute o script PowerShell `games/skyrim-se/install_mods_into_mo2.ps1` contido no seu repositório dotfiles:
  ```powershell
  powershell -ExecutionPolicy Bypass -File "c:\Users\lan\dotfiles\games\skyrim-se\install_mods_into_mo2.ps1"
  ```
* **Opção Manual:**  
  Extraia cada arquivo compactado da pasta `02_Mods_e_Patches\Skyrim_AE\` em sua respectiva subpasta dentro de `C:\Games\MO2\mods\<Nome_Do_Mod>`.

---

### 🚀 ETAPA 4: A Automação Mestre de 1 Clique (`run_setup.bat`)
Esta é a etapa mais importante. Ela resolve automaticamente 100% das configurações finas, patches e ordem de carga.

1. Vá até a pasta:
   `F:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\02_Mods_e_Patches\Skyrim_AE\00_CONFIGURACOES_E_AUTOMACAO\`
2. Dê **dois cliques** no arquivo:
   `run_setup.bat`
3. O script executará automaticamente:
   * **Injeção do Motor:** Copia o **SKSE 2.2.6** (`skse64_loader.exe`), as DLLs de suporte e o **Engine Fixes Parte 2** (`bink2w64.dll`) para a raiz do jogo.
   * **Executável Blindado:** Injeta o `SkyrimSE.exe` contendo as correções de ponteiro nulo (prevenindo qualquer crash no *New Game* e na abertura dos menus de Magia **P** e Inventário **I**).
   * **Perfil Sincronizado:** Configura o perfil `Default` com os **135 plugins ativos** e na ordem exata de carregamento em **UTF-8 puro sem BOM**.
   * **Patches Pós-Extração (FaceGen & Tundra):** Aplica os rostos completos do *Bijin* (Gerdur, Irileth, etc.), ativa a Tundra Verde do *Cathedral Landscapes*, atualiza a DLL do *MCM Helper 1.6.2* e desativa DLLs redundantes do *TK Dodge* e *SkyClimb*.
   * **Ferramentas Integradas:** Registra o **SSEEdit** e o **LOOT** dentro do menu de executáveis do MO2.
   * **Saves:** Restaura os saves mais recentes para a sua pasta de usuário.

---

### 🗡️ ETAPA 5: Jogando!
1. Abra o Mod Organizer 2 (`C:\Games\MO2\ModOrganizer.exe`).
2. No canto superior direito, selecione o executável **SKSE**.
3. Clique em **Executar**.
4. Bom jogo!

---

## 🛡️ 3. CASCA DE BANANA & ANÁLISE FORENSE (O QUE FOI RESOLVIDO)

Para referência técnica futura, estes foram os problemas complexos detectados e corrigidos cirurgicamente na sua instalação:

| Problema Encontrado | Causa-Raiz Técnica | Como Foi Resolvido |
| :--- | :--- | :--- |
| **Crash no New Game (`0x22D573`)** | Engine tentava ler registro de contêiner não resolvido (`entry->object == NULL`). | Blindagem no `SkyrimSE.exe` em `0x22D567` ignorando itens vazios na inicialização. |
| **Crash ao Abrir Magia (**P**) (`0x941300`)** | `StoreEnchantedItemsVisitor` percorria lista de inventário com ponteiro nulo. | Blindagem em `InventoryChanges::Accept` (`0x231A70`) com salto verificado para o rótulo de saída. |
| **Mulheres Sem Rosto (Gerdur, Irileth)** | O arquivo FOMOD do Bijin foi extraído deixando os arquivos `.nif` e `.dds` presos em `01 Characters\`. | Movidos todos os FaceGens de 46 mulheres para a raiz de malhas/texturas dos mods Bijin. |
| **Grama Rala & Linha de Pop-in Curta** | `fGrassStartFadeDistance` travado em `7000` e densidade em `60`. | Expandido para `18000` no `skyrimprefs.ini` e densidade elevada para `iMinGrassSize=40` (Tundra Verde ativa). |
| **Estradas Ausentes no Mapa 3D** | `A Clear Map of Skyrim` sobrepunha o terreno e não continha malhas de estradas desenhadas. | Ativado `A Quality World Map (Vivid with Stone Roads)` no final da ordem de carga. |
| **Avisos de "Plugin Not Found" no MO2** | PowerShell salvou arquivos `.txt` com cabeçalho invisível UTF-8 BOM (`EF BB BF`). | Todos os scripts e perfis foram reescritos em codificação UTF-8 pura (No BOM). |

---

## ⌨️ 4. MAPA DE ATALHOS & COMANDOS IN-GAME

* **`P`**: Menu de Magia (Ordinator + Apocalypse + Odin Overhauls).
* **`I` / `Tab`**: Menu de Inventário & Personagem (SkyUI com Skyland Bits and Bobs).
* **`M`**: Mapa Mundial 3D detalhado com todas as estradas de pedra e sem nuvens.
* **`Q`**: Menu de Favoritos / Roda de Acesso Rápido Wheeler.
* **`V`**: Esquiva tática / Dodge Roll (TK Dodge RE com animações fluidas).
* **`F`**: Alternar 1ª e 3ª Pessoa (True Directional Movement + SmoothCam com travamento de mira).
* **`~` (Aspas)**: Console de desenvolvedor (More Informative Console ativo).

---

## ☁️ 5. SINCRONIZAÇÃO COM O GOOGLE DRIVE

Como a pasta `F:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\` contém tudo:
1. Você pode sincronizar a subpasta `02_Mods_e_Patches\Skyrim_AE\` diretamente para o seu Google Drive.
2. A pasta `05_Instaladores\` pode ser guardada em nuvem ou em um HD externo / pendrive de backup.
3. Seus saves estão duplamente protegidos tanto em `01_Saves_e_Backups\` quanto em `00_CONFIGURACOES_E_AUTOMACAO\backup_saves\`.
