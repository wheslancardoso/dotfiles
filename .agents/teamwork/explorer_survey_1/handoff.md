# Relatório de Investigação e Pesquisa Forense — Explorer Survey 1

**Agente**: `teamwork_explorer` (`explorer_survey_1`)  
**Data/Timestamp**: 2026-11-07T16:20:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Escopo**: Levantamento e Mapeamento Completo de R1 (Organização e Limpeza Geral) & R2 (Organização das Aulas de DAO), com subsídios para R3 (`scripts/organizador`) e R4 (Google Drive).

---

## 1. Observation (Evidências Diretas Coletadas)

### 1.1 Contexto da Conversa `0808d8cc-5518-4271-b2c7-ce2c0ecb4ba9` & Aulas de DAO
Através de inspeção nos metadados e mensagens em `/home/lan/.gemini/antigravity/brain/0808d8cc-5518-4271-b2c7-ce2c0ecb4ba9/.system_generated/messages/`, constatou-se que a conversa `0808d8cc` orquestrou o desenvolvimento completo das 8 Trilhas de Aprendizagem do mini-sistema governamental `mini-fiscalizacao` (RoadGuard), localizado em:
`/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/`

Na mensagem `1ed74512-9650-4fd7-a274-ed86b175c433.json`:
> *"A missão de desenvolvimento integral das 8 Trilhas de Aprendizagem do mini-fiscalizacao (RoadGuard) foi concluída com sucesso absoluto e homologada com veredito VICTORY CONFIRMED pela Auditoria Independente de Vitória... Criação das 8 Trilhas Monográficas Definitivas em `mini-fiscalizacao/docs/aulas/trilhas/`: ... `TRILHA-04-DAO-PERSISTENCIA-COMPLETA.md`: 11 aulas (DAO-01 a DAO-11) — O Padrão DAO puro (Autuado, Enquadramento, Patio, AutoInfracao, TermoRemocao, Historico)."*

No arquivo canônico de índice `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/INDICE-AULAS-INDIVIDUAIS.md` (linhas 58 a 69) e no diretório `individual/`, as 11 aulas da Trilha 4 possuem os seguintes títulos e nomes exatos de arquivo:

1. `DAO-01_Por-que-o-Padrão-DAO-Existe-A-Lei-da-Responsabilidade-Única.md` (6.870 bytes)
2. `DAO-02_O-Papel-do-Arquivista-da-Repartição-Desacoplamento-e-Injeção-de-Conexão.md` (7.220 bytes)
3. `DAO-03_O-Método-Universal-mapRow-Mapeamento-Manual-sem-Hibernate.md` (6.599 bytes)
4. `DAO-04_Dissevissecção-do-AutuadoDAO-Inserção-e-Busca-Inteligente.md` (8.958 bytes)
5. `DAO-05_Dissevissecção-do-EnquadramentoDAO-Consulta-de-Infrações-e-Valores.md` (6.841 bytes)
6. `DAO-06_Dissevissecção-do-PatioConveniadoDAO-O-Gerenciamento-das-Vagas-e-Custódia.md` (6.532 bytes)
7. `DAO-07_Dissevissecção-do-AutoInfracaoDAO-Parte-1-Operações-de-Leitura-e-JOINs.md` (9.324 bytes)
8. `DAO-08_Dissevissecção-do-AutoInfracaoDAO-Parte-2-A-Escrita-e-o-Sequencial-com-Lock-Pessimista.md` (8.122 bytes)
9. `DAO-09_Dissevissecção-do-TermoRemocaoDAO-Guarda-e-Desbloqueio.md` (8.070 bytes)
10. `DAO-10_Dissevissecção-do-HistoricoTramitacaoDAO-A-Memória-que-Nunca-se-Apaga.md` (7.663 bytes)
11. `DAO-11_DAOs-Operando-sob-Conexões-Transacionais-Compartilhadas.md` (10.291 bytes)

