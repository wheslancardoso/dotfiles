#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
==============================================================================
🏛️ APEX FINANCE ENGINE — CORE KERNEL DE INTELIGÊNCIA FINANCEIRA (SQLITE / FTS)
==============================================================================
Motor financeiro robusto com suporte a:
- Contas correntes, saldos e histórico
- Cartões de crédito com cálculo automático de melhor dia de compra e faturas
- Compras parceladas automáticas vinculadas à fatura correta
- Fechamento e pagamento de fatura debitando da conta
- Caixinhas com cálculo de rendimento líquido em CDI (115%)
- Projeções mensais de caixa para os próximos 24 meses
- Exportação perfeita para planilhas Excel (.xlsx) formatadas profissionalmente
"""

import sqlite3
import os
import sys
import datetime
from datetime import date, timedelta
import calendar
import json

DB_DIR = os.path.expanduser("~/.local/share/apex-finance/data")
DB_PATH = os.path.join(DB_DIR, "finance.db")
os.makedirs(DB_DIR, exist_ok=True)

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn

def init_database():
    conn = get_connection()
    c = conn.cursor()
    c.executescript("""
    CREATE TABLE IF NOT EXISTS contas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        tipo TEXT NOT NULL, -- 'corrente', 'poupanca', 'investimento', 'carteira'
        instituicao TEXT NOT NULL,
        saldo REAL NOT NULL DEFAULT 0.0,
        cor TEXT DEFAULT '#10b981'
    );

    CREATE TABLE IF NOT EXISTS cartoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        instituicao TEXT NOT NULL,
        limite REAL NOT NULL,
        dia_fechamento INTEGER NOT NULL, -- Dia em que a fatura fecha (corte)
        dia_vencimento INTEGER NOT NULL, -- Dia em que a fatura vence
        conta_pagamento_id INTEGER REFERENCES contas(id)
    );

    CREATE TABLE IF NOT EXISTS caixinhas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        descricao TEXT,
        meta_total REAL NOT NULL,
        aporte_mensal REAL NOT NULL,
        saldo_atual REAL NOT NULL DEFAULT 0.0,
        data_alvo TEXT,
        tipo_rendimento TEXT DEFAULT '115% CDI',
        taxa_mensal REAL DEFAULT 0.0095
    );

    CREATE TABLE IF NOT EXISTS categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        tipo TEXT NOT NULL -- 'receita', 'despesa', 'ambos'
    );

    CREATE TABLE IF NOT EXISTS transacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL, -- 'YYYY-MM-DD'
        descricao TEXT NOT NULL,
        valor REAL NOT NULL,
        tipo TEXT NOT NULL, -- 'receita', 'despesa', 'transferencia', 'aporte_caixinha', 'fatura_cartao'
        categoria TEXT,
        conta_id INTEGER REFERENCES contas(id),
        cartao_id INTEGER REFERENCES cartoes(id),
        caixinha_id INTEGER REFERENCES caixinhas(id),
        mes_fatura TEXT, -- 'YYYY-MM'
        parcela_atual INTEGER DEFAULT 1,
        total_parcelas INTEGER DEFAULT 1,
        grupo_parcelamento_id TEXT
    );

    CREATE TABLE IF NOT EXISTS faturas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cartao_id INTEGER NOT NULL REFERENCES cartoes(id),
        mes_referencia TEXT NOT NULL, -- 'YYYY-MM'
        data_fechamento TEXT NOT NULL,
        data_vencimento TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'aberta', -- 'aberta', 'fechada', 'paga'
        valor_pago REAL DEFAULT 0.0,
        data_pagamento TEXT,
        UNIQUE(cartao_id, mes_referencia)
    );

    CREATE TABLE IF NOT EXISTS recorrencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL,
        tipo TEXT NOT NULL, -- 'receita', 'despesa'
        categoria TEXT,
        conta_id INTEGER REFERENCES contas(id),
        dia_vencimento INTEGER DEFAULT 5,
        ativo INTEGER DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS monthly_snapshots (
        mes_referencia TEXT PRIMARY KEY, -- 'YYYY-MM'
        data_snapshot TEXT NOT NULL,
        saldo_bancario_total REAL NOT NULL,
        saldo_caixinhas_total REAL NOT NULL,
        total_receitas REAL NOT NULL,
        total_despesas REAL NOT NULL,
        total_faturas_pagas REAL NOT NULL,
        liquidez_liquida REAL NOT NULL,
        teto_oxigenio REAL NOT NULL,
        status TEXT DEFAULT 'selado', -- 'selado', 'aberto'
        snapshot_json TEXT
    );

    CREATE TABLE IF NOT EXISTS aportes_planejados (
        mes_referencia TEXT NOT NULL,
        caixinha_id INTEGER NOT NULL REFERENCES caixinhas(id),
        valor REAL NOT NULL,
        motivo TEXT,
        PRIMARY KEY (mes_referencia, caixinha_id)
    );

    CREATE TABLE IF NOT EXISTS wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item TEXT NOT NULL,
        categoria TEXT NOT NULL, -- 'Estudos/Carreira', 'Saúde/Hidratação', 'Moto', 'Tecnologia', 'Outros'
        valor_estimado REAL NOT NULL,
        parcelas_sugeridas INTEGER DEFAULT 1,
        prioridade TEXT DEFAULT 'Média', -- 'Baixa', 'Média', 'Alta', 'Estratégica'
        condicao_compra TEXT, -- 'Após quitar faturas', 'Após 13º', 'Promoção', etc.
        status TEXT DEFAULT 'planejado', -- 'planejado', 'comprado', 'cancelado'
        link_ou_obs TEXT,
        data_criacao TEXT
    );
    """)

    # Populate defaults if empty
    c.execute("SELECT COUNT(*) FROM contas")
    if c.fetchone()[0] == 0:
        c.executescript("""
        INSERT INTO contas (nome, tipo, instituicao, saldo) VALUES
        ('Nubank Conta', 'corrente', 'Nubank', 174.00),
        ('Caixa Econômica', 'corrente', 'Caixa', 0.00),
        ('Carteira Física', 'carteira', 'Dinheiro', 50.00);

        INSERT INTO cartoes (nome, instituicao, limite, dia_fechamento, dia_vencimento, conta_pagamento_id) VALUES
        ('Cartão Caixa Elo/Visa', 'Caixa', 3500.00, 20, 28, 1),
        ('Cartão Nubank Gold', 'Nubank', 2500.00, 25, 5, 1);

        INSERT INTO caixinhas (nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo, tipo_rendimento, taxa_mensal) VALUES
        ('Alforria 2028 (O Meu Canto)', 'Reserva sagrada para emancipação aos 24 anos e R$ 18k livres', 27000.00, 1000.00, 1000.00, '2028-08-01', '115% CDI', 0.0095),
        ('Máquina Zerada (CG 160)', 'Fundo IPVA R$742 + Motul 5100 + Polimento Técnico & PPF', 1500.00, 100.00, 200.00, '2027-12-31', '100% CDI', 0.0085),
        ('Presença & Saúde Masculina', 'Minoxidil, Skincare, Óculos novos e Roupas alinhadas', 1200.00, 100.00, 150.00, '2027-06-01', '100% CDI', 0.0085);

        INSERT INTO categorias (nome, tipo) VALUES
        ('Alforria / Investimento', 'despesa'),
        ('Provisão Casa (Carnes)', 'despesa'),
        ('Moto (Gasolina / Óleo / IPVA)', 'despesa'),
        ('Saúde Mental / Psiquiatria', 'despesa'),
        ('Barbearia & Cuidados', 'despesa'),
        ('Estética / Minoxidil / Roupas', 'despesa'),
        ('Salário Comissionado AGR', 'receita'),
        ('Rendimento Caixinhas', 'receita'),
        ('Outros / Manobra', 'ambos');
        """)

    # Populate recorrencias if empty
    c.execute("SELECT COUNT(*) FROM recorrencias")
    if c.fetchone()[0] == 0:
        c.executescript("""
        INSERT INTO recorrencias (descricao, valor, tipo, categoria, conta_id, dia_vencimento, ativo) VALUES
        ('Salário Comissionado AGR', 2234.00, 'receita', 'Salário Comissionado AGR', 1, 5, 1),
        ('Aporte Sagrado Alforria', 1000.00, 'despesa', 'Alforria / Investimento', 1, 5, 1),
        ('Provisão Carnes & Casa', 400.00, 'despesa', 'Provisão Casa (Carnes)', 1, 10, 1),
        ('Psiquiatria & Vortioxetina', 200.00, 'despesa', 'Saúde Mental / Psiquiatria', 1, 15, 1),
        ('CG 160 (Gasolina + Motul + IPVA)', 190.00, 'despesa', 'Moto (Gasolina / Óleo / IPVA)', 1, 15, 1),
        ('Barbeiro Quinzenal', 120.00, 'despesa', 'Barbearia & Cuidados', 1, 10, 1),
        ('Presença, Minoxidil & Skincare', 150.00, 'despesa', 'Estética / Minoxidil / Roupas', 1, 20, 1);
        """)

    conn.commit()
    conn.close()

# ----------------------------------------------------------------------
# FATURAS E REGRAS DE CARTÃO DE CRÉDITO (SEM BUG)
# ----------------------------------------------------------------------
def calcular_mes_fatura(dia_compra_str, dia_fechamento):
    """
    Se a compra foi feita ANTES ou NO dia do fechamento, cai no mês da fatura atual.
    Se foi feita DEPOIS do dia do fechamento, cai na fatura do mês seguinte.
    """
    dt = datetime.datetime.strptime(dia_compra_str, "%Y-%m-%d").date()
    ano = dt.year
    mes = dt.month
    
    if dt.day > dia_fechamento:
        # Pula para a fatura do mês seguinte
        if mes == 12:
            ano += 1
            mes = 1
        else:
            mes += 1
    return f"{ano:04d}-{mes:02d}"

def analisar_impacto_parcelas(cartao_id, valor_total, parcelas=1, data_compra=None, teto_mensal=400.0, renda_mensal=2234.0):
    """
    Analisa a viabilidade de uma compra parcelada simulando o impacto mês a mês.
    Verifica se a soma das parcelas existentes + nova parcela ultrapassa o teto de segurança.
    """
    if not data_compra:
        data_compra = str(date.today())
        
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT nome, dia_fechamento, dia_vencimento FROM cartoes WHERE id = ?", (cartao_id,))
    cartao = c.fetchone()
    if not cartao:
        conn.close()
        raise ValueError("Cartão não encontrado.")
        
    dia_fechamento = cartao['dia_fechamento']
    valor_parcela = round(valor_total / parcelas, 2)
    primeiro_mes = calcular_mes_fatura(data_compra, dia_fechamento)
    ano_fat, mes_fat = map(int, primeiro_mes.split('-'))
    
    meses_analise = []
    estourou = False
    maior_comprometimento = 0.0
    
    for p in range(1, parcelas + 1):
        m_curr = mes_fat + (p - 1)
        a_curr = ano_fat + (m_curr - 1) // 12
        m_curr = ((m_curr - 1) % 12) + 1
        mes_fatura_str = f"{a_curr:04d}-{m_curr:02d}"
        
        # Busca faturas futuras existentes de TODOS os cartões para este mês
        c.execute("""
            SELECT SUM(valor) FROM transacoes 
            WHERE cartao_id IS NOT NULL AND mes_fatura = ?
        """, (mes_fatura_str,))
        comp_atual = c.fetchone()[0] or 0.0
        
        novo_total = round(comp_atual + valor_parcela, 2)
        if novo_total > maior_comprometimento:
            maior_comprometimento = novo_total
            
        passou_do_teto = novo_total > teto_mensal
        if passou_do_teto:
            estourou = True
            
        pct_renda = round((novo_total / renda_mensal) * 100, 1)
        
        meses_analise.append({
            'parcela_num': p,
            'mes_fatura': mes_fatura_str,
            'comprometido_atual': comp_atual,
            'valor_parcela': valor_parcela,
            'novo_total': novo_total,
            'estourou': passou_do_teto,
            'pct_renda': pct_renda
        })
        
    conn.close()
    
    # Formatação visual do relatório
    linhas_relatorio = []
    linhas_relatorio.append(f"💳 Análise de Parcelamento: {cartao['nome']}")
    linhas_relatorio.append(f"💰 Valor Total: R$ {valor_total:,.2f} em {parcelas}x de R$ {valor_parcela:,.2f}")
    linhas_relatorio.append(f"🛡️ Teto de Segurança: R$ {teto_mensal:,.2f}/mês (~{round((teto_mensal/renda_mensal)*100)}% da renda de R$ {renda_mensal:,.2f})")
    linhas_relatorio.append("────────────────────────────────────────────────────────────────────────")
    
    for m in meses_analise:
        status_tag = "🚨 ESTOURO" if m['estourou'] else "✅ SEGURO"
        linhas_relatorio.append(
            f"  • Mês {m['mes_fatura']} (Parc {m['parcela_num']}/{parcelas}): "
            f"Atual R$ {m['comprometido_atual']:>6.2f} + R$ {m['valor_parcela']:>6.2f} = "
            f"Novo R$ {m['novo_total']:>6.2f} ({m['pct_renda']:>4.1f}% renda) [{status_tag}]"
        )
    linhas_relatorio.append("────────────────────────────────────────────────────────────────────────")
    
    if estourou:
        linhas_relatorio.append(f"⚠️ RISCO DETECTADO: O mês mais pesado atingirá R$ {maior_comprometimento:,.2f}, estourando o teto de R$ {teto_mensal:,.2f}!")
    else:
        linhas_relatorio.append(f"🎯 COMPRA 100% BLINDADA: Todas as parcelas ficam rigorosamente dentro da sua margem segura.")
        
    return {
        'viavel': not estourou,
        'cartao_nome': cartao['nome'],
        'valor_parcela': valor_parcela,
        'teto_mensal': teto_mensal,
        'maior_comprometimento': maior_comprometimento,
        'meses_analise': meses_analise,
        'relatorio': "\n".join(linhas_relatorio)
    }

def registrar_compra_cartao(cartao_id, data_compra, descricao, valor_total, categoria, parcelas=1):
    conn = get_connection()
    c = conn.cursor()
    
    c.execute("SELECT dia_fechamento, dia_vencimento FROM cartoes WHERE id = ?", (cartao_id,))
    cartao = c.fetchone()
    if not cartao:
        conn.close()
        raise ValueError("Cartão não encontrado.")
        
    dia_fechamento = cartao['dia_fechamento']
    dia_vencimento = cartao['dia_vencimento']
    
    # Identificador de grupo se parcelado
    grupo_id = f"PARC_{int(datetime.datetime.now().timestamp())}" if parcelas > 1 else None
    valor_parcela = round(valor_total / parcelas, 2)
    
    # Primeiro mês de fatura
    dt_base = datetime.datetime.strptime(data_compra, "%Y-%m-%d").date()
    primeiro_mes = calcular_mes_fatura(data_compra, dia_fechamento)
    ano_fat, mes_fat = map(int, primeiro_mes.split('-'))
    
    for p in range(1, parcelas + 1):
        # Mês da fatura desta parcela
        m_curr = mes_fat + (p - 1)
        a_curr = ano_fat + (m_curr - 1) // 12
        m_curr = ((m_curr - 1) % 12) + 1
        mes_fatura_str = f"{a_curr:04d}-{m_curr:02d}"
        
        # Garante registro da fatura
        c.execute("""
            INSERT OR IGNORE INTO faturas (cartao_id, mes_referencia, data_fechamento, data_vencimento, status)
            VALUES (?, ?, ?, ?, 'aberta')
        """, (
            cartao_id, 
            mes_fatura_str, 
            f"{a_curr:04d}-{m_curr:02d}-{dia_fechamento:02d}", 
            f"{a_curr:04d}-{m_curr:02d}-{dia_vencimento:02d}"
        ))
        
        desc_final = f"{descricao} ({p}/{parcelas})" if parcelas > 1 else descricao
        c.execute("""
            INSERT INTO transacoes (data, descricao, valor, tipo, categoria, cartao_id, mes_fatura, parcela_atual, total_parcelas, grupo_parcelamento_id)
            VALUES (?, ?, ?, 'despesa', ?, ?, ?, ?, ?, ?)
        """, (data_compra, desc_final, valor_parcela, categoria, cartao_id, mes_fatura_str, p, parcelas, grupo_id))
        
    conn.commit()
    conn.close()

def pagar_fatura(cartao_id, mes_referencia, conta_pagamento_id, data_pagamento=None):
    if not data_pagamento:
        data_pagamento = str(date.today())
        
    conn = get_connection()
    c = conn.cursor()
    # Verificar se fatura já foi paga
    c.execute("SELECT status, valor_pago FROM faturas WHERE cartao_id = ? AND mes_referencia = ?", (cartao_id, mes_referencia))
    fat_row = c.fetchone()
    if fat_row and fat_row['status'] == 'paga':
        conn.close()
        return 0.0, f"A fatura de {mes_referencia} já está PAGA (Valor: R$ {fat_row['valor_pago']:,.2f}). Operação rejeitada para evitar duplicidade."

    # Calcular total da fatura
    c.execute("""
        SELECT SUM(valor) as total FROM transacoes
        WHERE cartao_id = ? AND mes_fatura = ?
    """, (cartao_id, mes_referencia))
    total = c.fetchone()['total'] or 0.0
    
    if total <= 0:
        conn.close()
        return 0.0, "Fatura com valor zero ou vazia."
        
    # Desconta da conta
    c.execute("UPDATE contas SET saldo = saldo - ? WHERE id = ?", (total, conta_pagamento_id))
    
    # Atualiza fatura para paga
    c.execute("""
        UPDATE faturas SET status = 'paga', valor_pago = ?, data_pagamento = ?
        WHERE cartao_id = ? AND mes_referencia = ?
    """, (total, data_pagamento, cartao_id, mes_referencia))
    
    # Registra transação de pagamento
    c.execute("SELECT nome FROM cartoes WHERE id = ?", (cartao_id,))
    cartao_nome = c.fetchone()['nome']
    c.execute("""
        INSERT INTO transacoes (data, descricao, valor, tipo, categoria, conta_id)
        VALUES (?, ?, ?, 'fatura_cartao', 'Pagamento Fatura', ?)
    """, (data_pagamento, f"Pagamento Fatura {cartao_nome} ({mes_referencia})", total, conta_pagamento_id))
    
    conn.commit()
    conn.close()
    return total, "Fatura paga com sucesso!"

def reajustar_fatura_cartao(cartao_id, mes_referencia, novo_valor_total, motivo="Ajuste de Fatura"):
    """
    Reajusta o valor total de uma fatura de cartão para bater exatamente
    com o app do banco (ex: IOF, anuidade, taxas ou estornos esquecidos),
    gerando uma transação de conciliação vinculada à fatura.
    """
    conn = get_connection()
    c = conn.cursor()
    
    c.execute("SELECT nome, dia_fechamento, dia_vencimento FROM cartoes WHERE id = ?", (cartao_id,))
    cartao = c.fetchone()
    if not cartao:
        conn.close()
        raise ValueError("Cartão não encontrado.")
        
    c.execute("""
        SELECT COALESCE(SUM(valor), 0.0) as total FROM transacoes
        WHERE cartao_id = ? AND mes_fatura = ?
    """, (cartao_id, mes_referencia))
    total_atual = c.fetchone()['total'] or 0.0
    
    diferenca = round(novo_valor_total - total_atual, 2)
    if abs(diferenca) < 0.01:
        conn.close()
        return 0.0, "O valor informado já coincide com o total atual da fatura."
        
    ano, mes = map(int, mes_referencia.split("-"))
    c.execute("""
        INSERT OR IGNORE INTO faturas (cartao_id, mes_referencia, data_fechamento, data_vencimento, status)
        VALUES (?, ?, ?, ?, 'aberta')
    """, (
        cartao_id, mes_referencia,
        f"{ano:04d}-{mes:02d}-{cartao['dia_fechamento']:02d}",
        f"{ano:04d}-{mes:02d}-{cartao['dia_vencimento']:02d}"
    ))
    
    tipo_tx = 'despesa' if diferenca > 0 else 'estorno'
    desc_tx = f"{motivo}: {cartao['nome']} ({total_atual:,.2f} -> {novo_valor_total:,.2f})"
    
    c.execute("""
        INSERT INTO transacoes (data, descricao, valor, tipo, categoria, cartao_id, mes_fatura)
        VALUES (?, ?, ?, ?, 'Outros / Manobra', ?, ?)
    """, (str(date.today()), desc_tx, diferenca, tipo_tx, cartao_id, mes_referencia))
    
    conn.commit()
    conn.close()
    return diferenca, f"Fatura {mes_referencia} reajustada com sucesso! Diferença aplicada: R$ {diferenca:+,.2f}"


# ----------------------------------------------------------------------
# OPERAÇÕES COMPLETAS DE CRUD (CRIAR, EDITAR, DELETAR, RESTAURAR)
# ----------------------------------------------------------------------
def editar_transacao(transacao_id, descricao, valor, tipo, categoria, data_str):
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT valor, tipo, conta_id, cartao_id FROM transacoes WHERE id = ?", (transacao_id,))
    antiga = c.fetchone()
    if not antiga:
        conn.close()
        raise ValueError("Transação não encontrada.")
        
    # Se estava vinculada a conta bancária, recalcula o saldo
    if antiga['conta_id']:
        sinal_ant = 1.0 if antiga['tipo'] == 'receita' else -1.0
        c.execute("UPDATE contas SET saldo = saldo - ? WHERE id = ?", (sinal_ant * antiga['valor'], antiga['conta_id']))
        sinal_novo = 1.0 if tipo == 'receita' else -1.0
        c.execute("UPDATE contas SET saldo = saldo + ? WHERE id = ?", (sinal_novo * valor, antiga['conta_id']))
        
    c.execute("""
        UPDATE transacoes 
        SET descricao = ?, valor = ?, tipo = ?, categoria = ?, data = ?
        WHERE id = ?
    """, (descricao, valor, tipo, categoria, data_str, transacao_id))
    
    conn.commit()
    conn.close()
    return True

def deletar_transacao(transacao_id, deletar_todas_parcelas=False):
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT id, valor, tipo, conta_id, cartao_id, grupo_parcelamento_id FROM transacoes WHERE id = ?", (transacao_id,))
    tx = c.fetchone()
    if not tx:
        conn.close()
        return False, "Transação não encontrada."
        
    if deletar_todas_parcelas and tx['grupo_parcelamento_id']:
        c.execute("DELETE FROM transacoes WHERE grupo_parcelamento_id = ?", (tx['grupo_parcelamento_id'],))
        conn.commit()
        conn.close()
        return True, "Todas as parcelas da série foram deletadas com sucesso!"
        
    if tx['conta_id']:
        sinal_reverso = -1.0 if tx['tipo'] == 'receita' else 1.0
        c.execute("UPDATE contas SET saldo = saldo + ? WHERE id = ?", (sinal_reverso * tx['valor'], tx['conta_id']))
        
    c.execute("DELETE FROM transacoes WHERE id = ?", (transacao_id,))
    conn.commit()
    conn.close()
    return True, "Transação deletada e saldos restaurados com sucesso!"

# CRUD CONTAS
def criar_conta(nome, tipo, instituicao, saldo_inicial=0.0):
    conn = get_connection()
    c = conn.cursor()
    c.execute("INSERT INTO contas (nome, tipo, instituicao, saldo) VALUES (?, ?, ?, ?)", (nome, tipo, instituicao, saldo_inicial))
    cid = c.lastrowid
    conn.commit()
    conn.close()
    return cid

def editar_conta(conta_id, nome, tipo, instituicao, saldo):
    conn = get_connection()
    c = conn.cursor()
    c.execute("UPDATE contas SET nome = ?, tipo = ?, instituicao = ?, saldo = ? WHERE id = ?", (nome, tipo, instituicao, saldo, conta_id))
    conn.commit()
    conn.close()
    return True

def deletar_conta(conta_id):
    conn = get_connection()
    c = conn.cursor()
    c.execute("DELETE FROM transacoes WHERE conta_id = ?", (conta_id,))
    c.execute("DELETE FROM contas WHERE id = ?", (conta_id,))
    conn.commit()
    conn.close()
    return True

# CRUD CARTÕES
def criar_cartao(nome, instituicao, limite, dia_fechamento, dia_vencimento):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        INSERT INTO cartoes (nome, instituicao, limite, dia_fechamento, dia_vencimento, conta_pagamento_id)
        VALUES (?, ?, ?, ?, ?, 1)
    """, (nome, instituicao, limite, dia_fechamento, dia_vencimento))
    cid = c.lastrowid
    conn.commit()
    conn.close()
    return cid

