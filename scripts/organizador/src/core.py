"""
Motor central de classificação, roteamento e movimentação de arquivos.
"""

import json
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from .history import HistoryManager
from .utils import (
    Colors,
    get_unique_destination_path,
    log_dry_run,
    log_error,
    log_info,
    log_success,
    log_warning,
    normalize_text,
)


class FileOrganizerEngine:
    def __init__(
        self,
        config_path: Path,
        root_user: Optional[Path] = None,
        custom_dest_root: Optional[Path] = None,
        history_manager: Optional[HistoryManager] = None,
    ):
        self.config_path = config_path
        with open(config_path, "r", encoding="utf-8") as f:
            self.config = json.load(f)

        self.root_user = root_user or Path.home()
        self.dest_root = custom_dest_root or (self.root_user / "Documents")
        self.desktop = self.root_user / "Desktop"
        self.downloads = self.root_user / "Downloads"

        self.ignored = set(self.config.get("arquivos_ignorados", []))
        self.keyword_rules = self.config.get("regras_palavras_chave", [])
        self.extension_rules = self.config.get("regras_extensoes", {})

        self.history_manager = history_manager or HistoryManager()
        self.recorded_operations: List[Dict] = []

    def should_ignore(self, path: Path) -> bool:
        """Verifica se o arquivo ou diretório deve ser ignorado (ex: desktop.ini, .git, atalhos)."""
        name = path.name
        if name in self.ignored:
            return True
        if name.startswith("."):
            return True
        # No Desktop, nunca movemos atalhos de programas (.lnk, .url)
        if path.suffix.lower() in [".lnk", ".url"]:
            return True
        return False

    def classify_file(self, file_path: Path) -> Optional[Path]:
        """
        Classifica um arquivo com base nas regras de palavras-chave e extensões.
        Retorna o caminho de destino absoluto correspondente na taxonomia.
        """
        name_normalized = normalize_text(file_path.name)
        ext = file_path.suffix.lower()

        # 1. Checagem por palavras-chave (prioridade mais alta)
        for rule in self.keyword_rules:
            terms = rule.get("termos", [])
            dest_rel = rule.get("destino", "")
            for term in terms:
                term_normalized = normalize_text(term)
                if term_normalized in name_normalized:
                    return self.dest_root / dest_rel

        # 2. Checagem por extensão
        if ext in self.extension_rules:
            dest_rel = self.extension_rules[ext]
            return self.dest_root / dest_rel

        # 3. Fallback inteligente: se for documento solto não identificado, envia para 00_Inbox_Triagem
        if ext in [".pdf", ".docx", ".xlsx", ".txt", ".md", ".json", ".zip", ".rar", ".7z", ".csv", ".pptx"]:
            return self.dest_root / "00_Inbox_Triagem"

        return None

    def move_item(self, source_path: Path, target_dir: Path, dry_run: bool = False) -> Tuple[bool, str]:
        """
        Move um arquivo ou pasta de forma segura, criando subpastas se necessário e evitando colisões.
        """
        if not source_path.exists():
            return False, "Origem não encontrada"

        # Garante diretório de destino
        target_dir.mkdir(parents=True, exist_ok=True)
        final_dest = get_unique_destination_path(target_dir / source_path.name)

        if dry_run:
            log_dry_run(f"{source_path.name} ➔ {final_dest}")
            return True, "Simulado com sucesso"

        try:
            abs_source = source_path.resolve()
            shutil.move(str(source_path), str(final_dest))
            abs_dest = final_dest.resolve()

            # Registra no histórico para permitir rollback
            self.recorded_operations.append({
                "source": str(abs_source),
                "destination": str(abs_dest),
                "filename": source_path.name,
            })

            log_success(f"{source_path.name} ➔ {final_dest.parent.name}/{final_dest.name}")
            return True, "Movido com sucesso"
        except Exception as e:
            log_error(f"Erro ao mover {source_path.name}: {e}")
            return False, str(e)

    def commit_session(self, description: str = "Organização Automática") -> Optional[str]:
        """Salva as operações acumuladas no histórico persistente."""
        if not self.recorded_operations:
            return None
        session_id = self.history_manager.create_session(description)
        self.history_manager.record_session(session_id, self.recorded_operations, description=description)
        self.recorded_operations = []
        return session_id

    def organize_directory(self, target_dir: Path, recursive: bool = False, dry_run: bool = False) -> dict:
        """
        Varre e organiza um diretório específico (Desktop, Downloads ou pasta do Google Drive).
        """
        stats = {"total_analisados": 0, "movidos": 0, "ignorados": 0, "erros": 0}

        if not target_dir.exists():
            log_warning(f"Diretório não existe: {target_dir}")
            return stats

        log_info(f"Iniciando varredura em: {target_dir} (DryRun: {dry_run})")

        items = list(target_dir.rglob("*") if recursive else target_dir.iterdir())

        for item in items:
            # Se for diretório dentro de varredura recursiva, pula para focar em arquivos
            if item.is_dir() and recursive:
                continue

            if self.should_ignore(item):
                stats["ignorados"] += 1
                continue

            stats["total_analisados"] += 1
            destination_dir = self.classify_file(item)

            if destination_dir:
                # Evita mover o arquivo para o mesmo lugar onde ele já está
                if item.parent.resolve() == destination_dir.resolve():
                    stats["ignorados"] += 1
                    continue

                success, _ = self.move_item(item, destination_dir, dry_run=dry_run)
                if success:
                    stats["movidos"] += 1
                else:
                    stats["erros"] += 1
            else:
                stats["ignorados"] += 1

        return stats
