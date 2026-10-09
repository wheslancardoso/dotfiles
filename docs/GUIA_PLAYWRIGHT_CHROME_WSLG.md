# 🌐 GUIA DEFINITIVO: CHROME / PLAYWRIGHT VISÍVEL NO WSL VIA WSLG

> **Documento de Infraestrutura & Automação Web**  
> *Finalidade: Explicar a arquitetura de execução do Chromium/Chrome gráfico no WSL2 (Windows Subsystem for Linux), solução de problemas de sandbox/display e guia de uso do comando `playwright-chrome`.*

---

## 🏛️ 1. O PROBLEMA HISTÓRICO: POR QUE O BROWSER TRAVA NO WSL?

Ao tentar rodar navegadores com interface gráfica (Playwright, Puppeteer, Selenium ou o próprio Chrome) dentro do ambiente Linux no WSL, os desenvolvedores enfrentam 4 armadilhas clássicas:

1. **Ausência ou Mapeamento Quebrado de Display:** Sem as variáveis do WSLg (`DISPLAY=:0` e `WAYLAND_DISPLAY=wayland-0`), o processo do Chrome tenta renderizar e encerra silenciosamente com erro de socket X11.
2. **Crash por Sandbox de Kernel:** O WSL2 utiliza um kernel virtualizado customizado onde certos namespaces de segurança de sandbox do Linux não são suportados nativamente, fazendo o Chrome abortar logo no boot.
3. **Esgotamento de `/dev/shm`:** A memória compartilhada padrão do WSL em `/dev/shm` pode ser insuficiente para renderização gráfica de abas modernas pesadas, resultando em quedas repentinas (*SIGBUS / target closed*).
4. **Detecção de Automação & Bloqueio do Google/Cloudflare:** O Google impede login direto quando o Chromium padrão roda com a flag `navigator.webdriver = true` ativa.

---

## ⚡ 2. A SOLUÇÃO DE ELITE IMPLEMENTADA

Para resolver isso de forma definitiva e permanente, foi criado o utilitário **`playwright-chrome`** (também disponível como **`chrome-wsl`**).

### As 5 Camadas de Resolução Automática:
* **WSLg Bridge Nativo:** Exporta automaticamente as variáveis de exibição (`DISPLAY=:0`, `WAYLAND_DISPLAY=wayland-0`, `XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir` e `PULSE_SERVER=/mnt/wslg/PulseServer`) para que a janela gráfica apareça como uma janela normal do Windows.
* **Flags Anti-Crash de WSL:** Injeta automaticamente `--no-sandbox` e `--disable-dev-shm-usage`.
* **Modo Stealth Anti-Detecção (Patchright):** Utiliza o motor `patchright` (versão endurecida do Playwright) com `--disable-blink-features=AutomationControlled`, permitindo logar livremente no Google, Cloudflare e NotebookLM sem tela de bloqueio.
* **Perfis Persistentes (`launchPersistentContext`):** Mantém logins, senhas salvas e cookies gravados no disco, para que você não precise refazer login a cada execução.
* **Sincronização de Estado (StorageState JSON):** Exporta cookies e `localStorage` automaticamente ao fechar o navegador, viabilizando o reuso da sessão em MCPs e scripts headless.

---

## 🚀 3. COMO USAR NO DIA A DIA

O comando está disponível globalmente no seu terminal zsh/bash:

### 1. Abrir Qualquer Site em Janela Visível
```bash
playwright-chrome https://google.com
# ou com o alias curto:
chrome-wsl https://google.com
```

### 2. Autenticar ou Reparar o MCP do NotebookLM (Modo Dedicado)
Quando o servidor MCP do NotebookLM perder a sessão ou você quiser adicionar fontes/interagir direto com os cadernos:
```bash
playwright-chrome --auth-notebooklm
```
* **O que acontece:** Abre diretamente a interface do NotebookLM no perfil do MCP (`~/.local/share/notebooklm-mcp/chrome_profile`). Ao fechar a janela, ele salva e atualiza o `browser_state/state.json` com mtime fresco, revalidando o MCP na hora!

### 3. Usar Perfis Isolados para Projetos Diferentes
```bash
# Perfil isolado para GitHub
playwright-chrome https://github.com --profile github

# Perfil isolado para estudos ou trabalho
playwright-chrome https://tecconcursos.com.br --profile concursos
```

### 4. Exportar Cookies/Sessão para Automações Headless
```bash
playwright-chrome https://site.com --export-state ~/meus_cookies.json
```
Ao fechar a janela, o arquivo `meus_cookies.json` é gravado com todos os cookies decodificados prontos para uso em scripts.

---

## 📁 4. ESTRUTURA DE ARQUIVOS NO SISTEMA

* **Script Master:** `~/dotfiles/scripts/playwright-chrome-wsl.sh`
* **Binário Chezmoi:** `~/dotfiles/home/dot_local/bin/executable_playwright-chrome`
* **Symlinks Ativos:**
  * `~/.local/bin/playwright-chrome`
  * `~/.local/bin/chrome-wsl`
* **Perfis de Navegação:** `~/.local/share/playwright-wsl/profiles/`
* **Documentação:** `~/dotfiles/docs/GUIA_PLAYWRIGHT_CHROME_WSLG.md`
