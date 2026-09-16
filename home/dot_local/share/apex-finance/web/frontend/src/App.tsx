import React, { useState, useEffect } from 'react';
import { 
  LayoutDashboard, CreditCard, Receipt, Repeat, 
  Rocket, History, BookmarkCheck, Plus, Trash2, Pencil, 
  CheckCircle, ArrowUpRight, ArrowDownRight, RefreshCw, 
  FileSpreadsheet, Sparkles, TrendingUp, 
  Calculator, Search, ShieldCheck, Zap,
  Home, Package, Flame
} from 'lucide-react';
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, 
  ResponsiveContainer
} from 'recharts';
import { CustomMonthPicker } from './components/CustomMonthPicker';
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
  const [mesRef, setMesRef] = useState<string>('2026-09');
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
  const [editingFixaId, setEditingFixaId] = useState<number | null>(null);
  const [editingTxId, setEditingTxId] = useState<number | null>(null);
  const [editingWishId, setEditingWishId] = useState<number | null>(null);
  const [faturasMesRef, setFaturasMesRef] = useState<string>('2026-10');
  const [faturasExibidas, setFaturasExibidas] = useState<Fatura[]>([]);
  const [showModalEfetivarSim, setShowModalEfetivarSim] = useState(false);
  const [simEfetivarContaId, setSimEfetivarContaId] = useState<string>('');
  const [extratoMesFiltro, setExtratoMesFiltro] = useState<string>('TODOS');
  const [showModalReajuste, setShowModalReajuste] = useState<Fatura | null>(null);
  const [reajusteNovoValor, setReajusteNovoValor] = useState<string>('');
  const [reajusteMotivo, setReajusteMotivo] = useState<string>('Ajuste para conciliar com app bancário');

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
    mes_inicio: '2026-09'
  });
  const [simResult, setSimResult] = useState<any>(null);

  // Oráculo de Compras & Decisão Financeira
  const [oraculoForm, setOraculoForm] = useState({
    item: 'Equipamento / Peça',
    precoPix: '450',
    precoCartao: '500',
    parcelas: 5,
    temJuros: false,
    taxaJurosMensal: '2.5', // % a.m. se tiver juros
    valorParcelaComJuros: '', // opcional: se o usuário já tem o valor exato da parcela (ex: 10x de 58,90)
  });

  // Simulador de Longo Prazo da Alforria & Independência
  const [alforriaAporteSim, setAlforriaAporteSim] = useState<number>(1000);
  const [alforriaMesesSim, setAlforriaMesesSim] = useState<number>(24);

  // Carregar dados principais
  const carregarTudo = async () => {
    try {
      setLoading(true);
      const dash = await api.getDashboard(mesRef);
      setHud(dash.hud);
      setContas(dash.contas);
      setFaturas(dash.faturas);
      
      const txs = await api.getTransacoes(extratoMesFiltro === "TODOS" ? undefined : extratoMesFiltro);
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

  useEffect(() => {
    api.getFaturas(faturasMesRef).then(setFaturasExibidas).catch(console.error);
  }, [faturasMesRef]);

  useEffect(() => {
    api.getTransacoes(extratoMesFiltro === "TODOS" ? undefined : extratoMesFiltro)
      .then(setTransacoes)
      .catch(console.error);
  }, [extratoMesFiltro]);

  const notificar = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 4000);
  };

  // Handlers de Criação / Ações
  const handleSalvarTransacao = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingTxId) {
        await api.editarTransacao(editingTxId, {
          descricao: txForm.descricao,
          valor: parseFloat(txForm.valor),
          tipo: txForm.tipo,
          categoria: txForm.categoria,
          data_transacao: txForm.data_transacao,
        });
        notificar("Transação atualizada com sucesso!");
      } else {
        await api.criarTransacao({
          descricao: txForm.descricao,
          valor: parseFloat(txForm.valor),
          tipo: txForm.tipo,
          categoria: txForm.categoria,
          conta_id: parseInt(txForm.conta_id),
          data_transacao: txForm.data_transacao,
          num_parcelas: parseInt(String(txForm.num_parcelas)),
        });
        notificar("Transação registrada com sucesso!");
      }
      setShowModalTx(false);
      setEditingTxId(null);
      setTxForm({
        descricao: '',
        valor: '',
        tipo: 'despesa',
        categoria: 'Outros',
        conta_id: contas[0]?.id ? String(contas[0].id) : '',
        data_transacao: new Date().toISOString().split('T')[0],
        num_parcelas: 1
      });
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const abrirEdicaoTransacao = (tx: Transacao) => {
    setEditingTxId(tx.id);
    setTxForm({
      descricao: tx.descricao,
      valor: String(tx.valor),
      tipo: tx.tipo,
      categoria: tx.categoria,
      conta_id: contas[0]?.id ? String(contas[0].id) : '',
      data_transacao: tx.data_transacao || new Date().toISOString().split('T')[0],
      num_parcelas: tx.total_parcelas || 1
    });
    setShowModalTx(true);
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

    const handleReajustarFatura = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!showModalReajuste) return;
    try {
      const val = parseFloat(reajusteNovoValor);
      const res = await api.reajustarFatura(showModalReajuste.cartao_id, showModalReajuste.mes_fatura, val, reajusteMotivo);
      notificar(res.mensagem || 'Fatura reajustada com sucesso!');
      setShowModalReajuste(null);
      carregarTudo();
      const fats = await api.getFaturas(faturasMesRef);
      setFaturasExibidas(fats);
    } catch (err: any) {
      notificar('Erro ao reajustar: ' + err.message);
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

  const handleSalvarFixa = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingFixaId) {
        await api.editarDespesaFixa(editingFixaId, {
          descricao: fixaForm.descricao,
          valor: parseFloat(fixaForm.valor),
          categoria: fixaForm.categoria,
          dia_vencimento: parseInt(String(fixaForm.dia_vencimento)),
          ativo: fixaForm.ativa ? 1 : 0
        });
        notificar("Despesa fixa atualizada com sucesso!");
      } else {
        await api.criarDespesaFixa({
          descricao: fixaForm.descricao,
          valor: parseFloat(fixaForm.valor),
          categoria: fixaForm.categoria,
          dia_vencimento: parseInt(String(fixaForm.dia_vencimento)),
          ativo: fixaForm.ativa ? 1 : 0
        });
        notificar("Despesa fixa adicionada!");
      }
      setShowModalFixa(false);
      setEditingFixaId(null);
      setFixaForm({
        descricao: '',
        valor: '',
        categoria: 'Assinaturas & Serviços',
        dia_vencimento: 10,
        ativa: true
      });
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const handleDeletarFixa = async (id: number, descricao: string) => {
    if (!window.confirm("Deseja realmente excluir a despesa fixa '" + descricao + "'?")) return;
    try {
      await api.deletarDespesaFixa(id);
      notificar("Despesa fixa excluída!");
      carregarTudo();
    } catch (err: any) {
      notificar("Erro ao excluir: " + err.message);
    }
  };

  const abrirEdicaoFixa = (df: DespesaFixa) => {
    setEditingFixaId(df.id);
    setFixaForm({
      descricao: df.descricao,
      valor: String(df.valor),
      categoria: df.categoria,
      dia_vencimento: df.dia_vencimento,
      ativa: Boolean(df.ativa)
    });
    setShowModalFixa(true);
  };

  const handleSalvarWishlist = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingWishId) {
        await api.editarWishlist(editingWishId, {
          item: wishForm.item,
          categoria: wishForm.categoria,
          valor_estimado: parseFloat(wishForm.valor_estimado),
          parcelas_sugeridas: parseInt(String(wishForm.parcelas_sugeridas)),
          prioridade: wishForm.prioridade,
          condicao_compra: wishForm.condicao_compra,
          link_ou_obs: wishForm.link_ou_obs
        });
        notificar("Item da Wishlist atualizado com sucesso!");
      } else {
        await api.criarWishlist({
          item: wishForm.item,
          categoria: wishForm.categoria,
          valor_estimado: parseFloat(wishForm.valor_estimado),
          parcelas_sugeridas: parseInt(String(wishForm.parcelas_sugeridas)),
          prioridade: wishForm.prioridade,
          condicao_compra: wishForm.condicao_compra,
          link_ou_obs: wishForm.link_ou_obs
        });
        notificar("Item salvo na Wishlist!");
      }
      setShowModalWish(false);
      setEditingWishId(null);
      setWishForm({
        item: '',
        categoria: 'Setup / Equipamento',
        valor_estimado: '',
        parcelas_sugeridas: 1,
        prioridade: 'Media',
        condicao_compra: '',
        link_ou_obs: ''
      });
      carregarTudo();
    } catch (err: any) {
      notificar("Erro: " + err.message);
    }
  };

  const abrirEdicaoWishlist = (item: WishlistItem) => {
    setEditingWishId(item.id);
    setWishForm({
      item: item.item,
      categoria: item.categoria,
      valor_estimado: String(item.valor_estimado),
      parcelas_sugeridas: item.parcelas_sugeridas || 1,
      prioridade: item.prioridade || 'Media',
      condicao_compra: item.condicao_compra || '',
      link_ou_obs: item.link_ou_obs || ''
    });
    setShowModalWish(true);
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

  const handleEfetivarSimulacaoReal = async () => {
    if (!simResult || !simEfetivarContaId) return;
    try {
      const contaNum = parseInt(simEfetivarContaId);
      const res = await api.efetivarSimulacao({
        descricao: simResult.compra_simulada || simForm.descricao || 'Compra Simulada',
        valor_total: parseFloat(simForm.valor),
        parcelas: simResult.num_parcelas || simForm.parcelas,
        tipo: 'despesa',
        cartao_id: contaNum,
        conta_id: contaNum,
        categoria: 'Simulações & Planejamento'
      });
      setShowModalEfetivarSim(false);
      notificar(res.mensagem || 'Simulação efetivada no banco com sucesso!');
      carregarTudo();
    } catch (err: any) {
      notificar('Erro ao efetivar: ' + err.message);
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

  // Cálculo Oráculo de Compras: PIX à Vista vs Parcelado (Sem ou Com Juros)
  const calcularOraculo = () => {
    const pix = parseFloat(oraculoForm.precoPix) || 0;
    const precoBase = parseFloat(oraculoForm.precoCartao) || 0;
    const nParc = Math.max(1, parseInt(String(oraculoForm.parcelas)) || 1);
    const taxaCdiMensal = 0.0095; // 0.95% ao mês (~115% CDI líquido na Caixinha)
    
    let parcelaReal = 0;
    let custoTotalParcelado = 0;
    let jurosEmbutidos = 0;

    if (oraculoForm.temJuros) {
      if (oraculoForm.valorParcelaComJuros && parseFloat(oraculoForm.valorParcelaComJuros) > 0) {
        parcelaReal = parseFloat(oraculoForm.valorParcelaComJuros);
        custoTotalParcelado = parcelaReal * nParc;
        jurosEmbutidos = Math.max(0, custoTotalParcelado - precoBase);
      } else {
        const jurosPct = (parseFloat(oraculoForm.taxaJurosMensal) || 0) / 100;
        if (jurosPct > 0) {
          // Fórmula da prestação com juros Price
          parcelaReal = precoBase * (jurosPct / (1 - Math.pow(1 + jurosPct, -nParc)));
        } else {
          parcelaReal = precoBase / nParc;
        }
        custoTotalParcelado = parcelaReal * nParc;
        jurosEmbutidos = Math.max(0, custoTotalParcelado - precoBase);
      }
    } else {
      parcelaReal = precoBase / nParc;
      custoTotalParcelado = precoBase;
      jurosEmbutidos = 0;
    }

    // Simulação do montante rendendo no CDB 115% CDI se optar por parcelar e pagar mensalmente
    let saldoCdb = pix;
    let rendimentoTotal = 0;
    const tabelaEvolucao: Array<{ mes: number; saldoInicial: number; rendimento: number; parcela: number; saldoFinal: number }> = [];

    for (let i = 1; i <= nParc; i++) {
      const rend = saldoCdb * taxaCdiMensal;
      rendimentoTotal += rend;
      const sFinal = Math.max(0, saldoCdb + rend - parcelaReal);
      tabelaEvolucao.push({
        mes: i,
        saldoInicial: saldoCdb,
        rendimento: rend,
        parcela: parcelaReal,
        saldoFinal: sFinal
      });
      saldoCdb = sFinal;
    }

    // Diferença real: comparar o que você desembolsa e quanto ganha no CDB
    // Se pagar PIX: gasta  hoje.
    // Se parcelar: paga  ao longo do tempo, mas o dinheiro rende .
    // Custo efetivo parcelado = custoTotalParcelado - rendimentoTotal.
    const custoEfetivoParcelado = custoTotalParcelado - rendimentoTotal;
    const diferencaVantagem = custoEfetivoParcelado - pix;
    
    // Se custoEfetivoParcelado > pix => PIX é mais vantajoso (economiza )
    // Se custoEfetivoParcelado <= pix => Parcelar é mais vantajoso (ou indiferente)
    const recomendePix = diferencaVantagem > 0.50; // margem mínima de 50 centavos

    return {
      descontoPixNominal: Math.max(0, precoBase - pix),
      custoTotalParcelado,
      jurosEmbutidos,
      rendimentoTotal,
      custoEfetivoParcelado,
      ganhoReal: Math.abs(diferencaVantagem),
      recomendePix,
      parcelaMensal: parcelaReal,
      tabelaEvolucao
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
              { id: 'dashboard', label: 'Dashboard & HUD', icon: LayoutDashboard, badge: undefined as string | undefined },
              { id: 'faturas', label: 'Cartões & Faturas', icon: CreditCard, badge: undefined as string | undefined },
              { id: 'oraculo', label: 'Oráculo de Compras', icon: Calculator, badge: undefined as string | undefined },
              { id: 'transacoes', label: 'Extrato & Busca', icon: Receipt, badge: undefined as string | undefined },
              { id: 'fixas', label: 'Custos Recorrentes', icon: Repeat, badge: undefined as string | undefined },
              { id: 'alforria', label: 'Alforria (115% CDI)', icon: Rocket, badge: undefined as string | undefined },
              { id: 'simulador', label: 'Máquina do Tempo', icon: History, badge: undefined as string | undefined },
              { id: 'wishlist', label: 'Wishlist & Sonhos', icon: BookmarkCheck, badge: undefined as string | undefined },
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
            onClick={() => {
                  setEditingTxId(null);
                  setTxForm({
                    descricao: '',
                    valor: '',
                    tipo: 'despesa',
                    categoria: 'Outros',
                    conta_id: contas[0]?.id ? String(contas[0].id) : '',
                    data_transacao: new Date().toISOString().split('T')[0],
                    num_parcelas: 1
                  });
                  setShowModalTx(true);
                }}
            className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-indigo-600 to-indigo-500 hover:from-indigo-500 hover:to-indigo-400 text-white font-semibold py-2.5 px-4 rounded-xl shadow-lg shadow-indigo-600/20 text-sm transition-all active:scale-95"
          >
            <Plus className="w-4 h-4" />
            <span>Novo Lançamento</span>
          </button>
          
          <div className="flex gap-2">
            <button
              onClick={async () => {
                try {
                  notificar("Gerando planilha Excel...");
                  const res = await api.exportarExcel();
                  notificar("Planilha baixada e salva em: " + res.caminho.split('/').pop());
                } catch (err: any) {
                  notificar("Erro ao gerar Excel: " + (err.message || 'Falha na conexão'));
                }
              }}
              title="Exportar e Baixar Excel (.xlsx)"
              className="flex-1 flex items-center justify-center gap-1.5 bg-slate-800/80 hover:bg-slate-800 active:scale-95 text-emerald-400 py-2 rounded-lg text-xs font-medium border border-slate-700/50 transition-all"
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
        <header className="h-16 border-b border-slate-800/80 bg-[#0c101c] z-30 px-8 flex items-center justify-between relative">
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
            <span className="text-xs text-slate-400 font-medium hidden sm:inline">Mês de Referência:</span>
            <CustomMonthPicker value={mesRef} onChange={(val) => setMesRef(val)} />
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

          {/* TAB: ORÁCULO DE COMPRAS (PIX vs CARTÃO SEM JUROS vs COM JUROS) */}
          {activeTab === 'oraculo' && (
            <div className="space-y-6 animate-fadeIn">
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-800">
                  <div className="flex items-center gap-3">
                    <div className="p-3 bg-indigo-600/20 text-indigo-400 rounded-xl border border-indigo-500/30">
                      <Calculator className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="text-base font-black text-slate-100">
                        Oráculo Prático de Compras: PIX à Vista vs. Parcelamento
                      </h3>
                      <p className="text-xs text-slate-400 mt-0.5">
                        Simule compras à vista, sem juros ou com juros embutidos (Shopee, Mercado Livre, etc.) contra o rendimento de 115% do CDI na Caixinha.
                      </p>
                    </div>
                  </div>

                  {/* Toggle Sem Juros / Com Juros */}
                  <div className="flex items-center gap-2 bg-slate-950 p-1 rounded-xl border border-slate-800 self-start sm:self-auto">
                    <button
                      type="button"
                      onClick={() => setOraculoForm({ ...oraculoForm, temJuros: false })}
                      className={'px-3 py-1.5 rounded-lg text-xs font-bold transition-all cursor-pointer ' + (
                        !oraculoForm.temJuros ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'
                      )}
                    >
                      Parcelamento Sem Juros
                    </button>
                    <button
                      type="button"
                      onClick={() => setOraculoForm({ ...oraculoForm, temJuros: true })}
                      className={'px-3 py-1.5 rounded-lg text-xs font-bold transition-all cursor-pointer ' + (
                        oraculoForm.temJuros ? 'bg-rose-600 text-white shadow' : 'text-slate-400 hover:text-white'
                      )}
                    >
                      Parcelamento Com Juros ⚠️
                    </button>
                  </div>
                </div>

                {/* Formulário Dinâmico */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Item / Produto Desejado</label>
                    <input
                      type="text"
                      placeholder="Ex: Celular, Pneu, Fone"
                      value={oraculoForm.item}
                      onChange={e => setOraculoForm({ ...oraculoForm, item: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Preço à Vista no PIX (R$)</label>
                    <input
                      type="number"
                      step="0.01"
                      placeholder="Ex: 450.00"
                      value={oraculoForm.precoPix}
                      onChange={e => setOraculoForm({ ...oraculoForm, precoPix: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">
                      {oraculoForm.temJuros ? 'Preço Base à Vista (R$)' : 'Preço Total no Cartão (R$)'}
                    </label>
                    <input
                      type="number"
                      step="0.01"
                      placeholder="Ex: 500.00"
                      value={oraculoForm.precoCartao}
                      onChange={e => setOraculoForm({ ...oraculoForm, precoCartao: e.target.value })}
                      className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                    />
                  </div>

                  <div>
                    <label className="text-xs text-slate-400 font-medium block mb-1.5">Número de Parcelas</label>
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

                {/* Campos Extras quando Tem Juros */}
                {oraculoForm.temJuros && (
                  <div className="mt-4 p-4 bg-rose-950/20 border border-rose-500/20 rounded-xl grid grid-cols-1 md:grid-cols-2 gap-4 animate-fadeIn">
                    <div>
                      <label className="text-xs text-rose-300 font-medium block mb-1.5">
                        Valor Exato da Parcela cobrada pelo site (R$) <span className="text-slate-400 font-normal">(opcional)</span>
                      </label>
                      <input
                        type="number"
                        step="0.01"
                        placeholder="Ex: 58.90 (se o site já calculou a parcela)"
                        value={oraculoForm.valorParcelaComJuros}
                        onChange={e => setOraculoForm({ ...oraculoForm, valorParcelaComJuros: e.target.value })}
                        className="w-full bg-slate-950 border border-rose-900/50 rounded-xl px-3 py-2 text-sm text-rose-100 focus:outline-none focus:border-rose-500"
                      />
                    </div>
                    <div>
                      <label className="text-xs text-rose-300 font-medium block mb-1.5">
                        Ou Taxa de Juros Mensal anunciada (% a.m.)
                      </label>
                      <input
                        type="number"
                        step="0.01"
                        placeholder="Ex: 2.5"
                        value={oraculoForm.taxaJurosMensal}
                        onChange={e => setOraculoForm({ ...oraculoForm, taxaJurosMensal: e.target.value })}
                        className="w-full bg-slate-950 border border-rose-900/50 rounded-xl px-3 py-2 text-sm text-rose-100 focus:outline-none focus:border-rose-500"
                      />
                    </div>
                  </div>
                )}

                {/* Veredicto do Oráculo */}
                <div className={'mt-6 p-6 rounded-2xl border transition-all ' + (
                  resultadoOraculo.recomendePix 
                    ? 'bg-emerald-950/30 border-emerald-500/40 shadow-lg shadow-emerald-950/20' 
                    : 'bg-indigo-950/30 border-indigo-500/40 shadow-lg shadow-indigo-950/20'
                )}>
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                    <div>
                      <span className="text-xs font-bold uppercase tracking-wider text-slate-400 flex items-center gap-1.5">
                        <Sparkles className="w-3.5 h-3.5 text-indigo-400" />
                        Veredicto Matemático Definitivo:
                      </span>
                      <h4 className={'text-xl font-black mt-1 ' + (
                        resultadoOraculo.recomendePix ? 'text-emerald-400' : 'text-indigo-400'
                      )}>
                        {resultadoOraculo.recomendePix 
                          ? '🏆 FUJA DO PARCELAMENTO: PAGUE À VISTA NO PIX!' 
                          : '💳 PODE PARCELAR! DEIXE O RESTANTE NO CDB (115% CDI)'}
                      </h4>
                      <p className="text-xs text-slate-300 mt-1 max-w-xl">
                        {resultadoOraculo.recomendePix
                          ? oraculoForm.temJuros 
                            ? 'Os juros do parcelamento superam completamente o rendimento de 115% do CDI da sua Caixinha. Parcelar com juros aqui é queimar patrimônio.'
                            : 'O desconto à vista no PIX é maior do que o seu dinheiro renderia durante todo o tempo das parcelas. Pague no PIX e garanta a economia imediata.'
                          : 'O desconto à vista é pequeno ou zero. Vale mais a pena manter o dinheiro rendendo no CDB a 115% do CDI na Caixinha e pagar as parcelas sem juros mês a mês.'}
                      </p>
                    </div>

                    <div className="text-left sm:text-right bg-slate-900/80 p-3.5 rounded-xl border border-slate-800">
                      <div className="text-xs text-slate-400 font-medium">Economia Real Líquida</div>
                      <div className="text-2xl font-black text-white font-mono">
                        {formatBRL(resultadoOraculo.ganhoReal)}
                      </div>
                      <span className="text-[10px] text-emerald-400 font-semibold">
                        {resultadoOraculo.recomendePix ? 'Vantagem a favor do PIX' : 'Vantagem a favor do CDB'}
                      </span>
                    </div>
                  </div>

                  {/* Métricas Detalhadas em Cards Rápidos */}
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mt-6 pt-4 border-t border-slate-800/80 text-xs font-mono">
                    <div className="p-3 bg-slate-950/60 rounded-xl border border-slate-800/60">
                      <span className="text-slate-400 block text-[11px]">Desconto do PIX:</span>
                      <span className="font-bold text-slate-100 text-sm">{formatBRL(resultadoOraculo.descontoPixNominal)}</span>
                    </div>

                    <div className="p-3 bg-slate-950/60 rounded-xl border border-slate-800/60">
                      <span className="text-slate-400 block text-[11px]">Custo Total Parcelado:</span>
                      <span className={'font-bold text-sm ' + (resultadoOraculo.jurosEmbutidos > 0 ? 'text-rose-400' : 'text-slate-100')}>
                        {formatBRL(resultadoOraculo.custoTotalParcelado)}
                      </span>
                      {resultadoOraculo.jurosEmbutidos > 0 && (
                        <span className="text-[10px] text-rose-500 block">+{formatBRL(resultadoOraculo.jurosEmbutidos)} só de juros</span>
                      )}
                    </div>

                    <div className="p-3 bg-slate-950/60 rounded-xl border border-slate-800/60">
                      <span className="text-slate-400 block text-[11px]">Rendimento CDB (115%):</span>
                      <span className="font-bold text-cyan-400 text-sm">+{formatBRL(resultadoOraculo.rendimentoTotal)}</span>
                    </div>

                    <div className="p-3 bg-slate-950/60 rounded-xl border border-slate-800/60">
                      <span className="text-slate-400 block text-[11px]">Valor de Cada Parcela:</span>
                      <span className="font-bold text-slate-100 text-sm">
                        {oraculoForm.parcelas}x de {formatBRL(resultadoOraculo.parcelaMensal)}
                      </span>
                    </div>
                  </div>

                  {/* Dica da Filosofia Homem Rocha */}
                  <div className="mt-4 p-3.5 bg-slate-900/90 rounded-xl text-xs text-slate-300 border border-slate-800 flex items-start gap-2.5">
                    <span className="text-base">🛡️</span>
                    <div>
                      <strong className="text-indigo-300">Regra de Ouro do Homem Rocha:</strong>{' '}
                      {oraculoForm.temJuros 
                        ? 'Juros compostos contra você são uma escravidão disfarçada de facilidade. Se não há desconto à vista e há juros no parcelamento, o caminho soberano é juntar o dinheiro na Caixinha antes e comprar à vista.'
                        : 'Se o parcelamento é estritamente sem juros e o desconto no PIX for menor do que ~5% a 7%, mantenha seu dinheiro no cofre rendendo e parcele no cartão para reter a liquidez.'}
                    </div>
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
                    className="bg-slate-900 border border-slate-800 rounded-xl px-3 py-2 text-xs text-slate-300 focus:outline-none focus:border-indigo-500 cursor-pointer"
                  >
                    <option value="TODOS">Todos os Bancos</option>
                    <option value="Nubank">Nubank</option>
                    <option value="Caixa">Caixa</option>
                    <option value="PicPay">PicPay</option>
                    <option value="Inter">Inter</option>
                    <option value="Neon">Neon</option>
                    <option value="Shopee">Shopee</option>
                    <option value="Mercado Pago">Mercado Pago</option>
                  </select>

                  {/* Filter Mês do Extrato */}
                  <select
                    value={extratoMesFiltro}
                    onChange={e => setExtratoMesFiltro(e.target.value)}
                    className="bg-slate-900 border border-slate-800 rounded-xl px-3 py-2 text-xs text-indigo-300 font-semibold focus:outline-none focus:border-indigo-500 cursor-pointer"
                  >
                    <option value="TODOS">Todos os Meses (Histórico Geral)</option>
                    <option value="2026-09">Setembro/2026</option>
                    <option value="2026-10">Outubro/2026</option>
                    <option value="2026-11">Novembro/2026</option>
                    <option value="2026-12">Dezembro/2026</option>
                    <option value="2027-01">Janeiro/2027</option>
                  </select>
                </div>

                <button
                  onClick={() => {
                  setEditingTxId(null);
                  setTxForm({
                    descricao: '',
                    valor: '',
                    tipo: 'despesa',
                    categoria: 'Outros',
                    conta_id: contas[0]?.id ? String(contas[0].id) : '',
                    data_transacao: new Date().toISOString().split('T')[0],
                    num_parcelas: 1
                  });
                  setShowModalTx(true);
                }}
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
                          <div className="flex items-center justify-center gap-1.5">
                            <button
                              onClick={() => abrirEdicaoTransacao(tx)}
                              title="Editar Lançamento"
                              className="p-1.5 hover:bg-indigo-500/10 text-slate-400 hover:text-indigo-400 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-indigo-500/30"
                            >
                              <Pencil className="w-3.5 h-3.5" />
                            </button>
                            <button
                              onClick={() => handleDeletarTransacao(tx.id, tx.serie_parcelamento_id || undefined)}
                              title="Excluir Transação"
                              className="p-1.5 hover:bg-rose-500/10 text-slate-400 hover:text-rose-400 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-rose-500/30"
                            >
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>
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
              {/* Header de Controle de Faturas */}
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                  <h3 className="text-base font-extrabold text-slate-100 flex items-center gap-2">
                    <CreditCard className="w-5 h-5 text-indigo-400" />
                    Controle de Faturas dos Cartões
                  </h3>
                  <p className="text-xs text-slate-400 mt-0.5">
                    Como o melhor dia de compras já passou em setembro, suas faturas abertas acumulam para o vencimento de <span className="text-indigo-300 font-bold font-mono">Outubro (2026-10)</span>.
                  </p>
                </div>

                <div className="flex items-center gap-2 self-start md:self-auto">
                  <span className="text-xs text-slate-400 font-medium">Ver Ciclo:</span>
                  <div className="flex items-center bg-slate-950 p-1 rounded-xl border border-slate-800">
                    <button
                      onClick={() => setFaturasMesRef('2026-09')}
                      className={'px-3 py-1 text-xs rounded-lg font-bold transition-all cursor-pointer ' + (
                        faturasMesRef === '2026-09' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'
                      )}
                    >
                      Set/2026 (Passada)
                    </button>
                    <button
                      onClick={() => setFaturasMesRef('2026-10')}
                      className={'px-3 py-1 text-xs rounded-lg font-bold transition-all cursor-pointer ' + (
                        faturasMesRef === '2026-10' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'
                      )}
                    >
                      Out/2026 (Aberta Atual)
                    </button>
                    <button
                      onClick={() => setFaturasMesRef('2026-11')}
                      className={'px-3 py-1 text-xs rounded-lg font-bold transition-all cursor-pointer ' + (
                        faturasMesRef === '2026-11' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'
                      )}
                    >
                      Nov/2026 (Próxima)
                    </button>
                  </div>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {(faturasExibidas.length > 0 ? faturasExibidas : faturas).map(fat => (
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

                    <div className="mt-8 pt-4 border-t border-slate-800/80 flex items-center justify-between gap-3">
                      <button
                        onClick={() => {
                          setShowModalReajuste(fat);
                          setReajusteNovoValor(String(fat.total_fatura));
                          setReajusteMotivo('Ajuste para conciliar com app bancário');
                        }}
                        className="flex items-center gap-1 px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-300 hover:text-white rounded-xl text-xs font-semibold border border-slate-700/60 transition-all cursor-pointer"
                        title="Ajustar valor total da fatura para bater com o banco"
                      >
                        <Pencil className="w-3.5 h-3.5 text-indigo-400" />
                        <span>Reajustar Fatura</span>
                      </button>

                      {fat.total_fatura > 0 ? (
                        <button
                          onClick={() => setShowModalPagarFatura(fat)}
                          className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-xs transition-all shadow-lg shadow-emerald-600/20 cursor-pointer"
                        >
                          Pagar Fatura Agora
                        </button>
                      ) : (
                        <span className="text-xs text-slate-500 font-medium">Sem lançamentos pendentes</span>
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
                  onClick={() => {
                  setEditingFixaId(null);
                  setFixaForm({
                    descricao: '',
                    valor: '',
                    categoria: 'Assinaturas & Serviços',
                    dia_vencimento: 10,
                    ativa: true
                  });
                  setShowModalFixa(true);
                }}
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
                        <div className="flex items-center gap-1.5">
                          <button
                            onClick={() => abrirEdicaoFixa(df)}
                            title="Editar Despesa Fixa"
                            className="p-1.5 hover:bg-indigo-500/10 text-slate-400 hover:text-indigo-400 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-indigo-500/30"
                          >
                            <Pencil className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => handleDeletarFixa(df.id, df.descricao)}
                            title="Excluir Despesa Fixa"
                            className="p-1.5 hover:bg-rose-500/10 text-slate-400 hover:text-rose-400 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-rose-500/30"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => handleToggleFixa(df.id)}
                            className={`px-2.5 py-1 text-xs font-bold rounded-lg border transition-all cursor-pointer ${
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
          {activeTab === 'alforria' && (() => {
            // Cálculo dinâmico do simulador de longo prazo
            const saldoBase = 1000.0;
            const taxaMensalCDI = 0.0095; // 115% CDI (~11.5% a.a. / 12)
            let s = saldoBase;
            const projDinamica = [];
            let totalAportado = 0;
            let totalJuros = 0;

            for (let i = 1; i <= alforriaMesesSim; i++) {
              const rend = s * taxaMensalCDI;
              s += rend + alforriaAporteSim;
              totalAportado += alforriaAporteSim;
              totalJuros += rend;
              projDinamica.push({
                mes: i,
                rendimento: rend,
                saldo: s,
                rendaPassiva: s * taxaMensalCDI
              });
            }

            const patrimonioFinal = s;
            const rendaPassivaFinal = s * taxaMensalCDI;
            const metaMobilia = 11500.0;
            const metaReservaSoberana = 15500.0;
            const metaTotalIndependencia = metaMobilia + metaReservaSoberana; // R$ 27.000
            const progressoIndependencia = Math.min(100, Math.round((saldoBase / metaTotalIndependencia) * 100));

            return (
              <div className="space-y-8 animate-fadeIn">
                {/* Hero Header */}
                <div className="bg-gradient-to-r from-indigo-950/80 via-slate-900 to-slate-900 border border-indigo-800/40 rounded-2xl p-6 shadow-xl relative overflow-hidden">
                  <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                    <div className="flex items-center gap-4">
                      <div className="p-4 bg-indigo-600 text-white rounded-2xl shadow-lg shadow-indigo-600/30">
                        <Rocket className="w-8 h-8" />
                      </div>
                      <div>
                        <h3 className="text-xl font-black text-white flex items-center gap-2">
                          Projeto Alforria • 115% do CDI
                          <span className="text-[10px] px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 font-bold border border-emerald-500/30">
                            Meta R$ 27.000
                          </span>
                        </h3>
                        <p className="text-xs text-indigo-200/80 mt-1 max-w-2xl">
                          Centro de Comando de Longo Prazo rumo à Moradia Soberana e Independência Real.
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-3 bg-slate-950/60 border border-slate-800/80 p-3 rounded-xl">
                      <div className="text-right">
                        <div className="text-[10px] text-slate-400 font-bold uppercase">Semente Atual na Caixinha</div>
                        <div className="text-lg font-black text-emerald-400 font-mono">R$ 1.000,00</div>
                      </div>
                      <ShieldCheck className="w-6 h-6 text-emerald-400" />
                    </div>
                  </div>

                  {/* Barra de Progresso da Alforria */}
                  <div className="mt-6 pt-5 border-t border-slate-800/80">
                    <div className="flex justify-between text-xs font-bold mb-2">
                      <span className="text-slate-300 flex items-center gap-1.5">
                        <Home className="w-3.5 h-3.5 text-indigo-400" />
                        Progresso Rumo ao "Meu Canto" (R$ 27.000):
                      </span>
                      <span className="text-indigo-400 font-mono">{progressoIndependencia}% Concluído</span>
                    </div>
                    <div className="w-full bg-slate-950 h-3 rounded-full overflow-hidden border border-slate-800">
                      <div 
                        className="bg-gradient-to-r from-indigo-500 via-indigo-400 to-emerald-400 h-full rounded-full transition-all duration-1000"
                        style={{ width: `${Math.max(4, progressoIndependencia)}%` }}
                      />
                    </div>
                    <div className="flex justify-between text-[10px] text-slate-500 mt-1.5 font-medium">
                      <span>R$ 1.000 (Base Atual)</span>
                      <span>R$ 11.500 (Mobília Paga)</span>
                      <span>R$ 27.000 (Alforria Total + Reserva 12m)</span>
                    </div>
                  </div>
                </div>

                {/* SIMULADOR INTERATIVO DE CENÁRIOS DE LONGO PRAZO */}
                <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-6">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800/80 pb-4">
                    <div>
                      <h4 className="text-base font-black text-slate-100 flex items-center gap-2">
                        <Calculator className="w-5 h-5 text-indigo-400" />
                        Simulador Estratégico de Longo Prazo (Juros Compostos)
                      </h4>
                      <p className="text-xs text-slate-400 mt-0.5">
                        Alterne os valores para ver a força dos juros e projetar sua vida com o salário atual vs. aprovação no concurso.
                      </p>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => { setAlforriaAporteSim(1000); setAlforriaMesesSim(24); }}
                        className={`px-3 py-1.5 rounded-lg text-xs font-bold border transition-all ${
                          alforriaAporteSim === 1000 && alforriaMesesSim === 24
                            ? 'bg-indigo-600 text-white border-indigo-500 shadow-sm'
                            : 'bg-slate-800 text-slate-400 border-slate-700 hover:text-slate-200'
                        }`}
                      >
                        Cenário AGR (R$ 1k/mês)
                      </button>
                      <button
                        onClick={() => { setAlforriaAporteSim(4000); setAlforriaMesesSim(24); }}
                        className={`px-3 py-1.5 rounded-lg text-xs font-bold border transition-all ${
                          alforriaAporteSim === 4000
                            ? 'bg-emerald-600 text-white border-emerald-500 shadow-sm'
                            : 'bg-slate-800 text-slate-400 border-slate-700 hover:text-slate-200'
                        }`}
                      >
                        Cenário TCE-GO (R$ 4k/mês) 🚀
                      </button>
                    </div>
                  </div>

                  {/* Sliders de Ajuste */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <div className="flex justify-between text-xs">
                        <span className="text-slate-400 font-semibold">Aporte Mensal Previsto:</span>
                        <span className="text-emerald-400 font-black font-mono text-sm">{formatBRL(alforriaAporteSim)}/mês</span>
                      </div>
                      <input
                        type="range"
                        min="200"
                        max="6000"
                        step="100"
                        value={alforriaAporteSim}
                        onChange={(e) => setAlforriaAporteSim(Number(e.target.value))}
                        className="w-full h-2 bg-slate-950 rounded-lg appearance-none cursor-pointer accent-indigo-500"
                      />
                      <div className="flex justify-between text-[10px] text-slate-500 font-medium">
                        <span>R$ 200</span>
                        <span>R$ 1.000 (AGR)</span>
                        <span>R$ 3.000</span>
                        <span>R$ 6.000 (Posse Topo)</span>
                      </div>
                    </div>

                    <div className="space-y-2">
                      <div className="flex justify-between text-xs">
                        <span className="text-slate-400 font-semibold">Horizonte de Tempo:</span>
                        <span className="text-cyan-400 font-black font-mono text-sm">{alforriaMesesSim} meses ({(alforriaMesesSim / 12).toFixed(1)} anos)</span>
                      </div>
                      <input
                        type="range"
                        min="6"
                        max="60"
                        step="6"
                        value={alforriaMesesSim}
                        onChange={(e) => setAlforriaMesesSim(Number(e.target.value))}
                        className="w-full h-2 bg-slate-950 rounded-lg appearance-none cursor-pointer accent-cyan-500"
                      />
                      <div className="flex justify-between text-[10px] text-slate-500 font-medium">
                        <span>6 meses</span>
                        <span>12 meses</span>
                        <span>24 meses (2 anos)</span>
                        <span>36 meses (3 anos)</span>
                        <span>60 meses (5 anos)</span>
                      </div>
                    </div>
                  </div>

                  {/* Cartões de Resultados Projetados */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-2">
                    <div className="bg-slate-950/60 border border-slate-800 rounded-xl p-4">
                      <div className="text-[11px] text-slate-400 font-bold uppercase">Patrimônio Acumulado</div>
                      <div className="text-2xl font-black text-white font-mono mt-1">
                        {formatBRL(patrimonioFinal)}
                      </div>
                      <div className="text-[10px] text-slate-500 mt-1">Ao final de {alforriaMesesSim} meses</div>
                    </div>

                    <div className="bg-slate-950/60 border border-slate-800 rounded-xl p-4">
                      <div className="text-[11px] text-slate-400 font-bold uppercase">Tirado do Próprio Bolso</div>
                      <div className="text-xl font-bold text-slate-300 font-mono mt-1">
                        {formatBRL(saldoBase + totalAportado)}
                      </div>
                      <div className="text-[10px] text-slate-500 mt-1">Sua economia real</div>
                    </div>

                    <div className="bg-slate-950/60 border border-slate-800 rounded-xl p-4">
                      <div className="text-[11px] text-slate-400 font-bold uppercase">Juros Livres (115% CDI)</div>
                      <div className="text-xl font-black text-cyan-400 font-mono mt-1">
                        +{formatBRL(totalJuros)}
                      </div>
                      <div className="text-[10px] text-cyan-500/80 mt-1">Dinheiro trabalhando por você</div>
                    </div>

                    <div className="bg-slate-950/60 border border-indigo-900/40 rounded-xl p-4 bg-indigo-950/20">
                      <div className="text-[11px] text-indigo-300 font-bold uppercase">Renda Passiva Mensal</div>
                      <div className="text-xl font-black text-emerald-400 font-mono mt-1">
                        +{formatBRL(rendaPassivaFinal)}/mês
                      </div>
                      <div className="text-[10px] text-slate-400 mt-1">Pingando todo dia 1º sem esforço</div>
                    </div>
                  </div>
                </div>

                {/* PLANO DE INDEPENDÊNCIA: AS 2 GAVETAS SAGRADAS */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                  {/* Gaveta 1: Mobília de Elite */}
                  <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4">
                    <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                      <div className="flex items-center gap-3">
                        <div className="p-2.5 bg-amber-500/10 text-amber-400 rounded-xl border border-amber-500/20">
                          <Package className="w-5 h-5" />
                        </div>
                        <div>
                          <h4 className="font-black text-slate-100 text-sm">Gaveta 1: Mobília & Ninho Seguro</h4>
                          <span className="text-xs text-slate-400">Meta: R$ 11.500 (Itens topo de linha duráveis)</span>
                        </div>
                      </div>
                      <span className="text-xs font-mono font-bold text-amber-400">6 Itens na Wishlist</span>
                    </div>

                    <div className="space-y-2.5">
                      {[
                        { nome: 'Geladeira Panasonic BT44 Inverter 391L (A+++)', preco: 2690.0, desc: 'Motor Inverter Japonês, Frost Free, Freezer Superior' },
                        { nome: 'Lava e Seca Samsung EcoBubble 11kg Inverter', preco: 3200.0, desc: 'Motor Digital Inverter 10 anos garantia, água fria' },
                        { nome: 'Cama Box Queen Molas Ensacadas (Castor/Guldi)', preco: 2200.0, desc: 'Pocket individual, Pillow Top hotelaria, coluna alinhada' },
                        { nome: 'Guarda-roupa 100% MDF Portas de Correr', preco: 1400.0, desc: 'Profundidade 56cm real, corrediças telescópicas' },
                        { nome: 'Cooktop Fischer 4 Bocas Mesa de Vidro', preco: 650.0, desc: 'Design moderno, limpa em segundos, vidro temperado' },
                        { nome: 'Micro-ondas Panasonic 30L SmartSense', preco: 650.0, desc: 'Descongela sem cozinhar bordas, função pega fácil' },
                      ].map((item, idx) => (
                        <div key={idx} className="flex items-center justify-between p-3 rounded-xl bg-slate-950/60 border border-slate-800/60 text-xs">
                          <div>
                            <div className="font-bold text-slate-200">{item.nome}</div>
                            <div className="text-[10px] text-slate-500">{item.desc}</div>
                          </div>
                          <div className="font-black font-mono text-slate-100 text-right ml-3">
                            {formatBRL(item.preco)}
                          </div>
                        </div>
                      ))}
                    </div>

                    <div className="p-3 rounded-xl bg-amber-500/5 border border-amber-500/20 text-[11px] text-amber-300/90 leading-relaxed">
                      💡 <strong>Estratégia Homem Rocha:</strong> Comprar em 10x sem juros no cartão quando você tiver o valor integral rendendo na Caixinha a 115% do CDI. Você ganha os juros do banco todo mês enquanto paga as parcelas fixas sem juros!
                    </div>
                  </div>

                  {/* Gaveta 2: Reserva Imutável */}
                  <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4">
                    <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                      <div className="flex items-center gap-3">
                        <div className="p-2.5 bg-indigo-500/10 text-indigo-400 rounded-xl border border-indigo-500/20">
                          <ShieldCheck className="w-5 h-5" />
                        </div>
                        <div>
                          <h4 className="font-black text-slate-100 text-sm">Gaveta 2: Alforria & Reserva de Sobrevivência</h4>
                          <span className="text-xs text-slate-400">Meta: R$ 15.500 (O Escudo de Ferro)</span>
                        </div>
                      </div>
                      <span className="text-xs font-mono font-bold text-indigo-400">12 Meses de Vida</span>
                    </div>

                    <div className="space-y-3">
                      <div className="p-4 rounded-xl bg-slate-950/60 border border-slate-800/80 space-y-2">
                        <div className="flex justify-between text-xs">
                          <span className="text-slate-300 font-semibold">Caução & Garantia do Aluguel:</span>
                          <span className="font-mono text-slate-100 font-bold">R$ 3.500,00</span>
                        </div>
                        <div className="text-[10px] text-slate-500">
                          Reserva para o primeiro mês + 2 cauções ou seguro fiança de imobiliária.
                        </div>
                      </div>

                      <div className="p-4 rounded-xl bg-slate-950/60 border border-slate-800/80 space-y-2">
                        <div className="flex justify-between text-xs">
                          <span className="text-slate-300 font-semibold">Escudo de 12 Meses de Custos:</span>
                          <span className="font-mono text-emerald-400 font-bold">R$ 12.000,00</span>
                        </div>
                        <div className="text-[10px] text-slate-500">
                          R$ 1.000/mês guardados gerando juros contínuos. Aconteça o que acontecer no mundo, seu teto e sua comida estão pagos por 1 ano inteiro.
                        </div>
                      </div>

                      <div className="p-4 rounded-xl bg-indigo-950/30 border border-indigo-800/40 space-y-2">
                        <div className="flex items-center gap-2 text-indigo-300 font-bold text-xs">
                          <Flame className="w-4 h-4 text-indigo-400" />
                          A Renda Passiva da Alforria (R$ 27.000):
                        </div>
                        <div className="text-xs text-slate-300 leading-relaxed">
                          Quando você atingir os R$ 27.000 na Caixinha a 115% CDI, o rendimento mensal será de <strong>~R$ 270 a R$ 300 todo mês</strong>.
                          Isso paga automaticamente o condomínio, a conta de luz e a internet do seu apartamento para sempre!
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Tabela de Evolução Mensal do Banco */}
                <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden">
                  <div className="p-4 border-b border-slate-800 flex justify-between items-center">
                    <h4 className="text-sm font-bold text-slate-200">Projeção Mensal do Banco (Timeline Real 115% CDI)</h4>
                    <span className="text-xs text-slate-500">Próximos 24 meses calculados pelo core_engine</span>
                  </div>
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
            );
          })()}

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
                    <div className="w-full">
                      <CustomMonthPicker
                        value={simForm.mes_inicio}
                        onChange={(val) => setSimForm({ ...simForm, mes_inicio: val })}
                      />
                    </div>
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
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4 pb-3 border-b border-slate-800">
                    <div>
                      <h4 className="text-sm font-extrabold text-indigo-300 uppercase tracking-wider">
                        Resultado da Simulação: {simResult.compra_simulada} ({simResult.num_parcelas}x de {formatBRL(simResult.parcela_mensal)})
                      </h4>
                      <p className="text-xs text-slate-400 mt-0.5">
                        Iniciando na fatura de {simResult.mes_inicio}. Verifique se as sobras mensais permanecem positivas.
                      </p>
                    </div>
                    <button
                      onClick={() => {
                        if (contas.length > 0 && !simEfetivarContaId) {
                          setSimEfetivarContaId(String(contas[0].id));
                        }
                        setShowModalEfetivarSim(true);
                      }}
                      className="flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-xs transition-all shadow-md shadow-emerald-600/20 cursor-pointer self-start sm:self-auto"
                    >
                      <CheckCircle className="w-4 h-4" />
                      <span>Efetivar Compra no Banco Real</span>
                    </button>
                  </div>
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

              {/* PROJEÇÃO TEMPORAL COMPLETA / NAVEGAÇÃO DA MÁQUINA DO TEMPO */}
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-4 pb-3 border-b border-slate-800">
                  <div>
                    <h4 className="text-base font-black text-slate-100 flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-cyan-400" />
                      Navegador Temporal de Fluxo Futuro (Próximos Meses)
                    </h4>
                    <p className="text-xs text-slate-400 mt-0.5">
                      Clique em qualquer mês para transportar todo o painel APEX para o momento escolhido no tempo.
                    </p>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-slate-400 font-medium">Mês em Foco:</span>
                    <span className="px-3 py-1 bg-indigo-600/20 text-indigo-300 border border-indigo-500/30 rounded-lg text-xs font-mono font-bold">
                      {mesRef}
                    </span>
                  </div>
                </div>

                {/* Carrossel / Pills de Navegação Rápida de Meses */}
                <div className="flex items-center gap-2 overflow-x-auto pb-3 mb-6 scrollbar-thin">
                  {timeline.map(t => {
                    const isSelected = t.mes === mesRef;
                    const sobra = t.sobra_mes;
                    return (
                      <button
                        key={t.mes}
                        onClick={() => {
                          setMesRef(t.mes);
                          notificar('Viajando no tempo para ' + t.mes);
                        }}
                        className={'flex-shrink-0 px-3.5 py-2 rounded-xl text-xs font-mono transition-all border text-left cursor-pointer ' + (
                          isSelected
                            ? 'bg-indigo-600 border-indigo-400 text-white shadow-lg shadow-indigo-600/30 font-bold scale-105'
                            : 'bg-slate-950/70 border-slate-800 hover:border-slate-700 text-slate-300 hover:text-white'
                        )}
                      >
                        <div className="font-bold flex items-center justify-between gap-2">
                          <span>{t.mes}</span>
                          {isSelected && <span className="text-[9px] bg-white/20 px-1 rounded uppercase">Ativo</span>}
                        </div>
                        <div className={'text-[11px] font-semibold mt-1 ' + (sobra >= 0 ? 'text-emerald-400' : 'text-rose-400')}>
                          {formatBRL(sobra)}
                        </div>
                      </button>
                    );
                  })}
                </div>

                {/* Tabela Detalhada com Colunas de Receita, Fixas, Cartão e Saldo Acumulado */}
                <div className="overflow-x-auto rounded-xl border border-slate-800">
                  <table className="w-full text-left text-xs font-mono">
                    <thead className="bg-slate-950/80 text-slate-400 uppercase border-b border-slate-800">
                      <tr>
                        <th className="py-3 px-4">Mês</th>
                        <th className="py-3 px-4">Receitas</th>
                        <th className="py-3 px-4">Custos Fixos</th>
                        <th className="py-3 px-4 text-rose-400">Faturas Cartão</th>
                        <th className="py-3 px-4">Total Saídas</th>
                        <th className="py-3 px-4">Sobra Líquida</th>
                        <th className="py-3 px-4 text-right">Saldo Acumulado</th>
                        <th className="py-3 px-4 text-center">Ação</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-800/40">
                      {timeline.map(t => {
                        const isSelected = t.mes === mesRef;
                        return (
                          <tr
                            key={t.mes}
                            className={'transition-colors ' + (
                              isSelected ? 'bg-indigo-950/30 font-bold' : 'hover:bg-slate-800/20'
                            )}
                          >
                            <td className="py-3 px-4 font-bold text-slate-200 flex items-center gap-1.5">
                              {t.mes}
                              {isSelected && <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 inline-block"></span>}
                            </td>
                            <td className="py-3 px-4 text-emerald-400 font-semibold">+{formatBRL(t.receitas)}</td>
                            <td className="py-3 px-4 text-slate-400">-{formatBRL(t.fixas)}</td>
                            <td className="py-3 px-4 text-rose-400 font-bold">-{formatBRL(t.faturas_cartao)}</td>
                            <td className="py-3 px-4 text-slate-300 font-semibold">-{formatBRL(t.despesas_totais)}</td>
                            <td className={'py-3 px-4 font-bold ' + (t.sobra_mes >= 0 ? 'text-emerald-400' : 'text-rose-400')}>
                              {formatBRL(t.sobra_mes)}
                            </td>
                            <td className="py-3 px-4 text-right font-black text-white">{formatBRL(t.saldo_acumulado)}</td>
                            <td className="py-3 px-4 text-center">
                              <button
                                onClick={() => {
                                  setMesRef(t.mes);
                                  notificar('Mês ' + t.mes + ' selecionado em todo o painel!');
                                }}
                                className={'px-2.5 py-1 rounded-lg text-[11px] font-semibold transition-all cursor-pointer ' + (
                                  isSelected
                                    ? 'bg-indigo-600 text-white'
                                    : 'bg-slate-800 hover:bg-slate-700 text-slate-300 hover:text-white'
                                )}
                              >
                                {isSelected ? 'Mês Atual' : 'Viajar'}
                              </button>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
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
                  onClick={() => {
                  setEditingWishId(null);
                  setWishForm({
                    item: '',
                    categoria: 'Setup / Equipamento',
                    valor_estimado: '',
                    parcelas_sugeridas: 1,
                    prioridade: 'Media',
                    condicao_compra: '',
                    link_ou_obs: ''
                  });
                  setShowModalWish(true);
                }}
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
                      <div className="flex items-center gap-1.5">
                        <button
                          onClick={() => abrirEdicaoWishlist(item)}
                          title="Editar Item Wishlist"
                          className="text-slate-400 hover:text-indigo-400 p-1.5 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-indigo-500/30"
                        >
                          <Pencil className="w-4 h-4" />
                        </button>
                        <button
                          onClick={async () => {
                            if (window.confirm("Deseja realmente remover '" + item.item + "' da Wishlist?")) {
                              await api.deletarWishlist(item.id);
                              notificar("Item removido!");
                              carregarTudo();
                            }
                          }}
                          title="Excluir Item Wishlist"
                          className="text-slate-400 hover:text-rose-400 p-1.5 rounded-lg transition-colors cursor-pointer border border-transparent hover:border-rose-500/30"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>

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
            <h3 className="text-base font-black text-slate-100 mb-4">{editingTxId ? "Editar Lançamento" : "Novo Lançamento"}</h3>
            <form onSubmit={handleSalvarTransacao} className="space-y-4">
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
            <h3 className="text-base font-black text-slate-100 mb-4">{editingWishId ? "Editar Item da Wishlist" : "Adicionar à Wishlist"}</h3>
            <form onSubmit={handleSalvarWishlist} className="space-y-3">
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
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl cursor-pointer"
                >
                  {editingWishId ? "Salvar Alterações" : "Salvar na Wishlist"}
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
            <h3 className="text-base font-black text-slate-100 mb-4">{editingFixaId ? "Editar Despesa Fixa" : "Nova Despesa Fixa"}</h3>
            <form onSubmit={handleSalvarFixa} className="space-y-3">
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
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl cursor-pointer"
                >
                  {editingFixaId ? "Atualizar Alterações" : "Salvar Despesa Fixa"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
          {/* MODAL: EFETIVAR SIMULAÇÃO EM TRANSAÇÃO REAL */}
      {showModalEfetivarSim && simResult && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl animate-fadeIn">
            <h3 className="text-base font-black text-slate-100 mb-2">Efetivar Simulação na Realidade</h3>
            <p className="text-xs text-slate-400 mb-4">
              Isso criará as parcelas no cartão ou conta escolhida a partir do mês programado.
            </p>

            <div className="bg-slate-950/60 border border-slate-800 rounded-xl p-3 mb-4 space-y-1.5 text-xs">
              <div className="flex justify-between">
                <span className="text-slate-400">Item:</span>
                <span className="font-bold text-slate-200">{simResult.compra_simulada || simForm.descricao}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Valor Total:</span>
                <span className="font-bold text-rose-400">{formatBRL(parseFloat(simForm.valor))}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Parcelas:</span>
                <span className="font-mono font-bold text-slate-200">{simResult.num_parcelas}x de {formatBRL(simResult.parcela_mensal)}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Início:</span>
                <span className="font-mono text-indigo-300">{simResult.mes_inicio}</span>
              </div>
            </div>

            <div className="space-y-3">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Lançar em qual Cartão / Conta:</label>
                <select
                  value={simEfetivarContaId}
                  onChange={e => setSimEfetivarContaId(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                >
                  {contas.map(c => (
                    <option key={c.id} value={c.id}>{c.nome} ({c.instituicao})</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-4 border-t border-slate-800 mt-5">
              <button
                type="button"
                onClick={() => setShowModalEfetivarSim(false)}
                className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200 cursor-pointer"
              >
                Cancelar
              </button>
              <button
                type="button"
                onClick={handleEfetivarSimulacaoReal}
                className="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold rounded-xl cursor-pointer"
              >
                Confirmar e Gravar Parcelas
              </button>
            </div>
          </div>
        </div>
      )}
      {/* MODAL: REAJUSTAR VALOR TOTAL DA FATURA */}
      {showModalReajuste && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md p-6 shadow-2xl animate-fadeIn">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-3 bg-indigo-600/20 text-indigo-400 rounded-xl border border-indigo-500/30">
                <CreditCard className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-base font-black text-slate-100">Reajustar Fatura Manualmente</h3>
                <p className="text-xs text-slate-400">
                  {showModalReajuste.cartao_nome} • Ciclo {showModalReajuste.mes_fatura}
                </p>
              </div>
            </div>

            <form onSubmit={handleReajustarFatura} className="space-y-4">
              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">
                  Valor Total Real no App do Banco (R$)
                </label>
                <input
                  type="number"
                  step="0.01"
                  required
                  placeholder="0.00"
                  value={reajusteNovoValor}
                  onChange={e => setReajusteNovoValor(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3.5 py-2.5 text-base font-mono font-bold text-rose-400 focus:outline-none focus:border-indigo-500"
                />
                <span className="text-[11px] text-slate-500 mt-1 block">
                  Valor atual no sistema: <strong className="text-slate-300 font-mono">{formatBRL(showModalReajuste.total_fatura)}</strong>
                </span>
              </div>

              <div>
                <label className="text-xs text-slate-400 font-medium block mb-1">Motivo do Reajuste</label>
                <input
                  type="text"
                  required
                  placeholder="Ex: IOF, anuidade, compra não registrada"
                  value={reajusteMotivo}
                  onChange={e => setReajusteMotivo(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500"
                />
              </div>

              <div className="flex justify-end gap-2 pt-4 border-t border-slate-800 mt-5">
                <button
                  type="button"
                  onClick={() => setShowModalReajuste(null)}
                  className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200 cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold rounded-xl cursor-pointer shadow-lg shadow-indigo-600/20"
                >
                  Confirmar e Recalcular Fatura
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
</div>
  );
}
