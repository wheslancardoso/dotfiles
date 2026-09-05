# 🏛️ Arquitetura Unificada de Arquivos: O Fim do Medo de Formatar

> **"Chega de ter que formatar o sistema e ficar horas fazendo backup."**  
> Este guia estabelece o padrão arquitetural definitivo para unificar seus arquivos entre o **Google Drive**, seu **Arch Linux** e seu **Windows 11**, garantindo que você possa reinstalar qualquer sistema operacional a qualquer momento com **zero perda de dados e zero necessidade de backup manual**.

---

## 🧭 1. O Princípio Fundamental: Separação Estado vs. Dados

A maioria dos computadores fica vulnerável porque mistura duas coisas totalmente diferentes no mesmo lugar:

1. **Estado do Sistema (Efêmero)**: Binários do Windows/Linux, drivers, atualizações, caches. Se quebrar, basta reinstalar em 10 minutos.
2. **Dados Pessoais (Permanente)**: Seus documentos, projetos de código, estudos, notas fiscais, memórias e ferramentas. **Esses dados nunca devem residir na partição do sistema operacional.**

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                          SSD FÍSICO (ex: 480 GB / 1 TB)                     │
├────────────────────────────────┬────────────────────────────────────────────┤
│   PARTIÇÃO DO SISTEMA          │   PARTIÇÃO DE DADOS / COFRE PERMANENTE     │
│   (Windows C:\ ou Linux /)     │   (Windows D:\ ou Linux /mnt/dados)        │
│   • 120 GB a 150 GB            │   • Restante do disco (300 GB a 850 GB)    │
│   • Reinstalável a qualquer    │   • Contém APENAS a Taxonomia Mestre       │
│     momento em 10 min          │     (00_Inbox a 06_Backups)                │
│   • ZERO arquivos pessoais     │   • NUNCA é tocada na formatação           │
└────────────────────────────────┴────────────────────────────────────────────┘
                                        ▲
                                        │ Espelhamento Bidirecional
                                        ▼
                         ☁️ GOOGLE DRIVE NA NUVEM
                         (Exata mesma árvore 00_ a 06_)
```

---

## 🌳 2. A Taxonomia Canônica Universal (`00_` a `06_`)

Tanto no seu Google Drive, quanto no Windows `D:\`, quanto no Arch Linux `/mnt/dados`, a árvore de diretórios é rigorosamente **idêntica**:

```text
📁 Raiz de Dados (D:\ ou /mnt/dados ou Google Drive Raiz)
│
├── 📁 00_Inbox_Triagem/                      # Destino padrão de downloads recém-chegados
│
├── 📁 01_Pessoal_e_Vida/
│   ├── 📁 01.1_Identidade_e_Documentos/     # RG, CPF, CNH, Certidões, Documentos digitalizados
│   ├── 📁 01.2_Carreira_e_Curriculos/       # Currículos, VDI, histórico de vagas
│   ├── 📁 01.3_Frequencia_e_Viagens/        # Comprovantes de ponto, relatórios de deslocamento
│   ├── 📁 01.4_Clareza_e_Desenvolvimento/   # Princípios, estilo pessoal, análises de personalidade
│   └── 📁 01.5_Financas_e_Contas/           # Extratos, faturas, imposto de renda, notas fiscais
│
├── 📁 02_Estudos_e_Concursos/
│   ├── 📁 02.1_TCE-GO/                      # Editais, cronogramas, cadernos de questões TCE
│   ├── 📁 02.2_Senador_Canedo/              # Editais e simulados Câmara de Senador Canedo
│   ├── 📁 02.3_Cursos_e_Certificacoes/      # ADS TCC, Apostilas SENAI, Linux Essentials, Redes
│   └── 📁 02.4_Biblioteca_e_Ebooks/         # Livros técnicos, ficção e desenvolvimento pessoal
│
├── 📁 03_Profissional_WFIX/
│   ├── 📁 03.1_IA_Prompts_e_SOPs/           # Fresh News, Playbooks de atendimento, Prompts de IA
│   ├── 📁 03.2_Automacoes_e_n8n/            # Workflows JSON, Webhooks e fluxos operacionais
│   ├── 📁 03.3_WFIX_Empresa/                # Administrativo, Financeiro, Marketing, Dev e IA
│   ├── 📁 03.4_Clientes_e_Whats/            # Transcrições e backups de conversas com clientes
│   └── 📁 03.5_Aulas_e_Treinamentos/        # Vídeos, gravações e aulas de negociação
│
├── 📁 04_Desenvolvimento_e_Codigo/
│   ├── 📁 04.1_Projetos_Web_e_Apps/         # Finance IA, Mixtape252, Wtech, apps fullstack
│   ├── 📁 04.2_Extensoes_e_Plugins/         # Plugins e extensões customizadas
│   └── 📁 04.3_Scripts_e_Automacoes/        # Scripts utilitários Python, Shell e bancos de dados SQL
│
├── 📁 05_Design_Midia_e_Criacao/
│   ├── 📁 05.1_Artes_e_Wallpapers/          # Banners, posteres, apresentações PPTX, Wallpapers
│   ├── 📁 05.2_Audios_e_Midias/             # Áudios, gravações de voz, trilhas e amostras
│   └── 📁 05.3_Letras_e_Composicoes/        # Rascunhos criativos e letras
│
└── 📁 06_Backups_ISOs_e_Sistemas/
    ├── 📁 06.1_Instaladores_e_APKs/         # Softwares portáteis, APKs e Suíte Ferramentas_TI
    ├── 📁 06.2_Backups_e_Snapshots/         # Backups de configurações (.pst, .zip de sistema)
    └── 📁 06.3_ISOs_e_Boot/                 # Imagens bootáveis (Windows 11, Hiren's Boot CD)
