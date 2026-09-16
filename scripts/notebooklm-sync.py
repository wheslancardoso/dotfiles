#!/usr/bin/env python3
"""
==============================================================================
📦 COMPILADOR & SINCRONIZADOR DE CONTEXTO NOTEBOOKLM (GEMINI NOTEBOOK)
==============================================================================
Compila todo o acervo do timeless_life (Pastas 00 a 11 + Contexto Estratégico TCE-GO)
em Megadocs temáticos ultra-otimizados e sincroniza diretamente para o Google Drive
via rclone, permitindo importação e atualização contínua no NotebookLM.

Megadocs gerados (Pastas 00 a 11 + Contexto do Concurso):
  1. Notebook_00_Identidade_Principios_e_Manifestos.md  (00 e 01)
  2. Notebook_01_Familia_Relacionamento_e_Filhos.md     (02 e 03)
  3. Notebook_02_Postura_Social_e_Financas.md           (04 e 05)
  4. Notebook_03_Capsula_do_Tempo_Esposa.md             (06)
  5. Notebook_04_Biblioteca_Tecnica_e_Engenharia.md     (07)
  6. Notebook_05_Repertorio_Cultural_e_Ingles.md        (08 e 09)
  7. Notebook_06_Prompts_IA_e_Carreira_Wtechapp.md      (10, 11 e .agents)
  8. Notebook_07_TCE_GO_Contexto_Estrategico_Guerra.md  (Apenas contexto do edital/estratégia, sem aulas/erros)

Uso:
  python3 notebooklm-sync.py              # Compila e sincroniza para gdrive:NotebookLM_Context
  python3 notebooklm-sync.py --local-only # Apenas compila localmente para teste
  python3 notebooklm-sync.py --watch      # Monitora alterações e sincroniza
==============================================================================
"""

import os
import sys
import time
import argparse
import subprocess
from pathlib import Path
from datetime import datetime

# Cores no terminal
BOLD = "\033[1m"
GREEN = "\033[38;2;166;227;161m"
BLUE = "\033[38;2;137;180;250m"
YELLOW = "\033[38;2;249;226;175m"
MAUVE = "\033[38;2;203;166;247m"
RED = "\033[38;2;243;139;168m"
NC = "\033[0m"

WORKSPACE_DIR = Path(os.environ.get("TIMELESS_LIFE_DIR", Path.home() / "timeless_life"))
OUTPUT_DIR = Path.home() / ".cache" / "notebooklm_sync"
RCLONE_REMOTE = os.environ.get("NOTEBOOKLM_RCLONE_REMOTE", "gdrive:NotebookLM_Context")

