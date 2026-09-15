export interface HudMetricas {
  saldo_total: number;
  faturas_pendentes: number;
  total_receitas: number;
  total_despesas_fixas: number;
  sobra_livre: number;
  taxa_poupanca: number;
}

export interface Conta {
  id: number;
  nome: string;
  tipo: 'corrente' | 'investimento' | 'cartao_credito' | 'carteira';
  instituicao?: string;
  saldo_atual: number;
  saldo?: number;
}

export interface Cartao {
  id: number;
  nome: string;
  instituicao: string;
  limite: number;
  dia_fechamento: number;
  dia_vencimento: number;
}

export interface Fatura {
  cartao_id: number;
  cartao_nome: string;
  dia_fechamento: number;
  dia_vencimento: number;
  mes_fatura: string;
  total_fatura: number;
  total_pago: number;
  status: 'aberta' | 'fechada' | 'paga' | 'zerada';
}

export interface Transacao {
  id: number;
  data_transacao: string;
  descricao: string;
  valor: number;
  tipo: 'receita' | 'despesa';
  categoria: string;
  conta_nome: string;
  serie_parcelamento_id?: string | null;
  parcela_atual?: number;
  total_parcelas?: number;
  mes_fatura?: string;
}

export interface DespesaFixa {
  id: number;
  descricao: string;
  valor: number;
  categoria: string;
  dia_vencimento: number;
  ativa: number | boolean;
  tipo?: string;
}

export interface Caixinha {
  id: number;
  nome: string;
  descricao: string;
  meta_total: number;
  aporte_mensal: number;
  saldo_atual: number;
  data_alvo?: string;
}

export interface WishlistItem {
  id: number;
  item: string;
  categoria: string;
  valor_estimado: number;
  parcelas_sugeridas: number;
  prioridade: 'Baixa' | 'Média' | 'Alta' | 'Estratégica';
  condicao_compra?: string;
  status: 'planejado' | 'comprado' | 'desistido';
  link_ou_obs?: string;
  data_criacao: string;
}

export interface TimelineMes {
  mes: string;
  receitas: number;
  fixas: number;
  faturas_cartao: number;
  despesas_totais: number;
  sobra_mes: number;
  saldo_acumulado: number;
}

export interface AlforriaMes {
  mes: string;
  saldo_inicial: number;
  rendimento_cdi: number;
  aporte: number;
  saldo_final: number;
  rendimento_mensal_futuro: number;
}

export interface AportePlanejado {
  mes: string;
  caixinha_id: number;
  valor: number;
  nota: string;
}
