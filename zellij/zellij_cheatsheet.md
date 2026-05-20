# 🌌 Guia Mestre: Zellij (Vim-Style)

Este guia contém TODOS os atalhos e comandos para dominar seu terminal.

---

## 🧭 Navegação Básica (Modo Normal)
*   **Alt + h/j/k/l**: Mover o foco entre janelas (estilo Vim).
*   **Alt + [ / ]**: Alternar entre layouts de tela.
*   **Alt + /**: Abrir este guia de ajuda (Popup).

## 🚀 Gerenciamento de Sessões
*   **No Terminal:**
    *   `zellij -s [nome]`: Inicia uma nova sessão nomeada.
    *   `zellij ls`: Lista todas as sessões ativas.
    *   `zellij attach [nome]`: Volta para uma sessão.
    *   `zellij delete-session [nome]`: Encerra uma sessão específica.
*   **Dentro do Zellij (Modo Session: `Ctrl + o`):**
    *   **d**: **Detach** (Sai e mantém a sessão rodando em background).
    *   **w**: Gerenciador de sessões visual.
    *   **x**: Deletar sessão atual.

## 🪟 Panes (Divisões de Tela)
*   **Ctrl + p** (Modo Pane) seguido de:
    *   **n**: Novo pane.
    *   **d**: Novo pane abaixo (Down).
    *   **r**: Novo pane na direita (Right).
    *   **x**: Fechar pane atual.
    *   **f**: Alternar tela cheia (Fullscreen).
    *   **w**: Alternar modo flutuante (Estilo janelas do Hyprland).
    *   **e**: Transformar pane flutuante em fixo (e vice-versa).
    *   **z**: Esconder/Mostrar bordas (Toggle Frames).

## 📑 Tabs (Abas Internas)
*   **Ctrl + t** (Modo Tab) seguido de:
    *   **n**: Nova aba.
    *   **x**: Fechar aba.
    *   **r**: Renomear aba.
    *   **s**: Sincronizar abas (Escreva em todas ao mesmo tempo).
    *   **h/j/k/l**: Navegar entre abas.

## 🔍 Scroll e Busca
*   **Ctrl + s** (Modo Scroll) seguido de:
    *   **s**: Iniciar busca por texto.
    *   **j/k**: Scroll linha a linha.
    *   **u/d**: Half-page scroll (Up/Down).
    *   **Ctrl + f/b**: Page Up / Page Down.

## 📏 Redimensionamento
*   **Alt + =**: Aumenta o tamanho do pane selecionado.
*   **Alt + -**: Diminui o tamanho do pane selecionado.

## 🛠️ Modos de Operação
*   **Ctrl + g**: Modo **LOCKED** (Trava todos os atalhos - use para digitar sem interferência).
*   **Ctrl + h**: Modo **MOVE** (Use h/j/k/l para arrastar as janelas de lugar).
*   **Ctrl + q**: Sair do Zellij (Encerra tudo definitivamente).

---
*Dica: O Zellij salva seu estado automaticamente. Use o Detach (`Ctrl + o` -> `d`) para nunca perder seu progresso.*
