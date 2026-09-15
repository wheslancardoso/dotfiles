#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
==============================================================================
🏛️ APEX FINANCE TUI — O COCKPIT GRÁFICO DO HOMEM ROCHA (TERMINAL SOBERANO)
==============================================================================
Interface gráfica de alta fidelidade para o terminal baseada em Textual & Plotext.
- Estética Brutalista & Catppuccin Mocha
- Survival HUD em tempo real (Liquidez Líquida, Teto de Oxigênio, Escudo de Resiliência)
- Time Machine (Navegador Temporal mês a mês)
- Simulador de Gastos Preditivo com Gráficos de Impacto no Fluxo de Caixa (12 meses)
- Faturas de Cartão com corte automático, parcelamento e pagamento de fatura
- Caixinhas do Nubank com barras de progresso e projeção do CDI (115%)
- Navegação completa por teclado estilo Vim (j/k, h/l, 1-6, n, s, p, e, r, q) e mouse
"""

import sys
import os
import datetime
from datetime import date
from typing import List, Dict, Any

# Garante path para o engine
sys.path.append(os.path.expanduser("~/.local/share/apex-finance"))
import core_engine

from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical, VerticalScroll, Grid
from textual.widgets import (
    Header, Footer, Static, Button, Label, Input, Select,
    TabbedContent, TabPane, DataTable, ProgressBar, Rule, Checkbox
)
from textual.screen import ModalScreen
from textual.binding import Binding
from textual_plotext import PlotextPlot

# ==============================================================================
# TEMA & CSS BRUTALISTA CATPPUCCIN MOCHA
# ==============================================================================
TUI_CSS = """
Screen {
    background: #181825;
    color: #cdd6f4;
}

#top-banner {
    dock: top;
    background: #1e1e2e;
    height: 3;
    padding: 0 1;
    border-bottom: solid #cba6f7;
    content-align: center middle;
}

#hud-container {
    height: 5;
    background: #181825;
    padding: 0 1;
    margin-bottom: 1;
    grid-size: 5;
}

.hud-card {
    height: 4;
    border: round #313244;
    background: #1e1e2e;
    padding: 0 1;
    content-align: center middle;
}

.hud-card:hover {
    border: round #cba6f7;
}

.hud-label {
    text-style: bold;
    color: #a6adc8;
    content-align: center middle;
}

.hud-val-green {
    text-style: bold;
    color: #a6e3a1;
    content-align: center middle;
}

.hud-val-red {
    text-style: bold;
    color: #f38ba8;
    content-align: center middle;
}

.hud-val-blue {
    text-style: bold;
    color: #89b4fa;
    content-align: center middle;
}

.hud-val-yellow {
    text-style: bold;
    color: #f9e2af;
    content-align: center middle;
}

.hud-val-mauve {
    text-style: bold;
    color: #cba6f7;
    content-align: center middle;
}

#time-navigator {
    height: 3;
    background: #1e1e2e;
    border-top: solid #313244;
    border-bottom: solid #313244;
    padding: 0 1;
    align: center middle;
}

#select-month-nav {
    width: 30;
    height: 3;
    border: none;
    background: #181825;
    color: #cba6f7;
    text-style: bold;
}

#month-display {
    text-style: bold;
    color: #cba6f7;
    width: 26;
    content-align: center middle;
}

#dash-depois-contas-box {
    border: round #89b4fa;
    background: #1e1e2e;
    padding: 1;
}

TabbedContent {
    background: #181825;
    height: 1fr;
}

TabPane {
    padding: 1 2;
    background: #181825;
}

.section-box {
    border: round #45475a;
    background: #1e1e2e;
    padding: 1;
    margin-bottom: 1;
}

.section-title {
    text-style: bold;
    color: #cba6f7;
    margin-bottom: 1;
}

DataTable {
    height: 1fr;
    border: round #313244;
    background: #1e1e2e;
}

DataTable > .datatable--header {
    background: #313244;
    color: #cba6f7;
    text-style: bold;
}

DataTable > .datatable--cursor {
    background: #45475a;
    color: #f5e0dc;
    text-style: bold;
}

/* Simulador de Impacto */
#sim-form {
    border: round #cba6f7;
    background: #1e1e2e;
    padding: 1 2;
    margin-bottom: 1;
}

.sim-input-row {
    height: 3;
    margin-bottom: 1;
    align: left middle;
}

.sim-label {
    width: 22;
    color: #bac2de;
    text-style: bold;
}

.verdict-box {
    height: 3;
    border: round #89b4fa;
    background: #181825;
    content-align: center middle;
    text-style: bold;
    margin-top: 1;
}

/* Modals */
ModalScreen {
    align: center middle;
    background: rgba(24, 24, 37, 0.85);
}

.modal-dialog {
    width: 65;
    height: auto;
    border: thick #cba6f7;
    background: #1e1e2e;
    padding: 1 2;
}

.modal-title {
    text-style: bold;
    color: #cba6f7;
    content-align: center middle;
    margin-bottom: 1;
}

.modal-btn-row {
    margin-top: 1;
    align: right middle;
    height: 3;
}

Button {
    background: #313244;
    color: #cdd6f4;
    border: none;
    margin-left: 1;
}

Button:hover {
    background: #cba6f7;
    color: #11111b;
    text-style: bold;
}

Button.-primary {
    background: #a6e3a1;
    color: #11111b;
    text-style: bold;
}

Button.-danger {
    background: #f38ba8;
    color: #11111b;
}

/* Caixinhas */
.cx-card {
    border: round #313244;
    background: #1e1e2e;
    padding: 1;
    margin-bottom: 1;
}

ProgressBar {
    margin-top: 1;
    margin-bottom: 1;
}

