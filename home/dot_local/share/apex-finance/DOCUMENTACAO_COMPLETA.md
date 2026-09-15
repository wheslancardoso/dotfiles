# 🏛️ APEX FINANCE — DOCUMENTAÇÃO TÉCNICA E OPERACIONAL COMPLETA
> **Versão:** 2.0 (Soberana & Modular) | **Autor:** Antigravity & Wheslan Cardoso
> **Repositório:** `~/dotfiles/home/dot_local/share/apex-finance/`
> **Local de Execução:** `~/.local/share/apex-finance/`
> **Banco de Dados Local:** `~/.local/share/apex-finance/data/finance.db`

---

## 1. VISÃO GERAL DO SISTEMA
O **APEX Finance** é um cockpit de inteligência financeira, contabilidade soberana e auditoria preditiva desenvolvido sob medida para a jornada de emancipação e alforria pessoal de Wheslan Cardoso.

Diferente de aplicativos convencionais e planilhas instáveis que misturam fuso horários, alucinam faturas e vazam centavos por imprecisão de ponto flutuante, o APEX Finance é construído sobre **arquitetura determinística**:
* **Lógica & Matemática:** 100% em Python 3 e SQLite relacional. Arredondamentos e cortes exatos.
* **Interface TUI (Terminal User Interface):** Baseada em `Textual`, roda em 0.1 segundo direto no terminal (`fin`), consumindo menos de 40MB de RAM.
* **Offline-First & Soberano:** Zero dependência de nuvem de terceiros, sem assinaturas, sem telemetria.
* **Exportação Multicanal:** Suporte nativo a Planilha Excel (`.xlsx` com 3 abas estilizadas), Backup Atômico SQLite online e Contexto Hierárquico para IA em `/mnt/dados`.

---

## 2. PILARES & REGRAS DE NEGÓCIO INEGOCIÁVEIS
1. **Renda Líquida Mensal:** R$ 2.234,00 (Salário Comissionado da AGR no dia 05).
2. **13º Salário Garantido:** Parcela adicional de R$ 1.100,00 nos meses de Novembro e Dezembro (Renda salta para R$ 3.334,00).
3. **Aporte Sagrado Alforria 2028:** R$ 1.000,00/mês investidos a 115% do CDI para bater a meta de emancipação de R$ 27.000 a R$ 30.000 livres até Agosto de 2028 (quando completa 24 anos).
4. **Métricas HUD em Tempo Real:**
   * **💰 DEPOIS DAS CONTAS:** `Renda Prevista - (Faturas de Cartão + Custos Fixos + Aporte da Alforria)`. É a sobra real do mês.
   * **🏦 DISPONÍVEL BANCOS:** Soma líquida de todas as contas correntes e carteira física.
   * **💳 FATURAS DO MÊS:** Total de obrigações em cartões de crédito com vencimento no mês selecionado.
   * **🏰 RESERVA ALFORRIA:** Patrimônio acumulado rendendo juros compostos.
   * **🛡️ LIQUIDEZ LÍQUIDA:** `Disponível Bancos - Faturas Abertas`.

---

## 3. ARQUITETURA DO BANCO DE DADOS (SQLITE)

O banco `finance.db` opera com 8 tabelas relacionais rigorosamente normalizadas:

1. **`contas`**: Contas bancárias e carteira física.
   * `id, nome, tipo ('corrente'/'carteira'), instituicao, saldo, cor`
2. **`cartoes`**: Cartões de crédito com parâmetros de corte e vencimento.
   * `id, nome, instituicao, limite, dia_fechamento, dia_vencimento, conta_pagamento_id`
   * *Cartão Nubank Gold:* Fecha dia 04, vence dia 11.
   * *Cartão Caixa Elo/Visa:* Fecha dia 02, vence dia 10.
3. **`faturas`**: Controle do ciclo de faturas mensais.
   * `id, cartao_id, mes_referencia ('YYYY-MM'), data_fechamento, data_vencimento, status ('aberta'/'paga'), valor_pago, data_pagamento`
4. **`transacoes`**: Registro de receitas, despesas, parcelamentos e pagamentos de fatura.
   * `id, data, descricao, valor, tipo ('receita'/'despesa'/'fatura_cartao'), categoria, conta_id, cartao_id, caixinha_id, mes_fatura, parcela_atual, total_parcelas, grupo_parcelamento_id`
5. **`caixinhas`**: Metas de patrimônio e reservas com taxa mensal de rendimento.
   * `id, nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo, tipo_rendimento, taxa_mensal`
6. **`aportes_planejados`**: Customização e modularidade de aportes por mês específico.
   * `mes_referencia ('YYYY-MM'), caixinha_id, valor, motivo` (Permite aporte R$ 0,00 em Outubro e R$ 1.000 em Novembro).
7. **`recorrencias`**: Custos fixos e fontes de receita orçamentárias.
   * `id, descricao, valor, tipo, categoria, conta_id, dia_vencimento, ativo (1/0)`
8. **`wishlist`**: Radar de compras futuras planejadas sem atrito.
   * `id, item, categoria, valor_estimado, parcelas_sugeridas, prioridade, condicao_compra, status ('planejado'/'comprado'/'cancelado'), link_ou_obs, data_criacao`
9. **`monthly_snapshots`**: Fechamentos imutáveis de meses selados para auditoria histórica.
   * `mes_referencia, data_snapshot, saldo_bancario_total, saldo_caixinhas_total, total_receitas, total_despesas, total_faturas_pagas, liquidez_liquida, teto_oxigenio, status, snapshot_json`