### 1.2 Localização e Inventário dos Vídeos Baixados de DAO (Downloads)
O diretório `/home/lan/Downloads` é um symlink para `/home/lan/downloads`, que por sua vez aponta para `/mnt/dados/00_Inbox_Triagem/`.
Inspeção executada via comando `ls -lh /mnt/dados/00_Inbox_Triagem/dao*.mp4`:

```text
-rw-r--r-- 1 lan lan  34M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-01.mp4
-rw-r--r-- 1 lan lan  31M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-02.mp4
-rw-r--r-- 1 lan lan 8.6M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-03.mp4
-rw-r--r-- 1 lan lan  34M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-04.mp4
-rw-r--r-- 1 lan lan  31M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-05.mp4
-rw-r--r-- 1 lan lan  31M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-06.mp4
-rw-r--r-- 1 lan lan  33M Nov  7 12:45  /mnt/dados/00_Inbox_Triagem/dao-07.mp4
-rw-r--r-- 1 lan lan  38M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-08.mp4
-rw-r--r-- 1 lan lan  36M Nov  7 12:45 '/mnt/dados/00_Inbox_Triagem/dao-09 (1).mp4'
-rw-r--r-- 1 lan lan    0 Nov  7 12:45  /mnt/dados/00_Inbox_Triagem/dao-09.mp4
-rw-r--r-- 1 lan lan  27M Nov  7 12:45  /mnt/dados/00_Inbox_Triagem/dao-10.mp4
-rw-r--r-- 1 lan lan  24M Nov  7 12:46  /mnt/dados/00_Inbox_Triagem/dao-11.mp4
```

**Diagnóstico Forense dos Arquivos de DAO:**
- Foram baixados 12 arquivos no total (~337 MB).
- O arquivo `dao-09.mp4` possui exatamente **0 bytes** (download interrompido/corrompido).
- O arquivo `'dao-09 (1).mp4'` possui **37.049.183 bytes (36 MB)** e é o arquivo íntegro correspondente à aula DAO-09.
- Os 11 arquivos válidos correspondem biunivocamente às 11 aulas da Trilha 4 (DAO) do `mini-fiscalizacao`.

### 1.3 Mapeamento de Arquivos Soltos, Redundâncias e Desordem em `/home/lan/dotfiles`

#### A. Arquivos Redundantes e Cópia Duplicada na Raiz:
- `TEST_INFRA.md` (6.520 bytes, hash SHA-256 `a159630d49bc...`): Cópia idêntica de `/home/lan/dotfiles/templates-lab/docs/TEST_INFRA.md`.
- `TEST_READY.md` (4.355 bytes, hash SHA-256 `a05c1ccc75e8...`): Cópia idêntica de `/home/lan/dotfiles/templates-lab/docs/TEST_READY.md`.

#### B. Arquivos Deslocados na Raiz do Repositório:
- `MODPACK_DEFINITIVO_GTA_SA.md` (49.845 bytes): Documento do modpack GTA San Andreas.
- `CHECKLIST_MODS_FALTANTES.md` (10.248 bytes): Checklist de mods GTA SA.
- `MODS_FALTANTES_PARA_BAIXAR.md` (9.358 bytes): Lista de pendências de download GTA SA.
- `MixSets_Otimizado.ini` (4.720 bytes): Configuração INI do MixSets para GTA SA (cabeçalho explicita: *"Coloque este arquivo dentro de: modloader/01_Correcoes_Codigo/MixSets/"*).
- `nexusmodconta.env` (50 bytes): Credenciais em texto claro de conta do NexusMods (`email=...`, `senha=...`). Risco crítico de segurança ao estar na raiz e versionado.
- `playlist_maratona_java.md` (29.737 bytes): Relação de 286 aulas de Java no YouTube. Deve residir na pasta de documentação/estudos (`docs/` ou `02_Estudos_e_Concursos/`).

