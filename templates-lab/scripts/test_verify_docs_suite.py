#!/usr/bin/env python3
"""
Unit and Adversarial Integrity Tests for verify_docs_suite.py
============================================================
Ensures that verify_docs_suite.py detects all violations (Tiers 1-4)
and correctly passes when all specifications are satisfied.
"""

import sys
import tempfile
import unittest
from pathlib import Path

# Add scripts directory to path
sys.path.insert(0, str(Path(__file__).resolve().parent))
from verify_docs_suite import (  # noqa: E402
    MODULE_FILES,
    README_FILE,
    DocsSuiteVerifier,
)


class TestDocsSuiteHarnessSelfTest(unittest.TestCase):
    """Verifies that DocsSuiteVerifier behaves properly against synthetic fixtures."""

    def test_tier1_detects_missing_directory(self):
        non_existent = Path("/tmp/does_not_exist_at_all_12345")
        verifier = DocsSuiteVerifier(docs_dir=non_existent)
        summary = verifier.verify_tier_1_file_existence()
        self.assertFalse(summary.passed)
        self.assertEqual(summary.failed_checks, 7)  # dir + 6 files

    def test_tier2_detects_forbidden_placeholders_and_short_files(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmppath = Path(tmpdir)
            # Create a file with TODO and FIXME and short length
            short_file = tmppath / MODULE_FILES[0]
            short_file.write_text(
                "# Titulo\n"
                "TODO: fazer depois\n"
                "FIXME: corrigir bug\n"
                "Aqui tem [TBD] pendente.\n"
                "Vamos implementar depois isso.\n"
                "```javascript\n"
                "function teste() {\n"
                "   ...\n"
                "}\n"
                "```\n",
                encoding="utf-8",
            )
            # Create rest of files as empty
            for f in MODULE_FILES[1:] + [README_FILE]:
                (tmppath / f).write_text("dummy", encoding="utf-8")

            verifier = DocsSuiteVerifier(docs_dir=tmppath)
            summary = verifier.verify_tier_2_completeness_placeholders()
            self.assertFalse(summary.passed)

            # Check that violations were logged for short_file
            ph_findings = [
                f for f in summary.findings
                if f.target == MODULE_FILES[0] and "Zero Placeholders" in f.name
            ]
            self.assertTrue(len(ph_findings) > 0)
            self.assertFalse(ph_findings[0].passed)
            self.assertIn("TODO", ph_findings[0].details)
            self.assertIn("FIXME", ph_findings[0].details)

            # Check that bare ellipsis was detected in code block
            ellip_findings = [
                f for f in summary.findings
                if f.target == MODULE_FILES[0] and "reticências" in f.name
            ]
            self.assertTrue(len(ellip_findings) > 0)
            self.assertFalse(ellip_findings[0].passed)
            self.assertEqual(ellip_findings[0].line_number, 8)

    def test_tier3_detects_missing_pedagogical_parts_and_contrasts(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmppath = Path(tmpdir)
            # File with plain text lacking pedagogical headings
            (tmppath / MODULE_FILES[1]).write_text(
                "# Spring Boot 3\nApenas texto comum sem seções obrigatórias.\n" * 40,
                encoding="utf-8",
            )
            verifier = DocsSuiteVerifier(docs_dir=tmppath)
            summary = verifier.verify_tier_3_pedagogical_structure()
            self.assertFalse(summary.passed)

            # Check specific missing pedagogical parts
            part1_findings = [f for f in summary.findings if "Parte 1" in f.name]
            self.assertTrue(len(part1_findings) > 0)
            self.assertFalse(part1_findings[0].passed)

    def test_tier4_detects_incomplete_traceability(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmppath = Path(tmpdir)
            # README with only a simple title
            (tmppath / README_FILE).write_text(
                "# Documentação\nSem tabela e sem microsserviços.\n",
                encoding="utf-8",
            )
            verifier = DocsSuiteVerifier(docs_dir=tmppath)
            summary = verifier.verify_tier_4_traceability_matrix()
            self.assertFalse(summary.passed)

    def test_synthetic_perfect_docs_passes_all_tiers(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmppath = Path(tmpdir)

            # Generate synthetic valid module 01
            m1_content = [
                "# 01 - Fundamentos Web e JavaScript Vanilla",
                "## Conceito Puro: O que é o conceito explicado de forma simples e Analogia com o mundo real",
                "HTML semântico e manipulação de DOM.",
                "## A Dor Histórica / O Desastre do Legado",
                "Div soup descontrolada e callback hell causavam panes graves.",
                "## A Solução Moderna de Elite",
                "JavaScript moderno com Promises, async/await, querySelector e CSS Grid.",
                "Diferenças entre var vs let/const, callback hell vs async/await e Vanilla DOM querySelector vs jQuery.",
                "HTML5 semântico eliminando div soup, e CSS BEM com Flexbox e Grid eliminando !important e acoplamento por ID.",
                "## Vínculo Direto com o AGR-Docs / Teatro-ABC",
                "Aplicado no frontend vanilla do greenfield teatro-abc e portais de atendimento da AGR.",
            ] + ["Linha de detalhamento técnico profundo sem placeholders." for _ in range(320)]
            (tmppath / MODULE_FILES[0]).write_text("\n".join(m1_content), encoding="utf-8")

            # Generate synthetic valid module 02
            m2_content = [
                "# 02 - Arquitetura Backend Spring Boot 3",
                "## O que é o conceito / Analogia didática",
                "Arquitetura RESTful moderna em camadas.",
                "## A Dor Histórica / O Desastre do Legado",
                "Endpoints caóticos sem padronização.",
                "## A Solução Moderna de Elite",
                "Java 8 vs 17 vs 21 LTS com Virtual Threads (Project Loom) e record imutável para DTOs.",
                "Spring Boot 3.3+ REST com tratamento global RFC 7807 ProblemDetail.",
                "## Vínculo Direto com o AGR-Docs / Teatro-ABC",
                "Aplicado no portalservice :8080 e teatro-abc.",
            ] + ["Linha de aprofundamento técnico real." for _ in range(320)]
            (tmppath / MODULE_FILES[1]).write_text("\n".join(m2_content), encoding="utf-8")

            # Generate synthetic valid module 03
            m3_content = [
                "# 03 - Persistência de Dados JPA Hibernate Concorrência",
                "## O que é o conceito / Analogia",
                "Mapeamento Objeto-Relacional de alta performance.",
                "## A Dor Histórica / O Desastre do Legado",
                "Explosão de queries N+1 e deadlocks em concorrência.",
                "## A Solução Moderna de Elite",
                "Jakarta Persistence 3.1 com Hibernate 6.x e JPA puro.",
                "Mapeamento otimizado sem N+1 usando JOIN FETCH e EntityGraph.",
                "Controle de concorrência com Lock Otimista @Version vs Lock Pessimista PESSIMISTIC_WRITE.",
                "Migração com Flyway V1__ eliminando ddl-auto=update em produção.",
                "## Vínculo Direto com o AGR-Docs / Teatro-ABC",
                "Utilizado no cadu :8081, fiscalizacao :8082 e teatro-abc.",
            ] + ["Linha de aprofundamento técnico real." for _ in range(320)]
            (tmppath / MODULE_FILES[2]).write_text("\n".join(m3_content), encoding="utf-8")

            # Generate synthetic valid module 04
            m4_content = [
                "# 04 - Segurança Stateless OAuth2 JWT RBAC",
                "## O que é o conceito / Analogia",
                "Segurança stateless e autorização descentralizada.",
                "## A Dor Histórica / O Desastre do Legado",
                "Sessões stateful que travavam o cluster.",
                "## A Solução Moderna de Elite",
                "Spring Security 5 vs 6 com SecurityFilterChain substituindo WebSecurityConfigurerAdapter.",
                "Uso de requestMatchers em vez de antMatchers.",
                "OAuth 2.1 com descontinuação do Password Grant e adoção de PKCE.",
                "RBAC granular com JWT claims e anotações @PreAuthorize hasAuthority.",
                "## Vínculo Direto com o AGR-Docs / Teatro-ABC",
                "Aplicado no portalservice :8080, receita :8092 e teatro-abc.",
            ] + ["Linha de aprofundamento técnico real." for _ in range(320)]
            (tmppath / MODULE_FILES[3]).write_text("\n".join(m4_content), encoding="utf-8")

            # Generate synthetic valid module 05
            m5_content = [
                "# 05 - Frontend Enterprise Angular Vanilla",
                "## O que é o conceito / Analogia",
                "Desenvolvimento SPA com Angular moderno.",
                "## A Dor Histórica / O Desastre do Legado",
                "Módulos gigantescos NgModules e change detection lenta.",
                "## A Solução Moderna de Elite",
                "Eliminação de NgModule com Standalone Components.",
                "Reatividade fina com Signals usando signal, computed e effect.",
                "Formulários Reativos com Typed Reactive Forms.",
                "PrimeNG moderno com p-table substituindo o p-dataTable legado.",
                "## Vínculo Direto com o AGR-Docs / Teatro-ABC",
                "Aplicado no frontend da fiscalização da AGR e teatro-abc.",
            ] + ["Linha de aprofundamento técnico real." for _ in range(320)]
            (tmppath / MODULE_FILES[4]).write_text("\n".join(m5_content), encoding="utf-8")

            # Generate synthetic valid README.md
            readme_content = [
                "# Suíte Modular de Documentação Pedagógica",
                "## Matriz Central de Rastreabilidade",
                "| Módulo | AlgaWorks Acervo | Microsserviços AGR | Greenfield |",
                "|---|---|---|---|",
                "| 01-fundamentos-web-e-javascript-vanilla.md | MJS, WDR (1.625 transcrições) | portalservice :8080 | teatro-abc |",
                "| 02-arquitetura-backend-spring-boot-3.md | ESR (Especialista Spring Rest) | cadu :8081, fiscalizacao :8082 | teatro-abc |",
                "| 03-persistencia-dados-jpa-hibernate-concorrencia.md | EJPA (Especialista JPA) | receita :8092, agrfiscalservice :8083 | teatro-abc |",
                "| 04-seguranca-stateless-oauth2-jwt-rbac.md | ESR Segurança OAuth2 | portalservice :8080, receita :8092 | teatro-abc |",
                "| 05-frontend-enterprise-angular-vanilla.md | FAS (Formação Angular Specialist) | fiscalizacao :8082 | teatro-abc |",
            ] + ["Linha de índice detalhado para os desenvolvedores e auditores." for _ in range(110)]
            (tmppath / README_FILE).write_text("\n".join(readme_content), encoding="utf-8")

            verifier = DocsSuiteVerifier(docs_dir=tmppath)
            report = verifier.run_suite()

            self.assertTrue(report.passed, "Relatório da suíte deveria passar para fixture perfeita")
            self.assertEqual(report.passed_tiers, 4)
            self.assertEqual(report.failed_checks, 0)


if __name__ == "__main__":
    unittest.main()
