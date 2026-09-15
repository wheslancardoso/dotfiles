import type { 
  HudMetricas, Conta, Fatura, Transacao, DespesaFixa, 
  WishlistItem, TimelineMes, AlforriaMes 
} from './types';

const API_BASE = '/api';

export const api = {
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

  async getContas(): Promise<Conta[]> {
    const res = await fetch(`${API_BASE}/contas`);
    return res.json();
  },

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
    recorrente?: boolean;
  }) {
    const res = await fetch(`${API_BASE}/transacoes`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error((await res.json()).detail || 'Erro ao criar transação');
    return res.json();
  },

  async deletarTransacao(id: number, apagarSerie = true) {
    const res = await fetch(`${API_BASE}/transacoes/${id}?apagar_serie=${apagarSerie}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Erro ao deletar transação');
    return res.json();
  },

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

  async getDespesasFixas(): Promise<DespesaFixa[]> {
    const res = await fetch(`${API_BASE}/despesas-fixas`);
    return res.json();
  },

  async criarDespesaFixa(data: {
    descricao: string;
    valor: number;
    categoria: string;
    dia_vencimento: number;
    ativa: boolean;
  }) {
    const res = await fetch(`${API_BASE}/despesas-fixas`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    return res.json();
  },

  async toggleDespesaFixa(id: number) {
    const res = await fetch(`${API_BASE}/despesas-fixas/${id}/toggle`, {
      method: 'PUT',
    });
    return res.json();
  },

  async deletarDespesaFixa(id: number) {
    const res = await fetch(`${API_BASE}/despesas-fixas/${id}`, {
      method: 'DELETE',
    });
    return res.json();
  },

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

  async getAlforria(params?: {
    saldo_inicial?: number;
    aporte_padrao?: number;
    taxa_cdi?: number;
  }): Promise<{
    projecao: AlforriaMes[];
    aportes_planejados: { mes: string; valor: number; nota: string }[];
  }> {
    const q = new URLSearchParams();
    if (params?.saldo_inicial !== undefined) q.set('saldo_inicial', String(params.saldo_inicial));
    if (params?.aporte_padrao !== undefined) q.set('aporte_padrao', String(params.aporte_padrao));
    if (params?.taxa_cdi !== undefined) q.set('taxa_cdi', String(params.taxa_cdi));
    const res = await fetch(`${API_BASE}/alforria?${q.toString()}`);
    return res.json();
  },

  async definirAportePlanejado(mes: string, valor: number, nota = '') {
    const res = await fetch(`${API_BASE}/alforria/aporte-planejado`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ mes, valor, nota }),
    });
    return res.json();
  },

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

  async deletarWishlist(id: number) {
    const res = await fetch(`${API_BASE}/wishlist/${id}`, {
      method: 'DELETE',
    });
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

  async exportarExcel(): Promise<{ status: string; caminho: string }> {
    const res = await fetch(`${API_BASE}/exportar/excel`, { method: 'POST' });
    return res.json();
  },

  async exportarIA(): Promise<{ status: string; arquivos: string[] }> {
    const res = await fetch(`${API_BASE}/exportar/contexto-ia`, { method: 'POST' });
    return res.json();
  }
};