def editar_cartao(cartao_id, nome, instituicao, limite, dia_fechamento, dia_vencimento):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        UPDATE cartoes 
        SET nome = ?, instituicao = ?, limite = ?, dia_fechamento = ?, dia_vencimento = ?
        WHERE id = ?
    """, (nome, instituicao, limite, dia_fechamento, dia_vencimento, cartao_id))
    conn.commit()
    conn.close()
    return True

def deletar_cartao(cartao_id):
    conn = get_connection()
    c = conn.cursor()
    c.execute("DELETE FROM transacoes WHERE cartao_id = ?", (cartao_id,))
    c.execute("DELETE FROM faturas WHERE cartao_id = ?", (cartao_id,))
    c.execute("DELETE FROM cartoes WHERE id = ?", (cartao_id,))
    conn.commit()
    conn.close()
    return True

# CRUD CAIXINHAS
def criar_caixinha(nome, descricao, meta_total, aporte_mensal, saldo_inicial=0.0, data_alvo=None):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        INSERT INTO caixinhas (nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (nome, descricao, meta_total, aporte_mensal, saldo_inicial, data_alvo))
    cid = c.lastrowid
    conn.commit()
    conn.close()
    return cid

def editar_caixinha(caixinha_id, nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        UPDATE caixinhas 
        SET nome = ?, descricao = ?, meta_total = ?, aporte_mensal = ?, saldo_atual = ?, data_alvo = ?
        WHERE id = ?
    """, (nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo, caixinha_id))
    conn.commit()
    conn.close()
    return True

