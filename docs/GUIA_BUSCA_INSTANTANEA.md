# ⚡ Guia Definitivo de Busca Instantânea (Windows e Linux)

> **Como localizar qualquer arquivo, documento ou código em menos de 1 segundo utilizando indexação ultraveloz e a Taxonomia Mestre.**

---

## 🧠 A Tríade da Produtividade Máxima

1. **Taxonomia Mestre (`00_` a `06_`)**: Cada pasta tem um papel claro e ordenação ordinal garantida.
2. **Nomenclatura Padrão ISO (`YYYY-MM-DD_Categoria_Descricao_v1`)**: Nomes semânticos com datas cronológicas.
3. **Indexador em Tempo Real**: Ferramenta que pesquisa instantaneamente à medida que você digita.

---

## 🪟 No Windows: Setup "God Mode"

### 1. O Motor: Everything (da Voidtools)
O **Everything** lê diretamente a tabela USN Journal / MFT do sistema de arquivos NTFS. Ele não consome memória em segundo plano e localiza 1 milhão de arquivos instantaneamente.

- **Download**: [https://www.voidtools.com/](https://www.voidtools.com/) (ou instale via `winget install voidtools.Everything`).
- **Atalho Recomendado**: Configure o atalho global `Win + F` ou `Alt + Espaço` para abrir a busca.

#### 🎯 Como Buscar com Eficiência Máxima no Everything:
| O que você quer achar | O que digitar no Everything |
|---|---|
| Apenas PDFs de Concursos | `02_Estudos .pdf` |
| Qualquer documento do TCE-GO | `tce-go` |
| Arquivos modificados hoje | `dm:today` |
| Arquivos modificados neste mês | `dm:thismonth` |
| Scripts Python e automações | `04_Desenvolvimento .py` |
| Imagens ou comprovantes de 2026 | `2026 01_Pessoal .pdf` |
| Buscar dentro do conteúdo do arquivo | `content:"palavra chave" .docx` |

### 2. A Barra de Atalho Estilo Spotlight: Flow Launcher (Opcional)
Para ter uma barra flutuante central (estilo Raycast do macOS):
- **Download**: [https://www.flowlauncher.com/](https://www.flowlauncher.com/) (ou `winget install Flow-Launcher.Flow-Launcher`).
- O Flow Launcher vem integrado com o plugin do *Everything*. Pressione `Alt + Espaço`, digite o que precisa e pressione Enter.

---

## 🐧 No Linux: Setup de Alta Performance

### 1. Interface Gráfica: FSearch
O **FSearch** é o equivalente do *Everything* no ecossistema Linux, desenvolvido em C puro e GTK+.

- **Instalação no Ubuntu / Debian**:
  ```bash
  sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-daily
  sudo apt update && sudo apt install fsearch
  ```
- **Instalação no Arch Linux**:
  ```bash
  sudo pacman -S fsearch
  # ou via AUR
  yay -S fsearch-git
  ```

### 2. Terminal e Linha de Comando: `fd` + `fzf` + `ripgrep`
Para desenvolvedores e usuários de terminal, essa combinação é a mais rápida que existe:

- **Instalação**:
  ```bash
  # Ubuntu / Debian
  sudo apt install fzf ripgrep fd-find
  
  # Arch Linux
  sudo pacman -S fzf ripgrep fd
  ```

- **Busca Fuzzy Instantânea de Arquivos**:
  ```bash
  # Abrir busca interativa com pré-visualização:
  fzf --preview 'cat {}'
  ```

- **Buscar Conteúdo Dentro de Qualquer Arquivo**:
  ```bash
  # Procura o termo 'tce-go' dentro de todos os arquivos instantaneamente:
  rg "tce-go" ~/Documents
  ```

---

## 🚀 Dicas de Ouro para a Área de Trabalho (Desktop 100% Limpa)

1. **Nunca use a Área de Trabalho como depósito permanente**:
   - Deixe apenas atalhos essenciais de aplicativos (`.lnk` no Windows ou `.desktop` no Linux).
2. **Deixe o Organizador Master trabalhar por você**:
   - Crie o hábito de executar o atalho `scripts/Executar-Organizacao.bat` (ou `scripts/organizar.sh`) ao final do dia ou da semana.
   - Qualquer arquivo solto no Desktop será roteado para a pasta certa ou enviado para `00_Inbox_Triagem`.
3. **Tranquilidade com o `--undo`**:
   - Se rodou e quer reverter, basta executar `scripts/Desfazer-Ultima-Organizacao.bat` ou `python main.py --undo`.
