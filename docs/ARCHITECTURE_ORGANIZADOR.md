# 🏗️ Arquitetura Técnica — Organizador Master

Este documento detalha o design de software, responsabilidades dos módulos e como estender ou personalizar o **Organizador Master**.

---

## 🧩 Visão Geral dos Módulos

```text
organizador-master/
├── main.py                     # Entry point (CLI bootstrapper)
├── config/
│   └── regras.json             # Regras declarativas de roteamento (JSON)
├── src/
│   ├── cli.py                  # Parser de argumentos CLI e orquestrador
│   ├── core.py                 # FileOrganizerEngine (classificação & movimentação)
│   ├── taxonomy.py             # TaxonomyManager (garantia da árvore 00..06)
│   └── utils.py                # Logging formatado, normalização NFKD, anti-colisão
└── scripts/                    # Launchers (.bat e .ps1) para ambiente Windows
```

---

## ⚙️ Princípios de Design e SOLID

1. **Single Responsibility Principle (SRP)**:
   - `TaxonomyManager`: Apenas cuida de criar e validar pastas mestre e subpastas.
   - `FileOrganizerEngine`: Apenas avalia arquivos contra regras e executa a movimentação.
   - `cli.py`: Apenas recebe comandos do usuário e formata a saída.

2. **Open/Closed Principle (OCP)**:
   - Novas regras de classificação, novas extensões e novos tópicos são adicionados diretamente em `config/regras.json` **sem necessidade de alterar uma única linha de código Python**.

3. **Segurança e Idempotência**:
   - `get_unique_destination_path`: Se um arquivo já existir no destino com o mesmo nome, o script nunca sobrescreve silenciosamente — ele adiciona `_1`, `_2`, etc.
   - Atalhos do Windows (`.lnk`, `.url`) e arquivos de sistema (`desktop.ini`, `.git`, `.venv`) são protegidos na lista de ignorados.

---

## 🛠️ Como Adicionar Novas Regras em `config/regras.json`

Para fazer com que arquivos com determinado nome ou palavra-chave vão automaticamente para uma pasta específica:

```json
{
  "termos": ["palavra1", "palavra2", "termo-especifico"],
  "destino": "03_Profissional_WFIX/03.1_IA_Prompts_e_SOPs"
}
```

Para redirecionar uma nova extensão de arquivo:
```json
"regras_extensoes": {
  ".dockerfile": "04_Desenvolvimento_e_Codigo/04.3_Scripts_e_Automacoes",
  ".csv": "01_Pessoal_e_Vida/01.5_Financas_e_Contas"
}
```
