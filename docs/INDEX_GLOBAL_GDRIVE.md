# 🗺️ ÍNDICE MESTRE GLOBAL DO GOOGLE DRIVE (5 TB)
## *Mapa de Navegação Semântica, Taxonomia & Árvore Completa para Agentes de IA*

> **Ponto de Montagem Local:** `/home/lan/gdrive` (link: `/mnt/dados/00_GoogleDrive`)  
> **Remote Rclone:** `gdrive:`  
> **Capacidade:** 5.0 TB (Rclone VFS Streaming com cache local de 50 GB)  
> **Última Atualização:** 17 de Outubro de 2026  
> **Finalidade:** Servir como guia definitivo e mapa estruturado para agentes de IA (Google Antigravity, Gemini, Claude, OpenAI) e humanos localizarem instantaneamente qualquer documento, código, mídia ou contexto de negócio sem buscas cegas ou varreduras lentas na rede.

---

## ⚡ 1. MATRIZ DE ROTEAMENTO RÁPIDO PARA IAs (ONDE PROCURAR O QUÊ)

Quando o usuário fizer uma solicitação, consulte esta tabela para saber exatamente em qual pasta ler primeiro:

| Tema / Intenção da Consulta | Onde Procurar no Drive | Formato dos Arquivos | Descrição do Conteúdo |
|---|---|---|---|
| **Concurso TCE-GO 2026** (Megadocs para Leitura Rápida) | `NotebookLM_Context/Concurso_TCE_GO/` | `.md` | Megadocs consolidados (Mestre Único, por caderno e 49 fontes individuais) |
| **Concurso TCE-GO 2026** (Vídeos, Podcasts, Aulas) | `02_Estudos_e_Concursos/02.1_TCE-GO/` | `.mp4`, `.mp3`, `.md` | Maratona de vídeo-aulas, podcasts longos e shorts didáticos |
| **Concurso TCE-GO 2026** (Editais, Erros, Reta Final) | `Taxonomia_Backup/02_Estudos_e_Concursos/02.1_TCE-GO/` | `.xlsx`, `.md`, `.pdf` | Edital verticalizado, caderno de erros, plano de reta final |
| **Finanças, Caixinhas & APEX** | `Taxonomia_Backup/01_Pessoal_e_Vida/01.3_Contas_e_Financas/` | `.xlsx`, `.pdf` | Planilhas APEX, orçamentos familiares, faturas consolidadas |
| **Finanças & Mindset (Megadoc IA)** | `NotebookLM_Context/Notebook_02_Postura_Social_e_Financas.md` | `.md` | Compilação conceitual de finanças, alforria e postura |
| **Identidade, Princípios & Vida** | `NotebookLM_Context/Notebook_00..03.md` | `.md` | Manifestos de propósito, casamento, cápsula do tempo da esposa |
| **Sabedoria & Modelos Mentais** | `NotebookLM_Context/Notebook_08..11.md` | `.md` | Megadocs de sabedoria prática (Bárbara, Desfigurado, Matheus Ferreira, Ricardo Thomé) |
| **Acervos Brutos de Sabedoria** | `05_Design_Midia_e_Criacao/Videos/` | `.tar.gz`, `.txt` | Transcrições completas compactadas (Ricardo Thomé 827 obras, etc.) |
| **WFIX & Atendimento a Clientes** | `03_Profissional_WFIX/03.4_Clientes_e_Whats/` | `.docx`, `.txt`, pastas OS | Transcrições de WhatsApp, ordens de serviço (`OS-2026WF-*`) |
| **WFIX & Dojo de Comunicação** | `03_Profissional_WFIX/03.4_Acervo_Conversas_Organizado_MD/` | `.md`, `.db` | Megadocs de oratória, carisma, playbooks e banco SQLite |
| **WFIX & Gestão/SOPs/n8n** | `Taxonomia_Backup/03_Profissional_WFIX/` | `.md`, `.json`, `.pdf` | SOPs N3, fluxos n8n, contratos sociais CNPJ, tabelas de preço |
| **Projetos de Software & Apps** | `Taxonomia_Backup/04_Desenvolvimento_e_Codigo/` | `.tar.gz`, `.sh`, `.py` | Backups de código (Fiscalização AGR, APEX, WTech) e automações |
| **Projetos de Software (Nuvem Raiz)** | `04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/` | Pastas de projeto | DynamicWaterReminder, Finance_IA, Mixtape252, WTECH_App |
| **Windows Pós-Formatação & Drivers** | `06_Backups_ISOs_e_Sistemas/06.1_Kit_Pos_Formatacao_Windows/` | `.exe`, `.msi`, `.ps1` | Kit completo em 9 categorias (ativadores, drivers offline, tweaks) |
| **Guia Windows 11 & Skyrim Modlist** | `GUIA_WINDOWS_E_SKYRIM.md` (e `.html`) | `.md`, `.html` | Guia completo de instalação, pós-formatação, drivers e Skyrim |
| **Backups & Snapshots de Sistema** | `06_Backups_ISOs_e_Sistemas/06.2_Backups_e_Snapshots/` | `.zip`, `.sql` | Backups pré-formatação, dumps SQL de Fiscalização AGR |
| **Mídias, Slides & Apresentações** | `05_Design_Midia_e_Criacao/05.1_Artes_e_Wallpapers/` | `.pptx`, `.png` | Slides de arquitetura de computadores, SAP1, controle de acesso |

