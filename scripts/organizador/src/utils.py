"""
Utilitários de log, sanitização e formatação visual para o Organizador Master.
"""

import os
import re
import sys
import unicodedata
from pathlib import Path
from typing import Optional


class Colors:
    HEADER = "\033[95m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    END = "\033[0m"


def supports_color() -> bool:
    """Verifica se o terminal suporta cores ANSI."""
    return sys.platform != "win32" or "ANSICON" in os.environ or "WT_SESSION" in os.environ or os.environ.get("TERM") == "xterm-256color"


def log_info(msg: str) -> None:
    print(f"{Colors.CYAN}[INFO]{Colors.END} {msg}")


def log_success(msg: str) -> None:
    print(f"{Colors.GREEN}[SUCESSO]{Colors.END} {msg}")


def log_warning(msg: str) -> None:
    print(f"{Colors.YELLOW}[AVISO]{Colors.END} {msg}")


def log_error(msg: str) -> None:
    print(f"{Colors.RED}[ERRO]{Colors.END} {msg}")


def log_dry_run(msg: str) -> None:
    print(f"{Colors.YELLOW}[SIMULAÇÃO]{Colors.END} {msg}")


def normalize_text(text: str) -> str:
    """Normaliza texto removendo acentos e convertendo para minúsculas para matching seguro."""
    normalized = unicodedata.normalize("NFKD", text)
    return "".join(c for c in normalized if not unicodedata.combining(c)).lower().strip()


def slugify_filename(
    name: str,
    remove_accents: bool = True,
    lowercase_ext: bool = True,
    safe_chars: bool = True,
) -> str:
    """
    Higieniza e normaliza nomes de arquivos e pastas para conformidade com filesystems e nuvem:
    - Normalização Unicode NFKD para remoção de diacríticos/acentos (ç -> c, ã -> a, etc.)
    - Conversão da extensão para minúsculas (.PDF -> .pdf)
    - Remoção/substituição de caracteres proibidos (: ? * " < > | ; # $ % & / \\)
    - Preserva integridade de datas ISO (YYYY-MM-DD) e estrutura do nome
    """
    path = Path(name)
    stem = path.stem
    ext = path.suffix

    if lowercase_ext and ext:
        ext = ext.lower()

    if remove_accents:
        normalized = unicodedata.normalize("NFKD", stem)
        stem = "".join(c for c in normalized if not unicodedata.combining(c))

    if safe_chars:
        # Substitui caracteres proibidos/inseguros por espaço para evitar aglutinação de palavras
        stem = re.sub(r'[\:\?\*\"\<\>\|;\#\$\%\&/\\\\]+', " ", stem)
        # Substitui espaços por underscores
        stem = re.sub(r"\s+", "_", stem.strip())
        # Colapsa múltiplos underscores consecutivos
        stem = re.sub(r"_+", "_", stem)
        # Colapsa múltiplos hifens consecutivos sem romper hifens de datas ISO
        stem = re.sub(r"-+", "-", stem)
        # Remove underscores e hifens soltos nas extremidades
        stem = stem.strip(" _-")

    if not stem:
        stem = "arquivo"

    return f"{stem}{ext}"


def get_unique_destination_path(target_path: Path, source_path: Optional[Path] = None) -> Path:
    """
    Garante que não haverá sobrescrita acidental se já existir arquivo com mesmo nome,
    adicionando sufixo incremental _1, _2, etc.
    Limpa sufixos repetidos em cadeia (_1_1_1 -> _1, _2) e protege contra auto-colisão.
    """
    if not target_path.exists():
        return target_path

    # Se a origem e o destino forem o mesmo arquivo físico, retorna sem alterar
    if source_path and source_path.exists():
        try:
            if target_path.resolve() == source_path.resolve() or target_path.samefile(source_path):
                return target_path
        except OSError:
            pass

    parent = target_path.parent
    stem = target_path.stem
    suffix = target_path.suffix

    # Limpa sufixos repetidos como _1_1_1_1
    base_stem = re.sub(r"(_\d+)+$", "", stem)
    if not base_stem:
        base_stem = stem

    counter = 1
    new_path = parent / f"{base_stem}_{counter}{suffix}"
    while new_path.exists():
        if source_path and source_path.exists():
            try:
                if new_path.resolve() == source_path.resolve() or new_path.samefile(source_path):
                    return new_path
            except OSError:
                pass
        counter += 1
        new_path = parent / f"{base_stem}_{counter}{suffix}"

    return new_path

