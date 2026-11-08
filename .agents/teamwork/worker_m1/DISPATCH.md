# Dispatch: Worker Milestone 1 (Organização e Limpeza Geral)

**Identity**: teamwork_worker
**Working Directory**: /home/lan/dotfiles/.agents/teamwork/worker_m1/
**Parent**: teamwork_orchestrator
**Scope**: Milestone 1 (R1 - Organização e Limpeza Geral do Repositório)

## Mandatory Documents to Read First
- `/home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md` (MUST read verbatim)
- `/home/lan/dotfiles/.agents/teamwork/PROJECT.md`
- `/home/lan/dotfiles/.agents/teamwork/explorer_survey_1/handoff.md` (Seção 4.2 - Plano Estrutural de Limpeza)

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Write Ownership Boundaries
You exclusively own and are authorized to modify/move/delete the following paths in `/home/lan/dotfiles/`:
1. `/home/lan/dotfiles/TEST_INFRA.md` & `/home/lan/dotfiles/TEST_READY.md` (delete from root; already preserved in `templates-lab/docs/`).
2. `/home/lan/dotfiles/games/gta-sa/`: Create directory structure and move from root:
   - `MODPACK_DEFINITIVO_GTA_SA.md`
   - `CHECKLIST_MODS_FALTANTES.md`
   - `MODS_FALTANTES_PARA_BAIXAR.md`
   - `MixSets_Otimizado.ini`
   - `nexusmodconta.env` (also add entry to `/home/lan/dotfiles/.gitignore` for `nexusmodconta.env` or `games/gta-sa/nexusmodconta.env`).
3. `/home/lan/dotfiles/games/gta-sa/scripts/`: Move the 21 GTA modding scripts from `scripts/`:
   `check_final_gta.py`, `check_wine_run.sh`, `extract_curated_mods.py`, `extract_new_batch.py`, `filtrar-curadoria-elite.py`, `generate_definitive_mixsets.py`, `generate_missing_checklist.py`, `generate_missing_list.py`, `gerar-lotes-270-fiel.py`, `gerar-lotes-curadoria-pura.py`, `gerar-lotes-download.py`, `gerar-lotes-filtrados.py`, `gta_catalog_full.json`, `gta_curated_core.json`, `gta-modman.py`, `limpar-bizarrices.py`, `limpar-dev-tools.py`, `lotes_download/`, `mixmods-scraper.py`, `testar-loading.py`, `test_wine_gta_30s.sh`, `test_wine_gta.sh`.
4. `/home/lan/dotfiles/templates-lab/scripts/`: Move `test_m1_empirical_adversarial.py`, `test_verify_docs_suite.py` and `verify_docs_suite.py` from `scripts/` to `templates-lab/scripts/`.
5. `/home/lan/dotfiles/docs/`: Move `playlist_maratona_java.md` from root to `docs/playlist_maratona_java.md`.
6. `/home/lan/dotfiles/backups/`: Remove uncompressed folder `hypr_backup_20261030_100513/`, keeping the compressed archive `hypr_backup_20261030_100513.tar.gz`.
7. Clean temporary `.pytest_cache` in root.

## Verification Requirements
Run shell verification commands (e.g. `ls`, `git status`) proving:
- Root is clean of loose GTA files, duplicate TEST_*.md, and sensitive credentials.
- All files were correctly moved to `games/gta-sa/`, `docs/`, and `templates-lab/scripts/`.
- No broken symlinks or missing files.
- Produce a detailed handoff report in `/home/lan/dotfiles/.agents/teamwork/worker_m1/handoff.md`.
- Send completion message to parent orchestrator.


## 2026-11-07T16:22:49Z
[Message] timestamp=2026-11-07T16:22:49Z sender=f343c4ee-7fc3-477c-9b0f-de332f78b04f priority=MESSAGE_PRIORITY_HIGH content=You are a Worker agent (teamwork_worker) implementing Milestone 1: Organização e Limpeza Geral.
Your working directory is: /home/lan/dotfiles/.agents/teamwork/worker_m1/
The authoritative user request is at: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
Your detailed dispatch assignment and write boundaries are at: /home/lan/dotfiles/.agents/teamwork/worker_m1/DISPATCH.md
The architecture and milestones document is at: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
The Explorer Survey findings with exact plans are at: /home/lan/dotfiles/.agents/teamwork/explorer_survey_1/handoff.md

You MUST read /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md and /home/lan/dotfiles/.agents/teamwork/worker_m1/DISPATCH.md before starting work.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope of work:
1. Delete duplicate TEST_INFRA.md and TEST_READY.md from root /home/lan/dotfiles/ (they are already in templates-lab/docs/).
2. Create /home/lan/dotfiles/games/gta-sa/ and /home/lan/dotfiles/games/gta-sa/scripts/.
3. Move root GTA files (MODPACK_DEFINITIVO_GTA_SA.md, CHECKLIST_MODS_FALTANTES.md, MODS_FALTANTES_PARA_BAIXAR.md, MixSets_Otimizado.ini, nexusmodconta.env) to games/gta-sa/.
4. Add nexusmodconta.env to .gitignore so credentials are never tracked.
5. Move the 21 GTA scripts and lotes_download/ from scripts/ to games/gta-sa/scripts/.
6. Move test_m1_empirical_adversarial.py, test_verify_docs_suite.py and verify_docs_suite.py from scripts/ to templates-lab/scripts/.
7. Move playlist_maratona_java.md from root to docs/playlist_maratona_java.md.
8. Remove the uncompressed backups/hypr_backup_20261030_100513/ directory, preserving the backups/hypr_backup_20261030_100513.tar.gz archive.
9. Clean .pytest_cache and temporary caches.
10. Verify via git status and ls commands that all files are in their right places and no broken links exist.
11. Write your full report to /home/lan/dotfiles/.agents/teamwork/worker_m1/handoff.md following the Handoff Protocol.
12. Notify parent orchestrator via send_message with a brief summary and path to handoff.md.
