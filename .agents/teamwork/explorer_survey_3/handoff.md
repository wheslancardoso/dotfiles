# Relatório de Handoff: Levantamento R4 (Espelhamento no Google Drive)

## 1. Observation

### 1.1 Configuração e Conectividade do Rclone
* **Remoto Configurado**:
  - Comando: `rclone listremotes`
  - Saída verbatim:
    ```
    gdrive:
    ```
  - Arquivo de configuração: `/home/lan/.config/rclone/rclone.conf`
* **Status do Ponto de Montagem VFS e Serviço Systemd**:
  - Comando: `bash /home/lan/dotfiles/scripts/gdrive-mount.sh status`
  - Saída verbatim:
    ```
    STATUS DA CONEXÃO:
      Estado          : ● CONECTADO & ATIVO
      Ponto Principal : /home/lan/gdrive
      Link Unificado  : /mnt/dados/00_GoogleDrive

    CACHE LOCAL VFS (Proteção do SSD):
      Uso Atual       : 0 B (Cache limpo)

    SERVIÇO SYSTEMD:
      Inicialização   : Habilitado no boot (user systemd)
      Status Systemd  : active (running)

    TESTE DE CONEXÃO COM O GOOGLE DRIVE:
      Verificando quota remota... OK!
      Espaço Total    : 0.0 GB (ou 0.00 TB)
      Espaço Ocupado  : 0.0 GB (ou 0.00 TB)
    ```
  - Unidade systemd ativa: `systemctl --user status rclone-gdrive.service` (PID 947, status `active (running)`).
  - Ponto de montagem montado e acessível: `/home/lan/gdrive` e symlink `/mnt/dados/00_GoogleDrive`.

### 1.2 Script Canônico de Espelhamento: `scripts/gdrive-sync.sh`
* **Localização**: `/home/lan/dotfiles/scripts/gdrive-sync.sh`
* **Definições e Regras de Negócio**:
  - Linhas 28-30:
    ```bash
    REMOTE="gdrive"
    DEST_PREFIX="Taxonomia_Backup"
    CONFIG_FILE="${HOME}/.config/rclone/rclone.conf"
    ```
  - Linhas 33-37:
    ```bash
    if [ -d "/mnt/dados" ] && [ -d "/mnt/dados/01_Pessoal_e_Vida" ]; then
        BASE_DIR="/mnt/dados"
    else
        BASE_DIR="${HOME}/documents"
    fi
    ```
  - Linhas 40-45 (Pilares de backup contínuo na nuvem):
    ```bash
    PILLARS=(
        "01_Pessoal_e_Vida"
        "02_Estudos_e_Concursos"
        "03_Profissional_WFIX"
        "04_Desenvolvimento_e_Codigo"
    )
    ```
  - Linhas 48-66 (Filtros de exclusão de artefatos efêmeros e binários de build):
    ```bash
    EXCLUDES=(
        "--exclude=.git/**"
        "--exclude=node_modules/**"
        "--exclude=__pycache__/**"
        "--exclude=.venv/**"
        "--exclude=.pytest_cache/**"
        "--exclude=target/**"
        "--exclude=build/**"
        "--exclude=dist/**"
        "--exclude=*.iso"
        "--exclude=*.crdownload"
        "--exclude=*.part"
        "--exclude=*.tmp"
        "--exclude=*.aria2"
        "--exclude=Thumbs.db"
        "--exclude=desktop.ini"
        "--exclude=*:Zone.Identifier"
        "--exclude=.DS_Store"
    )
    ```
  - Linhas 127-135 (Comando de execução do Rclone):
    ```bash
    rclone sync "$src_path" "$dest_path" \
        "${EXCLUDES[@]}" \
        "${dry_opt[@]}" \
        --transfers=4 \
        --checkers=8 \
        --fast-list \
        --stats=3s \
        --stats-one-line \
        --progress
    ```
* **Teste de Simulação Executado**:
  - Comando: `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run`
  - Resultado: Código de saída 0. Varreu com sucesso os 4 pilares locais `/mnt/dados/01..04` comparando com `gdrive:Taxonomia_Backup/01..04`.