def deletar_caixinha(caixinha_id):
    conn = get_connection()
    c = conn.cursor()
    c.execute("DELETE FROM transacoes WHERE caixinha_id = ?", (caixinha_id,))
    c.execute("DELETE FROM caixinhas WHERE id = ?", (caixinha_id,))
    c.execute("DELETE FROM aportes_planejados WHERE caixinha_id = ?", (caixinha_id,))
    conn.commit()
    conn.close()
    return True

def definir_aporte_planejado(mes_referencia, caixinha_id, valor, motivo=""):
    """
    Define ou altera o aporte planejado de uma caixinha para um mês específico.
    Permite modularidade total (ex: R$ 0,00 em Outubro e R$ 1.000,00 em Novembro).
    """
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        INSERT INTO aportes_planejados (mes_referencia, caixinha_id, valor, motivo)
        VALUES (?, ?, ?, ?)
        ON CONFLICT(mes_referencia, caixinha_id) DO UPDATE SET valor = excluded.valor, motivo = excluded.motivo
    """, (mes_referencia, caixinha_id, float(valor), motivo))
    conn.commit()
    conn.close()
    return True

def obter_aporte_planejado(mes_referencia, caixinha_id):
    """
    Obtém o aporte planejado para um mês específico.
    Se houver override configurado, retorna ele. Caso contrário, retorna o padrão da caixinha.
    """
    conn = get_connection()
    c = conn.cursor()
    try:
        c.execute("SELECT valor FROM aportes_planejados WHERE mes_referencia = ? AND caixinha_id = ?", (mes_referencia, caixinha_id))
        row = c.fetchone()
        if row is not None:
            val = row['valor']
            conn.close()
            return float(val)
    except Exception:
        pass
    c.execute("SELECT aporte_mensal FROM caixinhas WHERE id = ?", (caixinha_id,))
    cx = c.fetchone()
    conn.close()
    return float(cx['aporte_mensal']) if cx else 0.0

# CRUD RECORRÊNCIAS
def criar_recorrencia(descricao, valor, tipo, categoria, dia_vencimento=5):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        INSERT INTO recorrencias (descricao, valor, tipo, categoria, conta_id, dia_vencimento, ativo)
        VALUES (?, ?, ?, ?, 1, ?, 1)
    """, (descricao, valor, tipo, categoria, dia_vencimento))
    rid = c.lastrowid
    conn.commit()
    conn.close()
    return rid

def editar_recorrencia(rec_id, descricao, valor, tipo, categoria, dia_vencimento, ativo=1):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        UPDATE recorrencias 
        SET descricao = ?, valor = ?, tipo = ?, categoria = ?, dia_vencimento = ?, ativo = ?
        WHERE id = ?
    """, (descricao, valor, tipo, categoria, dia_vencimento, ativo, rec_id))
    conn.commit()
    conn.close()
    return True

def deletar_recorrencia(rec_id):
    conn = get_connection()
    c = conn.cursor()
    c.execute("DELETE FROM recorrencias WHERE id = ?", (rec_id,))
    conn.commit()
    conn.close()
    return True

# ----------------------------------------------------------------------
# CRUD WISHLIST (PLANO DE COMPRAS FUTURAS SEM ATRITO)
# ----------------------------------------------------------------------
def criar_item_wishlist(item, categoria, valor_estimado, parcelas_sugeridas=1, prioridade="Média", condicao_compra="", link_ou_obs=""):
    conn = get_connection()
    c = conn.cursor()
    dt_criacao = str(date.today())
    c.execute("""
        INSERT INTO wishlist (item, categoria, valor_estimado, parcelas_sugeridas, prioridade, condicao_compra, status, link_ou_obs, data_criacao)
        VALUES (?, ?, ?, ?, ?, ?, 'planejado', ?, ?)
    """, (item, categoria, float(valor_estimado), int(parcelas_sugeridas), prioridade, condicao_compra, link_ou_obs, dt_criacao))
    wid = c.lastrowid
    conn.commit()
    conn.close()
    return wid

def listar_wishlist(apenas_planejados=False):
    conn = get_connection()
    c = conn.cursor()
    if apenas_planejados:
        c.execute("SELECT * FROM wishlist WHERE status = 'planejado' ORDER BY CASE prioridade WHEN 'Estratégica' THEN 1 WHEN 'Alta' THEN 2 WHEN 'Média' THEN 3 ELSE 4 END, valor_estimado ASC")
    else:
        c.execute("SELECT * FROM wishlist ORDER BY CASE status WHEN 'planejado' THEN 1 WHEN 'comprado' THEN 2 ELSE 3 END, id DESC")
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

def editar_item_wishlist(item_id, item, categoria, valor_estimado, parcelas_sugeridas, prioridade, condicao_compra, status="planejado", link_ou_obs=""):
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        UPDATE wishlist 
        SET item = ?, categoria = ?, valor_estimado = ?, parcelas_sugeridas = ?, prioridade = ?, condicao_compra = ?, status = ?, link_ou_obs = ?
        WHERE id = ?
    """, (item, categoria, float(valor_estimado), int(parcelas_sugeridas), prioridade, condicao_compra, status, link_ou_obs, item_id))
    conn.commit()
    conn.close()
    return True

