# 📦 Kit de Integração do Cockpit Sensei & Dojo Piloto em Comando

Esta pasta contém os arquivos prontos para você utilizar com agentes de IA em qualquer projeto.

---

## 📂 Arquivos Disponíveis

1. **`PROTOCOLO_DOJO_PILOTO_EM_COMANDO.md`**
   * **O que é:** O protocolo mestre e unificado completo.
   * **Contém:** Todas as 9 regras (Método Socrático, Camuflagem de Código sem pegadas de IA, Defesa em Daily/PR, Dry-run, Arquitetura baseada em livros, e o Módulo Sensei do Cockpit).
   * **Onde usar:** Ideal para ser o arquivo principal `.agents/AGENTS.md` de repositórios próprios ou projetos de estudo.

2. **`09_COCKPIT_SENSEI_LAZYVIM.md`**
   * **O que é:** A regra modular especializada apenas nas ferramentas e no LazyVim.
   * **Contém:** Os 8 pilares do cockpit (LazyVim Alien, Dadbod DB, Kulala REST, LazyGit, Diffview, DAP Debugger, Zellij e Yazi), a Dica de Voo e as regras mnemônicas de ensino.
   * **Onde usar:** Ideal para ser colocado dentro da pasta `.agents/rules/` de projetos corporativos ou compartilhados (ex: `.agents/rules/cockpit_sensei.md`).

---

## 🛠️ Como usar em novos projetos

### Opção A: Regra Modular (Recomendado para repositórios compartilhados)
Se o projeto já possui um `AGENTS.md` ou se você quer apenas adicionar o Sensei do Cockpit sem interferir nas regras da equipe:
```bash
# Dentro da raiz do projeto:
mkdir -p .agents/rules
cp ~/documents/cockpit-sensei/09_COCKPIT_SENSEI_LAZYVIM.md .agents/rules/cockpit_sensei.md
```

### Opção B: Protocolo Completo (Recomendado para projetos próprios ou estudos)
Se você quer a experiência completa do Dojo Piloto em Comando (método socrático, desafios, defesa de PR):
```bash
# Dentro da raiz do projeto:
mkdir -p .agents
cp ~/documents/cockpit-sensei/PROTOCOLO_DOJO_PILOTO_EM_COMANDO.md .agents/AGENTS.md
```

### 🔒 Dica para Repositórios de Trabalho (Git Exclude)
Para usar o protocolo localmente sem sujar o `.gitignore` oficial do time:
```bash
echo ".agents/" >> .git/info/exclude
```
Dessa forma, o Git ignora a pasta `.agents/` apenas na sua máquina e nunca sobe para o repositório da empresa.

---

## 🌐 Lembrete: Você já tem a Global Skill Ativa!
Lembre-se que no seu computador nós já instalamos a **Global Skill** em `~/.gemini/config/skills/lazyvim-sensei/SKILL.md`.
Isso significa que **mesmo sem copiar nenhum arquivo para o projeto**, basta abrir o chat em qualquer pasta e dizer:
> **`"Estou no LazyVim"`**

E a IA ativará o Sensei automaticamente via Progressive Disclosure com zero desperdício de tokens!
