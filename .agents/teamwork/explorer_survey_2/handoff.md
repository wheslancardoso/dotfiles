# Relatório de Investigação Forense & Survey: Aprimoramento do Organizador (R3)

**Autor**: `teamwork_explorer` (explorer_survey_2)  
**Data**: 2026-11-07  
**Alvo**: `scripts/organizador` e Requisito R3 (Ferramenta de Organização)  
**Status**: Concluído  

---

## 1. Observation

### 1.1 Status da Suíte de Testes Atual
Execução do comando de testes do projeto:
```bash
pytest scripts/organizador/tests/
```
**Resultado verificado**:
```text
============================= test session starts ==============================
platform linux -- Python 3.12.14, pytest-9.1.1, pluggy-1.6.0
rootdir: /home/lan/dotfiles
plugins: anyio-4.15.1
collecting ... collected 22 items

scripts/organizador/tests/test_organizer.py ......................       [100%]

============================== 22 passed in 0.12s ==============================
```
Todos os 22 testes unitários atuais passam com sucesso. Contudo, há lacunas severas de cobertura para casos de borda e comportamentos reais.

---

### 1.2 Arquitetura de `scripts/organizador`
A ferramenta é composta por:
1. `main.py`: Ponto de entrada CLI que configura `sys.path` e invoca `src.cli.run_cli()`.
2. `src/cli.py`: Parser de argumentos (`argparse`) com 19 opções (`--all`, `--desktop`, `--downloads`, `--drive`, `--scaffold-only`, `--dry-run`, `--dest`, `--undo`, `--history`, `--auto-date`, `--sanitize`, `--calc-disk`, `--recursive`, `--audit`/`--doctor`, `--dedup`, `--media`, `--quarantine-dir`, `--watch`, `--clean-empty`, `--aging`, `--purge-installers`).
3. `src/core.py` (`FileOrganizerEngine`): Motor de classificação e movimentação com 6 estágios:
   - Estágio 1: Regras avançadas (`regras_avancadas`) ordenadas por prioridade descrescente (regex, termos, restrições de extensão e tamanho).
   - Estágio 2: Deep content sniffing (`sniff_file_content`) para `.txt`, `.md`, `.json`, `.csv`, `.html`, `.docx`, `.pdf`.
   - Estágio 3: OCR sniffing visual em imagens (`sniff_image_content`) via Tesseract.
   - Estágio 4: Similaridade fuzzy estrita (`difflib.SequenceMatcher`, ratio >= 0.90, palavras >= 6 caracteres).
   - Estágio 5: Regras diretas por extensão (`regras_extensoes`).
   - Estágio 6: Fallback de documentos não classificados para `00_Inbox_Triagem`.
4. `src/renamer.py` (`AutoNamer`): Higienização e prefixação de datas ISO (`YYYY-MM-DD_`).
5. `src/utils.py`: Normalização de texto NFKD (`normalize_text`), resolução de colisões de nomes (`get_unique_destination_path`), cores e logs de terminal.
6. `src/taxonomy.py` (`TaxonomyManager`): Criação idempotente dos diretórios numerados `00..06` e injeção de `.gitkeep`.
7. `src/history.py` (`HistoryManager`): Registro de transações em `~/.organizador_master_history.json` e suporte a rollback (`--undo`).
8. `src/dedup.py` (`HashDeduplicator`, `MediaDeduplicator`): Desduplicação criptográfica SHA-256 e análise de vídeo via `ffprobe`.
9. `src/doctor.py` (`SystemDoctor`): Diagnóstico e auditoria de saúde da taxonomia (score 0–100, pontuação de arquivos soltos, metadados e estagnação no Inbox).
10. `src/watcher.py` (`DirectoryWatcher`): Daemon em tempo real com polling nativo, debounce e checagem de descritores via `fuser`.
11. `src/partition_calc.py` (`PartitionCalculator`): Cálculo de dimensionamento ótimo para partições de SSD.
12. `config/regras.json`: Configuração canônica de taxonomia e 22 regras avançadas.
13. Scripts de conveniência em shell: `organizar.sh`, `auto_nomear.sh`, `desfazer.sh`, `simular.sh`, `calculadora_particoes.sh`, `vincular_linux.sh`.

