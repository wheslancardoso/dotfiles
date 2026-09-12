# ⚡ Guia Mestre de Digitação de Elite (200+ WPM para Devs)

> **"Velocidade não é pressa; é a ausência total de movimentos desnecessários e hesitações cognitivas."**

---

## 1. A Ciência da Neuroplasticidade: Quanto Tempo Treinar por Dia?

Pesquisas em neurociência motora e aquisição de habilidades de alta performance (*Deliberate Practice*) comprovam que o cérebro consolida memória muscular durante as fases de sono profundo (ondas lentas e REM), desde que haja **estímulo intenso com foco total e zero fadiga acumulada**.

### ⏱️ O Ponto Ideal Diário: 15 a 25 Minutos
* ❌ **O Grande Erro:** Treinar 2 horas seguidas até a mão doer. Isso gera fadiga nos tendões, degrada a precisão e consolida erros motores ruins (*bad motor habits*).
* ✔️ **O Protocolo Ótimo (Divisão em 2 Blocos de 10-12 Minutos):**
  * **Bloco 1 (Manhã / Antes de Começar a Codar):** 10 a 12 minutos focados em **Acurácia & Símbolos** (aquecimento neural).
  * **Bloco 2 (Final da Tarde / Noite):** 10 a 12 minutos focados em **Speed Burst & Modo Adaptativo** (tentativas de quebra de recorde WPM).

---

## 2. A Rotina Diária de Treino em 4 Fases (15 Minutos)

Para extrair o máximo de cada sessão no terminal usando o `devtype`:

```
┌─────────────────────────────────────────────────────────────┐
│  Fase 1: Aquecimento & Alinhamento (3 min)                  │
│  → Modo 6 (English 1k Prosa) ou Modo 7 (PT-BR)              │
│  → Objetivo: Aquecer os dedos sem forçar velocidade (99%+) │
├─────────────────────────────────────────────────────────────┤
│  Fase 2: The Symbol Gauntlet (5 min)                        │
│  → Modo 1 (Símbolos & Operadores: {}, [], =>, !==)          │
│  → Objetivo: Eliminar qualquer travamento em caracteres dev │
├─────────────────────────────────────────────────────────────┤
│  Fase 3: Prática Deliberada / Modo Adaptativo (4 min)       │
│  → Modo 8 (Adaptive Weak-Key Gauntlet)                      │
│  → O algoritmo ataca cirurgicamente suas letras com erros   │
├─────────────────────────────────────────────────────────────┤
│  Fase 4: Real-Code Speed Burst & Master Mode (3 min)        │
│  → Modo 2 (TypeScript) ou Modo 3 (Python/Rust) [Master Mode]│
│  → Objetivo: Digitar código real na velocidade máxima       │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Biomecânica de Elite no Logitech Pebble Keys 2 (K380s)

O **Logitech K380s** possui teclas tesoura (*scissor switch*) com curso curto de **1.5 mm**. É um dos teclados de membrana mais rápidos do mundo para velocidade pura, mas exige técnica refinada.

### 📐 Ergonomia & Postura
1. **Pulsos Flutuantes (*Floating Palms*):**
   * Nunca apoie a base da palma na mesa enquanto digita rápido.
   * Os antebraços devem ficar paralelos ao chão e os pulsos retos. As mãos flutuam suavemente sobre o teclado.
2. **Dedos Curvados (*Curved Fingertips*):**
   * As teclas do K380s são redondas. Para não escorregar no vão entre as teclas, bata com a ponta da polpa do dedo exatamente no centro da concavidade da tecla.
3. **Toque Leve (*Light Feather Touch*):**
   * A tecla ativa com pouca força. Não "esmague" o teclado. Quanto menor a força de impacto, mais rápida é a recuperação do dedo para a próxima tecla.

### ⚡ As Técnicas Avançadas
* **Rolagem de Dedos (*Finger Rolling*):**
  * Para palavras ou padrões comuns (`const`, `return`, `async`, `ion`, `tion`), não digite letra por letra pausadamente. Dispare os dedos em sequência como tocar uma escala rápida de piano.
* **A Regra dos Dois Shifts (*Opposite Shift Rule*):**
  * Letra na mão esquerda $\rightarrow$ Shift com o mindinho direito.
  * Letra na mão direita $\rightarrow$ Shift com o mindinho esquerdo.
  * *Nunca force a mesma mão a segurar Shift e apertar a tecla vizinha.*
* **Lookahead Buffering (Visão Antecipada):**
  * Seus olhos **nunca** devem olhar para a palavra que você está digitando no momento. Seus olhos devem estar lendo 1 ou 2 palavras à frente. Seus dedos processam o buffer motor em segundo plano enquanto seus olhos escaneiam o futuro.

---

## 4. Comandos do Motor `devtype`

O motor nativo `devtype` está integrado ao seu sistema:

| Comando | Descrição |
| :--- | :--- |
| `devtype` | Abre o menu interativo com todos os modos de treino. |
| `devtype -s` ou `[S]` | Abre o painel com estatísticas, recordes e **Heatmap Visual do seu Teclado**. |
| `devtype -m` ou `[M]` | Ativa o **Master Mode** (reinicia na hora se a precisão cair abaixo de 98%). |
| `devtype -f arquivo.ts` | Carrega qualquer arquivo do seu computador para treinar com seu próprio código! |
| `devtype -d src/` | Escaneia a pasta do seu projeto e extrai snippets reais para treino. |

### Atalhos dentro do teste:
* `TAB` : Reinicia o teste instantaneamente com um novo snippet.
* `Ctrl + W` : Apaga a palavra inteira de uma vez.
* `Backspace` : Corrige o último caractere.
* `Esc` : Volta para o menu.

---

## 5. Prevenção de Lesões (Alongamentos de 60 Segundos)

Faça antes e depois de cada sessão de treino:
1. **Extensão de Punho:** Estenda o braço para frente, puxe a ponta dos dedos para trás gentilmente por 15 segundos em cada mão.
2. **Abertura de Dedos:** Abra as mãos na largura máxima como uma estrela por 5 segundos e feche em punho leve. Repita 5 vezes.
3. **Relaxamento de Ombros:** Gire os ombros para trás 5 vezes para liberar a tensão do trapézio.
