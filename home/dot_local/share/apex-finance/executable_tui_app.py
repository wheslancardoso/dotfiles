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

#month-display {
    text-style: bold;
    color: #cba6f7;
    width: 30;
    content-align: center middle;
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
        Binding("n", "new_tx", "Nova Transação", show=True),
        Binding("d", "delete_tx", "Excluir [d]", show=True),
        Binding("s", "open_sim", "Simulador", show=False),
        Binding("p", "pay_invoice", "Pagar Fatura", show=True),
        Binding("b", "backup", "Backup", show=True),
        Binding("r", "refresh_data", "Atualizar", show=True),
        Binding("e", "export_excel", "Excel", show=True),
        Binding("h", "prev_month", "Mês Anterior", show=False),
        Binding("l", "next_month", "Próximo Mês", show=False),
    ]

    current_month_offset = 0
    filter_month_only = True

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        
        # 1. TOP SURVIVAL HUD
        with Grid(id="hud-container"):
            with Vertical(classes="hud-card"):
                yield Label("🛡️ LIQUIDEZ LÍQUIDA", classes="hud-label")
                yield Label("R$ 0,00", id="hud-liquidez", classes="hud-val-green")
                
            with Vertical(classes="hud-card"):
                yield Label("💰 DISPONÍVEL BANCOS", classes="hud-label")
                yield Label("R$ 0,00", id="hud-bancos", classes="hud-val-blue")
                
            with Vertical(classes="hud-card"):
                yield Label("💳 DÍVIDAS CARTÕES", classes="hud-label")
                yield Label("R$ 0,00", id="hud-dividas", classes="hud-val-red")
                
            with Vertical(classes="hud-card"):
                yield Label("🫁 TETO OXIGÊNIO (SEM)", classes="hud-label")
                yield Label("R$ 0,00 /sem", id="hud-teto", classes="hud-val-mauve")
                
            with Vertical(classes="hud-card"):
                yield Label("🎖️ ESCUDO RESILIÊNCIA", classes="hud-label")
                yield Label("Tier 1", id="hud-tier", classes="hud-val-yellow")

        # 2. MONTH NAVIGATOR
        with Horizontal(id="time-navigator"):
            yield Button("◀ Mês Ant. [h]", id="btn-prev-month")
            yield Label("📅 2026-09 (Setembro)", id="month-display")
            yield Label("⚡ ATIVO", id="month-status-badge", classes="hud-val-green")
            yield Button("Próx. Mês [l] ▶", id="btn-next-month")
            yield Button("🔒 Selar Mês", id="btn-seal-month")
            yield Button("📜 Snapshots", id="btn-view-snapshots")
            yield Button("💾 Backup [b]", id="btn-backup-tui")
            yield Button("⚖️ Ajustar Fatura", id="btn-open-adj-fat")
            yield Button("🏦 Reconciliar Saldo", id="btn-open-rec")
            yield Button("⚡ Ritual Domingo", id="btn-open-ritual")

        # 3. TABBED CONTENT
        with TabbedContent(id="main-tabs"):
            # ABA 1: DASHBOARD
            with TabPane("📊 Dashboard & Time Machine", id="tab-dash"):
                with Horizontal():
                    with Vertical(classes="section-box", id="dash-summary-box"):
                        yield Label("🏛️ Resumo Consolidado do Mês", classes="section-title")
                        yield Static(id="dash-consolidated-text")
                        yield Rule()
                        yield Label("🏦 Contas Correntes & Carteira", classes="section-title")
                        yield Static(id="dash-accounts-text")
                    
                    with Vertical(classes="section-box"):
                        yield Label("📈 Fluxo de Caixa Preditivo (Próximos 12 Meses)", classes="section-title")
                        yield PlotextPlot(id="chart-projection")

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
                    yield Label("📊 Comparativo: Fluxo de Caixa Normal (Azul) vs. Impactado (Rosa)", classes="section-title")
                    yield PlotextPlot(id="chart-sim")

            # ABA 4: CAIXINHAS & METAS
            with TabPane("🏰 Caixinhas & Alforria (115% CDI)", id="tab-cx"):
                with VerticalScroll():
                    yield Label("🏰 Metas de Patrimônio & Focos Sagrados", classes="section-title")
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
                    yield Label("📈 Tabela de Projeção da Alforria (Mês a Mês com 115% CDI)", classes="section-title")
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
                    yield DataTable(id="table-recorrencias")

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
        
        # Projeção Alforria
        table_proj = self.query_one("#table-proj-alforria", DataTable)
        table_proj.cursor_type = "row"
        table_proj.zebra_stripes = True
        table_proj.add_columns("Mês", "Referência", "Aporte", "Rendimento CDI", "Bônus 13º", "Saldo Final")

        # Recorrências
        table_rec = self.query_one("#table-recorrencias", DataTable)
        table_rec.cursor_type = "row"
        table_rec.zebra_stripes = True
        table_rec.add_columns("ID", "Descrição", "Valor", "Tipo", "Categoria", "Dia Venc.")

        # Cartões de Crédito
        table_cards = self.query_one("#table-cartoes", DataTable)
        table_cards.cursor_type = "row"
        table_cards.zebra_stripes = True
        table_cards.add_columns("ID", "Cartão", "Instituição", "Limite", "Comprometido", "Disponível", "Corte", "Vencimento", "Fatura Mês", "Status Fatura")

    def get_selected_month_str(self) -> str:
        hoje = date.today()
        m = hoje.month + self.current_month_offset
        a = hoje.year + (m - 1) // 12
        m = ((m - 1) % 12) + 1
        return f"{a:04d}-{m:02d}"

    def refresh_all_data(self) -> None:
        mes_ref = self.get_selected_month_str()
        
        # Atualiza etiqueta do mês
        ano, mes = map(int, mes_ref.split("-"))
        dt_exemplo = date(ano, mes, 1)
        nome_mes = dt_exemplo.strftime("%B").title()
        self.query_one("#month-display", Label).update(f"📅 {mes_ref} ({nome_mes})")

        # Atualiza badge de status do mês
        snap = core_engine.obter_snapshot_mensal(mes_ref)
        badge = self.query_one("#month-status-badge", Label)
        hoje_str = str(date.today())[:7]
        if snap:
            badge.update("🔒 SELADO")
            badge.classes = "hud-val-mauve"
        elif mes_ref < hoje_str:
            badge.update("⏳ PASSADO")
            badge.classes = "hud-val-yellow"
        elif mes_ref == hoje_str:
            badge.update("⚡ ATIVO")
            badge.classes = "hud-val-green"
        else:
            badge.update("🔮 PROJEÇÃO")
            badge.classes = "hud-val-blue"

        btn_filter = self.query_one("#btn-toggle-month-tx", Button)
        if self.filter_month_only:
            btn_filter.label = f"📅 Mês ({mes_ref})"
        else:
            btn_filter.label = "🌐 Todas Transações"

        # 1. Survival HUD
        hud = core_engine.get_survival_hud_metrics(mes_ref)
        
        lbl_liq = self.query_one("#hud-liquidez", Label)
        lbl_liq.update(f"R$ {hud['liquidez_liquida']:,.2f}")
        lbl_liq.set_class(hud['liquidez_liquida'] >= 0, "hud-val-green")
        lbl_liq.set_class(hud['liquidez_liquida'] < 0, "hud-val-red")
        
        self.query_one("#hud-bancos", Label).update(f"R$ {hud['saldo_bancario']:,.2f}")
        self.query_one("#hud-dividas", Label).update(f"R$ {hud['divida_consolidada']:,.2f}")
        self.query_one("#hud-teto", Label).update(f"R$ {hud['teto_oxigenio_semanal']:,.2f}/sem")
        self.query_one("#hud-tier", Label).update(hud['health_tier'])

        # 2. Resumo Consolidado & Contas
        conn = core_engine.get_connection()
        c = conn.cursor()
        
        c.execute("SELECT nome, tipo, instituicao, saldo FROM contas")
        contas_rows = c.fetchall()
        acc_text = ""
        for r in contas_rows:
            acc_text += f"• [b]{r['nome']}[/b] ({r['instituicao']}): [green]R$ {r['saldo']:,.2f}[/green]\n"
        self.query_one("#dash-accounts-text", Static).update(acc_text)
        
        c.execute("SELECT SUM(valor) FROM recorrencias WHERE tipo = 'receita' AND ativo = 1")
        rec_rec = c.fetchone()[0] or 0.0
        c.execute("SELECT SUM(valor) FROM recorrencias WHERE tipo = 'despesa' AND ativo = 1")
        desp_rec = c.fetchone()[0] or 0.0
        c.execute("SELECT SUM(valor) FROM transacoes WHERE cartao_id IS NOT NULL AND mes_fatura = ?", (mes_ref,))
        fat_mes = c.fetchone()[0] or 0.0
        
        sobra_mes = rec_rec - desp_rec - fat_mes
        saldo_proj_fim = hud['saldo_bancario'] + sobra_mes
        
        resumo_str = (
            f"[italic yellow]\"Quem é fiel no pouco, sobre o muito será colocado.\" (Lc 16:10)[/italic yellow]\n\n"
            f"• [b]Receita Mensal Projetada:[/b] [green]R$ {rec_rec:,.2f}[/green]\n"
            f"• [b]Custos Fixos & Metas:[/b] [red]R$ {desp_rec:,.2f}[/red]\n"
            f"• [b]Fatura Cartão ({mes_ref}):[/b] [yellow]R$ {fat_mes:,.2f}[/yellow]\n"
            f"• [b]Margem Líquida do Mês:[/b] [{'green' if sobra_mes>=0 else 'red'}]R$ {sobra_mes:,.2f}[/]\n"
            f"• [b]Saldo Projetado Fim de Mês:[/b] [{'green' if saldo_proj_fim>=0 else 'red'}]R$ {saldo_proj_fim:,.2f}[/]"
        )
        self.query_one("#dash-consolidated-text", Static).update(resumo_str)

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

        # 4. Caixinhas Progress Bars
        c.execute("SELECT id, nome, saldo_atual, meta_total, aporte_mensal FROM caixinhas")
        for cx in c.fetchall():
            if "Alforria" in cx['nome']:
                pb = self.query_one("#pb-alforria", ProgressBar)
                pb.progress = cx['saldo_atual']
                pct = (cx['saldo_atual'] / cx['meta_total']) * 100
                self.query_one("#lbl-alforria", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte: R$ {cx['aporte_mensal']:,.2f}/mês"
                )
            elif "CG 160" in cx['nome']:
                pb = self.query_one("#pb-moto", ProgressBar)
                pb.progress = cx['saldo_atual']
                pct = (cx['saldo_atual'] / cx['meta_total']) * 100
                self.query_one("#lbl-moto", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte: R$ {cx['aporte_mensal']:,.2f}/mês"
                )
            elif "Presença" in cx['nome']:
                pb = self.query_one("#pb-presenca", ProgressBar)
                pb.progress = cx['saldo_atual']
                pct = (cx['saldo_atual'] / cx['meta_total']) * 100
                self.query_one("#lbl-presenca", Static).update(
                    f"Acumulado: R$ {cx['saldo_atual']:,.2f} / R$ {cx['meta_total']:,.2f} ({pct:.1f}%) | Aporte: R$ {cx['aporte_mensal']:,.2f}/mês"
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
        c.execute("SELECT id, descricao, valor, tipo, categoria, dia_vencimento FROM recorrencias ORDER BY id")
        for r in c.fetchall():
            cor = "green" if r['tipo'] == 'receita' else "red"
            val_fmt = f"[{cor}]R$ {r['valor']:,.2f}[/]"
            table_rec.add_row(
                str(r['id']), r['descricao'], val_fmt, r['tipo'].upper(),
                r['categoria'] or '-', f"Todo dia {r['dia_vencimento']}"
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

        conn.close()

        # 7. Renderizar Gráfico de Fluxo de Caixa no Dashboard
        self.render_dashboard_chart()

    def render_dashboard_chart(self) -> None:
        plot = self.query_one("#chart-projection", PlotextPlot)
        plot.plt.clear_data()
        plot.plt.clear_figure()
        
        proj = core_engine.get_time_machine_projection(meses=10)
        meses = [p['label'].replace("/", "-") for p in proj]
        saldos = [p['saldo_final'] for p in proj]
        
        plot.plt.theme("dark")
        plot.plt.title("Projeção do Saldo em Conta (10 Meses)")
        plot.plt.bar(meses, saldos, color="green", width=0.5)
        plot.plt.plotsize(None, 14)
        plot.refresh()

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
        
        # Gráfico comparativo
        plot_sim = self.query_one("#chart-sim", PlotextPlot)
        plot_sim.plt.clear_data()
        plot_sim.plt.clear_figure()
        
        meses = [b['label'].replace("/", "-") for b in res['baseline']]
        x_pts = list(range(len(meses)))
        y_base = [b['saldo_final'] for b in res['baseline']]
        y_sim = [s['saldo_final'] for s in res['simulado']]
        
        plot_sim.plt.theme("dark")
        plot_sim.plt.title("Curva de Fluxo: Original (Azul) vs. Com Nova Compra (Rosa)")
        plot_sim.plt.plot(x_pts, y_base, label="Normal", color="cyan", marker="dot")
        plot_sim.plt.plot(x_pts, y_sim, label="Simulado", color="magenta", marker="dot")
        plot_sim.plt.xticks(x_pts, meses)
        plot_sim.plt.plotsize(None, 14)
        plot_sim.refresh()

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
        elif bid == "btn-open-ritual":
            self.app.push_screen(SundayRitualModal())
        elif bid == "btn-open-rec":
            self.app.push_screen(ReconcileModal(), callback=self.on_modal_closed)
        elif bid in ("btn-open-adj-fat", "btn-adj-caixa", "btn-adj-nubank"):
            self.app.push_screen(AdjustInvoiceModal(), callback=self.on_modal_closed)
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

    def action_prev_month(self) -> None:
        self.current_month_offset -= 1
        self.refresh_all_data()

    def action_next_month(self) -> None:
        self.current_month_offset += 1
        self.refresh_all_data()

if __name__ == "__main__":
    app = ApexFinanceApp()
    app.run()
