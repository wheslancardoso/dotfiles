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
    subprocess.run(["systemctl", "--user", "stop", "skyrim-gamescope.service"], stderr=subprocess.DEVNULL)
    subprocess.run(["systemctl", "--user", "reset-failed", "skyrim-gamescope.service"], stderr=subprocess.DEVNULL)
    for proc in ["SkyrimSE", "skse64", "wineserver", "notepad.exe", "gamescope"]:
        subprocess.run(["pkill", "-9", "-f", proc], stderr=subprocess.DEVNULL)
    time.sleep(1)

def launch_and_monitor(use_gamescope=True):
    print(f"[4/5] Disparando Skyrim AE via Proton nativo {'(com Gamescope & Force-Grab-Cursor)' if use_gamescope else ''}...")
    env = os.environ.copy()
    env["STEAM_COMPAT_CLIENT_INSTALL_PATH"] = "/home/lan/.local/share/Steam"
    env["STEAM_COMPAT_DATA_PATH"] = PREFIX_DIR
    env["PROTON_ENABLE_NVAPI"] = "1"
    env["PROTON_HIDE_NVIDIA_GPU"] = "0"
    env["WINEDLLOVERRIDES"] = "dxgi=n,b;d3d11=n,b;steam_api64=n,b"
    env["XCURSOR_THEME"] = "Bibata-Modern-Ice"
    env["XCURSOR_SIZE"] = "24"
    
    already_in_gamescope = "GAMESCOPE_WAYLAND_DISPLAY" in os.environ or "GAMESCOPE_EXTERNAL_OVERLAY" in os.environ
    if use_gamescope and not already_in_gamescope and shutil.which("gamescope"):
        runner_sh = os.path.join(GAME_DIR, "run_gamescope.sh")
        cmd = [
            "gamescope",
            "-W", "1920",
            "-H", "1080",
            "-w", "1920",
            "-h", "1080",
            "-r", "100",
            "-f",
            "--force-grab-cursor",
            "--",
            runner_sh
        ]
    else:
        cmd = [
            PROTON_BIN,
            "run",
            os.path.join(GAME_DIR, "skse64_loader.exe")
        ]
    
    subprocess.run(["systemctl", "--user", "stop", "skyrim-gamescope.service"], stderr=subprocess.DEVNULL)
    subprocess.run(["systemctl", "--user", "reset-failed", "skyrim-gamescope.service"], stderr=subprocess.DEVNULL)
    run_cmd = [
        "systemd-run",
        "--user",
        "--unit=skyrim-gamescope",
        f"--working-directory={GAME_DIR}",
        f"--setenv=STEAM_COMPAT_CLIENT_INSTALL_PATH=/home/lan/.local/share/Steam",
        f"--setenv=STEAM_COMPAT_DATA_PATH={PREFIX_DIR}",
        "--setenv=PROTON_ENABLE_NVAPI=1",
        "--setenv=PROTON_HIDE_NVIDIA_GPU=0",
        "--setenv=WINEDLLOVERRIDES=dxgi=n,b;d3d11=n,b;steam_api64=n,b",
        "--setenv=PROTON_USE_XALIA=0",
        "--setenv=XCURSOR_THEME=Bibata-Modern-Ice",
        "--setenv=XCURSOR_SIZE=24",
    ] + cmd
    
    res = subprocess.run(run_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print(f"      Serviço Gamescope registrado: {res.stdout.strip()}")
    
    print("[5/5] Monitorando inicialização do motor...")
    for i in range(35):
        time.sleep(1)
        # Checar se SkyrimSE.exe subiu
        res = subprocess.run(["pgrep", "-f", "SkyrimSE.exe"], stdout=subprocess.PIPE)
        if res.returncode == 0:
            pid = res.stdout.decode().strip().split()[0]
            print(f"\n[SUCESSO] SkyrimSE.exe está ativo e rodando! (PID: {pid})")
            
            # Garantir foco no Workspace 8 e na janela do Gamescope
            subprocess.run(["hyprctl", "dispatch", "workspace", "8"], stderr=subprocess.DEVNULL)
            for _ in range(10):
                time.sleep(1)
                chk = subprocess.run(["hyprctl", "clients"], stdout=subprocess.PIPE, text=True)
                if "gamescope" in chk.stdout:
                    subprocess.run(["hyprctl", "dispatch", "focuswindow", "class:gamescope"], stderr=subprocess.DEVNULL)
                    break
            
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
    use_gamescope = "--no-gamescope" not in sys.argv
    audit_environment()
    audit_winedevices()
    clean_stale_processes()
    ok = launch_and_monitor(use_gamescope=use_gamescope)
    sys.exit(0 if ok else 1)
