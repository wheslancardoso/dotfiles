# Execution Plan

## Objective
Organizar completamente o repositório dotfiles:
1. Limpeza e organização geral (remover redundâncias e arquivos soltos desnecessários).
2. Organização das aulas de DAO baixadas (contexto 0808d8cc-5518-4271-b2c7-ce2c0ecb4ba9).
3. Aprimoramento da ferramenta `scripts/organizador` e garantia de 100% dos testes passando.
4. Espelhamento do resultado no Google Drive.
5. Verificação E2E e auditoria forense.

## Phases
1. **Phase 0: Survey (3 Parallel Explorers)**
   - Explorer 1 (General & DAO): Investigar arquivos soltos, pastas raiz, aulas de DAO baixadas, duplicatas, contexto de referência.
   - Explorer 2 (Tooling): Investigar `scripts/organizador/`, estrutura de código, regras de classificação, cobertura de testes (`pytest scripts/organizador/tests/`).
   - Explorer 3 (Drive Sync): Investigar mecanismos existentes de espelhamento/sincronização com Google Drive (scripts, rclone, serviços).
2. **Phase 1: Project Plan & Milestone Decomposition**
   - Consolidar `PROJECT.md` com arquitetura, inventário de features e contratos de interface.
3. **Phase 2: Milestone Execution**
   - M1: Organização e limpeza geral.
   - M2: Organização das aulas de DAO.
   - M3: Aprimoramento de `scripts/organizador` e novos testes.
   - M4: Execução do espelhamento no Drive.
4. **Phase 3: E2E Verification & Forensic Integrity Audit**
   - Reviewers, Challengers e Forensic Auditor (`teamwork_auditor`).
5. **Phase 4: Synthesis & Reporting to Parent Sentinel**.
