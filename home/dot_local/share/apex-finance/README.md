# 🏛️ APEX FINANCE — COCKPIT SOBERANO

Suíte de Inteligência Financeira e Orçamento do Homem Rocha para Linux (Terminal / Hyprland).

## 🚀 Como Executar

```bash
fin               # Inicia o Cockpit Gráfico TUI (Textual + Plotext)
financas          # Alias idêntico
apex-finance      # Comando base

# Comandos Rápidos CLI
apex-finance backup       # Gera snapshot SQLite e planilha Excel em ~/backups/finance/
apex-finance export       # Exporta planilha Excel diretamente para ~/Planilha_Alforria_Homem_Rocha.xlsx
apex-finance fzf          # Inicia menu FZF alternativo
apex-finance restore <db> # Restaura backup de segurança
```

## ⌨️ Atalhos Principais no Cockpit TUI

- `1` a `6`: Alternar abas (Dashboard, Transações, Simulador, Caixinhas, Cartões, Recorrências)
- `h` / `l`: Mês anterior / Próximo mês na Time Machine
- `n`: Nova Transação (modal dinâmico)
- `Enter`: Editar registro selecionado (transação ou cartão)
- `d`: Excluir transação (com opção de apagar parcela única ou toda a série)
- `p`: Pagar fatura de cartão
- `b`: Backup atômico do banco e Excel
- `e`: Exportar planilha Excel
- `r`: Atualizar dados
- `q`: Sair instantaneamente

## 🛡️ Arquitetura e Dados

- Banco de dados: `~/.local/share/apex-finance/data/finance.db` (SQLite local, SSOT garantido)
- Backups automáticos: `~/backups/finance/`
- Código rastreado nos dotfiles (`~/dotfiles/home/dot_local/share/apex-finance/`)
