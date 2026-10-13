#!/usr/bin/env python3
"""
dojo_tracker.py — Rastreador Forense de Competências Sociais & Carisma (Homem Rocha)
Armazena e exibe a evolução numérica real dos treinos de comunicação de Wheslan.
"""

import argparse
import os
import sqlite3
import sys
from datetime import datetime

DB_PATH = os.path.expanduser("~/timeless_life/04 - Comunicação, Postura & Simulações Sociais/.dojo_metrics.db")


def get_db():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    with conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS treinos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                data TEXT NOT NULL,
                tema TEXT NOT NULL,
                atencao REAL NOT NULL,
                presenca REAL NOT NULL,
                contencao REAL NOT NULL,
                redirecionamento REAL NOT NULL,
                neutralidade REAL NOT NULL,
                media_geral REAL NOT NULL,
                observacoes TEXT
            )
        """)
    return conn


def registrar(tema, atencao, presenca, contencao, redirecionamento, neutralidade, obs=""):
    media = round((atencao + presenca + contencao + redirecionamento + neutralidade) / 5.0, 2)
    data_str = datetime.now().strftime("%Y-%m-%d %H:%M")
    
    conn = get_db()
    with conn:
        conn.execute("""
            INSERT INTO treinos (data, tema, atencao, presenca, contencao, redirecionamento, neutralidade, media_geral, observacoes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (data_str, tema, atencao, presenca, contencao, redirecionamento, neutralidade, media, obs))
    
    print(f"✅ Treino registrado com sucesso!")
    print(f"   Data: {data_str} | Tema: {tema}")
    print(f"   Média da Sessão: {media}/10")
    print("-" * 50)
    status()


def status():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) as total, AVG(media_geral) as media_total FROM treinos")
    row = cursor.fetchone()
    total = row["total"] or 0
    media_total = round(row["media_total"] or 0.0, 2)

    print("📊 PAINEL GERAL DE EVOLUÇÃO SOCIAL (HOMEM ROCHA)")
    print(f"   Total de Treinos Concluídos: {total}")
    print(f"   Média Geral Acumulada:        {media_total}/10")
    print("-" * 50)

    if total == 0:
        print("   Nenhum treino registrado ainda. Inicie o seu primeiro treino!")
        return

    cursor.execute("""
        SELECT 
            AVG(atencao) as m_atencao,
            AVG(presenca) as m_presenca,
            AVG(contencao) as m_contencao,
            AVG(redirecionamento) as m_redirec,
            AVG(neutralidade) as m_neutro
        FROM treinos
    """)
    m = cursor.fetchone()
    
    print("📈 MÉDIAS HISTÓRICAS POR COMPETÊNCIA:")
    print(f"   1. Atenção & Subtexto:       {round(m['m_atencao'], 1)}/10")
    print(f"   2. Presença Indivisa:        {round(m['m_presenca'], 1)}/10")
    print(f"   3. Contenção & Silêncio:     {round(m['m_contencao'], 1)}/10")
    print(f"   4. Redirecionamento Holofote: {round(m['m_redirec'], 1)}/10")
    print(f"   5. Neutralidade (Sem Julgar): {round(m['m_neutro'], 1)}/10")
    print("-" * 50)

    print("🕒 ÚLTIMOS TREINOS:")
    cursor.execute("SELECT id, data, tema, media_geral FROM treinos ORDER BY id DESC LIMIT 5")
    for r in cursor.fetchall():
        print(f"   [#{r['id']:02d}] {r['data']} — {r['tema'][:30]:<30} | Média: {r['media_geral']}/10")


def main():
    parser = argparse.ArgumentParser(description="Dojo Tracker - Gestor de Métricas Sociais")
    subparsers = parser.add_subparsers(dest="command")

    # Comando registrar
    reg_parser = subparsers.add_parser("registrar", help="Registrar notas de um novo treino")
    reg_parser.add_argument("--tema", required=True, help="Nome/Contexto do treino")
    reg_parser.add_argument("--notas", nargs=5, type=float, required=True, 
                            metavar=("ATENCAO", "PRESENCA", "CONTENCAO", "REDIREC", "NEUTRO"),
                            help="Notas de 0 a 10 nas 5 competências")
    reg_parser.add_argument("--obs", default="", help="Observações breves")

    # Comando status
    subparsers.add_parser("status", help="Exibir histórico e médias de evolução")

    args = parser.parse_args()

    if args.command == "registrar":
        n = args.notas
        registrar(args.tema, n[0], n[1], n[2], n[3], n[4], args.obs)
    else:
        status()


if __name__ == "__main__":
    main()
