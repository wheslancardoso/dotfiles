#!/usr/bin/env python3
"""
SKYRIM AE 1.6.318 MASTER INSTALLER & ECOSYSTEM AUTOMATOR
Utilitário para instalação, extração seletiva de FOMODs, sanitização de case sensitivity,
sincronização de plugins.txt e calibração de DXVK/INIs no Linux (Arch/CachyOS).
"""
import os
import sys
import json
import shutil
import subprocess
import glob
import re

GAME_DIR = "/mnt/dados/Jogos/Skyrim-AE"
DATA_DIR = os.path.join(GAME_DIR, "Data")
DOWNLOADS_DIR = os.path.join(GAME_DIR, "Downloads_Mods")
INBOX_DIR = "/mnt/dados/00_Inbox_Triagem"
PREFIX_DIR = "/home/lan/Games/Heroic/Prefixes/shared"
STEAMUSER_DIR = os.path.join(PREFIX_DIR, "pfx/drive_c/users/steamuser")
PUBLIC_DIR = os.path.join(PREFIX_DIR, "pfx/drive_c/users/Public")
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MANIFEST_FILE = os.path.join(SCRIPT_DIR, "skyrim_mods_manifest.json")
PENDING_FILE = os.path.join(SCRIPT_DIR, "mods_pendentes_download.json")

def print_header(title):
    print(f"\n{'=' * 65}")
    print(f"  {title}")
    print(f"{'=' * 65}")