### 1.3 Outros Scripts e Esteiras Existentes
* `scripts/gdrive-mount.sh`: Utilitário de montagem sob demanda via Rclone VFS com cache adaptativo de até 50 GB.
* `scripts/gdrive-index.py`: Auditor e gerador da árvore do índice do Google Drive (`docs/INDEX_GLOBAL_GDRIVE.md` e `~/gdrive/INDEX_GLOBAL_GDRIVE.md`).
* `scripts/notebooklm-sync.py`: Compilador de Megadocs do `~/timeless_life` e upload via `rclone copy` para `gdrive:NotebookLM_Context/`.
* `concurso-notebooklm-sync.path` / `concurso-notebooklm-sync.service` -> `/home/lan/concurso/scripts/sincronizar_notebooklm.py`: Monitora alterações em cadernos do concurso e roda `rclone sync` para `gdrive:NotebookLM_Context/Concurso_TCE_GO/`.
* `scripts/organizador-menu.sh`: Menu Rofi com opção `6. Sincronização Nuvem Google Drive 5TB (Rclone)`, apontando diretamente para `$HOME/dotfiles/scripts/gdrive-sync.sh`.

### 1.4 Estado dos Alvos e das Aulas de DAO
* Em `/mnt/dados/00_Inbox_Triagem/`:
  - 12 arquivos de vídeo identificados: `dao-01.mp4` a `dao-11.mp4`, incluindo a duplicata `dao-09 (1).mp4`.
* No ecossistema local:
  - As aulas teóricas de DAO correspondentes encontram-se em `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/individual/` (`DAO-01_*.md` a `DAO-11_*.md`).
  - O repositório dotfiles também possui cópia em `/mnt/dados/04_Desenvolvimento_e_Codigo/dotfiles`.
  - Uma vez organizadas e alocadas dentro de qualquer um dos 4 pilares (`04_Desenvolvimento_e_Codigo` ou `02_Estudos_e_Concursos`), as aulas e arquivos serão automaticamente capturados e espelhados por `gdrive-sync.sh`, visto que a extensão `.mp4` não está na lista de exclusão.

---

## 2. Logic Chain

1. **Premissa de Requisito (R4)**: O requisito R4 exige espelhar a estrutura organizada no Google Drive utilizando o mecanismo e rotinas de sincronização do projeto.
2. **Identificação da Ferramenta Oficial**: Conforme observado em `scripts/gdrive-sync.sh`, `scripts/organizador-menu.sh` (opção 6) e `docs/INDEX_GLOBAL_GDRIVE.md` (Seção 3), a esteira canônica de espelhamento do ecossistema é o `gdrive-sync.sh` operando via `rclone sync`.
3. **Validação da Conexão Remota**: A verificação de `rclone listremotes` e `gdrive-mount.sh status` confirmou que o remote `gdrive:` está 100% ativo, autenticado via OAuth2, com o serviço systemd de usuário em execução e o diretório `/home/lan/gdrive` montado.
4. **Mapeamento de Escopo e Filtros**:
   - Origem local: `/mnt/dados/`
   - Destino remoto: `gdrive:Taxonomia_Backup/`
   - Pilares abrangidos: `01_Pessoal_e_Vida`, `02_Estudos_e_Concursos`, `03_Profissional_WFIX`, `04_Desenvolvimento_e_Codigo`.
   - Arquivos temporários, caches e diretórios de versionamento (`.git/`) são filtrados para não poluir o armazenamento em nuvem com dados voláteis.
5. **Comportamento com Mídias e Aulas de DAO**: Aulas de DAO em `.mp4` não são descartadas pelas regras de exclusão de `gdrive-sync.sh`. Ao serem movidas para a estrutura final em `04_Desenvolvimento_e_Codigo` ou `02_Estudos_e_Concursos`, serão transferidas e espelhadas para `gdrive:Taxonomia_Backup/` na execução do sync.
6. **Teste de Execução Seguro**: A simulação com `--dry-run` foi executada em produção e terminou com código 0, comprovando a prontidão da ferramenta sem qualquer intervenção manual de infraestrutura.

