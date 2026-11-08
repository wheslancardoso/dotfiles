# Independent Review & Adversarial Challenge Report — Milestone 3

**Agent**: `teamwork_reviewer_critic` (reviewer_m3_2)  
**Date**: 2026-11-07  
**Scope**: Milestone 3 — Aprimoramento de scripts/organizador (Features F7 a F14)  
**Commit Inspected**: `18938b0160a2c9e629e25107f049d2c01815f038`  
**Verdict**: **APPROVE**  
**Adversarial Risk Assessment**: **LOW**  

---

## 1. Observation

### 1.1 Independent Test Execution
- Executado `pytest scripts/organizador/tests/ -v`:
  ```
  platform linux -- Python 3.12.14, pytest-9.1.1, pluggy-1.6.0
  rootdir: /home/lan/dotfiles
  collected 29 items
  scripts/organizador/tests/test_organizer.py::TestOrganizadorMaster::test_anti_collision_naming PASSED [  3%]
  ...
  scripts/organizador/tests/test_organizer.py::TestOrganizadorMaster::test_zero_byte_file_protection PASSED [100%]
  ============================== 29 passed in 0.09s ==============================
  ```
- Executado `python3 -m unittest discover scripts/organizador/tests`:
  ```
  Ran 29 tests in 0.055s
  OK
  ```
- Todos os 29 testes foram aprovados de forma síncrona e genuína, com tempo de execução inferior a 100ms.

### 1.2 Git Commit & Staging Inspection (`18938b0`)
- Executado `git log -1 --stat 18938b0`:
  ```
  commit 18938b0160a2c9e629e25107f049d2c01815f038 (HEAD -> main)
  Author: wheslancardoso <wheslancardoso1@gmail.com>
  Date:   Sat Nov 7 14:25:25 2026 -0300

      feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)

   scripts/organizador/auto_nomear.sh           |   2 +-
   scripts/organizador/calculadora_particoes.sh |   2 +-
   scripts/organizador/config/regras.json       |  39 +++++++
   scripts/organizador/desfazer.sh              |   2 +-
   scripts/organizador/simular.sh               |   2 +-
   scripts/organizador/src/core.py              |  70 +++++++++++-
   scripts/organizador/src/renamer.py           |  50 +++++----
   scripts/organizador/src/utils.py             |  42 +++++++
   scripts/organizador/tests/test_organizer.py  | 158 ++++++++++++++++++++++++++-
   9 files changed, 340 insertions(+), 27 deletions(-)
  ```
- Verificação do workspace: 0 arquivos fora de `scripts/organizador/` foram comitados. Zero poluição colateral.

### 1.3 Implementation Inspection
1. **F7 (Word Boundary para Termos Curtos)**:
   - Em `scripts/organizador/src/core.py:261-268`:
     ```python
     if len(term_normalized) <= 4:
         pattern = rf"(?<![a-z0-9]){re.escape(term_normalized)}(?![a-z0-9])"
         if re.search(pattern, name_normalized) or re.search(rf"\b{re.escape(term_normalized)}\b", name_normalized):
             return self.dest_root / dest_rel
     elif term_normalized in name_normalized:
         return self.dest_root / dest_rel
     ```
   - Teste de colisão executado: `audio_gravacao.wav`, `estudio_podcast.mp3`, `meu_episodio_de_podcast.mp4` retornaram `None`.
   - Teste positivo executado: `curso dio web.pdf`, `dio_bootcamp.pdf`, `dio-bootcamp.pdf`, `dio.pdf` retornaram `/mnt/dados/02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes`.