```

---

## 🐧 3. Implementação no Arch Linux

### Passo 1: Partição Separada no `/etc/fstab`
Seus arquivos pessoais devem ficar montados em `/mnt/dados` (ou como partição `/home` separada).

Exemplo no seu `/etc/fstab`:
```bash
# Partição de Dados Permanente (ex: Btrfs, Ext4 ou NTFS compartilhado)
UUID=SEU-UUID-AQUI   /mnt/dados   btrfs   defaults,noatime,compress=zstd   0  0
```

### Passo 2: Vinculação Automática com Symlinks
Execute o script incluído:
```bash
./scripts/vincular_linux.sh
```
O script cria links simbólicos transparentes na sua `$HOME`:
- `~/Downloads` ➔ `/mnt/dados/00_Inbox_Triagem`
- `~/Documentos` ➔ `/mnt/dados/01_Pessoal_e_Vida`
- `~/Estudos` ➔ `/mnt/dados/02_Estudos_e_Concursos`
- `~/WFIX` ➔ `/mnt/dados/03_Profissional_WFIX`
- `~/Projetos` ➔ `/mnt/dados/04_Desenvolvimento_e_Codigo`
- `~/Imagens` ➔ `/mnt/dados/05_Design_Midia_e_Criacao`
- `~/Backups` ➔ `/mnt/dados/06_Backups_ISOs_e_Sistemas`

---

## 🪟 4. Implementação no Windows 11

### Passo 1: Partição `D:\`
1. No particionamento do Windows, crie a partição `C:\` (130-140 GB) para o sistema.
2. Formate o restante do disco como `D:\` (NTFS com rótulo `Dados`).

### Passo 2: Vinculação Automática com Junções (`mklink /J`)
Abra a pasta `scripts/` e execute como Administrador:
```cmd
scripts\Vincular-Windows.bat
```
Todas as pastas de usuário passam a apontar diretamente para a partição `D:\`.

---

## ☁️ 5. Sincronização Perfeita com o Google Drive

1. **No Windows**:
   - Abra o **Google Drive Desktop** (app oficial).
   - Configure a pasta sincronizada para espelhar diretamente a sua partição `D:\`.
2. **No Linux**:
   - Use o **Rclone** montando ou sincronizando bidirecionalmente a pasta `/mnt/dados` via serviço systemd:
     ```bash
     rclone bisync /mnt/dados "gdrive:Meu Drive" --resync-mode newer
     ```

---

## ⚡ 6. O Teste de Ouro: Como Formatar em 10 Minutos

Quando você quiser formatar o computador (seja Linux ou Windows):

1. **Abra o instalador do SO.**
2. **Formate APENAS a partição do sistema** (`C:\` no Windows ou `/` no Linux).
3. Concluída a instalação:
   - No Linux: Execute `./setup.sh` do seu repositório de dotfiles e rode `./scripts/vincular_linux.sh`.
   - No Windows: Execute `scripts/Instalar-Programas-PC.bat` e rode `scripts/Vincular-Windows.bat`.
4. **Pronto!** Em menos de 15 minutos o computador está 100% novo, com todos os seus programas instalados, e **absolutamente nenhum arquivo precisou ser restaurado de backup manual**, pois todos já estavam intactos na partição de dados e na nuvem.
