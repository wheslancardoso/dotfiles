"""
Gerenciamento e instanciação da Taxonomia Mestre Numerada.
"""

from pathlib import Path
from typing import Dict, List, Optional
from .utils import log_info, log_dry_run


class TaxonomyManager:
    def __init__(self, root_documents: Path, config: dict):
        self.root_documents = root_documents
        self.config = config
        self.diretorios_mestre = config.get("diretorios_mestre", {})
        self.subpastas_padrao = config.get("subpastas_padrao", {})

    def scaffold(self, dry_run: bool = False) -> List[Path]:
        """
        Cria idempotentemente toda a árvore de diretórios numerada 00..06.
        Retorna a lista de caminhos de diretórios criados/garantidos.
        """
        created_paths: List[Path] = []

        # 1. Pastas mestre raiz
        for key, dir_name in self.diretorios_mestre.items():
            master_path = self.root_documents / dir_name
            if not master_path.exists():
                if dry_run:
                    log_dry_run(f"Criaria pasta raiz: {master_path}")
                else:
                    master_path.mkdir(parents=True, exist_ok=True)
                    log_info(f"Pasta raiz criada: {master_path}")
            created_paths.append(master_path)

        # 2. Subpastas padrão
        for master_name, sub_list in self.subpastas_padrao.items():
            for sub_name in sub_list:
                sub_path = self.root_documents / master_name / sub_name
                if not sub_path.exists():
                    if dry_run:
                        log_dry_run(f"Criaria subpasta: {sub_path}")
                    else:
                        sub_path.mkdir(parents=True, exist_ok=True)
                        log_info(f"Subpasta criada: {sub_path}")
                created_paths.append(sub_path)

        return created_paths