#### C. Scripts Deslocados em `scripts/`:
Em `scripts/`, há 21 arquivos específicos de modding de GTA San Andreas misturados com utilitários de sistema:
- `check_final_gta.py`, `check_wine_run.sh`, `extract_curated_mods.py`, `extract_new_batch.py`, `filtrar-curadoria-elite.py`, `generate_definitive_mixsets.py`, `generate_missing_checklist.py`, `generate_missing_list.py`, `gerar-lotes-270-fiel.py`, `gerar-lotes-curadoria-pura.py`, `gerar-lotes-download.py`, `gerar-lotes-filtrados.py`, `gta_catalog_full.json`, `gta_curated_core.json`, `gta-modman.py`, `limpar-bizarrices.py`, `limpar-dev-tools.py`, `lotes_download/` (diretório), `mixmods-scraper.py`, `testar-loading.py`, `test_wine_gta_30s.sh`, `test_wine_gta.sh`.
- Testes ad-hoc pertencentes ao `templates-lab`: `test_m1_empirical_adversarial.py` (40.984 bytes), `test_verify_docs_suite.py` (11.494 bytes), `verify_docs_suite.py` (36.070 bytes).

#### D. Redundâncias em `backups/`:
Em `backups/`, coexistem o arquivo compactado `hypr_backup_20261030_100513.tar.gz` (1.997.861 bytes) E a pasta inteira descompactada `hypr_backup_20261030_100513/` contendo dezenas de arquivos duplicados de configurações do Hyprland que já existem no tarball e no repositório.

#### E. Clutter e Caches Desnecessários Não Rastreados:
- `home/dot_local/share/apex-finance/web/frontend/node_modules/` (247 MB de dependências untracked gerando centenas de colisões de hash).
- `scripts/stream-extractor/node_modules/` (29 MB).
- Caches de compilação: `.pytest_cache/`, `scripts/__pycache__/`, `scripts/organizador/src/__pycache__/`, `home/dot_local/share/apex-finance/__pycache__/`.

### 1.4 Diagnóstico da Ferramenta `scripts/organizador` (Para R3)
1. **Falha com arquivos vazios (0-byte)**:
   Em `scripts/organizador/src/dedup.py` (linha 49): `if size > 0: size_groups[size].append(p)`.
   O `HashDeduplicator` ignora arquivos de 0 bytes. Com isso, arquivos corrompidos como `dao-09.mp4` nunca são detectados ou isolados.
2. **Colisão na Sanitização**:
   Em `scripts/organizador/src/renamer.py`: `AutoNamer.sanitize_name("dao-09 (1).mp4")` retorna `dao-09.mp4`. Porém, como `dao-09.mp4` (0 bytes) já existe na mesma pasta, a rotina `process_directory` chama `get_unique_destination_path` e gera `dao-09_1.mp4`, perpetuando o arquivo corrompido de 0 bytes como original.
3. **Ausência de Classificação para DAO / Mini-Fiscalização**:
   Ao executar `FileOrganizerEngine.classify_file(Path('/home/lan/Downloads/dao-01.mp4'))`, o retorno é `None`. Não existem regras em `scripts/organizador/config/regras.json` para arquivos da Trilha DAO ou mini-fiscalização.
4. **Status dos Testes Atuais**:
   O comando `pytest scripts/organizador/tests/` executa 22 testes em 0.08s com 100% de sucesso.

### 1.5 Diagnóstico de Espelhamento no Google Drive (Para R4)
1. **Configuração Rclone**:
   O remote `gdrive:` está funcional e autenticado. O comando `rclone lsd gdrive:Taxonomia_Backup` responde com sucesso, exibindo os pilares `01_Pessoal_e_Vida`, `02_Estudos_e_Concursos`, `03_Profissional_WFIX` e `04_Desenvolvimento_e_Codigo`.
2. **Rotina de Sincronização Canônica**:
   O script oficial do repositório é `/home/lan/dotfiles/scripts/gdrive-sync.sh`.
   Ele sincroniza `/mnt/dados/01..04` para `gdrive:Taxonomia_Backup/01..04` via comando `rclone sync`, possuindo flags de `--dry-run`, `--status` e `--sync`.

---

