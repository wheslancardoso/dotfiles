# Dispatch: Explorer M1 Fix 2 (Docs References Remediation)

**Identity**: teamwork_explorer
**Working Directory**: /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/
**Parent**: teamwork_orchestrator
**Scope**: Remediação de referências de comando na documentação de `templates-lab/docs/`

## Mandatory Documents
- `/home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md`
- `/home/lan/dotfiles/.agents/teamwork/PROJECT.md`
- `/home/lan/dotfiles/.agents/teamwork/reviewer_m1_2/handoff.md`
- `/home/lan/dotfiles/.agents/teamwork/challenger_m1_2/handoff.md`

## Task
1. Search all files in `/home/lan/dotfiles/templates-lab/docs/` (`README.md`, `TEST_READY.md`, `TEST_INFRA.md`) for references to `scripts/verify_docs_suite.py` and `scripts/test_verify_docs_suite.py`.
2. Map all occurrences and provide the exact replacement to `templates-lab/scripts/verify_docs_suite.py` and `templates-lab/scripts/test_verify_docs_suite.py`.
3. Check if any other docs in `docs/` or dotfiles have broken references.
4. Output your remediation plan in `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/handoff.md`.
5. Send message to orchestrator.


## 2026-11-07T16:37:33Z
You are an Explorer agent (teamwork_explorer) investigating doc references remediation for Milestone 1.
Your working directory is: /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/
The authoritative user request is at: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
Your detailed dispatch assignment is at: /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/DISPATCH.md
The architecture and milestones document is at: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
The reviewer reports are at:
/home/lan/dotfiles/.agents/teamwork/reviewer_m1_2/handoff.md
/home/lan/dotfiles/.agents/teamwork/challenger_m1_2/handoff.md

You MUST read /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md and /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/DISPATCH.md before starting work.

Scope of investigation:
1. Examine templates-lab/docs/ (README.md, TEST_READY.md, TEST_INFRA.md) and search for stale references to scripts/verify_docs_suite.py and scripts/test_verify_docs_suite.py.
2. Produce exact line-by-line fix recommendations updating them to templates-lab/scripts/.
3. Check for any other broken doc references in docs/.
4. Save your report to /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/handoff.md and notify parent orchestrator via send_message.
