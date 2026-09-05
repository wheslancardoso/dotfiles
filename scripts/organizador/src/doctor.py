"""
Módulo de Auditoria, Diagnóstico e Saúde do Sistema de Arquivos (System Doctor).
Avalia a conformidade com a Taxonomia Mestre e o Guia Padrão Ouro de Nomenclatura.
"""

import re
from pathlib import Path
from typing import Dict, List, Tuple

from .utils import Colors


class SystemDoctor:
    """Auditor rigoroso de padronização, ruído e organização de arquivos."""

    ARTIFACTS_REGEX = re.compile(
        r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy)",
        re.IGNORECASE,
    )

    @classmethod
    def audit(cls, root_dir: Path) -> Dict:
        """Executa auditoria abrangente em um diretório raiz de arquivos."""
        results = {
            "root_dir": str(root_dir),
            "loose_root_files": [],
            "noise_metadata_files": [],
            "naming_artifacts": [],
            "taxonomy_distribution": {},
            "total_files": 0,
            "total_dirs": 0,
            "score": 100,
            "grade": "A+",
            "issues": [],
        }

        if not root_dir.exists():
            results["issues"].append(f"Diretório não existe: {root_dir}")
            results["score"] = 0
            results["grade"] = "F"
            return results

        # 1. Checa arquivos soltos na raiz (não deve haver arquivos soltos fora das pastas)
        for item in root_dir.iterdir():
            if item.is_file():
                if not item.name.startswith("."):
                    results["loose_root_files"].append(item.name)

        # 2. Varredura completa da árvore
        all_items = list(root_dir.rglob("*"))
        for item in all_items:
            if item.is_dir():
                results["total_dirs"] += 1
                continue

            results["total_files"] += 1
            name = item.name

            # Metadados de ruído (Windows Zone, SmartScreen, Thumbs, DS_Store)
            if ":Zone.Identifier" in name or ":SmartScreen" in name or name in ["Thumbs.db", ".DS_Store", "desktop.ini"]:
                results["noise_metadata_files"].append(str(item.relative_to(root_dir)))

            # Nomenclatura com artefatos de download
            if cls.ARTIFACTS_REGEX.search(name):
                results["naming_artifacts"].append(str(item.relative_to(root_dir)))

        # 3. Distribuição por pastas numeradas da taxonomia mestre
        for master in sorted(root_dir.iterdir()):
            if master.is_dir() and master.name != "organizador-master-main":
                files_count = sum(1 for f in master.rglob("*") if f.is_file() and not f.name.startswith("."))
                dirs_count = sum(1 for f in master.rglob("*") if f.is_dir())
                results["taxonomy_distribution"][master.name] = {
                    "files": files_count,
                    "subdirs": dirs_count,
                }

        # 4. Cálculo de Pontuação e Nota
        deductions = 0
        if results["loose_root_files"]:
            deductions += min(len(results["loose_root_files"]) * 5, 30)
            results["issues"].append(f"{len(results['loose_root_files'])} arquivos soltos na raiz.")

        if results["noise_metadata_files"]:
            deductions += min(len(results["noise_metadata_files"]) * 2, 25)
            results["issues"].append(f"{len(results['noise_metadata_files'])} metadados de ruído (:Zone.Identifier/Thumbs.db).")

        if results["naming_artifacts"]:
            deductions += min(len(results["naming_artifacts"]) * 2, 25)
            results["issues"].append(f"{len(results['naming_artifacts'])} nomes de arquivos com artefatos de download (' (1)', '- Cópia').")

        inbox_dir = root_dir / "00_Inbox_Triagem"
        inbox = sum(1 for f in inbox_dir.glob("*") if f.is_file() and not f.name.startswith(".")) if inbox_dir.exists() else 0
        if inbox > 0:
            deductions += min(inbox * 2, 15)
            results["issues"].append(f"{inbox} arquivos pendentes em 00_Inbox_Triagem.")

        score = max(0, 100 - deductions)
        results["score"] = score

        if score >= 95:
            results["grade"] = "A+ (Padrão Ouro)"
        elif score >= 85:
            results["grade"] = "A (Excelente)"
        elif score >= 75:
            results["grade"] = "B (Bom)"
        elif score >= 60:
            results["grade"] = "C (Regular)"
        else:
            results["grade"] = "D / F (Necessita Organização)"

        return results

    @classmethod
    def format_report(cls, audit_data: Dict) -> str:
        """Formata o relatório de auditoria em um dashboard limpo e legível."""
        lines = [
            f"\n{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}",
            f"{Colors.BOLD}{Colors.HEADER}   ORGANIZADOR MASTER — AUDITORIA DE CONFORMIDADE   {Colors.END}",
            f"{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}",
            f" Diretório Raiz     : {audit_data['root_dir']}",
            f" Total de Arquivos  : {audit_data['total_files']}",
            f" Total de Pastas    : {audit_data['total_dirs']}",
            f" Pontuação de Saúde : {Colors.BOLD}{audit_data['score']}/100{Colors.END}",
            f" Classificação      : {Colors.BOLD}{Colors.GREEN if audit_data['score'] >= 85 else Colors.YELLOW}{audit_data['grade']}{Colors.END}",
            f"{Colors.HEADER}----------------------------------------------------{Colors.END}",
            f"{Colors.BOLD}DISTRIBUIÇÃO DA TAXONOMIA MESTRE:{Colors.END}",
        ]

        for folder, stats in audit_data["taxonomy_distribution"].items():
            lines.append(f"  📁 {folder:<32} {stats['files']:>5} arquivos | {stats['subdirs']:>3} subpastas")

        lines.append(f"{Colors.HEADER}----------------------------------------------------{Colors.END}")
        lines.append(f"{Colors.BOLD}VERIFICAÇÃO DE REQUISITOS PADRÃO OURO:{Colors.END}")

        # Checks
        if not audit_data["loose_root_files"]:
            lines.append(f"  {Colors.GREEN}✔{Colors.END} Zero arquivos soltos na raiz")
        else:
            lines.append(f"  {Colors.RED}✖{Colors.END} {len(audit_data['loose_root_files'])} arquivos soltos na raiz")

        if not audit_data["noise_metadata_files"]:
            lines.append(f"  {Colors.GREEN}✔{Colors.END} Zero ruídos de metadados (:Zone.Identifier / Thumbs.db)")
        else:
            lines.append(f"  {Colors.RED}✖{Colors.END} {len(audit_data['noise_metadata_files'])} metadados indesejados encontrados")

        if not audit_data["naming_artifacts"]:
            lines.append(f"  {Colors.GREEN}✔{Colors.END} Nomenclatura 100% sanitizada (sem ' (1)' ou '- Cópia')")
        else:
            lines.append(f"  {Colors.RED}✖{Colors.END} {len(audit_data['naming_artifacts'])} arquivos com nomes não padronizados")

        inbox_count = audit_data["taxonomy_distribution"].get("00_Inbox_Triagem", {}).get("files", 0)
        if inbox_count == 0:
            lines.append(f"  {Colors.GREEN}✔{Colors.END} Caixa de entrada (00_Inbox_Triagem) totalmente limpa")
        else:
            lines.append(f"  {Colors.YELLOW}⚠{Colors.END} {inbox_count} arquivos pendentes em 00_Inbox_Triagem")

        lines.append(f"{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}\n")
        return "\n".join(lines)
