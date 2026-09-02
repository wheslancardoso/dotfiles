"""
Módulo de cálculo e recomendação de dimensionamento de partições para SSDs e HDs.
Converte valores nominais para tamanho binário real e calcula divisão ótima entre Sistema (C:) e Dados (D:).
"""

from typing import Dict, Tuple


class PartitionCalculator:
    """Calcula tamanhos ótimos para partição C: (Sistema) e D: (Dados/Jogos)."""

    @staticmethod
    def nominal_to_real_gb(nominal_gb: float) -> float:
        """Converte gigabytes comerciais (base 10^9) para gibibytes reais do Windows (base 2^30)."""
        bytes_total = nominal_gb * (10**9)
        real_gb = bytes_total / (1024**3)
        return round(real_gb, 1)

    @classmethod
    def calculate(cls, nominal_gb: float) -> Dict:
        """Calcula o particionamento recomendado com base na capacidade informada."""
        real_gb = cls.nominal_to_real_gb(nominal_gb)

        if nominal_gb <= 128:
            return {
                "nominal_gb": nominal_gb,
                "real_gb": real_gb,
                "recomendacao": "Nao Particionar",
                "motivo": "Para discos <= 128 GB, particionar estrangulará o sistema operacional. Mantenha 100% no C:.",
                "c_gb": real_gb,
                "c_mb": int(real_gb * 1024),
                "d_gb": 0,
                "d_mb": 0,
                "shrink_mb": 0,
            }

        if nominal_gb <= 260:
            c_gb = 95.0
        elif nominal_gb <= 520:
            c_gb = 135.0
        elif nominal_gb <= 1050:
            c_gb = 200.0
        elif nominal_gb <= 2100:
            c_gb = 280.0
        else:
            c_gb = 350.0

        d_gb = round(real_gb - c_gb, 1)
        c_mb = int(c_gb * 1024)
        d_mb = int(d_gb * 1024)

        return {
            "nominal_gb": nominal_gb,
            "real_gb": real_gb,
            "recomendacao": "Particionamento Otimizado",
            "c_gb": c_gb,
            "c_mb": c_mb,
            "d_gb": d_gb,
            "d_mb": d_mb,
            "shrink_mb": d_mb,  # Quantidade exata a diminuir do C: no Gerenciador de Disco
            "motivo": f"Partição C: com {c_gb} GB garante folga para Windows + Apps + Cache NVMe. Partição D: com {d_gb} GB isola seus jogos e arquivos contra formatações.",
        }

    @classmethod
    def format_report(cls, calc_result: Dict) -> str:
        """Formata o resultado em um relatório visual para o terminal."""
        res = calc_result
        nominal = res["nominal_gb"]
        real = res["real_gb"]
        c_gb = res["c_gb"]
        d_gb = res["d_gb"]
        shrink_mb = res["shrink_mb"]

        report = [
            f"\n==================================================",
            f"   📐 CALCULADORA DE PARTIÇÃO — SSD/HD {nominal} GB",
            f"==================================================",
            f" • Capacidade Nominal : {nominal} GB",
            f" • Espaço Real no Win : ~{real} GB utilizáveis",
            f"--------------------------------------------------",
            f" 🪟 Partição C:\\ (Sistema & Softwares) : {c_gb} GB ({res['c_mb']} MB)",
            f" 🎮 Partição D:\\ (Dados, Jogos, Saves) : {d_gb} GB ({res['d_mb']} MB)",
            f"--------------------------------------------------",
            f" 💡 NO GERENCIADOR DE DISCO (diskmgmt.msc):",
            f"    ➔ Diminuir volume do C:\\ em: {shrink_mb} MB",
            f"    ➔ Criar novo volume no espaço liberado com a letra D:",
            f"==================================================\n",
        ]
        return "\n".join(report)
