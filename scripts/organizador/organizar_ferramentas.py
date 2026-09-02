#!/usr/bin/env python3
import os
import shutil
import re
from pathlib import Path

ROOT = Path('/home/lan/drive-organizacao')
FERRAMENTAS = ROOT / '1 - FERRAMENTAS'
TARGET_BASE = ROOT / '06_Backups_ISOs_e_Sistemas' / '06.1_Instaladores_e_APKs' / 'Ferramentas_TI'

DOWNLOAD_ARTIFACTS_REGEX = re.compile(
    r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy|^c[oó]pia de\s*)",
    re.IGNORECASE,
)

def sanitize_name(name: str) -> str:
    path = Path(name)
    stem = path.stem
    suffix = path.suffix

    stem = DOWNLOAD_ARTIFACTS_REGEX.sub("", stem)
    stem = re.sub(r"\s+", "_", stem.strip())
    stem = re.sub(r"_+", "_", stem)
    stem = re.sub(r"-+", "-", stem)
    stem = stem.strip(" _-")

    if not stem:
        stem = "item"

    return f"{stem}{suffix}"

def clean_junk(file_path: Path) -> bool:
    name = file_path.name
    if name.endswith(':Zone.Identifier') or name.endswith(':SmartScreen'):
        file_path.unlink()
        return True
    if name.endswith('.lnk') or name.endswith('.LOG'):
        file_path.unlink()
        return True
    return False

def safe_copy_or_move_file(src: Path, dest_dir: Path):
    if not src.exists():
        return
    if clean_junk(src):
        return

    dest_dir.mkdir(parents=True, exist_ok=True)
    clean_n = sanitize_name(src.name)
    dest = dest_dir / clean_n

    counter = 1
    while dest.exists() and dest.resolve() != src.resolve():
        # Se for um arquivo binário/zip idêntico em tamanho, pode ser duplicata exata
        if dest.is_file() and src.is_file() and dest.stat().st_size == src.stat().st_size:
            # Duplicata exata em tamanho, pula
            return
        dest = dest_dir / f"{dest.stem}_{counter}{dest.suffix}"
        counter += 1

    shutil.move(str(src), str(dest))

def safe_move_directory_contents(src_dir: Path, dest_dir: Path):
    if not src_dir.exists():
        return
    dest_dir.mkdir(parents=True, exist_ok=True)
    for item in list(src_dir.iterdir()):
        if item.is_dir():
            clean_sub_name = sanitize_name(item.name)
            safe_move_directory_contents(item, dest_dir / clean_sub_name)
        elif item.is_file():
            safe_copy_or_move_file(item, dest_dir)