# Definição dos Grupos Temáticos (Pastas 00 a 11 + Contexto Estratégico TCE-GO)
CLUSTERS = {
    "Notebook_00_Identidade_Principios_e_Manifestos.md": {
        "title": "🏛️ CLUSTER 00: IDENTIDADE, PRINCÍPIOS, MEMÓRIA VIVA & MANIFESTOS DO HOMEM",
        "description": "Contexto mestre da memória viva do agente, checklists do homem completo e manifestos de propósito e visão.",
        "paths": [
            "00 - Contexto Mestre & Memoria Viva do Agente.md",
            "00 - O Master Checklist do Homem Completo.md",
            "01 - O Núcleo do Homem & Manifestos (Propósito & Visão)"
        ]
    },
    "Notebook_01_Familia_Relacionamento_e_Filhos.md": {
        "title": "💍 CLUSTER 01: RELACIONAMENTO, ALINHAMENTO DE OURO & PATERNIDADE",
        "description": "Protocolos de casamento/namoro de alto valor, criação de filhos inabaláveis e cartas de legado.",
        "paths": [
            "02 - Relacionamento, Alinhamento de Ouro & Intimidade",
            "03 - Paternidade & Criação dos Filhos Inabaláveis"
        ]
    },
    "Notebook_02_Postura_Social_e_Financas.md": {
        "title": "⚔️ CLUSTER 02: COMUNICAÇÃO, POSTURA SOCIAL, FINANÇAS & DISCIPLINA",
        "description": "Simulações sociais, oratória, postura de Homem Rocha, finanças, blindagem mental e NoFap.",
        "paths": [
            "04 - Comunicação, Postura & Simulações Sociais",
            "05 - Disciplina, Finanças & Blindagem Mental"
        ]
    },
    "Notebook_03_Capsula_do_Tempo_Esposa.md": {
        "title": "💌 CLUSTER 03: O TESOURO DA MINHA ESPOSA (CÁPSULA DO TEMPO)",
        "description": "Cartas de amor, memórias de relacionamento, promessas e registros emocionais perpétuos.",
        "paths": [
            "06 - O Tesouro da Minha Esposa (Cápsula do Tempo)"
        ]
    },
    "Notebook_04_Biblioteca_Tecnica_e_Engenharia.md": {
        "title": "📚 CLUSTER 04: BIBLIOTECA TÉCNICA & LIVROS DE ENGENHARIA DE ELITE",
        "description": "Resumos de alta densidade de livros clássicos de arquitetura, DDD, Clean Code, concorrência e bancos.",
        "paths": [
            "07 - Biblioteca Técnica & Livros de Engenharia de Elite"
        ]
    },
    "Notebook_05_Repertorio_Cultural_e_Ingles.md": {
        "title": "🎬 CLUSTER 05: REPERTÓRIO CULTURAL, SABEDORIA & MAESTRIA EM INGLÊS",
        "description": "Filmes, séries, clássicos da literatura, sabedoria perene e imersão/shadowing em inglês de elite.",
        "paths": [
            "08 - Repertório Cultural (Cinema, Séries & Livros de Sabedoria)",
            "09 - Maestria em Inglês de Elite & Imersão Global"
        ]
    },
    "Notebook_06_Prompts_IA_e_Carreira_Wtechapp.md": {
        "title": "⚡ CLUSTER 06: PROMPTS DE IA, CARREIRA & EMPREENDIMENTOS (WTECHAPP)",
        "description": "Sistemas de prompts de ghostwriting, diretrizes de carreira sênior, AGR, wtechapp e Protocolo Dojo.",
        "paths": [
            "10 - Prompts & Configurações de IA (Ghostwriters)",
            "11 - Carreira, Engenharia de Software & Empreendimentos (wtechapp)",
            ".agents/AGENTS.md",
            ".agents/PROTOCOLO_DOJO_PILOTO_EM_COMANDO.md"
        ]
    },
    "Notebook_07_TCE_GO_Contexto_Estrategico_Guerra.md": {
        "title": "🎯 CLUSTER 07: OPERAÇÃO POSSE TCE-GO 2026 — CONTEXTO & DIRETRIZES DE GUERRA",
        "description": "Raio-X do concurso, cronograma de batalha dos 145 dias, edital verticalizado, SOP diário e manual de guerra do NotebookLM (sem aulas teóricas e sem caderno de erros).",
        "paths": [
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/00 - Master Checklist & Painel de Fechamento de Lacunas (Operação Posse TCE-GO).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/00 - O Manifesto de Guerra dos 145 Dias (A Conquista da Posse TCE-GO 2026).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/00 - O Raio-X & Guia Mestre do Concurso TCE-GO 2026.md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/01 - O Protocolo de Guerra dos 145 Dias (Rotina, 20.000 Questoes & SOP Diario).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/02 - O Edital Oficial Compilado (TCE-GO 2026 - FCC).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/03 - O Edital Verticalizado & Checklist de Conteúdo Programático.md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/04 - O Treinador de Estudo de Caso (Discursiva de TI - 100 Pontos).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/06 - O Mapa de Filtros Exatos do Estrategia Questoes.md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/07 - O Tutor de Questoes de Guerra (SOP Efeito Queijo Suico).md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/09 - A Ordem Sequencial de Batalha dos 10 Cadernos.md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/10 - O Rastreador de Streaks & Painel de Disciplina Suprema.md",
            "12 - Operação Posse TCE-GO 2026 (Tecnologia da Informação)/11 - O Manual de Guerra do NotebookLM (Podcasts de Audio, Video & Imersao nos Tempos Mortos).md"
        ]
    }
}

# Ignorar extensões e pastas que poluem o contexto
IGNORED_PATTERNS = {
    ".git", "__pycache__", "node_modules", ".sabedoria_index.db",
    "expurgo", ".html", ".png", ".jpg", ".jpeg", ".pdf"
}

def log(msg, color=NC):
    print(f"{color}{msg}{NC}")

def collect_files(target_paths):
    """Varre e coleta arquivos válidos em ordem alfabética."""
    collected = []
    for rel_path in target_paths:
        full_path = WORKSPACE_DIR / rel_path
        if not full_path.exists():
            continue
        if full_path.is_file():
            if full_path.suffix.lower() == ".md":
                collected.append(full_path)
        elif full_path.is_dir():
            for root, dirs, files in os.walk(full_path):
                # Ignorar pastas indesejadas
                dirs[:] = [d for d in dirs if d not in IGNORED_PATTERNS and not d.startswith(".")]
                for file in sorted(files):
                    if file.endswith(".md"):
                        collected.append(Path(root) / file)
    return sorted(list(set(collected)))

