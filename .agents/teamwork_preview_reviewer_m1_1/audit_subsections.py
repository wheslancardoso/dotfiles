import re

doc_path = "/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md"
with open(doc_path, "r", encoding="utf-8") as f:
    content = f.read()

# Match subsections like ### 1.1 ..., ### 2.1 ...
subsections = re.findall(r"(###\s+([1-4]\.[1-4])\s+[^\n]+)(.*?)(?=(?:###\s+[1-4]\.[1-4]|##\s+[0-9]|###\s+Caso|$))", content, re.DOTALL)

print(f"Total subsections found: {len(subsections)}")

for header, num, body in subsections:
    p1 = "#### Parte 1:" in body
    p2 = "#### Parte 2:" in body
    p3 = "#### Parte 3:" in body
    p4 = "#### Parte 4:" in body
    
    # Check analogy in P1
    analogy = bool(re.search(r"(analogia|imagine|pense em|como se|met[aá]fora)", body[:body.find("#### Parte 2:") if p2 else len(body)], re.I))
    
    # Check pain / algaworks in P2
    p2_body = body[body.find("#### Parte 2:"):body.find("#### Parte 3:")] if (p2 and p3) else ""
    algaworks = bool(re.search(r"(AlgaWorks|WDR|MJS|aula|legado|produ[cç][aã]o)", p2_body, re.I))
    
    # Check modern code in P3
    p3_body = body[body.find("#### Parte 3:"):body.find("#### Parte 4:")] if (p3 and p4) else ""
    code_block = "```" in p3_body
    
    # Check AGR / Teatro in P4
    p4_body = body[body.find("#### Parte 4:"):] if p4 else ""
    agr_teatro = bool(re.search(r"(AGR|portalservice|cadu|cadastrounico|fiscalizacao|agrfiscalservice|receita|teatro-abc|8080|8081|8082|8083|8090|8092)", p4_body, re.I))
    
    status = "OK" if (p1 and p2 and p3 and p4 and analogy and algaworks and code_block and agr_teatro) else "FLAG"
    print(f"[{status}] {num}: P1={p1} (Analogy={analogy}) | P2={p2} (Hist/AlgaWorks={algaworks}) | P3={p3} (Code={code_block}) | P4={p4} (AGR/Teatro={agr_teatro})")
    if status == "FLAG":
        print(f"   Details: {header}")
