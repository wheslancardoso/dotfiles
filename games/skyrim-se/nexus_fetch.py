#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import sys
from pathlib import Path

CREDENTIALS_FILE = Path.home() / ".config" / "nexusmods" / "credentials.json"
GAME_DOMAIN = "skyrimspecialedition"

def get_api_key():
    if not CREDENTIALS_FILE.exists():
        print(f"Erro: Arquivo {CREDENTIALS_FILE} não encontrado.")
        sys.exit(1)
    with open(CREDENTIALS_FILE, "r") as f:
        data = json.load(f)
    return data.get("api_key")

def query_mod(mod_id: int):
    api_key = get_api_key()
    url = f"https://api.nexusmods.com/v1/games/{GAME_DOMAIN}/mods/{mod_id}.json"
    req = urllib.request.Request(url, headers={"apikey": api_key, "User-Agent": "SkyrimAutomator/1.0"})
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            print(f"[{mod_id}] {data.get('name')} (v{data.get('version')})")
            print(f"      Status: {data.get('status')} | Endossos: {data.get('endorsement_count')}")
            print(f"      Resumo: {data.get('summary')}\n")
    except urllib.error.HTTPError as e:
        print(f"Erro ao consultar mod {mod_id}: HTTP {e.code} - {e.reason}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 nexus_fetch.py <MOD_ID_1> [MOD_ID_2 ...]")
        sys.exit(1)
    for m_id in sys.argv[1:]:
        query_mod(int(m_id))
