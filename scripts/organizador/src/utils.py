"""
Utilitários de log, sanitização e formatação visual para o Organizador Master.
"""

import os
import sys
import unicodedata
from pathlib import Path


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


def get_unique_destination_path(target_path: Path) -> Path:
    """
    Garante que não haverá sobrescrita acidental se já existir arquivo com mesmo nome,
    adicionando sufixo incremental _1, _2, etc.
    """
    if not target_path.exists():
        return target_path

    parent = target_path.parent
    stem = target_path.stem
    suffix = target_path.suffix

    counter = 1
    new_path = parent / f"{stem}_{counter}{suffix}"
    while new_path.exists():
        counter += 1
        new_path = parent / f"{stem}_{counter}{suffix}"

    return new_path
