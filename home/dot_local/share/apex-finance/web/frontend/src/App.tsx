import React, { useState, useEffect } from 'react';
import { 
  LayoutDashboard, CreditCard, Receipt, Repeat, 
  Rocket, History, BookmarkCheck, Plus, Trash2, 
  CheckCircle, ArrowUpRight, ArrowDownRight, RefreshCw, 
  FileSpreadsheet, Sparkles, TrendingUp, 
  Calculator, Search, ShieldCheck, Zap
} from 'lucide-react';
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, 
  ResponsiveContainer
} from 'recharts';
import { api } from './api';
import type { 
  HudMetricas, Conta, Fatura, Transacao, DespesaFixa, 
  WishlistItem, TimelineMes, AlforriaMes 
} from './types';

export function App() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'faturas' | 'transacoes' | 'fixas' | 'alforria' | 'simulador' | 'wishlist' | 'oraculo'>('dashboard');
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<string | null>(null);

  // Dados centrais
  const [mesRef, setMesRef] = useState<string>('2026-10');
  const [hud, setHud] = useState<HudMetricas | null>(null);
  const [contas, setContas] = useState<Conta[]>([]);
  const [faturas, setFaturas] = useState<Fatura[]>([]);
  const [transacoes, setTransacoes] = useState<Transacao[]>([]);
  const [despesasFixas, setDespesasFixas] = useState<DespesaFixa[]>([]);
  const [wishlist, setWishlist] = useState<WishlistItem[]>([]);
  const [timeline, setTimeline] = useState<TimelineMes[]>([]);
  const [alforria, setAlforria] = useState<AlforriaMes[]>([]);

  // Filtros de busca no extrato
  const [searchTerm, setSearchTerm] = useState('');
  const [filterBanco, setFilterBanco] = useState<string>('TODOS');

  // Modais
  const [showModalTx, setShowModalTx] = useState(false);
  const [showModalPagarFatura, setShowModalPagarFatura] = useState<Fatura | null>(null);
  const [showModalWish, setShowModalWish] = useState(false);
  const [showModalEfetivarWish, setShowModalEfetivarWish] = useState<WishlistItem | null>(null);
  const [showModalFixa, setShowModalFixa] = useState(false);

  // Forms
  const [txForm, setTxForm] = useState({
    descricao: '',
    valor: '',
    tipo: 'despesa',
    categoria: 'Outros',
    conta_id: '',
    data_transacao: new Date().toISOString().split('T')[0],
    num_parcelas: 1
  });

  const [wishForm, setWishForm] = useState({
    item: '',
    categoria: 'Setup / Equipamento',
    valor_estimado: '',
    parcelas_sugeridas: 1,
    prioridade: 'Media',
    condicao_compra: '',
    link_ou_obs: ''
  });

  const [fixaForm, setFixaForm] = useState({
    descricao: '',
    valor: '',
    categoria: 'Assinaturas & Serviços',
    dia_vencimento: 10,
    ativa: true
  });

  // Simulador state
  const [simForm, setSimForm] = useState({
    descricao: '',
    valor: '',
    parcelas: 6,
    mes_inicio: '2026-10'
  });
  const [simResult, setSimResult] = useState<any>(null);

  // Oráculo PIX vs Cartão
  const [oraculoForm, setOraculoForm] = useState({
    item: 'Equipamento / Peça',
    precoPix: '450',
    precoCartao: '500',
    parcelas: 5,
  });

  // Carregar dados principais
  const carregarTudo = async () => {
    try {
      setLoading(true);
      const dash = await api.getDashboard(mesRef);
      setHud(dash.hud);
      setContas(dash.contas);
      setFaturas(dash.faturas);
      
      const txs = await api.getTransacoes(mesRef);
      setTransacoes(txs);

      const fix = await api.getDespesasFixas();
      setDespesasFixas(fix);

      const wish = await api.getWishlist();
      setWishlist(wish);

      const sim = await api.getSimulador({ mes_inicio: mesRef });
      setTimeline(sim.timeline);

      const alf = await api.getAlforria();
      setAlforria(alf.projecao);

      if (dash.contas.length > 0 && !txForm.conta_id) {
        setTxForm(prev => ({ ...prev, conta_id: String(dash.contas[0].id) }));
      }
    } catch (err: any) {
      console.error(err);
      notificar("Erro ao carregar dados: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    carregarTudo();
  }, [mesRef]);

  const notificar = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 4000);
  };

  // Handlers de Criação / Ações
  const handleCriarTransacao = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.criarTransacao({
        descricao: txForm.descricao,
        valor: parseFloat(txForm.valor),
        tipo: txForm.tipo,
        categoria: txForm.categoria,
        conta_id: parseInt(txForm.conta_id),
        data_transacao: txForm.data_transacao,
        num_parcelas: parseInt(String(txForm.num_parcelas)),
      });
      setShowModalTx(false);
      setTxForm({
        descricao: '',
        valor: '',
        tipo: 'despesa',
        categoria: 'Outros',
        conta_id: contas[0]?.id ? String(contas[0].id) : '',
        data_transacao: new Date().toISOString().split('T')[0],
        num_parcelas: 1
      });
      notificar("Transação registrada com sucesso!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleDeletarTransacao = async (id: number, serieId?: string) => {
    const msg = serieId 
      ? "Esta despesa faz parte de uma compra parcelada. Deseja excluir TODAS as parcelas deste grupo?" 
      : "Deseja realmente excluir esta transação?";
    if (!window.confirm(msg)) return;
    try {
      await api.deletarTransacao(id, true);
      notificar("Transação(ões) excluída(s) com sucesso!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro ao excluir: " + err.message);
    }
  };

  const handlePagarFatura = async (cartaoId: number, mesFatura: string, contaOrigemId: number) => {
    try {
      const res = await api.pagarFatura(cartaoId, mesFatura, contaOrigemId);
      setShowModalPagarFatura(null);
      notificar(res.mensagem || "Fatura liquidada com sucesso!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleToggleFixa = async (id: number) => {
    try {
      await api.toggleDespesaFixa(id);
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleCriarFixa = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.criarDespesaFixa({
        descricao: fixaForm.descricao,
        valor: parseFloat(fixaForm.valor),
        categoria: fixaForm.categoria,
        dia_vencimento: parseInt(String(fixaForm.dia_vencimento)),
        ativa: fixaForm.ativa
      });
      setShowModalFixa(false);
      setFixaForm({
        descricao: '',
        valor: '',
        categoria: 'Assinaturas & Serviços',
        dia_vencimento: 10,
        ativa: true
      });
      notificar("Despesa fixa adicionada!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleCriarWishlist = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.criarWishlist({
        item: wishForm.item,
        categoria: wishForm.categoria,
        valor_estimado: parseFloat(wishForm.valor_estimado),
        parcelas_sugeridas: parseInt(String(wishForm.parcelas_sugeridas)),
        prioridade: wishForm.prioridade,
        condicao_compra: wishForm.condicao_compra,
        link_ou_obs: wishForm.link_ou_obs
      });
      setShowModalWish(false);
      setWishForm({
        item: '',
        categoria: 'Setup / Equipamento',
        valor_estimado: '',
        parcelas_sugeridas: 1,
        prioridade: 'Media',
        condicao_compra: '',
        link_ou_obs: ''
      });
      notificar("Item salvo na Wishlist!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleEfetivarWish = async (itemId: number, contaId: number, numParcelas: number) => {
    try {
      const res = await api.efetivarWishlist(itemId, contaId, numParcelas);
      setShowModalEfetivarWish(null);
      notificar(res.mensagem || "Compra da Wishlist efetivada no sistema!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro ao efetivar: " + err.message);
    }
  };

  const handleExecutarSimulacao = async () => {
    if (!simForm.valor || parseFloat(simForm.valor) <= 0) return;
    try {
      const res = await api.getSimulador({
        mes_inicio: mesRef,
        sim_descricao: simForm.descricao || "Simulação",
        sim_valor: parseFloat(simForm.valor),
        sim_parcelas: simForm.parcelas,
        sim_mes_inicio: simForm.mes_inicio
      });
      setSimResult(res.simulacao);
      notificar("Simulação calculada em tempo real!");
    } catch (err: any) {
      notificar("Erro na simulação: " + err.message);
    }
  };

  const formatBRL = (v: number) => {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  };

  // Cálculo Oráculo PIX vs Cartão
  const calcularOraculo = () => {
    const pix = parseFloat(oraculoForm.precoPix) || 0;
    const cartao = parseFloat(oraculoForm.precoCartao) || 0;
    const nParc = parseInt(String(oraculoForm.parcelas)) || 1;
    const taxaCdiMensal = 0.0095; // 0.95% ao mês (115% CDI líquido aproximado)
    
    // Se pagar no cartão em N parcelas, mantendo o valor do Pix no CDB rendendo enquanto paga cada parcela:
    let saldoCdb = pix;
    let rendimentoTotal = 0;
    const parcela = cartao / nParc;
    
    for (let i = 0; i < nParc; i++) {
      const rend = saldoCdb * taxaCdiMensal;
      rendimentoTotal += rend;
      saldoCdb = Math.max(0, saldoCdb + rend - parcela);
    }

    const descontoPixNominal = cartao - pix;
    const ganhoRealPixVsCartao = descontoPixNominal - rendimentoTotal;
    const recomendePix = ganhoRealPixVsCartao >= 0;

    return {
      descontoPixNominal,
      rendimentoTotal,
      ganhoRealPixVsCartao: Math.abs(ganhoRealPixVsCartao),
      recomendePix,
      parcelaMensal: parcela
    };
  };

  const resultadoOraculo = calcularOraculo();

  // Filtragem de transações
  const transacoesFiltradas = transacoes.filter(tx => {
    const matchesSearch = tx.descricao.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          tx.categoria.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesBanco = filterBanco === 'TODOS' || tx.conta_nome.toLowerCase().includes(filterBanco.toLowerCase());
    return matchesSearch && matchesBanco;
  });

  return (
    <div className="flex h-screen w-screen overflow-hidden bg-[#090d16] text-slate-100 antialiased font-sans">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-5 right-5 z-50 flex items-center gap-3 bg-indigo-600 text-white px-5 py-3 rounded-xl shadow-2xl border border-indigo-400/30 animate-bounce">
          <Sparkles className="w-5 h-5" />
          <span className="text-sm font-semibold">{toast}</span>
        </div>
      )}

      {/* Sidebar Lateral */}
      <aside className="w-64 border-r border-slate-800/80 bg-[#0c101c] flex flex-col justify-between p-4 select-none">
        <div>
          {/* Logo Brand */}
          <div className="flex items-center gap-3 px-3 py-4 mb-4 border-b border-slate-800">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-cyan-400 flex items-center justify-center font-black text-xl text-white shadow-lg shadow-indigo-500/20">
              ▲
            </div>
            <div>
              <h1 className="font-black text-base tracking-wider bg-gradient-to-r from-white via-slate-200 to-slate-400 bg-clip-text text-transparent">
                APEX FINANCE
              </h1>
              <span className="text-[10px] uppercase font-bold text-indigo-400 tracking-widest">
                Cockpit da Rocha 2.0
              </span>
            </div>
          </div>

          {/* Navigation Links */}
          <nav className="space-y-1">
            {[
              { id: 'dashboard', label: 'Dashboard & HUD', icon: LayoutDashboard },
              { id: 'faturas', label: 'Cartões & Faturas', icon: CreditCard },
              { id: 'oraculo', label: 'Oráculo de Compras', icon: Calculator, badge: 'NOVO' },
              { id: 'transacoes', label: 'Extrato & Busca', icon: Receipt },
              { id: 'fixas', label: 'Custos Recorrentes', icon: Repeat },
              { id: 'alforria', label: 'Alforria (115% CDI)', icon: Rocket },
              { id: 'simulador', label: 'Máquina do Tempo', icon: History },
              { id: 'wishlist', label: 'Wishlist & Sonhos', icon: BookmarkCheck },
            ].map(item => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setActiveTab(item.id as any)}
                  className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium transition-all ${
                    isActive
                      ? 'bg-indigo-600/15 text-indigo-400 border border-indigo-500/30 shadow-sm'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className={`w-4 h-4 ${isActive ? 'text-indigo-400' : 'text-slate-400'}`} />
                    <span>{item.label}</span>
                  </div>
                  {item.badge && (
                    <span className="px-1.5 py-0.5 text-[9px] font-extrabold bg-indigo-500 text-white rounded">
                      {item.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Bottom Actions */}
        <div className="space-y-2 border-t border-slate-800/80 pt-4">
          <button
            onClick={() => setShowModalTx(true)}
            className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-indigo-600 to-indigo-500 hover:from-indigo-500 hover:to-indigo-400 text-white font-semibold py-2.5 px-4 rounded-xl shadow-lg shadow-indigo-600/20 text-sm transition-all active:scale-95"
          >
            <Plus className="w-4 h-4" />
            <span>Novo Lançamento</span>
          </button>
          
          <div className="flex gap-2">
            <button
              onClick={async () => {
                const res = await api.exportarExcel();
                notificar("Planilha gerada: " + res.caminho.split('/').pop());
              }}
              title="Exportar Excel XLSX"
              className="flex-1 flex items-center justify-center gap-1.5 bg-slate-800/80 hover:bg-slate-800 text-emerald-400 py-2 rounded-lg text-xs font-medium border border-slate-700/50"
            >
              <FileSpreadsheet className="w-3.5 h-3.5" />
              <span>Excel</span>
            </button>

            <button
              onClick={async () => {
                await api.exportarIA();
                notificar("Contexto IA exportado para /mnt/dados!");
              }}
              title="Exportar Markdown para Contexto IA"
              className="flex-1 flex items-center justify-center gap-1.5 bg-slate-800/80 hover:bg-slate-800 text-cyan-400 py-2 rounded-lg text-xs font-medium border border-slate-700/50"
            >
              <Sparkles className="w-3.5 h-3.5" />
              <span>Contexto IA</span>
            </button>
          </div>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col overflow-hidden">
        {/* Top Header */}
        <header className="h-16 border-b border-slate-800/80 bg-[#0c101c]/60 backdrop-blur px-8 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <h2 className="text-lg font-black text-slate-100 uppercase tracking-wide flex items-center gap-2">
              {activeTab === 'dashboard' && 'Visão Executiva & Cockpit Financeiro'}
              {activeTab === 'faturas' && 'Cartões de Crédito & Quitação das Faturas'}
              {activeTab === 'oraculo' && 'Oráculo de Decisão: PIX à Vista vs. Cartão Sem Juros'}
              {activeTab === 'transacoes' && 'Extrato Geral com Filtros Inteligentes'}
              {activeTab === 'fixas' && 'Custos Fixos & Assinaturas Recorrentes'}
              {activeTab === 'alforria' && 'Projeto Alforria • Independência Financeira (115% CDI)'}
              {activeTab === 'simulador' && 'Máquina do Tempo • Simulador Preditivo'}
              {activeTab === 'wishlist' && 'Wishlist Estratégica • Compras Planejadas'}
            </h2>
          </div>

          <div className="flex items-center gap-3">
            <label className="text-xs text-slate-400 font-medium">Mês de Referência:</label>
            <input
              type="month"
              value={mesRef}
              onChange={(e) => setMesRef(e.target.value)}
              className="bg-slate-900 border border-slate-700/80 rounded-lg px-3 py-1.5 text-sm font-semibold text-indigo-300 focus:outline-none focus:border-indigo-500"
            />
            <button
              onClick={carregarTudo}
              title="Atualizar Dados"
              className="p-2 bg-slate-800/80 hover:bg-slate-800 rounded-lg text-slate-300 hover:text-white border border-slate-700/50 transition-colors"
            >
              <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
            </button>
          </div>
        </header>

        {/* Body Content */}
        <div className="flex-1 overflow-y-auto p-8 space-y-8">
          {/* TAB 1: DASHBOARD */}
          {activeTab === 'dashboard' && hud && (
            <div className="space-y-8 animate-fadeIn">
              {/* HUD Cards */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                {/* Saldo Líquido */}
                <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-5 relative overflow-hidden shadow-sm">
                  <div className="flex items-center justify-between text-slate-400 mb-2">
                    <span className="text-xs font-semibold uppercase tracking-wider">Saldo Líquido em Conta</span>
                    <ArrowUpRight className="w-4 h-4 text-emerald-400" />
                  </div>
                  <div className="text-2xl font-black text-emerald-400">
                    {formatBRL(hud.saldo_total)}
                  </div>
                  <div className="text-[11px] text-slate-500 mt-2 font-medium">
                    Disponível no banco
                  </div>
                  <div className="absolute -right-4 -bottom-4 w-20 h-20 bg-emerald-500/5 rounded-full blur-xl pointer-events-none" />
                </div>

                {/* Faturas a Vencer */}
                <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-5 relative overflow-hidden shadow-sm">
                  <div className="flex items-center justify-between text-slate-400 mb-2">
                    <span className="text-xs font-semibold uppercase tracking-wider">Faturas ({mesRef})</span>
                    <ArrowDownRight className="w-4 h-4 text-rose-400" />
                  </div>
                  <div className="text-2xl font-black text-rose-400">
                    {formatBRL(hud.faturas_pendentes)}
                  </div>
                  <div className="text-[11px] text-slate-500 mt-2 font-medium">
                    Comprometimento nos cartões
                  </div>
                  <div className="absolute -right-4 -bottom-4 w-20 h-20 bg-rose-500/5 rounded-full blur-xl pointer-events-none" />
                </div>

                {/* Teto de Oxigênio Semanal */}
                <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-5 relative overflow-hidden shadow-sm">
                  <div className="flex items-center justify-between text-slate-400 mb-2">
                    <span className="text-xs font-semibold uppercase tracking-wider">Teto de Oxigênio / Semanal</span>
                    <ShieldCheck className="w-4 h-4 text-cyan-400" />
                  </div>
                  <div className="text-2xl font-black text-cyan-400">
                    {formatBRL(Math.max(0, (2234.0 - hud.total_despesas_fixas) / 4))}
                  </div>
                  <div className="text-[11px] text-slate-500 mt-2 font-medium">
                    Limite seguro de gastos do dia a dia
                  </div>
                  <div className="absolute -right-4 -bottom-4 w-20 h-20 bg-cyan-500/5 rounded-full blur-xl pointer-events-none" />
                </div>

                {/* Sobra Projetada */}
                <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-5 relative overflow-hidden shadow-sm">
                  <div className="flex items-center justify-between text-slate-400 mb-2">
                    <span className="text-xs font-semibold uppercase tracking-wider">Sobra Mês ("Depois das Contas")</span>
                    <TrendingUp className="w-4 h-4 text-indigo-400" />
                  </div>
                  <div className={`text-2xl font-black ${hud.sobra_livre >= 0 ? 'text-emerald-400' : 'text-rose-400'}`}>
                    {formatBRL(hud.sobra_livre)}
                  </div>
                  <div className="text-[11px] text-slate-400 mt-2 font-medium">
                    Salário Real: R$ 2.234,00
                  </div>
                  <div className="absolute -right-4 -bottom-4 w-20 h-20 bg-indigo-500/5 rounded-full blur-xl pointer-events-none" />
                </div>
              </div>

              {/* GRÁFICO 1: A CURVA DO EXTERMÍNIO DE DÍVIDAS */}
              <div className="bg-slate-900/80 border border-slate-800 rounded-2xl p-6 shadow-md">
                <div className="flex items-center justify-between mb-6">
                  <div>
                    <h3 className="text-base font-black text-slate-100 flex items-center gap-2">
                      <Zap className="w-5 h-5 text-amber-400" />
                      A Curva do Extermínio de Dívidas (Passo a Passo)
                    </h3>
                    <p className="text-xs text-slate-400 mt-0.5">
                      Visualização matemática da queda brutal das parcelas até a quitação total em 2027
                    </p>
                  </div>
                  <span className="px-3 py-1 rounded-full text-xs font-bold bg-amber-500/10 text-amber-400 border border-amber-500/20">
                    Faturas Despencam 75% até Dezembro
                  </span>
                </div>

                <div className="h-64 w-full">
                  <ResponsiveContainer width="100%" height="100%">
                    <AreaChart
                      data={timeline.slice(0, 7)}
                      margin={{ top: 10, right: 10, left: -20, bottom: 0 }}
                    >
                      <defs>
                        <linearGradient id="corFaturas" x1="0" y1="0" x2="0" y2="1">
                          <stop offset="5%" stopColor="#f43f5e" stopOpacity={0.4}/>
                          <stop offset="95%" stopColor="#f43f5e" stopOpacity={0}/>
                        </linearGradient>
                        <linearGradient id="corSobra" x1="0" y1="0" x2="0" y2="1">
                          <stop offset="5%" stopColor="#10b981" stopOpacity={0.4}/>
                          <stop offset="95%" stopColor="#10b981" stopOpacity={0}/>
                        </linearGradient>
                      </defs>
                      <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
                      <XAxis dataKey="mes" stroke="#64748b" fontSize={11} />
                      <YAxis stroke="#64748b" fontSize={11} />
                      <Tooltip
                        contentStyle={{ backgroundColor: '#0f172a', borderColor: '#334155', borderRadius: '12px' }}
                        formatter={(val: any) => formatBRL(val)}
                      />
                      <Area type="monotone" dataKey="faturas_cartao" name="Faturas dos Cartões" stroke="#f43f5e" strokeWidth={2} fillOpacity={1} fill="url(#corFaturas)" />
                      <Area type="monotone" dataKey="sobra_mes" name="Sobra Livre Mês" stroke="#10b981" strokeWidth={2} fillOpacity={1} fill="url(#corSobra)" />
                    </AreaChart>
                  </ResponsiveContainer>
                </div>
              </div>

              {/* Faturas Grid Detalhado */}
              <div className="bg-slate-900/60 border border-slate-800 rounded-2xl p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-sm font-bold uppercase tracking-wider text-slate-400">
                    Faturas Ativas em Aberto ({mesRef})
                  </h3>
                  <span className="text-xs text-indigo-400 font-mono">{faturas.length} faturas</span>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {faturas.map(fat => (
                    <div key={fat.cartao_id} className="p-4 bg-slate-800/40 rounded-xl border border-slate-800 flex flex-col justify-between">
                      <div className="flex items-start justify-between">
                        <div>
                          <div className="font-bold text-sm text-slate-100">{fat.cartao_nome}</div>
                          <div className="text-xs text-slate-400 mt-0.5">
                            Fecha: <span className="text-slate-300 font-semibold">{fat.dia_fechamento}</span> | Vence: <span className="text-slate-300 font-semibold">{fat.dia_vencimento}</span>
                          </div>
                        </div>
                        <span className={`px-2 py-0.5 rounded text-[10px] font-extrabold uppercase ${
                          fat.status === 'paga' ? 'bg-emerald-500/10 text-emerald-400' :
                          fat.total_fatura === 0 ? 'bg-slate-800 text-slate-400' :
                          'bg-rose-500/10 text-rose-400 border border-rose-500/20'
                        }`}>
                          {fat.total_fatura === 0 ? 'Zerada' : fat.status}
                        </span>
                      </div>

                      <div className="mt-4 pt-3 border-t border-slate-800/60 flex items-center justify-between">
                        <div>
                          <span className="text-[10px] text-slate-500 uppercase font-semibold">Valor</span>
                          <div className="text-base font-black text-rose-400">{formatBRL(fat.total_fatura)}</div>
                        </div>

                        {fat.total_fatura > 0 && (
                          <button
                            onClick={() => setShowModalPagarFatura(fat)}
                            className="px-2.5 py-1 bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-300 border border-emerald-500/30 rounded-lg text-xs font-bold transition-all"
                          >
                            Pagar
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* TAB: ORÁCULO DE COMPRAS (PIX vs CARTÃO) */}
          {activeTab === 'oraculo' && (
            <div className="space-y-6 animate-fadeIn">
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <div className="flex items-center gap-3 mb-3">
                  <div className="p-3 bg-indigo-600/20 text-indigo-400 rounded-xl border border-indigo-500/30">
                    <Calculator className="w-6 h-6" />
                  </div>
                  <div>
                    <h3 className="text-lg font-black text-slate-100">
                      Oráculo da Rocha: Pagar à Vista no PIX ou Parcelar sem Juros?
                    </h3>
                    <p className="text-xs text-slate-400">
                      Calcula com precisão se o desconto do PIX supera o rendimento do dinheiro aplicado no CDI (115%).
                    </p>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1">Item / Produto</label>
                    <input
                      type="text"
                      value={oraculoForm.item}
                      onChange={e => setOraculoForm({ ...oraculoForm, item: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1">Preço no PIX à Vista (R$)</label>
                    <input
                      type="number"
                      value={oraculoForm.precoPix}
                      onChange={e => setOraculoForm({ ...oraculoForm, precoPix: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1">Preço no Cartão Sem Juros (R$)</label>
                    <input
                      type="number"
                      value={oraculoForm.precoCartao}
                      onChange={e => setOraculoForm({ ...oraculoForm, precoCartao: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1">Número de Parcelas Sem Juros</label>
                    <input
                      type="number"
                      min="1"
                      max="24"
                      value={oraculoForm.parcelas}
                      onChange={e => setOraculoForm({ ...oraculoForm, parcelas: parseInt(e.target.value) || 1 })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>
                </div>

                {/* Veredicto do Oráculo */}
                <div className={`mt-8 p-6 rounded-2xl border ${
                  resultadoOraculo.recomendePix 
                    ? 'bg-emerald-950/20 border-emerald-500/30' 
                    : 'bg-indigo-950/20 border-indigo-500/30'
                }`}>
                  <div className="flex items-center justify-between">
                    <div>
                      <span className="text-xs font-bold uppercase tracking-wider text-slate-400">Veredicto Matemático:</span>
                      <h4 className={`text-xl font-black mt-1 ${
                        resultadoOraculo.recomendePix ? 'text-emerald-400' : 'text-indigo-400'
                      }`}>
                        {resultadoOraculo.recomendePix 
                          ? '🏆 PAGUE À VISTA NO PIX COM DESCONTO!' 
                          : '💳 PARCELE SEM JUROS NO CARTÃO CAIXA!'}
                      </h4>
                    </div>

                    <div className="text-right">
                      <div className="text-xs text-slate-400">Vantagem Financeira Líquida</div>
                      <div className="text-2xl font-black text-white">
                        {formatBRL(resultadoOraculo.ganhoRealPixVsCartao)}
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-6 pt-4 border-t border-slate-800/80 text-xs">
                    <div>
                      <span className="text-slate-400 block">Desconto Nominal do PIX:</span>
                      <span className="font-bold text-slate-200 text-sm">{formatBRL(resultadoOraculo.descontoPixNominal)}</span>
                    </div>
                    <div>
                      <span className="text-slate-400 block">Rendimento no CDB se parcelar:</span>
                      <span className="font-bold text-slate-200 text-sm">+{formatBRL(resultadoOraculo.rendimentoTotal)}</span>
                    </div>
                    <div>
                      <span className="text-slate-400 block">Parcela Mensal no Cartão:</span>
                      <span className="font-bold text-slate-200 text-sm">{oraculoForm.parcelas}x de {formatBRL(resultadoOraculo.parcelaMensal)}</span>
                    </div>
                  </div>

                  <div className="mt-4 p-3 bg-slate-900/60 rounded-xl text-xs text-slate-300">
                    💡 <span className="font-bold">Regra do Homem Rocha:</span> {resultadoOraculo.recomendePix 
                      ? 'O desconto do PIX é maior do que o CDI geraria durante o tempo do parcelamento. Pague à vista no PIX e não crie fatura futura!' 
                      : 'O desconto do PIX é muito baixo ou zero. Deixe o dinheiro rendendo no CDB a 115% do CDI na Caixinha do Nubank e passe no Cartão Caixa para acumular pontuação e prazo.'}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB: EXTRATO COM BUSCA RÁPIDA */}
          {activeTab === 'transacoes' && (
            <div className="space-y-4 animate-fadeIn">
              <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
                {/* Search Bar */}
                <div className="flex items-center gap-3 w-full md:w-auto">
                  <div className="relative w-full md:w-80">
                    <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
                    <input
                      type="text"
                      placeholder="Pesquisar lançamentos (ex: Shopee, Carne, Moto)..."
                      value={searchTerm}
                      onChange={e => setSearchTerm(e.target.value)}
                      className="w-full bg-slate-900 border border-slate-800 rounded-xl pl-9 pr-4 py-2 text-xs text-slate-200 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  {/* Filter Banco */}
                  <select
                    value={filterBanco}
                    onChange={e => setFilterBanco(e.target.value)}
                    className="bg-slate-900 border border-slate-800 rounded-xl px-3 py-2 text-xs text-slate-300 focus:outline-none focus:border-indigo-500"
                  >
                    <option value="TODOS">Todos os Bancos</option>
                    <option value="Nubank">Nubank</option>
                    <option value="Caixa">Caixa</option>
                    <option value="PicPay">PicPay</option>
                    <option value="Inter">Inter</option>
                    <option value="Shopee">Shopee</option>
                  </select>
                </div>

                <button
                  onClick={() => setShowModalTx(true)}
                  className="flex items-center gap-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold py-2 px-3.5 rounded-lg"
                >
                  <Plus className="w-4 h-4" />
                  <span>Novo Lançamento</span>
                </button>
              </div>

              <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-950/60 text-slate-400 uppercase font-semibold border-b border-slate-800">
                    <tr>
                      <th className="py-3 px-4">Data</th>
                      <th className="py-3 px-4">Descrição</th>
                      <th className="py-3 px-4">Categoria</th>
                      <th className="py-3 px-4">Conta / Cartão</th>
                      <th className="py-3 px-4">Parcela / Fatura</th>
                      <th className="py-3 px-4 text-right">Valor</th>
                      <th className="py-3 px-4 text-center">Ações</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-800/50">
                    {transacoesFiltradas.map((tx) => (
                      <tr key={tx.id} className="hover:bg-slate-800/30 transition-colors">
                        <td className="py-3 px-4 font-mono text-slate-400">{tx.data_transacao}</td>
                        <td className="py-3 px-4 font-bold text-slate-200">
                          {tx.descricao}
                          {tx.serie_parcelamento_id && (
                            <span className="ml-2 px-1.5 py-0.5 rounded bg-indigo-900/40 text-indigo-400 text-[10px] font-mono border border-indigo-700/30">
                              PARCELADO
                            </span>
                          )}
                        </td>
                        <td className="py-3 px-4">
                          <span className="px-2 py-0.5 rounded-md bg-slate-800 text-slate-300 text-[11px]">
                            {tx.categoria}
                          </span>
                        </td>
                        <td className="py-3 px-4 text-slate-300">{tx.conta_nome}</td>
                        <td className="py-3 px-4 text-slate-400 font-mono">
                          {tx.parcela_atual ? `${tx.parcela_atual}/${tx.total_parcelas}` : '-'}
                          {tx.mes_fatura && ` (${tx.mes_fatura})`}
                        </td>
                        <td className={`py-3 px-4 text-right font-mono font-bold ${tx.tipo === 'receita' ? 'text-emerald-400' : 'text-rose-400'}`}>
                          {tx.tipo === 'receita' ? '+' : '-'} {formatBRL(tx.valor)}
                        </td>
                        <td className="py-3 px-4 text-center">
                          <button
                            onClick={() => handleDeletarTransacao(tx.id, tx.serie_parcelamento_id)}
                            title="Excluir Transação"
                            className="p-1.5 hover:bg-rose-500/10 text-slate-500 hover:text-rose-400 rounded-lg transition-colors"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 2: FATURAS & CARTÕES */}
          {activeTab === 'faturas' && (
            <div className="space-y-6 animate-fadeIn">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {faturas.map(fat => (
                  <div key={fat.cartao_id} className="bg-slate-900 border border-slate-800 rounded-2xl p-6 flex flex-col justify-between shadow-lg">
                    <div>
                      <div className="flex items-center justify-between mb-4">
                        <div className="flex items-center gap-3">
                          <div className="p-3 bg-indigo-600/10 text-indigo-400 rounded-xl border border-indigo-500/20">
                            <CreditCard className="w-6 h-6" />
                          </div>
                          <div>
                            <h3 className="font-extrabold text-lg text-slate-100">{fat.cartao_nome}</h3>
                            <span className="text-xs text-slate-400">Ciclo de faturamento ativo</span>
                          </div>
                        </div>
                        <span className={`px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wide ${
                          fat.status === 'paga' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' :
                          fat.total_fatura === 0 ? 'bg-slate-800 text-slate-400' :
                          'bg-rose-500/10 text-rose-400 border border-rose-500/20'
                        }`}>
                          {fat.total_fatura === 0 ? 'Zerada' : fat.status}
                        </span>
                      </div>

                      <div className="grid grid-cols-2 gap-4 my-6 p-4 bg-slate-800/30 rounded-xl border border-slate-800">
                        <div>
                          <div className="text-xs text-slate-400">Dia de Fechamento</div>
                          <div className="text-sm font-bold text-slate-200 mt-0.5">Dia {fat.dia_fechamento} de cada mês</div>
                        </div>
                        <div>
                          <div className="text-xs text-slate-400">Dia de Vencimento</div>
                          <div className="text-sm font-bold text-slate-200 mt-0.5">Dia {fat.dia_vencimento} de cada mês</div>
                        </div>
                      </div>

                      <div className="flex items-baseline justify-between">
                        <div>
                          <div className="text-xs font-semibold text-slate-400 uppercase tracking-wide">Total da Fatura ({fat.mes_fatura})</div>
                          <div className="text-3xl font-black text-rose-400 mt-1">{formatBRL(fat.total_fatura)}</div>
                        </div>
                      </div>
                    </div>

                    <div className="mt-8 pt-4 border-t border-slate-800/80 flex items-center justify-between">
                      <span className="text-xs text-slate-500 font-medium">
                        {fat.total_fatura === 0 ? 'Sem lançamentos pendentes' : 'Aguardando liquidação'}
                      </span>
                      {fat.total_fatura > 0 && (
                        <button
                          onClick={() => setShowModalPagarFatura(fat)}
                          className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-sm transition-all shadow-lg shadow-emerald-600/20"
                        >
                          Pagar Fatura Agora
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* TAB 4: DESPESAS FIXAS */}
          {activeTab === 'fixas' && (
            <div className="space-y-4 animate-fadeIn">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-base font-bold text-slate-200">Custos Fixos & Recorrentes</h3>
                  <span className="text-xs text-slate-500">Despesas que ocorrem todo mês automaticamente na projeção</span>
                </div>
                <button
                  onClick={() => setShowModalFixa(true)}
                  className="flex items-center gap-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold py-2 px-3.5 rounded-lg"
                >
                  <Plus className="w-4 h-4" />
                  <span>Nova Despesa Fixa</span>
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {despesasFixas.map(df => {
                  const isAtiva = Boolean(df.ativa);
                  return (
                    <div key={df.id} className={`p-5 rounded-2xl border transition-all ${
                      isAtiva ? 'bg-slate-900 border-slate-800' : 'bg-slate-900/40 border-slate-800/40 opacity-60'
                    }`}>
                      <div className="flex items-start justify-between">
                        <div>
                          <div className="font-extrabold text-base text-slate-100">{df.descricao}</div>
                          <span className="text-xs text-slate-400">{df.categoria} • Vence dia {df.dia_vencimento}</span>
                        </div>
                        <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase ${
                          isAtiva ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' : 'bg-slate-800 text-slate-500'
                        }`}>
                          {isAtiva ? 'Ativa' : 'Pausada'}
                        </span>
                      </div>

                      <div className="mt-4 flex items-baseline justify-between">
                        <div className="text-xl font-black text-amber-400 font-mono">
                          {formatBRL(df.valor)}
                        </div>
                        <div className="flex items-center gap-2">
                          <button
                            onClick={() => handleToggleFixa(df.id)}
                            className={`px-3 py-1 text-xs font-bold rounded-lg border transition-all ${
                              isAtiva 
                                ? 'bg-amber-500/10 hover:bg-amber-500/20 text-amber-400 border-amber-500/30' 
                                : 'bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-400 border-emerald-500/30'
                            }`}
                          >
                            {isAtiva ? 'Pausar' : 'Ativar'}
                          </button>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* TAB 5: ALFORRIA & CDI */}
          {activeTab === 'alforria' && (
            <div className="space-y-6 animate-fadeIn">
              <div className="bg-gradient-to-r from-indigo-950/60 to-slate-900 border border-indigo-800/40 rounded-2xl p-6">
                <div className="flex items-center gap-4">
                  <div className="p-4 bg-indigo-600 text-white rounded-2xl shadow-lg shadow-indigo-600/30">
                    <Rocket className="w-8 h-8" />
                  </div>
                  <div>
                    <h3 className="text-xl font-black text-white">Projeto Alforria • 115% do CDI</h3>
                    <p className="text-xs text-indigo-200/80 mt-1 max-w-2xl">
                      Construção do patrimônio sagrado rumo aos R$ 27.000 para a moradia soberana e liberdade.
                    </p>
                  </div>
                </div>
              </div>

              {/* Tabela de Evolução da Alforria */}
              <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-950/60 text-slate-400 uppercase font-semibold border-b border-slate-800">
                    <tr>
                      <th className="py-3 px-4">Mês</th>
                      <th className="py-3 px-4">Saldo Inicial</th>
                      <th className="py-3 px-4">Aporte Mensal</th>
                      <th className="py-3 px-4">Rendimento CDI (115%)</th>
                      <th className="py-3 px-4 text-right">Patrimônio Acumulado</th>
                      <th className="py-3 px-4 text-right">Renda Passiva Futura/mês</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-800/50 font-mono">
                    {alforria.slice(0, 24).map((row) => (
                      <tr key={row.mes} className="hover:bg-slate-800/30 transition-colors">
                        <td className="py-3 px-4 font-bold text-slate-200">{row.mes}</td>
                        <td className="py-3 px-4 text-slate-400">{formatBRL(row.saldo_inicial)}</td>
                        <td className="py-3 px-4 text-emerald-400 font-bold">{formatBRL(row.aporte)}</td>
                        <td className="py-3 px-4 text-cyan-400">+{formatBRL(row.rendimento_cdi)}</td>
                        <td className="py-3 px-4 text-right font-black text-white">{formatBRL(row.saldo_final)}</td>
                        <td className="py-3 px-4 text-right font-bold text-indigo-300">
                          +{formatBRL(row.rendimento_mensal_futuro)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 6: MÁQUINA DO TEMPO / SIMULADOR */}
          {activeTab === 'simulador' && (
            <div className="space-y-6 animate-fadeIn">
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <h3 className="text-base font-black text-slate-100 mb-2 flex items-center gap-2">
                  <History className="w-5 h-5 text-indigo-400" />
                  Simulador de Impacto de Novas Compras
                </h3>
                <p className="text-xs text-slate-400 mb-6">
                  Descubra exatamente como uma nova compra parcelada vai alterar sua folga de caixa e sobras nos próximos meses.
                </p>

                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Descrição do Item</label>
                    <input
                      type="text"
                      placeholder="Ex: Fone QCY H3 Pro"
                      value={simForm.descricao}
                      onChange={e => setSimForm({ ...simForm, descricao: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Valor Total (R$)</label>
                    <input
                      type="number"
                      placeholder="365.00"
                      value={simForm.valor}
                      onChange={e => setSimForm({ ...simForm, valor: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Número de Parcelas</label>
                    <input
                      type="number"
                      min="1"
                      max="24"
                      value={simForm.parcelas}
                      onChange={e => setSimForm({ ...simForm, parcelas: parseInt(e.target.value) || 1 })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Mês de Início</label>
                    <input
                      type="month"
                      value={simForm.mes_inicio}
                      onChange={e => setSimForm({ ...simForm, mes_inicio: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>
                </div>

                <div className="mt-5 flex justify-end">
                  <button
                    onClick={handleExecutarSimulacao}
                    className="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold rounded-xl text-sm transition-all shadow-lg shadow-indigo-600/20"
                  >
                    Simular Impacto no Fluxo de Caixa
                  </button>
                </div>
              </div>

              {simResult && (
                <div className="bg-slate-900 border border-indigo-500/30 rounded-2xl p-6 animate-fadeIn">
                  <h4 className="text-sm font-extrabold text-indigo-300 uppercase tracking-wider mb-4">
                    Resultado da Simulação: {simResult.compra_simulada} ({simResult.num_parcelas}x de {formatBRL(simResult.parcela_mensal)})
                  </h4>
                  <div className="overflow-x-auto">
                    <table className="w-full text-left text-xs font-mono">
                      <thead className="text-slate-400 uppercase border-b border-slate-800">
                        <tr>
                          <th className="py-2.5 px-3">Mês</th>
                          <th className="py-2.5 px-3">Parcela Adicional</th>
                          <th className="py-2.5 px-3">Sobra Original</th>
                          <th className="py-2.5 px-3">Nova Sobra Pós-Compra</th>
                          <th className="py-2.5 px-3 text-right">Novo Saldo Acumulado</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-800/40">
                        {simResult.impacto_mensal.map((m: any) => (
                          <tr key={m.mes} className="hover:bg-slate-800/30">
                            <td className="py-3 px-3 font-bold text-slate-200">{m.mes}</td>
                            <td className="py-3 px-3 text-rose-400 font-bold">-{formatBRL(m.parcela_simulada)}</td>
                            <td className="py-3 px-3 text-slate-400">{formatBRL(m.sobra_original)}</td>
                            <td className={`py-3 px-3 font-bold ${m.sobra_simulada >= 0 ? 'text-cyan-400' : 'text-red-400'}`}>
                              {formatBRL(m.sobra_simulada)}
                            </td>
                            <td className="py-3 px-3 text-right font-black text-white">{formatBRL(m.saldo_simulado)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* TAB 7: WISHLIST & COMPRAS FUTURAS */}
          {activeTab === 'wishlist' && (
            <div className="space-y-4 animate-fadeIn">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-base font-bold text-slate-200">Wishlist & Sonhos Planejados</h3>
                  <span className="text-xs text-slate-500">Itens congelados para comprar após quitação ou folga de caixa</span>
                </div>
                <button
                  onClick={() => setShowModalWish(true)}
                  className="flex items-center gap-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold py-2 px-3.5 rounded-lg"
                >
                  <Plus className="w-4 h-4" />
                  <span>Novo Item Wishlist</span>
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {wishlist.map(item => (
                  <div key={item.id} className="bg-slate-900 border border-slate-800 rounded-2xl p-5 flex flex-col justify-between shadow-md">
                    <div>
                      <div className="flex items-start justify-between">
                        <div>
                          <h4 className="font-extrabold text-base text-slate-100">{item.item}</h4>
                          <span className="text-xs text-slate-400">{item.categoria}</span>
                        </div>
                        <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-extrabold uppercase ${
                          item.status === 'comprado' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' :
                          item.prioridade === 'Alta' ? 'bg-rose-500/10 text-rose-400 border border-rose-500/20' :
                          'bg-indigo-500/10 text-indigo-400 border border-indigo-500/20'
                        }`}>
                          {item.status === 'comprado' ? 'Comprado' : `Prioridade ${item.prioridade}`}
                        </span>
                      </div>

                      <div className="my-4 p-3 bg-slate-800/40 rounded-xl border border-slate-800 space-y-1.5">
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-slate-400">Valor Estimado:</span>
                          <span className="font-mono font-bold text-slate-100">{formatBRL(item.valor_estimado)}</span>
                        </div>
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-slate-400">Parcelamento:</span>
                          <span className="font-mono text-slate-300">{item.parcelas_sugeridas}x sem juros</span>
                        </div>
                      </div>

                      {item.condicao_compra && (
                        <div className="text-xs text-slate-400 italic bg-slate-950/40 p-2.5 rounded-lg border border-slate-800/80 mb-4">
                          🎯 Regra: {item.condicao_compra}
                        </div>
                      )}
                    </div>

                    <div className="pt-3 border-t border-slate-800 flex items-center justify-between">
                      <button
                        onClick={async () => {
                          if (window.confirm("Deseja remover este item da Wishlist?")) {
                            await api.deletarWishlist(item.id);
                            notificar("Item removido!");
                            carregarTudo();
                          }
                        }}
                        className="text-slate-500 hover:text-rose-400 p-1.5 rounded-lg transition-colors"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>

                      {item.status !== 'comprado' && (
                        <button
                          onClick={() => setShowModalEfetivarWish(item)}
                          className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-lg text-xs transition-all shadow-md shadow-emerald-600/20"
                        >
                          <CheckCircle className="w-3.5 h-3.5" />
                          <span>Efetivar Compra Real</span>
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </main>

      {/* MODAL: NOVA TRANSAÇÃO */}
      {showModalTx && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl">
            <h3 className="text-base font-black text-slate-100 mb-4">Novo Lançamento</h3>
            <form onSubmit={handleCriarTransacao} className="space-y-4">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Descrição</label>
                <input
                  type="text"
                  required
                  placeholder="Ex: Aluguel, Mercado, Gasolina"
                  value={txForm.descricao}
                  onChange={e => setTxForm({ ...txForm, descricao: e.target.value })}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Valor Total (R$)</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    placeholder="0.00"
                    value={txForm.valor}
                    onChange={e => setTxForm({ ...txForm, valor: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Tipo</label>
                  <select
                    value={txForm.tipo}
                    onChange={e => setTxForm({ ...txForm, tipo: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  >
                    <option value="despesa">Despesa</option>
                    <option value="receita">Receita</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Conta / Cartão</label>
                  <select
                    value={txForm.conta_id}
                    onChange={e => setTxForm({ ...txForm, conta_id: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  >
                    {contas.map(c => (
                      <option key={c.id} value={c.id}>{c.nome}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Categoria</label>
                  <input
                    type="text"
                    value={txForm.categoria}
                    onChange={e => setTxForm({ ...txForm, categoria: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Data</label>
                  <input
                    type="date"
                    value={txForm.data_transacao}
                    onChange={e => setTxForm({ ...txForm, data_transacao: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Nº de Parcelas</label>
                  <input
                    type="number"
                    min="1"
                    max="48"
                    value={txForm.num_parcelas}
                    onChange={e => setTxForm({ ...txForm, num_parcelas: parseInt(e.target.value) || 1 })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>
              </div>

              <div className="flex justify-end gap-2 pt-4 border-t border-slate-800">
                <button
                  type="button"
                  onClick={() => setShowModalTx(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl"
                >
                  Salvar Lançamento
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* MODAL: PAGAR FATURA */}
      {showModalPagarFatura && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl">
            <h3 className="text-base font-black text-slate-100 mb-2">Liquidar Fatura do Cartão</h3>
            <p className="text-xs text-slate-400 mb-4">
              Pagar fatura de <span className="text-white font-bold">{showModalPagarFatura.cartao_nome}</span> no valor de{' '}
              <span className="text-rose-400 font-bold">{formatBRL(showModalPagarFatura.total_fatura)}</span> referente ao mês de{' '}
              <span className="text-indigo-300 font-bold">{showModalPagarFatura.mes_fatura}</span>.
            </p>

            <div className="mb-4">
              <label className="text-xs text-slate-400 font-medium block mb-1">Debitar de qual Conta?</label>
              <select
                id="contaOrigemPagar"
                className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                defaultValue={contas.find(c => c.tipo === 'corrente')?.id || contas[0]?.id}
              >
                {contas.filter(c => c.tipo !== 'cartao_credito').map(c => (
                  <option key={c.id} value={c.id}>
                    {c.nome} (Saldo: {formatBRL(c.saldo_atual)})
                  </option>
                ))}
              </select>
            </div>

            <div className="flex justify-end gap-2 pt-4 border-t border-slate-800">
              <button
                type="button"
                onClick={() => setShowModalPagarFatura(null)}
                className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
              >
                Cancelar
              </button>
              <button
                type="button"
                onClick={() => {
                  const sel = document.getElementById('contaOrigemPagar') as HTMLSelectElement;
                  handlePagarFatura(
                    showModalPagarFatura.cartao_id,
                    showModalPagarFatura.mes_fatura,
                    parseInt(sel.value)
                  );
                }}
                className="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold rounded-xl"
              >
                Confirmar Pagamento
              </button>
            </div>
          </div>
        </div>
      )}

      {/* MODAL: EFETIVAR WISHLIST */}
      {showModalEfetivarWish && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl">
            <h3 className="text-base font-black text-slate-100 mb-2">Efetivar Compra da Wishlist</h3>
            <p className="text-xs text-slate-400 mb-4">
              Item: <span className="text-white font-bold">{showModalEfetivarWish.item}</span> (Est: {formatBRL(showModalEfetivarWish.valor_estimado)})
            </p>

            <div className="space-y-3">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Qual Cartão ou Conta?</label>
                <select
                  id="contaEfetivarWish"
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  defaultValue={contas.find(c => c.tipo === 'cartao_credito')?.id || contas[0]?.id}
                >
                  {contas.map(c => (
                    <option key={c.id} value={c.id}>{c.nome}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Número de Parcelas</label>
                <input
                  id="parcelasEfetivarWish"
                  type="number"
                  min="1"
                  max="24"
                  defaultValue={showModalEfetivarWish.parcelas_sugeridas || 1}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-4 border-t border-slate-800 mt-4">
              <button
                type="button"
                onClick={() => setShowModalEfetivarWish(null)}
                className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
              >
                Cancelar
              </button>
              <button
                type="button"
                onClick={() => {
                  const selConta = document.getElementById('contaEfetivarWish') as HTMLSelectElement;
                  const inpParc = document.getElementById('parcelasEfetivarWish') as HTMLInputElement;
                  handleEfetivarWish(
                    showModalEfetivarWish.id,
                    parseInt(selConta.value),
                    parseInt(inpParc.value) || 1
                  );
                }}
                className="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold rounded-xl"
              >
                Lançar Compra Real
              </button>
            </div>
          </div>
        </div>
      )}

      {/* MODAL: NOVO ITEM WISHLIST */}
      {showModalWish && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl">
            <h3 className="text-base font-black text-slate-100 mb-4">Adicionar à Wishlist</h3>
            <form onSubmit={handleCriarWishlist} className="space-y-3">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Nome do Item</label>
                <input
                  type="text"
                  required
                  placeholder="Ex: Cadeira Ergonômica"
                  value={wishForm.item}
                  onChange={e => setWishForm({ ...wishForm, item: e.target.value })}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Valor Estimado (R$)</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    placeholder="0.00"
                    value={wishForm.valor_estimado}
                    onChange={e => setWishForm({ ...wishForm, valor_estimado: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Parcelas Sugeridas</label>
                  <input
                    type="number"
                    min="1"
                    value={wishForm.parcelas_sugeridas}
                    onChange={e => setWishForm({ ...wishForm, parcelas_sugeridas: parseInt(e.target.value) || 1 })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Categoria</label>
                  <input
                    type="text"
                    value={wishForm.categoria}
                    onChange={e => setWishForm({ ...wishForm, categoria: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Prioridade</label>
                  <select
                    value={wishForm.prioridade}
                    onChange={e => setWishForm({ ...wishForm, prioridade: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  >
                    <option value="Baixa">Baixa</option>
                    <option value="Media">Média</option>
                    <option value="Alta">Alta</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Condição de Compra</label>
                <input
                  type="text"
                  placeholder="Ex: Apenas após quitar a dívida X"
                  value={wishForm.condicao_compra}
                  onChange={e => setWishForm({ ...wishForm, condicao_compra: e.target.value })}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="flex justify-end gap-2 pt-4 border-t border-slate-800">
                <button
                  type="button"
                  onClick={() => setShowModalWish(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl"
                >
                  Salvar na Wishlist
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* MODAL: NOVA DESPESA FIXA */}
      {showModalFixa && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl">
            <h3 className="text-base font-black text-slate-100 mb-4">Nova Despesa Fixa</h3>
            <form onSubmit={handleCriarFixa} className="space-y-3">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Descrição</label>
                <input
                  type="text"
                  required
                  placeholder="Ex: Internet Fibra"
                  value={fixaForm.descricao}
                  onChange={e => setFixaForm({ ...fixaForm, descricao: e.target.value })}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Valor Mensal (R$)</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    placeholder="0.00"
                    value={fixaForm.valor}
                    onChange={e => setFixaForm({ ...fixaForm, valor: e.target.value })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>

                <div>
                  <label className="text-xs text-slate-400 font-medium block mb-1">Dia do Vencimento</label>
                  <input
                    type="number"
                    min="1"
                    max="31"
                    value={fixaForm.dia_vencimento}
                    onChange={e => setFixaForm({ ...fixaForm, dia_vencimento: parseInt(e.target.value) || 1 })}
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                  />
                </div>
              </div>

              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Categoria</label>
                <input
                  type="text"
                  value={fixaForm.categoria}
                  onChange={e => setFixaForm({ ...fixaForm, categoria: e.target.value })}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="flex justify-end gap-2 pt-4 border-t border-slate-800">
                <button
                  type="button"
                  onClick={() => setShowModalFixa(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl"
                >
                  Salvar Despesa Fixa
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
