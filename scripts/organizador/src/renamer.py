"""
Módulo de renomeação inteligente e padronização (Auto-Namer / Auto-Date).
Padroniza nomes com base no GUIA_NOMENCLATURA.md (datas ISO, remoção de artefatos de download).
"""

import os
import re
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from .utils import (
    Colors,
    get_unique_destination_path,
    log_dry_run,
    log_error,
    log_info,
    log_success,
    log_warning,
)


class AutoNamer:
    """Utilitário para padronização e higienização de nomes de arquivos."""

    DATE_PREFIX_REGEX = re.compile(r"^(\d{4}[-_]\d{2}[-_]\d{2}|\d{8})[-_]")
    DOWNLOAD_ARTIFACTS_REGEX = re.compile(
        r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy)",
        re.IGNORECASE,
    )

    @classmethod
    def has_date_prefix(cls, filename: str) -> bool:
        """Verifica se o arquivo já possui um prefixo de data ISO no início."""
        return bool(cls.DATE_PREFIX_REGEX.match(filename))

    @classmethod
    def get_file_iso_date(cls, file_path: Path) -> str:
        """Obtém a data ISO (YYYY-MM-DD) a partir do timestamp de modificação/criação do arquivo."""
        try:
            stat = file_path.stat()
            # Pega o menor timestamp plausível entre mtime e ctime
            timestamp = stat.st_mtime
            if hasattr(stat, "st_birthtime") and stat.st_birthtime > 0:
                timestamp = min(timestamp, stat.st_birthtime)
            dt = datetime.fromtimestamp(timestamp)
            return dt.strftime("%Y-%m-%d")
        except Exception:
            return datetime.now().strftime("%Y-%m-%d")

    @classmethod
    def sanitize_name(cls, filename: str) -> str:
        """
        Limpa artefatos feios do nome:
        - Remove ' (1)', ' [2]', '- Copia'
        - Substitui múltiplos espaços por um único underline/hífen
        - Remove espaços nas pontas antes da extensão
        """
        path = Path(filename)
        stem = path.stem
        suffix = path.suffix

        # Remove artefatos de download (ex: ' (1)', ' - Cópia')
        stem = cls.DOWNLOAD_ARTIFACTS_REGEX.sub("", stem)

        # Substitui espaços consecutivos por um único underline
        stem = re.sub(r"\s+", "_", stem.strip())

        # Remove caracteres repetidos indesejados (ex: '___' ou '---')
        stem = re.sub(r"_+", "_", stem)
        stem = re.sub(r"-+", "-", stem)

        # Remove trailing/leading underscores ou hyphens no stem
        stem = stem.strip(" _-")

        if not stem:
            stem = "arquivo"

        return f"{stem}{suffix}"

    @classmethod
    def generate_new_name(cls, file_path: Path, add_date: bool = True, sanitize: bool = True) -> str:
        """
        Gera o novo nome padronizado para o arquivo.
        Se add_date for True e o arquivo não possuir data, adiciona YYYY-MM-DD_ na frente.
        """
        name = file_path.name

        if sanitize:
            name = cls.sanitize_name(name)

        if add_date and not cls.has_date_prefix(name):
            iso_date = cls.get_file_iso_date(file_path)
            name = f"{iso_date}_{name}"

        return name

    def process_directory(
        self,
        target_dir: Path,
        add_date: bool = True,
        sanitize: bool = True,
        recursive: bool = False,
        dry_run: bool = False,
    ) -> Dict[str, int]:
        """
        Varre e renomeia todos os arquivos de um diretório seguindo o padrão.
        """
        stats = {"total": 0, "renomeados": 0, "inalterados": 0, "erros": 0}

        if not target_dir.exists():
            log_warning(f"Diretório para renomeação não encontrado: {target_dir}")
            return stats

        log_info(f"Iniciando Padronização/Renomeação em: {target_dir} (DryRun: {dry_run})")

        items = list(target_dir.rglob("*") if recursive else target_dir.iterdir())

        for item in items:
            if item.is_dir():
                continue
            if item.name.startswith(".") or item.name in ["desktop.ini", "Thumbs.db"]:
                continue

            stats["total"] += 1
            new_name = self.generate_new_name(item, add_date=add_date, sanitize=sanitize)

            if new_name == item.name:
                stats["inalterados"] += 1
                continue

            dest_path = item.parent / new_name

            # Evita colisão se já existir
            if dest_path.exists() and dest_path != item:
                dest_path = get_unique_destination_path(dest_path)

            if dry_run:
                log_dry_run(f"Renomear: {item.name} ➔ {dest_path.name}")
                stats["renomeados"] += 1
                continue

            try:
                item.rename(dest_path)
                log_success(f"Renomeado: {item.name} ➔ {dest_path.name}")
                stats["renomeados"] += 1
            except Exception as e:
                log_error(f"Erro ao renomear {item.name}: {e}")
                stats["erros"] += 1

        return stats
