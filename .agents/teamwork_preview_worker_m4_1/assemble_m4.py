#!/usr/bin/env python3
"""
Assembler and verifier for Module 04:
/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md
"""

from pathlib import Path
import re
import sys

base_dir = Path("/home/lan/dotfiles/.agents/teamwork_preview_worker_m4_1")
target_file = Path("/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md")

sec1 = (base_dir / "sec1.md").read_text(encoding="utf-8")
sec2 = (base_dir / "sec2.md").read_text(encoding="utf-8")
sec3 = (base_dir / "sec3.md").read_text(encoding="utf-8")
sec4 = (base_dir / "sec4.md").read_text(encoding="utf-8")

full_content = sec1 + sec2 + sec3 + sec4

target_file.parent.mkdir(parents=True, exist_ok=True)
target_file.write_text(full_content, encoding="utf-8")

lines = full_content.splitlines()
print(f"Assembly completed successfully!")
print(f"Target: {target_file}")
print(f"Total lines: {len(lines)}")
print(f"Total bytes: {len(full_content.encode('utf-8'))}")

# Self-audit against verify_docs_suite.py rules
print("\n--- IN-PROCESS SELF-AUDIT ---")

# 1. Placeholders
forbidden = [
    ("TODO", re.compile(r"\bTODO\b")),
    ("FIXME", re.compile(r"\bFIXME\b")),
    ("[TBD]", re.compile(r"\[TBD\]|\bTBD\b")),
    ("implementar depois", re.compile(r"\bimplementar\s+depois\b", re.IGNORECASE)),
    ("em breve / a definir", re.compile(r"\b(em\s+breve|a\s+definir|preencher\s+depois)\b", re.IGNORECASE)),
]
ph_found = []
for idx, line in enumerate(lines, 1):
    for name, pat in forbidden:
        if pat.search(line):
            ph_found.append((name, idx, line))

if ph_found:
    print(f"FAILED: Found {len(ph_found)} forbidden placeholders:")
    for name, idx, line in ph_found:
        print(f"  Line {idx} [{name}]: {line}")
else:
    print("PASSED: Zero forbidden placeholders.")

# 2. Code ellipsis
ellipsis_pat = re.compile(r"^\s*(//|#|/\*|<!--)?\s*\.\.\.\s*(\*/|-->)?\s*$")
in_code = False
el_found = []
for idx, line in enumerate(lines, 1):
    if line.strip().startswith("```"):
        in_code = not in_code
        continue
    if in_code and ellipsis_pat.match(line):
        el_found.append((idx, line))

if el_found:
    print(f"FAILED: Found {len(el_found)} bare ellipsis in code:")
    for idx, line in el_found:
        print(f"  Line {idx}: {line}")
else:
    print("PASSED: Zero bare code ellipsis.")

# 3. 4-part pedagogical structure
ped_sections = [
    ("Parte 1", re.compile(r"(o\s+que\s+[eé]\s+(o|um)?\s*conceito|analogia(\s+com\s+o\s+mundo\s+real|\s+did[aá]tica)?|conceito\s+puro)", re.IGNORECASE)),
    ("Parte 2", re.compile(r"(a\s+dor\s+hist[oó]rica|o\s+desastre\s+do\s+legado|o\s+que\s+quebrava\s+em\s+produ[cç][aã]o|dor\s+no\s+mundo\s+real)", re.IGNORECASE)),
    ("Parte 3", re.compile(r"(a\s+solu[cç][aã]o\s+moderna(\s+de\s+elite)?|engenharia\s+moderna|solu[cç][aã]o\s+de\s+elite)", re.IGNORECASE)),
    ("Parte 4", re.compile(r"(v[ií]nculo\s+direto\s+com\s+(o\s+)?AGR(-Docs)?|teatro-abc|aplica[cç][aã]o\s+no\s+AGR|onde\s+(isso\s+)?se\s+aplica\s+no\s+AGR)", re.IGNORECASE)),
]
for name, pat in ped_sections:
    matches = len(pat.findall(full_content))
    print(f"Pedagogical {name}: {matches} occurrences found (must be >= 1)")
    if matches == 0:
        print(f"FAILED: {name} not found!")

# 4. Version contrasts
contrasts = [
    ("Spring Security 5 vs 6", re.compile(r"SecurityFilterChain.*WebSecurityConfigurerAdapter|WebSecurityConfigurerAdapter.*SecurityFilterChain", re.IGNORECASE | re.DOTALL)),
    ("requestMatchers vs antMatchers", re.compile(r"requestMatchers.*antMatchers|antMatchers.*requestMatchers", re.IGNORECASE | re.DOTALL)),
    ("OAuth 2.1 & Descontinuação do Password Grant", re.compile(r"(Password\s+Grant|Resource\s+Owner\s+Password).*(descontinuad|PKCE|OAuth\s*2\.1)|OAuth\s*2\.1.*(Password\s+Grant|PKCE)", re.IGNORECASE | re.DOTALL)),
    ("RBAC Stateless com JWT Claims & @PreAuthorize", re.compile(r"(@PreAuthorize|hasAuthority|hasRole).*(\bJWT\b|claims?)|(\bJWT\b|claims?).*(@PreAuthorize|hasAuthority|hasRole)", re.IGNORECASE | re.DOTALL)),
]
for name, pat in contrasts:
    m = pat.search(full_content)
    if m:
        print(f"Contrast {name}: PASSED")
    else:
        print(f"Contrast {name}: FAILED!")

print("--- END AUDIT ---\n")