def deletar_item_wishlist(item_id):
    conn = get_connection()
    c = conn.cursor()
    c.execute("DELETE FROM wishlist WHERE id = ?", (item_id,))
    conn.commit()
    conn.close()
    return True

def efetivar_compra_wishlist(item_id, cartao_id=None, conta_id=None, data_compra=None, parcelas=None):
    """
    Transforma um item planejado da wishlist em compra real no banco (cartão ou conta)
    e atualiza seu status para 'comprado'.
    """
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT * FROM wishlist WHERE id = ?", (item_id,))
    w = c.fetchone()
    if not w:
        conn.close()
        raise ValueError("Item da wishlist não encontrado.")
    
    dt_compra = data_compra or str(date.today())
    parcs = parcelas if parcelas is not None else w['parcelas_sugeridas']
    desc = w['item']
    val = w['valor_estimado']
    cat = w['categoria']
    
    if cartao_id:
        registrar_compra_cartao(cartao_id, dt_compra, desc, val, cat, parcelas=parcs)
    elif conta_id:
        adicionar_transacao_conta(conta_id, dt_compra, desc, val, 'despesa', cat)
    else:
        # Default: primeiro cartão disponível
        c.execute("SELECT id FROM cartoes LIMIT 1")
        cid = c.fetchone()['id']
        registrar_compra_cartao(cid, dt_compra, desc, val, cat, parcelas=parcs)

    # Marca como comprado
    conn = get_connection()
    c = conn.cursor()
    c.execute("UPDATE wishlist SET status = 'comprado' WHERE id = ?", (item_id,))
    conn.commit()
    conn.close()
    return True

# ----------------------------------------------------------------------
# SNAPSHOTS MENSAIS & FECHAMENTO SELADO (HISTÓRICO IMUTÁVEL)
# ----------------------------------------------------------------------
def criar_snapshot_mensal(mes_referencia):
    """
    Tira um snapshot imutável de fechamento de mês, congelando os dados
    para histórico permanente (como no month_closing do Vesper).
    """
    conn = get_connection()
    c = conn.cursor()
    
    hud = get_survival_hud_metrics(mes_referencia)
    
    # Detalhamento de contas
    c.execute("SELECT nome, tipo, instituicao, saldo FROM contas")
    contas = [dict(r) for r in c.fetchall()]
    
    # Detalhamento de caixinhas
    c.execute("SELECT nome, meta_total, aporte_mensal, saldo_atual FROM caixinhas")
    caixinhas = [dict(r) for r in c.fetchall()]
    
    # Detalhamento de cartões e faturas
    c.execute("""
        SELECT k.nome, f.mes_referencia, f.status, f.valor_pago,
               COALESCE(SUM(t.valor), 0.0) as total_fatura
        FROM cartoes k
        LEFT JOIN faturas f ON (k.id = f.cartao_id AND f.mes_referencia = ?)
        LEFT JOIN transacoes t ON (k.id = t.cartao_id AND t.mes_fatura = ?)
        GROUP BY k.id
    """, (mes_referencia, mes_referencia))
    cartoes = [dict(r) for r in c.fetchall()]
    
    # Totais de receitas e despesas reais ocorridas no mês
    c.execute("""
        SELECT 
            COALESCE(SUM(CASE WHEN tipo = 'receita' THEN valor ELSE 0 END), 0.0) as receitas,
            COALESCE(SUM(CASE WHEN tipo = 'despesa' THEN valor ELSE 0 END), 0.0) as despesas,
            COALESCE(SUM(CASE WHEN tipo = 'fatura_cartao' THEN valor ELSE 0 END), 0.0) as faturas_pagas
        FROM transacoes
        WHERE data LIKE ?
    """, (f"{mes_referencia}%",))
    row_totais = c.fetchone()
    receitas_mes = row_totais['receitas']
    despesas_mes = row_totais['despesas']
    faturas_pagas_mes = row_totais['faturas_pagas']
    
    payload = {
        "mes_referencia": mes_referencia,
        "data_snapshot": str(date.today()),
        "hud": hud,
        "contas": contas,
        "caixinhas": caixinhas,
        "cartoes": cartoes,
        "receitas_mes": receitas_mes,
        "despesas_mes": despesas_mes,
        "faturas_pagas_mes": faturas_pagas_mes
    }
    
    c.execute("""
        INSERT OR REPLACE INTO monthly_snapshots (
            mes_referencia, data_snapshot, saldo_bancario_total, saldo_caixinhas_total,
            total_receitas, total_despesas, total_faturas_pagas, liquidez_liquida,
            teto_oxigenio, status, snapshot_json
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'selado', ?)
    """, (
        mes_referencia,
        str(date.today()),
        hud['saldo_bancario'],
        hud['saldo_caixinhas'],
        receitas_mes,
        despesas_mes,
        faturas_pagas_mes,
        hud['liquidez_liquida'],
        hud['teto_oxigenio_semanal'],
        json.dumps(payload)
    ))
    
    conn.commit()
    conn.close()
    return payload

def obter_snapshot_mensal(mes_referencia):
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT * FROM monthly_snapshots WHERE mes_referencia = ?", (mes_referencia,))
    row = c.fetchone()
    conn.close()
    if row:
        return dict(row)
    return None

def listar_snapshots_historicos():
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT mes_referencia, data_snapshot, saldo_bancario_total, saldo_caixinhas_total, liquidez_liquida, teto_oxigenio, status FROM monthly_snapshots ORDER BY mes_referencia DESC")
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

def get_transacoes_do_mes(mes_referencia):
    """
    Retorna com precisão absoluta as transações que pertencem ao mês especificado:
    - Transações diretas em conta ocorridas no mês (ex: 2026-09-XX)
    - Compras e parcelas de cartão de crédito cuja fatura é daquele mês (mes_fatura = '2026-09')
    """
    conn = get_connection()
    c = conn.cursor()
    c.execute("""
        SELECT t.id, t.data, t.descricao, t.valor, t.tipo, t.categoria,
               COALESCE(k.nome, c.nome, cx.nome, 'Geral') as origem,
               t.parcela_atual, t.total_parcelas, t.mes_fatura
        FROM transacoes t
        LEFT JOIN cartoes k ON t.cartao_id = k.id
        LEFT JOIN contas c ON t.conta_id = c.id
        LEFT JOIN caixinhas cx ON t.caixinha_id = cx.id
        WHERE (t.cartao_id IS NOT NULL AND t.mes_fatura = ?)
           OR (t.cartao_id IS NULL AND t.data LIKE ?)
        ORDER BY t.data DESC, t.id DESC
    """, (mes_referencia, f"{mes_referencia}%"))
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

# ----------------------------------------------------------------------
# APORTE EM CAIXINHAS E RENDIMENTO
# ----------------------------------------------------------------------
def realizar_aporte_caixinha(caixinha_id, conta_origem_id, valor, data_aporte=None):
    if not data_aporte:
        data_aporte = str(date.today())
        
    conn = get_connection()
    c = conn.cursor()
    
    # Desconta da conta
    c.execute("UPDATE contas SET saldo = saldo - ? WHERE id = ?", (valor, conta_origem_id))
    # Credita na caixinha
    c.execute("UPDATE caixinhas SET saldo_atual = saldo_atual + ? WHERE id = ?", (valor, caixinha_id))
    
    c.execute("SELECT nome FROM caixinhas WHERE id = ?", (caixinha_id,))
    cx_nome = c.fetchone()['nome']
    
    # Registra transação
    c.execute("""
        INSERT INTO transacoes (data, descricao, valor, tipo, categoria, conta_id, caixinha_id)
        VALUES (?, ?, ?, 'aporte_caixinha', 'Aporte Caixinha', ?, ?)
    """, (data_aporte, f"Aporte na Caixinha: {cx_nome}", valor, conta_origem_id, caixinha_id))
    
    conn.commit()
    conn.close()

def aplicar_rendimento_mensal_caixinhas():
    """Roda juros mensais sobre o saldo atual das caixinhas (ex: virada de mês)"""
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT id, nome, saldo_atual, taxa_mensal FROM caixinhas")
    caixinhas = c.fetchall()
    
    for cx in caixinhas:
        rendimento = round(cx['saldo_atual'] * cx['taxa_mensal'], 2)
        if rendimento > 0:
            c.execute("UPDATE caixinhas SET saldo_atual = saldo_atual + ? WHERE id = ?", (rendimento, cx['id']))
            c.execute("""
                INSERT INTO transacoes (data, descricao, valor, tipo, categoria, caixinha_id)
                VALUES (?, ?, ?, 'receita', 'Rendimento Caixinhas', ?)
            """, (str(date.today()), f"Rendimento CDI: {cx['nome']}", rendimento, cx['id']))
            
    conn.commit()
    conn.close()

# ----------------------------------------------------------------------
# SIMULAÇÃO & PROJEÇÃO DE 24 MESES
# ----------------------------------------------------------------------
def projetar_alforria(meses=22, aporte_mensal=1000.0, taxa_mensal=0.0095, bonus_13=2500.0):
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT id, saldo_atual, aporte_mensal FROM caixinhas WHERE nome LIKE '%Alforria%'")
    row = c.fetchone()
    saldo_inicial = row['saldo_atual'] if row else 1000.0
    cx_id = row['id'] if row else 1
    conn.close()
    
    projecao = []
    saldo = saldo_inicial
    dt_ref = date.today()
    
    for m in range(1, meses + 1):
        # Mês calendário futuro
        m_curr = dt_ref.month + m
        a_curr = dt_ref.year + (m_curr - 1) // 12
        m_curr = ((m_curr - 1) % 12) + 1
        label = f"{calendar.month_abbr[m_curr]}/{str(a_curr)[2:]}"
        mes_fatura_str = f"{a_curr:04d}-{m_curr:02d}"
        
        # Respeita o aporte planejado específico para este mês
        ap_mes = obter_aporte_planejado(mes_fatura_str, cx_id)
        
        rendimento = saldo * taxa_mensal
        extra = (bonus_13 / 2) if m_curr == 12 else 0.0
        saldo = saldo + rendimento + ap_mes + extra
        
        projecao.append({
            "mes_num": m,
            "mes_ano": label,
            "rendimento": round(rendimento, 2),
            "aporte": ap_mes,
            "extra": extra,
            "saldo": round(saldo, 2)
        })
    return projecao