---

## 🏗️ 2. A ARQUITETURA EM DUAS CAMADAS (TAXONOMIA vs NUVEM RAIZ)

Para não cometer erros de interpretação, a IA deve compreender as duas camadas presentes no Drive:

```text
Google Drive 5 TB (gdrive:)
│
├── 📂 Taxonomia_Backup/  ────────► [CAMADA 1: ESPELHO DO NVMe LOCAL]
│                                   Sincronizado automaticamente via 'gdrive-sync.sh'.
│                                   Espelha /mnt/dados/01..04 (Documentos, Código, Concurso).
│                                   Filtra lixo (.git, node_modules, .venv, *.iso).
│
├── 📂 01..06 (Pastas na Raiz) ───► [CAMADA 2: ACERVO DIRETO EM NUVEM & ARQUIVOS PESADOS]
│                                   Arquivos multimídia, vídeos 4K, cursos completos,
│                                   kits de instalação do Windows, dumps de banco e APKs.
│
├── 📂 NotebookLM_Context/ ───────► [CAMADA 3: DESTILADO DE ALTA DENSIDADE PARA LLMs]
│                                   Megadocs temáticos compilados prontos para absorção
│                                   pelo NotebookLM e Gemini (timeless_life + TCE-GO).
│
└── 📄 Arquivos Avulsos na Raiz ──► Guias mestres rápidos de consulta (ex: GUIA_WINDOWS_E_SKYRIM.md)
```

---

## 🔄 3. ESTEIRAS DE SINCRONIZAÇÃO ATIVAS

| Esteira / Script | Origem Local (NVMe) | Destino no Google Drive | Frequência / Como Roda |
|---|---|---|---|
| `gdrive-sync.sh` | `/mnt/dados/01..04` | `gdrive:Taxonomia_Backup/01..04` | Sob demanda ou cron (`gdrive-sync --sync`) |
| `notebooklm-sync.py` | `~/timeless_life` | `gdrive:NotebookLM_Context/Notebook_*.md` | Executado após atualizações no timeless_life |
| `sincronizar_notebooklm.py` | `~/concurso` | `gdrive:NotebookLM_Context/Concurso_TCE_GO/` | Executado após fechamento de cadernos e aulas |
| `rclone-gdrive.service` | `gdrive:` (Nuvem) | `/home/lan/gdrive` (Ponto VFS) | Serviço systemd montado no boot do Arch Linux |

---

## 🌳 4. ÁRVORE ESTRUTURAL COMPLETA DETALHADA