2. **F8 (Correção da Regex de Cópias no AutoNamer)**:
   - Em `scripts/organizador/src/renamer.py:28-32`:
     ```python
     COPY_PREFIX_REGEX = re.compile(r"^c[oó]pia\s+de\s*", re.IGNORECASE)
     DOWNLOAD_ARTIFACTS_REGEX = re.compile(
         r"(^c[oó]pia\s+de\s*|\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia\b|\s*-\s*copy\b|\b(?:c[oó]pia|copy)\b)",
         re.IGNORECASE,
     )
     ```
   - `AutoNamer.sanitize_name('fotocopiadora.pdf')` retornou exatamente `'fotocopiadora.pdf'`.
   - `AutoNamer.sanitize_name('Cópia de documento importante.pdf')` retornou `'documento_importante.pdf'`.
3. **F9 (Slugificação e Sanitização Universal)**:
   - Em `scripts/organizador/src/utils.py:56-95`: implementação de `slugify_filename` com `unicodedata.normalize("NFKD")`, conversão de extensão para minúsculas (`.PDF` -> `.pdf`), substituição de caracteres proibidos (`: ? * " < > | ; # $ % & / \\`) por espaços antes da normalização de underscores, e colapso de underscores repetidos mantendo datas ISO intactas.
4. **F10 (Metadados Residuais e Sanitização de Diretórios)**:
   - Em `scripts/organizador/src/core.py:475-520`: `clean_empty_directories` detecta metadados residuais (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `.directory`, `:Zone.Identifier`). Se uma pasta contiver apenas esses metadados, eles são expurgados com `junk.unlink()` e a pasta é removida. Se houver arquivos legítimos, a pasta e seus arquivos são preservados.
   - Em `scripts/organizador/src/renamer.py:54-64`: implementação de `AutoNamer.sanitize_directory_name`.
5. **F11 (Proteção Contra Arquivos 0-Byte)**:
   - Em `scripts/organizador/src/core.py:79-84`, `370-380`, `447-455`: `FileOrganizerEngine.is_zero_byte` implementado. Rejeita sobrescrita de arquivos válidos existentes no destino em `move_item`. Registra `stats["zero_bytes"]` e direciona para quarentena ou ignora no `organize_directory`.
6. **F12 (Correção de `PROJECT_ROOT` nos Wrappers Shell)**:
   - `auto_nomear.sh`, `calculadora_particoes.sh`, `desfazer.sh`, `simular.sh`: corrigidos para `PROJECT_ROOT="$SCRIPT_DIR"`. Execuções de teste com `--help` e cálculo de partição executaram com código de saída 0.
7. **F13 (Regras Canônicas de DAO e AGR)**:
   - `config/regras.json:288-326`: regras `dev_projetos_agr_e_fiscalizacao` (prioridade 90) e `dev_trilha_dao_backend` (prioridade 80) inseridas com padrões regex e termos completos.
   - `dao-01.mp4`, `dao-09.mp4`, `trilha-04-dao-projeto.zip`, `mini-fiscalizacao.zip`, `agr-vanilla-dojo.tar.gz` classificados para `04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps`.
8. **F14 (Expansão da Cobertura de Testes Unitários)**:
   - De 22 para 29 testes em `scripts/organizador/tests/test_organizer.py`.

---

## 2. Logic Chain

1. **Validação da Causa-Raiz e Soluções (F7 a F14)**:
   - O bug de substring "dio" ocorria porque `"dio" in "audio_gravacao"` é True. O uso de `rf"(?<![a-z0-9]){re.escape(term_normalized)}(?![a-z0-9])"` restringe a correspondência a fronteiras alfanuméricas (`_`, `-`, espaços, pontuação), eliminando o falso positivo sem quebrar correspondências legítimas como `dio_bootcamp.pdf` ou `curso dio web.pdf`.
   - O bug da regex de cópia ocorria pela falta de `\b` em `copia`, casando com `fotocopiadora`. A inclusão de `\b(?:c[oó]pia|copy)\b` resolveu o problema sem efeitos colaterais.
   - A separação de `slugify_filename` em `src/utils.py` centralizou a normalização, permitindo que tanto arquivos quanto diretórios sejam limpos sob o mesmo padrão canônico.
   - A purga de metadados residuais em `clean_empty_directories` evita acúmulo de pastas "fantasmas" geradas pelo Windows Explorer ou macOS.
   - A verificação de `is_zero_byte` no motor assegura que arquivos corrompidos ou downloads incompletos (como o observado em `dao-09.mp4` antes do M2) nunca sobrescrevam arquivos saudáveis no disco.
   - O ajuste de `PROJECT_ROOT="$SCRIPT_DIR"` sincroniza todos os 5 scripts de conveniência com o comportamento padrão de execução a partir da pasta `scripts/organizador`.