---

## 4. AS 7 ABAS DO COCKPIT TUI (`fin`)

### Aba 1: `📊 'Depois das Contas' & Fluxo do Mês` (Tecla `1`)
* Radiografia cirúrgica do fluxo financeiro do mês selecionado.
* Painel esquerdo: Resumo consolidado de receitas, faturas, fixos e saldo da Alforria.
* Painel direito: Extrato completo com tags de conforto (`✅ CONFORTÁVEL`, `⚠️ APERTADO`, `🚨 DÉFICIT DE CAIXA`).

### Aba 2: `📝 Transações & Faturas` (Tecla `2`)
* Tabela de lançamentos reais do mês ou histórico global (`btn-toggle-month-tx`).
* Atalho `n`: Nova transação manual (Conta ou Cartão em até 12x).
* Atalho `Enter`: Editar transação selecionada.
* Atalho `d`: Excluir transação. Se fizer parte de uma série parcelada, oferece opção de apagar só a parcela ou toda a série.
* Atalho `p`: Pagar fatura do cartão debitando da conta e travando pagamento duplicado.

### Aba 3: `🔮 Simulador de Impacto (Sandbox)` (Tecla `3`)
* Máquina do tempo preditiva: digite valor, parcelas e meio de pagamento.
* **Tabela de Auditoria Mês a Mês** (`table-sim-impact`): Compara a sobra de cada um dos próximos 12 meses antes vs. depois da compra, indicando percentual de comprometimento e veredicto.
* Botão `🚀 Efetivar Compra no Banco`: Converte a simulação em compra real instantaneamente.

### Aba 4: `🏰 Caixinhas & Alforria (115% CDI)` (Tecla `4`)
* CRUD completo de caixinhas (`➕ Nova`, `✏️ Editar`, `🗑️ Excluir`).
* `💰 Aporte Imediato`: Debita de uma conta corrente e credita na caixinha.
* `⏸️ Ajustar/Pausar Mês`: Define aportes customizados por mês (ex: R$ 0 em Outubro).
* Barras de progresso da Alforria 2028, CG 160 e Presença.
* Tabela de juros compostos calculados mês a mês até Agosto de 2028.

### Aba 5: `💳 Cartões & Faturas` (Tecla `5`)
* Tabela de cartões cadastrados com limites, comprometido, disponível, corte e vencimento.
* Botão `⚖️ Reajustar Fatura`: Conciliação contra o app do banco (ajusta centavos, IOF ou estornos sem quebrar o banco).

### Aba 6: `🔁 Recorrências & Fixos` (Tecla `6`)
* Gestão do orçamento base de custos fixos.
* `➕ Nova Recorrência` / `✏️ Editar` / `🗑️ Excluir`.
* `⚡ Pausar / Reativar`: Desativa temporariamente um custo fixo do cálculo da sobra sem apagá-lo da base.

### Aba 7: `🎯 Wishlist & Compras Futuras` (Tecla `7`)
* Radar de compras conscientes (Fone QCY, Adaptador PC, Garrafa Stanley).
* Permite cadastrar desejos com prioridade e condição/gatilho (ex: *"Após quitar faturas"*).
* Botão `🚀 Efetivar Compra Real`: Quando chegar o momento certo, abre o modal e cria as parcelas no cartão com 1 clique, marcando o item como comprado.

---

## 5. RECURSOS DE TOPO E NAVEGADOR TEMPORAL
* `◀ [h]` / `[l] ▶`: Navega mês a mês no passado ou futuro.
* `Select Mês`: Salta direto para qualquer mês entre Set/2026 e Ago/2028.
* `🔒 Selar`: Gera snapshot imutável de fechamento de mês.
* `📜 Snapshots`: Visualiza histórico de fechamentos patrimoniais passados.
* `💾 Backup [b]`: Gera backup online SQLite em `~/backups/finance/` e espelha em `/mnt/dados`.
* `🧠 Contexto IA [x]`: Exporta hierarquia completa em Markdown para `/mnt/dados/01_Pessoal_e_Vida/01.5_Financas_e_Contas/Apex_Contexto_IA/`.
* `⚡ Ritual`: Checklist do ritual do domingo à noite para blindagem semanal.

---

## 6. COMANDOS DE TERMINAL & CLI
```bash
fin                 # Inicia o Cockpit Gráfico TUI
fin --backup        # Realiza backup online SQLite + Planilha Excel
fin --export-excel  # Gera a planilha estilizada Planilha_Alforria_Homem_Rocha.xlsx
fin --export-ia     # Exporta CONTEXTO_GLOBAL.md e todos os arquivos mensais para /mnt/dados
```

---

## 7. SUITE DE TESTES AUTOMATIZADOS (PYTEST)
Para rodar a bateria completa de 18 testes unitários e edge cases:
```bash
python3 -m pytest ~/.local/share/apex-finance/tests/test_apex_finance.py -v
```
* **Cobertura dos Testes:**
  * Fechamento de fatura antes, no dia e após o corte.
  * Virada de ano em Dezembro/Janeiro.
  * Parcelamento com cruzamento de calendário.
  * Reconciliação e prevenção de duplicidade de pagamento de faturas.
  * Exclusão em lote de séries parceladas.
  * Rendimento do CDI e pausas programadas de aporte.
  * CRUD e efetivação de compras da Wishlist.
  * Geração de planilhas Excel e arquivos de Contexto IA.
  * Simulação de fluxo de caixa preditivo.
