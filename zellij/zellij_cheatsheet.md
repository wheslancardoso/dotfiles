# ⌨️ Guia Definitivo: Zellij (Vim-Style)

Este é o seu manual rápido para dominar o terminal.

## 🧭 Navegação (Modo Normal)
*   **Alt + h/j/k/l**: Mover o foco entre janelas (estilo Vim).
*   **Alt + [ / ]**: Alternar entre layouts de tela.
*   **Alt + /**: Abrir este guia de ajuda.

## 🚀 Sessões (O Coração da Persistência)
*   **No Terminal:**
    *   `zellij -s [nome]`: Inicia uma nova sessão com nome.
    *   `zellij ls`: Lista todas as sessões ativas.
    *   `zellij attach [nome]`: Volta para uma sessão.
    *   `zellij delete-session [nome]`: Encerra uma sessão específica.
*   **Dentro do Zellij:**
    *   **Ctrl + o** -> **d**: **Detach** (Sai e deixa tudo rodando em background).
    *   **Ctrl + o** -> **w**: Gerenciador de sessões visual.

## 🪟 Panes (Divisões de Tela)
*   **Ctrl + p** seguido de:
    *   **n**: Novo pane.
    *   **d**: Novo pane abaixo.
    *   **r**: Novo pane na direita.
    *   **x**: Fechar pane atual.
    *   **f**: Alternar tela cheia.
    *   **w**: Alternar modo flutuante (Janelas sobrepostas).
    *   **e**: Transformar pane flutuante em fixo (e vice-versa).

## 📑 Tabs (Abas)
*   **Ctrl + t** seguido de:
    *   **n**: Nova aba.
    *   **x**: Fechar aba.
    *   **r**: Renomear aba.
    *   **s**: Sincronizar abas (O que você digita em uma, sai em todas).

## 🔍 Scroll e Busca
*   **Ctrl + s** seguido de:
    *   **s**: Iniciar busca por texto.
    *   **j/k**: Scroll linha a linha.
    *   **Ctrl + f/b**: Page Up / Page Down.

## 🛠️ Extras
*   **Ctrl + g**: Modo **LOCKED** (Bloqueia todos os atalhos para evitar acidentes).
*   **Ctrl + q**: Sair do Zellij (Encerra a sessão e todos os processos).

---
*Dica: Use **Ctrl + h** para o modo MOVE e reposicionar suas janelas livremente.*