2. **Auditoria de Integridade**:
   - Não foram encontrados gabaritos hardcodados, condicionais falsas baseadas em nomes de teste ou métodos dummy.
   - Os testes utilizam diretórios temporários isolados (`tempfile.mkdtemp`), criam arquivos físicos reais, executam os fluxos do motor e verificam os efeitos colaterais no filesystem.

---

## 3. Caveats

- **Execução do Tesseract OCR e pypdf**:
  Caso o binário `tesseract` ou a biblioteca `pypdf` não estejam presentes no sistema, os fallbacks graciosos (regex binária e retorno de string vazia) entram em ação sem interromper a execução do motor. Ambos os caminhos foram validados.
- **Não interferência em dados reais**:
  Nenhum diretório fora de `scripts/organizador/` foi modificado durante o Milestone 3.

---

## 4. Conclusion

O Milestone 3 cumpre 100% dos requisitos técnicos estipulados em `PROJECT.md` (Features F7 a F14) e `ORIGINAL_REQUEST.md`:
- Veredito da Revisão Técnica: **APPROVE**.
- Veredito de Integridade: **CONFORME** (0 violações de integridade, 0 dados fabricados, 0 atalhos artificiais).

---

## 5. Verification Method

Para reproduzir e auditar as verificações realizadas:

```bash
# 1. Executar suíte de testes completa via pytest
pytest scripts/organizador/tests/ -v

# 2. Executar suíte de testes nativa unittest
python3 -m unittest discover scripts/organizador/tests

# 3. Teste de isolamento de termo curto e regex
python3 -c "
from pathlib import Path
from scripts.organizador.src.core import FileOrganizerEngine
from scripts.organizador.src.renamer import AutoNamer
e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json'))
assert e.classify_file(Path('audio_gravacao.wav')) is None
assert 'Cursos_e_Certificacoes' in str(e.classify_file(Path('dio_bootcamp.pdf')))
assert AutoNamer.sanitize_name('fotocopiadora.pdf') == 'fotocopiadora.pdf'
assert AutoNamer.sanitize_name('Cópia de documento importante.pdf') == 'documento_importante.pdf'
print('VERIFICACAO CONCLUIDA COM SUCESSO!')
"

# 4. Teste de execução dos scripts shell
bash scripts/organizador/simular.sh --help > /dev/null && echo "simular.sh OK"
bash scripts/organizador/desfazer.sh --help > /dev/null && echo "desfazer.sh OK"
echo "512" | bash scripts/organizador/calculadora_particoes.sh > /dev/null && echo "calculadora_particoes.sh OK"
```

---

## 6. Review Summary (Quality Review)

**Verdict**: **APPROVE**

### Findings
- **[Minor] Finding 1**: Edge Case de Sanitização em Arquivos cujo nome é puramente artefato (`copia.pdf`).
  - *Onde*: `scripts/organizador/src/renamer.py:78-90` e `scripts/organizador/src/utils.py:69-75`.
  - *O que acontece*: Se um arquivo for batizado exclusivamente como `copia.pdf` ou `copy.docx`, a remoção do artefato deixa o stem vazio (`""`), gerando `cleaned_file = ".pdf"`. O `pathlib.Path(".pdf")` trata `".pdf"` como stem oculto com extensão vazia (`ext=""`), contornando o fallback `if not stem: stem = "arquivo"` e resultando em `2026-11-07_.pdf` no `generate_new_name`.
  - *Sugestão de melhoria futura*: Em `AutoNamer.sanitize_name`, incluir `if not stem.strip(): stem = "arquivo"` antes de concatenar `f"{stem}{suffix}"`.
  - *Impacto*: Baixo/Trivial. Não bloqueia o milestone, pois se trata de um edge case raro e a ferramenta não falha em runtime.

