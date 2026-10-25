import sys
from pathlib import Path

target = Path("/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md")
target.write_text("", encoding="utf-8")

def append_section(text):
    with open(target, "a", encoding="utf-8") as f:
        f.write(text)

print("Initialized target file")