### `📁 01_Pessoal_e_Vida/` (Acervo Direto Raiz)
* `📁 01.1_Identidade_e_Documentos/`: Documentos civis legados.
* `📁 01.2_Carreira_e_Curriculos/`: Histórico profissional.
* `📁 01.3_Frequencia_e_Viagens/`: Registros de ponto e viagens passadas.
* `📁 01.4_Clareza_e_Desenvolvimento_Pessoal/`: Registros pessoais legados.
* `📁 01.5_Financas_e_Contas/`: Arquivos financeiros históricos.
* `📄 aegis-backup-20260910-183136.json`: Backup das chaves 2FA do Aegis Authenticator.
* `📄 personal_photos.rar`: Arquivo compactado de fotos pessoais.
* `📄 vault_legado.7z`: Cofre histórico compactado.

### `📁 02_Estudos_e_Concursos/` (Acervo de Mídia e Cursos)
* `📁 02.1_TCE-GO/`:
  * `📁 00_MARATONA_AULAS_EM_VIDEO/`: Aulas em vídeo por caderno (Português, RLM, Constitucional, Eng. Software, Dev Web, Bancos de Dados).
  * `📁 Caderno 06 - Bancos de Dados & SQL/Videoaulas/`: Aulas em vídeo de SQL e modelagem.
  * `📁 Caderno 07 - Infra, Linux & Redes-Cloud/Videoaulas/`: Aulas em vídeo de redes e Linux.
  * `📁 Caderno 09 - Governanca & Gestao de TI/`:
    * `📁 Audios (Podcast Longo)/`: Podcasts gerados pelo NotebookLM para estudo passivo.
    * `📁 Videoaulas/`: Aulas teóricas completas.
    * `📁 Videos Curtos (Shorts ~1 min)/`: Pílulas rápidas de revisão.
    * `📁 Videos Longos (Explicativo ~8 min)/`: Explicações detalhadas de tópicos complexos.
  * `📁 Caderno 10 - Ciencia de Dados, BI & IA/Videoaulas/`: Aulas em vídeo de engenharia de dados.
  * `📁 NotebookLM_Audios_e_Videos/`: Pílulas e deep dives com `PROTOCOLO_INGESTAO_IA.md` e `README.md`.
* `📁 02.3_Cursos_e_Certificacoes/`: Acervo de certificações (ADS TCC, Senai, Redes, Linux Essentials).
* `📁 02.4_Biblioteca_e_Ebooks/`: Ebooks e documentos de pesquisa (Historicidade, Quase Morte, livros de TI).
* `📁 Acervo_Study_Wennyo/`: Banco de mais de 44 mil questões e materiais complementares (+12k e +32k questões).

### `📁 03_Profissional_WFIX/` (Operação Comercial & Atendimento)
* `📁 03.1_IA_Prompts_e_SOPs/`: Prompts de atendimento e procedimentos padrão.
* `📁 03.2_Automacoes_e_n8n/`: Fluxos e rotinas de automação.
* `📁 03.3_WFIX_Empresa/`: Documentos corporativos da WFIX.
* `📁 03.4_Acervo_Conversas_Organizado_MD/`:
  * `📁 01_Clientes_GetNinjas/` a `📁 09_Dossies_de_Oratoria_e_Carisma/`: Categorização completa de clientes e contatos.
  * `📄 Megadoc_01_Dojo_Comunicacao_Carisma_e_WFIX.md`: Síntese de oratória e comunicação persuasiva (2.1 MB).
  * `📄 Megadoc_02_Relacoes_Pessoais_e_Amigos.md`: Síntese de relações interpessoais (800 KB).
  * `📄 acervo_comunicacao.db`: Banco de dados SQLite indexando todas as conversas e lições.
* `📁 03.4_Clientes_e_Whats/`: Transcrições de WhatsApp e ordens de serviço (`OS-2026WF-009`, `OS-2026WF-0010`, `OS-2026WF-0011`).
* `📁 03.5_Aulas_e_Treinamentos/`: Vídeos do método VDI 2.0 (precificação de serviços técnicos, valor de visita e salário).
* `📁 AGR_Fiscalizacao/`:
  * `📄 Relatório de Auto de Infração por Motoristas.xls`: Dados reais de infrações para engenharia de dados.
  * `📁 Salvo_do_Chrome/`: Páginas salvas do sistema de fiscalização governamental.

