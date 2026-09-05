# 🏗️ Arquitetura Técnica — Organizador Master

Este documento detalha o design de software, responsabilidades dos módulos e como estender ou personalizar a suíte do **Organizador Master**.

---

## 🧩 Visão Geral dos Módulos

```text
organizador-master/
├── main.py                     # Ponto de entrada CLI e orquestrador
├── config/
│   ├── regras.json             # Regras declarativas de roteamento (JSON)
│   └── glazewm/                # Configurações do tiling window manager
├── src/
│   ├── cli.py                  # Parser argparse e orquestração de subcomandos
│   ├── core.py                 # FileOrganizerEngine (classificação & movimentação)
│   ├── dedup.py                # HashDeduplicator (hash SHA-256 e quarentena)
│   ├── doctor.py               # SystemDoctor (auditoria, diagnóstico e score 0..100)
│   ├── watcher.py              # DirectoryWatcher (daemon de monitoramento em tempo real)
│   ├── history.py              # HistoryManager (transações e rollback com --undo)
│   ├── taxonomy.py             # TaxonomyManager (garantia da árvore 00..06)
│   ├── renamer.py              # AutoNamer (padronização de datas ISO e sanitização)
│   ├── partition_calc.py       # PartitionCalculator (calculadora de partições SO/Dados)
│   └── utils.py                # Cores ANSI, normalização NFKD, anti-colisão
├── tests/
│   └── test_organizer.py       # Suíte completa de testes automatizados (unittest)
└── scripts/                    # Scripts de automação para Linux e Windows
    ├── vincular_linux.sh       # Symlinks automáticos para partição de dados no Linux
    ├── Vincular-Windows.ps1    # Junções NTFS automáticas no Windows (D:\)
    └── ...                     # Launchers rápidos .bat e .sh
```

---

## ⚙️ Princípios de Design e Arquitetura

1. **Single Responsibility Principle (SRP)**:
   - `TaxonomyManager`: Apenas gerencia e valida a integridade das pastas mestre e subpastas ordinais.
   - `FileOrganizerEngine`: Avalia regras de classificação, inspeciona conteúdos e executa a movimentação segura.
   - `SystemDoctor`: Realiza checagens de integridade estática, gerando diagnósticos e notas de 0 a 100 (Padrão Ouro).
   - `HashDeduplicator`: Calcula hashes SHA-256 byte-a-byte para detectar arquivos gêmeos exatos e isolá-los em quarentena.
   - `DirectoryWatcher`: Monitora diretórios de entrada em segundo plano sem bloquear a máquina.
   - `HistoryManager`: Registra cada movimentação em log transacional atômico para permitir rollback com zero perda de dados.

2. **Open/Closed Principle (OCP)**:
   - Novas regras de classificação, novas extensões e novos tópicos são adicionados diretamente em `config/regras.json` **sem necessidade de alterar uma única linha de código Python**.

3. **Segurança e Idempotência**:
   - `get_unique_destination_path`: Se um arquivo já existir no destino com o mesmo nome, o script nunca sobrescreve silenciosamente — ele adiciona sufixos sequenciais (`_1`, `_2`, etc.).
   - Arquivos de sistema (`desktop.ini`, `.git`, `.venv`, atalhos de janelas) são estritamente protegidos.
   - Inspeção não-destrutiva de metadados de texto (`.docx`, `.txt`, `.md`) para desambiguação de arquivos com nomes genéricos.

---

## 🛠️ Como Adicionar Novas Regras em `config/regras.json`

Para fazer com que arquivos com determinado nome ou palavra-chave vão automaticamente para uma pasta específica:

```json
{
  "termos": ["palavra1", "palavra2", "termo-especifico"],
  "destino": "02_Profissional_e_Carreira/02.1_Projetos_e_Clientes"
}
```

Para redirecionar uma nova extensão de arquivo:
```json
"regras_extensoes": {
  ".dockerfile": "04_Desenvolvimento_e_Codigo/04.3_Scripts_e_Automacoes",
  ".csv": "01_Pessoal_e_Vida/01.5_Financas_e_Contas"
}
```
