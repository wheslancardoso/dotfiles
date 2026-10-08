#!/usr/bin/env python3
"""
⚡ I+1 SENTENCE AUDIO GENERATOR (Apex English Engine)
Gera áudio nativo ultra-realista via edge-tts (Microsoft Azure Neural)
e salva diretamente na pasta de mídia do Anki ou localmente para playback.
"""

import sys
import os
import argparse
import subprocess
import hashlib
import re
from pathlib import Path

# Vozes nativas padrão de alta fidelidade
VOICES = {
    "us-male": "en-US-ChristopherNeural",   # Natural, tom de podcast/conversa
    "us-female": "en-US-JennyNeural",       # Clara, expressiva
    "us-guy": "en-US-GuyNeural",            # Dinâmica e natural
    "gb-male": "en-GB-RyanNeural",          # Britânico natural
    "gb-female": "en-GB-SoniaNeural",       # Britânica formal
}

DEFAULT_VOICE = "en-US-ChristopherNeural"

def get_anki_media_dir():
    base_dir = Path.home() / ".local/share/Anki2"
    if not base_dir.exists():
        return None
    for user_dir in base_dir.iterdir():
        if user_dir.is_dir():
            media_dir = user_dir / "collection.media"
            if media_dir.exists():
                return media_dir
    return None

def sanitize_text(text: str) -> str:
    cleaned = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    cleaned = re.sub(r'\s+', '_', cleaned.strip()).lower()
    return cleaned[:30]

def generate_audio(text: str, voice: str, output_path: Path):
    cmd = [
        "edge-tts",
        "--voice", voice,
        "--text", text,
        "--write-media", str(output_path)
    ]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"Erro ao gerar áudio: {result.stderr}")

def main():
    parser = argparse.ArgumentParser(description="Gera áudio nativo de sentenças i+1 para Anki")
    parser.add_argument("text", nargs="?", help="Texto ou frase em inglês a ser gerada")
    parser.add_argument("-v", "--voice", default="us-male", choices=list(VOICES.keys()) + list(VOICES.values()), help="Voz (us-male, us-female, gb-male, etc)")
    parser.add_argument("-p", "--play", action="store_true", help="Toca o áudio imediatamente após gerar")
    parser.add_argument("-o", "--output", help="Caminho customizado de saída (se não informado, salva na collection.media do Anki)")
    parser.add_argument("--rate", default="+0%", help="Ajuste de velocidade (ex: -10%, +0%, +10%)")

    args = parser.parse_args()

    if not args.text:
        if not sys.stdin.isatty():
            text = sys.stdin.read().strip()
        else:
            parser.print_help()
            sys.exit(1)
    else:
        text = args.text.strip()

    if not text:
        print("Erro: texto vazio fornecido.", file=sys.stderr)
        sys.exit(1)

    voice_id = VOICES.get(args.voice, args.voice)

    # Nome único baseado nas primeiras palavras e hash do texto
    text_slug = sanitize_text(text)
    text_hash = hashlib.md5(text.encode("utf-8")).hexdigest()[:6]
    filename = f"i1_{text_slug}_{text_hash}.mp3"

    if args.output:
        dest_path = Path(args.output).resolve()
        if dest_path.is_dir():
            dest_path = dest_path / filename
    else:
        anki_media = get_anki_media_dir()
        if anki_media:
            dest_path = anki_media / filename
        else:
            cache_dir = Path.home() / ".cache/apex/anki_media"
            cache_dir.mkdir(parents=True, exist_ok=True)
            dest_path = cache_dir / filename

    # Gerar áudio via edge-tts
    cmd = [
        "edge-tts",
        "--voice", voice_id,
        "--rate", args.rate,
        "--text", text,
        "--write-media", str(dest_path)
    ]
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res.returncode != 0:
        print(f"Erro ao sintetizar áudio: {res.stderr}", file=sys.stderr)
        sys.exit(1)

    sound_tag = f"[sound:{dest_path.name}]"

    print(f"✅ Áudio gerado: {dest_path}")
    print(f"🎴 Tag do Anki: {sound_tag}")

    if args.play:
        subprocess.run(["mpv", "--really-quiet", str(dest_path)], check=False)

if __name__ == "__main__":
    main()
