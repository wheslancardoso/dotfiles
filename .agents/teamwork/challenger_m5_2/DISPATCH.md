# DISPATCH — Challenger 2 (Milestone 5: Global E2E Adversarial Testing)

## Task Assignment
Perform independent adversarial testing across all 4 requirements from `ORIGINAL_REQUEST.md`.

## Mandatory Inputs (Read these first):
- `/home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md` (Mandatory - read first)
- `/home/lan/dotfiles/.agents/teamwork/PROJECT.md`
- `/home/lan/dotfiles/.agents/teamwork/orchestrator/GATE_STATUS.md`
- `/home/lan/dotfiles/.agents/teamwork/orchestrator_gen2/GATE_STATUS.md`

## Adversarial Scope:
1. **R1**: Check git history and git diff to ensure changes from M1, M2, M3 are cleanly committed with semantic messages without regressions.
2. **R2**: Verify cross-linking and correspondence between `mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/` and `mini-fiscalizacao/docs/aulas/trilha-04-dao/` (11 MDs vs 11 MP4s).
3. **R3**: Run `pytest scripts/organizador/tests/` and test edge cases in organizer rules (e.g. anti-collision, 0-byte file handling).
4. **R4**: Empirically check remote state on Google Drive using `rclone lsl` and verify that `INDEX_GLOBAL_GDRIVE.md` exists both in `/home/lan/gdrive` and `/home/lan/dotfiles/docs/`.
5. Provide your explicit verdict: `APPROVE` or `REQUEST_CHANGES` in your `handoff.md` and message.
