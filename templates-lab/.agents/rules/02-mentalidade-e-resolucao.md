# 🥋 PROTOCOLO DOJO AGR — 02: COMO PENSAR COMO PROGRAMADOR & RAIO-X DE MÁQUINA
## *(Os 6 Passos Universais de Resolução & Anatomia de Stack vs Heap)*

Antes de sugerir qualquer sintaxe, a IA guia o dev obrigatoriamente por estes 6 passos universais (A Cura da Tela em Branco):

---

### 🧠 1. OS 6 PASSOS UNIVERSAIS DE RESOLUÇÃO DE PROBLEMAS

1. **Contrato de Entrada, Saída & Edge Cases (I/O):**
   * *Entrada:* Que tipos e estruturas exatas chegam na mão?
   * *Saída:* O que exatamente deve sair do outro lado? (Tipo, DTO, HTTP 200/404).
   * *Edge Cases:* E se vier vazio? E se for nulo? E se o banco falhar? (Arquiteto programa para a realidade).

2. **A Jornada do Dado (The Data Journey):**
   * Narrar a rota: *Banco (tabela) -> Memória (Java/Node) -> Regra de Negócio -> DTO limpo -> Rede (JSON) -> Tela*.

3. **Dividir para Conquistar (Pseudocódigo em Português Puro):**
   * Escrever em comentários no arquivo a sequência de ações em português simples antes de qualquer código:
     ```text
     // 1. Pegar o ID da requisição
     // 2. Buscar no banco
     // 3. Se não achar, lançar 404
     // 4. Se achar, calcular pendências
     // 5. Devolver DTO preenchido
     ```

4. **Batismo Semântico de Elite (Nomenclatura Limpa):**
   * Proibido nomes preguiçosos: `x`, `temp`, `aux`, `data`, `lista`, `obj`, `retorno`.
   * Substantivos expressivos para estado: `motoristaComInfracao`, `totalMultasPendentes`.
   * Verbos no infinitivo para métodos: `calcularValorComDesconto()`, `buscarPorCpf()`.

5. **Descascar a Cebola (Expressões Lógicas Complexas):**
   * Proibido empilhar `&&`, `||`, ternários ilegíveis. Decomponha em booleanos autoexplicativos:
     ```java
     boolean isVeiculoRecente = veiculo.getAno() > 2015;
     boolean isSemDebitos = veiculo.getDebitos() == null || veiculo.getDebitos().isEmpty();
     boolean isAptoParaVistoria = isVeiculoRecente && isSemDebitos && !veiculo.isBloqueado();
     if (isAptoParaVistoria) { ... }
     ```

6. **Dry-Run Mental (Processador Humano):**
   * O dev rastreia a lógica na cabeça como se fosse a CPU antes de compilar.

---

### 🔬 2. RAIO-X POR BAIXO DO CAPÔ (SEM "MAGIA")

* **Stack vs Heap:**
  * Primitivos moram na gaveta rápida da thread (**Stack**).
  * Objetos moram no galpão geral (**Heap**), e a variável guarda apenas um ponteiro (endereço de memória).
  * `NullPointerException` ou `undefined` nada mais é do que tentar abrir uma gaveta onde o ponteiro aponta para o vazio.
* **`=` vs `==` / `===`:**
  * Atribuição (despejo de dados em uma variável) vs Comparação de igualdade.
* **Compilador vs CPU vs Rede:**
  * O que o compilador valida em tempo de build (tipos, sintaxe) vs o que realmente roda na CPU (instruções, ciclos) ou trafega na rede (bytes serializados em JSON).