---

### 1.3 Falhas e Deficiências Observadas Diretamente no Código

#### A. Tratamento de Pastas e Subdiretórios
1. **Divergência entre `recursive=True` e `recursive=False` (`src/core.py`, linhas 395–400)**:
   ```python
   items = list(target_dir.rglob("*") if recursive else target_dir.iterdir())
   for item in items:
       # Se for diretório dentro de varredura recursiva, pula para focar em arquivos
       if item.is_dir() and recursive:
           continue
   ```
   - Em modo não recursivo (`recursive=False`), `item.is_dir()` **não é ignorado**. O diretório é passado para `classify_file(item)`. Se o nome da pasta der match com alguma regra, `move_item` move a pasta inteira com todo o conteúdo interno via `shutil.move`.
   - Em modo recursivo (`recursive=True`), diretórios são **ignorados**, mas seus arquivos internos são processados individualmente. Se os arquivos internos tiverem nomes genéricos (ex: `arquivo1.txt`, `video.mp4`), eles perdem o contexto da pasta pai, são movidos para locais genéricos (como `00_Inbox_Triagem`), e a pasta de origem é abandonada vazia no diretório de origem.
2. **Colisão de Diretórios em `move_item` (`src/core.py`, linha 343; `src/utils.py`, linhas 77–94)**:
   - Se um diretório de mesmo nome já existir no destino, `get_unique_destination_path` cria um sufixo numérico de pasta (`pasta_1`, `pasta_2`), em vez de realizar mesclagem inteligente (*merge*) ou reconciliação de conteúdo.
3. **Falha de Limpeza de Pastas Residuais com Metadados (`src/core.py`, linhas 446–453)**:
   ```python
   entries = list(current_path.iterdir())
   if len(entries) == 0:
       ...
       current_path.rmdir()
   ```
   - Se uma pasta residual deixada por downloads contiver apenas metadados ou arquivos ignorados (ex: `desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`), `len(entries)` é maior que 0. A função não limpa esses arquivos de lixo e a pasta permanece abandonada no disco. Teste com `desktop.ini` resultou em `Cleaned count: 0; Folder still exists: True`.
4. **`AutoNamer` Ignora Diretórios Completamente (`src/renamer.py`, linhas 120–121)**:
   ```python
   for item in items:
       if item.is_dir():
           continue
   ```
   - O módulo de renomeação não oferece capacidade de higienizar ou padronizar nomes de subpastas (ex: pastas criadas pelo Google Takeout como `Apostilas Senai-20260830T212333Z-1-001` ou `Minha personalidade _`).

#### B. Nomenclatura, Higienização e Slugificação
1. **RegEx de Artefatos Degenerativo (`src/renamer.py`, linhas 27–30)**:
   ```python
   DOWNLOAD_ARTIFACTS_REGEX = re.compile(
       r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy)",
       re.IGNORECASE,
   )
   ```
   - A expressão `\s*copia` sem limite de palavra (`\b`) corrompe substantivos válidos.
   - **Verificação via terminal**:
     ```bash
     python3 -c "from scripts.organizador.src.renamer import AutoNamer; print(AutoNamer.sanitize_name('fotocopiadora.pdf'))"
     # Resultado: fotodora.pdf
     ```
   - Além disso, a regex não remove prefixos clássicos do Windows como `"Cópia de "` (`^c[oó]pia de\s*`), que já havia sido implementado isoladamente em `organizar_ferramentas.py:12`, mas não no motor central.
2. **Ausência de Remoção de Acentos e Caracteres Especiais Inválidos em `AutoNamer`**:
   - `sanitize_name` apenas substitui espaços por underscores e remove artefatos. Acentos (`ç`, `ã`, `é`) e caracteres problemáticos para sistemas de arquivos (`:`, `?`, `*`, `"`, `<`, `>`, `|`, `;`, `#`, `$`, `%`, `&`) são mantidos intactos.
   - O guia oficial (`docs/GUIA_NOMENCLATURA.md`) estipula: `[DATA_ISO]_[CATEGORIA_OU_PROJETO]_[DESCRICAO-CLARA]_[VERSAO_OU_STATUS].[EXT]`, livre de caracteres especiais.