## 2. Logic Chain (Cadeia de Raciocínio & Deduções)

1. **Raciocínio sobre R2 (Aulas de DAO)**:
   - *Premissa 1*: O usuário solicitou a organização das aulas de DAO baixadas com base no contexto da conversa `0808d8cc`.
   - *Premissa 2*: A conversa `0808d8cc` gerou a documentação de 11 aulas da Trilha 4 (DAO) do projeto `mini-fiscalizacao` (`DAO-01_*.md` até `DAO-11_*.md`).
   - *Premissa 3*: Em `/mnt/dados/00_Inbox_Triagem/` existem exatamente 12 arquivos `dao-*.mp4`, sendo 11 vídeos completos (~337 MB) e 1 arquivo com 0 bytes (`dao-09.mp4`).
   - *Dedução*: `dao-09.mp4` é uma falha de download que deve ser purgada/removida, e `'dao-09 (1).mp4'` deve ser renomeado para a aula 09. Cada vídeo de `dao-01.mp4` a `dao-11.mp4` deve ser renomeado para corresponder exatamente ao título monográfico de sua respectiva aula em `mini-fiscalizacao/docs/aulas/individual/` com extensão `.mp4`, e movido para a pasta de destino `mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/` (ou espelhada em `02_Estudos_e_Concursos/02.1_TCE-GO/NotebookLM_Audios_e_Videos/`).

2. **Raciocínio sobre R1 (Limpeza do Dotfiles)**:
   - *Premissa 1*: `TEST_INFRA.md` e `TEST_READY.md` na raiz do dotfiles são idênticos aos arquivos em `templates-lab/docs/`.
   - *Dedução*: Devem ser removidos da raiz para eliminar redundância sem perda de dados.
   - *Premissa 2*: `MODPACK_DEFINITIVO_GTA_SA.md`, `CHECKLIST_MODS_FALTANTES.md`, `MODS_FALTANTES_PARA_BAIXAR.md`, `MixSets_Otimizado.ini` e 21 scripts em `scripts/` pertencem estritamente ao GTA San Andreas.
   - *Dedução*: Devem ser agrupados na taxonomia do repositório em `games/gta-sa/` (e `games/gta-sa/scripts/`), mantendo a raiz do dotfiles e `scripts/` limpos e dedicados à infraestrutura do sistema.
   - *Premissa 3*: `nexusmodconta.env` contém credenciais puras de e-mail e senha.
   - *Dedução*: Deve ser movido para `games/gta-sa/` (ou pasta protegida) e adicionado obrigatoriamente ao `.gitignore`.
   - *Premissa 4*: `playlist_maratona_java.md` é material de estudo.
   - *Dedução*: Deve ser alocado em `docs/cursos/` ou `docs/`.
   - *Premissa 5*: Em `backups/`, a pasta descompactada `hypr_backup_20261030_100513` duplica integralmente o arquivo `hypr_backup_20261030_100513.tar.gz`.
   - *Dedução*: Manter o `.tar.gz` e remover a pasta descompactada poupa centenas de arquivos duplicados no repositório git.

3. **Raciocínio sobre R3 (Aprimoramento do `organizador`)**:
   - A ferramenta precisa suportar purga/detecção de arquivos vazios de 0 bytes antes da renomeação, para não colidir cópias válidas como `dao-09 (1).mp4`.
   - A ferramenta precisa incluir regras para arquivos de estudo de programação e trilhas governamentais da AGR (`mini-fiscalizacao`), roteando vídeos de aulas para o diretório de destino correto.

4. **Raciocínio sobre R4 (Espelhamento no Google Drive)**:
   - Como os arquivos organizados de DAO residirão dentro de `/mnt/dados/04_Desenvolvimento_e_Codigo/` (ou `/mnt/dados/02_Estudos_e_Concursos/`), a execução de `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync` espelhará automaticamente a nova estrutura para `gdrive:Taxonomia_Backup/`.

---

## 3. Caveats (Ressalvas & Limitações)