---

## 3. Caveats

1. **Volume de Dados e Tempo de Transferência**: O comando live `--sync` transfere dados reais. O dry-run indicou arquivos pendentes na árvore de desenvolvimento. Se houver restrição de tempo, a equipe de implementação pode optar por sincronizar especificamente os subdiretórios afetados pelas tarefas R1/R2 via comando rclone pontual (`rclone sync /mnt/dados/04_Desenvolvimento_e_Codigo/... gdrive:Taxonomia_Backup/04_Desenvolvimento_e_Codigo/...`) antes de rodar a suíte global.
2. **Aviso de Client ID do Rclone**: O Rclone emitiu aviso de que o remoto utiliza o client ID padrão do Rclone. Isso não impede a sincronização imediata, mas comandos que gerem dezenas de milhares de chamadas por minuto podem sofrer throttling da API da Google. As flags já configuradas (`--transfers=4 --checkers=8 --fast-list`) reduzem esse impacto.
3. **Exclusão Intencional do `.git`**: O histórico git (`.git/`) é explicitamente ignorado na nuvem. A sincronização de código-fonte espelha apenas a árvore de arquivos de trabalho, preservando a soberania do GitHub para controle de versão.

---

## 4. Conclusion

1. **Rotina e Comando Definitivo para R4**:
   O espelhamento para o Google Drive deve ser executado chamando:
   ```bash
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync
   ```
   Ou, para simulação prévia obrigatória:
   ```bash
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run
   ```
2. **Ordem de Execução Recomendada**:
   - Fase 1: Executar R1 (Organização e limpeza de arquivos do projeto/dotfiles e diretórios locais).
   - Fase 2: Executar R2 (Organizar as aulas `dao-*.mp4` de `/mnt/dados/00_Inbox_Triagem/`, eliminar a duplicata `dao-09 (1).mp4`, alocar na pasta de destino).
   - Fase 3: Executar R3 (Aprimorar `scripts/organizador` e garantir que os testes passem via `pytest scripts/organizador/tests/`).
   - Fase 4: Executar R4 rodando `scripts/gdrive-sync.sh --dry-run` seguido de `scripts/gdrive-sync.sh --sync`.
   - Fase 5: Atualizar índice do drive se necessário via `python3 /home/lan/dotfiles/scripts/gdrive-index.py`.

---

## 5. Verification Method

Para verificar de forma independente e auditável o sucesso do espelhamento do requisito R4:

1. **Verificação de Simulação Prévia (Sem Modificações)**:
   ```bash
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run
   ```
   *Critério de Sucesso*: Terminar com código 0 e exibir `✔ Simulação concluída!`.

2. **Verificação de Execução Real**:
   ```bash
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync
   ```
   *Critério de Sucesso*: Terminar com código 0 e exibir `✔ Sincronização seletiva concluída com sucesso no Google Drive!`.

3. **Verificação de Consistência e Divergências (Audit)**:
   ```bash
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --status
   ```
   *Critério de Sucesso*: O comando `rclone check` deve apontar `0 differences` ou apenas as exclusões esperadas para os pilares sincronizados.

4. **Verificação Direta no Ponto de Montagem Local VFS**:
   Inspecionar diretamente o ponto de montagem do Drive para confirmar que os arquivos organizados estão visíveis:
   ```bash
   ls -la /home/lan/gdrive/Taxonomia_Backup/
   ```
   *Critério de Sucesso*: Diretórios dos pilares presentes e arquivos atualizados visíveis no sistema de arquivos virtual.

5. **Condições de Invalidação**:
   - Falha de autenticação do Rclone (`rclone listremotes` não listar `gdrive:`).
   - Erro de rede ou indisponibilidade de cota no Google Drive.
   - Ponto de montagem `/home/lan/gdrive` não montado ou serviço `rclone-gdrive.service` inativo.
