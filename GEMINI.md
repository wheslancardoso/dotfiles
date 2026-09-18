# 🏛️ LEI SUPREMA DE DIRETRIZES & ENGENHARIA DE ESTUDOS (CONCURSO TCE-GO 2026)

Este repositório é a base de operações soberana e de elite para a aprovação no concurso de **Auditor de Controle Externo (TI) do TCE-GO 2026** (Banca FCC).

Qualquer agente de IA operando neste repositório (em qualquer máquina onde ele for clonado) DEVE seguir rigorosamente as 4 regras soberanas abaixo, detalhadas em `.agents/rules/`:

---

## ⚡ 1. REGRA DA MONOTAREFA SEQUENCIAL & COMMITS CIRÚRGICOS (`.agents/rules/01_*.md`)
* **Proibido Multitarefa Desesperada:** Nunca tente processar sessão, atualizar erros, escrever aula e gerar cards tudo ao mesmo tempo de forma corrida ou superficial.
* **Execução Unitária em 5 Fases:** Execute **UMA FASE POR VEZ**, com profundidade máxima do zero absoluto, valide o resultado, faça o commit semântico correspondente e somente então avance para a fase seguinte.

---

## 📥 2. PROTOCOLO DE INGESTÃO DE SESSÕES DO GEMINI (`.agents/rules/02_*.md`)
Toda vez que o usuário colar ou apontar um chat do Gemini ou caderno de erros:
1. **Renomeação Canônica:** Detectar a próxima sessão (ex: `Sessao 10`) e salvar como `diario_de_batalha/YYYY-MM-DD - Sessao XX (Caderno YY - <Assunto> - Z Questoes).md`. Commit: `docs(diario)`.
2. **Desmontagem Forense do Zero:** Dissecar cada questão nas 3 camadas:
   * 🧠 **Causa-Raiz Conceitual:** O conceito puro ensinado do zero absoluto.
   * 💥 **Dor no Mundo Real:** O problema prático de engenharia que o conceito resolve.
   * 🍌 **Casca de Banana da FCC:** Onde a banca tentou induzir ao erro.
   * Atualizar o caderno em `cadernos_de_erros/por_materia/`. Commit: `feat(erros)`.
3. **Fechamento de Lacunas Teóricas:** Atualizar/criar a aula masterclass em `aulas/caderno_YY/md/` e compilar para `html/`. Commit: `feat(aulas)`.
4. **Extração Atômica de Flashcards:** Gerar cards atômicos de retenção máxima no lote do caderno, rodar auditoria e recompilar o deck mestre. Commit: `feat(anki)`.
5. **Sincronização:** `git push origin main`.

---

## 🎴 3. A LEI SAGRADA DOS FLASHCARDS DO ANKI (`.agents/rules/03_*.md`)
* **Princípio da Atomicidade Máxima (Piotr Wozniak / 20 Regras):** 1 Card = 1 Único Fato Atômico.
* **❌ TERMINANTEMENTE PROIBIDO:** Cards baseados no erro da questão (*"No contexto da questão...", "Você marcou C...", "Você chutou...", "Gabarito oficial: D..."*), versos quilométricos ou vazios.
* **✅ Didática do Zero:** O card deve ensinar o conceito na marra para qualquer estudante, sem pressupor ter visto a questão.
* **Auditoria Forense Obrigatória:** Rodar auditoria para garantir 0 termos degradantes e 0 versos vazios antes de recompilar o master deck.

---

## 📚 4. PADRÃO MASTERCLASS DE AULAS TEÓRICAS (`.agents/rules/04_*.md`)
* Toda aula deve conter: Mapa de Danos, Gancho de 60s, Teoria Pura do Zero à Maestria, Diagrama Mermaid, Tabela Comparativa e Cascas de Banana da FCC.
* Toda alteração em `.md` deve ser imediatamente compilada para `.html` via `python3 scripts/gerar_aulas_html.py`.
