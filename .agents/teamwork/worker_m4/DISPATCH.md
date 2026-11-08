# DISPATCH — worker_m4 (Milestone 4: Espelhamento no Google Drive)

- Timestamp: 2026-11-07T17:37:30Z
- Role: Drive Sync Specialist Worker (`teamwork_worker`)
- Working Directory: /home/lan/dotfiles/.agents/teamwork/worker_m4/
- Project Root: /home/lan/dotfiles
- Path to ORIGINAL_REQUEST.md: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- Path to PROJECT.md: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- Path to Survey Spec: /home/lan/dotfiles/.agents/teamwork/explorer_survey_3/handoff.md

## Objective
Executar o espelhamento da estrutura organizada no Google Drive utilizando o mecanismo oficial de sincronização do projeto (`scripts/gdrive-sync.sh`), cumprindo os requisitos R4 e Features F15 a F17.

## Detailed Tasks
1. **F15: Simulação (--dry-run)**:
   - Executar `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run`.
   - Inspecionar a saída da simulação para garantir que os pilares da taxonomia (`01..04`) são varridos sem erros impeditivos de conexão ou sintaxe.
2. **F16: Execução da Sincronização Real (--sync)**:
   - Executar `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync`.
   - Garantir que a sincronização para `gdrive:Taxonomia_Backup/` finalize com código de saída 0 e mensagem de sucesso.
3. **F17: Auditoria de Status e Consistência Pós-Sync**:
   - Executar `bash /home/lan/dotfiles/scripts/gdrive-sync.sh --status`.
   - Executar `python3 /home/lan/dotfiles/scripts/gdrive-index.py` (ou atualizar índices se aplicável).
   - Inspecionar o ponto de montagem VFS `/home/lan/gdrive/Taxonomia_Backup/` e/ou `/mnt/dados/00_GoogleDrive/` para certificar que os arquivos espelhados estão visíveis e íntegros.
4. **Relatório**:
   - Documentar todos os comandos executados, saídas verbatim, tempos de execução e métricas de transferência em `/home/lan/dotfiles/.agents/teamwork/worker_m4/handoff.md`.
   - Enviar mensagem de conclusão ao orquestrador.

## MANDATORY INTEGRITY WARNING
DO NOT CHEAT. All implementations and executions must be genuine. DO NOT fake sync logs or simulate results when live commands are required. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## 2026-11-07T17:37:48Z
Sender: f343c4ee-7fc3-477c-9b0f-de332f78b04f (Priority: HIGH)
Content:
Você é o Specialist Worker para o Milestone 4: Espelhamento no Google Drive.

Seu diretório exclusivo de trabalho é: /home/lan/dotfiles/.agents/teamwork/worker_m4/
O arquivo de despacho com todas as instruções detalhadas está em: /home/lan/dotfiles/.agents/teamwork/worker_m4/DISPATCH.md
Consulte também:
- /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_3/handoff.md

Seus objetivos principais:
1. Executar a simulação prévia obrigatória:
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --dry-run
2. Executar a sincronização real no Google Drive:
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --sync
3. Auditar a consistência e status pós-sincronização:
   bash /home/lan/dotfiles/scripts/gdrive-sync.sh --status
   python3 /home/lan/dotfiles/scripts/gdrive-index.py (se aplicável)
   Verificar a presença dos arquivos em /home/lan/gdrive/Taxonomia_Backup/
4. Redigir relatório completo em /home/lan/dotfiles/.agents/teamwork/worker_m4/handoff.md e enviar mensagem ao orquestrador.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All executions must be genuine. DO NOT fake sync logs or simulate results when live commands are required. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