def main():
    print("=== ORGANIZANDO 1 - FERRAMENTAS SEM REDUNDÂNCIA ===")
    if not FERRAMENTAS.exists():
        print("Diretório 1 - FERRAMENTAS não encontrado.")
        return

    # 1. Limpar metadados de ruído antes
    for item in list(FERRAMENTAS.rglob('*')):
        if item.is_file():
            clean_junk(item)

    # Definir subpastas de destino de Ferramentas_TI
    cat_diag = TARGET_BASE / '01_Teste_e_Diagnostico'
    cat_manut = TARGET_BASE / '02_Ferramentas_Tecnicas_e_Manutencao'
    cat_progs = TARGET_BASE / '03_Programas_Basicos_e_Navegadores'
    cat_comp = TARGET_BASE / '04_Complementos_e_Redistribuiveis'
    cat_impr = TARGET_BASE / '05_Impressoras_e_Resets'
    cat_isos = TARGET_BASE / '06_ISOs_e_Boot'

    # 2. Mover categorias pré-estruturadas de 1 a 9
    d_diag = FERRAMENTAS / '1 - Teste e Diagnóstico'
    if d_diag.exists():
        safe_move_directory_contents(d_diag, cat_diag)

    d_pers = FERRAMENTAS / '2 - Personalização'
    if d_pers.exists():
        safe_move_directory_contents(d_pers, cat_manut)

    d_tecn = FERRAMENTAS / '3 - Ferramentas Técnicas'
    if d_tecn.exists():
        safe_move_directory_contents(d_tecn, cat_manut)

    d_prog = FERRAMENTAS / '4 - Programas Básicos'
    if d_prog.exists():
        safe_move_directory_contents(d_prog, cat_progs)

    d_comp = FERRAMENTAS / '5 - Complementos'
    if d_comp.exists():
        safe_move_directory_contents(d_comp, cat_comp)

    d_pack = FERRAMENTAS / '6 - Pack Portables'
    if d_pack.exists():
        safe_move_directory_contents(d_pack, cat_manut)

    d_isos = FERRAMENTAS / '7 - Isos'
    if d_isos.exists():
        safe_move_directory_contents(d_isos, cat_isos)

    d_padr = FERRAMENTAS / '8 - Padrao'
    if d_padr.exists():
        safe_move_directory_contents(d_padr, cat_progs)

    d_impr = FERRAMENTAS / '9 - Impressoras'
    if d_impr.exists():
        safe_move_directory_contents(d_impr, cat_impr)

    d_deixar = FERRAMENTAS / 'DEIXAR NO PADRÃO'
    if d_deixar.exists():
        safe_move_directory_contents(d_deixar, cat_comp)

    # Move pastas avulsas da raiz de FERRAMENTAS
    loose_dirs = [
        ('ThrottleStop_9.7', cat_diag / 'ThrottleStop_9.7'),
        ('TreeSizeFree-Portable', cat_diag / 'TreeSizeFree-Portable'),
        ('dismplusplus-10-1-1002-2', cat_manut / 'dismplusplus-10-1-1002-2'),
        ('lVl A C R l U lVl', cat_manut / 'Macrium_Reflect_Bootable'),
    ]
    for folder_name, target_dest in loose_dirs:
        folder_path = FERRAMENTAS / folder_name
        if folder_path.exists():
            safe_move_directory_contents(folder_path, target_dest)

    # 3. Classificar arquivos soltos da raiz de FERRAMENTAS
    for item in list(FERRAMENTAS.iterdir()):
        if item.is_file():
            name_l = item.name.lower()
            ext_l = item.suffix.lower()

            if ext_l == '.iso':
                safe_copy_or_move_file(item, cat_isos)
            elif ext_l in ['.exe', '.msi', '.deb', '.apk']:
                safe_copy_or_move_file(item, cat_progs)
            elif ext_l in ['.zip', '.rar', '.7z']:
                # Se for zip de impressora
                if 'impressora' in name_l:
                    safe_copy_or_move_file(item, cat_impr)
                elif 'throttlestop' in name_l or 'treesize' in name_l:
                    safe_copy_or_move_file(item, cat_diag)
                elif 'dism' in name_l:
                    safe_copy_or_move_file(item, cat_manut)
                else:
                    safe_copy_or_move_file(item, cat_progs)
            elif ext_l in ['.bat', '.reg']:
                safe_copy_or_move_file(item, cat_impr if 'impressora' in name_l or 'spooler' in name_l else cat_manut)
            elif ext_l == '.pdf':
                # Documentos PDF soltos vão para Pessoal ou Estudos
                safe_copy_or_move_file(item, ROOT / '01_Pessoal_e_Vida' / '01.1_Identidade_e_Documentos')
            elif ext_l == '.pst':
                # Backup PST
                safe_copy_or_move_file(item, ROOT / '06_Backups_ISOs_e_Sistemas' / '06.2_Backups_e_Snapshots')
            elif ext_l == '.txt':
                # Anotações/scripts txt
                if 'office' in name_l or 'anydesk' in name_l or 'debloat' in name_l:
                    safe_copy_or_move_file(item, ROOT / '04_Desenvolvimento_e_Codigo' / '04.2_Scripts_e_Bancos')
                else:
                    safe_copy_or_move_file(item, cat_manut)
            else:
                safe_copy_or_move_file(item, cat_manut)

    # 4. Remover zips duplicados quando a pasta descompactada do mesmo nome existe em Ferramentas_TI
    print("Deduplicando zips redundantes onde a pasta descompactada existe...")
    for zip_file in list(TARGET_BASE.rglob('*.zip')) + list(TARGET_BASE.rglob('*.rar')) + list(TARGET_BASE.rglob('*.7z')):
        stem = zip_file.stem
        # Procura pasta correspondente no mesmo diretório ou subdiretórios
        matching_dir = zip_file.parent / stem
        if matching_dir.exists() and matching_dir.is_dir():
            zip_file.unlink()
            print(f"Removido zip redundante: {zip_file.relative_to(TARGET_BASE)}")

    # 5. Sanitizar nomes de todas as pastas e arquivos dentro de TARGET_BASE
    print("Sanitizando e normalizando toda a árvore de Ferramentas_TI...")
    for item in list(TARGET_BASE.rglob('*')):
        if item.is_file():
            clean_junk(item)
            clean_n = sanitize_name(item.name)
            if clean_n != item.name:
                new_p = item.parent / clean_n
                c = 1
                while new_p.exists() and new_p != item:
                    new_p = item.parent / f"{new_p.stem}_{c}{new_p.suffix}"
                    c += 1
                try:
                    item.rename(new_p)
                except Exception:
                    pass

    # 6. Remover pasta FERRAMENTAS se vazia
    shutil.rmtree(FERRAMENTAS, ignore_errors=True)
    print("=== ORGANIZAÇÃO DE 1 - FERRAMENTAS CONCLUÍDA! ===")

if __name__ == "__main__":
    main()