1. **Escopo Somente-Leitura deste Explorer**:
   Nenhuma alteração de arquivo foi realizada nesta fase de levantamento (Survey Phase). A execução das remoções, renomeações e movimentações cabe às fases seguintes (Milestones M1 a M4).
2. **Downloads de Mods Pesados em Inbox**:
   Em `/mnt/dados/00_Inbox_Triagem/`, há múltiplos arquivos de mods de GTA (`.7z`, `.zip`) totalizando mais de 15 GB (ex: `RoSA Evolved - August.7z` com 6.3 GB, `Original Radio Extended.zip` com 7.1 GB). Estes arquivos estão fora do escopo do repositório dotfiles, devendo ser mantidos ou triados pelo usuário em `/mnt/dados/06_Backups_ISOs_e_Sistemas/06.4_Games_e_Emuladores`.
3. **Credenciais do NexusMods**:
   Recomenda-se remover `nexusmodconta.env` do histórico do Git caso tenha sido versionado publicamente, além de adicioná-lo ao `.gitignore`.

---

## 4. Conclusion (Plano de Ação para os Próximos Milestones)

### Tabela de Mapeamento e Renomeação Canônica das Aulas de DAO (R2)

| Arquivo Atual em `~/Downloads` | Ação | Nome de Destino Padronizado | Pasta de Destino |
|---|---|---|---|
| `dao-01.mp4` (34 MB) | Mover & Renomear | `DAO-01_Por-que-o-Padrão-DAO-Existe-A-Lei-da-Responsabilidade-Única.mp4` | `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/` |
| `dao-02.mp4` (31 MB) | Mover & Renomear | `DAO-02_O-Papel-do-Arquivista-da-Repartição-Desacoplamento-e-Injeção-de-Conexão.mp4` | Idem |
| `dao-03.mp4` (8.6 MB) | Mover & Renomear | `DAO-03_O-Método-Universal-mapRow-Mapeamento-Manual-sem-Hibernate.mp4` | Idem |
| `dao-04.mp4` (34 MB) | Mover & Renomear | `DAO-04_Dissevissecção-do-AutuadoDAO-Inserção-e-Busca-Inteligente.mp4` | Idem |
| `dao-05.mp4` (31 MB) | Mover & Renomear | `DAO-05_Dissevissecção-do-EnquadramentoDAO-Consulta-de-Infrações-e-Valores.mp4` | Idem |
| `dao-06.mp4` (31 MB) | Mover & Renomear | `DAO-06_Dissevissecção-do-PatioConveniadoDAO-O-Gerenciamento-das-Vagas-e-Custódia.mp4` | Idem |
| `dao-07.mp4` (33 MB) | Mover & Renomear | `DAO-07_Dissevissecção-do-AutoInfracaoDAO-Parte-1-Operações-de-Leitura-e-JOINs.mp4` | Idem |
| `dao-08.mp4` (38 MB) | Mover & Renomear | `DAO-08_Dissevissecção-do-AutoInfracaoDAO-Parte-2-A-Escrita-e-o-Sequencial-com-Lock-Pessimista.mp4` | Idem |
| `dao-09.mp4` (**0 bytes**) | **Excluir** | *(Arquivo corrompido / download interrompido)* | N/A |
| `'dao-09 (1).mp4'` (36 MB) | Mover & Renomear | `DAO-09_Dissevissecção-do-TermoRemocaoDAO-Guarda-e-Desbloqueio.mp4` | Idem |
| `dao-10.mp4` (27 MB) | Mover & Renomear | `DAO-10_Dissevissecção-do-HistoricoTramitacaoDAO-A-Memória-que-Nunca-se-Apaga.mp4` | Idem |
| `dao-11.mp4` (24 MB) | Mover & Renomear | `DAO-11_DAOs-Operando-sob-Conexões-Transacionais-Compartilhadas.mp4` | Idem |

