"""
Módulo de detecção e gestão de duplicatas por hash criptográfico (SHA-256).
Identifica arquivos com conteúdo idêntico mesmo que tenham nomes totalmente diferentes.
"""

import hashlib
import json
import os
import re
import shutil
import subprocess
from collections import defaultdict
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

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


class MediaDeduplicator:
    """
    Detecta vídeos duplicados considerando títulos normalizados (sem IDs),
    durações coincidentes via ffprobe e variações de resolução.
    Mantém automaticamente a versão de melhor qualidade e isola as redundantes.
    """

    MEDIA_EXTENSIONS = {".mp4", ".mkv", ".webm", ".avi", ".mov", ".m4v", ".flv", ".ts"}

    @classmethod
    def normalize_title(cls, filename: str) -> str:
        stem = Path(filename).stem
        # Remove IDs entre colchetes como [xhZ5vo3] ou [345748] ou [ph5f106a5c78711]
        stem = re.sub(r"\[.*?\]", "", stem)
        # Remove tags comuns de resolução como [720p], (360p), etc.
        stem = re.sub(r"[\(\[]?\d{3,4}p[\)\]]?", "", stem, flags=re.IGNORECASE)
        # Remove caracteres especiais e pontuações
        stem = re.sub(r"[^a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ]", " ", stem).lower()
        return re.sub(r"\s+", " ", stem).strip()

    @classmethod
    def get_media_info(cls, file_path: Path) -> Optional[Dict[str, Any]]:
        cmd = [
            "ffprobe",
            "-v", "error",
            "-show_entries", "format=duration,size",
            "-show_entries", "stream=width,height",
            "-of", "json",
            str(file_path)
        ]
        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
            if res.returncode != 0:
                return None
            data = json.loads(res.stdout)
            dur = float(data.get("format", {}).get("duration", 0))
            sz = int(data.get("format", {}).get("size", 0))
            w, h = 0, 0
            for s in data.get("streams", []):
                if "width" in s and s["width"]:
                    w, h = int(s["width"]), int(s["height"])
                    break
            return {
                "path": file_path,
                "duration": round(dur, 1),
                "size": sz,
                "width": w,
                "height": h,
                "norm_title": cls.normalize_title(file_path.name),
            }
        except Exception:
            return None

    @classmethod
    def scan_directory(cls, target_dir: Path, recursive: bool = True) -> List[List[Dict[str, Any]]]:
        files = list(target_dir.rglob("*") if recursive else target_dir.iterdir())
        media_files = [
            p for p in files
            if p.is_file() and p.suffix.lower() in cls.MEDIA_EXTENSIONS and not p.name.startswith(".")
        ]

        media_info_list = []
        for p in media_files:
            info = cls.get_media_info(p)
            if info and info["duration"] > 2.0:
                media_info_list.append(info)

        duplicates = []
        used = set()

        for i, v1 in enumerate(media_info_list):
            if v1["path"] in used:
                continue
            group = [v1]
            for v2 in media_info_list[i + 1:]:
                if v2["path"] in used:
                    continue

                is_dup = False
                # Caso 1: Mesmo título normalizado (>= 4 caracteres) e duração muito próxima (<= 2.5s)
                if len(v1["norm_title"]) >= 4 and v1["norm_title"] == v2["norm_title"] and abs(v1["duration"] - v2["duration"]) <= 2.5:
                    is_dup = True

                # Caso 2: Mesma duração exata (<= 0.2s) e tamanho em bytes muito próximo (<= 3%)
                elif abs(v1["duration"] - v2["duration"]) <= 0.2:
                    max_sz = max(v1["size"], v2["size"])
                    if max_sz > 0 and abs(v1["size"] - v2["size"]) / max_sz < 0.03:
                        is_dup = True

                # Caso 3: Mesma duração exata (<= 0.3s) e dimensões de vídeo idênticas
                elif abs(v1["duration"] - v2["duration"]) <= 0.3 and v1["width"] > 0 and v1["width"] == v2["width"] and v1["height"] == v2["height"]:
                    is_dup = True

                if is_dup:
                    group.append(v2)
                    used.add(v2["path"])

            if len(group) > 1:
                used.add(v1["path"])
                # Ordena de forma que o item de melhor qualidade/resolução fique no índice 0
                group.sort(key=lambda x: (x["width"] * x["height"], x["size"]), reverse=True)
                duplicates.append(group)

        return duplicates

    @classmethod
    def format_report(cls, duplicates: List[List[Dict[str, Any]]], root_dir: Path) -> str:
        if not duplicates:
            return f"\n{Colors.GREEN}{Colors.BOLD}✅ Nenhum vídeo/mídia duplicada encontrada!{Colors.END}\n"

        total_redundant = sum(len(grp) - 1 for grp in duplicates)
        total_wasted_bytes = sum(sum(item["size"] for item in grp[1:]) for grp in duplicates)
        wasted_mb = total_wasted_bytes / (1024 * 1024)

        lines = [
            f"\n{Colors.BOLD}{Colors.HEADER}=== DETECÇÃO INTELIGENTE DE MÍDIAS DUPLICADAS (FFPROBE) ==={Colors.END}",
            f"Grupos com vídeos idênticos : {len(duplicates)}",
            f"Vídeos redundantes           : {total_redundant}",
            f"Espaço recuperável          : {wasted_mb:.2f} MB ({wasted_mb/1024:.2f} GB)",
            f"{Colors.HEADER}----------------------------------------------------------------------{Colors.END}",
        ]

        for idx, grp in enumerate(duplicates, 1):
            orig = grp[0]
            copies = grp[1:]
            dur_str = f"{orig['duration']:.1f}s"
            lines.append(f"\n{Colors.YELLOW}Grupo #{idx}{Colors.END} [Duração: {dur_str}]:")

            orig_rel = orig["path"].relative_to(root_dir) if orig["path"].is_relative_to(root_dir) else orig["path"]
            orig_sz = orig["size"] / (1024 * 1024)
            orig_res = f"{orig['width']}x{orig['height']}" if orig["width"] else "resolução ?"
            lines.append(f"   {Colors.GREEN}[MANTER - MELHOR]{Colors.END} {orig_rel} ({orig_res}, {orig_sz:.1f} MB)")

            for c in copies:
                c_rel = c["path"].relative_to(root_dir) if c["path"].is_relative_to(root_dir) else c["path"]
                c_sz = c["size"] / (1024 * 1024)
                c_res = f"{c['width']}x{c['height']}" if c["width"] else "resolução ?"
                lines.append(f"   {Colors.RED}[REDUNDANTE]    {Colors.END} {c_rel} ({c_res}, {c_sz:.1f} MB)")

        lines.append(f"\n{Colors.BOLD}{Colors.HEADER}======================================================================{Colors.END}\n")
        return "\n".join(lines)

    @classmethod
    def quarantine_duplicates(
        cls,
        duplicates: List[List[Dict[str, Any]]],
        quarantine_dir: Path,
        dry_run: bool = False,
    ) -> int:
        quarantined = 0
        for grp in duplicates:
            copies = grp[1:]
            for c in copies:
                copy_path = c["path"]
                dest_file = quarantine_dir / copy_path.name
                counter = 1
                while dest_file.exists():
                    dest_file = quarantine_dir / f"{dest_file.stem}_{counter}{dest_file.suffix}"
                    counter += 1

                if dry_run:
                    log_dry_run(f"Mover cópia redundante: {copy_path.name} ➔ {dest_file}")
                    quarantined += 1
                else:
                    quarantine_dir.mkdir(parents=True, exist_ok=True)
                    try:
                        shutil.move(str(copy_path), str(dest_file))
                        log_success(f"Quarentena: {copy_path.name} ➔ {dest_file.name}")
                        quarantined += 1
                    except Exception as e:
                        log_error(f"Erro ao mover cópia {copy_path.name}: {e}")

        return quarantined