/* Ritual */
.ritual-item {
    margin-bottom: 1;
}
"""

# ==============================================================================
# MODAL: NOVA TRANSAÇÃO
# ==============================================================================
class AddTransactionModal(ModalScreen):
    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("➕ NOVA TRANSAÇÃO (CONTA OU CARTÃO)", classes="modal-title")
            
            yield Label("Descrição do Gasto / Receita:")
            yield Input(placeholder="Ex: Gasolina CG 160 / Carnes açougue / Salário", id="tx-desc")
            
            yield Label("Valor em R$ (ex: 85.50):")
            yield Input(placeholder="0.00", id="tx-val")
            
            yield Label("Tipo:")
            yield Select([("Despesa", "despesa"), ("Receita", "receita")], value="despesa", id="tx-tipo")
            
            conn = core_engine.get_connection()
            cartoes = conn.execute("SELECT id, nome, instituicao FROM cartoes ORDER BY id").fetchall()
            contas = conn.execute("SELECT id, nome, instituicao FROM contas ORDER BY id").fetchall()
            conn.close()

            meio_options = []
            for cr in cartoes:
                meio_options.append((f"💳 {cr['nome']} ({cr['instituicao']})", f"cartao-{cr['id']}"))
            for ct in contas:
                meio_options.append((f"🏦 {ct['nome']} ({ct['instituicao']})", f"conta-{ct['id']}"))
            if not meio_options:
                meio_options = [("Conta Nubank", "conta-1")]

            yield Label("Meio de Pagamento:")
            yield Select(meio_options, value=meio_options[0][1], id="tx-meio")
            
            yield Label("Parcelas (se Cartão):")
            yield Select([(f"{i}x", str(i)) for i in range(1, 13)], value="1", id="tx-parc")
            
            yield Label("Categoria:")
            yield Select([
                ("Moto (Gasolina / Óleo / IPVA)", "Moto (Gasolina / Óleo / IPVA)"),
                ("Provisão Casa (Carnes)", "Provisão Casa (Carnes)"),
                ("Saúde Mental / Psiquiatria", "Saúde Mental / Psiquiatria"),
                ("Barbearia & Cuidados", "Barbearia & Cuidados"),
                ("Estética / Minoxidil / Roupas", "Estética / Minoxidil / Roupas"),
                ("Alforria / Investimento", "Alforria / Investimento"),
                ("Salário Comissionado AGR", "Salário Comissionado AGR"),
                ("Outros / Manobra", "Outros / Manobra"),
            ], value="Moto (Gasolina / Óleo / IPVA)", id="tx-cat")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar [Esc]", id="btn-cancel", classes="-danger")
                yield Button("Salvar Transação [Enter]", id="btn-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-cancel":
            self.dismiss(False)
            return

        desc = self.query_one("#tx-desc", Input).value.strip()
        val_str = self.query_one("#tx-val", Input).value.strip().replace(",", ".")
        tipo = self.query_one("#tx-tipo", Select).value
        meio = self.query_one("#tx-meio", Select).value
        parc = int(self.query_one("#tx-parc", Select).value)
        cat = self.query_one("#tx-cat", Select).value
        
        if not desc or not val_str:
            self.app.notify("Preencha descrição e valor!", severity="error")
            return
            
        try:
            val = float(val_str)
            if val <= 0:
                raise ValueError()
        except ValueError:
            self.app.notify("Valor numérico inválido!", severity="error")
            return
            
        dt_hoje = str(date.today())
        
        if meio.startswith("cartao-"):
            cid = int(meio.split("-")[1])
            core_engine.registrar_compra_cartao(cid, dt_hoje, desc, val, cat, parcelas=parc)
            self.app.notify(f"✔ Compra de R$ {val:,.2f} ({parc}x) registrada no Cartão!")
        else:
            conta_id = int(meio.split("-")[1])
            core_engine.adicionar_transacao_conta(conta_id, dt_hoje, desc, val, tipo, cat)
            self.app.notify(f"✔ Transação de R$ {val:,.2f} registrada na Conta!")
            
        self.dismiss(True)

# ==============================================================================
# MODAL: EDITAR TRANSAÇÃO
# ==============================================================================
class EditTransactionModal(ModalScreen):
    def __init__(self, tx_id: int):
        super().__init__()
        self.tx_id = tx_id
        conn = core_engine.get_connection()
        self.tx = conn.execute("SELECT * FROM transacoes WHERE id = ?", (tx_id,)).fetchone()
        conn.close()

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label(f"✏️ EDITAR TRANSAÇÃO #{self.tx_id}", classes="modal-title")
            
            yield Label("Descrição:")
            yield Input(value=self.tx['descricao'] if self.tx else "", id="edit-desc")
            
            yield Label("Valor em R$:")
            yield Input(value=f"{self.tx['valor']:.2f}" if self.tx else "0.00", id="edit-val")
            
            yield Label("Tipo:")
            yield Select([("Despesa", "despesa"), ("Receita", "receita")], value=self.tx['tipo'] if self.tx else "despesa", id="edit-tipo")
            
            yield Label("Data (AAAA-MM-DD):")
            yield Input(value=self.tx['data'] if self.tx else str(date.today()), id="edit-data")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-edit-cancel", classes="-danger")
                yield Button("Salvar Alterações", id="btn-edit-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-edit-cancel":
            self.dismiss(False)
            return

        desc = self.query_one("#edit-desc", Input).value.strip()
        val_str = self.query_one("#edit-val", Input).value.strip().replace(",", ".")
        tipo = self.query_one("#edit-tipo", Select).value
        dt_str = self.query_one("#edit-data", Input).value.strip()
        
        try:
            val = float(val_str)
            cat = self.tx['categoria'] if self.tx else "Outros / Manobra"
            core_engine.editar_transacao(self.tx_id, desc, val, tipo, cat, dt_str)
            self.app.notify("✔ Transação atualizada com sucesso!", severity="information")
            self.dismiss(True)
        except Exception as e:
            self.app.notify(f"Erro ao editar: {e}", severity="error")

# ==============================================================================
# MODAL: DELETAR TRANSAÇÃO
# ==============================================================================
class DeleteTransactionModal(ModalScreen):
    def __init__(self, tx_id: int):
        super().__init__()
        self.tx_id = tx_id
        conn = core_engine.get_connection()
        self.tx = conn.execute("SELECT * FROM transacoes WHERE id = ?", (tx_id,)).fetchone()
        conn.close()

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label(f"🗑️ EXCLUIR TRANSAÇÃO #{self.tx_id}", classes="modal-title")
            desc = self.tx['descricao'] if self.tx else "Desconhecida"
            val = self.tx['valor'] if self.tx else 0.0
            yield Static(f"Deseja realmente apagar a transação:\n[bold]{desc}[/bold] (R$ {val:,.2f})?\n")
            
            if self.tx and self.tx['grupo_parcelamento_id']:
                yield Static("[yellow]⚠ Esta transação faz parte de uma série parcelada![/yellow]")
                with Horizontal(classes="modal-btn-row"):
                    yield Button("Cancelar", id="btn-del-cancel")
                    yield Button("Apagar SÓ Esta Parcela", id="btn-del-single", classes="-danger")
                    yield Button("Apagar TODA a Série", id="btn-del-all", classes="-danger")
            else:
                with Horizontal(classes="modal-btn-row"):
                    yield Button("Cancelar", id="btn-del-cancel")
                    yield Button("Confirmar Exclusão", id="btn-del-single", classes="-danger")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-del-cancel":
            self.dismiss(False)
            return
            
        del_all = (event.button.id == "btn-del-all")
        success, msg = core_engine.deletar_transacao(self.tx_id, deletar_todas_parcelas=del_all)
        if success:
            self.app.notify(f"✔ {msg}", severity="information")
            self.dismiss(True)
        else:
            self.app.notify(f"Erro: {msg}", severity="error")
            self.dismiss(False)

# ==============================================================================
# MODAL: PAGAR FATURA
# ==============================================================================
class PayInvoiceModal(ModalScreen):
    def __init__(self, cartao_id: int = None, mes_ref: str = None):
        super().__init__()
        self.preset_cartao_id = cartao_id
        self.preset_mes_ref = mes_ref or str(date.today())[:7]

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("💳 PAGAR FATURA DO CARTÃO DE CRÉDITO", classes="modal-title")
            
            conn = core_engine.get_connection()
            cartoes = conn.execute("SELECT id, nome, instituicao FROM cartoes ORDER BY id").fetchall()
            contas = conn.execute("SELECT id, nome, instituicao FROM contas ORDER BY id").fetchall()
            conn.close()

            cartao_options = [(f"💳 {r['nome']} ({r['instituicao']})", str(r['id'])) for r in cartoes] or [("Cartão", "1")]
            conta_options = [(f"🏦 {r['nome']} ({r['instituicao']})", str(r['id'])) for r in contas] or [("Conta", "1")]

            default_cid = str(self.preset_cartao_id) if self.preset_cartao_id and any(o[1] == str(self.preset_cartao_id) for o in cartao_options) else cartao_options[0][1]
            default_conta = conta_options[0][1]

            yield Label("Cartão:")
            yield Select(cartao_options, value=default_cid, id="pay-cartao")
            
            yield Label("Mês de Referência da Fatura (AAAA-MM):")
            yield Input(value=self.preset_mes_ref, id="pay-mes")
            
            yield Label("Conta para Débito:")
            yield Select(conta_options, value=default_conta, id="pay-conta")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-pay-cancel", classes="-danger")
                yield Button("Liquidar Fatura", id="btn-pay-confirm", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-pay-cancel":
            self.dismiss(False)
            return

        cid = int(self.query_one("#pay-cartao", Select).value)
        mes_ref = self.query_one("#pay-mes", Input).value.strip()
        conta_id = int(self.query_one("#pay-conta", Select).value)
        
        total, msg = core_engine.pagar_fatura(cid, mes_ref, conta_id)
        if total > 0:
            self.app.notify(f"✔ Fatura {mes_ref} de R$ {total:,.2f} liquidada com sucesso!", severity="information")
            self.dismiss(True)
        else:
            self.app.notify(f"Aviso: {msg}", severity="warning")
            self.dismiss(False)

# ==============================================================================
# MODAL: RECONCILIAR SALDO DE CONTA
# ==============================================================================
class ReconcileModal(ModalScreen):
    def __init__(self, conta_id: int = None):
        super().__init__()
        self.preset_conta_id = conta_id

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("🏦 AJUSTAR SALDO BANCÁRIO REAL", classes="modal-title")
            
            conn = core_engine.get_connection()
            contas = conn.execute("SELECT id, nome, instituicao FROM contas ORDER BY id").fetchall()
            conn.close()
            conta_options = [(f"🏦 {r['nome']} ({r['instituicao']})", str(r['id'])) for r in contas] or [("Conta", "1")]

            default_cid = str(self.preset_conta_id) if self.preset_conta_id and any(o[1] == str(self.preset_conta_id) for o in conta_options) else conta_options[0][1]

            yield Label("Conta para Reconciliação:")
            yield Select(conta_options, value=default_cid, id="rec-conta")
            
            yield Label("Novo Saldo Real Exato (R$):")
            yield Input(placeholder="Ex: 250.00", id="rec-saldo")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-rec-cancel", classes="-danger")
                yield Button("Confirmar Ajuste", id="btn-rec-confirm", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-rec-cancel":
            self.dismiss(False)
            return

        conta_id = int(self.query_one("#rec-conta", Select).value)
        saldo_str = self.query_one("#rec-saldo", Input).value.strip().replace(",", ".")
        try:
            novo_saldo = float(saldo_str)
            core_engine.reconciliar_saldo(conta_id, novo_saldo)
            self.app.notify(f"✔ Saldo ajustado para R$ {novo_saldo:,.2f}!")
            self.dismiss(True)
        except Exception as e:
            self.app.notify("Valor de saldo inválido!", severity="error")

# ==============================================================================
# MODAL: RITUAL DO DOMINGO À NOITE (15 MINUTOS)
# ==============================================================================
class SundayRitualModal(ModalScreen):
    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("🕯️ RITUAL DO DOMINGO À NOITE (AUDITORIA RÁPIDA)", classes="modal-title")
            yield Static("[italic yellow]\"Quem é fiel no pouco, sobre o muito será colocado.\" (Lc 16:10)[/italic yellow]\n\nAbra os apps bancários e audite a sua blindagem semanal:\n")
            
            yield Checkbox(" [1] Fatura Cartão Caixa: Apenas gastos previstos e zero surpresas?", id="c1")
            yield Checkbox(" [2] Caixinha Alforria: Aporte sagrado intacto rendendo 115% CDI?", id="c2")
            yield Checkbox(" [3] CG 160: Óleo Motul 5100 verificado e pneus calibrados (25/33 PSI)?", id="c3")
            yield Checkbox(" [4] Provisão Familiar: Carnes limpas e compras essenciais em dia?", id="c4")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Fechar", id="btn-rit-close", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        c1 = self.query_one("#c1", Checkbox).value
        c2 = self.query_one("#c2", Checkbox).value
        c3 = self.query_one("#c3", Checkbox).value
        c4 = self.query_one("#c4", Checkbox).value
        if c1 and c2 and c3 and c4:
            self.app.notify("🛡️ Semana 100% blindada! Mente serena de Homem Rocha.", severity="information")
        self.dismiss(True)

# ==============================================================================
# MODAL: REAJUSTAR FATURA DE CARTÃO
# ==============================================================================
class AdjustInvoiceModal(ModalScreen):
    def __init__(self, cartao_id: int = None, mes_ref: str = None):
        super().__init__()
        self.preset_cartao_id = cartao_id
        self.preset_mes_ref = mes_ref or str(date.today())[:7]

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("⚖️ REAJUSTAR FATURA DE CARTÃO", classes="modal-title")
            yield Static("Digite o valor exato que consta no app do banco para sincronizar a fatura:\n")
            
            conn = core_engine.get_connection()
            cartoes = conn.execute("SELECT id, nome, instituicao FROM cartoes ORDER BY id").fetchall()
            conn.close()
            cartao_options = [(f"💳 {r['nome']} ({r['instituicao']})", str(r['id'])) for r in cartoes] or [("Cartão", "1")]

            default_cid = str(self.preset_cartao_id) if self.preset_cartao_id and any(o[1] == str(self.preset_cartao_id) for o in cartao_options) else cartao_options[0][1]

            yield Label("Cartão:")
            yield Select(cartao_options, value=default_cid, id="adj-cartao")
            
            yield Label("Mês de Referência (AAAA-MM):")
            yield Input(value=self.preset_mes_ref, id="adj-mes")
            
            yield Label("Novo Valor Total Exato no App (R$):")
            yield Input(placeholder="Ex: 487.32", id="adj-val")
            
            yield Label("Motivo / Observação:")
            yield Input(value="Ajuste / Conciliação de Fatura", id="adj-motivo")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-adj-cancel", classes="-danger")
                yield Button("Aplicar Reajuste", id="btn-adj-confirm", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-adj-cancel":
            self.dismiss(False)
            return

        cid = int(self.query_one("#adj-cartao", Select).value)
        mes_ref = self.query_one("#adj-mes", Input).value.strip()
        val_str = self.query_one("#adj-val", Input).value.strip().replace(",", ".")
        motivo = self.query_one("#adj-motivo", Input).value.strip() or "Ajuste de Fatura"
        
        try:
            val = float(val_str)
            dif, msg = core_engine.reajustar_fatura_cartao(cid, mes_ref, val, motivo=motivo)
            self.app.notify(msg, severity="information")
            self.dismiss(True)
        except Exception as e:
            self.app.notify(f"Erro ao reajustar fatura: {e}", severity="error")

# ==============================================================================
# MODAL: NOVO CARTÃO DE CRÉDITO
# ==============================================================================
class AddCardModal(ModalScreen):
    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("💳 CADASTRAR NOVO CARTÃO DE CRÉDITO", classes="modal-title")
            
            yield Label("Nome do Cartão:")
            yield Input(placeholder="Ex: Cartão Inter Black / C6 Carbon", id="card-nome")
            
            yield Label("Instituição:")
            yield Input(placeholder="Ex: Inter / C6 / Itaú / Nubank", id="card-inst")
            
            yield Label("Limite Total (R$):")
            yield Input(placeholder="Ex: 5000.00", id="card-limite")
            
            yield Label("Dia de Fechamento (Corte da Fatura):")
            yield Select([(str(i), str(i)) for i in range(1, 32)], value="20", id="card-corte")
            
            yield Label("Dia de Vencimento:")
            yield Select([(str(i), str(i)) for i in range(1, 32)], value="28", id="card-venc")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-card-cancel", classes="-danger")
                yield Button("Salvar Cartão", id="btn-card-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-card-cancel":
            self.dismiss(False)
            return

        nome = self.query_one("#card-nome", Input).value.strip()
        inst = self.query_one("#card-inst", Input).value.strip()
        lim_str = self.query_one("#card-limite", Input).value.strip().replace(",", ".")
        corte = int(self.query_one("#card-corte", Select).value)
        venc = int(self.query_one("#card-venc", Select).value)
        
        if not nome or not inst or not lim_str:
            self.app.notify("Preencha todos os campos do cartão!", severity="error")
            return
            
        try:
            limite = float(lim_str)
            core_engine.criar_cartao(nome, inst, limite, corte, venc)
            self.app.notify(f"✔ Cartão {nome} cadastrado com sucesso!", severity="information")
            self.dismiss(True)
        except Exception as e:
            self.app.notify(f"Erro ao cadastrar cartão: {e}", severity="error")

# ==============================================================================
# MODAL: EDITAR CARTÃO DE CRÉDITO
# ==============================================================================
class EditCardModal(ModalScreen):
    def __init__(self, card_id: int):
        super().__init__()
        self.card_id = card_id
        conn = core_engine.get_connection()
        self.card = conn.execute("SELECT * FROM cartoes WHERE id = ?", (card_id,)).fetchone()
        conn.close()

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            nome = self.card['nome'] if self.card else ""
            yield Label(f"✏️ EDITAR CARTÃO: {nome}", classes="modal-title")
            
            yield Label("Nome:")
            yield Input(value=self.card['nome'] if self.card else "", id="ecard-nome")
            
            yield Label("Instituição:")
            yield Input(value=self.card['instituicao'] if self.card else "", id="ecard-inst")
            
            yield Label("Limite Total (R$):")
            yield Input(value=f"{self.card['limite']:.2f}" if self.card else "0.00", id="ecard-limite")
            
            yield Label("Dia de Fechamento (Corte):")
            yield Select([(str(i), str(i)) for i in range(1, 32)], value=str(self.card['dia_fechamento']) if self.card else "20", id="ecard-corte")
            
            yield Label("Dia de Vencimento:")
            yield Select([(str(i), str(i)) for i in range(1, 32)], value=str(self.card['dia_vencimento']) if self.card else "28", id="ecard-venc")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-ecard-cancel", classes="-danger")
                yield Button("Salvar Alterações", id="btn-ecard-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-ecard-cancel":
            self.dismiss(False)
            return

        nome = self.query_one("#ecard-nome", Input).value.strip()
        inst = self.query_one("#ecard-inst", Input).value.strip()
        lim_str = self.query_one("#ecard-limite", Input).value.strip().replace(",", ".")
        corte = int(self.query_one("#ecard-corte", Select).value)
        venc = int(self.query_one("#ecard-venc", Select).value)
        
        try:
            limite = float(lim_str)
            core_engine.editar_cartao(self.card_id, nome, inst, limite, corte, venc)
            self.app.notify(f"✔ Cartão {nome} atualizado com sucesso!", severity="information")
            self.dismiss(True)
        except Exception as e:
            self.app.notify(f"Erro ao atualizar cartão: {e}", severity="error")

# ==============================================================================
# MODAL: DELETAR CARTÃO DE CRÉDITO
# ==============================================================================
class DeleteCardModal(ModalScreen):
    def __init__(self, card_id: int):
        super().__init__()
        self.card_id = card_id
        conn = core_engine.get_connection()
        self.card = conn.execute("SELECT * FROM cartoes WHERE id = ?", (card_id,)).fetchone()
        conn.close()

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            nome = self.card['nome'] if self.card else "Desconhecido"
            yield Label(f"🗑️ EXCLUIR CARTÃO: {nome}", classes="modal-title")
            yield Static(f"Deseja realmente apagar o cartão [bold]{nome}[/bold]?\n\n[red]⚠ ATENÇÃO: Todas as faturas e compras vinculadas a este cartão serão removidas![/red]\n")
            
            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-dcard-cancel")
                yield Button("Confirmar Exclusão", id="btn-dcard-confirm", classes="-danger")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-dcard-cancel":
            self.dismiss(False)
            return
            
        core_engine.deletar_cartao(self.card_id)
        self.app.notify(f"✔ Cartão excluído com sucesso!", severity="information")
        self.dismiss(True)

# ==============================================================================
# MODAL: HISTÓRICO DE SNAPSHOTS MENSAIS (AUDITORIA IMUTÁVEL)
# ==============================================================================
class SnapshotsModal(ModalScreen):
    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("📜 HISTÓRICO DE SNAPSHOTS MENSAIS (FECHAMENTOS)", classes="modal-title")
            yield Static("Fechamentos imutáveis de meses passados para auditoria patrimonial:\n")
            yield DataTable(id="table-snapshots")
            with Horizontal(classes="modal-btn-row"):
                yield Button("Fechar", id="btn-snap-close", classes="-primary")

    def on_mount(self) -> None:
        table = self.query_one("#table-snapshots", DataTable)
        table.cursor_type = "row"
        table.zebra_stripes = True
        table.add_columns("Mês", "Data Fechamento", "Saldo Bancos", "Caixinhas", "Liquidez", "Teto/Sem", "Status")
        
        snaps = core_engine.listar_snapshots_historicos()
        for s in snaps:
            table.add_row(
                s['mes_referencia'], s['data_snapshot'],
                f"R$ {s['saldo_bancario_total']:,.2f}",
                f"R$ {s['saldo_caixinhas_total']:,.2f}",
                f"R$ {s['liquidez_liquida']:,.2f}",
                f"R$ {s['teto_oxigenio']:,.2f}",
                s['status'].upper()
            )

    def on_button_pressed(self, event: Button.Pressed) -> None:
        self.dismiss(True)

# ==============================================================================
# MODAL: CRUD CAIXINHA (CRIAR / EDITAR)
# ==============================================================================
class AddEditCaixinhaModal(ModalScreen):
    def __init__(self, caixinha_id: int = None):
        super().__init__()
        self.caixinha_id = caixinha_id

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            title = "➕ NOVA CAIXINHA DE METAS" if not self.caixinha_id else "✏️ EDITAR CAIXINHA"
            yield Label(title, classes="modal-title")
            
            nome_val, desc_val, meta_val, aporte_val, saldo_val, alvo_val = "", "", "1500.00", "100.00", "0.00", "2027-12-31"
            if self.caixinha_id:
                conn = core_engine.get_connection()
                cx = conn.execute("SELECT * FROM caixinhas WHERE id = ?", (self.caixinha_id,)).fetchone()
                conn.close()
                if cx:
                    nome_val = cx['nome']
                    desc_val = cx['descricao'] or ""
                    meta_val = f"{cx['meta_total']:.2f}"
                    aporte_val = f"{cx['aporte_mensal']:.2f}"
                    saldo_val = f"{cx['saldo_atual']:.2f}"
                    alvo_val = str(cx['data_alvo']) if cx['data_alvo'] else "2028-08-01"

            yield Label("Nome da Caixinha / Alvo:")
            yield Input(value=nome_val, placeholder="Ex: Reserva Alforria / Moto CG 160", id="cx-nome")

            yield Label("Descrição / Objetivo:")
            yield Input(value=desc_val, placeholder="Ex: Fundo de reserva e alforria", id="cx-desc")

            yield Label("Meta Total em R$:")
            yield Input(value=meta_val, placeholder="27000.00", id="cx-meta")

            yield Label("Aporte Mensal Padrão (R$):")
            yield Input(value=aporte_val, placeholder="1000.00", id="cx-aporte")

            yield Label("Saldo Atual (R$):")
            yield Input(value=saldo_val, placeholder="1000.00", id="cx-saldo")

            yield Label("Data Alvo (AAAA-MM-DD):")
            yield Input(value=alvo_val, placeholder="2028-08-01", id="cx-alvo")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-cx-cancel", classes="-danger")
                yield Button("Salvar Caixinha", id="btn-cx-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-cx-cancel":
            self.dismiss(False)
            return

        nome = self.query_one("#cx-nome", Input).value.strip()
        if not nome:
            self.app.notify("Nome da caixinha é obrigatório!", severity="error")
            return
        desc = self.query_one("#cx-desc", Input).value.strip()
        try:
            meta = float(self.query_one("#cx-meta", Input).value.strip().replace(",", "."))
            aporte = float(self.query_one("#cx-aporte", Input).value.strip().replace(",", "."))
            saldo = float(self.query_one("#cx-saldo", Input).value.strip().replace(",", "."))
        except ValueError:
            self.app.notify("Valores numéricos inválidos!", severity="error")
            return
        alvo = self.query_one("#cx-alvo", Input).value.strip() or None

        if self.caixinha_id:
            core_engine.editar_caixinha(self.caixinha_id, nome, desc, meta, aporte, saldo, alvo)
            self.app.notify("✔ Caixinha atualizada com sucesso!", severity="information")
        else:
            core_engine.criar_caixinha(nome, desc, meta, aporte, saldo, alvo)
            self.app.notify("✔ Nova Caixinha criada com sucesso!", severity="information")
        self.dismiss(True)

# ==============================================================================
# MODAL: AJUSTAR APORTE DE MÊS ESPECÍFICO (MODULARIDADE / PAUSA)
# ==============================================================================
class AjustarAporteMesModal(ModalScreen):
    def __init__(self, caixinha_id: int = 1, mes_ref: str = None):
        super().__init__()
        self.caixinha_id = caixinha_id
        self.mes_ref = mes_ref or str(date.today())[:7]

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("⏸️ AJUSTAR APORTE DE MÊS ESPECÍFICO", classes="modal-title")
            
            conn = core_engine.get_connection()
            cx = conn.execute("SELECT nome, aporte_mensal FROM caixinhas WHERE id = ?", (self.caixinha_id,)).fetchone()
            conn.close()
            cx_nome = cx['nome'] if cx else "Caixinha"
            
            val_atual = core_engine.obter_aporte_planejado(self.mes_ref, self.caixinha_id)

            yield Label(f"Caixinha: [bold cyan]{cx_nome}[/bold cyan]")
            yield Label("Mês de Referência [AAAA-MM]:")
            yield Input(value=self.mes_ref, placeholder="2026-10", id="aj-mes")

            yield Label("Aporte Planejado para este Mês (R$) — Digite 0.00 para pausar:")
            yield Input(value=f"{val_atual:.2f}", placeholder="0.00 ou 1000.00", id="aj-valor")

            yield Label("Motivo da Alteração:")
            yield Input(placeholder="Ex: Revisão CG 160 / Sem margem neste mês", id="aj-motivo")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-aj-cancel", classes="-danger")
                yield Button("Confirmar Ajuste", id="btn-aj-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-aj-cancel":
            self.dismiss(False)
            return

        mes_ref = self.query_one("#aj-mes", Input).value.strip()
        motivo = self.query_one("#aj-motivo", Input).value.strip()
        try:
            val = float(self.query_one("#aj-valor", Input).value.strip().replace(",", "."))
            core_engine.definir_aporte_planejado(mes_ref, self.caixinha_id, val, motivo)
            self.app.notify(f"✔ Aporte de {mes_ref} definido como R$ {val:,.2f}!", severity="information")
            self.dismiss(True)
        except ValueError:
            self.app.notify("Valor inválido!", severity="error")

# ==============================================================================
# MODAL: APORTE IMEDIATO NA CAIXINHA
# ==============================================================================
class AporteManualModal(ModalScreen):
    def __init__(self, caixinha_id: int = 1):
        super().__init__()
        self.caixinha_id = caixinha_id

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            yield Label("💰 APORTE IMEDIATO NA CAIXINHA", classes="modal-title")
            
            conn = core_engine.get_connection()
            cx = conn.execute("SELECT nome FROM caixinhas WHERE id = ?", (self.caixinha_id,)).fetchone()
            contas = conn.execute("SELECT id, nome, saldo FROM contas ORDER BY id").fetchall()
            conn.close()
            
            cx_nome = cx['nome'] if cx else "Caixinha"
            conta_opts = [(f"🏦 {r['nome']} (Saldo: R$ {r['saldo']:,.2f})", str(r['id'])) for r in contas] or [("Nubank", "1")]

            yield Label(f"Caixinha de Destino: [bold cyan]{cx_nome}[/bold cyan]")
            yield Label("Conta para debitar o valor:")
            yield Select(conta_opts, value=conta_opts[0][1], id="ap-conta")

            yield Label("Valor do Aporte em R$:")
            yield Input(value="1000.00", placeholder="1000.00", id="ap-val")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-ap-cancel", classes="-danger")
                yield Button("Confirmar Aporte", id="btn-ap-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-ap-cancel":
            self.dismiss(False)
            return

        conta_id = int(self.query_one("#ap-conta", Select).value)
        try:
            val = float(self.query_one("#ap-val", Input).value.strip().replace(",", "."))
            res, msg = core_engine.realizar_aporte_caixinha(self.caixinha_id, val, conta_id)
            if res:
                self.app.notify(f"✔ Aporte de R$ {val:,.2f} realizado com sucesso!", severity="information")
                self.dismiss(True)
            else:
                self.app.notify(f"Aviso: {msg}", severity="warning")
        except ValueError:
            self.app.notify("Valor inválido!", severity="error")

# ==============================================================================
# MODAL: CRUD RECORRÊNCIAS & FIXOS (CRIAR / EDITAR)
# ==============================================================================
class AddEditRecorrenciaModal(ModalScreen):
    def __init__(self, rec_id: int = None):
        super().__init__()
        self.rec_id = rec_id

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            title = "➕ NOVA RECORRÊNCIA / CUSTO FIXO" if not self.rec_id else "✏️ EDITAR RECORRÊNCIA"
            yield Label(title, classes="modal-title")
            
            desc_val, val_val, tipo_val, cat_val, dia_val = "", "200.00", "despesa", "Provisão Casa (Carnes)", "10"
            if self.rec_id:
                conn = core_engine.get_connection()
                r = conn.execute("SELECT * FROM recorrencias WHERE id = ?", (self.rec_id,)).fetchone()
                conn.close()
                if r:
                    desc_val = r['descricao']
                    val_val = f"{r['valor']:.2f}"
                    tipo_val = r['tipo']
                    cat_val = r['categoria'] or "Provisão Casa (Carnes)"
                    dia_val = str(r['dia_vencimento'])

            yield Label("Descrição da Conta / Receita:")
            yield Input(value=desc_val, placeholder="Ex: Provisão Casa / Psiquiatria / Salário", id="rec-desc")

            yield Label("Valor em R$:")
            yield Input(value=val_val, placeholder="200.00", id="rec-val")

            yield Label("Tipo:")
            yield Select([("Despesa", "despesa"), ("Receita", "receita")], value=tipo_val, id="rec-tipo")

            yield Label("Dia de Vencimento (1 a 31):")
            yield Input(value=dia_val, placeholder="10", id="rec-dia")

            yield Label("Categoria:")
            yield Select([
                ("Provisão Casa (Carnes)", "Provisão Casa (Carnes)"),
                ("Saúde Mental / Psiquiatria", "Saúde Mental / Psiquiatria"),
                ("Moto (Gasolina / Óleo / IPVA)", "Moto (Gasolina / Óleo / IPVA)"),
                ("Barbearia & Cuidados", "Barbearia & Cuidados"),
                ("Estética / Minoxidil / Roupas", "Estética / Minoxidil / Roupas"),
                ("Alforria / Investimento", "Alforria / Investimento"),
                ("Salário Comissionado AGR", "Salário Comissionado AGR"),
                ("Outros / Manobra", "Outros / Manobra"),
            ], value=cat_val, id="rec-cat")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-rec-cancel", classes="-danger")
                yield Button("Salvar Recorrência", id="btn-rec-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-rec-cancel":
            self.dismiss(False)
            return

        desc = self.query_one("#rec-desc", Input).value.strip()
        if not desc:
            self.app.notify("Descrição é obrigatória!", severity="error")
            return
        tipo = self.query_one("#rec-tipo", Select).value
        cat = self.query_one("#rec-cat", Select).value
        try:
            val = float(self.query_one("#rec-val", Input).value.strip().replace(",", "."))
            dia = int(self.query_one("#rec-dia", Input).value.strip())
        except ValueError:
            self.app.notify("Valores numéricos inválidos!", severity="error")
            return

        if self.rec_id:
            core_engine.editar_recorrencia(self.rec_id, desc, val, tipo, cat, dia, 1)
            self.app.notify("✔ Recorrência atualizada com sucesso!", severity="information")
        else:
            core_engine.criar_recorrencia(desc, val, tipo, cat, dia)
            self.app.notify("✔ Nova Recorrência criada com sucesso!", severity="information")
        self.dismiss(True)

# ==============================================================================
# MODAL: CRUD WISHLIST (CRIAR / EDITAR ITEM PLANEJADO)
# ==============================================================================
class AddEditWishlistModal(ModalScreen):
    def __init__(self, item_id: int = None):
        super().__init__()
        self.item_id = item_id

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            title = "➕ NOVO PLANO DE COMPRA (WISHLIST)" if not self.item_id else "✏️ EDITAR PLANO DE COMPRA"
            yield Label(title, classes="modal-title")

            item_val, cat_val, val_val, parc_val, prio_val, cond_val, obs_val = "", "Estudos / Concursos", "300.00", "4", "Alta", "Após quitar faturas", ""
            if self.item_id:
                conn = core_engine.get_connection()
                w = conn.execute("SELECT * FROM wishlist WHERE id = ?", (self.item_id,)).fetchone()
                conn.close()
                if w:
                    item_val = w['item']
                    cat_val = w['categoria']
                    val_val = f"{w['valor_estimado']:.2f}"
                    parc_val = str(w['parcelas_sugeridas'])
                    prio_val = w['prioridade']
                    cond_val = w['condicao_compra'] or ""
                    obs_val = w['link_ou_obs'] or ""

            yield Label("Nome do Item / Objetivo:")
            yield Input(value=item_val, placeholder="Ex: Fone QCY H3 Pro / Garrafa Stanley", id="w-item")

            yield Label("Categoria:")
            yield Select([
                ("Estudos / Concursos", "Estudos / Concursos"),
                ("Tecnologia & Periféricos", "Tecnologia & Periféricos"),
                ("Saúde & Hidratação", "Saúde & Hidratação"),
                ("Moto (Manutenção / Peças)", "Moto (Manutenção / Peças)"),
                ("Estética & Presença Masculina", "Estética & Presença Masculina"),
                ("Outros / Casa", "Outros / Casa"),
            ], value=cat_val, id="w-cat")

            yield Label("Valor Estimado em R$:")
            yield Input(value=val_val, placeholder="365.00", id="w-val")

            yield Label("Parcelas Sugeridas:")
            yield Select([(f"{i}x sem juros", str(i)) for i in range(1, 13)], value=parc_val, id="w-parc")

            yield Label("Prioridade de Guerra:")
            yield Select([
                ("Alta (Impacto imediato em estudos/renda)", "Alta"),
                ("Média (Conforto / Produtividade)", "Média"),
                ("Baixa (Desejo futuro)", "Baixa"),
                ("Estratégica (Alforria)", "Estratégica")
            ], value=prio_val, id="w-prio")

            yield Label("Gatilho / Condição para Compra:")
            yield Input(value=cond_val, placeholder="Ex: Após quitar faturas / Após 13º salário", id="w-cond")

            yield Label("Observação / Justificativa:")
            yield Input(value=obs_val, placeholder="Ex: Cancelamento de ruído essencial para estudar", id="w-obs")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-w-cancel", classes="-danger")
                yield Button("Salvar no Radar", id="btn-w-save", classes="-primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-w-cancel":
            self.dismiss(False)
            return

        item = self.query_one("#w-item", Input).value.strip()
        if not item:
            self.app.notify("Nome do item é obrigatório!", severity="error")
            return
        cat = self.query_one("#w-cat", Select).value
        prio = self.query_one("#w-prio", Select).value
        parcs = int(self.query_one("#w-parc", Select).value)
        cond = self.query_one("#w-cond", Input).value.strip()
        obs = self.query_one("#w-obs", Input).value.strip()
        try:
            val = float(self.query_one("#w-val", Input).value.strip().replace(",", "."))
        except ValueError:
            self.app.notify("Valor estimado inválido!", severity="error")
            return

        if self.item_id:
            core_engine.editar_item_wishlist(self.item_id, item, cat, val, parcs, prio, cond, status="planejado", link_ou_obs=obs)
            self.app.notify("✔ Item da Wishlist atualizado!", severity="information")
        else:
            core_engine.criar_item_wishlist(item, cat, val, parcs, prio, cond, obs)
            self.app.notify("✔ Item cadastrado no radar de compras futuras!", severity="information")
        self.dismiss(True)

# ==============================================================================
# MODAL: EFETIVAR COMPRA DA WISHLIST (SEM ATRITO)
# ==============================================================================
class EfetivarWishlistModal(ModalScreen):
    def __init__(self, item_id: int):
        super().__init__()
        self.item_id = item_id
        conn = core_engine.get_connection()
        self.w = conn.execute("SELECT * FROM wishlist WHERE id = ?", (item_id,)).fetchone()
        self.cartoes = conn.execute("SELECT id, nome, limite FROM cartoes ORDER BY id").fetchall()
        self.contas = conn.execute("SELECT id, nome, saldo FROM contas ORDER BY id").fetchall()
        conn.close()

    def compose(self) -> ComposeResult:
        with Vertical(classes="modal-dialog"):
            item_nome = self.w['item'] if self.w else "Item"
            val = self.w['valor_estimado'] if self.w else 0.0
            parcs = self.w['parcelas_sugeridas'] if self.w else 1
            yield Label(f"🚀 EFETIVAR COMPRA: {item_nome}", classes="modal-title")
            yield Static(f"Valor: [bold green]R$ {val:,.2f}[/bold green] | Parcelas Sugeridas: [bold yellow]{parcs}x[/bold yellow]\n")

            yield Label("Forma de Pagamento:")
            opts = [(f"💳 Cartão {c['nome']}", f"cartao-{c['id']}") for c in self.cartoes] + \
                   [(f"🏦 Conta {ct['nome']} (À Vista)", f"conta-{ct['id']}") for ct in self.contas]
            yield Select(opts, value=opts[0][1], id="ef-meio")

            yield Label("Número de Parcelas:")
            yield Select([(f"{i}x (R$ {val/i:.2f}/mês)", str(i)) for i in range(1, 13)], value=str(parcs), id="ef-parc")

            yield Label("Data da Compra (AAAA-MM-DD):")
            yield Input(value=str(date.today()), id="ef-data")

            with Horizontal(classes="modal-btn-row"):
                yield Button("Cancelar", id="btn-ef-cancel", classes="-danger")
                yield Button("Confirmar Compra Real", id="btn-ef-confirm", classes="-success")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "btn-ef-cancel":
            self.dismiss(False)
            return

        meio = self.query_one("#ef-meio", Select).value
        parcs = int(self.query_one("#ef-parc", Select).value)
        dt_compra = self.query_one("#ef-data", Input).value.strip()

        cid = int(meio.split("-")[1])
        cartao_id = cid if meio.startswith("cartao") else None
        conta_id = cid if meio.startswith("conta") else None

        try:
            core_engine.efetivar_compra_wishlist(self.item_id, cartao_id=cartao_id, conta_id=conta_id, data_compra=dt_compra, parcelas=parcs)
            self.app.notify(f"🚀 Compra '{self.w['item']}' efetivada com sucesso no banco!", severity="information")
            self.dismiss(True)
        except Exception as e:
            self.app.notify(f"Erro ao efetivar compra: {e}", severity="error")

# ==============================================================================
# APLICAÇÃO PRINCIPAL: APEX FINANCE TUI
# ==============================================================================
class ApexFinanceApp(App):
    CSS = TUI_CSS
    TITLE = "🏛️ APEX FINANCE — COCKPIT SOBERANO"
    
    BINDINGS = [
        Binding("q", "quit", "Sair", show=True),
        Binding("1", "tab_dash", "Dashboard", show=True),
        Binding("2", "tab_tx", "Transações", show=True),
        Binding("3", "tab_sim", "Simulador", show=True),
        Binding("4", "tab_cx", "Caixinhas", show=True),
        Binding("5", "tab_card", "Cartões", show=True),
        Binding("6", "tab_rec", "Recorrências", show=True),
        Binding("7", "tab_wish", "Wishlist", show=True),
        Binding("n", "new_tx", "Nova Transação", show=True),
        Binding("d", "delete_tx", "Excluir [d]", show=True),
        Binding("s", "open_sim", "Simulador", show=False),
        Binding("p", "pay_invoice", "Pagar Fatura", show=True),
        Binding("b", "backup", "Backup", show=True),
        Binding("r", "refresh_data", "Atualizar", show=True),
        Binding("e", "export_excel", "Excel", show=True),
        Binding("x", "export_ia", "Contexto IA", show=True),
        Binding("h", "prev_month", "Mês Anterior", show=False),
        Binding("l", "next_month", "Próximo Mês", show=False),
    ]

    current_month_offset = 0
    filter_month_only = True

    @staticmethod
    def get_month_options() -> list:
        nomes = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
        opts = []
        a, m = 2026, 9
        hoje_str = str(date.today())[:7]
        while True:
            mes_str = f"{a:04d}-{m:02d}"
            tag = " (Atual)" if mes_str == hoje_str else ""
            opts.append((f"{mes_str} • {nomes[m-1]}/{a}{tag}", mes_str))
            if a == 2028 and m == 8:
                break
            m += 1
            if m > 12:
                m = 1
                a += 1
        return opts

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        
        # 1. TOP SURVIVAL HUD
        with Grid(id="hud-container"):
            with Vertical(classes="hud-card"):
                yield Label("💰 DEPOIS DAS CONTAS", classes="hud-label")
                yield Label("R$ 0,00", id="hud-depois-contas", classes="hud-val-green")
                
            with Vertical(classes="hud-card"):
                yield Label("🏦 DISPONÍVEL BANCOS", classes="hud-label")
                yield Label("R$ 0,00", id="hud-bancos", classes="hud-val-blue")
                
            with Vertical(classes="hud-card"):
                yield Label("💳 FATURAS DO MÊS", classes="hud-label")
                yield Label("R$ 0,00", id="hud-dividas", classes="hud-val-yellow")
                
            with Vertical(classes="hud-card"):
                yield Label("🏰 RESERVA ALFORRIA", classes="hud-label")
                yield Label("R$ 0,00", id="hud-alforria-top", classes="hud-val-mauve")
                
            with Vertical(classes="hud-card"):
                yield Label("🛡️ LIQUIDEZ LÍQUIDA", classes="hud-label")
                yield Label("R$ 0,00", id="hud-liquidez", classes="hud-val-green")

        # 2. MONTH NAVIGATOR
        with Horizontal(id="time-navigator"):
            yield Button("◀ [h]", id="btn-prev-month")
            yield Select(self.get_month_options(), value="2026-09", id="select-month-nav", allow_blank=False)
            yield Label("⚡ ATIVO", id="month-status-badge", classes="hud-val-green")
            yield Button("[l] ▶", id="btn-next-month")
            yield Button("🔒 Selar", id="btn-seal-month")
            yield Button("📜 Snapshots", id="btn-view-snapshots")
            yield Button("💾 Backup [b]", id="btn-backup-tui")
            yield Button("⚖️ Ajustar Fat", id="btn-open-adj-fat")
            yield Button("🏦 Reconciliar", id="btn-open-rec")
            yield Button("🧠 Contexto IA [x]", id="btn-export-ia", classes="-success")
            yield Button("⚡ Ritual", id="btn-open-ritual")

        # 3. TABBED CONTENT
        with TabbedContent(id="main-tabs"):
            # ABA 1: DASHBOARD
            with TabPane("📊 'Depois das Contas' & Fluxo do Mês", id="tab-dash"):
                with Horizontal():
                    with Vertical(classes="section-box", id="dash-summary-box"):
                        yield Label("🏛️ Resumo Consolidado do Mês", classes="section-title")
                        yield Static(id="dash-consolidated-text")
                        yield Rule()
                        yield Label("🏦 Contas Correntes & Carteira", classes="section-title")
                        yield Static(id="dash-accounts-text")
                    
                    with VerticalScroll(classes="section-box", id="dash-depois-contas-box"):
                        yield Label("💰 Extrato Cirúrgico: 'Depois das Contas' deste Mês", classes="section-title")
                        yield Static(id="dash-depois-contas-text")

            # ABA 2: TRANSAÇÕES
            with TabPane("📝 Transações & Faturas", id="tab-tx"):
                with Horizontal():
                    yield Button("➕ Nova [n]", id="btn-new-tx-tab", classes="-primary")
                    yield Button("✏️ Editar [Enter]", id="btn-edit-tx-tab")
                    yield Button("🗑️ Excluir [d]", id="btn-del-tx-tab", classes="-danger")
                    yield Button("📅 Deste Mês", id="btn-toggle-month-tx")
                    yield Button("💳 Pagar Fatura [p]", id="btn-pay-tab")
                    yield Button("📑 Exportar Excel [e]", id="btn-export-tab")
                yield DataTable(id="table-transactions")

            # ABA 3: SIMULADOR DE IMPACTO
            with TabPane("🔮 Simulador de Impacto (Sandbox)", id="tab-sim"):
                with Vertical(classes="section-box", id="sim-form"):
                    yield Label("🔮 SIMULADOR DA MÁQUINA DO TEMPO (SANDBOX PREDITIVO)", classes="section-title")
                    yield Static("Simule compras à vista ou parceladas antes de gastar e veja o impacto instantâneo no caixa:")
                    
                    with Horizontal(classes="sim-input-row"):
                        yield Label("Descrição da Compra:", classes="sim-label")
                        yield Input(value="Peça CG 160 / Revisão", id="sim-desc")
                        
                    with Horizontal(classes="sim-input-row"):
                        yield Label("Valor Total em R$:", classes="sim-label")
                        yield Input(value="600.00", id="sim-val")
                        
                    with Horizontal(classes="sim-input-row"):
                        yield Label("Parcelas:", classes="sim-label")
                        yield Select([(f"{i}x (R$ {600/i:.2f}/mês)", str(i)) for i in range(1, 13)], value="6", id="sim-parc")

                    with Horizontal(classes="sim-input-row"):
                        yield Label("Meio:", classes="sim-label")
                        yield Select([
                            ("Cartão Caixa (Elo/Visa)", "cartao-1"),
                            ("Cartão Nubank (Gold)", "cartao-2"),
                            ("Nubank Conta (À Vista / Débito)", "conta-1")
                        ], value="cartao-1", id="sim-meio")
                        
                    with Horizontal():
                        yield Button("🔄 Simular Impacto Agora", id="btn-run-sim", classes="-primary")
                        yield Button("🚀 Efetivar Compra no Banco", id="btn-commit-sim")
                        
                    yield Static("VEREDICTO: Pronto para simular.", id="sim-verdict", classes="verdict-box")
                    
                with Vertical(classes="section-box"):
                    yield Label("📊 Auditoria Mês a Mês: Baseline Normal vs. Compra Simulada", classes="section-title")
                    yield DataTable(id="table-sim-impact")

            # ABA 4: CAIXINHAS & METAS
            with TabPane("🏰 Caixinhas & Alforria (115% CDI)", id="tab-cx"):
                with VerticalScroll():
                    yield Label("🏰 Gestão Soberana de Caixinhas & Focos de Alforria", classes="section-title")
                    with Horizontal():
                        yield Button("➕ Nova Caixinha", id="btn-add-cx", classes="-primary")
                        yield Button("✏️ Editar Caixinha [Enter]", id="btn-edit-cx-sel")
                        yield Button("🗑️ Excluir Caixinha", id="btn-del-cx-sel", classes="-danger")
                        yield Button("💰 Aporte Imediato", id="btn-aporte-cx-sel", classes="-success")
                        yield Button("⏸️ Ajustar/Pausar Mês", id="btn-ajustar-aporte-cx-sel")
                    
                    yield DataTable(id="table-caixinhas-crud")

                    yield Rule()
                    yield Label("🎯 Progresso Visual das Metas Principais", classes="section-title")
                    with Vertical(classes="cx-card", id="cx-1-box"):
                        yield Label("🏰 Alforria 2028 (O Meu Canto) — Meta: R$ 27.000,00 (115% CDI)", classes="hud-label")
                        yield ProgressBar(total=27000.0, show_eta=False, id="pb-alforria")
                        yield Static("Acumulado: R$ 1.000,00 | Aporte: R$ 1.000,00/mês | Alvo: Agosto/2028", id="lbl-alforria")
                        
                    with Vertical(classes="cx-card", id="cx-2-box"):
                        yield Label("🏍️ Máquina Zerada (CG 160) — Meta: R$ 1.500,00 (IPVA + Motul 5100 + Estética)", classes="hud-label")
                        yield ProgressBar(total=1500.0, show_eta=False, id="pb-moto")
                        yield Static("Acumulado: R$ 200,00 | Aporte: R$ 100,00/mês | Alvo: Dezembro/2027", id="lbl-moto")
                        
                    with Vertical(classes="cx-card", id="cx-3-box"):
                        yield Label("🧴 Presença & Imagem Masculina — Meta: R$ 1.200,00 (Minoxidil + Cuidados)", classes="hud-label")
                        yield ProgressBar(total=1200.0, show_eta=False, id="pb-presenca")
                        yield Static("Acumulado: R$ 150,00 | Aporte: R$ 100,00/mês | Alvo: Junho/2027", id="lbl-presenca")
                        
                    yield Rule()
                    yield Label("📈 Tabela de Projeção da Alforria (Mês a Mês com 115% CDI e Pausas)", classes="section-title")
                    yield DataTable(id="table-proj-alforria")

            # ABA 5: CARTÕES & FATURAS
            with TabPane("💳 Cartões & Faturas", id="tab-cards"):
                with Horizontal():
                    yield Button("➕ Novo Cartão", id="btn-add-card", classes="-primary")
                    yield Button("✏️ Editar Cartão [Enter]", id="btn-edit-card-sel")
                    yield Button("🗑️ Excluir Cartão", id="btn-del-card-sel", classes="-danger")
                    yield Button("💳 Pagar Fatura [p]", id="btn-pay-card-sel")
                    yield Button("⚖️ Reajustar Fatura", id="btn-adj-card-sel")
                yield DataTable(id="table-cartoes")

            # ABA 6: RECORRÊNCIAS & FIXOS
            with TabPane("🔁 Recorrências & Fixos", id="tab-rec"):
                with VerticalScroll():
                    yield Label("🔁 Orçamento Base Mensal (R$ 2.234 Salário)", classes="section-title")
                    with Horizontal():
                        yield Button("➕ Nova Recorrência", id="btn-add-rec", classes="-primary")
                        yield Button("✏️ Editar Recorrência [Enter]", id="btn-edit-rec-sel")
                        yield Button("🗑️ Excluir Recorrência", id="btn-del-rec-sel", classes="-danger")
                        yield Button("⚡ Pausar / Reativar", id="btn-toggle-rec-sel")
                    yield DataTable(id="table-recorrencias")

            # ABA 7: WISHLIST & COMPRAS FUTURAS
            with TabPane("🎯 Wishlist & Compras Futuras", id="tab-wish"):
                with VerticalScroll():
                    yield Label("🎯 Radar de Compras Conscientes (Planejar Agora, Executar Sem Atrito)", classes="section-title")
                    with Horizontal():
                        yield Button("➕ Novo Item Wishlist", id="btn-add-wish", classes="-primary")
                        yield Button("✏️ Editar Item [Enter]", id="btn-edit-wish-sel")
                        yield Button("🗑️ Excluir Item", id="btn-del-wish-sel", classes="-danger")
                        yield Button("🚀 Efetivar Compra Real", id="btn-efetivar-wish-sel", classes="-success")
                    yield DataTable(id="table-wishlist")

        yield Footer()

    def on_mount(self) -> None:
        core_engine.init_database()
        self.init_data_tables()
        self.refresh_all_data()
        self.run_simulation()

    def init_data_tables(self) -> None:
        # Transações
        table_tx = self.query_one("#table-transactions", DataTable)
        table_tx.cursor_type = "row"
        table_tx.zebra_stripes = True
        table_tx.add_columns("ID", "Data", "Descrição", "Valor", "Tipo", "Categoria", "Origem/Fatura", "Parcela")
        
        # Simulador Impacto Tabular
        table_sim = self.query_one("#table-sim-impact", DataTable)
        table_sim.cursor_type = "row"
        table_sim.zebra_stripes = True
        table_sim.add_columns("Mês", "Renda Prev.", "Sobra Atual", "Parcela Simulada", "Nova Sobra Livre", "Impacto %", "Veredicto Mensal")

        # Caixinhas CRUD Table
        table_cx = self.query_one("#table-caixinhas-crud", DataTable)
        table_cx.cursor_type = "row"
        table_cx.zebra_stripes = True
        table_cx.add_columns("ID", "Caixinha / Meta", "Saldo Atual", "Meta Total", "Progresso", "Aporte Padrão", "Aporte Mês Sel.", "Data Alvo")

        # Projeção Alforria
        table_proj = self.query_one("#table-proj-alforria", DataTable)
        table_proj.cursor_type = "row"
        table_proj.zebra_stripes = True
        table_proj.add_columns("Mês", "Referência", "Aporte", "Rendimento CDI", "Bônus 13º", "Saldo Final")

        # Recorrências
        table_rec = self.query_one("#table-recorrencias", DataTable)
        table_rec.cursor_type = "row"
        table_rec.zebra_stripes = True
        table_rec.add_columns("ID", "Descrição", "Valor", "Tipo", "Categoria", "Dia Venc.", "Status")

        # Cartões de Crédito
        table_cards = self.query_one("#table-cartoes", DataTable)
        table_cards.cursor_type = "row"
        table_cards.zebra_stripes = True
        table_cards.add_columns("ID", "Cartão", "Instituição", "Limite", "Comprometido", "Disponível", "Corte", "Vencimento", "Fatura Mês", "Status Fatura")

        # Wishlist / Compras Futuras Table
        table_wish = self.query_one("#table-wishlist", DataTable)
        table_wish.cursor_type = "row"
        table_wish.zebra_stripes = True
        table_wish.add_columns("ID", "Item / Desejo", "Categoria", "Valor Estimado", "Parcelas", "Prioridade", "Condição / Gatilho", "Status", "Observações")

    def get_selected_month_str(self) -> str:
        hoje = date.today()
        m = hoje.month + self.current_month_offset
        a = hoje.year + (m - 1) // 12
        m = ((m - 1) % 12) + 1
        return f"{a:04d}-{m:02d}"

    def refresh_all_data(self) -> None:
        mes_ref = self.get_selected_month_str()
        
        # Atualiza badge de status do mês
        snap = core_engine.obter_snapshot_mensal(mes_ref)
        badge = self.query_one("#month-status-badge", Label)
        hoje_str = str(date.today())[:7]
        if snap:
            badge.update(f"🔒 {mes_ref} (SELADO)")
            badge.classes = "hud-val-mauve"
        elif mes_ref < hoje_str:
            badge.update(f"⏳ {mes_ref} (PASSADO)")
            badge.classes = "hud-val-yellow"
        elif mes_ref == hoje_str:
            badge.update(f"⚡ {mes_ref} (MÊS ATUAL)")
            badge.classes = "hud-val-green"
        else:
            badge.update(f"🔮 {mes_ref} (PROJEÇÃO)")
            badge.classes = "hud-val-blue"

        # Sincroniza seletor de mês na barra superior
        try:
            sel_nav = self.query_one("#select-month-nav", Select)
            if sel_nav.value != mes_ref:
                sel_nav.value = mes_ref
        except Exception:
            pass

        btn_filter = self.query_one("#btn-toggle-month-tx", Button)
        if self.filter_month_only:
            btn_filter.label = f"📅 Mês ({mes_ref})"
        else:
            btn_filter.label = "🌐 Todas Transações"

        # 1. Survival HUD
        hud = core_engine.get_survival_hud_metrics(mes_ref)

        # 2. Resumo Consolidado, Contas & Depois das Contas
        conn = core_engine.get_connection()
        c = conn.cursor()
        
        c.execute("SELECT nome, tipo, instituicao, saldo FROM contas")
        contas_rows = c.fetchall()
        acc_text = ""
        for r in contas_rows:
            acc_text += f"• [b]{r['nome']}[/b] ({r['instituicao']}): [green]R$ {r['saldo']:,.2f}[/green]\n"
        self.query_one("#dash-accounts-text", Static).update(acc_text)
        
        # Radiografia "Depois das Contas"
        ano_sel, m_sel = map(int, mes_ref.split('-'))
        renda = 2234.0
        desc_renda = "Salário AGR"
        if False and m_sel in [11, 12]:
            renda += 1100.0
            desc_renda = "Salário AGR + 13º Salário"

        # Faturas do mês selecionado
        c.execute("""
            SELECT k.nome, k.dia_vencimento, SUM(t.valor)
            FROM transacoes t
            JOIN cartoes k ON t.cartao_id = k.id
            WHERE t.mes_fatura = ?
            GROUP BY k.nome, k.dia_vencimento
        """, (mes_ref,))
        fats = c.fetchall()
        total_fats = sum(f[2] for f in fats) if fats else 0.0

        # Recorrências fixas (sem Alforria)
        c.execute("SELECT descricao, valor, dia_vencimento FROM recorrencias WHERE ativo = 1 AND tipo = 'despesa' AND descricao NOT LIKE '%Alforria%' ORDER BY dia_vencimento")
        recs = c.fetchall()
        total_recs = sum(r[1] for r in recs)

        # Aporte da Alforria (Lê override específico se configurado, ex: Outubro R$ 0)
        aporte_alforria = core_engine.obter_aporte_planejado(mes_ref, 1)
        total_saidas = total_fats + total_recs + aporte_alforria
        sobra_depois_contas = renda - total_saidas

        # Acúmulo da Alforria até o mês selecionado
        saldo_alf = 1000.0
        taxa = 0.0095
        a_cur, m_cur = 2026, 9
        while True:
            k_mes = f'{a_cur:04d}-{m_cur:02d}'
            if k_mes == mes_ref:
                break
            ap_mes = core_engine.obter_aporte_planejado(k_mes, 1)
            saldo_alf = saldo_alf * (1 + taxa) + ap_mes
            if m_cur in [11, 12]:
                saldo_alf += 600.0
            m_cur += 1
            if m_cur > 12:
                m_cur = 1
                a_cur += 1

        # Atualiza os 5 Cards do HUD no Topo
        lbl_depois = self.query_one("#hud-depois-contas", Label)
        lbl_depois.update(f"R$ {sobra_depois_contas:,.2f}")
        lbl_depois.set_class(sobra_depois_contas >= 0, "hud-val-green")
        lbl_depois.set_class(sobra_depois_contas < 0, "hud-val-red")

        self.query_one("#hud-bancos", Label).update(f"R$ {hud['saldo_bancario']:,.2f}")
        self.query_one("#hud-dividas", Label).update(f"R$ {total_fats:,.2f}")
        self.query_one("#hud-alforria-top", Label).update(f"R$ {saldo_alf:,.2f}")
        
        lbl_liq = self.query_one("#hud-liquidez", Label)
        lbl_liq.update(f"R$ {hud['liquidez_liquida']:,.2f}")
        lbl_liq.set_class(hud['liquidez_liquida'] >= 0, "hud-val-green")
        lbl_liq.set_class(hud['liquidez_liquida'] < 0, "hud-val-red")

        # Texto do Resumo Consolidado (lado esquerdo)
        resumo_str = (
            f"[italic yellow]\"Quem é fiel no pouco, sobre o muito será colocado.\" (Lc 16:10)[/italic yellow]\n\n"
            f"• [b]Renda Prevista ({mes_ref}):[/b] [green]R$ {renda:,.2f}[/green]\n"
            f"• [b]Custos Fixos & Provisão:[/b] [red]R$ {total_recs:,.2f}[/red]\n"
            f"• [b]Faturas dos Cartões:[/b] [yellow]R$ {total_fats:,.2f}[/yellow]\n"
            f"• [b]Aporte Sagrado Alforria:[/b] [gold1]R$ {aporte_alforria:,.2f}[/gold1]\n"
            f"• [b]Dinheiro Livre ('Depois das Contas'):[/b] [{'green' if sobra_depois_contas>=0 else 'red'}]R$ {sobra_depois_contas:,.2f}[/]\n"
            f"• [b]Patrimônio Alforria Acumulado:[/b] [cyan]R$ {saldo_alf:,.2f}[/cyan]"
        )
        self.query_one("#dash-consolidated-text", Static).update(resumo_str)

        # Painel Detalhado Depois das Contas (lado direito)
        linhas = []
        linhas.append(f"[bold cyan]💰 EXTRATO CIRÚRGICO: 'DEPOIS DAS CONTAS' ({mes_ref})[/bold cyan]\n")
        linhas.append(f"[bold green]🟢 Renda Líquida Prevista:[/bold green]                  [bold green]R$ {renda:>9,.2f}[/bold green] [dim]({desc_renda})[/dim]")
        linhas.append(f"[dim]──────────────────────────────────────────────────────────────[/dim]")
        
        linhas.append(f"[bold yellow]💳 Faturas dos Cartões de Crédito:[/bold yellow]")
        if not fats:
            linhas.append(f"   • Faturas zeradas neste mês                  [dim]R$      0.00[/dim]")
        else:
            for f in fats:
                linhas.append(f"   • [yellow]{f[0]:28}[/yellow] (Vence {f[1]:02d}) -> [bold yellow]R$ {f[2]:>8,.2f}[/bold yellow]")

        linhas.append(f"\n[bold magenta]📦 Despesas Fixas & Provisão do Lar:[/bold magenta]")
        for r in recs:
            linhas.append(f"   • {r[0]:28} (Dia {r[2]:02d})       -> R$ {r[1]:>8,.2f}")

        linhas.append(f"\n[bold gold1]🟡 Aporte Sagrado Alforria (Dia 05):[/bold gold1]         [bold gold1]R$ {aporte_alforria:>9,.2f}[/bold gold1] [dim](CDB 115% CDI)[/dim]")
        linhas.append(f"[dim]──────────────────────────────────────────────────────────────[/dim]")
        linhas.append(f"[bold red]🔴 Total de Obrigações & Aportes:[/bold red]          [bold red]R$ {total_saidas:>9,.2f}[/bold red]")
        linhas.append(f"[dim]══════════════════════════════════════════════════════════════[/dim]")

        if sobra_depois_contas >= 150:
            tag_status = "[bold black on green] ✅ CONFORTÁVEL [/]"
            cor_sobra = "bold green"
        elif sobra_depois_contas >= 0:
            tag_status = "[bold black on yellow] ⚠️ APERTADO [/]"
            cor_sobra = "bold yellow"
        else:
            tag_status = "[bold white on red] 🚨 DÉFICIT DE CAIXA [/]"
            cor_sobra = "bold red"

        linhas.append(f"[{cor_sobra}]💸 SOBRA LIVRE ('DEPOIS DAS CONTAS'):       R$ {sobra_depois_contas:>9,.2f}[/]  {tag_status}")
        linhas.append(f"[dim]══════════════════════════════════════════════════════════════[/dim]\n")
        linhas.append(f"🏰 [bold cyan]Caixinha Alforria Acumulada até este Mês:[/bold cyan] [bold yellow]R$ {saldo_alf:>9,.2f}[/bold yellow] [dim](115% CDI)[/dim]")
        linhas.append(f"🎯 [dim]Meta: R$ 27.000 a R$ 30.000 | Progresso: {min(100, (saldo_alf/27000)*100):.1f}%[/dim]")

        self.query_one("#dash-depois-contas-text", Static).update("\n".join(linhas))

        # 3. Transações Table
        table_tx = self.query_one("#table-transactions", DataTable)
        table_tx.clear()
        if self.filter_month_only:
            tx_rows = core_engine.get_transacoes_do_mes(mes_ref)
        else:
            c.execute("""
                SELECT t.id, t.data, t.descricao, t.valor, t.tipo, t.categoria,
                       COALESCE(k.nome, c.nome, cx.nome, 'Geral') as origem,
                       t.parcela_atual, t.total_parcelas, t.mes_fatura
                FROM transacoes t
                LEFT JOIN cartoes k ON t.cartao_id = k.id
                LEFT JOIN contas c ON t.conta_id = c.id
                LEFT JOIN caixinhas cx ON t.caixinha_id = cx.id
                ORDER BY t.data DESC, t.id DESC LIMIT 60
            """)
            tx_rows = [dict(r) for r in c.fetchall()]

        for r in tx_rows:
            sinal = "+" if r['tipo'] == 'receita' else "-"
            cor_val = "green" if r['tipo'] == 'receita' else "red"
            val_fmt = f"[{cor_val}]{sinal} R$ {r['valor']:,.2f}[/]"
            parc_fmt = f"{r['parcela_atual']}/{r['total_parcelas']}" if r['total_parcelas'] > 1 else "-"
            origem_fat = f"{r['origem']} ({r['mes_fatura']})" if r['mes_fatura'] else r['origem']
            table_tx.add_row(
                str(r['id']), r['data'], r['descricao'], val_fmt,
                r['tipo'].title(), r['categoria'] or '-', origem_fat, parc_fmt
            )

        # 4. Caixinhas CRUD Table & Progress Bars
        table_cx = self.query_one("#table-caixinhas-crud", DataTable)
        table_cx.clear()
        c.execute("SELECT id, nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo FROM caixinhas ORDER BY id")
        all_cx = c.fetchall()
        for cx in all_cx:
            pct = (cx['saldo_atual'] / cx['meta_total'] * 100) if cx['meta_total'] > 0 else 0
            ap_mes_sel = core_engine.obter_aporte_planejado(mes_ref, cx['id'])
            tag_ap_mes = f"[bold green]R$ {ap_mes_sel:,.2f}[/]" if ap_mes_sel > 0 else "[bold red]PAUSADO (R$ 0)[/]"
            table_cx.add_row(
                str(cx['id']),
                cx['nome'],
                f"[bold cyan]R$ {cx['saldo_atual']:,.2f}[/]",
                f"R$ {cx['meta_total']:,.2f}",
                f"{pct:.1f}%",
                f"R$ {cx['aporte_mensal']:,.2f}",
                tag_ap_mes,
                str(cx['data_alvo']) if cx['data_alvo'] else "-"
            )

            if "Alforria" in cx['nome']:
                pb = self.query_one("#pb-alforria", ProgressBar)
                pb.progress = cx['saldo_atual']
                self.query_one("#lbl-alforria", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte Padrão: R$ {cx['aporte_mensal']:,.2f}/mês | Mês {mes_ref}: R$ {ap_mes_sel:,.2f}"
                )
            elif "CG 160" in cx['nome']:
                pb = self.query_one("#pb-moto", ProgressBar)
                pb.progress = cx['saldo_atual']
                self.query_one("#lbl-moto", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte Padrão: R$ {cx['aporte_mensal']:,.2f}/mês | Mês {mes_ref}: R$ {ap_mes_sel:,.2f}"
                )
            elif "Presença" in cx['nome']:
                pb = self.query_one("#pb-presenca", ProgressBar)
                pb.progress = cx['saldo_atual']
                self.query_one("#lbl-presenca", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte Padrão: R$ {cx['aporte_mensal']:,.2f}/mês | Mês {mes_ref}: R$ {ap_mes_sel:,.2f}"
                )

        # 5. Projeção Alforria Table
        table_proj = self.query_one("#table-proj-alforria", DataTable)
        table_proj.clear()
        proj_dados = core_engine.projetar_alforria(meses=22)
        for p in proj_dados:
            extra_str = f"R$ {p['extra']:,.2f}" if p['extra'] > 0 else "-"
            table_proj.add_row(
                f"Mês {p['mes_num']:02d}", p['mes_ano'], f"R$ {p['aporte']:,.2f}",
                f"[green]R$ {p['rendimento']:,.2f}[/green]", extra_str,
                f"[bold blue]R$ {p['saldo']:,.2f}[/bold blue]"
            )

        # 6. Recorrências Table
        table_rec = self.query_one("#table-recorrencias", DataTable)
        table_rec.clear()
        c.execute("SELECT id, descricao, valor, tipo, categoria, dia_vencimento, ativo FROM recorrencias ORDER BY id")
        for r in c.fetchall():
            cor = "green" if r['tipo'] == 'receita' else "red"
            val_fmt = f"[{cor}]R$ {r['valor']:,.2f}[/]"
            status_txt = "[green]ATIVO[/green]" if r['ativo'] == 1 else "[yellow]PAUSADO[/yellow]"
            table_rec.add_row(
                str(r['id']), r['descricao'], val_fmt, r['tipo'].upper(),
                r['categoria'] or '-', f"Todo dia {r['dia_vencimento']}", status_txt
            )

        # 7. Cartões de Crédito Table
        table_cards = self.query_one("#table-cartoes", DataTable)
        table_cards.clear()
        c.execute("SELECT id, nome, instituicao, limite, dia_fechamento, dia_vencimento FROM cartoes ORDER BY id")
        cartoes_rows = c.fetchall()
        for cr in cartoes_rows:
            cid = cr['id']
            limite = cr['limite']
            # Comprometido total em faturas abertas
            c.execute("""
                SELECT COALESCE(SUM(t.valor), 0.0)
                FROM transacoes t
                LEFT JOIN faturas f ON (f.cartao_id = t.cartao_id AND f.mes_referencia = t.mes_fatura)
                WHERE t.cartao_id = ? AND (f.status IS NULL OR f.status != 'paga')
            """, (cid,))
            total_devido = c.fetchone()[0] or 0.0
            disponivel = max(0.0, limite - total_devido)
            
            # Fatura específica do mês selecionado
            c.execute("""
                SELECT COALESCE(SUM(valor), 0.0) FROM transacoes
                WHERE cartao_id = ? AND mes_fatura = ?
            """, (cid, mes_ref))
            fat_mes_card = c.fetchone()[0] or 0.0
            
            c.execute("SELECT status FROM faturas WHERE cartao_id = ? AND mes_referencia = ?", (cid, mes_ref))
            status_fat_row = c.fetchone()
            status_fat = status_fat_row['status'] if status_fat_row else "aberta"
            
            status_fmt = "[green]PAGA[/green]" if status_fat == 'paga' else "[yellow]ABERTA[/yellow]"
            cor_disp = "green" if disponivel > (limite * 0.3) else "red"
            
            table_cards.add_row(
                str(cid),
                cr['nome'],
                cr['instituicao'],
                f"R$ {limite:,.2f}",
                f"[red]R$ {total_devido:,.2f}[/red]",
                f"[{cor_disp}]R$ {disponivel:,.2f}[/]",
                f"Dia {cr['dia_fechamento']}",
                f"Dia {cr['dia_vencimento']}",
                f"R$ {fat_mes_card:,.2f}",
                status_fmt
            )

        # 8. Wishlist / Compras Futuras Table
        table_wish = self.query_one("#table-wishlist", DataTable)
        table_wish.clear()
        c.execute("SELECT * FROM wishlist ORDER BY CASE status WHEN 'planejado' THEN 1 WHEN 'comprado' THEN 2 ELSE 3 END, id ASC")
        w_rows = c.fetchall()
        for w in w_rows:
            prio = w['prioridade']
            cor_prio = "red" if prio in ('Alta', 'Estratégica') else ("yellow" if prio == 'Média' else "blue")
            st = w['status']
            st_fmt = "[yellow]PLANEJADO[/yellow]" if st == 'planejado' else ("[green]COMPRADO[/green]" if st == 'comprado' else "[dim]CANCELADO[/dim]")
            parc_txt = f"{w['parcelas_sugeridas']}x sem juros" if w['parcelas_sugeridas'] > 1 else "À Vista"
            table_wish.add_row(
                str(w['id']),
                w['item'],
                w['categoria'],
                f"[bold green]R$ {w['valor_estimado']:,.2f}[/]",
                parc_txt,
                f"[{cor_prio}]{prio}[/]",
                w['condicao_compra'] or "-",
                st_fmt,
                w['link_ou_obs'] or "-"
            )

        conn.close()

    def on_select_changed(self, event: Select.Changed) -> None:
        if event.select.id == "select-month-nav" and event.value != Select.BLANK:
            mes_str = str(event.value)
            try:
                ano, mes = map(int, mes_str.split("-"))
                hoje = date.today()
                new_offset = (ano - hoje.year) * 12 + (mes - hoje.month)
                if new_offset != self.current_month_offset:
                    self.current_month_offset = new_offset
                    self.refresh_all_data()
            except Exception:
                pass

    def run_simulation(self) -> None:
        val_str = self.query_one("#sim-val", Input).value.strip().replace(",", ".")
        try:
            val = float(val_str)
        except ValueError:
            val = 600.0
            
        parc = int(self.query_one("#sim-parc", Select).value)
        meio = self.query_one("#sim-meio", Select).value
        tipo = "cartao" if meio.startswith("cartao") else "conta"
        
        res = core_engine.simular_impacto_compra(val, parcelas=parc, tipo=tipo)
        
        # Atualiza o banner do veredito
        lbl_v = self.query_one("#sim-verdict", Static)
        lbl_v.update(f"⚡ VEREDICTO: {res['veredicto']}")
        
        # Tabela comparativa de impacto financeiro
        table_sim = self.query_one("#table-sim-impact", DataTable)
        table_sim.clear()
        
        for b, s in zip(res['baseline'], res['simulado']):
            m_label = b['label']
            renda_prev = b['receitas']
            sobra_base = b['saldo_final']
            sobra_sim = s['saldo_final']
            parcela_mes = s.get('parcela', val / parc if parc > 0 else val)
            
            # Variação / impacto
            diff = sobra_base - sobra_sim
            pct_impacto = (diff / sobra_base * 100) if sobra_base > 0 else 0
            
            if sobra_sim >= 200:
                cor_sobra = "green"
                veredito = "[bold black on green] TRANQUILO [/]"
            elif sobra_sim >= 0:
                cor_sobra = "yellow"
                veredito = "[bold black on yellow] APERTADO [/]"
            else:
                cor_sobra = "red"
                veredito = "[bold white on red] DÉFICIT DE CAIXA [/]"

            table_sim.add_row(
                m_label,
                f"R$ {renda_prev:,.2f}",
                f"R$ {sobra_base:,.2f}",
                f"[yellow]R$ {parcela_mes:,.2f}[/yellow]",
                f"[{cor_sobra}]R$ {sobra_sim:,.2f}[/]",
                f"[dim]{pct_impacto:.1f}%[/dim]",
                veredito
            )

    # Eventos de botões e atalhos
    def on_button_pressed(self, event: Button.Pressed) -> None:
        bid = event.button.id
        if bid == "btn-prev-month":
            self.current_month_offset -= 1
            self.refresh_all_data()
        elif bid == "btn-next-month":
            self.current_month_offset += 1
            self.refresh_all_data()
        elif bid == "btn-toggle-month-tx":
            self.filter_month_only = not self.filter_month_only
            self.refresh_all_data()
        elif bid == "btn-seal-month":
            mes_ref = self.get_selected_month_str()
            core_engine.criar_snapshot_mensal(mes_ref)
            self.notify(f"🔒 Mês {mes_ref} selado e snapshot registrado com sucesso!", severity="information")
            self.refresh_all_data()
        elif bid == "btn-view-snapshots":
            self.app.push_screen(SnapshotsModal())
        elif bid == "btn-new-tx-tab":
            self.action_new_tx()
        elif bid == "btn-edit-tx-tab":
            self.action_edit_tx()
        elif bid == "btn-del-tx-tab":
            self.action_delete_tx()
        elif bid in ("btn-pay-tab", "btn-pay-caixa", "btn-pay-nubank"):
            self.action_pay_invoice()
        elif bid == "btn-add-card":
            self.push_screen(AddCardModal(), callback=self.on_modal_closed)
        elif bid == "btn-edit-card-sel":
            self.action_edit_card()
        elif bid == "btn-del-card-sel":
            self.action_delete_card()
        elif bid == "btn-pay-card-sel":
            self.action_pay_card_selected()
        elif bid == "btn-adj-card-sel":
            self.action_adj_card_selected()
        elif bid == "btn-backup-tui":
            self.action_backup()
        elif bid == "btn-export-tab":
            self.action_export_excel()
        elif bid == "btn-export-ia":
            self.action_export_ia()
        elif bid == "btn-open-ritual":
            self.app.push_screen(SundayRitualModal())
        elif bid == "btn-open-rec":
            self.app.push_screen(ReconcileModal(), callback=self.on_modal_closed)
        elif bid in ("btn-open-adj-fat", "btn-adj-caixa", "btn-adj-nubank"):
            self.app.push_screen(AdjustInvoiceModal(), callback=self.on_modal_closed)
        elif bid == "btn-add-cx":
            self.push_screen(AddEditCaixinhaModal(), callback=self.on_modal_closed)
        elif bid == "btn-edit-cx-sel":
            self.action_edit_cx()
        elif bid == "btn-del-cx-sel":
            self.action_delete_cx()
        elif bid == "btn-aporte-cx-sel":
            self.action_aporte_cx()
        elif bid == "btn-ajustar-aporte-cx-sel":
            self.action_ajustar_aporte_cx()
        elif bid == "btn-add-rec":
            self.push_screen(AddEditRecorrenciaModal(), callback=self.on_modal_closed)
        elif bid == "btn-edit-rec-sel":
            self.action_edit_rec()
        elif bid == "btn-del-rec-sel":
            self.action_delete_rec()
        elif bid == "btn-toggle-rec-sel":
            self.action_toggle_rec()
        elif bid == "btn-add-wish":
            self.push_screen(AddEditWishlistModal(), callback=self.on_modal_closed)
        elif bid == "btn-edit-wish-sel":
            self.action_edit_wish()
        elif bid == "btn-del-wish-sel":
            self.action_delete_wish()
        elif bid == "btn-efetivar-wish-sel":
            self.action_efetivar_wish()
        elif bid == "btn-run-sim":
            self.run_simulation()
        elif bid == "btn-commit-sim":
            self.commit_simulation()

    def commit_simulation(self) -> None:
        desc = self.query_one("#sim-desc", Input).value.strip()
        val = float(self.query_one("#sim-val", Input).value.strip().replace(",", "."))
        parc = int(self.query_one("#sim-parc", Select).value)
        meio = self.query_one("#sim-meio", Select).value
        
        tipo = "cartao" if meio.startswith("cartao") else "conta"
        cid = int(meio.split("-")[1])
        
        core_engine.efetivar_simulacao(desc, val, parcelas=parc, tipo=tipo, cartao_id=cid, conta_id=cid)
        self.notify(f"🚀 Simulação convertida em compra real no banco com sucesso!")
        self.refresh_all_data()
        self.run_simulation()

    def on_modal_closed(self, result: bool) -> None:
        if result:
            self.refresh_all_data()

    # Ações de Teclado (Bindings)
    def action_tab_dash(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-dash"

    def action_tab_tx(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-tx"

    def action_tab_sim(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-sim"

    def action_tab_cx(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-cx"

    def action_tab_card(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-cards"

    def action_tab_rec(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-rec"

    def action_tab_wish(self) -> None:
        self.query_one("#main-tabs", TabbedContent).active = "tab-wish"

    def action_new_tx(self) -> None:
        self.push_screen(AddTransactionModal(), callback=self.on_modal_closed)

    def on_data_table_row_selected(self, event: DataTable.RowSelected) -> None:
        if event.data_table.id == "table-transactions":
            row = event.data_table.get_row(event.row_key)
            if row:
                tx_id = int(row[0])
                self.push_screen(EditTransactionModal(tx_id), callback=self.on_modal_closed)
        elif event.data_table.id == "table-cartoes":
            row = event.data_table.get_row(event.row_key)
            if row:
                card_id = int(row[0])
                self.push_screen(EditCardModal(card_id), callback=self.on_modal_closed)
        elif event.data_table.id == "table-caixinhas-crud":
            row = event.data_table.get_row(event.row_key)
            if row:
                cx_id = int(row[0])
                self.push_screen(AddEditCaixinhaModal(cx_id), callback=self.on_modal_closed)
        elif event.data_table.id == "table-recorrencias":
            row = event.data_table.get_row(event.row_key)
            if row:
                rec_id = int(row[0])
                self.push_screen(AddEditRecorrenciaModal(rec_id), callback=self.on_modal_closed)
        elif event.data_table.id == "table-wishlist":
            row = event.data_table.get_row(event.row_key)
            if row:
                wish_id = int(row[0])
                self.push_screen(AddEditWishlistModal(wish_id), callback=self.on_modal_closed)

    def action_edit_wish(self) -> None:
        table = self.query_one("#table-wishlist", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                wish_id = int(row[0])
                self.push_screen(AddEditWishlistModal(wish_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione um item da wishlist para editar.", severity="warning")
        else:
            self.notify("Nenhum item na wishlist.", severity="warning")

    def action_delete_wish(self) -> None:
        table = self.query_one("#table-wishlist", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                wish_id = int(row[0])
                item_nome = str(row[1])
                core_engine.deletar_item_wishlist(wish_id)
                self.notify(f"✔ Item '{item_nome}' removido da wishlist!", severity="information")
                self.refresh_all_data()
            except Exception as e:
                self.notify(f"Erro ao excluir item: {e}", severity="error")
        else:
            self.notify("Nenhum item na wishlist.", severity="warning")

    def action_efetivar_wish(self) -> None:
        table = self.query_one("#table-wishlist", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                wish_id = int(row[0])
                self.push_screen(EfetivarWishlistModal(wish_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione um item da wishlist para efetivar.", severity="warning")
        else:
            self.notify("Nenhum item na wishlist para efetivar.", severity="warning")

    def action_edit_cx(self) -> None:
        table = self.query_one("#table-caixinhas-crud", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                cx_id = int(row[0])
                self.push_screen(AddEditCaixinhaModal(cx_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione uma caixinha para editar.", severity="warning")
        else:
            self.notify("Nenhuma caixinha cadastrada.", severity="warning")

    def action_delete_cx(self) -> None:
        table = self.query_one("#table-caixinhas-crud", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                cx_id = int(row[0])
                cx_nome = str(row[1])
                core_engine.deletar_caixinha(cx_id)
                self.notify(f"✔ Caixinha '{cx_nome}' excluída!", severity="information")
                self.refresh_all_data()
            except Exception as e:
                self.notify(f"Erro ao excluir caixinha: {e}", severity="error")
        else:
            self.notify("Nenhuma caixinha cadastrada.", severity="warning")

    def action_aporte_cx(self) -> None:
        table = self.query_one("#table-caixinhas-crud", DataTable)
        cx_id = 1
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                cx_id = int(row[0])
            except Exception:
                pass
        self.push_screen(AporteManualModal(cx_id), callback=self.on_modal_closed)

    def action_ajustar_aporte_cx(self) -> None:
        table = self.query_one("#table-caixinhas-crud", DataTable)
        cx_id = 1
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                cx_id = int(row[0])
            except Exception:
                pass
        mes_ref = self.get_selected_month_str()
        self.push_screen(AjustarAporteMesModal(caixinha_id=cx_id, mes_ref=mes_ref), callback=self.on_modal_closed)

    def action_edit_rec(self) -> None:
        table = self.query_one("#table-recorrencias", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                rec_id = int(row[0])
                self.push_screen(AddEditRecorrenciaModal(rec_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione uma recorrência para editar.", severity="warning")
        else:
            self.notify("Nenhuma recorrência cadastrada.", severity="warning")

    def action_delete_rec(self) -> None:
        table = self.query_one("#table-recorrencias", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                rec_id = int(row[0])
                rec_desc = str(row[1])
                core_engine.deletar_recorrencia(rec_id)
                self.notify(f"✔ Recorrência '{rec_desc}' excluída!", severity="information")
                self.refresh_all_data()
            except Exception as e:
                self.notify(f"Erro ao excluir recorrência: {e}", severity="error")
        else:
            self.notify("Nenhuma recorrência cadastrada.", severity="warning")

    def action_toggle_rec(self) -> None:
        table = self.query_one("#table-recorrencias", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                rec_id = int(row[0])
                
                conn = core_engine.get_connection()
                r = conn.execute("SELECT ativo, descricao FROM recorrencias WHERE id = ?", (rec_id,)).fetchone()
                novo_st = 0 if r['ativo'] == 1 else 1
                conn.execute("UPDATE recorrencias SET ativo = ? WHERE id = ?", (novo_st, rec_id))
                conn.commit()
                conn.close()
                
                status_label = "REATIVADA" if novo_st == 1 else "PAUSADA"
                self.notify(f"✔ Recorrência '{r['descricao']}' {status_label}!", severity="information")
                self.refresh_all_data()
            except Exception as e:
                self.notify(f"Erro ao alterar status da recorrência: {e}", severity="error")
        else:
            self.notify("Nenhuma recorrência cadastrada.", severity="warning")

    def action_edit_tx(self) -> None:
        table = self.query_one("#table-transactions", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                tx_id = int(row[0])
                self.push_screen(EditTransactionModal(tx_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione uma transação para editar.", severity="warning")
        else:
            self.notify("Nenhuma transação registrada para editar.", severity="warning")

    def action_delete_tx(self) -> None:
        table = self.query_one("#table-transactions", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                tx_id = int(row[0])
                self.push_screen(DeleteTransactionModal(tx_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione uma transação para excluir.", severity="warning")
        else:
            self.notify("Nenhuma transação registrada para excluir.", severity="warning")

    def action_edit_card(self) -> None:
        table = self.query_one("#table-cartoes", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                card_id = int(row[0])
                self.push_screen(EditCardModal(card_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione um cartão para editar.", severity="warning")
        else:
            self.notify("Nenhum cartão cadastrado.", severity="warning")

    def action_delete_card(self) -> None:
        table = self.query_one("#table-cartoes", DataTable)
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                card_id = int(row[0])
                self.push_screen(DeleteCardModal(card_id), callback=self.on_modal_closed)
            except Exception:
                self.notify("Selecione um cartão para excluir.", severity="warning")
        else:
            self.notify("Nenhum cartão cadastrado.", severity="warning")

    def action_pay_card_selected(self) -> None:
        table = self.query_one("#table-cartoes", DataTable)
        card_id = None
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                card_id = int(row[0])
            except Exception:
                pass
        mes_ref = self.get_selected_month_str()
        self.push_screen(PayInvoiceModal(cartao_id=card_id, mes_ref=mes_ref), callback=self.on_modal_closed)

    def action_adj_card_selected(self) -> None:
        table = self.query_one("#table-cartoes", DataTable)
        card_id = None
        if table.row_count > 0:
            try:
                row_key, _ = table.coordinate_to_cell_key(table.cursor_coordinate)
                row = table.get_row(row_key)
                card_id = int(row[0])
            except Exception:
                pass
        mes_ref = self.get_selected_month_str()
        self.push_screen(AdjustInvoiceModal(cartao_id=card_id, mes_ref=mes_ref), callback=self.on_modal_closed)

    def action_pay_invoice(self) -> None:
        mes_ref = self.get_selected_month_str()
        self.push_screen(PayInvoiceModal(mes_ref=mes_ref), callback=self.on_modal_closed)

    def action_refresh_data(self) -> None:
        self.refresh_all_data()
        self.notify("Dados atualizados com sucesso!")

    def action_backup(self) -> None:
        try:
            res = core_engine.fazer_backup()
            msg = f"✔ Backup realizado com sucesso!\n• SQLite: {res['db_file']}\n• Excel: {res['excel_file']}"
            if res['mirrors']:
                msg += f"\n• Espelhos: {len(res['mirrors'])} destino(s)"
            self.notify(msg, severity="information", timeout=6)
        except Exception as e:
            self.notify(f"Erro ao gerar backup: {e}", severity="error")

    def action_export_excel(self) -> None:
        out = core_engine.exportar_para_excel()
        self.notify(f"✔ Planilha exportada para:\n{out}", severity="information")

    def action_export_ia(self) -> None:
        try:
            res = core_engine.exportar_contexto_ia()
            self.notify(f"🧠 Contexto para IA atualizado em /mnt/dados!\n• {res['meses_count']} meses gerados", severity="information", timeout=6)
        except Exception as e:
            self.notify(f"Erro ao exportar contexto IA: {e}", severity="error")

    def action_prev_month(self) -> None:
        self.current_month_offset -= 1
        self.refresh_all_data()

    def action_next_month(self) -> None:
        self.current_month_offset += 1
        self.refresh_all_data()

if __name__ == "__main__":
    app = ApexFinanceApp()
    app.run()