### `📁 04_Desenvolvimento_e_Codigo/` (Projetos em Nuvem)
* `📁 04.1_Projetos_Web_e_Apps/`:
  * `📁 DynamicWaterReminder/`: Código do app Android de lembrete de água.
  * `📁 Finance_IA/`: Protótipo do assistente financeiro inteligente.
  * `📁 Mixtape252/`: Projeto de mixtape / áudio web.
  * `📁 WTECH_App/`: Aplicação web corporativa.

### `📁 05_Design_Midia_e_Criacao/` (Assets, Slides & Acervos)
* `📁 05.1_Artes_e_Wallpapers/`:
  * Apresentações PowerPoint técnicas: Arquitetura de Processadores Modernos, Controle de Acesso SAP-1, circuitos eletrônicos.
  * `📁 Projetos_Arquitetura/` e `📁 Wallpapers/`.
* `📁 05.2_Audios_e_Midias/`: Músicas instrumentais, feeds RSS de Hip-Hop underground.
* `📁 05.3_Letras_e_Composicoes/`: Rascunhos autorais.
* `📁 05.4_Filmes_e_Series/`: Acervo de produções audiovisuais.
* `📁 Videos/`:
  * `📄 Acervo_Completo_Transcrições_Sabedoria_2026.tar.gz`: Todas as transcrições de vídeos de sabedoria.
  * `📄 Acervo_Ricardo_Thome_Projeto_Conselho_827_Obras.tar.gz`: 827 transcrições de obras do Projeto Conselho.
* `📄 youtube_comments_*.csv`: Comentários raspados de vídeos do YouTube sobre Skyrim.

### `📁 06_Backups_ISOs_e_Sistemas/` (Instaladores, Snapshots & Games)
* `📁 06.1_Instaladores_e_APKs/`: APKs assinados (`DynamicWaterReminder` v1.0 a v2.5, `Minhas Finanças`, `btrfs.zip`).
* `📁 06.1_Kit_Pos_Formatacao_Windows/`: Kit estruturado pós-instalação do Windows 11:
  * `01_Ativadores_e_Debloat/`: Scripts de ativação e remoção de bloatware.
  * `02_Runtimes_e_Bibliotecas/`: Visual C++ Redistributable All-in-One, DirectX, .NET Frameworks.
  * `03_Drivers_e_Rede_Offline/`: Drivers de rede e chipset offline.
  * `04_Navegadores_e_Comunicacao/`: Instaladores offline de browsers e apps de chat.
  * `05_Office_PDF_e_Produtividade/`: Pacote office e leitores PDF.
  * `06_Programas_Crackeados_Design_e_CAD/`: Softwares de engenharia/design.
  * `07_Diagnostico_Manutencao_e_Resets/`: CrystalDiskInfo, HWMonitor, MemTest, DDU.
  * `08_Scripts_Registro_e_Tweaks/`: Modificações de registro para telemetria zero e alta performance.
  * `09_Abrir_Com_Associacao_Rapida/`: Arquivos `.reg` para menu de contexto rápido.
* `📁 06.2_Backups_e_Snapshots/`:
  * `📄 dump-fiscalizacao-202609161602.sql`: Dump SQL do banco PostgreSQL de fiscalização AGR (32 MB).
  * `📄 BACKUP_PRE_WINDOWS_*.zip`: Snapshot dos documentos antes da última formatação.
  * `📄 makingofformaturas_*.zip`: Backup de arquivos digitais de formatura (749 MB).
* `📁 06.3_ISOs_e_Boot/`: Imagens ISO de sistemas operacionais.
* `📁 06.4_Games_e_Emuladores/`: Saves de jogos, modlists de Skyrim, emuladores e ROMs.
* `📁 06.5_APKs_e_Pacotes_Mobile/`: Pacotes de aplicativos móveis.