3. **Não Padronização de Extensões em Caixa Alta**:
   - `path.suffix` é preservado com o case original. Arquivos como `.PDF`, `.MP4`, `.PNG` não são convertidos para minúsculas (`.pdf`, `.mp4`, `.png`).
4. **Vulnerabilidade a Arquivos de 0 Bytes e Downloads Corrompidos**:
   - Na pasta `00_Inbox_Triagem`, constatou-se a presença de `dao-09.mp4` (0 bytes, download interrompido) e `dao-09 (1).mp4` (37.049.183 bytes).
   - `organize_directory` processa arquivos de 0 bytes sem checagem de integridade, permitindo que arquivos corrompidos ocupem o nome principal e empurrem arquivos íntegros para `_1`.

#### C. Lógica de Regras e Resolução de Conflitos
1. **Falso Positivo Crítico por Substring sem Word Boundary (`src/core.py`, linhas 237–240; `config/regras.json`, linha 299)**:
   ```python
   terms = rule.get("termos", [])
   for term in terms:
       term_normalized = normalize_text(term)
       if term_normalized in name_normalized:
           return self.dest_root / dest_rel
   ```
   - A regra `cursos_e_certificacoes_senai_e_redes` (prioridade 70) contém o termo `"dio"` (Digital Innovation One).
   - Como a verificação é por substring bruta (`in`), qualquer arquivo cujo nome contenha `"dio"` é classificado como curso do SENAI!
   - **Verificação via terminal**:
     ```bash
     python3 -c "
     from pathlib import Path
     from scripts.organizador.src.core import FileOrganizerEngine
     engine = FileOrganizerEngine(Path('scripts/organizador/config/regras.json'))
     print('audio_gravacao.wav ->', engine.classify_file(Path('audio_gravacao.wav')))
     print('estudio_podcast.mp3 ->', engine.classify_file(Path('estudio_podcast.mp3')))
     print('meu_episodio_de_podcast.mp3 ->', engine.classify_file(Path('meu_episodio_de_podcast.mp3')))
     "
     ```
     **Saída**:
     ```text
     audio_gravacao.wav -> /mnt/dados/02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes
     estudio_podcast.mp3 -> /mnt/dados/02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes
     meu_episodio_de_podcast.mp3 -> /mnt/dados/02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes
     ```
   - Arquivos de áudio legítimos nunca chegam na regra de áudio (`design_audios_e_samples`, prioridade 60) por causa do match prematuro de `"dio"`.
2. **Inexistência de Regras para Aulas de DAO e Projetos Vanilla da AGR**:
   - `config/regras.json` possui regras para TCE-GO e AGR de trânsito/frequência, mas zero regras para os mini-sistemas governamentais do Dojo AGR (`agr-vanilla-dojo`, `mini-fiscalizacao`) e aulas de DAO (`dao-01.mp4` a `dao-11.mp4`).
   - `classify_file(Path('dao-01.mp4'))` retorna `None`.

#### D. Erro de Caminho nos Scripts de Shell
1. **Erro de Invocação de `main.py` nos Scripts Utilitários**:
   - Nos scripts `auto_nomear.sh:5`, `desfazer.sh:5`, `simular.sh:5` e `calculadora_particoes.sh:5`:
     ```bash
     SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
     PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
     ...
     cd "$PROJECT_ROOT" || exit 1
     python3 main.py ...
     ```
   - Se o script está em `scripts/organizador/`, `dirname "$SCRIPT_DIR"` resulta em `scripts/`.
   - Como `main.py` está em `scripts/organizador/main.py` e não em `scripts/main.py`, qualquer execução desses 4 scripts falha com erro:
     ```text
     python3: can't open file '/home/lan/dotfiles/scripts/main.py': [Errno 2] No such file or directory
     ```
   - Apenas `organizar.sh` utiliza corretamente `PROJECT_ROOT="$SCRIPT_DIR"`.

