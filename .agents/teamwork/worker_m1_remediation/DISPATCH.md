# Dispatch: Worker M1 Remediation (Milestone 1 Iteration 2)

**Identity**: teamwork_worker
**Working Directory**: /home/lan/dotfiles/.agents/teamwork/worker_m1_remediation/
**Parent**: teamwork_orchestrator
**Scope**: Remediação e Finalização do Milestone 1 (R1 - Organização e Limpeza Geral)

## Mandatory Documents
- `/home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md` (MUST read verbatim)
- `/home/lan/dotfiles/.agents/teamwork/PROJECT.md`
- `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/handoff.md`
- `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/handoff.md`
- `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_3/handoff.md`

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Write Ownership Boundaries
You exclusively own and are authorized to modify/move/stage:
- `scripts/abrir-links-pendentes.sh` (git mv to `games/gta-sa/scripts/abrir-links-pendentes.sh`)
- `games/gta-sa/scripts/*.py`
- `templates-lab/docs/*.md`
- `templates-lab/scripts/verify_docs_suite.py`
- Staging in git: `games/gta-sa/`, `templates-lab/`, `docs/`, `scripts/`, `.gitignore`

## Exact Steps
1. Move the remaining GTA script:
   `git mv scripts/abrir-links-pendentes.sh games/gta-sa/scripts/abrir-links-pendentes.sh`
2. Apply the GTA scripts patch:
   `git apply /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/gta_scripts_fix.patch`
3. Apply the documentation references patch:
   `git apply /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch`
4. Run the full verification harness:
   - python3 games/gta-sa/scripts/check_final_gta.py
   - python3 games/gta-sa/scripts/filtrar-curadoria-elite.py
   - python3 games/gta-sa/scripts/generate_missing_checklist.py
   - python3 games/gta-sa/scripts/generate_missing_list.py
   - python3 games/gta-sa/scripts/gerar-lotes-270-fiel.py
   - python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
   - python3 games/gta-sa/scripts/gerar-lotes-download.py
   - python3 games/gta-sa/scripts/gerar-lotes-filtrados.py
   - python3 games/gta-sa/scripts/limpar-bizarrices.py
   - python3 games/gta-sa/scripts/limpar-dev-tools.py
   - pytest templates-lab/scripts/test_verify_docs_suite.py
   - python3 templates-lab/scripts/verify_docs_suite.py
   - pytest templates-lab/scripts/test_m1_empirical_adversarial.py
   - pytest scripts/organizador/tests/
5. Stage all changes to git:
   ```bash
   git add games/gta-sa/
   git add templates-lab/
   git add docs/
   git add scripts/
   git add .gitignore
   ```
6. Verify with `git status --short` that no production files have status `RM` or unstaged modifications.
7. Write your handoff report to `/home/lan/dotfiles/.agents/teamwork/worker_m1_remediation/handoff.md`.
8. Send message with summary to parent orchestrator.


## 2026-11-07T16:50:06Z
You are a Worker agent (teamwork_worker) implementing the remediation for Milestone 1: Organização e Limpeza Geral.
Your working directory is: /home/lan/dotfiles/.agents/teamwork/worker_m1_remediation/
The authoritative user request is at: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
Your detailed dispatch assignment is at: /home/lan/dotfiles/.agents/teamwork/worker_m1_remediation/DISPATCH.md
The architecture and milestones document is at: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
The remediation Explorer handoffs and pre-validated patches are at:
/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/handoff.md
/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/gta_scripts_fix.patch
/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/handoff.md
/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch
/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_3/handoff.md
