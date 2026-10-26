# 🏎️ Diagnóstico Forense e Guia de Recuperação de Save (Btrfs / Linux)
**Jogo:** Midnight Club: Los Angeles Complete Edition (Xbox 360 Title ID: `545407F8`)  
**Plataforma / Runtime:** Midnight Club L.A. Recompiled (ReXGlue / Xenia Static Recomp)  
**Data do Incidente:** 25/10/2026 ~20:55:16 BRT  
**Sistema de Arquivos da Partição do Jogo:** `Btrfs` (Volume de ~217 GB / Driver Windows: WinBtrfs)  
**Diretório do Jogo:** `F:\Games\Midnight-Club-LA-Recompiled-Windows-x64\MCLA_LA_Recompiled\`

---

## 📌 Mensagem para a IA / Agente no Linux
> [!IMPORTANT]
> **LEIA ESTA SEÇÃO PRIMEIRO SE VOCÊ É UM AGENTE DE IA EM UMA SESSÃO LINUX:**  
> O usuário jogou cerca de 2 a 3 horas de Midnight Club: Los Angeles no Windows via recompilação estática (`mcla-recomp`).  
> Ocorreu uma queda repentina de energia às 20:55 durante um **Autosave**.  
> O drive onde o jogo está instalado (`F:` no Windows) é uma partição nativa **Btrfs**!  
> No Windows, o save reporta "corrompido" porque o cabeçalho existe, mas o arquivo de dados foi desvinculado no meio da escrita.  
> O usuário deu boot no Linux para tentar recuperar os blocos do arquivo através das características CoW / transações do **Btrfs** (`btrfs restore`).  
> Já existe um backup preventivo de toda a pasta em `.../MCLA_LA_Recompiled/userdata_backup_emergency`.

---

## 🔍 Diagnóstico Técnico Detalhado

### 1. O que aconteceu na queda de energia?
- O jogador esteve em sessão contínua das **19:27** às **20:55**.
- O arquivo de conquistas `userdata/achievements/545407F8.toml` registrou 4 conquistas desbloqueadas hoje (`19`, `36`, `38`, `69`).
- Às **20:55:16**, o jogo acionou a rotina de salvar o progresso.
- A energia caiu exatamente enquanto o arquivo de dados estava sendo substituído/descarregado no disco.

### 2. A arquitetura de Saves do ReXGlue / Xenia
O emulador/recompilador gerencia o storage de títulos Xbox 360 no formato `XCONTENT`:
```text
userdata/
└── B13EBABEBABEBABE/                  # XUID do perfil padrão offline
    └── 545407F8/                      # Title ID do Midnight Club: LA
        ├── 00000001/                  # Categoria XCONTENTTYPE_SAVEDGAME
        │   └── mc4.sav/               # Pasta montada como a raiz virtual de "save0:\"
        │       └── mc4.sav            # [ARQUIVO DE DADOS DO SAVE] -> FICOU FALTANDO / ZERADO
        └── Headers/
            └── 00000001/
                └── mc4.sav.header     # Cabeçalho STFS (328 bytes - SOBREVIVEU)