### Plano Estrutural de Limpeza do Dotfiles (R1)
1. **Eliminar Redundâncias na Raiz**:
   - Deletar `/home/lan/dotfiles/TEST_INFRA.md` e `/home/lan/dotfiles/TEST_READY.md` (preservados em `templates-lab/docs/`).
2. **Isolar Ecossistema GTA San Andreas**:
   - Criar diretório `/home/lan/dotfiles/games/gta-sa/` e subdiretório `scripts/`.
   - Mover os 4 arquivos soltos da raiz (`MODPACK_DEFINITIVO_GTA_SA.md`, `CHECKLIST_MODS_FALTANTES.md`, `MODS_FALTANTES_PARA_BAIXAR.md`, `MixSets_Otimizado.ini`) para `games/gta-sa/`.
   - Mover os 21 scripts e arquivos JSON específicos de GTA de `scripts/` para `games/gta-sa/scripts/`.
   - Mover `nexusmodconta.env` para `games/gta-sa/` e adicionar ao `.gitignore`.
3. **Mover Scripts de Templates-Lab**:
   - Mover `test_m1_empirical_adversarial.py`, `test_verify_docs_suite.py` e `verify_docs_suite.py` para `templates-lab/scripts/`.
4. **Organizar Estudos de Java**:
   - Mover `playlist_maratona_java.md` para `docs/playlist_maratona_java.md`.
5. **Desduplicar Backups**:
   - Remover o diretório descompactado `backups/hypr_backup_20261030_100513/`, mantendo o arquivo `backups/hypr_backup_20261030_100513.tar.gz`.
6. **Limpeza de Caches**:
   - Limpar `.pytest_cache` e `__pycache__` residuais.

### Plano de Aprimoramento da Ferramenta de Organização (R3)
- Adicionar ao `HashDeduplicator` / `FileOrganizerEngine` método `purge_empty_files()` ou flag para identificar e limpar arquivos com tamanho 0 bytes antes da desduplicação e sanitização.
- Adicionar suporte e regra em `regras.json` para arquivos com prefixo `dao-*.mp4` e trilhas do mini-fiscalizacao.
- Adicionar testes unitários em `scripts/organizador/tests/test_organizer.py` cobrindo limpeza de 0-byte e regras de trilhas de aulas.
- Garantir que `pytest scripts/organizador/tests/` passe com 100% de sucesso.

### Plano de Espelhamento no Drive (R4)
- Após a reorganização local e movimentação das aulas de DAO, executar `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run` para validar a esteira, e em seguida `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync` para espelhar as alterações em `gdrive:Taxonomia_Backup/`.

---

## 5. Verification Method (Comandos de Validação Independente)

Para qualquer agente ou auditor verificar este relatório independentemente, execute:

1. **Verificação dos arquivos de DAO baixados**:
   ```bash
   ls -lh /mnt/dados/00_Inbox_Triagem/dao*.mp4
   # Esperado: 12 arquivos (11 com tamanho entre 8.6M e 38M, e dao-09.mp4 com 0 bytes)
   ```

2. **Verificação dos títulos canônicos de DAO no projeto `mini-fiscalizacao`**:
   ```bash
   ls -la /mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/individual/DAO*.md
   # Esperado: 11 arquivos markdown de DAO-01 a DAO-11
   ```

3. **Verificação das redundâncias no dotfiles**:
   ```bash
   diff /home/lan/dotfiles/TEST_INFRA.md /home/lan/dotfiles/templates-lab/docs/TEST_INFRA.md
   diff /home/lan/dotfiles/TEST_READY.md /home/lan/dotfiles/templates-lab/docs/TEST_READY.md
   # Esperado: Retorno silencioso (código de saída 0), provando que são 100% idênticos
   ```

4. **Verificação dos testes do organizador**:
   ```bash
   pytest /home/lan/dotfiles/scripts/organizador/tests/
   # Esperado: 22 passed in < 0.2s
   ```

5. **Verificação do status do Google Drive**:
   ```bash
   rclone lsd gdrive:Taxonomia_Backup
   # Esperado: Lista dos 4 pilares sincronizados
   ```
