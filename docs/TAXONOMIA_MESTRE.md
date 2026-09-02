# 🏛️ Taxonomia Mestre Numerada (`00_` a `06_`)

Esta taxonomia utiliza o princípio de **ordenação ordinal por prefixo numérico de dois dígitos**. Isso garante que o Windows Explorer, macOS Finder, terminais e o Google Drive exibam suas pastas exatamente na ordem de prioridade mental e operacional.

---

## 🌳 Árvore Completa de Diretórios

```text
📁 Documents/ (ou Google Drive Raiz)
│
├── 📁 00_Inbox_Triagem/
│   └── Destino padrão de arquivos avulsos recebidos ou pendentes de classificação
│
├── 📁 01_Pessoal_e_Vida/
│   ├── 📁 01.1_Identidade_e_Documentos/    # RG, CPF, Certidões, Comprovantes de Residência, Diplomas
│   ├── 📁 01.2_Carreira_e_Curriculos/      # Currículos (.pdf, .tex, .html), Cartas, Portfólio
│   ├── 📁 01.3_Frequencia_e_Viagens/       # Fichas de ponto, SFR, relatórios de deslocamento
│   ├── 📁 01.4_clareza/                    # Master Vault de princípios, visão e reflexões
│   └── 📁 01.5_Financas_e_Contas/          # Imposto de Renda, extratos importantes, notas fiscais
│
├── 📁 02_Estudos_e_Concursos/
│   ├── 📁 02.1_TCE-GO/                     # Editais TCE-GO, Questões, Cronogramas, Operação Posse
│   ├── 📁 02.2_Senador_Canedo/             # Editais e cronogramas Câmara de Senador Canedo
│   ├── 📁 02.3_Cursos_e_Certificacoes/     # Slides de cursos TI (m2..m6), Arquitetura (TOGAF, DAMA, EDA)
│   └── 📁 02.4_Biblioteca_e_Ebooks/        # Livros digitais (.epub, .pdf) de desenvolvimento pessoal e TI
│
├── 📁 03_Profissional_WFIX/
│   ├── 📁 03.1_IA_Prompts_e_SOPs/          # Prompts de IA, Playbooks de Atendimento, Engenharia de Prompt
│   ├── 📁 03.2_Automacoes_n8n/             # Fluxos de automação n8n, JSONs, webhooks, intenções
│   ├── 📁 03.3_Historico_e_Casos/          # Casos de atendimento resolvidos, pesquisas de preço/mercado
│   ├── 📁 03.4_Clientes_e_Whats/           # Backups e transcrições de conversas com clientes
│   └── 📁 03.5_Aulas_e_Treinamentos/       # Gravações de aulas de negociação (.ts, .mp3, áudios)
│
├── 📁 04_Desenvolvimento_e_Codigo/
│   ├── 📁 04.1_Projetos_Web_e_Apps/        # Projetos de desenvolvimento (wtechapp, dynamic-water, finance-ia)
│   ├── 📁 04.2_Extensoes_e_Plugins/        # Extensões de navegador e plugins
│   └── 📁 04.3_Scripts_e_Automacoes/       # Scripts utilitários, automações PowerShell, Python
│
├── 📁 05_Design_Midia_e_Criacao/
│   ├── 📁 05.1_Artes_e_Cartazes/           # Cartazes, convites de aniversário, artes institucionais
│   ├── 📁 05.2_Audios_e_Vozes/             # Músicas, áudios curtos, samples, gravações
│   └── 📁 05.3_Letras_e_Composicoes/       # Rascunhos de letras de música e poemas
│
└── 📁 06_Backups_ISOs_e_Sistemas/
    ├── 📁 06.1_Imagens_e_Snapshots/        # Imagens Macrium Reflect (.mrimgx), backups de códigos
    ├── 📁 06.2_Maquinas_Virtuais_WSL/      # Distribuições WSL (Arch Linux ext4.vhdx), VMs VirtualBox
    └── 📁 06.3_Instaladores_e_ISOs/        # ISOs de instalação (Windows 11), executáveis e SDKs
```

---

## 🧭 Onde Colocar Cada Tipo de Arquivo?

- **Novo comprovante de pagamento / endereço**: `01_Pessoal_e_Vida/01.1_Identidade_e_Documentos`
- **Novo PDF de concurso / simulado**: `02_Estudos_e_Concursos/02.1_TCE-GO` ou `02.2_Senador_Canedo`
- **Novo prompt / ajuste no bot de IA**: `03_Profissional_WFIX/03.1_IA_Prompts_e_SOPs`
- **Novo projeto de programação**: `04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps`
- **Nova arte no Canva / Photoshop**: `05_Design_Midia_e_Criacao/05.1_Artes_e_Cartazes`
- **Novo instalador baixado**: `06_Backups_ISOs_e_Sistemas/06.3_Instaladores_e_ISOs` (ou deixe o script mover para lá automaticamente!)