def run_cmd(cmd, cwd=None):
    res = subprocess.run(cmd, shell=isinstance(cmd, str), cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return res

def cmd_audit():
    print_header("AUDITORIA DE AMBIENTE & FERRAMENTAS")
    checks = [
        ("Diretório do Jogo", os.path.exists(GAME_DIR)),
        ("Diretório Data/", os.path.exists(DATA_DIR)),
        ("SkyrimSE.exe", os.path.exists(os.path.join(GAME_DIR, "SkyrimSE.exe"))),
        ("skse64_loader.exe", os.path.exists(os.path.join(GAME_DIR, "skse64_loader.exe"))),
        ("skse64_1_6_318.dll", os.path.exists(os.path.join(GAME_DIR, "skse64_1_6_318.dll"))),
        ("Address Library AE 1.6.318", os.path.exists(os.path.join(DATA_DIR, "SKSE/Plugins/versionlib-1-6-318-0.bin"))),
        ("Prefixo Heroic", os.path.exists(PREFIX_DIR)),
        ("Comando 7z (p7zip)", shutil.which("7z") is not None),
        ("Comando gamescope", shutil.which("gamescope") is not None),
    ]
    all_ok = True
    for label, ok in checks:
        status = "🟢 OK" if ok else "🔴 FALTANDO"
        print(f"  [{status}] {label}")
        if not ok:
            all_ok = False
    return all_ok

def cmd_check_downloads():
    print_header("VALIDAÇÃO DOS ARQUIVOS DE MODS BAIXADOS")
    
    # Check manifest
    manifest_mods = []
    if os.path.exists(MANIFEST_FILE):
        with open(MANIFEST_FILE) as f:
            manifest_mods = json.load(f)
            
    # Check pending
    pending_mods = []
    if os.path.exists(PENDING_FILE):
        with open(PENDING_FILE) as f:
            pending_mods = json.load(f)

    down_files = os.listdir(DOWNLOADS_DIR) if os.path.exists(DOWNLOADS_DIR) else []
    inbox_files = os.listdir(INBOX_DIR) if os.path.exists(INBOX_DIR) else []

    print(f"  📁 Arquivos em Downloads_Mods/: {len(down_files)}")
    print(f"  📥 Arquivos no Inbox_Triagem/:  {len(inbox_files)}")
    
    # Check what is in inbox
    inbox_new_mods = []
    for f in inbox_files:
        for m in pending_mods:
            nid = str(m['nexus_id'])
            pat = rf'(-{nid}-| {nid} |-{nid}\.|\({nid}\))'
            if re.search(pat, f):
                inbox_new_mods.append((m, f))
                break
                
    if inbox_new_mods:
        print(f"\n  ✨ {len(inbox_new_mods)} Novos mods detectados no Inbox (prontos para mover/instalar):")
        for m, f in inbox_new_mods:
            print(f"     - [ID {m['nexus_id']}] {m['name']} -> {f}")
            
    print(f"\n  📊 Status do Roadmap:")
    print(f"     Mods no Manifesto Base: {len(manifest_mods)}")
    print(f"     Mods na Wishlist (60 Camadas): {len(pending_mods)}")
    print(f"     Recém-baixados no Inbox: {len(inbox_new_mods)}")
    print(f"     Faltam baixar da Wishlist: {len(pending_mods) - len(inbox_new_mods)}")

def cmd_move_inbox():
    print_header("TRANSFERINDO DOWNLOADS DO INBOX PARA DOWNLOADS_MODS")
    os.makedirs(DOWNLOADS_DIR, exist_ok=True)
    if not os.path.exists(INBOX_DIR):
        print("  Inbox não encontrado.")
        return

    pending_mods = []
    if os.path.exists(PENDING_FILE):
        with open(PENDING_FILE) as f:
            pending_mods = json.load(f)

    inbox_files = os.listdir(INBOX_DIR)
    moved = 0
    for f in inbox_files:
        for m in pending_mods:
            nid = str(m['nexus_id'])
            pat = rf'(-{nid}-| {nid} |-{nid}\.|\({nid}\))'
            if re.search(pat, f):
                src = os.path.join(INBOX_DIR, f)
                dst = os.path.join(DOWNLOADS_DIR, f)
                shutil.move(src, dst)
                print(f"  🚚 Movido: {f} -> Downloads_Mods/")
                moved += 1
                break
    print(f"\n  Total transferido: {moved} arquivos.")

def extract_archive(archive_path, target_dir):
    fname = os.path.basename(archive_path)
    
    # Check if FOMOD special handling is needed
    if "Essential Favorites" in fname:
        print(f"  📦 [FOMOD AE] Extraindo Essential Favorites (Versão AE 1.6.318)...")
        tmp_dir = "/tmp/extract_ef"
        shutil.rmtree(tmp_dir, ignore_errors=True)
        os.makedirs(tmp_dir, exist_ok=True)
        run_cmd(f'7z x "{archive_path}" -o"{tmp_dir}" -y')
        ae_skse = os.path.join(tmp_dir, "Essential Favorites FOMOD Installer/AE/SKSE")
        req_skse = os.path.join(tmp_dir, "Essential Favorites FOMOD Installer/Required/SKSE")
        if os.path.exists(ae_skse):
            dest_skse = os.path.join(target_dir, "SKSE")
            os.makedirs(dest_skse, exist_ok=True)
            run_cmd(f'cp -rf "{ae_skse}"/* "{dest_skse}/"')
        if os.path.exists(req_skse):
            dest_skse = os.path.join(target_dir, "SKSE")
            run_cmd(f'cp -rf "{req_skse}"/* "{dest_skse}/"')
        shutil.rmtree(tmp_dir, ignore_errors=True)
        return

    if "Barter Limit Fix" in fname:
        print(f"  📦 [FOMOD AE] Extraindo Barter Limit Fix (Versão AE 1.6.318)...")
        tmp_dir = "/tmp/extract_blf"
        shutil.rmtree(tmp_dir, ignore_errors=True)
        os.makedirs(tmp_dir, exist_ok=True)
        run_cmd(f'7z x "{archive_path}" -o"{tmp_dir}" -y')
        ae_skse = os.path.join(tmp_dir, "Barter Limit Fix FOMOD Installer/AE/SKSE")
        if os.path.exists(ae_skse):
            dest_skse = os.path.join(target_dir, "SKSE")
            os.makedirs(dest_skse, exist_ok=True)
            run_cmd(f'cp -rf "{ae_skse}"/* "{dest_skse}/"')
        shutil.rmtree(tmp_dir, ignore_errors=True)
        return

    if "Equip Enchantment Fix" in fname and "1.6.629" in fname:
        print(f"  ⚠️ [AVISO] Pulando {fname}: versão compilada para 1.6.629+ (Skyrim atual é 1.6.318.0).")
        return

    if "Lux Via" in fname and "main" in fname:
        print(f"  📦 [FOMOD CIRÚRGICO] Extraindo Lux Via...")
        tmp_dir = "/tmp/extract_lux_via"
        shutil.rmtree(tmp_dir, ignore_errors=True)
        os.makedirs(tmp_dir, exist_ok=True)
        run_cmd(f'7z x "{archive_path}" -o"{tmp_dir}" -y')
        for root, dirs, files in os.walk(tmp_dir):
            for file in files:
                if file.startswith("Lux - Resources") or file.startswith("Lux Via"):
                    src_f = os.path.join(root, file)
                    dst_f = os.path.join(target_dir, file)
                    shutil.copy2(src_f, dst_f)
        shutil.rmtree(tmp_dir, ignore_errors=True)
        return

    if "Lux (main)" in fname or "Lux - 43158" in fname:
        print(f"  🛡️ [QUARENTENA] Lux de Interiores mantido seguro fora de Data/ para evitar black screens.")
        return

    # Standard extraction
    print(f"  📦 Extraindo: {fname}...")
    run_cmd(f'7z x "{archive_path}" -o"{target_dir}" -y')

def cmd_install():
    print_header("INSTALAÇÃO E EXTRAÇÃO DOS MODS EM Data/")
    cmd_move_inbox()
    
    archives = []
    for ext in ["*.zip", "*.7z", "*.rar"]:
        archives.extend(glob.glob(os.path.join(DOWNLOADS_DIR, ext)))
        
    print(f"\n  Encontrados {len(archives)} arquivos compactados.")
    for arc in sorted(archives):
        extract_archive(arc, DATA_DIR)
        
    cmd_sanitize()
    cmd_sync_plugins()

def cmd_sanitize():
    print_header("SANITIZAÇÃO DE CASE-SENSITIVITY (Linux EXT4/Btrfs)")
    script_fix = os.path.join(SCRIPT_DIR, "fix_case_dupes.py")
    if os.path.exists(script_fix):
        res = subprocess.run([sys.executable, script_fix, DATA_DIR, "--apply"])
        print(f"  Sanitização concluída (código {res.returncode}).")
    else:
        print("  Aviso: fix_case_dupes.py não encontrado.")

def cmd_sync_plugins():
    print_header("SINCRONIZAÇÃO DE plugins.txt")
    plugins = []
    for f in os.listdir(DATA_DIR):
        f_lower = f.lower()
        if f_lower.endswith((".esm", ".esp", ".esl")):
            if f_lower in ["lux.esp", "lux - master plugin.esm", "lux - jk's skyrim.esp", "lux - 3dnpc patch.esp"]:
                continue
            plugins.append(f)

    esms = sorted([p for p in plugins if p.lower().endswith(".esm")])
    esls = sorted([p for p in plugins if p.lower().endswith(".esl")])
    esps = sorted([p for p in plugins if p.lower().endswith(".esp")])
    
    master_priority = [
        "skyrim.esm", "update.esm", "dawnguard.esm", "hearthfires.esm", "dragonborn.esm",
        "unofficial skyrim special edition patch.esp", "unofficial skyrim special edition patch.esm"
    ]
    sorted_esms = []
    for m in master_priority:
        for p in esms:
            if p.lower() == m and p not in sorted_esms:
                sorted_esms.append(p)
    for p in esms:
        if p not in sorted_esms:
            sorted_esms.append(p)

    # Special sorting for bottom-loading mods
    bottom_priority = [
        "realisticwatertwo.esp",
        "alternate start - live another life.esp",
        "betterquestobjectives-alternatestartpatch.esp"
    ]
    
    # Filter bottom plugins out of esps
    normal_esps = []
    bottom_esps = {k: None for k in bottom_priority}
    
    for p in esps:
        p_low = p.lower()
        matched_bottom = False
        for bp in bottom_priority:
            if p_low == bp:
                bottom_esps[bp] = p
                matched_bottom = True
                break
        if not matched_bottom:
            normal_esps.append(p)
            
    sorted_bottom = [bottom_esps[k] for k in bottom_priority if bottom_esps[k] is not None]
    final_order = sorted_esms + esls + normal_esps + sorted_bottom
    
    lines = ["# Load order gerado automaticamente pelo Skyrim Master Installer\n"]
    for p in final_order:
        lines.append(f"*{p}\n")
        
    target_locations = [
        os.path.join(STEAMUSER_DIR, "AppData/Local/Skyrim Special Edition/plugins.txt"),
        os.path.join(PUBLIC_DIR, "AppData/Local/Skyrim Special Edition/plugins.txt"),
    ]
    for loc in target_locations:
        os.makedirs(os.path.dirname(loc), exist_ok=True)
        with open(loc, "w") as f:
            f.writelines(lines)
        print(f"  ✅ plugins.txt atualizado ({len(final_order)} plugins): {loc}")

def cmd_configure():
    print_header("CONFIGURAÇÃO DE DXVK, ARQUIVOS INI E WINE")
    dosdevices_dir = os.path.join(PREFIX_DIR, "pfx/dosdevices")
    os.makedirs(dosdevices_dir, exist_ok=True)
    s_link = os.path.join(dosdevices_dir, "s:")
    w_link = os.path.join(dosdevices_dir, "w:")
    if not os.path.exists(s_link):
        os.symlink("/mnt/dados", s_link)
        print("  ✅ dosdevices s: -> /mnt/dados")
    if not os.path.exists(w_link):
        os.symlink("/mnt", w_link)
        print("  ✅ dosdevices w: -> /mnt")

    dxvk_conf = os.path.join(GAME_DIR, "dxvk.conf")
    with open(dxvk_conf, "w") as f:
        f.write("""dxvk.frameRate = 60
d3d11.presentInterval = 1
dxgi.syncInterval = 1
dxgi.nvapiHack = False
dxgi.maxFrameLatency = 2
d3d11.samplerAnisotropy = 16
dxvk.enableGraphicsPipelineLibrary = False
""")
    print("  ✅ dxvk.conf gravado (trava 60 FPS, sync)")

    ini_dir = os.path.join(STEAMUSER_DIR, "Documents/My Games/Skyrim Special Edition")
    os.makedirs(ini_dir, exist_ok=True)
    prefs_file = os.path.join(ini_dir, "SkyrimPrefs.ini")
    if os.path.exists(prefs_file):
        with open(prefs_file) as f:
            content = f.read()
        content = re.sub(r'bUse64bitsHDRRenderTarget\s*=\s*\d', 'bUse64bitsHDRRenderTarget=0', content)
        with open(prefs_file, "w") as f:
            f.write(content)
        print("  ✅ SkyrimPrefs.ini calibrado (bUse64bitsHDRRenderTarget=0 anti-black-screen)")

def main():
    if len(sys.argv) < 2:
        print("Uso: skyrim_master_installer.py [audit|check-downloads|move-inbox|install|sanitize|sync-plugins|configure|all]")
        sys.exit(1)

    cmd = sys.argv[1].lower()
    if cmd == "audit":
        cmd_audit()
    elif cmd == "check-downloads":
        cmd_check_downloads()
    elif cmd == "move-inbox":
        cmd_move_inbox()
    elif cmd == "install":
        cmd_install()
    elif cmd == "sanitize":
        cmd_sanitize()
    elif cmd == "sync-plugins":
        cmd_sync_plugins()
    elif cmd == "configure":
        cmd_configure()
    elif cmd == "all":
        cmd_audit()
        cmd_install()
        cmd_configure()
    else:
        print(f"Comando desconhecido: {cmd}")
        sys.exit(1)

if __name__ == "__main__":
    main()
