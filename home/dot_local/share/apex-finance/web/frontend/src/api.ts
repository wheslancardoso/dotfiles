import type { 
  HudMetricas, Conta, Cartao, Fatura, Transacao, DespesaFixa, 
  WishlistItem, TimelineMes, AlforriaMes, Caixinha, AportePlanejado 
} from './types';

const API_BASE = '/api';

export const api = {
  // DASHBOARD
  async getDashboard(mes?: string): Promise<{
    mes_referencia: string;
    hud: HudMetricas;
    contas: Conta[];
    faturas: Fatura[];
    total_fixas: number;
  }> {
    const url = mes ? `${API_BASE}/dashboard?mes=${mes}` : `${API_BASE}/dashboard`;
    const res = await fetch(url);
    return res.json();
  },

  // CONTAS
  async getContas(): Promise<Conta[]> {
    const res = await fetch(`${API_BASE}/contas`);
    return res.json();
  },
  async criarConta(conta: { nome: string; tipo: string; instituicao: string; saldo: number }) {
    const res = await fetch(`${API_BASE}/contas`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(conta)
    });
    return res.json();
  },
  async editarConta(id: number, conta: { nome: string; tipo: string; instituicao: string; saldo: number }) {
    const res = await fetch(`${API_BASE}/contas/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(conta)
    });
    return res.json();
  },
  async deletarConta(id: number) {
    const res = await fetch(`${API_BASE}/contas/${id}`, { method: 'DELETE' });
    return res.json();
  },

  // CARTÕES
  async getCartoes(): Promise<Cartao[]> {
    const res = await fetch(`${API_BASE}/cartoes`);
    return res.json();
  },
  async criarCartao(data: { nome: string; instituicao: string; limite: number; dia_fechamento: number; dia_vencimento: number }) {
    const res = await fetch(`${API_BASE}/cartoes`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return res.json();
  },
  async editarCartao(id: number, data: { nome: string; instituicao: string; limite: number; dia_fechamento: number; dia_vencimento: number }) {
    const res = await fetch(`${API_BASE}/cartoes/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return res.json();
  },
  async deletarCartao(id: number) {
    const res = await fetch(`${API_BASE}/cartoes/${id}`, { method: 'DELETE' });
    return res.json();
  },
  async reajustarFatura(cartaoId: number, mesFatura: string, novoValorTotal: number, motivo: string) {
    const res = await fetch(`${API_BASE}/cartoes/reajustar`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ cartao_id: cartaoId, mes_fatura: mesFatura, novo_valor_total: novoValorTotal, motivo })
    });
    return res.json();
  },

  // TRANSAÇÕES
  async getTransacoes(mes?: string, contaId?: number): Promise<Transacao[]> {
    let url = `${API_BASE}/transacoes?limite=150`;
    if (mes) url += `&mes=${mes}`;
    if (contaId) url += `&conta_id=${contaId}`;
    const res = await fetch(url);
    return res.json();
  },
  async criarTransacao(data: {
    descricao: string;
    valor: number;
    tipo: string;
    categoria: string;
    conta_id: number;
    data_transacao?: string;
    num_parcelas?: number;
  }) {
    const res = await fetch(`${API_BASE}/transacoes`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error((await res.json()).detail || 'Erro ao criar transação');
    return res.json();
  },
  async editarTransacao(id: number, data: {
    descricao: string;
    valor: number;
    tipo: string;
    categoria: string;
    data_transacao: string;
  }) {
    const res = await fetch(`${API_BASE}/transacoes/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error((await res.json()).detail || 'Erro ao editar transação');
    return res.json();
  },
  async deletarTransacao(id: number, apagarSerie = true) {
    const res = await fetch(`${API_BASE}/transacoes/${id}?apagar_serie=${apagarSerie}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Erro ao deletar transação');
    return res.json();
  },

  // FATURAS
  async getFaturas(mes?: string): Promise<Fatura[]> {
    const url = mes ? `${API_BASE}/faturas?mes=${mes}` : `${API_BASE}/faturas`;
    const res = await fetch(url);
    return res.json();
  },
  async pagarFatura(cartaoId: number, mesFatura: string, contaOrigemId: number) {
    const res = await fetch(`${API_BASE}/faturas/pagar`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        cartao_id: cartaoId,
        mes_fatura: mesFatura,
        conta_origem_id: contaOrigemId,
      }),
    });
    if (!res.ok) throw new Error((await res.json()).detail || 'Erro ao pagar fatura');
    return res.json();
  },

  // RECORRÊNCIAS / DESPESAS FIXAS
  async getDespesasFixas(): Promise<DespesaFixa[]> {
    const res = await fetch(`${API_BASE}/despesas-fixas`);
    return res.json();
  },
  async criarDespesaFixa(data: {
    descricao: string;
    valor: number;
    categoria: string;
    dia_vencimento: number;
    tipo?: string;
    ativo?: number;
  }) {
    const res = await fetch(`${API_BASE}/despesas-fixas`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    return res.json();
  },
  async editarDespesaFixa(id: number, data: {
    descricao: string;
    valor: number;
    categoria: string;
    dia_vencimento: number;
    tipo?: string;
    ativo?: number;
  }) {
    const res = await fetch(`${API_BASE}/despesas-fixas/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    return res.json();
  },
  async toggleDespesaFixa(id: number) {
    const res = await fetch(`${API_BASE}/despesas-fixas/${id}/toggle`, { method: 'PUT' });
    return res.json();
  },
  async deletarDespesaFixa(id: number) {
    const res = await fetch(`${API_BASE}/despesas-fixas/${id}`, { method: 'DELETE' });
    return res.json();
  },

  // CAIXINHAS & ALFORRIA
  async getCaixinhas(): Promise<Caixinha[]> {
    const res = await fetch(`${API_BASE}/caixinhas`);
    return res.json();
  },
  async criarCaixinha(cx: { nome: string; descricao: string; meta_total: number; aporte_mensal: number; saldo_atual: number; data_alvo?: string }) {
    const res = await fetch(`${API_BASE}/caixinhas`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(cx)
    });
    return res.json();
  },
  async editarCaixinha(id: number, cx: { nome: string; descricao: string; meta_total: number; aporte_mensal: number; saldo_atual: number; data_alvo?: string }) {
    const res = await fetch(`${API_BASE}/caixinhas/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(cx)
    });
    return res.json();
  },
  async deletarCaixinha(id: number) {
    const res = await fetch(`${API_BASE}/caixinhas/${id}`, { method: 'DELETE' });
    return res.json();
  },
  async aportarCaixinha(caixinhaId: number, contaOrigemId: number, valor: number, dataAporte?: string) {
    const res = await fetch(`${API_BASE}/caixinhas/aporte`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ caixinha_id: caixinhaId, conta_origem_id: contaOrigemId, valor, data_aporte: dataAporte })
    });
    return res.json();
  },
  async definirAportePlanejado(mes: string, caixinhaId: number, valor: number, motivo = '') {
    const res = await fetch(`${API_BASE}/caixinhas/aporte-planejado`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ mes_referencia: mes, caixinha_id: caixinhaId, valor, motivo }),
    });
    return res.json();
  },
  async getAlforria(): Promise<{
    projecao: AlforriaMes[];
    aportes_planejados: AportePlanejado[];
  }> {
    const res = await fetch(`${API_BASE}/alforria`);
    return res.json();
  },

  // SIMULADOR
  async getSimulador(params?: {
    mes_inicio?: string;
    meses_a_frente?: number;
    sim_descricao?: string;
    sim_valor?: number;
    sim_parcelas?: number;
    sim_mes_inicio?: string;
  }): Promise<{
    mes_base: string;
    timeline: TimelineMes[];
    simulacao?: {
      compra_simulada: any;
      mes_inicio: string;
      parcela_mensal: number;
      num_parcelas: number;
      impacto_mensal: any[];
    };
  }> {
    const q = new URLSearchParams();
    if (params?.mes_inicio) q.set('mes_inicio', params.mes_inicio);
    if (params?.meses_a_frente) q.set('meses_a_frente', String(params.meses_a_frente));
    if (params?.sim_valor && params.sim_valor > 0) {
      q.set('sim_valor', String(params.sim_valor));
      if (params.sim_descricao) q.set('sim_descricao', params.sim_descricao);
      if (params.sim_parcelas) q.set('sim_parcelas', String(params.sim_parcelas));
      if (params.sim_mes_inicio) q.set('sim_mes_inicio', params.sim_mes_inicio);
    }
    const res = await fetch(`${API_BASE}/simulador?${q.toString()}`);
    return res.json();
  },
  async efetivarSimulacao(data: {
    descricao: string;
    valor_total: number;
    parcelas: number;
    tipo: string;
    cartao_id: number;
    conta_id: number;
    categoria: string;
  }) {
    const res = await fetch(`${API_BASE}/simulador/efetivar`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return res.json();
  },

  // WISHLIST
  async getWishlist(): Promise<WishlistItem[]> {
    const res = await fetch(`${API_BASE}/wishlist`);
    return res.json();
  },
  async criarWishlist(item: {
    item: string;
    categoria: string;
    valor_estimado: number;
    parcelas_sugeridas: number;
    prioridade: string;
    condicao_compra?: string;
    link_ou_obs?: string;
  }) {
    const res = await fetch(`${API_BASE}/wishlist`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(item),
    });
    return res.json();
  },
  async editarWishlist(id: number, item: {
    item: string;
    categoria: string;
    valor_estimado: number;
    parcelas_sugeridas: number;
    prioridade: string;
    condicao_compra?: string;
    link_ou_obs?: string;
  }) {
    const res = await fetch(`${API_BASE}/wishlist/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(item),
    });
    return res.json();
  },
  async deletarWishlist(id: number) {
    const res = await fetch(`${API_BASE}/wishlist/${id}`, { method: 'DELETE' });
    return res.json();
  },
  async efetivarWishlist(id: number, contaId: number, numParcelas: number, dataCompra?: string) {
    const res = await fetch(`${API_BASE}/wishlist/${id}/efetivar`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        conta_id: contaId,
        num_parcelas: numParcelas,
        data_compra: dataCompra,
      }),
    });
    if (!res.ok) throw new Error((await res.json()).detail || 'Erro ao efetivar compra');
    return res.json();
  },

  // EXPORTAÇÕES
  async exportarExcel(): Promise<{ status: string; caminho: string }> {
    const res = await fetch(`${API_BASE}/exportar/excel`);
    const data = await res.json();
    
    // Dispara download automático no navegador
    const a = document.createElement('a');
    a.href = `${API_BASE}/exportar/excel/download`;
    a.download = 'Planilha_Alforria_Homem_Rocha.xlsx';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    
    return data;
  },
  async exportarIA(): Promise<{ status: string; arquivos: string[] }> {
    const res = await fetch(`${API_BASE}/exportar/contexto-ia`, { method: 'POST' });
    return res.json();
  }
};
