import re

doc_path = "/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md"
with open(doc_path, "r", encoding="utf-8") as f:
    content = f.read()

subsections = re.findall(r"(###\s+([1-4]\.[1-4])\s+[^\n]+)(.*?)(?=(?:###\s+[1-4]\.[1-4]|##\s+[0-9]|###\s+Caso|$))", content, re.DOTALL)

for header, num, body in subsections:
    p2_start = body.find("#### Parte 2:")
    p3_start = body.find("#### Parte 3:")
    if p2_start != -1 and p3_start != -1:
        p2_text = body[p2_start:p3_start].strip()
        has_aw = "AlgaWorks" in p2_text or "WDR" in p2_text or "MJS" in p2_text
        print(f"=== {num} (AlgaWorks tag in P2: {has_aw}) ===")
        print(p2_text[:250] + "...\n")
