import re
from pathlib import Path

parts_dir = Path("/home/lan/dotfiles/.agents/teamwork_preview_worker_m2_1/parts")
part_files = sorted(parts_dir.glob("*.md"))

full_content = ""
for pf in part_files:
    text = pf.read_text(encoding="utf-8")
    full_content += text
    if not text.endswith("\n"):
        full_content += "\n"

# Verify all constraints
lines = full_content.splitlines()
print(f"Total parts: {len(part_files)}")
print(f"Total lines: {len(lines)}")
print(f"Total characters: {len(full_content)}")

assert len(lines) >= 301, f"Line count {len(lines)} < 301"

forbidden_placeholders = [
    ("TODO", re.compile(r"\bTODO\b")),
    ("FIXME", re.compile(r"\bFIXME\b")),
    ("[TBD]", re.compile(r"\[TBD\]|\bTBD\b")),
    ("implementar depois", re.compile(r"\bimplementar\s+depois\b", re.IGNORECASE)),
    ("em breve / a definir", re.compile(r"\b(em\s+breve|a\s+definir|preencher\s+depois)\b", re.IGNORECASE)),
]

for name, pattern in forbidden_placeholders:
    for idx, line in enumerate(lines, start=1):
        if pattern.search(line):
            raise AssertionError(f"Forbidden placeholder '{name}' found on line {idx}: {line}")

# Check bare ellipsis in code blocks
in_code = False
code_ellipsis_pattern = re.compile(r"^\s*(//|#|/\*|<!--)?\s*\.\.\.\s*(\*/|-->)?\s*$")
for idx, line in enumerate(lines, start=1):
    if line.strip().startswith("```"):
        in_code = not in_code
        continue
    if in_code and code_ellipsis_pattern.match(line):
        raise AssertionError(f"Bare ellipsis in code block at line {idx}: {line}")

# Check 4 mandatory pedagogical parts
pedagogical_sections = [
    ("Parte 1", re.compile(r"(o\s+que\s+[eé]\s+(o|um)?\s*conceito|analogia(\s+com\s+o\s+mundo\s+real|\s+did[aá]tica)?|conceito\s+puro)", re.IGNORECASE)),
    ("Parte 2", re.compile(r"(a\s+dor\s+hist[oó]rica|o\s+desastre\s+do\s+legado|o\s+que\s+quebrava\s+em\s+produ[cç][aã]o|dor\s+no\s+mundo\s+real)", re.IGNORECASE)),
    ("Parte 3", re.compile(r"(a\s+solu[cç][aã]o\s+moderna(\s+de\s+elite)?|engenharia\s+moderna|solu[cç][aã]o\s+de\s+elite)", re.IGNORECASE)),
    ("Parte 4", re.compile(r"(v[ií]nculo\s+direto\s+com\s+(o\s+)?AGR(-Docs)?|teatro-abc|aplica[cç][aã]o\s+no\s+AGR|onde\s+(isso\s+)?se\s+aplica\s+no\s+AGR)", re.IGNORECASE)),
]
for name, pat in pedagogical_sections:
    matches = list(pat.finditer(full_content))
    print(f"Pedagogical section '{name}': {len(matches)} matches")
    assert len(matches) > 0, f"Missing pedagogical section: {name}"

# Check version contrasts
version_contrasts = [
    ("Java 8 vs 17 vs 21 LTS", re.compile(r"Java\s*8.*(17|21)|Java\s*(17|21).*8", re.IGNORECASE | re.DOTALL)),
    ("Java Records imutáveis para DTOs", re.compile(r"\brecord\b.*(DTO|imut[aá]ve|boilerplate)|(DTO|imut[aá]ve|boilerplate).*\brecord\b", re.IGNORECASE | re.DOTALL)),
    ("Virtual Threads / Project Loom", re.compile(r"(Virtual\s+Threads?|Project\s+Loom)", re.IGNORECASE)),
    ("Spring Boot 3.3+ REST & Tratamento RFC 7807 ProblemDetail", re.compile(r"(ProblemDetail|RFC\s*7807)", re.IGNORECASE)),
]
for name, pat in version_contrasts:
    m = pat.search(full_content)
    assert m is not None, f"Missing version contrast: {name}"
    print(f"Version contrast '{name}': OK")

# Write to target file
target = Path("/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md")
target.write_text(full_content, encoding="utf-8")
print(f"Written {len(full_content)} bytes to {target}")
