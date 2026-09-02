"""
Módulo de registro de histórico de movimentações e suporte a reversão (Undo).
"""

import json
import os
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from .utils import Colors, get_unique_destination_path, log_dry_run, log_error, log_info, log_success, log_warning


class HistoryManager:
    """Gerencia o registro de movimentações e permite desfazer operações anteriores."""

    def __init__(self, history_file: Optional[Path] = None):
        if history_file:
            self.history_file = history_file
        else:
            # Salva por padrão na pasta raiz do usuário ou do projeto
            self.history_file = Path.home() / ".organizador_master_history.json"

    def _load_history(self) -> List[Dict]:
        """Carrega a lista de sessões de histórico salvas."""
        if not self.history_file.exists():
            return []
        try:
            with open(self.history_file, "r", encoding="utf-8") as f:
                data = json.load(f)
                return data if isinstance(data, list) else []
        except Exception as e:
            log_warning(f"Não foi possível ler histórico anterior: {e}")
            return []

    def _save_history(self, history: List[Dict]) -> None:
        """Salva a lista de sessões de histórico."""
        try:
            with open(self.history_file, "w", encoding="utf-8") as f:
                json.dump(history, f, indent=2, ensure_ascii=False)
        except Exception as e:
            log_error(f"Erro ao salvar arquivo de histórico: {e}")

    def create_session(self, description: str = "Organização Automática") -> str:
        """Gera um identificador de sessão único baseado em timestamp."""
        session_id = datetime.now().strftime("%Y%m%d_%H%M%S")
        return session_id

    def record_session(self, session_id: str, operations: List[Dict], description: str = "Organização Automática") -> None:
        """Registra uma sessão completa com suas respectivas operações de arquivos movidos."""
        if not operations:
            return

        history = self._load_history()
        session_entry = {
            "session_id": session_id,
            "timestamp": datetime.now().isoformat(),
            "description": description,
            "total_items": len(operations),
            "operations": operations,
        }
        # Mantém até as últimas 50 sessões
        history.append(session_entry)
        if len(history) > 50:
            history = history[-50:]

        self._save_history(history)

    def get_last_session(self) -> Optional[Dict]:
        """Retorna os dados da última sessão realizada."""
        history = self._load_history()
        if not history:
            return None
        return history[-1]

    def list_recent_sessions(self, limit: int = 10) -> List[Dict]:
        """Lista as sessões mais recentes."""
        history = self._load_history()
        return list(reversed(history[-limit:]))

    def undo_last_session(self, dry_run: bool = False) -> Tuple[int, int]:
        """
        Reverte a última sessão de movimentação, movendo os arquivos de volta para suas origens.
        Retorna (sucessos, erros).
        """
        history = self._load_history()
        if not history:
            log_warning("Nenhum histórico encontrado para desfazer.")
            return 0, 0

        last_session = history[-1]
        session_id = last_session.get("session_id", "Desconhecida")
        operations = last_session.get("operations", [])

        log_info(f"Iniciando reversão da sessão [{session_id}] ({len(operations)} arquivos)...")

        successes = 0
        errors = 0

        # Itera em ordem reversa
        for op in reversed(operations):
            src_str = op.get("source")
            dest_str = op.get("destination")

            if not src_str or not dest_str:
                continue

            current_location = Path(dest_str)
            original_location = Path(src_str)

            if not current_location.exists():
                log_warning(f"Arquivo não encontrado no destino atual (já foi movido/apagado): {current_location}")
                errors += 1
                continue

            if dry_run:
                log_dry_run(f"Reverter: {current_location.name} ➔ {original_location}")
                successes += 1
                continue

            try:
                original_location.parent.mkdir(parents=True, exist_ok=True)
                target_back = get_unique_destination_path(original_location)
                shutil.move(str(current_location), str(target_back))
                log_success(f"Devolvido: {current_location.name} ➔ {target_back.parent.name}/{target_back.name}")
                successes += 1
            except Exception as e:
                log_error(f"Erro ao reverter {current_location.name}: {e}")
                errors += 1

        if not dry_run and successes > 0:
            # Remove a sessão do histórico após reversão
            history.pop()
            self._save_history(history)
            log_success(f"Sessão [{session_id}] revertida com sucesso! ({successes} arquivos restaurados)")

        return successes, errors
