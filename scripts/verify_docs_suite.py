#!/usr/bin/env python3
"""
Automated E2E Verification Test Harness for Pedagogical Documentation Suite
=============================================================================
Repository: dotfiles / templates-lab / docs
Authoritative Specification: ORIGINAL_REQUEST.md & PROJECT.md
Usage:
    python3 scripts/verify_docs_suite.py
    python3 scripts/verify_docs_suite.py --tier 1
    python3 scripts/verify_docs_suite.py --format json
    python3 scripts/verify_docs_suite.py --format markdown
    pytest scripts/verify_docs_suite.py
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import unittest
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Pattern, Tuple

# ---------------------------------------------------------------------------
# Constants & Canonical File Definitions
# ---------------------------------------------------------------------------

DEFAULT_DOCS_DIR = (
    Path(__file__).resolve().parent.parent / "templates-lab" / "docs"
)

MODULE_FILES = [
    "01-fundamentos-web-e-javascript-vanilla.md",
    "02-arquitetura-backend-spring-boot-3.md",
    "03-persistencia-dados-jpa-hibernate-concorrencia.md",
    "04-seguranca-stateless-oauth2-jwt-rbac.md",
    "05-frontend-enterprise-angular-vanilla.md",
]

README_FILE = "README.md"
CANONICAL_FILES = MODULE_FILES + [README_FILE]

MIN_LINES_MODULE = 301  # > 300 lines each
MIN_LINES_README = 100

FORBIDDEN_PLACEHOLDERS: List[Tuple[str, Pattern[str]]] = [
    ("TODO", re.compile(r"\bTODO\b")),
    ("FIXME", re.compile(r"\bFIXME\b")),
    ("[TBD]", re.compile(r"\[TBD\]|\bTBD\b")),
    ("implementar depois", re.compile(r"\bimplementar\s+depois\b", re.IGNORECASE)),
    ("em breve / a definir", re.compile(r"\b(em\s+breve|a\s+definir|preencher\s+depois)\b", re.IGNORECASE)),
]

# Code ellipsis pattern: detects bare '...' inside code fences without explanation
CODE_ELLIPSIS_PATTERN = re.compile(r"^\s*(//|#|/\*|<!--)?\s*\.\.\.\s*(\*/|-->)?\s*$")

# Tier 3: 4-part pedagogical structure patterns
PEDAGOGICAL_SECTIONS: List[Tuple[str, Pattern[str]]] = [
    (
        "Parte 1: O que é o conceito / Analogia",
        re.compile(
            r"(o\s+que\s+[eé]\s+(o|um)?\s*conceito|analogia(\s+com\s+o\s+mundo\s+real|\s+did[aá]tica)?|conceito\s+puro)",
            re.IGNORECASE,
        ),
    ),
    (
        "Parte 2: A Dor Histórica / O Desastre do Legado",
        re.compile(
            r"(a\s+dor\s+hist[oó]rica|o\s+desastre\s+do\s+legado|o\s+que\s+quebrava\s+em\s+produ[cç][aã]o|dor\s+no\s+mundo\s+real)",
            re.IGNORECASE,
        ),
    ),
    (
        "Parte 3: A Solução Moderna de Elite",
        re.compile(
            r"(a\s+solu[cç][aã]o\s+moderna(\s+de\s+elite)?|engenharia\s+moderna|solu[cç][aã]o\s+de\s+elite)",
            re.IGNORECASE,
        ),
    ),
    (
        "Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC",
        re.compile(
            r"(v[ií]nculo\s+direto\s+com\s+(o\s+)?AGR(-Docs)?|teatro-abc|aplica[cç][aã]o\s+no\s+AGR|onde\s+(isso\s+)?se\s+aplica\s+no\s+AGR)",
            re.IGNORECASE,
        ),
    ),
]

# Tier 3: Version contrasts per module
VERSION_CONTRASTS: Dict[str, List[Tuple[str, Pattern[str]]]] = {
    "01-fundamentos-web-e-javascript-vanilla.md": [
        ("var vs let/const", re.compile(r"\bvar\b.*\b(let|const)\b|\b(let|const)\b.*\bvar\b", re.IGNORECASE | re.DOTALL)),
        ("Callbacks vs Promises / async/await", re.compile(r"(callback(\s+hell)?|pyramid\s+of\s+doom).*(\bPromise\b|async/await|async\s+await)|(\bPromise\b|async/await|async\s+await).*(callback(\s+hell)?|pyramid\s+of\s+doom)", re.IGNORECASE | re.DOTALL)),
        ("Vanilla DOM vs jQuery", re.compile(r"(querySelector|addEventListener).*(\bjQuery\b|\$\()|(\bjQuery\b|\$\().*(querySelector|addEventListener)", re.IGNORECASE | re.DOTALL)),
        ("HTML5 Semântico vs div soup", re.compile(r"(div\s+soup|div-soup|sem[aâ]ntic)", re.IGNORECASE)),
        ("CSS BEM / Flexbox / Grid vs !important", re.compile(r"(!important|acoplamento.*id).*(BEM|flexbox|css\s+grid)|(BEM|flexbox|css\s+grid).*(!important|acoplamento.*id)", re.IGNORECASE | re.DOTALL)),
    ],
    "02-arquitetura-backend-spring-boot-3.md": [
        ("Java 8 vs 17 vs 21 LTS", re.compile(r"Java\s*8.*(17|21)|Java\s*(17|21).*8", re.IGNORECASE | re.DOTALL)),
        ("Java Records imutáveis para DTOs", re.compile(r"\brecord\b.*(DTO|imut[aá]ve|boilerplate)|(DTO|imut[aá]ve|boilerplate).*\brecord\b", re.IGNORECASE | re.DOTALL)),
        ("Virtual Threads / Project Loom", re.compile(r"(Virtual\s+Threads?|Project\s+Loom)", re.IGNORECASE)),
        ("Spring Boot 3.3+ REST & Tratamento RFC 7807 ProblemDetail", re.compile(r"(ProblemDetail|RFC\s*7807)", re.IGNORECASE)),
    ],
    "03-persistencia-dados-jpa-hibernate-concorrencia.md": [
        ("JPA puro vs Hibernate 6.x / Jakarta Persistence 3.1", re.compile(r"(Jakarta\s+Persistence|JPA\s+puro).*Hibernate|Hibernate.*(Jakarta\s+Persistence|JPA\s+puro)", re.IGNORECASE | re.DOTALL)),
        ("Mapeamentos sem N+1 (JOIN FETCH / EntityGraph / Projeções)", re.compile(r"(N\s*\+\s*1|JOIN\s+FETCH|EntityGraph)", re.IGNORECASE)),
        ("Lock Otimista (@Version) vs Lock Pessimista", re.compile(r"(@Version|OptimisticLockException).*Pessimis|Pessimis.*(@Version|OptimisticLockException)", re.IGNORECASE | re.DOTALL)),
        ("Versionamento com Flyway vs ddl-auto=update", re.compile(r"(Flyway|V1__).*(ddl-auto|update)|(ddl-auto|update).*(Flyway|V1__)", re.IGNORECASE | re.DOTALL)),
    ],
    "04-seguranca-stateless-oauth2-jwt-rbac.md": [
        ("Spring Security 5 vs 6 (SecurityFilterChain vs WebSecurityConfigurerAdapter)", re.compile(r"SecurityFilterChain.*WebSecurityConfigurerAdapter|WebSecurityConfigurerAdapter.*SecurityFilterChain", re.IGNORECASE | re.DOTALL)),
        ("requestMatchers vs antMatchers", re.compile(r"requestMatchers.*antMatchers|antMatchers.*requestMatchers", re.IGNORECASE | re.DOTALL)),
        ("OAuth 2.1 & Descontinuação do Password Grant", re.compile(r"(Password\s+Grant|Resource\s+Owner\s+Password).*(descontinuad|PKCE|OAuth\s*2\.1)|OAuth\s*2\.1.*(Password\s+Grant|PKCE)", re.IGNORECASE | re.DOTALL)),
        ("RBAC Stateless com JWT Claims & @PreAuthorize", re.compile(r"(@PreAuthorize|hasAuthority|hasRole).*(\bJWT\b|claims?)|(\bJWT\b|claims?).*(@PreAuthorize|hasAuthority|hasRole)", re.IGNORECASE | re.DOTALL)),
    ],
    "05-frontend-enterprise-angular-vanilla.md": [
        ("Standalone Components vs NgModules clássicos", re.compile(r"(standalone.*NgModule|NgModule.*standalone|elimina[cç][aã]o\s+de\s+NgModule)", re.IGNORECASE | re.DOTALL)),
        ("Reatividade Moderna com Signals (signal, computed, effect)", re.compile(r"\bsignal\b.*\bcomputed\b.*\beffect\b|\bSignals?\b", re.IGNORECASE | re.DOTALL)),
        ("Typed Reactive Forms vs Formulários legados", re.compile(r"(Typed\s+Form|FormGroup|FormControl|Formul[aá]rios?\s+Reativos?)", re.IGNORECASE)),
        ("PrimeNG Moderno (p-table) vs p-dataTable legado", re.compile(r"(p-table.*p-dataTable|p-dataTable.*p-table|p-table)", re.IGNORECASE | re.DOTALL)),
    ],
}

# Tier 4: Traceability required components in README.md
TRACEABILITY_COMPONENTS: List[Tuple[str, Pattern[str]]] = [
    ("Tabela Markdown com Matriz Estruturada", re.compile(r"\|.*\|.*\|")),
    ("Acervo AlgaWorks (1.625 transcrições / siglas ESR, EJPA, FAS, MJS, WDR)", re.compile(r"(AlgaWorks|1\.?625|ESR|EJPA|FAS|MJS|WDR)", re.IGNORECASE)),
    ("Microsserviço Real AGR: portalservice (:8080)", re.compile(r"portalservice.*8080|8080.*portalservice", re.IGNORECASE | re.DOTALL)),
    ("Microsserviço Real AGR: cadu (:8081)", re.compile(r"cadu.*8081|8081.*cadu", re.IGNORECASE | re.DOTALL)),
    ("Microsserviço Real AGR: fiscalizacao / agrfiscalservice (:8082 / :8083)", re.compile(r"(fiscalizacao|agrfiscalservice).*(8082|8083)|(8082|8083).*(fiscalizacao|agrfiscalservice)", re.IGNORECASE | re.DOTALL)),
    ("Microsserviço Real AGR: receita (:8092)", re.compile(r"receita.*8092|8092.*receita", re.IGNORECASE | re.DOTALL)),
    ("Projeto Greenfield: teatro-abc", re.compile(r"teatro-abc", re.IGNORECASE)),
    ("Cobertura dos 5 Módulos Canônicos no Índice", re.compile(r"01-fundamentos.*02-arquitetura.*03-persistencia.*04-seguranca.*05-frontend", re.IGNORECASE | re.DOTALL)),
]

# ---------------------------------------------------------------------------
# Data Models
# ---------------------------------------------------------------------------

@dataclass
class CheckFinding:
    check_id: str
    tier: int
    name: str
    target: str
    passed: bool
    line_number: Optional[int] = None
    details: str = ""
    remediation: Optional[str] = None


@dataclass
class TierSummary:
    tier: int
    name: str
    total_checks: int = 0
    passed_checks: int = 0
    failed_checks: int = 0
    findings: List[CheckFinding] = field(default_factory=list)

    @property
    def passed(self) -> bool:
        return self.failed_checks == 0 and self.total_checks > 0


@dataclass
class SuiteReport:
    docs_dir: str
    total_tiers: int = 4
    passed_tiers: int = 0
    failed_tiers: int = 0
    total_checks: int = 0
    passed_checks: int = 0
    failed_checks: int = 0
    summaries: List[TierSummary] = field(default_factory=list)

    @property
    def passed(self) -> bool:
        return self.failed_checks == 0 and self.total_checks > 0


# ---------------------------------------------------------------------------
# Terminal Color Formatting Utilities
# ---------------------------------------------------------------------------

class Colors:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    WHITE = "\033[37m"

    @classmethod
    def disable(cls):
        cls.RESET = ""
        cls.BOLD = ""
        cls.RED = ""
        cls.GREEN = ""
        cls.YELLOW = ""
        cls.BLUE = ""
        cls.MAGENTA = ""
        cls.CYAN = ""
        cls.WHITE = ""


# ---------------------------------------------------------------------------
# Core Verifier Engine
# ---------------------------------------------------------------------------

class DocsSuiteVerifier:
    def __init__(self, docs_dir: Optional[Path] = None):
        if docs_dir:
            self.docs_dir = Path(docs_dir).resolve()
        else:
            env_dir = os.environ.get("DOCS_SUITE_DIR")
            if env_dir:
                self.docs_dir = Path(env_dir).resolve()
            else:
                self.docs_dir = DEFAULT_DOCS_DIR

    def read_file_safe(self, filename: str) -> Tuple[Optional[str], Optional[str]]:
        path = self.docs_dir / filename
        if not path.is_file():
            return None, f"Arquivo não encontrado: {path}"
        try:
            return path.read_text(encoding="utf-8"), None
        except UnicodeDecodeError as exc:
            return None, f"Falha de decodificação UTF-8 em {path}: {exc}"
        except Exception as exc:
            return None, f"Erro ao ler {path}: {exc}"

    # -----------------------------------------------------------------------
    # Tier 1: File Existence & Basic Integrity
    # -----------------------------------------------------------------------
    def verify_tier_1_file_existence(self) -> TierSummary:
        summary = TierSummary(
            tier=1,
            name="Tier 1: File Existence & Basic Integrity",
        )

        # Check target docs directory
        dir_exists = self.docs_dir.is_dir()
        finding_dir = CheckFinding(
            check_id="T1-DIR-EXIST",
            tier=1,
            name="Diretório de documentação existe",
            target=str(self.docs_dir),
            passed=dir_exists,
            details=f"Diretório encontrado em {self.docs_dir}" if dir_exists else f"Diretório ausente: {self.docs_dir}",
            remediation="Criar o diretório /home/lan/dotfiles/templates-lab/docs/" if not dir_exists else None,
        )
        summary.findings.append(finding_dir)

        # Check canonical files
        for filename in CANONICAL_FILES:
            target_path = self.docs_dir / filename
            exists = target_path.is_file()
            size = target_path.stat().st_size if exists else 0
            non_empty = size > 0

            passed = exists and non_empty
            details = f"Arquivo presente ({size} bytes)" if passed else (
                f"Arquivo ausente em {target_path}" if not exists else f"Arquivo vazio (0 bytes): {target_path}"
            )
            remediation = f"Criar {filename} com conteúdo substantive em {self.docs_dir}" if not passed else None

            summary.findings.append(
                CheckFinding(
                    check_id=f"T1-FILE-{filename[:4].upper()}",
                    tier=1,
                    name=f"Arquivo canônico presente: {filename}",
                    target=filename,
                    passed=passed,
                    details=details,
                    remediation=remediation,
                )
            )

        summary.total_checks = len(summary.findings)
        summary.passed_checks = sum(1 for f in summary.findings if f.passed)
        summary.failed_checks = summary.total_checks - summary.passed_checks
        return summary

    # -----------------------------------------------------------------------
    # Tier 2: Completeness & Zero Placeholders
    # -----------------------------------------------------------------------
    def verify_tier_2_completeness_placeholders(self) -> TierSummary:
        summary = TierSummary(
            tier=2,
            name="Tier 2: Completeness & Zero Placeholders",
        )

        for filename in CANONICAL_FILES:
            content, err = self.read_file_safe(filename)
            if content is None:
                summary.findings.append(
                    CheckFinding(
                        check_id=f"T2-READ-{filename[:4].upper()}",
                        tier=2,
                        name=f"Leitura de {filename}",
                        target=filename,
                        passed=False,
                        details=err or "Arquivo indisponível",
                        remediation=f"Certifique-se de que {filename} existe antes de auditar completude",
                    )
                )
                continue

            lines = content.splitlines()
            line_count = len(lines)
            min_lines = MIN_LINES_README if filename == README_FILE else MIN_LINES_MODULE

            # 1. Line count check
            line_check_passed = line_count >= min_lines
            summary.findings.append(
                CheckFinding(
                    check_id=f"T2-LEN-{filename[:4].upper()}",
                    tier=2,
                    name=f"Tamanho substantivo ({min_lines}+ linhas) em {filename}",
                    target=filename,
                    passed=line_check_passed,
                    details=f"{line_count} linhas encontradas (mínimo exigido: {min_lines})",
                    remediation=f"Expandir conteúdo pedagógico de {filename} para conter mais de {min_lines-1} linhas sem enrolação" if not line_check_passed else None,
                )
            )

            # 2. Forbidden placeholder search
            placeholder_violations: List[Tuple[str, int, str]] = []
            for line_idx, line in enumerate(lines, start=1):
                for ph_name, pattern in FORBIDDEN_PLACEHOLDERS:
                    match = pattern.search(line)
                    if match:
                        placeholder_violations.append((ph_name, line_idx, line.strip()))

            ph_passed = len(placeholder_violations) == 0
            if ph_passed:
                ph_details = "Nenhum placeholder proibido (TODO, FIXME, [TBD], implementar depois) encontrado."
                ph_remed = None
            else:
                ph_details = f"{len(placeholder_violations)} placeholder(s) proibido(s) detectado(s): " + ", ".join(
                    f"L{l} [{name}] '{snippet[:40]}'" for name, l, snippet in placeholder_violations[:5]
                )
                if len(placeholder_violations) > 5:
                    ph_details += f" ... (+{len(placeholder_violations)-5} ocorrências)"
                ph_remed = f"Substituir todos os placeholders por implementações reais e detalhadas em {filename}"

            summary.findings.append(
                CheckFinding(
                    check_id=f"T2-PH-{filename[:4].upper()}",
                    tier=2,
                    name=f"Zero Placeholders Proibidos em {filename}",
                    target=filename,
                    passed=ph_passed,
                    line_number=placeholder_violations[0][1] if placeholder_violations else None,
                    details=ph_details,
                    remediation=ph_remed,
                )
            )

            # 3. Code blocks bare ellipsis search
            ellipsis_violations: List[Tuple[int, str]] = []
            in_code_block = False
            for line_idx, line in enumerate(lines, start=1):
                if line.strip().startswith("```"):
                    in_code_block = not in_code_block
                    continue
                if in_code_block:
                    if CODE_ELLIPSIS_PATTERN.match(line):
                        ellipsis_violations.append((line_idx, line.strip()))

            ellipsis_passed = len(ellipsis_violations) == 0
            if ellipsis_passed:
                el_details = "Nenhuma reticência vazia ('...') sem explicação em blocos de código."
                el_remed = None
            else:
                el_details = f"{len(ellipsis_violations)} reticência(s) sem explicação em bloco de código: " + ", ".join(
                    f"L{l} '{snippet}'" for l, snippet in ellipsis_violations[:4]
                )
                el_remed = f"Substituir reticências vazias '...' por código completo executável ou comentários explicativos"

            summary.findings.append(
                CheckFinding(
                    check_id=f"T2-ELLIP-{filename[:4].upper()}",
                    tier=2,
                    name=f"Código sem reticências desleixadas em {filename}",
                    target=filename,
                    passed=ellipsis_passed,
                    line_number=ellipsis_violations[0][0] if ellipsis_violations else None,
                    details=el_details,
                    remediation=el_remed,
                )
            )

        summary.total_checks = len(summary.findings)
        summary.passed_checks = sum(1 for f in summary.findings if f.passed)
        summary.failed_checks = summary.total_checks - summary.passed_checks
        return summary

    # -----------------------------------------------------------------------
    # Tier 3: Pedagogical 4-Part Structure & Version Contrasts
    # -----------------------------------------------------------------------
    def verify_tier_3_pedagogical_structure(self) -> TierSummary:
        summary = TierSummary(
            tier=3,
            name="Tier 3: Pedagogical 4-Part Structure & Version Contrasts",
        )

        for filename in MODULE_FILES:
            content, err = self.read_file_safe(filename)
            if content is None:
                summary.findings.append(
                    CheckFinding(
                        check_id=f"T3-READ-{filename[:4].upper()}",
                        tier=3,
                        name=f"Leitura de {filename}",
                        target=filename,
                        passed=False,
                        details=err or "Arquivo indisponível",
                        remediation=f"Criar {filename} antes de validar estrutura pedagógica",
                    )
                )
                continue

            # Check 4 mandatory pedagogical parts
            for part_idx, (section_title, pattern) in enumerate(PEDAGOGICAL_SECTIONS, start=1):
                match = pattern.search(content)
                passed = match is not None
                details = (
                    f"Seção obrigatória identificada: '{match.group(0)}'"
                    if passed
                    else f"Seção obrigatória ausente no documento (padrão esperado: {section_title})"
                )
                remediation = (
                    f"Adicionar a seção '{section_title}' para todos os conceitos principais de {filename}"
                    if not passed
                    else None
                )

                summary.findings.append(
                    CheckFinding(
                        check_id=f"T3-PART{part_idx}-{filename[:4].upper()}",
                        tier=3,
                        name=f"{section_title} em {filename}",
                        target=filename,
                        passed=passed,
                        details=details,
                        remediation=remediation,
                    )
                )

            # Check version contrasts for this module
            contrasts = VERSION_CONTRASTS.get(filename, [])
            for c_idx, (c_name, c_pattern) in enumerate(contrasts, start=1):
                match = c_pattern.search(content)
                passed = match is not None
                details = (
                    f"Contraste de versão validado: '{c_name}'"
                    if passed
                    else f"Contraste obrigatório não identificado no texto: '{c_name}'"
                )
                remediation = (
                    f"Adicionar análise comparativa explícita de '{c_name}' em {filename}"
                    if not passed
                    else None
                )

                summary.findings.append(
                    CheckFinding(
                        check_id=f"T3-CONTRAST-{filename[:4].upper()}-{c_idx}",
                        tier=3,
                        name=f"Contraste: {c_name} em {filename}",
                        target=filename,
                        passed=passed,
                        details=details,
                        remediation=remediation,
                    )
                )

        summary.total_checks = len(summary.findings)
        summary.passed_checks = sum(1 for f in summary.findings if f.passed)
        summary.failed_checks = summary.total_checks - summary.passed_checks
        return summary

    # -----------------------------------------------------------------------
    # Tier 4: Traceability Matrix & Index
    # -----------------------------------------------------------------------
    def verify_tier_4_traceability_matrix(self) -> TierSummary:
        summary = TierSummary(
            tier=4,
            name="Tier 4: Traceability Matrix & Central Index (README.md)",
        )

        content, err = self.read_file_safe(README_FILE)
        if content is None:
            summary.findings.append(
                CheckFinding(
                    check_id="T4-READ-README",
                    tier=4,
                    name=f"Leitura de {README_FILE}",
                    target=README_FILE,
                    passed=False,
                    details=err or "Arquivo indisponível",
                    remediation=f"Criar {README_FILE} com a matriz central de rastreabilidade",
                )
            )
            summary.total_checks = 1
            summary.failed_checks = 1
            return summary

        for comp_idx, (comp_name, comp_pattern) in enumerate(TRACEABILITY_COMPONENTS, start=1):
            match = comp_pattern.search(content)
            passed = match is not None
            details = (
                f"Elemento de rastreabilidade encontrado: '{comp_name}'"
                if passed
                else f"Elemento de rastreabilidade ausente em {README_FILE}: '{comp_name}'"
            )
            remediation = (
                f"Incluir referência explícita a '{comp_name}' na matriz de rastreabilidade do {README_FILE}"
                if not passed
                else None
            )

            summary.findings.append(
                CheckFinding(
                    check_id=f"T4-COMP-{comp_idx}",
                    tier=4,
                    name=f"Rastreabilidade: {comp_name}",
                    target=README_FILE,
                    passed=passed,
                    details=details,
                    remediation=remediation,
                )
            )

        summary.total_checks = len(summary.findings)
        summary.passed_checks = sum(1 for f in summary.findings if f.passed)
        summary.failed_checks = summary.total_checks - summary.passed_checks
        return summary

    # -----------------------------------------------------------------------
    # Aggregated Execution
    # -----------------------------------------------------------------------
    def run_suite(self, tiers: Optional[List[int]] = None) -> SuiteReport:
        active_tiers = tiers or [1, 2, 3, 4]
        report = SuiteReport(docs_dir=str(self.docs_dir))

        tier_runners = {
            1: self.verify_tier_1_file_existence,
            2: self.verify_tier_2_completeness_placeholders,
            3: self.verify_tier_3_pedagogical_structure,
            4: self.verify_tier_4_traceability_matrix,
        }

        for t in active_tiers:
            runner = tier_runners.get(t)
            if runner:
                summary = runner()
                report.summaries.append(summary)
                report.total_checks += summary.total_checks
                report.passed_checks += summary.passed_checks
                report.failed_checks += summary.failed_checks
                if summary.passed:
                    report.passed_tiers += 1
                else:
                    report.failed_tiers += 1

        report.total_tiers = len(report.summaries)
        return report


# ---------------------------------------------------------------------------
# Output Formatters
# ---------------------------------------------------------------------------

def format_terminal_report(report: SuiteReport, verbose: bool = False) -> str:
    lines = []
    lines.append(f"{Colors.BOLD}{Colors.CYAN}{'='*80}{Colors.RESET}")
    lines.append(
        f"{Colors.BOLD}{Colors.CYAN} PEDAGOGICAL DOCUMENTATION SUITE E2E VERIFICATION TEST HARNESS{Colors.RESET}"
    )
    lines.append(f"{Colors.BOLD}{Colors.CYAN}{'='*80}{Colors.RESET}")
    lines.append(f"{Colors.WHITE}Target Docs Directory: {Colors.BOLD}{report.docs_dir}{Colors.RESET}")
    lines.append("")

    for summary in report.summaries:
        status_color = Colors.GREEN if summary.passed else Colors.RED
        status_text = "PASS" if summary.passed else "FAIL"
        lines.append(
            f"{Colors.BOLD}[{status_color}{status_text}{Colors.RESET}{Colors.BOLD}] {summary.name}{Colors.RESET} "
            f"({summary.passed_checks}/{summary.total_checks} checks passed)"
        )

        for finding in summary.findings:
            if finding.passed:
                if verbose:
                    lines.append(
                        f"  {Colors.GREEN}✓{Colors.RESET} [{finding.check_id}] {finding.name} "
                        f"{Colors.WHITE}- {finding.details}{Colors.RESET}"
                    )
            else:
                line_info = f" (line {finding.line_number})" if finding.line_number else ""
                lines.append(
                    f"  {Colors.RED}✗{Colors.RESET} [{Colors.BOLD}{finding.check_id}{Colors.RESET}] "
                    f"{Colors.BOLD}{finding.name}{Colors.RESET}{line_info}:"
                )
                lines.append(f"     {Colors.RED}Detalhe:{Colors.RESET} {finding.details}")
                if finding.remediation:
                    lines.append(f"     {Colors.YELLOW}Remediação:{Colors.RESET} {finding.remediation}")

        lines.append("")

    lines.append(f"{Colors.BOLD}{Colors.CYAN}{'-'*80}{Colors.RESET}")
    final_color = Colors.GREEN if report.passed else Colors.RED
    final_text = "SUITE PASSED (ALL CRITERIA MET)" if report.passed else "SUITE FAILED (ACCEPTANCE CRITERIA UNMET)"
    lines.append(
        f"{Colors.BOLD}OVERALL RESULT: {final_color}{final_text}{Colors.RESET} | "
        f"Tiers: {report.passed_tiers}/{report.total_tiers} passed | "
        f"Checks: {report.passed_checks}/{report.total_checks} passed"
    )
    lines.append(f"{Colors.BOLD}{Colors.CYAN}{'='*80}{Colors.RESET}")
    return "\n".join(lines)


def format_json_report(report: SuiteReport) -> str:
    data = {
        "docs_dir": report.docs_dir,
        "suite_passed": report.passed,
        "total_tiers": report.total_tiers,
        "passed_tiers": report.passed_tiers,
        "failed_tiers": report.failed_tiers,
        "total_checks": report.total_checks,
        "passed_checks": report.passed_checks,
        "failed_checks": report.failed_checks,
        "tiers": [
            {
                "tier": s.tier,
                "name": s.name,
                "passed": s.passed,
                "total_checks": s.total_checks,
                "passed_checks": s.passed_checks,
                "failed_checks": s.failed_checks,
                "findings": [asdict(f) for f in s.findings],
            }
            for s in report.summaries
        ],
    }
    return json.dumps(data, indent=2, ensure_ascii=False)


def format_markdown_report(report: SuiteReport) -> str:
    lines = [
        "# Relatório de Execução da Suíte de Verificação E2E",
        "",
        f"- **Diretório Alvo**: `{report.docs_dir}`",
        f"- **Status Geral**: {'✅ **PASSOU**' if report.passed else '❌ **FALHOU**'}",
        f"- **Tiers Aprovados**: `{report.passed_tiers}/{report.total_tiers}`",
        f"- **Checks Aprovados**: `{report.passed_checks}/{report.total_checks}`",
        "",
        "## Resumo por Tier",
        "",
        "| Tier | Descrição | Status | Passaram | Total |",
        "|:---:|---|:---:|:---:|:---:|",
    ]

    for s in report.summaries:
        status_badge = "✅ PASS" if s.passed else "❌ FAIL"
        lines.append(f"| Tier {s.tier} | {s.name} | {status_badge} | {s.passed_checks} | {s.total_checks} |")

    lines.append("")
    lines.append("## Detalhes de Verificação e Remediações")
    lines.append("")

    for s in report.summaries:
        lines.append(f"### Tier {s.tier}: {s.name}")
        lines.append("")
        for f in s.findings:
            icon = "✅" if f.passed else "❌"
            lines.append(f"- {icon} **[{f.check_id}] {f.name}** (`{f.target}`)")
            lines.append(f"  - *Detalhes*: {f.details}")
            if f.remediation:
                lines.append(f"  - *Remediação*: `{f.remediation}`")
        lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Python unittest.TestCase Bindings
# ---------------------------------------------------------------------------

class BaseDocsSuiteTestCase(unittest.TestCase):
    verifier: DocsSuiteVerifier

    @classmethod
    def setUpClass(cls):
        cls.verifier = DocsSuiteVerifier()


class TestTier1FileExistence(BaseDocsSuiteTestCase):
    """Tier 1: Verifies directory and canonical file existence and basic readability."""

    def test_tier1_all_files_exist_and_non_empty(self):
        summary = self.verifier.verify_tier_1_file_existence()
        failures = [f for f in summary.findings if not f.passed]
        if failures:
            fail_msgs = [f"[{f.check_id}] {f.name}: {f.details}" for f in failures]
            self.fail("Tier 1 Falhas de Existência:\n" + "\n".join(fail_msgs))


class TestTier2CompletenessZeroPlaceholders(BaseDocsSuiteTestCase):
    """Tier 2: Verifies substantive length and absence of forbidden placeholders."""

    def test_tier2_size_and_zero_placeholders(self):
        summary = self.verifier.verify_tier_2_completeness_placeholders()
        failures = [f for f in summary.findings if not f.passed]
        if failures:
            fail_msgs = [f"[{f.check_id}] {f.name}: {f.details}" for f in failures]
            self.fail("Tier 2 Falhas de Completude & Placeholders:\n" + "\n".join(fail_msgs))


class TestTier3PedagogicalStructureVersionContrasts(BaseDocsSuiteTestCase):
    """Tier 3: Verifies mandatory 4-part structure and version contrasts per module."""

    def test_tier3_pedagogical_structure_and_contrasts(self):
        summary = self.verifier.verify_tier_3_pedagogical_structure()
        failures = [f for f in summary.findings if not f.passed]
        if failures:
            fail_msgs = [f"[{f.check_id}] {f.name}: {f.details}" for f in failures]
            self.fail("Tier 3 Falhas de Estrutura Pedagógica & Contrastes:\n" + "\n".join(fail_msgs))


class TestTier4TraceabilityMatrix(BaseDocsSuiteTestCase):
    """Tier 4: Verifies central index and traceability matrix in README.md."""

    def test_tier4_traceability_matrix(self):
        summary = self.verifier.verify_tier_4_traceability_matrix()
        failures = [f for f in summary.findings if not f.passed]
        if failures:
            fail_msgs = [f"[{f.check_id}] {f.name}: {f.details}" for f in failures]
            self.fail("Tier 4 Falhas de Rastreabilidade em README.md:\n" + "\n".join(fail_msgs))


# ---------------------------------------------------------------------------
# CLI Entrypoint
# ---------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Automated E2E Verification Test Harness for Pedagogical Docs Suite",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--docs-dir",
        type=str,
        default=None,
        help="Path to directory containing docs (default: /home/lan/dotfiles/templates-lab/docs)",
    )
    parser.add_argument(
        "--tier",
        type=str,
        default="all",
        choices=["1", "2", "3", "4", "all"],
        help="Select specific tier to run (default: all)",
    )
    parser.add_argument(
        "--format",
        type=str,
        default="terminal",
        choices=["terminal", "json", "markdown"],
        help="Report output format (default: terminal)",
    )
    parser.add_argument(
        "--output",
        type=str,
        default=None,
        help="Write report output to specified file path",
    )
    parser.add_argument(
        "--no-color",
        action="store_true",
        help="Disable ANSI color output in terminal",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output including passed checks",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Strict mode: exit with non-zero if any warning or failure occurs",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.no_color or not sys.stdout.isatty():
        Colors.disable()

    target_dir = Path(args.docs_dir) if args.docs_dir else None
    verifier = DocsSuiteVerifier(docs_dir=target_dir)

    tiers = [int(args.tier)] if args.tier != "all" else [1, 2, 3, 4]
    report = verifier.run_suite(tiers=tiers)

    if args.format == "json":
        output = format_json_report(report)
    elif args.format == "markdown":
        output = format_markdown_report(report)
    else:
        output = format_terminal_report(report, verbose=args.verbose)

    if args.output:
        out_path = Path(args.output).resolve()
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(output, encoding="utf-8")
        print(f"Relatório gravado com sucesso em: {out_path}")
    else:
        print(output)

    return 0 if report.passed else 1


if __name__ == "__main__":
    sys.exit(main())
