# BRIEFING — 2026-11-07T16:10:00Z

## Mission
Investigate `scripts/organizador` to identify improvements for R3 (folder/file handling, naming slugification/sanitization, rule matching, test gaps) and produce a structured survey handoff.

## 🔒 My Identity
- Archetype: explorer
- Roles: explorer, survey
- Working directory: /home/lan/dotfiles/.agents/teamwork/explorer_survey_2
- Original parent: f343c4ee-7fc3-477c-9b0f-de332f78b04f
- Milestone: Survey Phase (R3 Focus)

## 🔒 Key Constraints
- Read-only investigation — do NOT implement
- Scope limited to scripts/organizador and R3 requirements
- Output handoff.md with 5-component structure
- Notify caller via send_message upon completion

## Current Parent
- Conversation ID: f343c4ee-7fc3-477c-9b0f-de332f78b04f
- Updated: not yet

## Investigation State
- **Explored paths**:
  - /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
  - /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/DISPATCH.md
  - scripts/organizador/ (main.py, config/regras.json, requirements.txt, shell scripts)
  - scripts/organizador/src/ (cli.py, core.py, renamer.py, taxonomy.py, utils.py, history.py, dedup.py, doctor.py, watcher.py, partition_calc.py)
  - scripts/organizador/tests/test_organizer.py (22/22 tests passing)
  - /mnt/dados/00_Inbox_Triagem (DAO lessons and 0-byte corrupt file dao-09.mp4 found)
  - docs/GUIA_NOMENCLATURA.md, docs/GUIA_GOOGLE_DRIVE.md
- **Key findings**:
  1. Substring false-positive bug: "dio" in config/regras.json hijacks all audio files (e.g. audio_gravacao.wav, estudio.mp3) to Cursos_e_Certificacoes.
  2. Degenerate regex in AutoNamer: r"\s*copia" corrupts valid words (e.g. fotocopiadora.pdf -> fotodora.pdf).
  3. Directory handling: recursive=True flattens files and strips parent folder context; clean_empty_directories fails when metadata (desktop.ini, .DS_Store) exists.
  4. Path bug in shell wrappers: auto_nomear.sh, desfazer.sh, simular.sh, calculadora_particoes.sh try to run non-existent ../scripts/main.py.
  5. 0-byte file vulnerability: 0-byte corrupt files take priority and relegate good files to _1.
  6. Missing rules: No rules exist for DAO lectures or AGR Dojo projects.
- **Unexplored areas**:
  - None within the survey scope for R3.

## Key Decisions Made
- Fully documented all bugs and architectural shortcomings with exact reproduction steps and code locations in handoff.md.
- Formulated concrete improvement recommendations and 6 new test cases for implementation in M3.

## Artifact Index
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/DISPATCH.md — Task assignment
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/BRIEFING.md — Persistent context & memory
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/progress.md — Liveness heartbeat
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/handoff.md — Final survey report for R3