# ----------------------------------------------------------------------
# INTELIGÊNCIA PREDITIVA & SURVIVAL HUD (INSPIRADO NO VESPER/FINANCE-IA)
# ----------------------------------------------------------------------
def adicionar_transacao_conta(conta_id, data_str, descricao, valor, tipo, categoria):
    """Adiciona receita ou despesa direta na conta e atualiza o saldo."""
    conn = get_connection()
    c = conn.cursor()
    fator = 1.0 if tipo == 'receita' else -1.0
    c.execute("UPDATE contas SET saldo = saldo + ? WHERE id = ?", (fator * valor, conta_id))
    c.execute("""
        INSERT INTO transacoes (data, descricao, valor, tipo, categoria, conta_id)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (data_str, descricao, valor, tipo, categoria, conta_id))
    conn.commit()
    conn.close()

def reconciliar_saldo(conta_id, novo_saldo, motivo="Ajuste de Conciliação"):
    """Reconcilia o saldo bancário com precisão e registra histórico."""
    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT saldo, nome FROM contas WHERE id = ?", (conta_id,))
    row = c.fetchone()
    if not row:
        conn.close()
        raise ValueError("Conta não encontrada.")
    saldo_antigo = row['saldo']
    diferenca = novo_saldo - saldo_antigo
    c.execute("UPDATE contas SET saldo = ? WHERE id = ?", (novo_saldo, conta_id))
    
    if abs(diferenca) > 0.001:
        tipo = 'receita' if diferenca > 0 else 'despesa'
        c.execute("""
            INSERT INTO transacoes (data, descricao, valor, tipo, categoria, conta_id)
            VALUES (?, ?, ?, ?, 'Outros / Manobra', ?)
        """, (str(date.today()), f"{motivo}: {row['nome']} ({saldo_antigo:,.2f} -> {novo_saldo:,.2f})", abs(diferenca), tipo, conta_id))
        
    conn.commit()
    conn.close()

def get_survival_hud_metrics(mes_ref=None):
    """
    Calcula as métricas soberanas do Survival HUD:
    - Liquidez Líquida Soberana (Ativos Líquidos - Dívidas Consolidadas de Cartão)
    - Teto de Oxigênio Semanal
    - Escudo de Liquidez & Tiers de Antifragilidade
    """
    if not mes_ref:
        mes_ref = date.today().strftime("%Y-%m")
        
    conn = get_connection()
    c = conn.cursor()
    
    # Saldos em conta
    c.execute("SELECT SUM(saldo) FROM contas")
    saldo_bancario = c.fetchone()[0] or 0.0
    
    # Saldos em caixinhas
    c.execute("SELECT SUM(saldo_atual) FROM caixinhas")
    saldo_caixinhas = c.fetchone()[0] or 0.0
    
    # Fatura atual aberta (todos os cartões no mês de referência)
    # Fatura atual aberta (que não foi paga ainda)
    c.execute("""
        SELECT COALESCE(SUM(t.valor), 0.0) FROM transacoes t
        LEFT JOIN faturas f ON (t.cartao_id = f.cartao_id AND t.mes_fatura = f.mes_referencia)
        WHERE t.cartao_id IS NOT NULL AND t.mes_fatura = ? AND COALESCE(f.status, 'aberta') != 'paga'
    """, (mes_ref,))
    fatura_atual_aberta = c.fetchone()[0] or 0.0
    
    # Parcelas futuras projetadas após o mês de referência
    c.execute("""
        SELECT COALESCE(SUM(t.valor), 0.0) FROM transacoes t
        LEFT JOIN faturas f ON (t.cartao_id = f.cartao_id AND t.mes_fatura = f.mes_referencia)
        WHERE t.cartao_id IS NOT NULL AND t.mes_fatura > ? AND COALESCE(f.status, 'aberta') != 'paga'
    """, (mes_ref,))
    parcelas_futuras = c.fetchone()[0] or 0.0
    
    divida_consolidada = fatura_atual_aberta + parcelas_futuras
    liquidez_liquida = saldo_bancario - divida_consolidada
    
    # Custos fixos mensais cadastrados nas recorrências
    c.execute("SELECT SUM(valor) FROM recorrencias WHERE tipo = 'despesa' AND ativo = 1")
    custo_fixo_mensal = c.fetchone()[0] or 0.0
    
    # Teto semanal de oxigênio (margem líquida disponível dividida por 4 semanas)
    sobra_imediata = saldo_bancario - fatura_atual_aberta
    teto_oxigenio_semanal = max(0.0, sobra_imediata / 4.0)
    
    # Meses de cobertura (Escudo de Liquidez)
    if custo_fixo_mensal > 0:
        meses_cobertura = round((saldo_bancario + saldo_caixinhas) / custo_fixo_mensal, 1)
    else:
        meses_cobertura = 99.0
        
    # Tier de Antifragilidade
    if liquidez_liquida < 0:
        health_tier = "Tier 0 • Zona de Risco (Crise de Crédito)"
        status_cor = "red"
    elif meses_cobertura < 3:
        health_tier = f"Tier 1 • Sobrevivente ({meses_cobertura}m de cobertura)"
        status_cor = "yellow"
    elif meses_cobertura < 6:
        health_tier = f"Tier 2 • Imune ({meses_cobertura}m de cobertura)"
        status_cor = "blue"
    else:
        health_tier = f"Tier 3 • Antifrágil ({meses_cobertura}m de cobertura)"
        status_cor = "green"
        
    conn.close()
    
    return {
        "mes_referencia": mes_ref,
        "saldo_bancario": saldo_bancario,
        "saldo_caixinhas": saldo_caixinhas,
        "total_ativos": saldo_bancario + saldo_caixinhas,
        "fatura_atual_aberta": fatura_atual_aberta,
        "parcelas_futuras": parcelas_futuras,
        "divida_consolidada": divida_consolidada,
        "liquidez_liquida": liquidez_liquida,
        "custo_fixo_mensal": custo_fixo_mensal,
        "teto_oxigenio_semanal": teto_oxigenio_semanal,
        "meses_cobertura": meses_cobertura,
        "health_tier": health_tier,
        "status_cor": status_cor
    }

def get_time_machine_projection(meses=12, data_base=None):
    """
    Projeção cronológica mês a mês (Time Machine) integrando:
    - Saldo inicial
    - Recorrências ativas (Salário, Carnes, Moto, Psiquiatria, Barbeiro, Presença)
    - Faturas e parcelas reais programadas em cada mês
    - Saldo projetado final e teto de oxigênio de cada mês
    """
    if not data_base:
        data_base = date.today()
        
    conn = get_connection()
    c = conn.cursor()
    
    # Saldo bancário inicial
    c.execute("SELECT SUM(saldo) FROM contas")
    saldo_atual = c.fetchone()[0] or 0.0
    
    # Recorrências
    c.execute("SELECT SUM(valor) FROM recorrencias WHERE tipo = 'receita' AND ativo = 1")
    receita_recorrente = c.fetchone()[0] or 0.0
    c.execute("SELECT SUM(valor) FROM recorrencias WHERE tipo = 'despesa' AND ativo = 1")
    despesa_recorrente = c.fetchone()[0] or 0.0
    
    projection = []
    saldo_corrente = saldo_atual
    ano_base = data_base.year
    mes_base = data_base.month
    
    for i in range(meses):
        m_calc = mes_base + i
        a_calc = ano_base + (m_calc - 1) // 12
        m_calc = ((m_calc - 1) % 12) + 1
        mes_fatura_key = f"{a_calc:04d}-{m_calc:02d}"
        
        # Fatura de cartão com parcelas já programadas para este mês (não pagas)
        c.execute("""
            SELECT COALESCE(SUM(t.valor), 0.0) FROM transacoes t
            LEFT JOIN faturas f ON (t.cartao_id = f.cartao_id AND t.mes_fatura = f.mes_referencia)
            WHERE t.cartao_id IS NOT NULL AND t.mes_fatura = ? AND COALESCE(f.status, 'aberta') != 'paga'
        """, (mes_fatura_key,))
        fatura_mes = c.fetchone()[0] or 0.0
        
        saldo_inicial_mes = saldo_corrente
        sobra_mes = receita_recorrente - despesa_recorrente - fatura_mes
        saldo_final_mes = saldo_inicial_mes + sobra_mes
        teto_oxigenio = max(0.0, saldo_final_mes / 4.0)
        
        projection.append({
            "index": i,
            "mes_ano": mes_fatura_key,
            "label": f"{calendar.month_abbr[m_calc]}/{str(a_calc)[2:]}",
            "saldo_inicial": round(saldo_inicial_mes, 2),
            "receitas": round(receita_recorrente, 2),
            "despesas_fixas": round(despesa_recorrente, 2),
            "fatura_cartao": round(fatura_mes, 2),
            "saldo_final": round(saldo_final_mes, 2),
            "teto_semanal": round(teto_oxigenio, 2)
        })
        saldo_corrente = saldo_final_mes
        
    conn.close()
    return projection

def simular_impacto_compra(valor_total, parcelas=1, tipo='cartao', cartao_id=1, data_inicio=None):
    """
    Simula uma compra (Time Machine Sandbox) e compara a curva de fluxo de caixa
    original vs. impactada pela nova compra nos próximos 12 meses.
    """
    baseline = get_time_machine_projection(meses=12, data_base=data_inicio)
    simulado = []
    
    valor_parcela = round(valor_total / parcelas, 2)
    
    menor_saldo = 999999.0
    mes_menor_folga = ""
    violou_reserva = False
    
    for i, base in enumerate(baseline):
        mes_dict = dict(base)
        impacto_neste_mes = 0.0
        
        if tipo == 'cartao':
            # Impacta da parcela 1 até 'parcelas'
            if i < parcelas:
                impacto_neste_mes = valor_parcela
        else:
            # À vista na conta impacta no mês 0
            if i == 0:
                impacto_neste_mes = valor_total
                
        # Recalcular saldos com o impacto acumulado
        if i == 0:
            mes_dict["fatura_cartao"] = round(base["fatura_cartao"] + (impacto_neste_mes if tipo == 'cartao' else 0.0), 2)
            mes_dict["saldo_final"] = round(base["saldo_final"] - impacto_neste_mes, 2)
        else:
            saldo_ant_sim = simulado[i-1]["saldo_final"]
            mes_dict["saldo_inicial"] = saldo_ant_sim
            mes_dict["fatura_cartao"] = round(base["fatura_cartao"] + (impacto_neste_mes if tipo == 'cartao' else 0.0), 2)
            sobra_mes = mes_dict["receitas"] - mes_dict["despesas_fixas"] - mes_dict["fatura_cartao"]
            mes_dict["saldo_final"] = round(saldo_ant_sim + sobra_mes, 2)
            
        mes_dict["teto_semanal"] = max(0.0, round(mes_dict["saldo_final"] / 4.0, 2))
        simulado.append(mes_dict)
        
        if mes_dict["saldo_final"] < menor_saldo:
            menor_saldo = mes_dict["saldo_final"]
            mes_menor_folga = mes_dict["label"]
            
        if mes_dict["saldo_final"] < 0:
            violou_reserva = True
            
    if violou_reserva:
        veredicto = "PERIGO • Quebra de liquidez no período!"
        status = "danger"
    elif menor_saldo < 100.0:
        veredicto = f"ATENÇÃO • Margem apertada em {mes_menor_folga} (R$ {menor_saldo:,.2f})"
        status = "warning"
    else:
        veredicto = f"SEGURO • Fluxo de caixa absorve confortavelmente (Folga mín: R$ {menor_saldo:,.2f})"
        status = "safe"
        
    return {
        "valor_total": valor_total,
        "parcelas": parcelas,
        "valor_parcela": valor_parcela,
        "veredicto": veredicto,
        "status": status,
        "menor_saldo": menor_saldo,
        "mes_menor_folga": mes_menor_folga,
        "baseline": baseline,
        "simulado": simulado
    }

def efetivar_simulacao(descricao, valor_total, parcelas=1, tipo='cartao', cartao_id=1, conta_id=1, categoria="Outros / Manobra"):
    """Converte instantaneamente a simulação em compra real no banco de dados."""
    data_hoje = str(date.today())
    if tipo == 'cartao':
        registrar_compra_cartao(cartao_id, data_hoje, descricao, valor_total, categoria, parcelas=parcelas)
    else:
        adicionar_transacao_conta(conta_id, data_hoje, descricao, valor_total, 'despesa', categoria)

# ----------------------------------------------------------------------
# EXPORTAÇÃO EXCEL (.XLSX) PROFISSIONAL
# ----------------------------------------------------------------------
def exportar_para_excel(filepath=None):
    if not filepath:
        filepath = os.path.expanduser("~/Planilha_Alforria_Homem_Rocha.xlsx")
        
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
    from openpyxl.utils import get_column_letter

    wb = openpyxl.Workbook()
    
    # ------------------ ABA 1: RESUMO DO COCKPIT ------------------
    ws1 = wb.active
    ws1.title = "Cockpit & Saldos"
    ws1.views.sheetView[0].showGridLines = True
    
    # Cores de paleta executiva
    c_header_fill = PatternFill(start_color="1E293B", end_color="1E293B", fill_type="solid")
    c_header_font = Font(name="Segoe UI", size=11, bold=True, color="FFFFFF")
    c_sub_fill = PatternFill(start_color="F1F5F9", end_color="F1F5F9", fill_type="solid")
    c_bold = Font(name="Segoe UI", size=10, bold=True)
    c_regular = Font(name="Segoe UI", size=10)
    c_green = Font(name="Segoe UI", size=10, bold=True, color="047857")
    c_gold = Font(name="Segoe UI", size=10, bold=True, color="B45309")
    thin_border = Border(
        left=Side(style='thin', color='E2E8F0'),
        right=Side(style='thin', color='E2E8F0'),
        top=Side(style='thin', color='E2E8F0'),
        bottom=Side(style='thin', color='E2E8F0')
    )

    ws1['A1'] = "COCKPIT FINANCEIRO HOMEM ROCHA — ALFORRIA 2026-2028"
    ws1['A1'].font = Font(name="Segoe UI", size=14, bold=True, color="FFFFFF")
    ws1['A1'].fill = c_header_fill
    ws1.merge_cells('A1:E1')
    ws1.row_dimensions[1].height = 30
    ws1['A1'].alignment = Alignment(vertical="center", horizontal="left")

    conn = get_connection()
    c = conn.cursor()
    
    # Tabela Contas
    ws1['A3'] = "CONTAS & DISPONIBILIDADE IMEDIATA"
    ws1['A3'].font = Font(name="Segoe UI", size=11, bold=True, color="0F172A")
    headers_contas = ["ID", "Conta", "Instituição", "Tipo", "Saldo Atual (R$)"]
    for col_idx, h in enumerate(headers_contas, start=1):
        cell = ws1.cell(row=4, column=col_idx, value=h)
        cell.font = c_header_font
        cell.fill = c_header_fill
        cell.alignment = Alignment(horizontal="center" if col_idx != 2 else "left")

    c.execute("SELECT id, nome, instituicao, tipo, saldo FROM contas")
    row_num = 5
    for row in c.fetchall():
        ws1.cell(row=row_num, column=1, value=row['id']).alignment = Alignment(horizontal="center")
        ws1.cell(row=row_num, column=2, value=row['nome']).font = c_bold
        ws1.cell(row=row_num, column=3, value=row['instituicao'])
        ws1.cell(row=row_num, column=4, value=row['tipo'].title())
        val_cell = ws1.cell(row=row_num, column=5, value=row['saldo'])
        val_cell.number_format = '"R$" #,##0.00'
        val_cell.font = c_green if row['saldo'] >= 0 else Font(name="Segoe UI", size=10, bold=True, color="B91C1C")
        for col in range(1, 6):
            ws1.cell(row=row_num, column=col).border = thin_border
        row_num += 1

    # Tabela Caixinhas
    row_num += 2
    ws1.cell(row=row_num, column=1, value="CAIXINHAS NUBANK & METAS DE PATRIMÔNIO").font = Font(name="Segoe UI", size=11, bold=True, color="0F172A")
    row_num += 1
    headers_cx = ["Caixinha", "Meta Total (R$)", "Aporte Mensal (R$)", "Saldo Atual (R$)", "Data Alvo"]
    for col_idx, h in enumerate(headers_cx, start=1):
        cell = ws1.cell(row=row_num, column=col_idx, value=h)
        cell.font = c_header_font
        cell.fill = PatternFill(start_color="0F766E", end_color="0F766E", fill_type="solid")
        cell.alignment = Alignment(horizontal="center" if col_idx > 1 else "left")

    c.execute("SELECT nome, meta_total, aporte_mensal, saldo_atual, data_alvo FROM caixinhas")
    row_num += 1
    for row in c.fetchall():
        ws1.cell(row=row_num, column=1, value=row['nome']).font = c_bold
        c2 = ws1.cell(row=row_num, column=2, value=row['meta_total'])
        c2.number_format = '"R$" #,##0.00'
        c3 = ws1.cell(row=row_num, column=3, value=row['aporte_mensal'])
        c3.number_format = '"R$" #,##0.00'
        c4 = ws1.cell(row=row_num, column=4, value=row['saldo_atual'])
        c4.number_format = '"R$" #,##0.00'
        c4.font = c_gold
        ws1.cell(row=row_num, column=5, value=row['data_alvo']).alignment = Alignment(horizontal="center")
        for col in range(1, 6):
            ws1.cell(row=row_num, column=col).border = thin_border
        row_num += 1

    # ------------------ ABA 2: TRANSAÇÕES & HISTÓRICO ------------------
    ws2 = wb.create_sheet(title="Histórico de Transações")
    ws2.views.sheetView[0].showGridLines = True
    headers_tx = ["ID", "Data", "Descrição", "Tipo", "Categoria", "Valor (R$)", "Conta/Cartão", "Fatura Ref."]
    for col_idx, h in enumerate(headers_tx, start=1):
        cell = ws2.cell(row=1, column=col_idx, value=h)
        cell.font = c_header_font
        cell.fill = c_header_fill
        cell.alignment = Alignment(horizontal="center" if col_idx in [1, 2, 4, 8] else "left")

    c.execute("""
        SELECT t.id, t.data, t.descricao, t.tipo, t.categoria, t.valor,
               COALESCE(c.nome, k.nome, cx.nome, 'Geral') as origem,
               t.mes_fatura
        FROM transacoes t
        LEFT JOIN contas c ON t.conta_id = c.id
        LEFT JOIN cartoes k ON t.cartao_id = k.id
        LEFT JOIN caixinhas cx ON t.caixinha_id = cx.id
        ORDER BY t.data DESC, t.id DESC
    """)
    r_tx = 2
    for r in c.fetchall():
        ws2.cell(row=r_tx, column=1, value=r['id']).alignment = Alignment(horizontal="center")
        ws2.cell(row=r_tx, column=2, value=r['data']).alignment = Alignment(horizontal="center")
        ws2.cell(row=r_tx, column=3, value=r['descricao']).font = c_regular
        ws2.cell(row=r_tx, column=4, value=r['tipo'].upper()).alignment = Alignment(horizontal="center")
        ws2.cell(row=r_tx, column=5, value=r['categoria'] or '-')
        val = ws2.cell(row=r_tx, column=6, value=r['valor'])
        val.number_format = '"R$" #,##0.00'
        if r['tipo'] == 'receita':
            val.font = c_green
        else:
            val.font = Font(name="Segoe UI", size=10, color="B91C1C")
        ws2.cell(row=r_tx, column=7, value=r['origem'])
        ws2.cell(row=r_tx, column=8, value=r['mes_fatura'] or '-').alignment = Alignment(horizontal="center")
        for col in range(1, 9):
            ws2.cell(row=r_tx, column=col).border = thin_border
        r_tx += 1

    # ------------------ ABA 3: PROJEÇÃO 22 MESES (ALFORRIA) ------------------
    ws3 = wb.create_sheet(title="Projeção 22 Meses (Ago-2028)")
    ws3.views.sheetView[0].showGridLines = True
    headers_proj = ["Mês", "Mês / Ano", "Aporte Sagrado (R$)", "Rendimento CDI (R$)", "Bônus 13º (R$)", "Saldo Acumulado (R$)"]
    for col_idx, h in enumerate(headers_proj, start=1):
        cell = ws3.cell(row=1, column=col_idx, value=h)
        cell.font = c_header_font
        cell.fill = PatternFill(start_color="B45309", end_color="B45309", fill_type="solid")
        cell.alignment = Alignment(horizontal="center" if col_idx in [1, 2] else "right")

    proj_dados = projetar_alforria(meses=22)
    r_pr = 2
    for p in proj_dados:
        ws3.cell(row=r_pr, column=1, value=f"Mês {p['mes_num']:02d}").alignment = Alignment(horizontal="center")
        ws3.cell(row=r_pr, column=2, value=p['mes_ano']).alignment = Alignment(horizontal="center")
        c3 = ws3.cell(row=r_pr, column=3, value=p['aporte'])
        c3.number_format = '"R$" #,##0.00'
        c4 = ws3.cell(row=r_pr, column=4, value=p['rendimento'])
        c4.number_format = '"R$" #,##0.00'
        c4.font = c_green
        c5 = ws3.cell(row=r_pr, column=5, value=p['extra'])
        c5.number_format = '"R$" #,##0.00'
        c6 = ws3.cell(row=r_pr, column=6, value=p['saldo'])
        c6.number_format = '"R$" #,##0.00'
        c6.font = Font(name="Segoe UI", size=10, bold=True, color="1E3A8A")
        for col in range(1, 7):
            ws3.cell(row=r_pr, column=col).border = thin_border
        r_pr += 1

    # Autoajuste de largura de colunas
    for ws in [ws1, ws2, ws3]:
        for col in ws.columns:
            max_len = max(len(str(cell.value or '')) for cell in col)
            col_letter = get_column_letter(col[0].column)
            ws.column_dimensions[col_letter].width = max(max_len + 3, 12)

    wb.save(filepath)
    conn.close()
    return filepath

# ----------------------------------------------------------------------
# BACKUP ATÔMICO & RESTAURAÇÃO (ONLINE SQLITE SNAPSHOT)
# ----------------------------------------------------------------------
def fazer_backup(destino_dir=None):
    """
    Realiza backup online seguro e atômico do SQLite (zero lock contention).
    Gera snapshot com timestamp no diretório padrão ~/backups/finance/
    e também salva a planilha Excel sincronizada.
    """
    import shutil
    from datetime import datetime
    
    if not destino_dir:
        destino_dir = os.path.expanduser("~/backups/finance")
    os.makedirs(destino_dir, exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y-%m-%d_%H%M%S")
    db_backup_file = os.path.join(destino_dir, f"finance_backup_{timestamp}.db")
    
    # 1. Backup online nativo do SQLite (consistência total mesmo com app em execução)
    source_conn = get_connection()
    dest_conn = sqlite3.connect(db_backup_file)
    source_conn.backup(dest_conn)
    dest_conn.close()
    source_conn.close()
    
    # 2. Exportar Excel correspondente ao ponto no tempo
    excel_backup_file = os.path.join(destino_dir, f"finance_backup_{timestamp}.xlsx")
    exportar_para_excel(excel_backup_file)
    
    # 3. Se existir diretório privado no Google Drive ou /mnt/dados, espelha lá também
    mirror_dirs = [
        os.path.expanduser("~/drive-organizacao/01_Pessoal_e_Vida/Backups/Finance"),
        "/mnt/dados/01_Pessoal_e_Vida/Backups/Finance"
    ]
    mirrors_saved = []
    for md in mirror_dirs:
        if os.path.isdir(os.path.dirname(md)):
            try:
                os.makedirs(md, exist_ok=True)
                shutil.copy2(db_backup_file, os.path.join(md, f"finance_backup_{timestamp}.db"))
                shutil.copy2(excel_backup_file, os.path.join(md, f"finance_backup_{timestamp}.xlsx"))
                mirrors_saved.append(md)
            except Exception:
                pass

    return {
        "timestamp": timestamp,
        "db_file": db_backup_file,
        "excel_file": excel_backup_file,
        "mirrors": mirrors_saved
    }

def restaurar_backup(db_backup_file):
    """
    Restaura o banco a partir de um arquivo .db de backup,
    gerando um backup de segurança do estado atual antes da substituição.
    """
    import shutil
    if not os.path.exists(db_backup_file):
        raise FileNotFoundError(f"Arquivo de backup não encontrado: {db_backup_file}")
        
    # Backup de segurança antes da restauração
    fazer_backup()
    
    # Restaura o banco principal
    shutil.copy2(db_backup_file, DB_PATH)
    return True

def exportar_contexto_ia(base_dir="/mnt/dados/01_Pessoal_e_Vida/01.5_Financas_e_Contas/Apex_Contexto_IA"):
    """
    Exporta todo o contexto financeiro consolidado em arquivos Markdown legíveis por IA,
    estruturados hierarquicamente em /mnt/dados por anos e meses:
    - CONTEXTO_GLOBAL.md (Visão geral de regras, contas, cartões, metas da Alforria e próximos 24 meses)
    - YYYY/YYYY-MM.md (Extrato cirúrgico detalhado de cada mês: depois das contas, faturas, fixos e transações)
    """
    os.makedirs(base_dir, exist_ok=True)
    conn = get_connection()
    c = conn.cursor()

    hoje_dt = date.today()
    hoje_str = str(hoje_dt)
    mes_atual = hoje_str[:7]

    # 1. Obter dados de Contas
    c.execute("SELECT id, nome, tipo, instituicao, saldo FROM contas ORDER BY id")
    contas = c.fetchall()

    # 2. Obter dados de Cartões
    c.execute("SELECT id, nome, instituicao, limite, dia_fechamento, dia_vencimento FROM cartoes ORDER BY id")
    cartoes = c.fetchall()

    # 3. Obter Caixinhas
    c.execute("SELECT id, nome, descricao, meta_total, aporte_mensal, saldo_atual, data_alvo, tipo_rendimento FROM caixinhas ORDER BY id")
    caixinhas = c.fetchall()

    # 4. Obter Recorrências Fixas
    c.execute("SELECT id, descricao, valor, tipo, categoria, dia_vencimento, ativo FROM recorrencias ORDER BY dia_vencimento")
    recorrencias = c.fetchall()

    # 5. Gerar CONTEXTO_GLOBAL.md
    global_md = []
    global_md.append("# 🏛️ APEX FINANCE — CONTEXTO ESTRATÉGICO GLOBAL (AUDITORIA IA)")
    global_md.append(f"> **Última Atualização:** `{hoje_str}` | **Mês Ativo de Referência:** `{mes_atual}`")
    global_md.append("> **Regras Inegociáveis:** Renda AGR R$ 2.234 (+ 13º em Nov/Dez) | Meta Alforria 2028: R$ 27k a R$ 30k (115% CDI).\n")

    global_md.append("## 1. 🏦 SALDOS BANCÁRIOS & LIQUIDEZ IMEDIATA")
    total_bancos = 0.0
    for ct in contas:
        total_bancos += ct['saldo']
        global_md.append(f"- **{ct['nome']}** ({ct['instituicao']}): `R$ {ct['saldo']:,.2f}` [{ct['tipo']}]")
    global_md.append(f"**Total Líquido em Bancos:** `R$ {total_bancos:,.2f}`\n")

    global_md.append("## 2. 🏰 CAIXINHAS DE METAS & PATRIMÔNIO")
    total_caixinhas = 0.0
    for cx in caixinhas:
        total_caixinhas += cx['saldo_atual']
        pct = (cx['saldo_atual'] / cx['meta_total'] * 100) if cx['meta_total'] > 0 else 0
        global_md.append(f"- **{cx['nome']}**")
        global_md.append(f"  - Saldo Atual: `R$ {cx['saldo_atual']:,.2f}` / Meta: `R$ {cx['meta_total']:,.2f}` ({pct:.1f}%)")
        global_md.append(f"  - Aporte Padrão: `R$ {cx['aporte_mensal']:,.2f}/mês` | Alvo: `{cx['data_alvo']}` | Rendimento: `{cx['tipo_rendimento']}`")
    global_md.append(f"**Total Acumulado em Caixinhas:** `R$ {total_caixinhas:,.2f}`\n")

    global_md.append("## 3. 💳 CARTÕES DE CRÉDITO & LIMITES")
    for cr in cartoes:
        cid = cr['id']
        c.execute("""
            SELECT COALESCE(SUM(t.valor), 0.0)
            FROM transacoes t
            LEFT JOIN faturas f ON (f.cartao_id = t.cartao_id AND f.mes_referencia = t.mes_fatura)
            WHERE t.cartao_id = ? AND (f.status IS NULL OR f.status != 'paga')
        """, (cid,))
        devido = c.fetchone()[0] or 0.0
        disp = max(0.0, cr['limite'] - devido)
        global_md.append(f"- **{cr['nome']}** ({cr['instituicao']}):")
        global_md.append(f"  - Limite Total: `R$ {cr['limite']:,.2f}` | Comprometido Total: `R$ {devido:,.2f}` | Disponível: `R$ {disp:,.2f}`")
        global_md.append(f"  - Fechamento: Dia {cr['dia_fechamento']:02d} | Vencimento: Dia {cr['dia_vencimento']:02d}")
    global_md.append("")

    global_md.append("## 4. 🔁 CUSTOS FIXOS & PROVISÃO MENSAL")
    total_fixos = 0.0
    for r in recorrencias:
        if r['ativo'] == 1 and r['tipo'] == 'despesa' and 'Alforria' not in r['descricao']:
            total_fixos += r['valor']
        st_txt = "Ativo" if r['ativo'] == 1 else "Pausado"
        global_md.append(f"- `{r['descricao']}`: `R$ {r['valor']:,.2f}` (Dia {r['dia_vencimento']:02d}) [{r['categoria']}] — *{st_txt}*")
    global_md.append(f"**Total Custos Fixos Operacionais:** `R$ {total_fixos:,.2f}/mês`\n")

    global_md.append("## 5. 🔮 RADIOGRAFIA 'DEPOIS DAS CONTAS' (PRÓXIMOS 12 MESES)")
    global_md.append("| Mês | Renda Prevista | Faturas Cartão | Custos Fixos | Aporte Alforria | Sobra Livre | Status |")
    global_md.append("| :--- | :--- | :--- | :--- | :--- | :--- | :--- |")

    ano_cur, m_cur = 2026, 9
    for _ in range(16):
        mes_k = f"{ano_cur:04d}-{m_cur:02d}"
        renda_k = 2234.0 + (1100.0 if m_cur in [11, 12] else 0.0)
        
        c.execute("SELECT COALESCE(SUM(valor), 0.0) FROM transacoes WHERE mes_fatura = ?", (mes_k,))
        fats_k = c.fetchone()[0] or 0.0
        
        ap_k = obter_aporte_planejado(mes_k, 1)
        total_saidas_k = fats_k + total_fixos + ap_k
        sobra_k = renda_k - total_saidas_k
        
        if sobra_k >= 200:
            status_k = "🟢 Confortável"
        elif sobra_k >= 0:
            status_k = "🟡 Apertado"
        else:
            status_k = "🔴 Déficit"

        obs_ap = f"R$ {ap_k:,.2f}" if ap_k > 0 else "R$ 0,00 (Pausado)"
        global_md.append(f"| `{mes_k}` | R$ {renda_k:,.2f} | R$ {fats_k:,.2f} | R$ {total_fixos:,.2f} | {obs_ap} | **R$ {sobra_k:,.2f}** | {status_k} |")

        m_cur += 1
        if m_cur > 12:
            m_cur = 1
            ano_cur += 1

    # Wishlist / Plano de Compras Futuras
    c.execute("SELECT * FROM wishlist ORDER BY CASE status WHEN 'planejado' THEN 1 ELSE 2 END, id ASC")
    wishes = c.fetchall()
    global_md.append("\n## 6. 🎯 WISHLIST & COMPRAS FUTURAS PLANEJADAS")
    if not wishes:
        global_md.append("- *Nenhum item em espera no radar de compras.*")
    else:
        for w in wishes:
            st_icon = "⏳ [Planejado]" if w['status'] == 'planejado' else ("✅ [Comprado]" if w['status'] == 'comprado' else "❌ [Cancelado]")
            parc_str = f"em até {w['parcelas_sugeridas']}x" if w['parcelas_sugeridas'] > 1 else "à vista"
            global_md.append(f"- **{w['item']}** ({w['categoria']}): `R$ {w['valor_estimado']:,.2f}` ({parc_str})")
            global_md.append(f"  - Prioridade: `{w['prioridade']}` | Condição: *{w['condicao_compra']}* | Status: {st_icon}")
            if w['link_ou_obs']:
                global_md.append(f"  - Obs: {w['link_ou_obs']}")
    global_md.append("")

    global_file = os.path.join(base_dir, "CONTEXTO_GLOBAL.md")
    with open(global_file, "w", encoding="utf-8") as f:
        f.write("\n".join(global_md))

    # 6. Gerar arquivos por Mês em subdiretórios por Ano (Ex: 2026/2026-09.md, 2026/2026-10.md)
    ano_cur, m_cur = 2026, 9
    meses_gerados = []
    for _ in range(24):
        mes_k = f"{ano_cur:04d}-{m_cur:02d}"
        ano_dir = os.path.join(base_dir, str(ano_cur))
        os.makedirs(ano_dir, exist_ok=True)
        mes_file = os.path.join(ano_dir, f"{mes_k}.md")

        renda_k = 2234.0 + (1100.0 if m_cur in [11, 12] else 0.0)
        desc_renda = "Salário AGR" + (" + Parcela 13º" if m_cur in [11, 12] else "")

        c.execute("""
            SELECT k.nome, k.dia_vencimento, SUM(t.valor)
            FROM transacoes t
            JOIN cartoes k ON t.cartao_id = k.id
            WHERE t.mes_fatura = ?
            GROUP BY k.nome, k.dia_vencimento
        """, (mes_k,))
        fats_mes = c.fetchall()
        total_fats_mes = sum(f[2] for f in fats_mes) if fats_mes else 0.0

        ap_mes = obter_aporte_planejado(mes_k, 1)
        total_saidas_mes = total_fats_mes + total_fixos + ap_mes
        sobra_mes = renda_k - total_saidas_mes

        # Transações detalhadas do mês
        txs = get_transacoes_do_mes(mes_k)

        m_md = []
        m_md.append(f"# 📅 EXTRATO & DIAGNÓSTICO FINANCEIRO: `{mes_k}`")
        m_md.append(f"> **Status do Mês:** `{'ATIVO' if mes_k == mes_atual else ('PASSADO' if mes_k < mes_atual else 'PROJEÇÃO')}`")
        m_md.append(f"> **Gerado em:** `{hoje_str}`\n")

        m_md.append("## 1. 💰 BALANÇO 'DEPOIS DAS CONTAS'")
        m_md.append(f"- **Renda Líquida Prevista:** `R$ {renda_k:,.2f}` ({desc_renda})")
        m_md.append(f"- **Faturas de Cartões:** `R$ {total_fats_mes:,.2f}`")
        m_md.append(f"- **Despesas Fixas & Provisão:** `R$ {total_fixos:,.2f}`")
        m_md.append(f"- **Aporte Alforria Programado:** `R$ {ap_mes:,.2f}`" + (" *(Pausado)*" if ap_mes == 0 else ""))
        m_md.append(f"- **Total Obrigações & Aporte:** `R$ {total_saidas_mes:,.2f}`")
        m_md.append(f"- **💸 SOBRA LIVRE ('DEPOIS DAS CONTAS'):** `R$ {sobra_mes:,.2f}`\n")

        m_md.append("## 2. 💳 DETALHAMENTO DAS FATURAS")
        if not fats_mes:
            m_md.append("- *Zero faturas programadas para este mês.*")
        else:
            for f_row in fats_mes:
                m_md.append(f"- **{f_row[0]}** (Vencimento dia {f_row[1]:02d}): `R$ {f_row[2]:,.2f}`")
        m_md.append("")

        m_md.append("## 3. 📜 LANÇAMENTOS E TRANSAÇÕES DO MÊS")
        if not txs:
            m_md.append("- *Nenhuma transação individual registrada.*")
        else:
            m_md.append("| ID | Data | Descrição | Valor | Tipo | Categoria | Origem/Fatura | Parcela |")
            m_md.append("| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |")
            for t in txs:
                parc_txt = f"{t['parcela_atual']}/{t['total_parcelas']}" if t['total_parcelas'] > 1 else "-"
                m_md.append(f"| {t['id']} | {t['data']} | {t['descricao']} | R$ {t['valor']:,.2f} | {t['tipo']} | {t['categoria']} | {t['origem']} | {parc_txt} |")
        m_md.append("")

        with open(mes_file, "w", encoding="utf-8") as f:
            f.write("\n".join(m_md))
        meses_gerados.append(mes_file)

        m_cur += 1
        if m_cur > 12:
            m_cur = 1
            ano_cur += 1

    # 7. Gerar DUMP_COMPLETO_APEX.md (SSOT Consolidado para IA em arquivo único)
    dump_completo_file = os.path.join(base_dir, "DUMP_COMPLETO_APEX.md")
    # Copia o resumo global e anexa a visão detalhada das faturas e parcelas
    dump_lines = list(global_md)
    dump_lines.append("\n## 7. 💳 CRONOGRAMA INTEGRAL DE FATURAS & PARCELAMENTOS FUTUROS")
    c.execute("""
        SELECT t.mes_fatura, t.descricao, t.valor, t.parcela_atual, t.total_parcelas, COALESCE(k.nome, 'Conta/Outro')
        FROM transacoes t
        LEFT JOIN cartoes k ON t.cartao_id = k.id
        WHERE t.mes_fatura >= ?
        ORDER BY t.mes_fatura, t.valor DESC
    """, (mes_atual,))
    futuras = c.fetchall()
    if futuras:
        dump_lines.append("| Mês Fatura | Descrição / Item | Valor | Parcela | Cartão / Origem |")
        dump_lines.append("| :--- | :--- | :--- | :--- | :--- |")
        for f in futuras:
            p_str = f"{f[3]}/{f[4]}" if f[4] > 1 else "À vista"
            dump_lines.append(f"| `{f[0]}` | {f[1]} | R$ {f[2]:,.2f} | {p_str} | {f[5]} |")
    else:
        dump_lines.append("- *Zero parcelas ou faturas futuras pendentes.*")

    dump_lines.append("\n---")
    dump_lines.append(f"> *Arquivo gerado automaticamente pelo APEX Finance Core Engine em {hoje_str}. SSOT Soberano.*")

    with open(dump_completo_file, "w", encoding="utf-8") as f:
        f.write("\n".join(dump_lines))

    # Também espelha uma cópia de fácil acesso em ~/.local/share/apex-finance/DUMP_COMPLETO_APEX.md
    local_mirror = os.path.expanduser("~/.local/share/apex-finance/DUMP_COMPLETO_APEX.md")
    try:
        with open(local_mirror, "w", encoding="utf-8") as f:
            f.write("\n".join(dump_lines))
    except Exception:
        pass

    conn.close()
    return {
        "base_dir": base_dir,
        "global_file": global_file,
        "dump_completo": dump_completo_file,
        "local_mirror": local_mirror,
        "meses_count": len(meses_gerados)
    }

def listar_backups(destino_dir=None):
    if not destino_dir:
        destino_dir = os.path.expanduser("~/backups/finance")
    if not os.path.isdir(destino_dir):
        return []
    arquivos = [f for f in os.listdir(destino_dir) if f.startswith("finance_backup_") and f.endswith(".db")]
    arquivos.sort(reverse=True)
    resultado = []
    for a in arquivos:
        caminho = os.path.join(destino_dir, a)
        tam = os.path.getsize(caminho)
        mtime = os.path.getmtime(caminho)
        resultado.append({
            "arquivo": a,
            "caminho": caminho,
            "tamanho_kb": round(tam / 1024, 1),
            "data": datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M:%S")
        })
    return resultado

if __name__ == "__main__":
    import sys
    if "--backup" in sys.argv:
        res = fazer_backup()
        print("✔ Backup do APEX Finance realizado com sucesso!")
        print(f"  • Banco SQLite : {res['db_file']}")
        print(f"  • Planilha XLSX: {res['excel_file']}")
        if res['mirrors']:
            print(f"  • Espelhos     : {', '.join(res['mirrors'])}")
    elif "--export-ia" in sys.argv or "--export-context" in sys.argv or "--dump" in sys.argv:
        res = exportar_contexto_ia()
        print("✔ Contexto para IA exportado com sucesso!")
        print(f"  • Diretório Base : {res['base_dir']}")
        print(f"  • Arquivo Global : {res['global_file']}")
        print(f"  • Dump Completo  : {res['dump_completo']}")
        print(f"  • Espelho Local  : {res['local_mirror']}")
        print(f"  • Meses Gerados  : {res['meses_count']} arquivos detalhados")
    else:
        init_database()
        print("Database initialized successfully.")
        out = exportar_para_excel()
        print(f"Planilha exportada com sucesso em: {out}")
        res = exportar_contexto_ia()
        print(f"Contexto IA atualizado em: {res['base_dir']}")
