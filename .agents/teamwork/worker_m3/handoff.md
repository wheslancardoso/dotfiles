# Handoff Report — Milestone 3: Aprimoramento da Ferramenta de Organização (scripts/organizador)

**Autor**: `teamwork_worker` (worker_m3)  
**Data**: 2026-11-07  
**Alvo**: `scripts/organizador/` (Features F7 a F14)  
**Status**: Concluído (100% de Aprovação nos Testes / Commit Cirúrgico Realizado)

---

## 1. Observation

Durante a investigação e implementação das melhorias em `scripts/organizador`, foram constatados diretamente os seguintes fatos:

### 1.1 Falso Positivo de "dio" (F7)
- **Localização**: `scripts/organizador/src/core.py:236-240`.
- **Comportamento prévio**:
  ```python
  terms = rule.get("termos", [])
  for term in terms:
      term_normalized = normalize_text(term)
      if term_normalized in name_normalized:
          return self.dest_root / dest_rel
  ```
  Na regra `cursos_e_certificacoes_senai_e_redes` (`config/regras.json`), o termo `"dio"` (Digital Innovation One) capturava indevidamente qualquer arquivo cujo nome contivesse `"dio"` como substring, incluindo `audio_gravacao.wav`, `estudio_podcast.mp3` e `meu_episodio_de_podcast.mp3`.
- **Comando de validação inicial**:
  `python3 -c "from pathlib import Path; from scripts.organizador.src.core import FileOrganizerEngine; e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json')); print(e.classify_file(Path('audio_gravacao.wav')))"`
  Retornava: `/mnt/dados/02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes`.

### 1.2 RegEx Degenerativa de Cópia (F8)
- **Localização**: `scripts/organizador/src/renamer.py:27-30`.
- **Expressão prévia**:
  ```python
  DOWNLOAD_ARTIFACTS_REGEX = re.compile(
      r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy)",
      re.IGNORECASE,
  )
  ```
- **Comportamento observado**:
  `AutoNamer.sanitize_name("fotocopiadora.pdf")` transformava o substantivo em `"fotodora.pdf"`. Além disso, prefixos como `"Cópia de documento.pdf"` não eram tratados.

### 1.3 Slugificação e Sanitização Incompleta (F9)
- **Localização**: `scripts/organizador/src/utils.py`.
- **Comportamento prévio**:
  Não existia uma função `slugify_filename` formalmente exposta. Nomes com acentos diacríticos (`ç`, `ã`, `é`), caracteres proibidos de filesystem/nuvem (`:`, `?`, `*`, `"`, `<`, `>`, `|`, `;`, `#`, `$`, `%`, `&`) e extensões em caixa alta (`.PDF`, `.MP4`) não eram normalizados de forma padronizada.

