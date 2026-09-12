#!/usr/bin/env python3
"""
⚡ ANKI MUSIC MINER — Apex & MPV Music Immersion Engine
Fatia com precisão cirúrgica o áudio do verso atual da música e cria o card no Anki.
Suporta importação via AnkiConnect (tempo real) e persistência em deck TSV/TXT (offline).
"""

import sys
import os
import argparse
import subprocess
import re
import urllib.request
import json
from pathlib import Path

ANKI_CONNECT_URL = "http://127.0.0.1:8765"
DECK_NAME = "🇬🇧 English Immersion :: Music Lyrics & Shadowing"

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

def sanitize_filename(name: str) -> str:
    cleaned = re.sub(r'[\\/*?:"<>|]', "", name)
    cleaned = re.sub(r'\s+', "_", cleaned)
    return cleaned[:40]

def anki_connect_request(action: str, **params):
    try:
        payload = json.dumps({"action": action, "version": 6, "params": params}).encode("utf-8")
        req = urllib.request.Request(ANKI_CONNECT_URL, data=payload, headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=1.5) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            return data
    except Exception:
        return None

def notify_user(title: str, message: str, urgency: str = "normal"):
    try:
        subprocess.run(
            ["notify-send", title, message, "-i", "audio-volume-high", "-u", urgency, "-a", "Apex Music Study"],
            check=False
        )
    except Exception:
        pass

def main():
    parser = argparse.ArgumentParser(description="Mine music lyrics and slice audio for Anki")
    parser.add_argument("--file", required=True, help="Path to the audio file")
    parser.add_argument("--start", type=float, required=True, help="Start time in seconds")
    parser.add_argument("--end", type=float, required=True, help="End time in seconds")
    parser.add_argument("--text", required=True, help="Lyric verse / text")
    parser.add_argument("--title", default="", help="Song title")
    parser.add_argument("--artist", default="", help="Song artist")
    args = parser.parse_args()

    audio_file = Path(args.file).resolve()
    if not audio_file.exists():
        print(f"Error: audio file {audio_file} not found.", file=sys.stderr)
        sys.exit(1)

    verse_text = args.text.strip()
    if not verse_text:
        verse_text = "Lyrics snippet"

    song_title = args.title.strip()
    if not song_title:
        base_name = audio_file.stem
        song_title = base_name

    artist = args.artist.strip()
    if not artist and " - " in song_title:
        parts = song_title.split(" - ", 1)
        artist = parts[0].strip()
        song_title = parts[1].strip()

    # Padding de segurança para respiração e ataque de voz (200ms antes, 350ms depois)
    start_time = max(0.0, args.start - 0.20)
    duration = max(0.8, (args.end - start_time) + 0.35)

    media_dir = get_anki_media_dir()
    if not media_dir:
        media_dir = Path.home() / ".cache/apex/anki_media"
        media_dir.mkdir(parents=True, exist_ok=True)

    clean_title = sanitize_filename(song_title)
    timestamp_tag = f"{int(args.start * 1000)}"
    audio_clip_name = f"song_{clean_title}_{timestamp_tag}.mp3"
    dest_audio_path = media_dir / audio_clip_name

    # Cortar áudio com ffmpeg
    ffmpeg_cmd = [
        "ffmpeg", "-y",
        "-ss", f"{start_time:.3f}",
        "-t", f"{duration:.3f}",
        "-i", str(audio_file),
        "-vn",
        "-acodec", "libmp3lame",
        "-q:a", "2",
        str(dest_audio_path)
    ]

    res = subprocess.run(ffmpeg_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if res.returncode != 0 or not dest_audio_path.exists():
        print(f"Error cutting audio with ffmpeg", file=sys.stderr)
        notify_user("❌ Erro ao Minerador de Música", "Falha ao cortar áudio do verso.", "critical")
        sys.exit(1)

    sound_tag = f"[sound:{audio_clip_name}]"

    # Estrutura do Card (FRENTE e VERSO)
    card_front = f"<div style='font-size: 22px; font-weight: 600; text-align: center; color: #89b4fa; margin-bottom: 12px;'>🎵 {verse_text}</div><div style='text-align: center;'>{sound_tag}</div>"
    
    is_video = audio_file.suffix.lower() in [".mkv", ".mp4", ".avi", ".webm", ".mov", ".m4v"]
    media_label = "🎬 Obra / Filme" if is_video else "🎵 Faixa"
    tips_label = "Diálogo & Entonação do Personagem" if is_video else "Shadowing & Connected Speech"
    
    card_back = (
        f"<div style='text-align: center; margin-bottom: 10px; font-size: 14px; color: #a6adc8;'>"
        f"<b>{media_label}:</b> {song_title}" + (f" • <b>Artista:</b> {artist}" if artist else "") +
        f"</div>"
        f"<div style='background: rgba(137, 180, 250, 0.08); border-left: 4px solid #89b4fa; padding: 10px; border-radius: 6px; font-size: 15px; color: #cdd6f4; text-align: left;'>"
        f"<b>🎧 {tips_label}:</b><br/>"
        f"Preste atenção na velocidade real dos nativos, na modulação da voz e nas conexões de palavras."
        f"</div>"
    )

    card_added = False
    try:
        version_check = anki_connect_request("version")
        if version_check and "result" in version_check:
            anki_connect_request("createDeck", deck=DECK_NAME)
            
            note_payload = {
                "deckName": DECK_NAME,
                "modelName": "Basic",
                "fields": {
                    "Front": card_front,
                    "Back": card_back
                },
                "options": {
                    "allowDuplicate": False,
                    "duplicateScope": "deck"
                },
                "tags": ["english", "cinema" if is_video else "music", "shadowing", "apex"]
            }
            add_res = anki_connect_request("addNote", note=note_payload)
            if add_res and add_res.get("result"):
                card_added = True
    except Exception:
        pass

    tsv_line = f"{card_front}\t{card_back}\tenglish {'cinema' if is_video else 'music'} shadowing apex\n"
    
    deck_files = [
        Path("/mnt/dados/02_Estudos_e_Concursos/02.5_Ingles_e_Imersao/Anki_Decks/English_Immersion_Deck.tsv"),
        Path.home() / "dotfiles/docs/anki/Music_Anki_Deck.tsv",
        Path.home() / "timeless_life/09 - Maestria em Inglês de Elite & Imersão Global/Music_Anki_Deck.tsv"
    ]

    for d_file in deck_files:
        if d_file.parent.exists():
            try:
                with open(d_file, "a", encoding="utf-8") as f:
                    f.write(tsv_line)
            except Exception:
                pass


    status_str = "Card injetado no Anki!" if card_added else "Áudio salvo e card preparado para Anki!"
    notify_user(
        f"🎵 [Anki] {status_str}",
        f"Verso: \"{verse_text}\"\nFaixa: {song_title}",
        "normal"
    )
    print(f"SUCCESS: {audio_clip_name} mined successfully.")

if __name__ == "__main__":
    main()
