"""
Interface de Linha de Comando (CLI) para o Organizador Master.
"""

import argparse
import sys
from pathlib import Path

from .core import FileOrganizerEngine
from .history import HistoryManager
from .partition_calc import PartitionCalculator
from .renamer import AutoNamer
from .taxonomy import TaxonomyManager
from .utils import Colors, log_error, log_info, log_success, log_warning


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Organizador Master — Suíte de Padronização e Limpeza Automatizada de Arquivos",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos de Uso:
  python main.py --all                      # Varre Desktop, Downloads e aplica taxonomia
  python main.py --all --dry-run            # Simula a organização sem mover nenhum arquivo
  python main.py --desktop                  # Limpa a Área de Trabalho mantendo apenas atalhos
  python main.py --downloads                # Organiza a pasta Downloads
  python main.py --drive "D:\\MeuGoogleDrive" # Organiza arquivos baixados do Google Drive
  python main.py --scaffold-only            # Apenas cria a estrutura de pastas 00..06
  python main.py --undo                     # Desfaz a última sessão de organização (move de volta)
  python main.py --history                  # Lista o histórico de sessões executadas
  python main.py --auto-date "D:\\Downloads"  # Padroniza nomes adicionando data ISO (YYYY-MM-DD_)
  python main.py --sanitize "D:\\Downloads"   # Limpa caracteres e artefatos de download de nomes
  python main.py --calc-disk 480            # Calcula particionamento ótimo para SSD de 480 GB (ou 256, 1000, etc.)
        """,
    )

    parser.add_argument("--all", action="store_true", help="Executa varredura completa (Desktop + Downloads)")
    parser.add_argument("--desktop", action="store_true", help="Organiza apenas a Área de Trabalho (Desktop)")
    parser.add_argument("--downloads", action="store_true", help="Organiza apenas a pasta Downloads")
    parser.add_argument("--drive", type=str, help="Caminho de uma pasta personalizada (ex: Google Drive baixado)")
    parser.add_argument("--scaffold-only", action="store_true", help="Apenas gera a árvore de diretórios 00..06")
    parser.add_argument("--dry-run", action="store_true", help="Modo simulação: exibe o que seria feito sem mover/alterar nada")
    parser.add_argument("--dest", type=str, help="Define pasta raiz de destino para as pastas 00..06 (Padrão: ~/Documents)")
    parser.add_argument("--undo", action="store_true", help="Desfaz a última sessão de movimentação de arquivos")
    parser.add_argument("--history", action="store_true", help="Exibe histórico de movimentações anteriores")
    parser.add_argument("--auto-date", type=str, help="Adiciona data ISO e padroniza nomes de arquivos no diretório informado")
    parser.add_argument("--sanitize", type=str, help="Sanitiza nomes de arquivos (remove ' (1)', espaços) no diretório informado")
    parser.add_argument("--calc-disk", type=float, help="Calcula a divisão ótima de partições C: e D: para o tamanho de disco informado em GB (ex: 256, 480, 512, 1000, 2000)")
    parser.add_argument("--recursive", action="store_true", help="Aplica a operação de forma recursiva em subpastas")

    return parser


def show_history(history_mgr: HistoryManager) -> None:
    sessions = history_mgr.list_recent_sessions(limit=10)
    if not sessions:
        log_info("Nenhuma sessão registrada no histórico ainda.")
        return

    print(f"\n{Colors.BOLD}{Colors.HEADER}=== HISTÓRICO DE SESSÕES RECENTES ==={Colors.END}")
    for idx, s in enumerate(sessions, 1):
        sid = s.get("session_id", "N/A")
        ts = s.get("timestamp", "N/A")
        desc = s.get("description", "Organização")
        total = s.get("total_items", 0)
        print(f" {idx}. [{sid}] {ts} — {desc} ({total} arquivos)")
    print(f"{Colors.BOLD}{Colors.HEADER}======================================{Colors.END}\n")


def run_cli():
    parser = build_parser()
    args = parser.parse_args()

    project_root = Path(__file__).resolve().parent.parent
    config_path = project_root / "config" / "regras.json"

    if not config_path.exists():
        log_error(f"Arquivo de configuração não encontrado em: {config_path}")
        sys.exit(1)

    print(f"\n{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}")
    print(f"{Colors.BOLD}{Colors.HEADER}   ORGANIZADOR MASTER — ÁPICE DA EFICIÊNCIA          {Colors.END}")
    print(f"{Colors.BOLD}{Colors.HEADER}===================================================={Colors.END}\n")

    # Comando: --calc-disk
    if args.calc_disk is not None:
        calc_res = PartitionCalculator.calculate(args.calc_disk)
        report = PartitionCalculator.format_report(calc_res)
        print(report)
        return

    history_mgr = HistoryManager()

    # Comando: --history
    if args.history:
        show_history(history_mgr)
        return

    # Comando: --undo
    if args.undo:
        log_info("Executando reversão (Undo) da última sessão...")
        successes, errors = history_mgr.undo_last_session(dry_run=args.dry_run)
        print(f"\n{Colors.BOLD}{Colors.GREEN}================== RESUMO DO UNDO =================={Colors.END}")
        print(f" Arquivos Restaurados : {successes}")
        print(f" Erros na Reversão    : {errors}")
        print(f"{Colors.BOLD}{Colors.GREEN}===================================================={Colors.END}\n")
        return

    # Comando: --auto-date ou --sanitize
    if args.auto_date or args.sanitize:
        target = Path(args.auto_date if args.auto_date else args.sanitize).resolve()
        add_date = bool(args.auto_date)
        renamer = AutoNamer()
        stats = renamer.process_directory(
            target_dir=target,
            add_date=add_date,
            sanitize=True,
            recursive=args.recursive,
            dry_run=args.dry_run,
        )
        print(f"\n{Colors.BOLD}{Colors.GREEN}================== RESUMO DA RENOMEAÇÃO =============={Colors.END}")
        print(f" Total de Arquivos     : {stats['total']}")
        print(f" Arquivos Renomeados   : {stats['renomeados']}")
        print(f" Arquivos Inalterados  : {stats['inalterados']}")
        print(f" Erros                 : {stats['erros']}")
        print(f"{Colors.BOLD}{Colors.GREEN}===================================================={Colors.END}\n")
        return

    dest_root = Path(args.dest).resolve() if args.dest else (Path.home() / "Documents")

    # 1. Garantir estrutura de taxonomia mestre
    engine = FileOrganizerEngine(config_path=config_path, custom_dest_root=dest_root, history_manager=history_mgr)
    taxonomy = TaxonomyManager(root_documents=dest_root, config=engine.config)

    log_info(f"Destino Mestre: {dest_root}")
    taxonomy.scaffold(dry_run=args.dry_run)

    if args.scaffold_only:
        log_success("Árvore de taxonomia criada com sucesso!")
        return

    # Se nenhum argumento específico for passado, assume --all
    if not (args.desktop or args.downloads or args.drive or args.all):
        args.all = True

    total_stats = {"total_analisados": 0, "movidos": 0, "ignorados": 0, "erros": 0}

    # 2. Execuções
    if args.drive:
        drive_path = Path(args.drive).resolve()
        log_info(f"Modo Google Drive Ativado para: {drive_path}")
        st = engine.organize_directory(drive_path, recursive=args.recursive, dry_run=args.dry_run)
        for k in total_stats:
            total_stats[k] += st[k]

    if args.desktop or args.all:
        log_info("Organizando Área de Trabalho (Desktop)...")
        st = engine.organize_directory(engine.desktop, recursive=False, dry_run=args.dry_run)
        for k in total_stats:
            total_stats[k] += st[k]

    if args.downloads or args.all:
        log_info("Organizando Downloads...")
        st = engine.organize_directory(engine.downloads, recursive=False, dry_run=args.dry_run)
        for k in total_stats:
            total_stats[k] += st[k]

    # Salva sessão se houver arquivos movidos
    if not args.dry_run and total_stats["movidos"] > 0:
        session_id = engine.commit_session(description="Organização Master")
        if session_id:
            log_info(f"Sessão [{session_id}] registrada no histórico com sucesso (use --undo para reverter).")

    print(f"\n{Colors.BOLD}{Colors.GREEN}================== RESUMO GERAL ===================={Colors.END}")
    print(f" Arquivos Analisados : {total_stats['total_analisados']}")
    print(f" Arquivos Movidos    : {total_stats['movidos']}")
    print(f" Arquivos Ignorados  : {total_stats['ignorados']}")
    print(f" Erros Encontrados   : {total_stats['erros']}")
    print(f"{Colors.BOLD}{Colors.GREEN}===================================================={Colors.END}\n")