def compile_cluster(cluster_filename, cluster_info):
    """Compila uma lista de arquivos .md em um único Megadoc estruturado."""
    files = collect_files(cluster_info["paths"])
    if not files:
        return None, 0, 0

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = OUTPUT_DIR / cluster_filename
    
    total_words = 0
    now_str = datetime.now().strftime("%d/%m/%Y %H:%M:%S")

    with open(out_path, "w", encoding="utf-8") as out:
        out.write(f"# {cluster_info['title']}\n\n")
        out.write(f"> **Descrição:** {cluster_info['description']}  \n")
        out.write(f"> **Última Compilação Automática:** `{now_str}`  \n")
        out.write(f"> **Total de Arquivos Compilados:** `{len(files)}`  \n\n")
        out.write("---\n\n")
        
        # Índice interno
        out.write("## 📑 ÍNDICE GERAL DESTE NOTEBOOK\n\n")
        for idx, f in enumerate(files, 1):
            try:
                rel = f.relative_to(WORKSPACE_DIR)
            except ValueError:
                rel = f.name
            out.write(f"{idx}. `{rel}`\n")
        out.write("\n---\n\n")

        # Conteúdo de cada arquivo
        for idx, f in enumerate(files, 1):
            try:
                rel = f.relative_to(WORKSPACE_DIR)
            except ValueError:
                rel = f.name
            
            try:
                content = f.read_text(encoding="utf-8", errors="replace")
            except Exception as e:
                content = f"*[Erro ao ler arquivo: {e}]*"

            word_count = len(content.split())
            total_words += word_count

            out.write(f"<!-- INICIO_ARQUIVO: {rel} -->\n")
            out.write(f"# [ARQUIVO {idx:02d}] {rel}\n\n")
            out.write(content.strip())
            out.write("\n\n<!-- FIM_ARQUIVO -->\n\n---\n\n")

    return out_path, len(files), total_words

def sync_to_gdrive():
    """Envia os Megadocs compilados para o Google Drive via rclone."""
    log(f"\n☁️ Sincronizando com Google Drive via Rclone ({RCLONE_REMOTE})...", BLUE)
    
    # Verifica se rclone está instalado
    try:
        subprocess.run(["rclone", "version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
    except (subprocess.SubprocessError, FileNotFoundError):
        log("⚠️ 'rclone' não foi encontrado ou não está no PATH local.", RED)
        log("💡 No Arch Linux com rclone instalado e remote 'gdrive' configurado, o sync roda 100% automático.", YELLOW)
        return False

    cmd = [
        "rclone", "sync",
        str(OUTPUT_DIR),
        RCLONE_REMOTE,
        "--progress",
        "--update",
        "--verbose"
    ]
    
    try:
        subprocess.run(cmd, check=True)
        log("✅ Sincronização com o Google Drive concluída com sucesso!", GREEN)
        return True
    except subprocess.CalledProcessError as e:
        log(f"❌ Erro ao sincronizar via rclone: {e}", RED)
        return False

def build_all(local_only=False):
    log("==================================================================", MAUVE)
    log("🚀 INICIANDO COMPILADOR MASTER NOTEBOOKLM (GEMINI NOTEBOOK)", BOLD + MAUVE)
    log(f"📁 Diretório Workspace: {WORKSPACE_DIR}", NC)
    log(f"📦 Diretório de Saída:  {OUTPUT_DIR}", NC)
    log("==================================================================", MAUVE)

    if not WORKSPACE_DIR.exists():
        log(f"❌ Erro: Diretório {WORKSPACE_DIR} não existe.", RED)
        sys.exit(1)

    total_files_all = 0
    total_words_all = 0

    for filename, info in CLUSTERS.items():
        out_path, count, words = compile_cluster(filename, info)
        if out_path:
            total_files_all += count
            total_words_all += words
            size_kb = out_path.stat().st_size / 1024
            log(f"✨ {filename} -> {count:2d} arquivos | {words:6d} palavras | {size_kb:6.1f} KB", GREEN)
        else:
            log(f"⚠️ {filename} -> Nenhum arquivo encontrado.", YELLOW)

    log("------------------------------------------------------------------", MAUVE)
    log(f"📊 TOTAL CONSOLIDADO: {total_files_all} arquivos | {total_words_all:,} palavras", BOLD + GREEN)
    log(f"🎯 Total de Megadocs gerados: {len(CLUSTERS)} (Encaixa com folga no limite de 50 fontes!)", BOLD + BLUE)

    if not local_only:
        sync_to_gdrive()
    else:
        log("\n💡 Flag --local-only ativada: Sincronização via nuvem ignorada.", YELLOW)

def main():
    parser = argparse.ArgumentParser(description="Compila e sincroniza notas do timeless_life para o NotebookLM.")
    parser.add_argument("--local-only", action="store_true", help="Apenas compila os arquivos na máquina local.")
    parser.add_argument("--watch", action="store_true", help="Executa em modo contínuo monitorando a cada X segundos.")
    parser.add_argument("--interval", type=int, default=300, help="Intervalo de monitoramento em segundos (padrão: 300s / 5min).")
    args = parser.parse_args()

    if args.watch:
        log(f"👀 Modo Watch ativado. Atualizando a cada {args.interval} segundos (Ctrl+C para sair)...", BLUE)
        try:
            while True:
                build_all(local_only=args.local_only)
                time.sleep(args.interval)
        except KeyboardInterrupt:
            log("\n🛑 Modo Watch encerrado.", YELLOW)
    else:
        build_all(local_only=args.local_only)

if __name__ == "__main__":
    main()
