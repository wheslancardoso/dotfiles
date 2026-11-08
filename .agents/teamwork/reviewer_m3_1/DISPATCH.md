# DISPATCH — Reviewer M3 (1)

- Role: Objective & Adversarial Reviewer (`teamwork_reviewer`)
- Working Directory: /home/lan/dotfiles/.agents/teamwork/reviewer_m3_1/
- Scope: Milestone 3 (Aprimoramento de scripts/organizador - Features F7 a F14)
- Original Request: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- Project Scope: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- Worker Handoff: /home/lan/dotfiles/.agents/teamwork/worker_m3/handoff.md

## Verification Tasks
1. Execute and verify the complete test suite: `pytest scripts/organizador/tests/ -v` (ensure all 29 tests pass).
2. Verify git log for Milestone 3 commit (`git log -1 --stat` -> commit `18938b0`).
3. Empirically verify F7: word-boundary matching on short terms ("dio" must NOT match "audio_gravacao.wav", "estudio.mp3", "episodio.mp4", but MUST match "curso dio web.pdf" and "dio_bootcamp.pdf").
4. Empirically verify F8: "fotocopiadora.pdf" remains "fotocopiadora.pdf" (not "fotodora.pdf") and "Cópia de documento.pdf" -> "documento.pdf".
5. Empirically verify F9: `slugify_filename` in `src/utils.py` handles accents (NFKD), lowercase extensions, and illegal chars.
6. Empirically verify F10: `AutoNamer.sanitize_directory_name` and `clean_empty_directories` purging junk metadata (`desktop.ini`, `.DS_Store`).
7. Empirically verify F11: 0-byte file detection and protection in `src/core.py`.
8. Empirically verify F12: Shell scripts `auto_nomear.sh`, `desfazer.sh`, `simular.sh`, `calculadora_particoes.sh` run without path errors (`--help`).
9. Empirically verify F13: DAO and AGR rules in `config/regras.json`.
10. Deliver handoff.md with verdict: APPROVE or REQUEST_CHANGES.

## 2026-11-07T17:27:21Z
Você é o Reviewer 1 para o Gate do Milestone 3 (Aprimoramento de scripts/organizador).

Seu diretório exclusivo de trabalho é: /home/lan/dotfiles/.agents/teamwork/reviewer_m3_1/
Consulte:
- /home/lan/dotfiles/.agents/teamwork/reviewer_m3_1/DISPATCH.md
- /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- /home/lan/dotfiles/.agents/teamwork/worker_m3/handoff.md

Execute as verificações:
1. Executar e validar a suíte completa de testes: pytest scripts/organizador/tests/ -v (29 testes).
2. Verificar o commit semântico M3 no git: git log -1 --stat (commit 18938b0).
3. Testar empiricamente F7 (word boundary em 'dio'), F8 (preservação de 'fotocopiadora.pdf' e cópia), F9 (slugify_filename), F10 (pastas e metadados desktop.ini/.DS_Store), F11 (proteção 0-byte), F12 (scripts shell), F13 (regras DAO/AGR).
4. Gerar relatório detalhado em /home/lan/dotfiles/.agents/teamwork/reviewer_m3_1/handoff.md com veredito (APPROVE ou REQUEST_CHANGES) e enviar mensagem ao orquestrador.