### `📁 NotebookLM_Context/` (Megadocs Estruturados para Absorção por IA)
* `📄 Notebook_00_Identidade_Principios_e_Manifestos.md` (435 KB): Memória viva, checklists e propósito.
* `📄 Notebook_01_Familia_Relacionamento_e_Filhos.md` (507 KB): Protocolos de casamento, criação e alinhamento de ouro.
* `📄 Notebook_02_Postura_Social_e_Financas.md` (704 KB): Oratória, finanças, blindagem mental e disciplina.
* `📄 Notebook_03_Capsula_do_Tempo_Esposa.md` (22 KB): Memórias, cartas e registros de afeto perpétuo.
* `📄 Notebook_04_Biblioteca_Tecnica_e_Engenharia.md` (9 KB): Resumos de livros clássicos de arquitetura de software.
* `📄 Notebook_05_Repertorio_Cultural_e_Ingles.md` (912 KB): Cinema, literatura clássica e imersão em inglês.
* `📄 Notebook_06_Prompts_IA_e_Carreira_Wtechapp.md` (339 KB): Prompts operacionais, agentes e carreira tech.
* `📄 Notebook_07_TCE_GO_Contexto_Estrategico_Guerra.md` (230 KB): Edital esquematizado e estratégia de 120 dias.
* `📄 Notebook_08_Sabedoria_Barbara_Timeless_Wisdom.md` (936 KB): Transcrições e ensinamentos da Bárbara.
* `📄 Notebook_09_Sabedoria_Desfigurado_Homem_Rocha.md` (406 KB): Masculinidade sóbria e postura do homem rocha.
* `📄 Notebook_10_Sabedoria_Matheus_Ferreira_Homem_Classico.md` (380 KB): Conduta clássica, elegância e caráter.
* `📄 Notebook_11_Sabedoria_Ricardo_Thome_Projeto_Conselho.md` (1.7 MB): Acervo condensado do Projeto Conselho.
* `📁 Concurso_TCE_GO/`:
  * `📄 README.md`: Guia de arquitetura dos Megadocs do Concurso.
  * `📁 00_MEGADOC_MESTRE_UNICO/`: 1 arquivo único contendo TODO o conteúdo teórico e prático do concurso.
  * `📁 01_MEGADOCS_POR_CADERNO/`: Megadocs completos separados por disciplina (Cadernos 00 a 11).
  * `📁 02_MEGADOCS_MODULARES/`: Separação cirúrgica entre Aulas Teóricas vs Cadernos de Erros.
  * `📁 03_FONTES_MD_INDIVIDUAIS/`: 49 arquivos Markdown avulsos, cada um contendo uma aula masterclass completa (de Firewalls e Redes até CRISP-DM, Machine Learning, Zachman e COBIT).

### `📁 Taxonomia_Backup/` (Espelho Contínuo do NVMe `/mnt/dados/`)
* `📁 01_Pessoal_e_Vida/`:
  * `📁 01.1_Identidade_e_Documentos/`: PDFs oficiais (CNH, RG, Título de Eleitor, Certidão, Comprovante).
  * `📁 01.2_Carreira_e_Curriculos/`: Currículos atualizados (Tech Lead / Auditor TI) e portfólio.
  * `📁 01.3_Contas_e_Financas/`: Planilhas do APEX Finance, faturas consolidadas e extratos.
  * `📁 01.3_Frequencia_e_Viagens/`: Histórico de passagens e férias.
  * `📁 01.4_Clareza_e_Desenvolvimento_Pessoal/`: Diário estóico, matriz de decisão e rotina matinal.
  * `📁 01.5_Financas_e_Contas/`: Declarações de IRPF e recibos.
  * `📁 Backups/`: Backups encriptados do Bitwarden e Aegis 2FA.
  * `📁 cockpit-sensei/`: Regras, atalhos e snapshots de configuração do ambiente de desenvolvimento.
  * `📁 My Games/`: Modlists e configs do Skyrim.
