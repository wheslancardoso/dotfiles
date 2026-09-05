"""
Módulo de detecção e gestão de duplicatas por hash criptográfico (SHA-256).
Identifica arquivos com conteúdo idêntico mesmo que tenham nomes totalmente diferentes.
"""

import hashlib
import os
import shutil
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from .utils import Colors, log_dry_run, log_error, log_info, log_success, log_warning


class HashDeduplicator:
    """Detecta e gerencia arquivos duplicados via SHA-256 com filtragem rápida por tamanho."""

    BUFFER_SIZE = 65536  # 64 KB

    @classmethod
    def calculate_file_hash(cls, file_path: Path) -> str:
        """Calcula o hash SHA-256 de um arquivo de forma eficiente em blocos."""
        hasher = hashlib.sha256()
        with open(file_path, "rb") as f:
            while chunk := f.read(cls.BUFFER_SIZE):
                hasher.update(chunk)
        return hasher.hexdigest()

    @classmethod
    def scan_directory(cls, target_dir: Path, recursive: bool = True) -> Dict[str, List[Path]]:
        """
        Varre o diretório e agrupa arquivos que possuem hash SHA-256 idêntico.
        Otimização: só calcula hash para arquivos cujo tamanho em bytes é compartilhado por 2+ arquivos.
        """
        size_groups: Dict[int, List[Path]] = defaultdict(list)
        all_files = list(target_dir.rglob("*") if recursive else target_dir.iterdir())

        for p in all_files:
            if not p.is_file():
                continue
            if p.name.startswith(".") or ":Zone.Identifier" in p.name:
                continue
            try:
                size = p.stat().st_size
                if size > 0:  # Ignora arquivos de 0 bytes
                    size_groups[size].append(p)
            except (OSError, PermissionError):
                continue

        # Filtra apenas tamanhos com potencial de colisão
        hash_groups: Dict[str, List[Path]] = defaultdict(list)
        candidates = [p for sz, paths in size_groups.items() if len(paths) > 1 for p in paths]

        for p in candidates:
            try:
                h = cls.calculate_file_hash(p)
                hash_groups[h].append(p)
            except (OSError, PermissionError):
                continue

        # Retorna apenas hashes com 2 ou mais arquivos idênticos
        return {h: paths for h, paths in hash_groups.items() if len(paths) > 1}

    @classmethod
    def format_report(cls, duplicates: Dict[str, List[Path]], root_dir: Path) -> str:
        """Gera um relatório legível e detalhado das duplicatas encontradas."""
        if not duplicates:
            return f"\n{Colors.GREEN}{Colors.BOLD}✅ Nenhuma duplicata de conteúdo (SHA-256) encontrada!{Colors.END}\n"

        total_dups = sum(len(paths) - 1 for paths in duplicates.values())
        total_wasted_bytes = sum(
            paths[0].stat().st_size * (len(paths) - 1)
            for paths in duplicates.values()
            if paths and paths[0].exists()
        )
        wasted_mb = total_wasted_bytes / (1024 * 1024)

        lines = [
            f"\n{Colors.BOLD}{Colors.HEADER}=== DETECÇÃO DE DUPLICATAS POR HASH SHA-256 ==={Colors.END}",
            f"Grupos com conteúdo idêntico : {len(duplicates)}",
            f"Arquivos redundantes          : {total_dups}",
            f"Espaço desperdiçado           : {wasted_mb:.2f} MB",
            f"{Colors.HEADER}-------------------------------------------------{Colors.END}",
        ]

        for idx, (h, paths) in enumerate(duplicates.items(), 1):
            size_kb = paths[0].stat().st_size / 1024 if paths[0].exists() else 0
            lines.append(f"\n{Colors.YELLOW}Grupo #{idx}{Colors.END} [SHA256: {h[:12]}...] ({size_kb:.1f} KB):")
            for i, p in enumerate(paths):
                rel = p.relative_to(root_dir) if p.is_relative_to(root_dir) else p
                tag = f"{Colors.GREEN}[ORIGINAL]{Colors.END}" if i == 0 else f"{Colors.RED}[CÓPIA]{Colors.END}"
                lines.append(f"   {tag} {rel}")

        lines.append(f"\n{Colors.BOLD}{Colors.HEADER}================================================={Colors.END}\n")
        return "\n".join(lines)

    @classmethod
    def quarantine_duplicates(
        cls,
        duplicates: Dict[str, List[Path]],
        quarantine_dir: Path,
        dry_run: bool = False,
    ) -> int:
        """
        Move as cópias excedentes para uma pasta de quarentena segura preservando o original.
        """
        quarantined_count = 0
        for h, paths in duplicates.items():
            # O primeiro arquivo é preservado como original
            original = paths[0]
            copies = paths[1:]
            for copy in copies:
                dest_file = quarantine_dir / copy.name
                counter = 1
                while dest_file.exists():
                    dest_file = quarantine_dir / f"{dest_file.stem}_{counter}{dest_file.suffix}"
                    counter += 1

                if dry_run:
                    log_dry_run(f"Mover cópia para quarentena: {copy.name} ➔ {dest_file}")
                    quarantined_count += 1
                else:
                    quarantine_dir.mkdir(parents=True, exist_ok=True)
                    try:
                        shutil.move(str(copy), str(dest_file))
                        log_success(f"Quarentena: {copy.name} ➔ {dest_file.name}")
                        quarantined_count += 1
                    except Exception as e:
                        log_error(f"Erro ao mover cópia {copy.name}: {e}")

        return quarantined_count