```

### 3. Evidência nos Logs (`logs/mcla_004.log`)
Ao reabrir o jogo após a inicialização:
```text
[warning] [krnl] [NtCreateFile] FAILED: path='save0:\mc4.sav' -> 0xc000000f (STATUS_NO_SUCH_FILE)
```
Como o `mc4.sav.header` existe, o emulador sabe que o save deveria existir e monta `save0:\` apontando para a pasta `00000001/mc4.sav/`. Porém, como o arquivo binário `mc4.sav` dentro da pasta não foi fechado a tempo pelo sistema de arquivos, a chamada de leitura falha com `0xc000000f` e o jogo exibe erro de save danificado/corrompido.

---

## 🛡️ Backups Preventivos já Realizados
Antes de qualquer alteração, o seguinte backup integral foi criado no disco:
* Caminho Windows: `F:\Games\Midnight-Club-LA-Recompiled-Windows-x64\MCLA_LA_Recompiled\userdata_backup_emergency\`
* Contém: Shaders, conquistas, cabeçalho `mc4.sav.header` e configurações intactas.

---

## 🛠️ Procedimento de Recuperação no Linux (Btrfs)

Como a partição é formatada em **Btrfs**, ela opera com **Copy-on-Write (CoW)**. Isso significa que a versão anterior do arquivo (ou partes da transação do autosave) geralmente **não** é sobrescrita no mesmo local físico imediatamente.

### Passo 1: Identificar a partição do jogo
Abra o terminal no Linux e localize o disco:
```bash
lsblk -f
```
Procure a partição Btrfs com capacidade de ~200-217 GB (a que continha o `F:` do Windows).  
Exemplo: `/dev/nvme0n1pX` ou `/dev/sdbX`.

### Passo 2: NÃO realizar montagens com escrita desnecessária
Se a partição não estiver montada, mantenha-a desmontada ou monte como somente leitura (`-o ro`) para preservar a árvore de transações anterior.

### Passo 3: Executar `btrfs restore` para pescar o arquivo desvinculado
O utilitário `btrfs restore` consegue varrer blocos de metadados antigos mesmo de arquivos desvinculados:

```bash
# Criar diretório temporário para receber os arquivos resgatados
mkdir -p ~/recuperacao_mcla

# Tentar restaurar filtrando por arquivos de save (*mc4* ou *.sav)
sudo btrfs restore -v -i --path-regex ".*mc4.*" /dev/sdXN ~/recuperacao_mcla/
```

> **Parâmetros do comando:**
> * `-v`: Modo verbose (exibe os arquivos encontrados).
> * `-i`: Ignora erros de integridade/metadados da árvore atual para buscar transações passadas.
> * `--path-regex`: Filtra apenas itens relacionados ao jogo Midnight Club LA.

Se você quiser listar as raízes de transações anteriores disponíveis na partição:
```bash
sudo btrfs-find-root /dev/sdXN
```
E você pode apontar o `btrfs restore` para uma raiz anterior específica via `-r <root_bytenr>`.

### Passo 4: Verificar se há Snapshots Btrfs existentes
Se a partição Btrfs foi criada sob uma instalação Linux que tenha **Snapper** ou **Timeshift**:
```bash
sudo btrfs subvolume list /ponto/de/montagem
```
Se houver snapshots, verifique a pasta `.snapshots/` da partição; o arquivo `mc4.sav` de poucas horas atrás pode estar intacto lá.

---

## 🎯 Onde colocar o arquivo recuperado?

Quando o arquivo `mc4.sav` (arquivo binário do save) for resgatado:
1. Monte a partição em modo leitura/escrita.
2. Copie o arquivo recuperado exatamente para:
   ```text
   <ponto_montagem>/Games/Midnight-Club-LA-Recompiled-Windows-x64/MCLA_LA_Recompiled/userdata/B13EBABEBABEBABE/545407F8/00000001/mc4.sav/mc4.sav
   ```
3. Garanta que o caminho final seja um arquivo com o nome `mc4.sav` dentro da pasta `mc4.sav`:
   ```text
   .../00000001/mc4.sav/mc4.sav
   ```
4. Ao abrir o jogo novamente, a chamada `NtCreateFile('save0:\mc4.sav')` terá sucesso imediato e o jogo carregará o save perfeitamente.

---

## 🔄 Plano Alternativo: Se o arquivo original não for encontrado

Caso a queda de energia tenha limpado a árvore antes de qualquer escrita no Btrfs:
1. **Injetar Save da Comunidade (Xbox 360):**  
   Qualquer save do jogo de Xbox 360 extraído no formato de arquivo `mc4.sav` pode ser colocado no caminho `userdata/.../00000001/mc4.sav/mc4.sav`.
2. **Iniciar Carreira Nova sem erro de corrupção:**  
   Se desejar começar do zero limpo sem telas de erro, basta deletar a pasta vazia `userdata/.../00000001/mc4.sav/` e o arquivo `userdata/.../Headers/00000001/mc4.sav.header`. O jogo criará um perfil novo automaticamente.
