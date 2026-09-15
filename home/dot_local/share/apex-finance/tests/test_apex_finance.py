#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Suite de Testes Unitários e de Borda (Edge Cases) para o APEX Finance.
Garante 100% de precisão matemática e contábil.
"""

import pytest
import sqlite3
import os
import sys
import shutil
import tempfile
from datetime import date

sys.path.insert(0, '/home/lan/.local/share/apex-finance')
import core_engine

@pytest.fixture
def test_db():
    temp_dir = tempfile.mkdtemp()
    db_path = os.path.join(temp_dir, "test_finance.db")
    orig_db = core_engine.DB_PATH
    core_engine.DB_PATH = db_path
    
    core_engine.init_database()
    
    yield db_path
    
    core_engine.DB_PATH = orig_db
    shutil.rmtree(temp_dir, ignore_errors=True)

# -----------------------------------------------------------------------------
# 1. TESTES DE FECHAMENTO DE FATURA & CORTE DE CARTÃO (EDGE CASES)
# -----------------------------------------------------------------------------
class TestCartaoFaturaEdgeCases:
    def test_compra_antes_do_fechamento_cai_no_mes_atual(self, test_db):
        """
        Nubank fecha dia 04. Compra feita dia 03 deve cair na fatura do mês atual.
        """
        mes_fatura = core_engine.calcular_mes_fatura("2026-09-03", dia_fechamento=4)
        assert mes_fatura == "2026-09"

    def test_compra_no_dia_do_fechamento_cai_no_mes_atual(self, test_db):
        """
        Compra feita no dia exato do fechamento (dia 04) ainda entra na fatura atual.
        """
        mes_fatura = core_engine.calcular_mes_fatura("2026-09-04", dia_fechamento=4)
        assert mes_fatura == "2026-09"

    def test_compra_depois_do_fechamento_pula_para_mes_seguinte(self, test_db):
        """
        Compra feita dia 05 com fechamento dia 04 DEVE pular para o mês seguinte.
        """
        mes_fatura = core_engine.calcular_mes_fatura("2026-09-05", dia_fechamento=4)
        assert mes_fatura == "2026-10"

    def test_virada_de_ano_em_dezembro(self, test_db):
        """
        Compra feita após o fechamento em Dezembro (ex: 2026-12-25) DEVE virar o ano para 2027-01.
        """
        mes_fatura = core_engine.calcular_mes_fatura("2026-12-25", dia_fechamento=20)
        assert mes_fatura == "2027-01"

    def test_parcelamento_com_virada_de_ano(self, test_db):
        """
        Compra parcelada em 4x em Novembro deve gerar parcelas em Nov/26, Dez/26, Jan/27 e Fev/27.
        """
        core_engine.registrar_compra_cartao(
            cartao_id=1,
            data_compra="2026-11-01",
            descricao="Peça Moto Especial",
            valor_total=400.0,
            categoria="Moto",
            parcelas=4
        )
        conn = core_engine.get_connection()
        c = conn.cursor()
        c.execute("SELECT mes_fatura, parcela_atual, valor FROM transacoes WHERE descricao LIKE 'Peça Moto Especial%' ORDER BY parcela_atual")
        rows = c.fetchall()
        conn.close()

        assert len(rows) == 4
        assert [r['mes_fatura'] for r in rows] == ["2026-11", "2026-12", "2027-01", "2027-02"]
        for r in rows:
            assert r['valor'] == 100.0

# -----------------------------------------------------------------------------
# 2. TESTES DE RECONCILIAÇÃO E SALDO BANCÁRIO
# -----------------------------------------------------------------------------
class TestSaldosContabilidade:
    def test_adicionar_despesa_reduz_saldo_da_conta(self, test_db):
        conn = core_engine.get_connection()
        c = conn.cursor()
        saldo_ant = c.execute("SELECT saldo FROM contas WHERE id = 1").fetchone()['saldo']
        conn.close()

        core_engine.adicionar_transacao_conta(1, "2026-09-15", "Mercado", 50.0, "despesa", "Alimentação")

        conn = core_engine.get_connection()
        c = conn.cursor()
        saldo_novo = c.execute("SELECT saldo FROM contas WHERE id = 1").fetchone()['saldo']
        conn.close()
        assert round(saldo_novo, 2) == round(saldo_ant - 50.0, 2)

    def test_pagar_fatura_debita_da_conta_e_marca_como_paga(self, test_db):
        # 1. Compra no cartão
        core_engine.registrar_compra_cartao(1, "2026-09-01", "Posto Shell", 100.0, "Moto", parcelas=1)
        
        # 2. Pagar fatura
        core_engine.reconciliar_saldo(1, 500.0)
        total_pago, msg = core_engine.pagar_fatura(1, "2026-09", conta_pagamento_id=1)
        
        assert total_pago == 100.0
        assert "sucesso" in msg.lower()
        
        # 3. Verifica saldo e status da fatura
        conn = core_engine.get_connection()
        c = conn.cursor()
        saldo = c.execute("SELECT saldo FROM contas WHERE id = 1").fetchone()['saldo']
        status = c.execute("SELECT status FROM faturas WHERE cartao_id = 1 AND mes_referencia = '2026-09'").fetchone()['status']
        conn.close()
        assert round(saldo, 2) == 400.0
        assert status == "paga"

    def test_prevenir_pagamento_duplicado_de_fatura(self, test_db):
        core_engine.registrar_compra_cartao(1, "2026-09-01", "Almoço", 80.0, "Alimentação")
        core_engine.reconciliar_saldo(1, 300.0)
        core_engine.pagar_fatura(1, "2026-09", conta_pagamento_id=1)
        
        # Segunda tentativa
        tot2, msg2 = core_engine.pagar_fatura(1, "2026-09", conta_pagamento_id=1)
        assert tot2 == 0.0
        assert "já está paga" in msg2.lower()

# -----------------------------------------------------------------------------
# 3. TESTES DE EXCLUSÃO DE SÉRIES PARCELADAS
# -----------------------------------------------------------------------------
class TestExclusaoSeriesParceladas:
    def test_deletar_serie_inteira_remove_todas_as_parcelas(self, test_db):
        core_engine.registrar_compra_cartao(1, "2026-09-01", "Curso Online", 300.0, "Estudos", parcelas=3)
        
        conn = core_engine.get_connection()
        c = conn.cursor()
        tx = c.execute("SELECT id FROM transacoes WHERE descricao LIKE 'Curso Online%' LIMIT 1").fetchone()
        tx_id = tx['id']
        conn.close()

        # Deleta a série completa
        ok, msg = core_engine.deletar_transacao(tx_id, deletar_todas_parcelas=True)
        assert ok is True
        
        conn = core_engine.get_connection()
        c = conn.cursor()
        restantes = c.execute("SELECT COUNT(*) FROM transacoes WHERE descricao LIKE 'Curso Online%'").fetchone()[0]
        conn.close()
        assert restantes == 0

# -----------------------------------------------------------------------------
# 4. TESTES DA ALFORRIA & APORTES PLANEJADOS (PAUSAS E RETOMADAS)
# -----------------------------------------------------------------------------
class TestAlforriaAportesModulares:
    def test_override_de_aporte_planejado_mes_especifico(self, test_db):
        core_engine.definir_aporte_planejado("2026-10", 1, 0.0, "Pausa Moto")
        
        ap_out = core_engine.obter_aporte_planejado("2026-10", 1)
        ap_nov = core_engine.obter_aporte_planejado("2026-11", 1)
        
        assert ap_out == 0.0
        assert ap_nov == 1000.0

    def test_projecao_alforria_respeita_pausas(self, test_db):
        core_engine.definir_aporte_planejado("2026-10", 1, 0.0, "Pausa")
        proj = core_engine.projetar_alforria(meses=3)
        
        # Mês 1: Outubro/2026 -> Aporte zero
        assert proj[0]['aporte'] == 0.0
        assert proj[0]['saldo'] > 1000.0
        
        # Mês 2: Novembro/2026 -> Aporte normal R$ 1000
        assert proj[1]['aporte'] == 1000.0

# -----------------------------------------------------------------------------
# 5. TESTES DA WISHLIST (PLANEJAMENTO DE COMPRAS SEM ATRITO)
# -----------------------------------------------------------------------------
class TestWishlistCore:
    def test_crud_wishlist(self, test_db):
        wid = core_engine.criar_item_wishlist(
            item="QCY H3 Pro",
            categoria="Estudos",
            valor_estimado=365.0,
            parcelas_sugeridas=4,
            prioridade="Alta",
            condicao_compra="Após quitar dividas"
        )
        assert wid is not None
        
        items = core_engine.listar_wishlist(apenas_planejados=True)
        assert any(i['item'] == "QCY H3 Pro" for i in items)

        # Edita
        core_engine.editar_item_wishlist(wid, "QCY H3 Pro Max", "Estudos", 380.0, 4, "Alta", "Condicao Nova")
        items_mod = core_engine.listar_wishlist()
        item_editado = next(i for i in items_mod if i['id'] == wid)
        assert item_editado['item'] == "QCY H3 Pro Max"
        assert item_editado['valor_estimado'] == 380.0

    def test_efetivar_compra_wishlist_cria_transacoes_e_muda_status(self, test_db):
        wid = core_engine.criar_item_wishlist(
            item="Garrafa Stanley 1.1L",
            categoria="Saúde",
            valor_estimado=278.0,
            parcelas_sugeridas=6,
            prioridade="Média"
        )
        
        core_engine.efetivar_compra_wishlist(wid, cartao_id=1, parcelas=6)
        
        conn = core_engine.get_connection()
        c = conn.cursor()
        w = c.execute("SELECT status FROM wishlist WHERE id = ?", (wid,)).fetchone()
        assert w['status'] == "comprado"
        
        txs = c.execute("SELECT * FROM transacoes WHERE descricao LIKE 'Garrafa Stanley 1.1L%'").fetchall()
        conn.close()
        assert len(txs) == 6
        for t in txs:
            assert t['total_parcelas'] == 6

# -----------------------------------------------------------------------------
# 6. TESTES DE EXPORTAÇÃO (EXCEL & CONTEXTO IA)
# -----------------------------------------------------------------------------
class TestExportacoes:
    def test_exportar_para_excel_gera_arquivo_valido(self, test_db):
        temp_dir = tempfile.mkdtemp()
        xlsx_file = os.path.join(temp_dir, "test_export.xlsx")
        out = core_engine.exportar_para_excel(xlsx_file)
        assert os.path.exists(out)
        assert os.path.getsize(out) > 1000
        shutil.rmtree(temp_dir, ignore_errors=True)

    def test_exportar_contexto_ia_gera_hierarquia_markdown(self, test_db):
        temp_dir = tempfile.mkdtemp()
        res = core_engine.exportar_contexto_ia(base_dir=temp_dir)
        
        assert os.path.exists(res['global_file'])
        assert res['meses_count'] == 24
        
        with open(res['global_file'], 'r') as f:
            conteudo = f.read()
            assert "CONTEXTO ESTRATÉGICO GLOBAL" in conteudo
            assert "DEPOIS DAS CONTAS" in conteudo
            assert "WISHLIST & COMPRAS FUTURAS" in conteudo
            
        shutil.rmtree(temp_dir, ignore_errors=True)

# -----------------------------------------------------------------------------
# 7. TESTES ADICIONAIS DE BORDA: SIMULADOR & TETO SEMANAL
# -----------------------------------------------------------------------------
class TestSimuladorEHudEdgeCases:
    def test_simulador_impacto_compra_recalcula_sobras(self, test_db):
        res = core_engine.simular_impacto_compra(600.0, parcelas=6, tipo="cartao")
        assert len(res['baseline']) == 12
        assert len(res['simulado']) == 12
        assert "veredicto" in res
        # Primeiras 6 parcelas devem ter saldo menor no simulado acumulando R$ 100 a cada mês
        for i in range(6):
            assert res['simulado'][i]['saldo_final'] < res['baseline'][i]['saldo_final']
            # O impacto acumulado após i parcelas pagas é (i + 1) * 100
            impacto_esperado = (i + 1) * 100.0
            assert round(res['baseline'][i]['saldo_final'] - res['simulado'][i]['saldo_final'], 2) == round(impacto_esperado, 2)

    def test_calcular_mes_fatura_limites_de_mes(self, test_db):
        # Fevereiro ano bissexto ou 28 dias
        assert core_engine.calcular_mes_fatura("2028-02-29", dia_fechamento=28) == "2028-03"
        assert core_engine.calcular_mes_fatura("2028-02-28", dia_fechamento=28) == "2028-02"
        # Dia 31 de Julho -> Agosto
        assert core_engine.calcular_mes_fatura("2027-07-31", dia_fechamento=25) == "2027-08"

    def test_reajuste_de_fatura_conciliacao(self, test_db):
        core_engine.registrar_compra_cartao(1, "2026-09-01", "Gasto", 100.0, "Outros")
        # App do banco marca 100.15 (IOF de 15 centavos)
        dif, msg = core_engine.reajustar_fatura_cartao(1, "2026-09", 100.15, motivo="IOF")
        assert round(dif, 2) == 0.15
        
        # Verifica total recalculado
        conn = core_engine.get_connection()
        c = conn.cursor()
        tot = c.execute("SELECT SUM(valor) FROM transacoes WHERE cartao_id = 1 AND mes_fatura = '2026-09'").fetchone()[0]
        conn.close()
        assert round(tot, 2) == 100.15
