import subprocess
import time
import os

game_dir = "/mnt/dados/Games/GTA_San_Andreas"
wine_pfx = "/mnt/dados/Games/pfx_gtasa"
env = os.environ.copy()
env["WINEPREFIX"] = wine_pfx
env["WINEDLLOVERRIDES"] = "vorbisFile,vorbisHooked=n,b;d3d9=n,b"
env["WINEDEBUG"] = "-all"

print("Iniciando gta_sa.exe via Wine...")
proc = subprocess.Popen(["wine", os.path.join(game_dir, "gta_sa.exe")], cwd=game_dir, env=env)

time.sleep(3)
print(f"PID: {proc.pid}, poll: {proc.poll()}")

# Esperar 4s e matar
proc.terminate()
try:
    proc.wait(timeout=2)
except:
    proc.kill()

print("Teste concluido com sucesso!")
