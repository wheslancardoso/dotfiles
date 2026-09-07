#!/usr/bin/env python3
"""
🚀 REMOVER MARCA D'ÁGUA — ARCH LINUX POWER PDF SUITE
Ferramenta para remoção cirúrgica de marcas d'água, anotações de carimbo e CPFs
em PDFs de concursos, apostilas e documentos.
Pode abrir diretamente no Master PDF Editor (equivalente Foxit Premium).
"""

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Optional

try:
    import pypdf
except ImportError:
    pypdf = None


def remove_watermark_annotations(input_pdf: Path, output_pdf: Path, text_pattern: Optional[str] = None) -> int:
    """Remove objetos de anotação de marca d'água e carimbos de páginas de PDF."""
    if not pypdf:
        print("[ERRO] Biblioteca pypdf não instalada.")
        return 0

    reader = pypdf.PdfReader(str(input_pdf))
    writer = pypdf.PdfWriter()

    removed_count = 0
    pattern = re.compile(text_pattern, re.IGNORECASE) if text_pattern else None

    for idx, page in enumerate(reader.pages):
        # 1. Checa anotações (/Annots)
        if "/Annots" in page:
            annots = page["/Annots"]
            new_annots = []
            for annot_ref in annots:
                annot = annot_ref.get_object()
                subtype = annot.get("/Subtype", "")
                contents = str(annot.get("/Contents", ""))

                # Remove se for tipo Watermark, Stamp ou se o conteúdo bater com o padrão
                is_watermark = subtype in ["/Watermark", "/Stamp"]
                matches_pattern = pattern.search(contents) if pattern and contents else False

                if is_watermark or matches_pattern:
                    removed_count += 1
                else:
                    new_annots.append(annot_ref)

            if len(new_annots) < len(annots):
                page[pypdf.generic.NameObject("/Annots")] = pypdf.generic.ArrayObject(new_annots)

        writer.add_page(page)

    with open(output_pdf, "wb") as f:
        writer.write(f)

    return removed_count


def crop_pdf_margins(input_pdf: Path, output_pdf: Path, top_mm: float = 12.0, bottom_mm: float = 12.0) -> None:
    """Recorta margens superior e inferior em milímetros (elimina faixas de rodapé/cabeçalho)."""
    if not pypdf:
        return

    reader = pypdf.PdfReader(str(input_pdf))
    writer = pypdf.PdfWriter()

    # 1 mm = 72 / 25.4 pontos = ~2.8346 pt
    pt_per_mm = 72.0 / 25.4
    top_pt = top_mm * pt_per_mm
    bottom_pt = bottom_mm * pt_per_mm

    for page in reader.pages:
        box = page.mediabox
        page.mediabox.lower_left = (box.left, box.bottom + bottom_pt)
        page.mediabox.upper_right = (box.right, box.top - top_pt)
        writer.add_page(page)

    with open(output_pdf, "wb") as f:
        writer.write(f)


def main():
    parser = argparse.ArgumentParser(
        description="Remover Marca d'Água e Editor de PDFs (Estilo Foxit Premium)"
    )
    parser.add_argument("pdf", help="Caminho do arquivo PDF a processar")
    parser.add_argument("-t", "--text", type=str, help="Texto ou CPF da marca d'água a remover")
    parser.add_argument("-c", "--crop", action="store_true", help="Recorta faixas de cabeçalho e rodapé (12mm)")
    parser.add_argument("-g", "--gui", action="store_true", help="Abre o arquivo no Master PDF Editor (Interface visual completa)")
    parser.add_argument("-a", "--arranger", action="store_true", help="Abre no PDF Arranger (organizar páginas, recortar)")
    parser.add_argument("-o", "--output", type=str, help="Arquivo de destino (Padrão: [nome]_limpo.pdf)")

    args = parser.parse_args()

    input_path = Path(args.pdf).resolve()
    if not input_path.exists():
        print(f"[ERRO] Arquivo não encontrado: {input_path}")
        sys.exit(1)

    if args.gui:
        editor = shutil.which("masterpdfeditor5") or shutil.which("masterpdfeditor")
        if editor:
            print(f"Abrindo {input_path.name} no Master PDF Editor...")
            subprocess.Popen([editor, str(input_path)])
            return
        else:
            print("[AVISO] Master PDF Editor não encontrado no PATH.")

    if args.arranger:
        arranger = shutil.which("pdfarranger")
        if arranger:
            subprocess.Popen([arranger, str(input_path)])
            return

    output_path = Path(args.output).resolve() if args.output else input_path.with_name(f"{input_path.stem}_limpo.pdf")

    print("==========================================================")
    print("   🚀 REMOVER MARCA D'ÁGUA — PROCESSAMENTO CIRÚRGICO       ")
    print("==========================================================")
    print(f" Arquivo de Origem : {input_path.name}")
    print(f" Arquivo de Saída  : {output_path.name}")
    if args.text:
        print(f" Padrão de Texto   : {args.text}")
    print("----------------------------------------------------------")

    if args.crop:
        print("Recortando margens de cabeçalho/rodapé...")
        crop_pdf_margins(input_path, output_path)
        print(f"✔ Margens recortadas salvas em: {output_path.name}")
    else:
        removed = remove_watermark_annotations(input_path, output_path, text_pattern=args.text)
        print(f"✔ Processamento concluído: {removed} anotações/marcas removidas.")
        print(f"✔ Salvo com sucesso em: {output_path.name}")

    print("==========================================================")


if __name__ == "__main__":
    main()
