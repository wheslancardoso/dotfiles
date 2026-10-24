#!/usr/bin/env python3
"""
gta-modman.py - Gerenciador Cirúrgico do Modpack Definitivo do GTA San Andreas (2026)
Integração com ModLoader, CLEO, Heroic Games Launcher e Wine Staging/DXVK.
"""

import sys
import os
import re
import time
import json
import shutil
import subprocess
import argparse
from pathlib import Path

# Caminhos Canônicos
GAME_DIR = Path("/mnt/dados/Games/GTA_San_Andreas")
MODLOADER_DIR = GAME_DIR / "modloader"
CLEO_DIR = GAME_DIR / "CLEO"
WINE_PREFIX = Path("/mnt/dados/Games/pfx_gtasa")
CATALOG_MD = Path("/home/lan/dotfiles/MODPACK_DEFINITIVO_GTA_SA.md")

INBOX_DIRS = [
    Path.home() / "downloads",
    Path.home() / "Downloads",
    Path("/mnt/dados/00_Inbox_Triagem"),
    Path("/mnt/dados/00_Inbox_Triagem/ABDM/Compressed")
]

HEROIC_CONFIG = Path.home() / ".config" / "heroic"
HEROIC_LIBRARY = HEROIC_CONFIG / "sideload_apps" / "library.json"
HEROIC_GAME_CONF = HEROIC_CONFIG / "GamesConfig" / "gtasa_essentials.json"

MIXMODS_PASSWORD = "mixmods.com.br"

IGNORE_PATTERNS = [
    "gta san andreas - mixmods.com.br-001",
    "personal_photos",
    "windows_11",
    "pt-br_windows",
    "skyrim",
    "the elder scrolls",
    "vault_legado"
]

