"""
APEX Finance - Web API Backend (FastAPI)
Conecta a interface web moderna ao core_engine.py com precisão matemática soberana.
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
import datetime
import os
import sys

# Inclui o diretório raiz do apex-finance no path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))
import core_engine as ce

app = FastAPI(title="APEX Finance Web API", version="2.0.0")

# CORS liberado para desenvolvimento local
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def mes_atual_str() -> str:
    hoje = datetime.date.today()
    return f"{hoje.year:04d}-{hoje.month:02d}"

# ----------------- MODELOS PYDANTIC -----------------

class TransacaoIn(BaseModel):
    descricao: str
    valor: float
    tipo: str  # 'receita' ou 'despesa'
    categoria: str
    conta_id: int
    data_transacao: Optional[str] = None
    num_parcelas: int = 1

class RecorrenciaIn(BaseModel):
    descricao: str
    valor: float
    tipo: str = "despesa"
    categoria: str
    dia_vencimento: int
    conta_id: Optional[int] = 1
    ativo: int = 1

class CartaoIn(BaseModel):
    nome: str
    instituicao: str
    limite: float
    dia_fechamento: int
    dia_vencimento: int

class WishlistIn(BaseModel):
    item: str
    categoria: str
    valor_estimado: float
    parcelas_sugeridas: int = 1
    prioridade: str = "Media"
    condicao_compra: str = ""
    link_ou_obs: str = ""

class WishlistEfetivarIn(BaseModel):
    conta_id: int
    num_parcelas: int = 1
    data_compra: Optional[str] = None

class PagarFaturaIn(BaseModel):
    cartao_id: int
    mes_fatura: str
    conta_origem_id: int

# ----------------- ENDPOINTS -----------------

@app.get("/api/dashboard")
def get_dashboard(mes: Optional[str] = None):
    mes_ref = mes or mes_atual_str()
    ce.init_database()
    
    # Métricas HUD
    hud_engine = ce.get_survival_hud_metrics(mes_ref)
    
    conn = ce.get_connection()
    c = conn.cursor()
    
    # Contas
    c.execute("SELECT id, nome, tipo, instituicao, saldo FROM contas")
    contas_rows = [dict(r) for r in c.fetchall()]
    
    # Faturas
    c.execute("""
        SELECT k.id as cartao_id, k.nome as cartao_nome, k.dia_fechamento, k.dia_vencimento,
               COALESCE(SUM(t.valor), 0.0) as total_fatura
        FROM cartoes k
        LEFT JOIN transacoes t ON t.cartao_id = k.id AND t.mes_fatura = ?
        GROUP BY k.id, k.nome, k.dia_fechamento, k.dia_vencimento
    """, (mes_ref,))
    faturas_rows = []
    for r in c.fetchall():
        d = dict(r)
        d["mes_fatura"] = mes_ref
        d["total_pago"] = 0.0
        d["status"] = "aberta"
        faturas_rows.append(d)
        
    # Recorrências
    c.execute("SELECT id, descricao, valor, categoria, dia_vencimento, ativo FROM recorrencias WHERE ativo = 1")
    recs = [dict(r) for r in c.fetchall()]
    total_fixas = sum(r["valor"] for r in recs if "Alforria" not in r["descricao"])
    
    # Renda e Depois das Contas
    ano_sel, m_sel = map(int, mes_ref.split('-'))
    renda = 2234.0
    if m_sel in [11, 12]:
        renda += 1100.0
        
    total_fats = sum(f["total_fatura"] for f in faturas_rows)
    aporte_alforria = ce.obter_aporte_planejado(mes_ref, 1)
    sobra_depois_contas = renda - (total_fats + total_fixas + aporte_alforria)
    
    # Taxa de poupança
    taxa_poup = ((aporte_alforria + max(0.0, sobra_depois_contas)) / renda) * 100 if renda > 0 else 0.0

    conn.close()

    hud = {
        "saldo_total": hud_engine["saldo_bancario"],
        "faturas_pendentes": total_fats,
        "total_receitas": renda,
        "total_despesas_fixas": total_fixas,
        "sobra_livre": sobra_depois_contas,
        "taxa_poupanca": taxa_poup
    }

    return {
        "mes_referencia": mes_ref,
        "hud": hud,
        "contas": contas_rows,
        "faturas": faturas_rows,
        "total_fixas": total_fixas
    }

@app.get("/api/contas")
def get_contas():
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("SELECT id, nome, tipo, instituicao, saldo as saldo_atual FROM contas")
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

@app.get("/api/cartoes")
def get_cartoes():
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("SELECT id, nome, instituicao, limite, dia_fechamento, dia_vencimento FROM cartoes")
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

@app.get("/api/transacoes")
def get_transacoes(mes: Optional[str] = None, conta_id: Optional[int] = None, limite: int = 150):
    mes_ref = mes or mes_atual_str()
    txs = ce.get_transacoes_do_mes(mes_ref)
    result = []
    for t in txs:
        result.append({
            "id": t["id"],
            "data_transacao": t["data"],
            "descricao": t["descricao"],
            "valor": t["valor"],
            "tipo": t["tipo"],
            "categoria": t["categoria"],
            "conta_nome": t["origem"],
            "parcela_atual": t["parcela_atual"],
            "total_parcelas": t["total_parcelas"],
            "mes_fatura": t["mes_fatura"],
            "serie_parcelamento_id": "PARC" if t["total_parcelas"] > 1 else None
        })
    return result

@app.delete("/api/transacoes/{transacao_id}")
def delete_transacao(transacao_id: int, apagar_serie: bool = True):
    ce.deletar_transacao(transacao_id, apagar_serie=apagar_serie)
    return {"status": "ok"}

@app.get("/api/faturas")
def get_faturas(mes: Optional[str] = None):
    mes_ref = mes or mes_atual_str()
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("""
        SELECT k.id as cartao_id, k.nome as cartao_nome, k.dia_fechamento, k.dia_vencimento,
               COALESCE(SUM(t.valor), 0.0) as total_fatura
        FROM cartoes k
        LEFT JOIN transacoes t ON t.cartao_id = k.id AND t.mes_fatura = ?
        GROUP BY k.id, k.nome, k.dia_fechamento, k.dia_vencimento
    """, (mes_ref,))
    faturas_rows = []
    for r in c.fetchall():
        d = dict(r)
        d["mes_fatura"] = mes_ref
        d["total_pago"] = 0.0
        d["status"] = "aberta" if d["total_fatura"] > 0 else "zerada"
        faturas_rows.append(d)
    conn.close()
    return faturas_rows

@app.post("/api/faturas/pagar")
def post_pagar_fatura(payload: PagarFaturaIn):
    try:
        ce.pagar_fatura(
            cartao_id=payload.cartao_id,
            mes_fatura=payload.mes_fatura,
            conta_origem_id=payload.conta_origem_id
        )
        return {"status": "ok", "mensagem": f"Fatura {payload.mes_fatura} paga com sucesso!"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/despesas-fixas")
def get_despesas_fixas():
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("SELECT id, descricao, valor, categoria, dia_vencimento, ativo as ativa FROM recorrencias ORDER BY dia_vencimento")
    rows = [dict(r) for r in c.fetchall()]
    conn.close()
    return rows

@app.post("/api/despesas-fixas")
def post_despesa_fixa(df: RecorrenciaIn):
    rid = ce.criar_recorrencia(
        tipo=df.tipo,
        descricao=df.descricao,
        valor=df.valor,
        categoria=df.categoria,
        dia_vencimento=df.dia_vencimento,
        conta_id=df.conta_id or 1
    )
    return {"status": "ok", "id": rid}

@app.put("/api/despesas-fixas/{id}/toggle")
def toggle_despesa_fixa(id: int):
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("SELECT * FROM recorrencias WHERE id = ?", (id,))
    r = c.fetchone()
    if not r:
        conn.close()
        raise HTTPException(status_code=404, detail="Recorrência não encontrada")
    novo_status = 0 if r["ativo"] == 1 else 1
    c.execute("UPDATE recorrencias SET ativo = ? WHERE id = ?", (novo_status, id))
    conn.commit()
    conn.close()
    return {"status": "ok", "ativa": novo_status}

@app.delete("/api/despesas-fixas/{id}")
def delete_despesa_fixa(id: int):
    ce.deletar_recorrencia(id)
    return {"status": "ok"}

@app.get("/api/simulador")
def get_simulador(
    mes_inicio: Optional[str] = None,
    meses_a_frente: int = 12,
    sim_descricao: Optional[str] = None,
    sim_valor: float = 0.0,
    sim_parcelas: int = 1,
    sim_mes_inicio: Optional[str] = None
):
    mes_base = mes_inicio or mes_atual_str()
    proj = ce.get_time_machine_projection(meses=meses_a_frente)
    
    # Formata para o padrão consumido pelo front
    timeline = []
    for item in proj:
        tot_desp = item.get("despesas_fixas", 0.0) + item.get("fatura_cartao", 0.0)
        sobra = item.get("receitas", 0.0) - tot_desp
        timeline.append({
            "mes": item.get("mes_ano", item.get("label", "")),
            "receitas": item.get("receitas", 0.0),
            "fixas": item.get("despesas_fixas", 0.0),
            "faturas_cartao": item.get("fatura_cartao", 0.0),
            "despesas_totais": tot_desp,
            "sobra_mes": sobra,
            "saldo_acumulado": item.get("saldo_final", 0.0)
        })
        
    simulacao = None
    if sim_valor > 0:
        sim_data = ce.simular_impacto_compra(
            valor_total=sim_valor,
            num_parcelas=sim_parcelas,
            mes_inicio=sim_mes_inicio or mes_base,
            descricao=sim_descricao or "Simulação"
        )
        simulacao = {
            "compra_simulada": sim_data["descricao"],
            "mes_inicio": sim_data["mes_inicio"],
            "parcela_mensal": sim_data["parcela_mensal"],
            "num_parcelas": sim_data["num_parcelas"],
            "impacto_mensal": sim_data["impacto_mensal"]
        }
        
    return {
        "mes_base": mes_base,
        "timeline": timeline,
        "simulacao": simulacao
    }

@app.get("/api/alforria")
def get_alforria():
    proj = ce.projetar_alforria(meses=36)
    aportes_planejados = []
    conn = ce.get_connection()
    c = conn.cursor()
    c.execute("SELECT mes_referencia as mes, valor, motivo as nota FROM aportes_planejados ORDER BY mes_referencia")
    for r in c.fetchall():
        aportes_planejados.append(dict(r))
    conn.close()
    
    res = []
    saldo_ant = 1000.0
    for p in proj:
        s_final = p.get("saldo", 0.0)
        rend = p.get("rendimento", 0.0)
        ap = p.get("aporte", 0.0)
        res.append({
            "mes": p.get("mes_ano", ""),
            "saldo_inicial": saldo_ant,
            "rendimento_cdi": rend,
            "aporte": ap,
            "saldo_final": s_final,
            "rendimento_mensal_futuro": s_final * 0.0095
        })
        saldo_ant = s_final
        
    return {
        "projecao": res,
        "aportes_planejados": aportes_planejados
    }

@app.get("/api/wishlist")
def get_wishlist():
    return ce.listar_wishlist()

@app.post("/api/wishlist")
def post_wishlist(w: WishlistIn):
    wid = ce.criar_item_wishlist(
        item=w.item,
        categoria=w.categoria,
        valor_estimado=w.valor_estimado,
        parcelas_sugeridas=w.parcelas_sugeridas,
        prioridade=w.prioridade,
        condicao_compra=w.condicao_compra,
        link_ou_obs=w.link_ou_obs
    )
    return {"status": "ok", "id": wid}

@app.delete("/api/wishlist/{id}")
def delete_wishlist(id: int):
    ce.deletar_item_wishlist(id)
    return {"status": "ok"}

@app.post("/api/wishlist/{id}/efetivar")
def post_efetivar_wishlist(id: int, p: WishlistEfetivarIn):
    sucesso, msg = ce.efetivar_compra_wishlist(
        item_id=id,
        conta_id=p.conta_id,
        num_parcelas=p.num_parcelas,
        data_compra=p.data_compra
    )
    if not sucesso:
        raise HTTPException(status_code=400, detail=msg)
    return {"status": "ok", "mensagem": msg}

@app.post("/api/exportar/excel")
def post_exportar_excel():
    caminho = ce.exportar_para_excel()
    return {"status": "ok", "caminho": caminho}

@app.post("/api/exportar/contexto-ia")
def post_exportar_ia():
    caminhos = ce.exportar_contexto_ia()
    return {"status": "ok", "arquivos": caminhos}

# Servir Frontend compilado
FRONTEND_DIST = os.path.abspath(os.path.join(os.path.dirname(__file__), "../frontend/dist"))
if os.path.exists(FRONTEND_DIST):
    app.mount("/assets", StaticFiles(directory=os.path.join(FRONTEND_DIST, "assets")), name="assets")
    
    @app.get("/")
    async def serve_root():
        return FileResponse(os.path.join(FRONTEND_DIST, "index.html"))

    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        file_path = os.path.join(FRONTEND_DIST, full_path)
        if os.path.exists(file_path) and os.path.isfile(file_path):
            return FileResponse(file_path)
        return FileResponse(os.path.join(FRONTEND_DIST, "index.html"))

if __name__ == "__main__":
    import uvicorn
    ce.init_database()
    print("🚀 Iniciando APEX Finance Web Backend em http://localhost:8000")
    uvicorn.run(app, host="127.0.0.1", port=8000)
