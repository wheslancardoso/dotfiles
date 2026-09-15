# 🏛️ GUIA MESTRE — APEX FINANCE (COCKPIT SOBERANO DE GESTÃO & SSOT)

> ***"Quem é fiel no pouco, sobre o muito será colocado."*** *(Lucas 16:10 / Mateus 25:21)*  
> *"Quem gasta o que não tem para impressionar quem não conhece vira escravo do sistema. O Homem Rocha constrói em silêncio, blinda o caixa e compra sua alforria."*

O **APEX FINANCE** é a suíte financeira definitiva integrada nativamente ao ambiente Linux (Hyprland / Terminal / Zsh / Zellij). Substitui planilhas desarticuladas e aplicações web infladas (como o antigo `~/finance-ia`) por uma arquitetura local de altíssimo desempenho baseada em **SQLite**, **Python 3.12**, **Textual TUI brutalista (Catppuccin Mocha)** e **Plotext**.

---

## 🧭 Sumário Executivo

1. [Arquitetura & Single Source of Truth (SSOT)](#1-arquitetura--single-source-of-truth-ssot)
2. [Atalhos Rápidos & Como Executar](#2-atalhos-rápidos--como-executar)
3. [Navegação e Estrutura das Abas](#3-navegação-e-estrutura-das-abas)
4. [CRUD Completo de Entidades](#4-crud-completo-de-entidades)
5. [Mecanismo de Faturas de Cartão (Sem Bugs)](#5-mecanismo-de-faturas-de-cartão-sem-bugs)
6. [Time Machine & Snapshots Mensais Imutáveis](#6-time-machine--snapshots-mensais-imutáveis)
7. [Rotinas de Backup Atômico & Restauração](#7-rotinas-de-backup-atômico--restauração)
8. [Integração com o Dotfiles e Setup](#8-integração-com-o-dotfiles-e-setup)

---

## 1. Arquitetura & Single Source of Truth (SSOT)

Ao contrário de arquiteturas web complexas com Next.js, ORMs pesados e sincronização assíncrona que geravam faturas reabertas, lançamentos duplicados e descompasso de saldo, o APEX FINANCE adota princípios soberanos:

- **Motor Local**: Banco de dados SQLite persistido em `~/.local/share/apex-finance/data/finance.db`.
- **Integridade Transacional Estrita**: Chaves estrangeiras com `PRAGMA foreign_keys = ON` e restrições `UNIQUE(cartao_id, mes_referencia)` para faturas.
- **Idempotência**: Uma fatura liquidada não pode ser paga duas vezes por engano. Qualquer tentativa repetida é bloqueada no motor central (`core_engine.py`).
- **Simetria Contábil**: Exclusões e edições de transações recalculam o saldo bancário ou limites do cartão instantaneamente e de forma atômica.
- **Exportação Universal**: Exporta em menos de 1 segundo para Excel (.xlsx) com 3 abas executivas prontas para impressão ou auditoria externa.

---

## 2. Atalhos Rápidos & Como Executar

No terminal, você pode iniciar o cockpit com qualquer um dos aliases:
```bash
fin
# ou
financas
# ou
apex-finance
```

### ⌨️ Mapa de Teclas Globais

| Tecla | Ação | Descrição |
|---|---|---|
| `1` | Aba Dashboard | Visão geral do mês, saldos em conta e gráfico preditivo de 10 meses |
| `2` | Aba Transações | Tabela de movimentações com filtro por mês ou visão geral |
| `3` | Aba Simulador | Sandbox da Máquina do Tempo (compras parceladas vs impacto no caixa) |
| `4` | Aba Caixinhas | Metas sagradas (Alforria 115% CDI, CG 160 e Presença) |
| `5` | Aba Cartões | Gestão e tabela completa de limites, corte, vencimento e faturas |
| `6` | Aba Recorrências | Orçamento base fixo e provisões essenciais |
| `h` / `l` | Voltar / Avançar Mês | Navega pela Time Machine alterando a referência do sistema |
| `n` | Nova Transação | Cadastra despesa ou receita (conta ou cartão) |
| `Enter` | Editar Registro | Abre modal de edição da linha selecionada (em transações e cartões) |
| `d` | Excluir Registro | Exclui transação (com opção de apagar parcela única ou toda a série) |
| `p` | Pagar Fatura | Liquida fatura de cartão com débito em conta bancária |
| `b` | Backup Atômico | Gera snapshot seguro do SQLite e da planilha Excel em `~/backups/finance/` |
| `e` | Exportar Excel | Salva planilha `Planilha_Alforria_Homem_Rocha.xlsx` na pasta pessoal |
| `r` | Atualizar | Recarrega todos os dados do banco |
| `q` | Sair | Fecha a aplicação instantaneamente |

---

## 3. Navegação e Estrutura das Abas

### Survival HUD (Cabeçalho Superior)
Exibido permanentemente no topo:
1. **🛡️ Liquidez Líquida**: `Saldo Bancário - Dívidas Consolidadas de Cartão`. Mostra a real solvência patrimonial.
2. **💰 Disponível Bancos**: Total de saldo líquido somado em todas as contas correntes e carteira.
3. **💳 Dívidas Cartões**: Soma da fatura aberta do mês com todas as parcelas futuras já comprometidas.
4. **🫁 Teto de Oxigênio (Sem)**: Margem disponível dividida por 4 semanas para blindar contra gastos desgovernados.
5. **🎖️ Escudo de Resiliência**: Tiers de Antifragilidade baseados em meses de cobertura dos custos fixos.

---

## 4. CRUD Completo de Entidades

### Transações & Lançamentos
- **Criar (`n`)**: Preenche descrição, valor, tipo (receita/despesa), meio de pagamento (carregado dinamicamente das contas e cartões do banco), parcelamento (1x a 12x) e categoria.
- **Editar (`Enter`)**: Altera descrição, valor, data ou categoria. Se o valor de uma despesa em conta mudar, o saldo bancário correspondente é reajustado na hora.
- **Excluir (`d`)**: Se o lançamento pertencer a uma série parcelada, o sistema oferece dois caminhos claros:
  1. *Apagar apenas a parcela selecionada*.
  2. *Apagar toda a série de parcelamento* de uma única vez, limpando faturas futuras.

### Cartões de Crédito (Aba 5)
- **Novo Cartão**: Botão `[➕ Novo Cartão]` para cadastrar cartão de qualquer instituição, definindo limite, dia de fechamento (corte) e vencimento.
- **Editar Cartão**: `[✏️ Editar Cartão]` ou teclar `Enter` sobre a linha do cartão para alterar limites e datas de corte.
- **Excluir Cartão**: `[🗑️ Excluir Cartão]` com proteção de integridade referencial.
- **Tabela em Tempo Real**: Exibe limite total, dívida total comprometida, valor disponível (com alerta em vermelho se inferior a 30%), fatura do mês selecionado e status (`[PAGA]` ou `[ABERTA]`).

---

## 5. Mecanismo de Faturas de Cartão (Sem Bugs)

O cálculo de fechamento segue estritamente o calendário bancário:
- Compras realizadas **até o dia de corte** entram na fatura do mês corrente.
- Compras realizadas **após o dia de corte** caem automaticamente na fatura do mês seguinte (o "melhor dia de compra").
- Compras parceladas geram as entradas futuras nas faturas correspondentes com metadados de rastreio (`PARC_TIMESTAMP`).

### Reajuste / Conciliação de Fatura
Se a fatura no aplicativo do banco divergir de centavos ou de cobranças como IOF/taxas:
1. Clique em `[⚖️ Reajustar Fatura]` (ou use o botão na barra superior).
2. Digite o valor real final exibido no app do banco.
3. O sistema calcula a diferença exata e lança uma transação de ajuste vinculada àquela fatura, empatando o valor no centavo sem distorcer o histórico.

### Liquidação de Fatura
1. Clique em `[💳 Pagar Fatura [p]]`.
2. Selecione o cartão, o mês de referência e a conta bancária para débito.
3. O sistema desconta o saldo da conta, registra a transação de pagamento e marca a fatura como `paga`. Se já tiver sido paga anteriormente, o sistema impede a duplicação.

---

## 6. Time Machine & Snapshots Mensais Imutáveis

O APEX FINANCE possui uma Máquina do Tempo completa:
- Ao navegar entre os meses (`h` / `l`):
  - A tabela de transações filtra as movimentações do mês escolhido (incluindo parcelas de cartão daquele mês).
  - O status da fatura de cada cartão adapta-se àquele mês.
  - O badge superior reflete o estado:
    - `⚡ ATIVO`: Mês em curso.
    - `🔒 SELADO`: Mês auditado e congelado.
    - `⏳ PASSADO`: Mês já decorrido.
    - `🔮 PROJEÇÃO`: Meses futuros com previsibilidade de caixa.

### Selagem de Mês & Histórico Auditável
- **Selar Mês (`[🔒 Selar Mês]`)**: Tira uma foto atômica de fechamento, salvando todos os saldos, receitas, despesas, faturas pagas e o estado completo no formato JSON na tabela `monthly_snapshots`.
- **Ver Histórico (`[📜 Snapshots]`)**: Abre um modal tabular listando todos os fechamentos passados para acompanhar o crescimento da liquidez e do patrimônio sem alterações retroativas.

---

## 7. Rotinas de Backup Atômico & Restauração

A preservação dos dados é prioridade absoluta. O sistema inclui 3 camadas de proteção:

### 1. Backup via TUI (1 Toque)
- Pressione a tecla `b` ou clique no botão `[💾 Backup [b]]` na barra superior.
- Um snapshot seguro do SQLite e da planilha Excel é gravado instantaneamente em `~/backups/finance/`.

### 2. Backup via Linha de Comando / Scripts
Você pode disparar o backup de qualquer lugar do terminal:
```bash
apex-finance backup
# ou
fin backup
# ou
apex-finance-backup
```

### 3. Integração no Backup Geral do Sistema
O script mestre de backup dos dotfiles (`~/dotfiles/scripts/backup.sh`) inclui a etapa `step_backup_finance()`. Sempre que você rodar o backup dos dotfiles, o banco financeiro é sincronizado automaticamente.

### Restauração de Emergência
Para restaurar um backup anterior:
```bash
apex-finance restore ~/backups/finance/finance_backup_2026-09-14_203550.db
```
*(O sistema gera automaticamente um backup preventivo do estado atual antes de restaurar).*

---

## 8. Integração com o Dotfiles e Setup

Os arquivos do APEX FINANCE estão incorporados no repositório de dotfiles (`wheslancardoso/dotfiles`):
- `home/dot_local/share/apex-finance/core_engine.py`: Motor financeiro, regras de negócio e SQLite.
- `home/dot_local/share/apex-finance/executable_tui_app.py`: Interface gráfica de terminal (Textual).
- `home/dot_local/bin/executable_apex-finance`: Script executável com FZF e suporte CLI.
- `home/dot_local/bin/executable_apex-finance-backup`: Script utilitário de backup rápido.
- `scripts/backup.sh`: Rotina de backup do sistema integrada.
- `setup.sh`: Script de instalação inicial que provisiona automaticamente as dependências Python (`textual`, `textual-plotext`, `plotext`, `rich`, `openpyxl`), pastas e permissões de execução.

> [!NOTE]
> O arquivo `finance.db` permanece local em `~/.local/share/apex-finance/data/` e **nunca** é enviado para o repositório Git público, preservando 100% da sua privacidade e sigilo financeiro.
