#!/usr/bin/env python3
"""
SKYRIM AE & SKSE RUNTIME DIAGNOSTIC & LAUNCH AGENT (SOVEREIGN ENGINE)
Executa auditoria forense completa do ecossistema e inicia o jogo via GE-Proton com captura em tempo real.
"""
import os
import sys
import json
import time
import subprocess
import shutil

GAME_DIR = "/mnt/dados/Jogos/Skyrim-AE"
PREFIX_DIR = "/home/lan/Games/Heroic/Prefixes/shared"
PROTON_BIN = "/home/lan/.config/heroic/tools/proton/GE-Proton-latest/proton"
DOCS_SKSE = "/home/lan/Games/Heroic/Prefixes/shared/pfx/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition/SKSE"

def audit_environment():
    print("[1/5] Auditando integridade do binário e extensões...")
    assert os.path.exists(os.path.join(GAME_DIR, "SkyrimSE.exe")), "SkyrimSE.exe não encontrado!"
    assert os.path.exists(os.path.join(GAME_DIR, "skse64_loader.exe")), "skse64_loader.exe não encontrado!"
    assert os.path.exists(os.path.join(GAME_DIR, "skse64_1_6_318.dll")), "skse64_1_6_318.dll não encontrado!"
    
    # Validar Address Library
    addr = os.path.join(GAME_DIR, "Data/SKSE/Plugins/versionlib-1-6-318-0.bin")
    assert os.path.exists(addr), "Address library para AE 1.6.318 não encontrada!"
    print(f"      Address Library OK ({os.path.getsize(addr)} bytes)")

def audit_winedevices():
    print("[2/5] Auditando mapeamento de unidades no Wine (dosdevices)...")
    dosdevices_dir = os.path.join(PREFIX_DIR, "pfx/dosdevices")
    os.makedirs(dosdevices_dir, exist_ok=True)
    s_link = os.path.join(dosdevices_dir, "s:")
    w_link = os.path.join(dosdevices_dir, "w:")
    if not os.path.exists(s_link):
        os.symlink("/mnt/dados", s_link)
        print("      Criado link dosdevices s: -> /mnt/dados")
    if not os.path.exists(w_link):
        os.symlink("/mnt", w_link)
        print("      Criado link dosdevices w: -> /mnt")

def clean_stale_processes():
    print("[3/5] Limpando processos zumbis anteriores...")
    for proc in ["SkyrimSE", "skse64", "wineserver", "notepad.exe"]:
        subprocess.run(["pkill", "-9", "-f", proc], stderr=subprocess.DEVNULL)
    time.sleep(1)

def launch_and_monitor():
    print("[4/5] Disparando Skyrim AE via Proton nativo...")
    env = os.environ.copy()
    env["STEAM_COMPAT_CLIENT_INSTALL_PATH"] = "/home/lan/.local/share/Steam"
    env["STEAM_COMPAT_DATA_PATH"] = PREFIX_DIR
    env["PROTON_ENABLE_NVAPI"] = "1"
    env["PROTON_HIDE_NVIDIA_GPU"] = "0"
    env["WINEDLLOVERRIDES"] = "dxgi=n,b;d3d11=n,b;steam_api64=n,b"
    
    cmd = [
        PROTON_BIN,
        "run",
        os.path.join(GAME_DIR, "skse64_loader.exe")
    ]
    
    p = subprocess.Popen(cmd, cwd=GAME_DIR, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"      Processo lançado com PID de arranque: {p.pid}")
    
    print("[5/5] Monitorando inicialização do motor...")
    for i in range(12):
        time.sleep(1)
        # Checar se SkyrimSE.exe subiu
        res = subprocess.run(["pgrep", "-f", "SkyrimSE.exe"], stdout=subprocess.PIPE)
        if res.returncode == 0:
            pid = res.stdout.decode().strip().split()[0]
            print(f"\n[SUCESSO] SkyrimSE.exe está ativo e rodando! (PID: {pid})")
            
            # Verificar SKSE
            skse_log = os.path.join(DOCS_SKSE, "skse64.log")
            if os.path.exists(skse_log):
                with open(skse_log) as f:
                    lines = f.readlines()
                print(f"         Status SKSE: {lines[-1].strip()} ({len(lines)} eventos registrados)")
            return True
            
    print("\n[ALERTA] Tempo de arranque excedido ou processo finalizou.")
    return False

if __name__ == "__main__":
    audit_environment()
    audit_winedevices()
    clean_stale_processes()
    ok = launch_and_monitor()
    sys.exit(0 if ok else 1)