---

## 2. Logic Chain

1. **Da observação de 22 testes passando para a necessidade de expansão da suíte**:
   - A suíte atual em `test_organizer.py` testa apenas cenários de sucesso idealizados (nomes limpos com espaço simples, pastas vazias sem metadados, termos compostos como `"edital tce"`). Nenhum teste cobre colisões de substrings curtas (`"dio"` em `"audio"`), diretórios com metadados residuais, arquivos de zero bytes, scripts de shell ou normalização de extensões em maiúsculas.
2. **Da observação do match de `"dio"` para o requisito de correspondência por limites de palavra (*word boundary*)**:
   - `name_normalized` contém palavras concatenadas ou separadas por underline/espaço. A checagem `term_normalized in name_normalized` não exige limites de palavra. Para termos curtos (≤ 4 caracteres), o matching por substring gera falsos positivos inevitáveis em português e inglês. A solução lógica é compilar regex com limites `\b` ou tokenizar palavras para termos isolados.
3. **Da observação de `fotocopiadora.pdf` -> `fotodora.pdf` para a reformulação da regex de artefatos**:
   - A regex `\s*copia` remove qualquer ocorrência da sequência `copia`, mesmo em meio a palavras compostas. A regex deve exigir `\b` antes e depois (`\b(c[oó]pia|copy)\b`) ou separadores explícitos (`[-_]\s*c[oó]pia`).
4. **Da observação do comportamento de `recursive=True` para a necessidade de preservação de contexto de pastas**:
   - No modo recursivo, ignorar diretórios sem antes extrair seu nome faz com que arquivos genéricos dentro de pastas temáticas percam a classificação correta. Uma pasta como `Aulas_DAO/aula01.mp4` deve herdar o contexto `Aulas_DAO` para classificação antes do roteamento individual, e pastas vazias devem ser limpas automaticamente ao término da operação.
5. **Da observação do erro nos scripts `.sh` para a correção de `PROJECT_ROOT`**:
   - Nos scripts `auto_nomear.sh`, `desfazer.sh`, `simular.sh` e `calculadora_particoes.sh`, definir `PROJECT_ROOT="$SCRIPT_DIR"` (como já feito em `organizar.sh`) resolve imediatamente o erro de arquivo não encontrado.

---

## 3. Caveats

1. **Restrição Read-Only**: Esta investigação operou exclusivamente em modo de leitura e análise diagnóstica, sem modificar arquivos de código-fonte de `scripts/organizador` nem a configuração de produção `config/regras.json`.
2. **Dependências Opcionais**: As ferramentas Tesseract OCR e `ffprobe` são utilitários externos do sistema operacional. Quando ausentes ou com timeout, o motor realiza fallback gracioso, o que é um comportamento resiliente e deve ser mantido.
3. **Escopo Delimitado**: A investigação focou estritamente no requisito R3 (aprimoramento de `scripts/organizador`), relacionando-o com R2 (arquivos de DAO identificados em `00_Inbox_Triagem`) e R4 (espelhamento Drive) apenas para fins de interoperabilidade.

---

## 4. Conclusion

A ferramenta `scripts/organizador` possui uma base arquitetural sólida e modular, com bom desacoplamento de responsabilidades e histórico com suporte a rollback. No entanto, para cumprir integralmente o requisito **R3**, é imperativo implementar 5 melhorias estruturais no Milestone M3:

### Recomendações Técnicas para o Milestone M3

1. **Correção do Motor de Regras e Matching (`src/core.py` e `config/regras.json`)**:
   - Implementar verificação com limites de palavras (`\b`) para termos curtos (≤ 4 letras) ou tokenização de palavras, eliminando a colisão de `"dio"` que sequestra áudios legítimos.
   - Adicionar regras canônicas para o projeto AGR e aulas de DAO no `regras.json` (ex: `dao-\\d+`, `mini-fiscalizacao`, `agr-vanilla-dojo`), direcionando-os para `04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps` ou destinação dedicada.