### 1.4 Diretórios com Metadados Residuais e Sanitização de Pastas (F10)
- **Localização**: `scripts/organizador/src/core.py:446` e `src/renamer.py`.
- **Comportamento prévio**:
  `clean_empty_directories` checava apenas `len(list(current_path.iterdir())) == 0`. Pastas contendo apenas arquivos de lixo (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`, `.directory`) eram ignoradas e permaneciam no disco. Além disso, `AutoNamer` ignorava diretórios em suas rotinas de sanitização.

### 1.5 Vulnerabilidade a Arquivos de 0 Bytes (F11)
- **Localização**: `scripts/organizador/src/core.py`.
- **Comportamento prévio**:
  Arquivos vazios gerados por downloads incompletos (ex: `dao-09.mp4` de 0 bytes) eram processados indistintamente, podendo empurrar ou colidir com arquivos íntegros de mesmo nome no destino.

### 1.6 Caminho Incorreto nos Scripts Shell (F12)
- **Localização**: `auto_nomear.sh:5`, `desfazer.sh:5`, `simular.sh:5`, `calculadora_particoes.sh:5`.
- **Comportamento prévio**:
  `PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"` apontava para `scripts/`, resultando em `python3: can't open file '.../scripts/main.py': [Errno 2] No such file or directory`.

### 1.7 Ausência de Regras para DAO e AGR Dev (F13)
- **Localização**: `scripts/organizador/config/regras.json`.
- **Comportamento prévio**:
  Arquivos como `dao-01.mp4`, `trilha-04-dao-setup.zip`, `mini-fiscalizacao.zip` e `agr-vanilla-dojo.tar.gz` resultavam em `None` ou fallback para `00_Inbox_Triagem`.

### 1.8 Cobertura de Testes (F14)
- **Baseline inicial**: 22 testes unitários em `scripts/organizador/tests/test_organizer.py`.

---

## 2. Logic Chain

1. **Correção de Word Boundary (F7)**:
   - Para termos curtos (`len(term_normalized) <= 4`), o teste de substring simples inevitavelmente causa falsos positivos em língua portuguesa e inglesa.
   - A solução lógica foi implementar regex com limites de palavra: união de `\b` com lookarounds de caracteres alfanuméricos `rf"(?<![a-z0-9]){re.escape(term_normalized)}(?![a-z0-9])"`, permitindo que delimitadores de nome de arquivo (`_`, `-`, `.`, espaços) sirvam de fronteira sem capturar substrings como `"audio"`, `"estudio"` ou `"episodio"`.
   - Resultado verificado: `audio_gravacao.wav` retorna `None` (ou regra de áudio), enquanto `curso dio web.pdf` e `dio_bootcamp.pdf` são classificados corretamente para `02.3_Cursos_e_Certificacoes`.

2. **Reformulação da Regex de Cópia e AutoNamer (F8 e F10)**:
   - Ao adicionar word boundary `\b` para `copia` e `copy` (`\b(?:c[oó]pia|copy)\b` e `-\s*c[oó]pia\b`), `"fotocopiadora.pdf"` não casa mais e permanece íntegro.
   - Adicionou-se `COPY_PREFIX_REGEX = re.compile(r"^c[oó]pia\s+de\s*", re.IGNORECASE)` para tratar arquivos clonados no formato "Cópia de X".
   - Implementou-se `AutoNamer.sanitize_directory_name` e suporte ao parâmetro `is_directory` em `sanitize_name`.

3. **Slugificação e Sanitização Universal (F9)**:
   - A função `slugify_filename` em `src/utils.py` implementa decomposição NFKD para acentos, conversão de extensões para minúsculas (`.PDF` -> `.pdf`), substituição de caracteres proibidos (`: ? * " < > | ; # $ % & / \`) por espaços, colapso de underscores e preservação estrita de datas ISO no formato `YYYY-MM-DD`.

4. **Purga de Metadados Residuais em Pastas Vazias (F10)**:
   - No método `clean_empty_directories`, antes de avaliar se a pasta está vazia, o motor detecta se todos os arquivos contidos são metadados de lixo (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`, `.directory`).
   - Se a pasta contiver apenas esses metadados, eles são removidos com `junk.unlink()` e a pasta é removida com `current_path.rmdir()`. Se houver arquivos legítimos, nada é excluído.

5. **Proteção Contra Arquivos 0-Byte (F11)**:
   - Criou-se o método `FileOrganizerEngine.is_zero_byte(path)`.
   - Em `move_item`, se o arquivo de origem possuir 0 bytes e já existir no diretório de destino um arquivo com o mesmo nome e tamanho > 0 bytes, a operação é rejeitada para evitar corrupção de dados.
   - Em `organize_directory`, arquivos de 0 bytes são contabilizados em `stats["zero_bytes"]`, alertados no console e, se configurado, enviados para quarentena isolada.

6. **Correção de `PROJECT_ROOT` nos Scripts Shell (F12)**:
   - Alterou-se `PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"` para `PROJECT_ROOT="$SCRIPT_DIR"` nos 4 scripts shell (`auto_nomear.sh`, `desfazer.sh`, `simular.sh`, `calculadora_particoes.sh`), sincronizando com o comportamento de `organizar.sh`.

7. **Regras Canônicas de DAO e AGR (F13)**:
   - Adicionaram-se as regras `dev_projetos_agr_e_fiscalizacao` (prioridade 90) e `dev_trilha_dao_backend` (prioridade 80) em `config/regras.json`, direcionando adequadamente para `04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps`.

8. **Expansão da Suíte de Testes (F14)**:
   - A suíte em `tests/test_organizer.py` foi expandida de 22 para 29 testes unitários, cobrindo todas as novas funcionalidades de forma genuína (sem atalhos, sem hardcoding).

---

## 3. Caveats

- **Ambiente de Testes Automatizados**: A biblioteca opcional `pypdf` e o binário do sistema `tesseract` são checados dinamicamente com fallback gracioso nos testes unitários caso não estejam instalados no PATH do sistema.
- **Não alteração de arquivos de dados do usuário**: Nenhuma alteração foi realizada em diretórios de produção fora de `scripts/organizador/`. O escopo foi estritamente cirúrgico e modular.

---

## 4. Conclusion

Todas as 8 tarefas do Milestone 3 (Features F7 a F14) foram implementadas com sucesso:
1. `F7`: Word Boundary Matching ativo no `core.py` eliminando colisões por substring em termos <= 4 chars.
2. `F8`: `AutoNamer` corrigido com word boundary e prefixo "Cópia de ", preservando `fotocopiadora.pdf`.
3. `F9`: `slugify_filename` implementada em `utils.py` com NFKD, minúsculas e safe chars.
4. `F10`: Limpeza de metadados residuais em `clean_empty_directories` e `sanitize_directory_name` no `AutoNamer`.
5. `F11`: Proteção contra 0-byte implementada em `core.py` (`is_zero_byte`, `move_item`, `organize_directory`).
6. `F12`: Scripts shell ajustados para `PROJECT_ROOT="$SCRIPT_DIR"`.
7. `F13`: Regras de DAO e projetos AGR adicionadas com sucesso em `regras.json`.
8. `F14`: Suíte de testes expandida para 29 testes (100% de aprovação no `pytest`).
9. `Git`: Commit semântico cirúrgico realizado:
   `feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)` (hash: `18938b0`).

---

## 5. Verification Method

Para verificar independentemente todo o trabalho realizado:

1. **Executar a suíte completa de testes com pytest**:
   ```bash
   pytest scripts/organizador/tests/ -v
   ```
   *Resultado esperado*: 29 testes coletados, 29 aprovados (100% pass), 0 falhas, 0 warnings.

2. **Executar a suíte de testes com o módulo nativo unittest**:
   ```bash
   python3 -m unittest discover scripts/organizador/tests
   ```
   *Resultado esperado*: `Ran 29 tests in ... OK`.

3. **Verificar a correção do falso positivo "dio"**:
   ```bash
   python3 -c "
   from pathlib import Path
   from scripts.organizador.src.core import FileOrganizerEngine
   e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json'))
   assert e.classify_file(Path('audio_gravacao.wav')) is None
   assert e.classify_file(Path('estudio_podcast.mp3')) is None
   assert 'Cursos_e_Certificacoes' in str(e.classify_file(Path('curso dio web.pdf')))
   print('F7 VERIFICADO COM SUCESSO!')
   "
   ```

4. **Verificar a integridade de "fotocopiadora.pdf"**:
   ```bash
   python3 -c "
   from scripts.organizador.src.renamer import AutoNamer
   assert AutoNamer.sanitize_name('fotocopiadora.pdf') == 'fotocopiadora.pdf'
   assert AutoNamer.sanitize_name('Cópia de documento.pdf') == 'documento.pdf'
   print('F8 VERIFICADO COM SUCESSO!')
   "
   ```

5. **Verificar os scripts shell**:
   ```bash
   bash scripts/organizador/simular.sh --help
   bash scripts/organizador/auto_nomear.sh --help
   ```
   *Resultado esperado*: Exibição imediata da ajuda do CLI do `main.py` sem erro de arquivo não encontrado.

6. **Verificar classificação de DAO e AGR**:
   ```bash
   python3 -c "
   from pathlib import Path
   from scripts.organizador.src.core import FileOrganizerEngine
   e = FileOrganizerEngine(Path('scripts/organizador/config/regras.json'))
   assert 'Projetos_Web_e_Apps' in str(e.classify_file(Path('dao-01.mp4')))
   assert 'Projetos_Web_e_Apps' in str(e.classify_file(Path('mini-fiscalizacao.zip')))
   assert 'Projetos_Web_e_Apps' in str(e.classify_file(Path('agr-vanilla-dojo.tar.gz')))
   print('F13 VERIFICADO COM SUCESSO!')
   "
   ```

7. **Verificar commit no git**:
   ```bash
   git log -1 --stat
   ```
   *Resultado esperado*: Commit `feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)` modificando os 9 arquivos sob `scripts/organizador/`.
