"""
Módulo de Monitoramento Contínuo em Tempo Real (Watcher Daemon).
Observa diretórios (ex: 00_Inbox_Triagem ou Downloads) e organiza novos arquivos automaticamente.
"""

import time
from pathlib import Path
from typing import Callable, Dict, Optional, Set, Tuple

from .core import FileOrganizerEngine
from .renamer import AutoNamer
from .utils import Colors, log_error, log_info, log_success, log_warning


class DirectoryWatcher:
    """Daemon leve de observação de arquivos baseado em polling nativo e debounce."""

    def __init__(
        self,
        watch_dir: Path,
        engine: FileOrganizerEngine,
        auto_namer: Optional[AutoNamer] = None,
        poll_interval: float = 2.0,
        settle_time: float = 1.5,
    ):
        self.watch_dir = watch_dir
        self.engine = engine
        self.auto_namer = auto_namer or AutoNamer()
        self.poll_interval = poll_interval
        self.settle_time = settle_time
        self._running = False
        self._known_sizes: Dict[Path, Tuple[int, float]] = {}

    def is_file_settled(self, file_path: Path) -> bool:
        """
        Verifica se um arquivo terminou de ser copiado/baixado comparando
        seu tamanho e timestamp de modificação ao longo do intervalo de acomodação.
        """
        try:
            current_size = file_path.stat().st_size
            now = time.time()

            if file_path not in self._known_sizes:
                self._known_sizes[file_path] = (current_size, now)
                return False

            prev_size, first_seen = self._known_sizes[file_path]
            if current_size == prev_size and (now - first_seen) >= self.settle_time:
                return True
            else:
                self._known_sizes[file_path] = (current_size, now)
                return False
        except (OSError, PermissionError):
            return False

    def process_incoming_file(self, file_path: Path) -> bool:
        """Sanitiza e organiza um arquivo recém-chegado."""
        if not file_path.exists() or file_path.is_dir():
            return False

        if self.engine.should_ignore(file_path):
            return False

        log_info(f"Detectado novo arquivo: {file_path.name}")

        # 1. Sanitiza nome do arquivo se necessário
        clean_name = self.auto_namer.sanitize_name(file_path.name)
        if clean_name != file_path.name:
            new_path = file_path.parent / clean_name
            try:
                file_path.rename(new_path)
                file_path = new_path
                log_success(f"Higienizado nome: {clean_name}")
            except Exception as e:
                log_warning(f"Não foi possível renomear {file_path.name}: {e}")

        # 2. Classifica e move para a taxonomia mestre
        dest_dir = self.engine.classify_file(file_path)
        if dest_dir:
            success, _ = self.engine.move_item(file_path, dest_dir)
            if success:
                log_success(f"Auto-Organizado: {file_path.name} ➔ {dest_dir.name}")
                return True

        return False

    def start(self, once: bool = False) -> None:
        """Inicia o loop de monitoramento."""
        if not self.watch_dir.exists():
            log_error(f"Diretório para monitorar não existe: {self.watch_dir}")
            return

        print(f"\n{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}")
        print(f"{Colors.BOLD}{Colors.HEADER}   ORGANIZADOR MASTER — MODO WATCHER EM TEMPO REAL   {Colors.END}")
        print(f"{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}")
        log_info(f"Monitorando diretório : {self.watch_dir}")
        log_info(f"Destino dos arquivos  : {self.engine.dest_root}")
        log_info("Pressione Ctrl+C para encerrar o monitoramento a qualquer momento.\n")

        self._running = True
        try:
            while self._running:
                # Varre arquivos soltos na pasta observada
                for item in list(self.watch_dir.iterdir()):
                    if item.is_file() and not item.name.startswith("."):
                        if self.is_file_settled(item):
                            self.process_incoming_file(item)
                            self._known_sizes.pop(item, None)

                if once:
                    break
                time.sleep(self.poll_interval)
        except KeyboardInterrupt:
            log_info("Monitoramento encerrado pelo usuário.")
        finally:
            self._running = False
