# 🥋 PROTOCOLO DOJO AGR — 06: AUDITORIA DE BANCO & INTEGRIDADE DE RELATÓRIOS
## *(Validação Cruzada Banco x Aplicação, Desambiguação de Joins e Prevenção de Falso Positivo)*

---

### 📌 1. A REGRA DE OURO DA ENTIDADE-RAIZ EM RELATÓRIOS
Em relatórios de negócio (como relatórios de TRV, Abordagens, Notificações, Autos):
1. **O status ativo deve incidir na entidade PRIMÁRIA do relatório:**
   - Se o relatório é de **Termo de Remoção de Veículo (TRV)**, a cláusula mandatória é `WHERE trv.situacao = 'ATIVO'`.
   - **NUNCA** filtre rigidamente `WHERE entidadeSecundaria.situacao = 'ATIVO'` se a anulação da secundária (ex.: cancelamento de auto de infração) não anula o evento físico principal (ex.: veículo que foi efetivamente removido para o pátio).
2. **Blindagem contra Duplicidades em Relacionamentos 1:N:**
   - Quando a entidade-raiz se relaciona com entidades que podem conter registros anulados por duplicidade (ex.: dois autos lavrados na mesma abordagem), o `JOIN` deve desambiguar e priorizar o registro ativo (ex.: subquery com `ORDER BY CASE WHEN situacao = 'ATIVO' THEN 1 ELSE 2 END ... LIMIT 1`).
   - Jamais permita que um `INNER JOIN` multiplique linhas ou exclua a entidade-raiz.

---

### 📌 2. CHECKLIST OBRIGATÓRIO PRÉ-HOMOLOGAÇÃO (AUDITORIA CRUZADA)
Antes de declarar qualquer relatório pronto ou enviar para homologação:
1. **Batimento de Contagem Absoluta:**
   - Execute a contagem total da tabela no banco usando as credenciais de `conexaobanco.md`:
     ```sql
     SELECT COUNT(*) FROM tabela_principal WHERE situacao = 'ATIVO';
     ```
   - Compare com a quantidade total retornada pelo endpoint e pelo cabeçalho/resumo do PDF/XLS (`$P{quantidade}`).
   - **Diferença aceitável:** ZERO registros. Se houver divergência, é obrigatório rodar o `LEFT JOIN ... WHERE q.id IS NULL` para identificar os IDs divergentes antes de liberar o PR.
2. **Teste de Casos de Borda Administrativos:**
   - Validar explicitamente registros com auto anulado.
   - Validar registros com autos gerados em duplicidade.
   - Validar registros com datas antigas vinculadas a cadastros recentes (ex.: dados fictícios de homologação).

---

### 📌 3. PROTOCOLO DE CONEXÃO AO BANCO DE DADOS
Sempre que for necessário auditar, confrontar ou verificar dados no MySQL de homologação:
* Utilizar as credenciais centralizadas em `conexaobanco.md`:
  - **Host / Porta:** `10.243.1.27:3306`
  - **Database:** `fiscalizacao`
  - **Client CLI:** `mysqlsh` ou script PowerShell com autenticação segura.