2. **Aprimoramento de Slugificação e Higienização (`src/renamer.py` e `src/utils.py`)**:
   - Corrigir `DOWNLOAD_ARTIFACTS_REGEX` para exigir `\b` em `copia`/`copy` e suportar prefixo `^c[oó]pia de\s*`.
   - Adicionar função robusta `slugify_filename(name, remove_accents=True, lowercase_ext=True, safe_chars=True)` que:
     - Remove acentos via decomposição NFKD.
     - Converte extensões para minúsculas (`.PDF` -> `.pdf`).
     - Remove caracteres perigosos para arquivos e nuvem (`:`, `?`, `*`, `"`, `<`, `>`, `|`, `;`, `#`, `$`, `%`, `&`).
     - Preserva ou formata datas ISO de acordo com o `GUIA_NOMENCLATURA.md`.
   - Estender `AutoNamer` para suportar renomeação e sanitização de nomes de **diretórios**, não apenas arquivos.
3. **Tratamento Inteligente de Pastas e Subdiretórios (`src/core.py`)**:
   - Em modo recursivo, avaliar primeiro se o nome da pasta pai possui match de alta prioridade antes de pulverizar arquivos órfãos.
   - Tornar a limpeza de diretórios vazios (`clean_empty_directories`) capaz de purgar metadados residuais ignorados (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`), permitindo a remoção completa de pastas fantasmas.
   - Implementar detecção de arquivos de 0 bytes (downloads incompletos como `dao-09.mp4`), evitando que corrompam a nomenclatura durante a organização.
4. **Correção dos Scripts Shell de Conveniência**:
   - Ajustar a variável `PROJECT_ROOT="$SCRIPT_DIR"` em `auto_nomear.sh`, `desfazer.sh`, `simular.sh` e `calculadora_particoes.sh`.
5. **Novos Testes Automatizados para a Suíte (`tests/test_organizer.py`)**:
   - `test_slugify_accents_and_special_chars`: Validação de acentos, caracteres proibidos e case de extensões.
   - `test_autonamer_artifacts_word_boundary`: Validação de `fotocopiadora.pdf` não virando `fotodora.pdf`.
   - `test_clean_empty_directories_with_junk_metadata`: Validação de remoção de pastas contendo apenas `desktop.ini` / `.DS_Store`.
   - `test_rule_matching_word_boundary_isolation`: Garantir que `audio.mp3` e `episodio.mp4` não sofram match de `"dio"`.
   - `test_autonamer_directory_sanitization`: Validação de higienização de pastas.
   - `test_zero_byte_file_protection`: Garantir que arquivos de 0 bytes não sobreponham arquivos válidos.

---

## 5. Verification Method

Para verificar de forma independente todas as observações e conclusões deste relatório:

1. **Verificar testes atuais**:
   ```bash
   pytest scripts/organizador/tests/
   ```
2. **Verificar erro do falso positivo `"dio"`**:
   ```bash
   python3 -c "from pathlib import Path; from scripts.organizador.src.core import FileOrganizerEngine; e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json')); print(e.classify_file(Path('audio_gravacao.wav')))"
   # Esperado observar: classificação incorreta para Cursos_e_Certificacoes
   ```
3. **Verificar erro da regex de cópia**:
   ```bash
   python3 -c "from scripts.organizador.src.renamer import AutoNamer; print(AutoNamer.sanitize_name('fotocopiadora.pdf'))"
   # Esperado observar: fotodora.pdf
   ```
4. **Verificar erro de caminho nos scripts shell**:
   ```bash
   bash scripts/organizador/simular.sh --help
   # Esperado observar: python3: can't open file .../scripts/main.py: No such file or directory
   ```
5. **Verificar pastas com metadados em `clean_empty_directories`**:
   ```bash
   python3 -c "import tempfile; from pathlib import Path; from scripts.organizador.src.core import FileOrganizerEngine; t = Path(tempfile.mkdtemp()); (t / 'd.ini').touch(); e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json')); print('Removed:', e.clean_empty_directories(t.parent))"
   ```
