import React, { useState, useRef, useEffect } from 'react';
import { Calendar, ChevronLeft, ChevronRight, Check } from 'lucide-react';

interface CustomMonthPickerProps {
  value: string; // formato "AAAA-MM" (ex: "2026-10")
  onChange: (newMonth: string) => void;
  label?: string;
}

const MESES = [
  { num: '01', nome: 'Jan', extenso: 'Janeiro' },
  { num: '02', nome: 'Fev', extenso: 'Fevereiro' },
  { num: '03', nome: 'Mar', extenso: 'Março' },
  { num: '04', nome: 'Abr', extenso: 'Abril' },
  { num: '05', nome: 'Mai', extenso: 'Maio' },
  { num: '06', nome: 'Jun', extenso: 'Junho' },
  { num: '07', nome: 'Jul', extenso: 'Julho' },
  { num: '08', nome: 'Ago', extenso: 'Agosto' },
  { num: '09', nome: 'Set', extenso: 'Setembro' },
  { num: '10', nome: 'Out', extenso: 'Outubro' },
  { num: '11', nome: 'Nov', extenso: 'Novembro' },
  { num: '12', nome: 'Dez', extenso: 'Dezembro' },
];

export const CustomMonthPicker: React.FC<CustomMonthPickerProps> = ({ value, onChange, label }) => {
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const [anoAtual, setAnoAtual] = useState(() => {
    if (value && value.includes('-')) {
      return parseInt(value.split('-')[0], 10);
    }
    return new Date().getFullYear();
  });

  const mesAtualStr = value && value.includes('-') ? value.split('-')[1] : '10';

  useEffect(() => {
    if (value && value.includes('-')) {
      setAnoAtual(parseInt(value.split('-')[0], 10));
    }
  }, [value]);

  // Fechar ao clicar fora
  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    }
    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isOpen]);

  const mesObj = MESES.find(m => m.num === mesAtualStr) || MESES[8];
  const labelExibicao = mesObj ? (mesObj.extenso + ' ' + (value.split('-')[0] || anoAtual)) : value;

  const handleSelectMes = (mNum: string) => {
    onChange(anoAtual + '-' + mNum);
    setIsOpen(false);
  };

  const hoje = new Date();
  const hojeMesStr = hoje.getFullYear() + '-' + String(hoje.getMonth() + 1).padStart(2, '0');

  const irParaHoje = () => {
    onChange(hojeMesStr);
    setAnoAtual(hoje.getFullYear());
    setIsOpen(false);
  };

  return (
    <div className="relative inline-block" ref={containerRef}>
      {label && <label className="text-xs text-slate-400 font-medium block mb-1">{label}</label>}

      {/* Botão Gatilho Estilizado Dark APEX */}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2.5 bg-slate-900/90 hover:bg-slate-800 border border-slate-700/80 hover:border-indigo-500/70 rounded-xl px-3.5 py-1.5 text-sm font-semibold text-slate-100 shadow-inner transition-all group cursor-pointer focus:outline-none focus:ring-2 focus:ring-indigo-500/30"
      >
        <Calendar className="w-4 h-4 text-indigo-400 group-hover:text-indigo-300 transition-colors" />
        <span className="text-indigo-200 group-hover:text-white font-medium">{labelExibicao}</span>
        <span className="text-[10px] text-slate-500 bg-slate-800/80 group-hover:bg-slate-700/80 px-1.5 py-0.5 rounded font-mono">
          {value}
        </span>
      </button>

      {/* Popover Customizado Dark Glass - Solid and Highest Z-Index */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-72 bg-[#0d1322] border border-slate-700 rounded-2xl shadow-[0_20px_60px_-15px_rgba(0,0,0,0.95)] p-4 z-[9999] animate-fadeIn">
          {/* Cabeçalho do Ano */}
          <div className="flex items-center justify-between pb-3 mb-3 border-b border-slate-800">
            <button
              type="button"
              onClick={() => setAnoAtual(anoAtual - 1)}
              className="p-1.5 hover:bg-slate-800 rounded-lg text-slate-400 hover:text-white transition-colors cursor-pointer"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <span className="text-sm font-bold text-slate-100 font-mono tracking-wide">{anoAtual}</span>
            <button
              type="button"
              onClick={() => setAnoAtual(anoAtual + 1)}
              className="p-1.5 hover:bg-slate-800 rounded-lg text-slate-400 hover:text-white transition-colors cursor-pointer"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>

          {/* Grid de Meses */}
          <div className="grid grid-cols-3 gap-2">
            {MESES.map(m => {
              const itemMesCompleto = anoAtual + '-' + m.num;
              const isSelected = value === itemMesCompleto;
              const isHoje = hojeMesStr === itemMesCompleto;

              return (
                <button
                  key={m.num}
                  type="button"
                  onClick={() => handleSelectMes(m.num)}
                  className={'py-2 px-2.5 rounded-xl text-xs font-semibold transition-all flex flex-col items-center justify-center relative cursor-pointer ' + (
                    isSelected
                      ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/30 font-bold'
                      : isHoje
                      ? 'bg-slate-800/90 text-indigo-300 border border-indigo-500/40 hover:bg-indigo-600/20'
                      : 'bg-slate-800/40 hover:bg-slate-800 text-slate-300 hover:text-white'
                  )}
                >
                  <span>{m.nome}</span>
                  {isSelected && <Check className="w-3 h-3 absolute right-1.5 top-1.5 text-white/80" />}
                </button>
              );
            })}
          </div>

          {/* Atalho Mês Atual */}
          <div className="mt-3 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <button
              type="button"
              onClick={irParaHoje}
              className="text-indigo-400 hover:text-indigo-300 font-medium transition-colors cursor-pointer"
            >
              Ir para Mês Atual
            </button>
            <button
              type="button"
              onClick={() => setIsOpen(false)}
              className="text-slate-500 hover:text-slate-300 transition-colors cursor-pointer"
            >
              Fechar
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
