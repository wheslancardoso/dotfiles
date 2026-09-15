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
  tipo: 'corrente' | 'investimento' | 'cartao_credito';
  saldo_atual: number;
  limite?: number;
  dia_fechamento?: number;
  dia_vencimento?: number;
}

export interface Fatura {
  cartao_id: number;
  cartao_nome: string;
  dia_fechamento: number;
  dia_vencimento: number;
  mes_fatura: string;
  total_fatura: number;
  total_pago: number;
  status: 'aberta' | 'fechada' | 'paga';
}

export interface Transacao {
  id: number;
  data_transacao: string;
  descricao: string;
  valor: number;
  tipo: 'receita' | 'despesa';
  categoria: string;
  conta_id: number;
  conta_nome: string;
  serie_parcelamento_id?: string;
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
}

export interface WishlistItem {
  id: number;
  item: string;
  categoria: string;
  valor_estimado: number;
  parcelas_sugeridas: number;
  prioridade: 'Baixa' | 'Media' | 'Alta';
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
