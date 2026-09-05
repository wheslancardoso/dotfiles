# 🎮 Guia de Padronização — Games, Emuladores e Ludusavi

Este guia define a arquitetura oficial para manter **jogos, emuladores (Nintendo Switch, PCSX2), mods e saves** 100% protegidos, organizados e sincronizados com a nuvem (Google Drive) e com o disco de dados (`/mnt/dados` ou `D:\`).

---

## 🌳 A Arquitetura Canônica de Games (`06.4_Games_e_Emuladores`)

Todas as pastas de jogos e emuladores agora possuem um lugar definitivo dentro da Taxonomia Mestre:

```text
📁 06_Backups_ISOs_e_Sistemas/
└── 📁 06.4_Games_e_Emuladores/
    │
    ├── 📁 01_Saves_e_Backups/
    │   ├── 📁 Ludusavi_Backups/         # 💾 Sincronização automática de saves via Ludusavi
    │   │   ├── 📁 Grand Theft Auto III/
    │   │   ├── 📁 Marvel's Spider-Man/
    │   │   └── 📁 Need for Speed_ Most Wanted/
    │   └── 📁 Saves_Manuais/            # Saves avulsos, memcards e backups pontuais
    │
    ├── 📁 02_Mods_e_Patches/            # 🧩 Mods, reshades, traduções PT-BR e trainers
    │   ├── 📁 GTA_Trilogy/
    │   ├── 📁 Spider-Man/
    │   └── 📁 NFS_Most_Wanted/
    │
    ├── 📁 03_Emuladores/                # 🕹️ Emuladores portáteis, BIOS e configurações
    │   ├── 📁 Nintendo_Switch/
    │   │   ├── 📁 Emulador/             # Yuzu / Ryujinx / Sudachi portátil ou AppImage
    │   │   ├── 📁 Configuracoes/        # Perfis de controle, configs gráficas e hotkeys
    │   │   ├── 📁 Keys_e_Firmware/      # prod.keys, title.keys e firmware oficial
    │   │   ├── 📁 Saves/                # Backups de saves do Switch (exportados / JKSV)
    │   │   └── 📁 Mods/                 # Mods de 60fps, texturas e traduções
    │   │
    │   └── 📁 PCSX2_PlayStation_2/
    │       ├── 📁 Emulador/             # PCSX2 portátil ou AppImage
    │       ├── 📁 Configuracoes/        # inis, gamesettings e profiles de controle
    │       ├── 📁 Bios/                 # BIOS oficial (SCPH-77000, SCPH-39001, etc.)
    │       ├── 📁 Memcards_e_Saves/     # Mcd001.ps2, Mcd002.ps2 e savestates (.p2s)
    │       └── 📁 Cheats_e_Patches/     # Arquivos .pnach (Widescreen e 60fps)
    │
    └── 📁 04_ROMs_e_ISOs/               # 💿 Jogos compactados (.chd, .cso, .nsp, .xci)
```

---

## 🛡️ O Poder do Ludusavi ("Lupisave")

O **Ludusavi** é a ferramenta open-source em Rust número 1 do mundo para backup e restauração de saves de jogos no PC. Ele detecta automaticamente mais de 10.000 jogos (Steam, Epic Games, GOG, emuladores e jogos piratas/repacks).

### Como Configurar o Ludusavi para Sincronizar no Google Drive / Dados:

1. Abra o **Ludusavi** (no Windows ou no Arch Linux via `ludusavi` ou menu de apps).
2. Clique no ícone de engrenagem **Settings (Configurações)**.
3. No campo **Backup Target Directory (Diretório de Backup)**, aponte para:
   - **No Linux**:
     ```text
     /mnt/dados/06_Backups_ISOs_e_Sistemas/06.4_Games_e_Emuladores/01_Saves_e_Backups/Ludusavi_Backups
     ```
   - **No Windows**:
     ```text
     D:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\01_Saves_e_Backups\Ludusavi_Backups
     ```
     *(ou a pasta correspondente no Google Drive)*
4. **Pronto!** Toda vez que você clicar em **Backup** no Ludusavi (ou ao fechar o jogo se deixar em segundo plano), todos os seus saves vão direto para a pasta segura e sincronizam com o Google Drive na nuvem.

### Como Restaurar os Saves após Formatar o PC:
1. Abra o Ludusavi no sistema novo.
2. Defina o mesmo caminho de diretório de backup acima.
3. Vá na aba **Restore (Restaurar)** e clique no botão verde.
4. **Em 2 segundos todos os seus jogos estarão com os seus saves exatamente onde você parou.**

---

## 🕹️ Emuladores: Onde Fica Cada Coisa

### 1. PCSX2 (PlayStation 2)
- **BIOS**: As BIOS japonesas/americanas (`SCPH-77000`) já foram preservadas em `03_Emuladores/PCSX2_PlayStation_2/Bios/`. No PCSX2 novo, basta ir em *Configurações > BIOS* e selecionar essa pasta.
- **Memory Cards**: Os cartões de memória (`Mcd001.ps2` e `Mcd002.ps2`) já foram copiados para `03_Emuladores/PCSX2_PlayStation_2/Memcards_e_Saves/`. No PCSX2, aponte o diretório de Memory Cards para lá e nenhum progresso será perdido.

### 2. Nintendo Switch (Yuzu / Ryujinx / Sudachi)
- **Keys**: Coloque seus arquivos `prod.keys` e `title.keys` na pasta `Keys_e_Firmware`.
- **Saves**: O Ludusavi também faz backup dos saves do Ryujinx e Yuzu automaticamente se eles estiverem no caminho padrão!
- **Mods**: Qualquer mod de 60fps ou tradução fica isolado em `03_Emuladores/Nintendo_Switch/Mods/`.

---

## 🚀 Status da Importação no seu Drive

Nós já realizamos a migração imediata dos arquivos encontrados no seu computador:
- ✔ **Saves do Ludusavi importados**: *Spider-Man*, *GTA Trilogy*, *NFS Most Wanted*.
- ✔ **BIOS do PCSX2 importada**: *SCPH-77000* e complementos de ROM.
- ✔ **Memory Cards importados**: *Mcd001.ps2* e *Mcd002.ps2* com todos os seus saves de PS2.
- ✔ **Árvore do Nintendo Switch scaffoldada**: Pronta para receber suas chaves, firmware e emuladores.
- ✔ **Regras do Organizador Master**: O motor Python agora roteia arquivos de jogos, emuladores e ROMs (`.nsp`, `.xci`, `.chd`, `.cso`) direto para cá.