### Verified Claims
- `F7` (Word Boundary "dio" e termos <= 4) -> Verificado via Python direto e pytest -> **PASS**
- `F8` (Correção regex cópias e preservação de fotocopiadora) -> Verificado -> **PASS**
- `F9` (Slugificação Unicode NFKD e safe chars) -> Verificado -> **PASS**
- `F10` (Limpeza de metadados residuais em pastas vazias) -> Verificado em árvore aninhada -> **PASS**
- `F11` (Proteção contra arquivos de 0 bytes) -> Verificado com symlinks, arquivos reais e rejeição de sobrescrita -> **PASS**
- `F12` (Caminhos corretos nos scripts shell) -> Verificado com execução direta -> **PASS**
- `F13` (Regras de DAO e projetos AGR) -> Verificado com regex e termos em regras.json -> **PASS**
- `F14` (29 testes unitários) -> Verificado (29/29 passados em pytest e unittest) -> **PASS**

### Coverage Gaps
- Nenhuma lacuna crítica de dependências ou chamada não coberta.

### Unverified Items
- Nenhum.

---

## 7. Adversarial Challenge Report

**Overall Risk Assessment**: **LOW**

### Challenges

#### [Low] Challenge 1: Filename Stem Exclusively Composed of Artifacts
- **Assumption Challenged**: Presumiu-se que todo arquivo submetido ao `AutoNamer` possui um nome significativo além dos artefatos de download (`copia`, `copy`, `(1)`).
- **Attack Scenario**: Usuário baixa um arquivo renomeado pelo sistema para `copia.pdf` ou `(1).pdf`. O `DOWNLOAD_ARTIFACTS_REGEX` remove todo o stem.
- **Blast Radius**: O arquivo renomeado ganha nome de arquivo oculto no Linux (`.pdf` ou `2026-11-07_.pdf`). Nenhum dado é perdido ou corrompido.
- **Mitigation**: Garantir `stem = stem or "arquivo"` antes de montar `cleaned_file`.

#### [Low] Challenge 2: Regex Compilation Inside Loop for Short Terms
- **Assumption Challenged**: Compilar `rf"(?<![a-z0-9]){re.escape(term_normalized)}(?![a-z0-9])"` dinamicamente para cada termo `<= 4` em `classify_file` não causa gargalo perceptível.
- **Attack Scenario**: Varredura de dezenas de milhares de arquivos pequenos em loop contínuo.
- **Blast Radius**: Pequeno aumento de CPU (amenizado pelo cache interno `re._cache`). Na suíte de testes de 29 itens o tempo total foi de apenas 55ms.
- **Mitigation**: Pré-compilar as regexes de fronteira na inicialização das regras em `_load_advanced_rules`.

### Stress Test Results
- `fotocopiadora.pdf` não é corrompido -> **PASS**
- `Cópia de documento.pdf` tem prefixo removido com sucesso -> **PASS**
- `audio_gravacao.wav` e `estudio_podcast.mp3` não colidem com "dio" -> **PASS**
- `dio_bootcamp.pdf` e `curso dio web.pdf` classificam corretamente -> **PASS**
- `clean_empty_directories` com `.DS_Store` e `desktop.ini` aninhados -> Remove todas as pastas residuais vazias e preserva pastas com arquivos válidos -> **PASS**
- Symlink quebrado em `is_zero_byte` -> Trata com segurança (retorna False sem levantar exceção) -> **PASS**
- `move_item` com arquivo de 0 bytes contra arquivo válido existente -> Rejeita sobrescrita e preserva integridade do arquivo de destino -> **PASS**

### Unchallenged Areas
- Nenhum item relevante ficou fora do teste de estresse.