# Cores ANSI
class C:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RED = "\033[31m"
    CYAN = "\033[36m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    DIM = "\033[2m"

def get_installed_entries():
    """Retorna conjunto de arquivos e pastas instalados no jogo."""
    installed = set()
    if MODLOADER_DIR.exists():
        for item in MODLOADER_DIR.iterdir():
            installed.add(item.name.lower())
            if item.is_dir():
                for sub in item.iterdir():
                    installed.add(sub.name.lower())
    if CLEO_DIR.exists():
        for item in CLEO_DIR.iterdir():
            installed.add(item.name.lower())
    for item in GAME_DIR.glob("*.asi"):
        installed.add(item.name.lower())
    for item in GAME_DIR.glob("*.dll"):
        installed.add(item.name.lower())
    return installed

def get_inbox_archives():
    """Varre pastas de inbox/downloads procurando arquivos compactados válidos."""
    archives = {}
    for d in INBOX_DIRS:
        if d.exists():
            for p in d.iterdir():
                if p.is_file() and p.suffix.lower() in [".zip", ".7z", ".rar"]:
                    name_lower = p.name.lower()
                    if any(ign in name_lower for ign in IGNORE_PATTERNS):
                        continue
                    archives[name_lower] = p
    return archives

def parse_catalog():
    """Lê o MODPACK_DEFINITIVO_GTA_SA.md e extrai os mods curados."""
    if not CATALOG_MD.exists():
        print(f"{C.RED}Catálogo não encontrado em {CATALOG_MD}{C.RESET}")
        return []

    lines = CATALOG_MD.read_text(encoding="utf-8").split("\n")
    mods = []
    current_category = "Geral"
    
    idx = 1
    pattern = r"^\*\s+\*\*\[(.*?)\]\s+(.*?):\*\*\s+(.*)$"
    
    for line in lines:
        line_str = line.strip()
        if line_str.startswith("### "):
            current_category = line_str.replace("### ", "").strip()
            continue
            
        m = re.match(pattern, line_str)
        if m:
            status_tag = m.group(1).strip()
            name = m.group(2).strip()
            rest = m.group(3).strip()
            
            links = re.findall(r"\[(.*?)\]\((.*?)\)", rest)
            page_url = ""
            downloads = []
            
            for label, url in links:
                if "Post MixMods" in label or "Post" in label:
                    page_url = url
                elif any(dom in url for dom in ["sharemods", "mediafire", "github.com", "mega.nz", "drive.google", "dropbox"]):
                    downloads.append({"label": label, "url": url})
            if not page_url and links:
                page_url = links[0][1]

            clean_name = re.sub(r"\(.*?\)", "", name).strip()
            keywords = [w.lower() for w in re.split(r"[^a-zA-Z0-9]+", clean_name) if len(w) > 3]

            mods.append({
                "id": idx,
                "title": name,
                "clean_name": clean_name,
                "category": current_category,
                "keywords": keywords,
                "page_url": page_url,
                "downloads": downloads,
                "tag": status_tag
            })
            idx += 1
            
    return mods

def match_mod_status(mod, installed_entries, inbox_archives):
    """Determina o status do mod: INSTALLED, DOWNLOADED, PENDING."""
    clean = mod["clean_name"].lower()
    keywords = mod["keywords"]
    
    for inst in installed_entries:
        if clean and (clean in inst or inst in clean):
            return "INSTALLED", inst
        if keywords and len(keywords) >= 2 and all(k in inst for k in keywords[:2]):
            return "INSTALLED", inst

    for arch_name, arch_path in inbox_archives.items():
        if clean and (clean in arch_name or arch_name in clean):
            return "DOWNLOADED", arch_path
        if keywords and len(keywords) >= 2 and all(k in arch_name for k in keywords[:2]):
            return "DOWNLOADED", arch_path

    if "INSTALADO" in mod["tag"]:
        return "INSTALLED", "Manual/Verified"

    return "PENDING", None

def cmd_status(args):
    print(f"\n{C.BOLD}{C.CYAN}=== 🎮 GTA SAN ANDREAS - AUDITORIA FORENSE DE SISTEMA ==={C.RESET}")
    print(f"Diretório do Jogo:  {C.GREEN if GAME_DIR.exists() else C.RED}{GAME_DIR}{C.RESET}")
    print(f"Prefixo Wine:       {C.GREEN if WINE_PREFIX.exists() else C.RED}{WINE_PREFIX}{C.RESET}")
    
    heroic_ok = HEROIC_GAME_CONF.exists() and HEROIC_LIBRARY.exists()
    print(f"Heroic Launcher:    {C.GREEN + 'Integrado (Play Ready)' if heroic_ok else C.YELLOW + 'Pendente'}{C.RESET}")
    
    asi_ok = (GAME_DIR / "vorbisFile.dll").exists()
    ml_ok = (GAME_DIR / "modloader.asi").exists()
    cleo_ok = (GAME_DIR / "CLEO.asi").exists()
    cleo_rdx = (GAME_DIR / "cleo_redux.asi").exists()
    exe_ok = (GAME_DIR / "gta_sa.exe").exists()
    
    print(f"\n{C.BOLD}Componentes Fundamentais:{C.RESET}")
    print(f"  - gta_sa.exe v1.0 US:      {'🟢 OK' if exe_ok else '🔴 Ausente'}")
    print(f"  - Silent's ASI Loader:     {'🟢 OK' if asi_ok else '🔴 Ausente'}")
    print(f"  - ModLoader v0.3.8+:       {'🟢 OK' if ml_ok else '🔴 Ausente'}")
    print(f"  - CLEO 4 / CLEO+:          {'🟢 OK' if cleo_ok else '🔴 Ausente'}")
    print(f"  - CLEO Redux x86:          {'🟢 OK' if cleo_rdx else '🔴 Ausente'}")

    mods = parse_catalog()
    installed_entries = get_installed_entries()
    inbox_archives = get_inbox_archives()
    
    inst_count = 0
    down_count = 0
    pend_count = 0
    
    for m in mods:
        st, _ = match_mod_status(m, installed_entries, inbox_archives)
        if st == "INSTALLED":
            inst_count += 1
        elif st == "DOWNLOADED":
            down_count += 1
        else:
            pend_count += 1
            
    print(f"\n{C.BOLD}Estatísticas do Modpack Curado ({len(mods)} mods essenciais selecionados):{C.RESET}")
    print(f"  - 🟢 Instalados no jogo:   {C.GREEN}{C.BOLD}{inst_count}{C.RESET}")
    print(f"  - 🟡 Baixados no Inbox:    {C.YELLOW}{C.BOLD}{down_count}{C.RESET}")
    print(f"  - 🔴 Pendentes de download:{C.RED}{C.BOLD}{pend_count}{C.RESET}")
    print()

def cmd_list(args):
    mods = parse_catalog()
    installed_entries = get_installed_entries()
    inbox_archives = get_inbox_archives()
    
    print(f"\n{C.BOLD}Catálogo Curado de Elite ({len(mods)} mods selecionados):{C.RESET}")
    current_cat = None
    count = 0
    
    for m in mods:
        st, ref = match_mod_status(m, installed_entries, inbox_archives)
        
        if args.installed and st != "INSTALLED":
            continue
        if args.downloaded and st != "DOWNLOADED":
            continue
        if args.pending and st != "PENDING":
            continue
        if args.search and args.search.lower() not in m["title"].lower() and args.search.lower() not in m["category"].lower():
            continue
            
        if m["category"] != current_cat:
            current_cat = m["category"]
            print(f"\n{C.BOLD}{C.BLUE}--- {current_cat} ---{C.RESET}")

        badge = f"{C.GREEN}[INSTALADO]{C.RESET}" if st == "INSTALLED" else (f"{C.YELLOW}[BAIXADO]{C.RESET}" if st == "DOWNLOADED" else f"{C.RED}[PENDENTE]{C.RESET}")
        print(f"{C.DIM}{m['id']:02d}{C.RESET} {badge} {C.BOLD}{m['title']}{C.RESET}")
        if m["page_url"]:
            print(f"    Post:     {C.CYAN}{m['page_url']}{C.RESET}")
        for dl in m["downloads"]:
            print(f"    Download: {C.MAGENTA}{dl['label']}{C.RESET} -> {dl['url']}")
        count += 1
        
    print(f"\nTotal exibido: {count} mods.")

def ingest_file(p):
    """Extrai e instala um arquivo de mod no modloader."""
    name_lower = p.name.lower()
    if any(ign in name_lower for ign in IGNORE_PATTERNS):
        return False
    if not any(name_lower.endswith(ext) for ext in [".zip", ".7z", ".rar"]):
        return False
        
    mod_target_name = re.sub(r"\.(zip|7z|rar)$", "", p.name, flags=re.I)
    mod_target_name = re.sub(r"^(SA_-_|SA_|_)", "", mod_target_name)
    target_dir = MODLOADER_DIR / mod_target_name
    
    print(f"\n{C.YELLOW}⚡ Ingerindo mod recém-chegado:{C.RESET} {p.name}")
    print(f"   Destino: {C.CYAN}modloader/{target_dir.name}{C.RESET}")
    target_dir.mkdir(parents=True, exist_ok=True)
    
    cmd = ["7z", "x", f"-p{MIXMODS_PASSWORD}", f"-o{target_dir}", str(p), "-y"]
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if res.returncode == 0:
        print(f"   {C.GREEN}✔ Instalado com sucesso no ModLoader!{C.RESET}")
        return True
    else:
        cmd_nopass = ["7z", "x", f"-o{target_dir}", str(p), "-y"]
        res_np = subprocess.run(cmd_nopass, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if res_np.returncode == 0:
            print(f"   {C.GREEN}✔ Instalado com sucesso no ModLoader!{C.RESET}")
            return True
        else:
            print(f"   {C.RED}❌ Falha na extração de {p.name}: {res.stderr.decode()[:100]}{C.RESET}")
            return False

def cmd_ingest(args):
    """Varre arquivos compactados nas pastas de inbox e instala no modloader."""
    inbox_dirs = [Path(args.dir)] if args.dir else INBOX_DIRS
    print(f"\n{C.BOLD}{C.CYAN}=== 📥 AUTO-INGESTÃO DE MODS PARA MODLOADER ==={C.RESET}")
    
    found_any = False
    for d in inbox_dirs:
        if not d.exists():
            continue
        for p in d.iterdir():
            if not p.is_file():
                continue
            name_lower = p.name.lower()
            if any(ign in name_lower for ign in IGNORE_PATTERNS):
                continue
                
            is_gta = any(k in name_lower for k in ["sa_", "gta", "cleo", "mod", "fix", "stream", "effect", "retex", "shader", "anim", "weapon", "radar", "urbanize", "person", "traffic", "veh", "ped", "ragdoll", "aiming"])
            if not is_gta and not args.force:
                continue

            if ingest_file(p):
                found_any = True

    if not found_any:
        print(f"{C.DIM}Nenhum arquivo compactado novo encontrado no inbox.{C.RESET}")

def cmd_watch(args):
    """Monitora a pasta de Downloads em tempo real para auto-instalação imediata."""
    downloads_dir = Path.home() / "downloads"
    print(f"\n{C.BOLD}{C.CYAN}=== 🛰️ GTA-MODMAN WATCHER ATIVADO ==={C.RESET}")
    print(f"Monitorando em tempo real: {C.GREEN}{downloads_dir}{C.RESET}")
    print(f"{C.DIM}Assim que você clicar em 'Download' no navegador, o mod será instalado automaticamente no jogo!{C.RESET}")
    print(f"{C.DIM}Pressione Ctrl+C para encerrar o monitoramento.{C.RESET}\n")
    
    known_files = set()
    if downloads_dir.exists():
        for p in downloads_dir.iterdir():
            if p.is_file():
                known_files.add(p.name)
                
    try:
        while True:
            time.sleep(2)
            if not downloads_dir.exists():
                continue
            for p in downloads_dir.iterdir():
                if not p.is_file():
                    continue
                # Se for download temporário, ignora
                if p.name.endswith(".crdownload") or p.name.endswith(".part"):
                    continue
                if p.name not in known_files:
                    known_files.add(p.name)
                    # Aguarda 1s para o arquivo fechar gravação
                    time.sleep(1)
                    ingest_file(p)
    except KeyboardInterrupt:
        print(f"\n{C.YELLOW}Watcher finalizado.{C.RESET}")

def cmd_open_batch(args):
    """Abre os 7 principais mods essenciais pendentes de uma só vez no navegador."""
    essentials = [
        ("First Person Mod v3.0 Fixed", "https://www.mixmods.com.br/2022/03/first-person-mod-primeira-pessoa/"),
        ("Urbanize (Ambient NPCs)", "https://sharemods.com/moincval44bp/SA_-_Urbanize_12-25_Final_1.zip.html"),
        ("Real Traffic Fix v2.2", "https://sharemods.com/jlqyc2ya7lol/SA_-_Real_Traffic_Fix.7z.html"),
        ("VehFuncs v2.5.5", "https://www.mixmods.com.br/2025/12/sa-vehfuncs/"),
        ("Ragdoll Bullet Physics", "https://sharemods.com/txlr846ungla/Ragdoll_Bullet_Physics.zip.html"),
        ("Proper Radar v1.3 (Minimapa HD)", "https://sharemods.com/eenyrp1bklvj/Proper_Radar.7z.html"),
        ("Story Mode v2.0", "https://sharemods.com/iq9lg1tafztf/Story_Mode.7z.html")
    ]
    
    print(f"\n{C.BOLD}{C.CYAN}Abrindo os 7 Mods Estelares no Navegador Brave:{C.RESET}")
    for title, url in essentials:
        print(f"  - {C.BOLD}{title}{C.RESET} -> {C.CYAN}{url}{C.RESET}")
        subprocess.run(["xdg-open", url])
    print(f"\n{C.GREEN}✔ Abas abertas! Assim que clicar em baixar, execute 'gta-modman ingest' (ou use 'gta-modman watch') para instalar tudo de uma vez!{C.RESET}")

def cmd_play(args):
    """Inicia o jogo."""
    launcher = GAME_DIR / "jogar.sh"
    if not launcher.exists():
        print(f"{C.RED}Launcher {launcher} não encontrado!{C.RESET}")
        return
    cmd = [str(launcher)]
    if args.gamescope:
        cmd.append("--gamescope")
    print(f"{C.GREEN}Iniciando GTA San Andreas...{C.RESET}")
    subprocess.run(cmd)

def main():
    parser = argparse.ArgumentParser(description="GTA San Andreas Modpack Manager (gta-modman)")
    sub = parser.add_subparsers(dest="command")
    
    sub.add_parser("status", help="Auditoria forense do jogo e status dos mods")
    
    p_list = sub.add_parser("list", help="Lista catálogo curado de mods")
    p_list.add_argument("--installed", action="store_true", help="Apenas instalados")
    p_list.add_argument("--downloaded", action="store_true", help="Apenas baixados no inbox")
    p_list.add_argument("--pending", action="store_true", help="Apenas pendentes")
    p_list.add_argument("--search", "-s", type=str, help="Filtrar por nome ou categoria")
    
    p_ingest = sub.add_parser("ingest", help="Auto-ingestão e instalação de zips baixados")
    p_ingest.add_argument("--dir", "-d", type=str, help="Diretório específico")
    p_ingest.add_argument("--force", "-f", action="store_true", help="Forçar ingestão de todos os arquivos")
    
    sub.add_parser("watch", help="Monitora ~/downloads em tempo real e auto-instala no ModLoader")
    sub.add_parser("open-batch", help="Abre os 7 principais mods definitivos de uma vez só no navegador")
    
    p_play = sub.add_parser("play", help="Executar o jogo")
    p_play.add_argument("--gamescope", action="store_true", help="Executar dentro do Gamescope")
    
    args = parser.parse_args()
    if not args.command:
        parser.print_help()
        sys.exit(0)
        
    cmds = {
        "status": cmd_status,
        "list": cmd_list,
        "ingest": cmd_ingest,
        "watch": cmd_watch,
        "open-batch": cmd_open_batch,
        "play": cmd_play
    }
    cmds[args.command](args)

if __name__ == "__main__":
    main()