* `📁 02_Estudos_e_Concursos/`:
  * `📁 02.1_TCE-GO/`: Edital verticalizado em planilha, cronogramas de revisão espaçada e caderno consolidado de erros FCC.
  * `📁 02.2_Senador_Canedo/`: Edital e provas anteriores de TI da Câmara de Senador Canedo.
  * `📁 02.3_Cursos_e_Certificacoes/`: Certificados AWS Solutions Architect, CKA Kubernetes e Spring Boot Expert.
  * `📁 02.4_Biblioteca_e_Ebooks/`: Ebooks clássicos (Designing Data-Intensive Applications, Clean Architecture, Enterprise Integration Patterns, Database Internals, Computer Networking Kurose).
  * `📁 02.5_Ingles_e_Imersao/`: Decks Anki de inglês técnico e guias de shadowing.
* `📁 03_Profissional_WFIX/`:
  * `📁 03.1_IA_Prompts_e_SOPs/`: SOPs de suporte N3 e engenharia reversa do sistema de Fiscalização AGR.
  * `📁 03.2_Automacoes_e_n8n/`: Workflows exportados do n8n em formato JSON.
  * `📁 03.3_WFIX_Empresa/`: Contrato social, cartão CNPJ e certidões negativas de débito federal.
  * `📁 03.4_Clientes_e_Whats/`: CRM de clientes e histórico de atendimentos VIP.
  * `📁 03.5_Aulas_e_Treinamentos/`: Apostilas de redes e suporte de hardware.
* `📁 04_Desenvolvimento_e_Codigo/`:
  * `📁 04.1_Projetos_Web_e_Apps/`: Pacotes compactados dos projetos web (Fiscalização Backend/Frontend, APEX Mobile, WTech).
  * `📁 04.2_Extensoes_e_Plugins/`: Extensões de navegador e pacotes de plugins LazyVim/Obsidian.
  * `📁 04.3_Scripts_e_Automacoes/`: Scripts utilitários de backup, automação Anki e gestão de janelas Hyprland.

### 📄 Arquivos Avulsos na Raiz do Drive
* `📄 GUIA_WINDOWS_E_SKYRIM.md` / `📄 GUIA_WINDOWS_E_SKYRIM.html`: Guia pós-instalação completo do Windows 11 com debloat, associação rápida e setup da Skyrim Modlist.
* `📄 Cópia de Calculadora de Precificação de Serviços V3 - Vida de Tecnico.xlsx`: Planilha mestre de precificação de suporte e serviços de TI.

---

## 🤖 5. PROTOCOLO OPERACIONAL PARA AGENTES DE IA

Ao receber qualquer tarefa que envolva arquivos neste Drive:

1. **Priorize Megadocs e Markdowns:** Para tarefas conceituais, de síntese ou de contexto, leia primeiro os arquivos de `NotebookLM_Context/` ou `Taxonomia_Backup/`. Eles concentram todo o conhecimento destilado sem tráfego de rede desnecessário.
2. **Não Dispare Downloads Pesados:** Arquivos dentro de `05_Design_Midia_e_Criacao/Videos/` e `06_Backups_ISOs_e_Sistemas/` contêm gigabytes de dados binários. Nunca faça leitura completa de buffers (`cat`, `view_file` irrestrito) nesses diretórios sem filtro de cabeçalho ou metadados.
3. **Respeite o Cache Local VFS:** O cache local de leitura fica em `/home/lan/.cache/rclone/vfs/gdrive/`. Ele possui teto de 50 GB. Ao inspecionar arquivos, utilize comandos como `ls`, `find -maxdepth`, `grep` focado ou os próprios scripts de sincronização.
4. **Distinção entre Espelho e Nuvem:**
   - Para editar ou consultar a versão de trabalho mais recente de documentos e códigos: consulte sempre `/mnt/dados/` (local) ou `Taxonomia_Backup/` (nuvem).
   - Para recuperar instaladores, kits offline ou mídias pesadas: consulte as pastas de topo (`05_` e `06_`).
