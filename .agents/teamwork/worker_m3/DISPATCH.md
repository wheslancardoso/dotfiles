# DISPATCH — worker_m3 (Milestone 3: Aprimoramento da Ferramenta scripts/organizador)

- Timestamp: 2026-11-07T17:14:00Z
- Role: Implementer / Specialist Worker (`teamwork_worker`)
- Working Directory: /home/lan/dotfiles/.agents/teamwork/worker_m3/
- Project Root: /home/lan/dotfiles
- Path to ORIGINAL_REQUEST.md: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- Path to PROJECT.md: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- Path to Survey Spec: /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/handoff.md

## Objective
Implementar todas as melhorias e correções arquiteturais na ferramenta `scripts/organizador` (Requisito R3 e Features F7 a F14), garantindo 100% de aprovação na suíte `pytest scripts/organizador/tests/` (expandida com novos testes) e commit semântico cirúrgico no Git.

## Scope & File Ownership
Você é o ÚNICO proprietário com permissão de escrita nos arquivos de `scripts/organizador/`:
- `scripts/organizador/src/core.py`
- `scripts/organizador/src/renamer.py`
- `scripts/organizador/src/utils.py`
- `scripts/organizador/config/regras.json`
- `scripts/organizador/tests/test_organizer.py`
- `scripts/organizador/auto_nomear.sh`
- `scripts/organizador/desfazer.sh`
- `scripts/organizador/simular.sh`
- `scripts/organizador/calculadora_particoes.sh`

## Detailed Implementation Tasks

### 1. F7: Correção do falso positivo por "dio" (Word Boundary Matching)
- Em `scripts/organizador/src/core.py` (método de classificação por termos):
  - Ao verificar correspondência de `term_normalized` em `name_normalized`:
  - Se o termo for curto (<= 4 caracteres, como "dio"), NÃO faça simples substring `term_normalized in name_normalized`.
  - Use regex com limites de palavra: `re.search(r'\b' + re.escape(term_normalized) + r'\b', name_normalized)`.
  - Isso garante que "dio" case com "curso dio web" ou "dio_bootcamp", mas NUNCA case com "audio_gravacao.wav", "estudio.mp3" ou "episodio.mp4".

### 2. F8: Correção da Regex de Cópia no AutoNamer
- Em `scripts/organizador/src/renamer.py`:
  - Ajustar `DOWNLOAD_ARTIFACTS_REGEX`:
  - Garantir word boundary em `copia` e `copy` (ex: `r'(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia\b|\s*-\s*copy\b|\b(?:c[oó]pia|copy)\b)'`).
  - Suportar prefixo `^c[oó]pia de\s*` (como em "Cópia de documento.pdf").
  - Testar para garantir que `fotocopiadora.pdf` permaneça `fotocopiadora.pdf` (NUNCA `fotodora.pdf`).

### 3. F9: Slugificação e Sanitização Robusta
- Em `scripts/organizador/src/utils.py`:
  - Adicionar/aprimorar a função `slugify_filename(name, remove_accents=True, lowercase_ext=True, safe_chars=True)`:
    - Normalização Unicode NFKD para remover acentos (`ç` -> `c`, `ã` -> `a`, `é` -> `e`).
    - Conversão da extensão de arquivo para minúsculas (`.PDF` -> `.pdf`, `.MP4` -> `.mp4`).
    - Remoção ou substituição de caracteres proibidos em sistemas de arquivos e nuvem (`:`, `?`, `*`, `"`, `<`, `>`, `|`, `;`, `#`, `$`, `%`, `&`).
    - Preservação da integridade de datas ISO (`YYYY-MM-DD`).

### 4. F10: Tratamento Aprimorado de Pastas e Subdiretórios
- Em `scripts/organizador/src/renamer.py`:
  - Estender o `AutoNamer` para suportar higienização e sanitização de nomes de diretórios (ex: método `sanitize_directory_name` ou parâmetro em `sanitize_name`), permitindo padronizar pastas baixadas de nuvens ou e-mails.
- Em `scripts/organizador/src/core.py`:
  - No método `clean_empty_directories`:
    - Antes de verificar se a pasta está vazia, detectar arquivos residuais de lixo/metadados (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`, `.directory`).
    - Se a pasta contiver APENAS esses arquivos de lixo, remover os arquivos de lixo e então remover a pasta vazia.

### 5. F11: Proteção Contra Arquivos 0-Byte
- Em `scripts/organizador/src/core.py` (ou `src/dedup.py`):
  - Adicionar proteção para que arquivos de 0 bytes (downloads corrompidos/interrompidos) sejam detectados e tratados (quarentena ou alerta, nunca substituindo nem colidindo com arquivos válidos já existentes).

### 6. F12: Correção dos Scripts Shell de Conveniência
- Em `auto_nomear.sh`, `desfazer.sh`, `simular.sh` e `calculadora_particoes.sh`:
  - Corrigir a definição de `PROJECT_ROOT`:
    `PROJECT_ROOT="$SCRIPT_DIR"` (já que `main.py` está diretamente em `scripts/organizador/main.py`).

### 7. F13: Regras Canônicas para DAO e AGR
- Em `scripts/organizador/config/regras.json`:
  - Adicionar regras de classificação para arquivos de DAO e projetos da AGR:
    - Ex: regra para `dao-\\d+` / `trilha-04-dao` e projetos AGR (`mini-fiscalizacao`, `agr-vanilla-dojo`), direcionando para as rotas adequadas de desenvolvimento ou triagem.

### 8. F14: Expansão dos Testes Automatizados com Pytest
- Em `scripts/organizador/tests/test_organizer.py`:
  - Manter todos os 22 testes originais passando.
  - Adicionar testes cobrindo todas as melhorias:
    - `test_slugify_accents_and_special_chars`
    - `test_autonamer_artifacts_word_boundary` (verificar `fotocopiadora.pdf`)
    - `test_clean_empty_directories_with_junk_metadata` (verificar remoção de pastas com `desktop.ini` / `.DS_Store`)
    - `test_rule_matching_word_boundary_isolation` (verificar que "dio" não casa com "audio_gravacao.wav" ou "episodio.mp4")
    - `test_autonamer_directory_sanitization`
    - `test_zero_byte_file_protection`
  - Executar `pytest scripts/organizador/tests/` e garantir 100% de aprovação (todos os testes verdes).

### 9. Commit Semântico Cirúrgico
- Ao final, realizar commit semântico seguindo a convenção do projeto:
  `git add scripts/organizador/`
  `git commit -m "feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)"`
- Garantir `git status` limpo nas áreas de código.

## MANDATORY INTEGRITY WARNING
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.


## 2026-11-07T17:14:19Z
Você é o Specialist Worker para o Milestone 3: Aprimoramento da Ferramenta de Organização (scripts/organizador).

Seu diretório de trabalho exclusivo é: /home/lan/dotfiles/.agents/teamwork/worker_m3/
O arquivo de despacho com todas as instruções detalhadas está em: /home/lan/dotfiles/.agents/teamwork/worker_m3/DISPATCH.md
Consulte também:
- /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
- /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- /home/lan/dotfiles/.agents/teamwork/explorer_survey_2/handoff.md

Seus objetivos principais:
1. Implementar F7: Correção do falso positivo por "dio" via regex com limites de palavra (\b) para termos curtos (<= 4 chars) em scripts/organizador/src/core.py.
2. Implementar F8: Correção da regex de cópia em scripts/organizador/src/renamer.py (\b em copia/copy e prefixo ^c[oó]pia de\s*), garantindo que fotocopiadora.pdf não seja corrompido.
3. Implementar F9: Slugificação e sanitização robusta com slugify_filename em scripts/organizador/src/utils.py (NFKD sem acentos, extensão minúscula, caracteres permitidos/seguros).
4. Implementar F10: Tratamento aprimorado de pastas e subdiretórios (sanitização de nomes de pastas no AutoNamer e limpeza de pastas contendo metadados de lixo desktop.ini/.DS_Store em clean_empty_directories).
5. Implementar F11: Proteção contra arquivos 0-byte (downloads corrompidos/interrompidos).
6. Implementar F12: Correção de PROJECT_ROOT="$SCRIPT_DIR" nos scripts shell auto_nomear.sh, desfazer.sh, simular.sh e calculadora_particoes.sh.
7. Implementar F13: Regras canônicas para DAO e AGR em config/regras.json.
8. Implementar F14: Expansão da suíte de testes em scripts/organizador/tests/test_organizer.py cobrindo todos os cenários e garantindo 100% de aprovação no pytest (pytest scripts/organizador/tests/).
9. Realizar commit semântico cirúrgico no Git:
   git add scripts/organizador/
   git commit -m "feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)"
10. Produzir relatório detalhado em /home/lan/dotfiles/.agents/teamwork/worker_m3/handoff.md e enviar mensagem ao orquestrador.
