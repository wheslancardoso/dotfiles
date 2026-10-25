# Blueprint Arquitetural & Especificação Canônica: Módulo 03
## Persistência de Dados Relacional: JPA Puro, Hibernate 6.5+, Concorrência Crítica & Migrations com Flyway
### Documento Alvo: `/home/lan/dotfiles/templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md`

> **Autor:** Explorer Milestone 3 (Persistência JPA, Hibernate & Concorrência)  
> **Data:** 25 de Outubro de 2026  
> **Status:** Especificação Canônica Aprovada para Autoria  
> **Conformidade Normativa:** `ORIGINAL_REQUEST.md`, `PROJECT.md` (F09, F10, F11, F12), `scripts/verify_docs_suite.py` (Tiers 1 a 4)

---

## 1. Sumário Executivo & Diretrizes de Engenharia

O Módulo 03 da suíte pedagógica modular destina-se a transformar a compreensão de persistência relacional do desenvolvedor, elevando-o da visão ingênua de "banco de dados como repositório mágico de objetos" para o domínio da **física de I/O relacional, do modelo semântico do Hibernate 6.5+ (SQM), da contenção atômica de concorrência e da imutabilidade de migrações estruturais**.

Em sistemas governamentais de grande escala — como o ecossistema de 25 microsserviços da **Agência Goiana de Regulação (AGR)** operando sob contenção crônica de banco — e em sistemas de alta vazão concorrente como a bilhetagem do **Teatro-ABC**, o uso amador do JPA/Hibernate resulta em catástrofes previsíveis:
1. Esgotamento instantâneo do pool de conexões (HikariCP) causado pelo antipadrão **Open Session In View (OSIV)**.
2. Explosão de consultas no banco de dados (**Problema do N+1**) decorrente do desconhecimento da armadilha do `FetchType.EAGER` padrão da especificação JPA.
3. Corrupção silenciosa de registros administrativos por sobrescrita cega (**Lost Updates**), resultante da ausência de **Lock Otimista (`@Version`)**.
4. Conflitos destrutivos e reservas duplicadas em recursos escassos decorrentes da falta de **Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`)**.
5. Desastres de deploy em produção causados pelo uso do perigoso `hibernate.hbm2ddl.auto=update`, superado obrigatoriamente pelo controle estrito de migrações versionadas com **Flyway 10+**.

O documento `03-persistencia-dados-jpa-hibernate-concorrencia.md` deverá ter **mais de 800 linhas** (superando com folga o mínimo regulamentar de 301 linhas exigido pelo Tier 2 de `verify_docs_suite.py`), conter **zero placeholders** (`TODO`, `FIXME`, `[TBD]`, reticências bare `...`), e implementar estritamente a **Quadrupleta Canônica em 4 Partes** para cada um dos conceitos centrais.

---

## 2. Matriz de Conformidade com `scripts/verify_docs_suite.py`

O script de validação automatizada impõe os seguintes testes determinísticos para o arquivo `03-persistencia-dados-jpa-hibernate-concorrencia.md`:

| Identificador do Check | Descrição da Regra | Expressão Regular Canônica no Test Harness | Estratégia de Atendimento no Blueprint |
| :--- | :--- | :--- | :--- |
| **`T1-FILE-03-P`** | Existência física e arquivo não-vazio no diretório alvo | `templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md` presente e `size > 0` | Criação integral no caminho canônico. |
| **`T2-LEN-03-P`** | Volume de conteúdo substantive (> 300 linhas) | `len(lines) >= 301` | Blueprint estruturado para gerar entre 1.000 e 1.400 linhas de densidade técnica pura. |
| **`T2-PH-03-P`** | Proibição de marcadores incompletos | `r"\b(TODO\|FIXME\|\[TBD\]\|implementar\s+depois\|em\s+breve)\b"` | Zero ocorrências. Todos os blocos de código e tabelas são 100% implementados. |
| **`T2-ELLIP-03-P`** | Proibição de reticências bare em blocos de código | `r"^\s*(//\|#\|/\*\|<!--)?\s*\.\.\.\s*(\*/\|-->)?\s*$"` | Todo exemplo de código é autocontido e funcional. Comentários explicativos substituem qualquer omissão. |
| **`T3-PART1-03-P`** | Presença da Parte 1 da estrutura pedagógica | `r"(o\s+que\s+[eé]\s+(o\|um)?\s*conceito\|analogia(\s+com\s+o\s+mundo\s+real\|\s+did[aá]tica)?\|conceito\s+puro)"` | Subtítulo explícito: `#### Parte 1: O que é o conceito / Analogia Didática` em todas as seções. |
| **`T3-PART2-03-P`** | Presença da Parte 2 da estrutura pedagógica | `r"(a\s+dor\s+hist[oó]rica\|o\s+desastre\s+do\s+legado\|o\s+que\s+quebrava\s+em\s+produ[cç][aã]o\|dor\s+no\s+mundo\s+real)"` | Subtítulo explícito: `#### Parte 2: A Dor Histórica / O Desastre do Legado` em todas as seções. |
| **`T3-PART3-03-P`** | Presença da Parte 3 da estrutura pedagógica | `r"(a\s+solu[cç][aã]o\s+moderna(\s+de\s+elite)?\|engenharia\s+moderna\|solu[cç][aã]o\s+de\s+elite)"` | Subtítulo explícito: `#### Parte 3: A Solução Moderna de Elite` em todas as seções. |
| **`T3-PART4-03-P`** | Presença da Parte 4 da estrutura pedagógica | `r"(v[ií]nculo\s+direto\s+com\s+(o\s+)?AGR(-Docs)?\|teatro-abc\|aplica[cç][aã]o\s+no\s+AGR\|onde\s+(isso\s+)?se\s+aplica\s+no\s+AGR)"` | Subtítulo explícito: `#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` em todas as seções. |
| **`T3-CONTRAST-03-P-1`**| Contraste JPA puro vs Hibernate 6.x / Jakarta Persistence 3.1 | `r"(Jakarta\s+Persistence\|JPA\s+puro).*Hibernate\|Hibernate.*(Jakarta\s+Persistence\|JPA\s+puro)"` | Abordagem aprofundada na Seção 1 (especificação vs implementação, SQM, ciclo de vida, dirty checking). |
| **`T3-CONTRAST-03-P-2`**| Mapeamentos sem N+1 (JOIN FETCH / EntityGraph / Projeções) | `r"(N\s*\+\s*1\|JOIN\s+FETCH\|EntityGraph)"` | Abordagem aprofundada na Seção 2 (combate ao N+1, `FetchType.LAZY`, `@EntityGraph`, Projeções DTO Records). |
| **`T3-CONTRAST-03-P-3`**| Lock Otimista (@Version) vs Lock Pessimista | `r"(@Version\|OptimisticLockException).*Pessimis\|Pessimis.*(@Version\|OptimisticLockException)"` | Abordagem aprofundada na Seção 3 (`@Version`, `OptimisticLockException`, `LockModeType.PESSIMISTIC_WRITE`). |
| **`T3-CONTRAST-03-P-4`**| Versionamento com Flyway vs ddl-auto=update | `r"(Flyway\|V1__).*(ddl-auto\|update)\|(ddl-auto\|update).*(Flyway\|V1__)"` | Abordagem aprofundada na Seção 4 (estrutura `V1__`, `V2__`, `R__`, banimento absoluto de `ddl-auto=update`). |

---

## 3. Estrutura Canônica & Outline Detalhado do Arquivo

O arquivo `/home/lan/dotfiles/templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md` será organizado nas seguintes 6 grandes divisões estruturais:

```
# Módulo 03: Persistência Relacional Avançada: JPA Puro, Hibernate 6.5+, Concorrência Crítica & Migrations com Flyway

## Sumário Executivo & Manifesto da Persistência de Elite
  - A ilusão do ORM como repositório de memória infinita
  - A física de I/O de banco de dados: conexões JDBC, pools (HikariCP), latência de rede e isolamento ACID
  - O contrato pedagógico em 4 camadas

## 1. JPA Puro vs Hibernate 6.5+: Especificação Jakarta Persistence 3.1 & Otimizações de Engine
  ### 1.1 Especificação (JPA / Jakarta Persistence 3.1) vs Implementação (Hibernate ORM 6.5+)
    - Parte 1: O que é o conceito / Analogia Didática (A Constituição Federal e os Códigos Operacionais)
    - Parte 2: A Dor Histórica / O Desastre do Legado (O choque da migração javax.* para jakarta.* e o acoplamento proprietário)
    - Parte 3: A Solução Moderna de Elite (Código Java 21 limpo, EntityManager, Jakarta EE 10)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (portalservice :8080 e cadu :8081 saneando DAOs antigos)
  ### 1.2 O Motor Semantic Query Model (SQM) do Hibernate 6+ e a Física da Compilação de Consultas
    - Parte 1: O que é o conceito / Analogia Didática (O Compilador C2 da JVM vs Compilador SQM de SQL)
    - Parte 2: A Dor Histórica / O Desastre do Legado (A fragilidade do HQL AST antigo no Hibernate 5 e bugs de parsing)
    - Parte 3: A Solução Moderna de Elite (Consultas SQM com funções analíticas nativas, Window Functions e Subqueries)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Relatórios de fiscalização e ordenação analítica)
  ### 1.3 O Ciclo de Vida da Entidade (Transient, Managed, Detached, Removed) e Dirty Checking Otimizado
    - Parte 1: O que é o conceito / Analogia Didática (O Crachá de Acesso do Visitante no Edifício Governamental)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Entidades detached causando LazyInitializationException e chamadas inúteis de em.merge)
    - Parte 3: A Solução Moderna de Elite (Demonstração prática dos 4 estados, flush() explícito vs commit, e dirty checking sem overhead)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (cadastrounicoservice :8081 na alteração de frotas e empresas)

## 2. Mapeamentos Avançados e o Extermínio Definitivo do Problema N+1
  ### 2.1 A Armadilha do Eager Loading Default em @ManyToOne e @OneToOne
    - Parte 1: O que é o conceito / Analogia Didática (O Entregador Ansioso que faz 100 viagens para trazer uma compra)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação Literal AlgaWorks 412_6.10: "Uma única consulta gerou 6 selects...")
    - Parte 3: A Solução Moderna de Elite (A Regra de Ouro: FetchType.LAZY obrigatório em 100% dos relacionamentos)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (cadastrounicoservice :8081: Veículo -> Empresa -> Município)
  ### 2.2 As Armas de Elite contra o N+1: JOIN FETCH, @EntityGraph Declarativo e Projeções DTO com Records
    - Parte 1: O que é o conceito / Analogia Didática (O Frete Consolidado e o Raio-X Cirúrgico de Documento)
    - Parte 2: A Dor Histórica / O Desastre do Legado (O Produto Cartesiano destrutivo com MultipleBagFetchException)
    - Parte 3: A Solução Moderna de Elite (Código completo: JPQL JOIN FETCH, @EntityGraph, DTO Constructor Expression com Java 21 Record)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (agrfiscalservice :8083 na listagem consolidada de Autos de Infração)
  ### 2.3 O Antipadrão Open Session In View (OSIV) e o Esgotamento do Pool HikariCP
    - Parte 1: O que é o conceito / Analogia Didática (A Torneira Aberta na Cozinha enquanto o Cliente Escolhe o Prato)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Pool starvation, queries disparadas no meio da serialização Jackson e travamento de API)
    - Parte 3: A Solução Moderna de Elite (spring.jpa.open-in-view=false, isolamento transacional estrito na camada @Service)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (O gargalo histórico do MySQL corporativo 10.243.1.27)

## 3. Concorrência Crítica e Mecanismos de Lock (Lost Updates, Otimista & Pessimista)
  ### 3.1 A Anatomia da Concorrência: O Fenômeno do Lost Update (Atualização Perdida)
    - Parte 1: O que é o conceito / Analogia Didática (Dois Editores de Texto simultâneos salvando por cima um do outro)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação Literal AlgaWorks 1598_EJPA_14_02: O conflito de Maria e João)
    - Parte 3: A Solução Moderna de Elite (Fundamentos matemáticos e os 4 níveis de isolamento ANSI SQL: Read Uncommitted até Serializable)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (fiscalizacao :8082 na concorrência de autuações e cadu :8081 em baixas de veículos)
  ### 3.2 Lock Otimista com @Version e Tratamento Elegante de OptimisticLockException
    - Parte 1: O que é o conceito / Analogia Didática (O Carimbo de Versão e o Selo de Cartório Não-Bloqueante)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Sobrescritas silenciosas de histórico sancionatório no MySQL da AGR)
    - Parte 3: A Solução Moderna de Elite (Código Java 21: @Version Long versao, interceptador REST com RFC 7807 409 Conflict e ETags HTTP)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Auto de Infração e Veículo no agrfiscalservice :8083)
  ### 3.3 Lock Pessimista (LockModeType.PESSIMISTIC_WRITE) em Recursos Escassos
    - Parte 1: O que é o conceito / Analogia Didática (A Cabine Telefônica Trancada por Dentro com Chave Exclusiva)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Numeração duplicada de autos fiscais, guias DARE colidentes e Deadlocks no banco)
    - Parte 3: A Solução Moderna de Elite (Código Java 21: SELECT ... FOR UPDATE via Spring Data JPA com timeout estrito de 3000ms)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (teatro-abc :8090 na reserva atômica de assentos numerados do Centro Oscar Niemeyer)

## 4. Evolução e Governança Estrutural de Banco com Flyway
  ### 4.1 O Perigo Mortal de ddl-auto=update / create-drop em Produção
    - Parte 1: O que é o conceito / Analogia Didática (Construir um prédio sem planta de engenharia, derrubando vigas no escuro)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Tabelas corrompidas em cluster, colunas órfãs e o caos dos dumps manuais no 10.243.1.27)
    - Parte 3: A Solução Moderna de Elite (spring.jpa.hibernate.ddl-auto=validate obrigatório em produção)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Paridade estrita entre Docker local de dev, homologação e produção)
  ### 4.2 Estrutura Canônica de Versionamento Flyway 10+: V1__, V2__, R__ e flyway_schema_history
    - Parte 1: O que é o conceito / Analogia Didática (O Livro de Registro Notarial com Páginas Numeradas e Carimbo Temporal)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Scripts rodados na mão via DBeaver gerando SQLException de coluna ausente em pleno deploy)
    - Parte 3: A Solução Moderna de Elite (Scripts SQL de migração imutáveis V1__, V2__, migrations repetíveis R__ para views e checksum CRC32)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Scripts completos de DDL do teatro-abc e do agrfiscalservice)

## 5. Guia Prático de Implementação & Checklist de Engenharia
  - Tabela comparativa consolidada: Padrões Legados AlgaWorks/AGR vs Padrões Modernos de Elite
  - Checklist de auditoria de código para PRs (Pull Requests) de persistência
```

---

## 4. Conteúdo Detalhado & Especificações por Seção

Abaixo está a dissecação exaustiva do conteúdo técnico, citações literais, blocos de código e vinculações que o agente autor deverá transpor para o documento final:

### Seção 1: JPA Puro vs Hibernate 6.5+ (Jakarta Persistence 3.1 & SQM)

#### 1.1 Especificação vs Implementação
* **Parte 1 (Analogia):** A analogia entre a **Constituição Federal / Normas ABNT** (a especificação Jakarta Persistence 3.1, que define interfaces como `EntityManager`, anotações como `@Entity`, `@Table`, `@Id`, sem conter uma única linha de código que execute no banco) e o **Código Operacional / Construtora de Engenharia** (o framework Hibernate 6.5+, que implementa os drivers JDBC, gerencia conexões, traduz queries e executa o dirty checking).
* **Parte 2 (A Dor Histórica):** O pesadelo da transição do namespace `javax.persistence` para `jakarta.persistence` decorrente da cessão do Java EE pela Oracle para a Eclipse Foundation (Jakarta EE 9 e 10). Conforme documentado na aula AlgaWorks `864_28.1. Migrando para o Spring Boot 3.txt`, bibliotecas legadas pararam de funcionar repentinamente, código antigo que importava classes do pacote proprietário `org.hibernate.Session` quebrou na migração, e sistemas estatais da AGR ficaram travados no Java 8 por receio da quebra de compatibilidade em massa.
* **Parte 3 (A Solução Moderna de Elite):** Código Java 21 moderno usando estritamente o namespace `jakarta.persistence.*`, com injeção padrão via `@PersistenceContext private EntityManager em;` ou via interfaces Spring Data JPA `JpaRepository`. Código demonstrando configuração tipada e ausência de dependência de classes proprietárias do Hibernate no código de aplicação de negócio.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `portalservice :8080` e `cadu :8081`, o código legado herdado do Portal 1 utilizava a classe proprietária `org.hibernate.Criteria` (removida no Hibernate 6) e `session.createSQLQuery()` com casts arcaicos. A modernização para Jakarta Persistence 3.1 com Spring Boot 3.3 restaura o desacoplamento arquitetural e viabiliza a execução sobre containers leves.

#### 1.2 O Motor Semantic Query Model (SQM) do Hibernate 6+
* **Parte 1 (Analogia):** A analogia com o compilador C2 da JVM: em vez de traduzir texto em instruções de máquina de forma literal e cega, o compilador constrói uma árvore sintática intermediária rica, analisa o fluxo de controle, elimina código morto e gera o código nativo mais otimizado possível. O SQM é o "C2" das consultas SQL do Hibernate 6.
* **Parte 2 (A Dor Histórica):** No Hibernate 5.x e versões anteriores ensinadas nos cursos tradicionais, o compilador de consultas HQL baseava-se em um parser Antlr v2 arcaico. Uma consulta HQL gerava diretamente uma AST orientada a strings. Quando o desenvolvedor tentava usar subqueries no SELECT, funções de data complexas ou joins semânticos em árvores polimórficas, o Hibernate 5 emitia SQLs gigantescos, cheios de joins redundantes e subselects desnecessários que explodiam o tempo de resposta no MySQL da AGR.
* **Parte 3 (A Solução Moderna de Elite):** Demonstração técnica da arquitetura do Hibernate 6:
  `JPQL / Criteria Query ➔ Semantic Query Model (SQM) ➔ SQL AST ➔ SQL String do Dialeto Específico (PostgreSQL / MySQL 8.4)`.
  Exemplo de código com JPQL moderno utilizando funções analíticas nativas (Window Functions: `ROW_NUMBER() OVER (PARTITION BY ...)`), subconsultas diretas e projeções aritméticas que antes exigiam SQL nativo.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `agrfiscalservice :8083`, para gerar o ranking de frotas mais autuadas por período, o legado executava SQL nativo com concatenação dinâmica de strings no `AutoInfracaoDAO` porque o Hibernate 5 não suportava funções de janela no HQL. Com o SQM do Hibernate 6, a consulta é 100% tipada em JPQL, segura contra SQL Injection e portável entre ambientes.

#### 1.3 Ciclo de Vida da Entidade & Dirty Checking Otimizado
* **Parte 1 (Analogia):** O crachá de acesso corporativo no edifício da AGR:
  - `Transient`: O visitante preenche o formulário na calçada (objeto recém-instanciado com `new`, vive apenas na Heap da JVM, o banco não sabe que ele existe).
  - `Managed`: O visitante recebe o crachá na portaria e passa pela catraca (associado ao `EntityManager` no Persistence Context L1; qualquer movimento dele no prédio é monitorado pelas câmeras).
  - `Detached`: O visitante sai do prédio e a catraca recolhe o crachá temporariamente (a transação encerrou; ele tem uma identidade/ID de banco, mas se trocar de camisa na rua, o sistema do prédio não percebe).
  - `Removed`: O visitante é escoltado para fora e seu registro de acesso é cancelado (`em.remove()`, o registro será deletado no próximo flush).
* **Parte 2 (A Dor Histórica):** O desespero de programadores que não entendem o estado `Managed` e enchem os métodos de serviço com chamadas redundantes a `repository.save(entidade)` para entidades que já estavam sob custódia do contexto de persistência. Pior: ao passar entidades no estado `Detached` para controllers e tentar acessar coleções tardias, o sistema cuspia em produção a infame `org.hibernate.LazyInitializationException: could not initialize proxy - no Session`.
* **Parte 3 (A Solução Moderna de Elite):** Código Java 21 executável demonstrando:
  - A transição entre os 4 estados.
  - A mecânica do **Dirty Checking**: como o Hibernate detecta mutações em propriedades de entidades no estado `Managed` e emite o `UPDATE` automaticamente na sincronização do `flush()`, sem necessidade de chamar `save()`.
  - A diferença crítica entre `em.flush()` (sincronização de comandos SQL pendentes com a conexão JDBC) e `transaction.commit()` (finalização atômica da transação no motor relacional).
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `cadastrounicoservice :8081`, o fluxo de homologação de vistoria veicular recebia o DTO, buscava a entidade `Veiculo` (estado `Managed`), alterava o status para `HOMOLOGADO` e, por desconhecimento, o desenvolvedor executava um `veiculoDAO.update(veiculo)` que recriava prepared statements manuais no MySQL legado, gerando concorrência desnecessária no pool de conexões.

---

### Seção 2: Mapeamentos Avançados e o Combate ao N+1

#### 2.1 A Armadilha do Eager Loading Default
* **Parte 1 (Analogia):** A analogia do delivery de supermercado: você pede 10 caixas de cereais. Em vez de colocar as 10 caixas em uma única van e trazer para sua casa em uma viagem, o entregador ansioso faz uma viagem para trazer a primeira caixa, outra viagem para trazer a segunda caixa... e ainda para na padaria do bairro para comprar pães e queijos que você nem pediu, porque no contrato dele dizia "sempre que buscar cereal, traga a padaria inteira junto" (carregamento ansioso em cascata).
* **Parte 2 (A Dor Histórica):** Citação literal da aula AlgaWorks `412_6.10. Entendendo o Eager Loading.txt`:
  > *"Uma única consulta de restaurante gerou um, dois, três, quatro, cinco, seis selects... Por que está fazendo o select de cozinha sendo que a gente não está precisando da cozinha? ... Tudo que termina com 'ToOne' usa a estratégia por padrão eager loading... ele vai buscar a cozinha relacionada a esse restaurante porque é um carregamento ansioso. Então, ah, eu não quero saber se o JPA falando, tá? Não quero saber se vai precisar ou não. Sou ansioso, sou ansioso, vou lá buscar, vai lá e busca a cozinha, tá? Essa é a configuração."*
  O desastre em produção: Em uma tabela com 5.000 veículos no CADU, um `veiculoRepository.findAll()` sem join fetch disparava 5.001 consultas SQL simultâneas ao MySQL `10.243.1.27`, derrubando o servidor de banco de dados e gerando *out of memory* na JVM do Tomcat.
* **Parte 3 (A Solução Moderna de Elite):**
  - **A Regra de Ouro Inegociável:** 100% dos relacionamentos `@ManyToOne` e `@OneToOne` DEVEM ser explicitamente configurados com `fetch = FetchType.LAZY`. O default da JPA (`FetchType.EAGER`) é um dos piores antipadrões de design da história da especificação Java.
  - Exemplo de código Java 21 com a anotação correta:
    ```java
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "empresa_id", nullable = false)
    private Empresa empresa;
    ```
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `cadastrounicoservice :8081`, a entidade `Veiculo` possui relações com `Empresa`, `ModeloVeiculo`, `Marca`, `Municipio` e `TipoCombustivel`. No legado, todas eram `EAGER`. Consultar 20 veículos na tela de consulta de frota gerava mais de 100 queries SQL. Com o `LAZY` estrito, o número cai para exatamente 1 query.

#### 2.2 As Armas de Elite: JOIN FETCH, @EntityGraph e Projeções DTO com Records
* **Parte 1 (Analogia):** O frete consolidado e o raio-X cirúrgico:
  - `JOIN FETCH`: Você avisa a transportadora para carregar no mesmo caminhão o produto principal e suas peças complementares em um único itinerário.
  - `@EntityGraph`: Uma planta arquitetural que diz à consulta básica: "nesta requisição específica, acione os holofotes sobre as salas A e B".
  - Projeções DTO com Records: Em vez de transportar o container inteiro com todos os móveis da fábrica (entidades pesadas gerenciadas pelo ORM), você envia um telegrama impresso contendo apenas o nome e o número de série das 3 colunas que o usuário solicitou na tela.
* **Parte 2 (A Dor Histórica):** A tentativa ingênua de resolver o N+1 colocando múltiplos `join fetch` de coleções simultâneas:
  `SELECT r FROM Restaurante r JOIN FETCH r.produtos JOIN FETCH r.formasPagamento`.
  Isso gera a temida `MultipleBagFetchException` do Hibernate ou cria um **Produto Cartesiano Explosivo**: se o restaurante tem 50 produtos e 10 formas de pagamento, a query retorna 500 linhas no ResultSet JDBC, alocando centenas de megabytes no Heap da JVM para montar um único objeto.
* **Parte 3 (A Solução Moderna de Elite):** O tripé de resolução definitiva com código Java 21 completo:
  1. **JPQL com `JOIN FETCH` cirúrgico:**
     ```java
     @Query("SELECT DISTINCT v FROM Veiculo v " +
            "JOIN FETCH v.empresa e " +
            "JOIN FETCH v.modelo m " +
            "WHERE e.id = :empresaId")
     List<Veiculo> buscarFrotaComDetalhes(@Param("empresaId") Long empresaId);
     ```
  2. **`@EntityGraph` Declarativo no Spring Data JPA:**
     ```java
     @EntityGraph(attributePaths = {"empresa", "modelo.marca"})
     Page<Veiculo> findByAtivoTrue(Pageable pageable);
     ```
  3. **Projeções DTO com Java 21 Records (Constructor Expression em JPQL):**
     Zero overhead de proxy, zero dirty checking, desempenho equivalente a JDBC puro:
     ```java
     public record VeiculoResumoDTO(
         Long id,
         String placa,
         String renavam,
         String razaoSocialEmpresa,
         String nomeModelo
     ) {}

     @Query("SELECT new com.agr.cadu.dto.VeiculoResumoDTO(v.id, v.placa, v.renavam, e.razaoSocial, m.nome) " +
            "FROM Veiculo v " +
            "JOIN v.empresa e " +
            "JOIN v.modelo m " +
            "WHERE v.ativo = true")
     List<VeiculoResumoDTO> listarResumoFrotaAtiva();
     ```
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `agrfiscalservice :8083`, o relatório consolidado de blitz que exibe os dados do Auto de Infração, nome do auditor, placa do veículo e artigo da lei infringido. A consulta que demorava 14 segundos utilizando DAOs legados roda em 85 milissegundos com DTO projection em Records.

#### 2.3 O Antipadrão Open Session In View (OSIV)
* **Parte 1 (Analogia):** A torneira aberta na cozinha do restaurante: O cliente pede um prato de comida. O garçom leva o prato até a mesa do cliente, mas deixa a torneira do reservatório central jorrando água aberta enquanto o cliente decide se vai comer a salada ou a sobremesa. Se 20 clientes chegarem ao restaurante ao mesmo tempo, a caixa d'água inteira seca e a cozinha inteira para. O OSIV é essa torneira aberta prendendo conexões do banco de dados na camada web.
* **Parte 2 (A Dor Histórica):** O Spring Boot mantém, por padrão de fábrica, a propriedade `spring.jpa.open-in-view=true`. Isso faz com que um filtro web (`OpenEntityManagerInViewFilter`) abra a sessão JPA e segure a conexão JDBC da pool (HikariCP) durante todo o ciclo de vida da requisição HTTP — desde o Controller até a serialização JSON pelo Jackson.
  - Se um cliente mobile numa rodovia em Goiás com sinal 3G oscilante demorar 10 segundos para baixar a resposta JSON da fiscalização, a conexão de banco fica bloqueada para aquele único usuário.
  - Sob uma carga de 50 requisições simultâneas, o pool padrão de 10 conexões do HikariCP esgota imediatamente:
    `java.sql.SQLTransientConnectionException: HikariPool-1 - Connection is not available, request timed out after 30000ms`.
  - A API inteira do órgão trava, e o pior: o desenvolvedor não percebe isso em ambiente local porque em localhost a latência de rede é 0ms e não há concorrência.
* **Parte 3 (A Solução Moderna de Elite):**
  - **Desativação Mandatória no `application.yml`:**
    ```yaml
    spring:
      jpa:
        open-in-view: false
    ```
  - **O Novo Paradigma:** A fronteira transacional é rigorosamente a camada `@Service` com `@Transactional(readOnly = true)`. Se o Controller ou o Serializer JSON tentar acessar um getter Lazy fora do serviço, o Hibernate lança imediatamente uma exceção, forçando o desenvolvedor a carregar os dados explicitamente via DTO ou `JOIN FETCH` na camada de persistência.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** O colapso frequente do MySQL corporativo `10.243.1.27:3306` da AGR ocorria justamente porque os 25 microsserviços rodavam com `open-in-view=true`. Quando servidores públicos abriam relatórios pesados no navegador, centenas de conexões ficavam presas em estado `Sleep` no MySQL, impedindo a lavratura de autos pelos policiais e auditores fiscais em campo.

---

### Seção 3: Concorrência Crítica e Mecanismos de Lock (Lost Updates, Otimista & Pessimista)

#### 3.1 A Anatomia da Concorrência e o Lost Update
* **Parte 1 (Analogia):** A lousa da sala de reunião: Duas pessoas entram na sala para atualizar o cronograma na lousa. Ambas olham para a data atual (10 de outubro). A primeira pessoa apaga a data e escreve "15 de outubro" e sai da sala. A segunda pessoa, que não viu a alteração porque estava digitando no celular com a foto antiga da lousa, sobe na cadeira, apaga "15 de outubro" e escreve "20 de outubro". A decisão da primeira pessoa foi completamente apagada e destruída sem deixar vestígios. Isso é o *Lost Update* (Atualização Perdida).
* **Parte 2 (A Dor Histórica):** Citação literal da aula AlgaWorks `1598_EJPA_14_02_Resolvendo_problemas_de_concorrência_com_Lock_Otimista.txt`:
  > *"Imagina aí no e-commerce, tem dois funcionários ali, o João e a Maria... os dois pegaram ali o produto de identificador igual a um, os dois pegaram ele para poder editar a descrição desse produto... abriram o browser, carregaram o produto ao mesmo tempo... A Maria vai demorar 1 segundo só... O João vai demorar 3 segundos... A Maria clica em salvar, comita e é jogada para o banco... Aí depois o João vai sobrescrever o trabalho da Maria... a Maria vai perder o trabalho que ela fez... Como que a gente garante isso? Colocando na entidade @Version private Integer versao... O Hibernate vai pensar: 'o João está querendo atualizar aqui um registro, mas a versão dele é zero e a que está no banco, que no caso a Maria atualizou, está na versão 1'... aí o Hibernate vai lançar uma exceção que é OptimisticLockException."*
* **Parte 3 (A Solução Moderna de Elite):** Os quatro níveis de isolamento ANSI SQL (Read Uncommitted, Read Committed, Repeatable Read e Serializable) e por que isolamento de transação de banco por si só NÃO resolve o problema de concorrência na web: porque as requisições HTTP são stateless e desconectadas! O usuário carrega a página no GET (transação 1 fecha) e só clica no POST/PUT 30 segundos depois (transação 2 abre). O controle de concorrência precisa viajar na camada de aplicação.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `cadastrounicoservice :8081`, quando dois analistas abriam simultaneamente o processo de cancelamento de cadastro de uma concessionária de ônibus: o analista A alterava o endereço e o analista B alterava a situação cadastral para "CASSADA". O último clique salvava, apagando o cancelamento da concessão e mantendo a empresa operando irregularmente no Estado de Goiás.

#### 3.2 Lock Otimista com `@Version` e Tratamento de Exceções
* **Parte 1 (Analogia):** O carimbo de versão com data e hora de protocolo: O documento recebe o carimbo "Versão 1". Se você quiser protocolar uma emenda, você precisa apresentar o documento com o carimbo "Versão 1". Se alguém já protocolou uma alteração antes de você, o documento oficial do cartório já está marcado como "Versão 2". O atendente do cartório recusa sua folha na hora: "Desculpe, seu documento de base está desatualizado; retire uma cópia nova da Versão 2 antes de propor mudanças".
* **Parte 2 (A Dor Histórica):** Sistemas que implementam `@Version` mas não tratam a exceção no backend. Quando ocorre a colisão, o Spring lança `ObjectOptimisticLockingFailureException`, que sobe sem tratamento, estoura um HTTP 500 feio com stack trace no console do navegador, e o usuário acha que o sistema quebrou, tentando clicar repetidamente e agravando a contenção.
* **Parte 3 (A Solução Moderna de Elite):**
  - Entidade mapeada com o campo canônico:
    ```java
    @Version
    @Column(name = "versao", nullable = false)
    private Long versao;
    ```
  - Como o Hibernate emite o SQL de atualização sob o capô:
    ```sql
    UPDATE tb_auto_infracao 
    SET valor_multa = ?, situacao = ?, versao = versao + 1 
    WHERE id = ? AND versao = ?;
    ```
    Se `rows affected == 0`, o Hibernate sabe instantaneamente que outro thread alterou o registro e lança `jakarta.persistence.OptimisticLockException`.
  - Tratamento global no `@RestControllerAdvice` retornando a especificação **RFC 7807 (ProblemDetail)** com status **HTTP 409 Conflict**:
    ```java
    @ExceptionHandler(ObjectOptimisticLockingFailureException.class)
    public ProblemDetail handleOptimisticLock(ObjectOptimisticLockingFailureException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.CONFLICT,
            "O registro foi modificado concorrentemente por outro usuário ou processo. Por favor, recarregue os dados mais recentes antes de tentar novamente."
        );
        problem.setTitle("Conflito de Concorrência Detectado");
        problem.setType(URI.create("https://api.agr.go.gov.br/erros/conflito-concorrencia"));
        problem.setProperty("timestamp", Instant.now());
        return problem;
    }
    ```
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No `agrfiscalservice :8083`, o Auto de Infração e o Termo de Remoção de Veículo (TRV) contêm `@Version private Long versao`. Se o auditor de campo alterar a descrição da penalidade no tablet enquanto o setor de apoio jurídico em Goiânia anexar uma decisão liminar no mesmo auto, a colisão é interceptada com elegância, informando ao auditor que os autos foram atualizados.

#### 3.3 Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`) em Recursos Escassos
* **Parte 1 (Analogia):** A tranca física da cabine de votação eleitoral ou da cabine telefônica: Não adianta usar carimbo de versão se o recurso não pode admitir refação. Em uma urna eleitoral ou no único assento da fileira A de um espetáculo teatral, você não pode deixar dois eleitores entrarem e depois dizer para um deles "desculpe, tente votar de novo". O primeiro que chega fecha a tranca física da porta por dentro; o segundo é forçado a esperar na fila até a liberação completa da cabine.
* **Parte 2 (A Dor Histórica):** O desastre da geração de números sequenciais de documentos fiscais e reserva de vagas. Em picos de blitz simultâneas nas rodovias ou no início da venda de ingressos do show de inauguração do Centro Cultural Oscar Niemeyer:
  - Dois threads liam o último número do Auto de Infração (`SELECT MAX(numero) FROM auto_infracao WHERE ano = 2026`). Ambos liam `141`.
  - Ambos somavam 1 em memória (`142`) e tentavam gravar.
  - Resultado: Erro de violação de constraint única (`DuplicateKeyException`) ou, pior, em bancos mal modelados sem chave única, dois autos oficiais emitidos com o mesmo número, gerando nulidade jurídica das autuações no Tribunal de Justiça de Goiás.
* **Parte 3 (A Solução Moderna de Elite):**
  - Repositório com `@Lock(LockModeType.PESSIMISTIC_WRITE)` e controle de timeout para prevenir deadlocks eternos:
    ```java
    public interface SequenciadorDocumentoRepository extends JpaRepository<SequenciadorDocumento, Long> {
        
        @Lock(LockModeType.PESSIMISTIC_WRITE)
        @QueryHints({
            @QueryHint(name = "jakarta.persistence.lock.timeout", value = "3000") // 3 segundos de timeout
        })
        @Query("SELECT s FROM SequenciadorDocumento s WHERE s.tipoDocumento = :tipo AND s.ano = :ano")
        Optional<SequenciadorDocumento> buscarParaAtualizacaoComLock(
            @Param("tipo") TipoDocumentoFiscal tipo, 
            @Param("ano") Integer ano
        );
    }
    ```
  - Mecânica do banco: O JPA traduz para `SELECT ... FOR UPDATE` no dialeto relacional.
  - Serviço de emissão atômica:
    ```java
    @Service
    public class GeradorNumeroAutoInfracaoService {

        private final SequenciadorDocumentoRepository sequenciadorRepository;

        @Transactional(isolation = Isolation.READ_COMMITTED)
        public String gerarProximoNumeroAuto(Integer ano) {
            SequenciadorDocumento sequenciador = sequenciadorRepository
                .buscarParaAtualizacaoComLock(TipoDocumentoFiscal.AUTO_INFRACAO, ano)
                .orElseThrow(() -> new IllegalStateException("Sequenciador não inicializado"));

            Long proximoNumero = sequenciador.incrementar();
            return String.format("%d/%06d", ano, proximoNumero);
        }
    }
    ```
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):**
  - **Teatro-ABC (`:8090`):** O caso clássico do Centro Cultural Oscar Niemeyer (Goiânia). 5.000 usuários tentando reservar 300 assentos de plateia no mesmo minuto. O endpoint `POST /api/v1/sessoes/{sessaoId}/reservas` adquire lock pessimista no `Assento` solicitado. Se outro cliente tentar o mesmo assento na mesma fração de segundo, sua transação fica enfileirada no banco ou recebe timeout amigável, garantindo zero *overbooking* (assentos duplicados).
  - **AGR `daredtoservice :8088`:** Emissão atômica do código de barras da Guia DARE junto à SEFAZ-GO, garantindo unicidade na numeração da guia arrecadatória estadual.

---

### Seção 4: Migrações e Versionamento de Banco de Dados com Flyway

#### 4.1 O Perigo Mortal de `ddl-auto=update` em Produção
* **Parte 1 (Analogia):** Construir um arranha-céu sem projeto de engenharia arquivado, deixando os pedreiros quebrarem paredes e emendarem tubulações no improviso toda vez que um novo morador se muda. Um dia, alguém derruba uma coluna mestra e o edifício desaba. O `hibernate.ddl-auto=update` é esse pedreiro cego alterando o banco no escuro.
* **Parte 2 (A Dor Histórica):** As falhas reais causadas pelo `ddl-auto=update`:
  1. **Corrupção em Clusters:** Quando o sistema roda em múltiplos containers (Kubernetes ou Docker Compose escalado), 3 instâncias sobem simultaneamente e todas tentam executar comandos DDL de `ALTER TABLE` concorrentes, travando as tabelas com metadata locks e abortando a inicialização das aplicações.
  2. **Acúmulo de Lixo Estrutural:** O Hibernate nunca apaga colunas ou tabelas que foram removidas do código Java para evitar perda de dados. Com o tempo, o banco de produção fica cheio de colunas zumbis, constraints órfãs e índices duplicados.
  3. **Alterações Destrutivas Silenciosas:** Uma simples mudança de tipo primitivo na entidade (ex: de `Long` para `String` ou renomeação de propriedade) pode fazer o Hibernate recriar colunas ou gerar falhas silenciosas de cast.
* **Parte 3 (A Solução Moderna de Elite):**
  - **A Norma Inviolável de Produção:**
    ```yaml
    spring:
      jpa:
        hibernate:
          ddl-auto: validate # Banido terminantemente o 'update' ou 'create-drop'!
    ```
    O Hibernate apenas **valida** se as entidades Java mapeadas são 100% compatíveis com as tabelas físicas já existentes. Se houver discrepância de tipos ou colunas ausentes, a JVM recusa-se a subir, impedindo falhas em runtime.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No ambiente corporativo da AGR, equipes antigas usavam scripts SQL executados manualmente via DBeaver no servidor MySQL compartilhado `10.243.1.27:3306`. Toda sexta-feira de deploy gerava incidentes graves porque alguém alterava o código Java e esquecia de rodar o script no banco de produção.

#### 4.2 Estrutura Canônica de Versionamento com Flyway 10+
* **Parte 1 (Analogia):** O livro-razão imutável de um cartório notarial: cada certidão é registrada em uma folha numerada sequencialmente (`V1`, `V2`, `V3`), assinada e carimbada com um selo criptográfico (checksum). Ninguém pode rasgar uma folha antiga, apagar o que foi escrito ou colar uma folha adulterada no meio do livro sem que o selo de segurança aponte a fraude.
* **Parte 2 (A Dor Histórica):** A falta de rastreabilidade do schema: Sem ferramenta de migração, era impossível reproduzir o banco de dados exato de produção na máquina do novo desenvolvedor que acabava de entrar na AGR. O novo servidor público demorava 3 dias apenas tentando rodar dumps de banco desatualizados cheios de erros de chave estrangeira.
* **Parte 3 (A Solução Moderna de Elite):**
  - Configuração do Flyway 10+ no Spring Boot 3.3:
    ```yaml
    spring:
      flyway:
        enabled: true
        locations: classpath:db/migration
        baseline-on-migrate: true
        baseline-version: 0
        validate-on-migrate: true
    ```
  - Estrutura de arquivos em `src/main/resources/db/migration/`:
    - `V1__criar_tabelas_iniciais_fiscalizacao.sql`
    - `V2__adicionar_coluna_versao_lock_otimista.sql`
    - `V3__criar_tabela_sequenciador_autos.sql`
    - `R__criar_view_analitica_autuacoes_mensais.sql` (migration repetível, executada sempre que o checksum do arquivo for alterado).
  - A tabela de governança `flyway_schema_history`: como ela valida o checksum de cada script e aborta imediatamente o boot se alguém alterar um caractere de um script `V` já aplicado.
  - Scripts SQL completos, executáveis e com tipagem estrita para PostgreSQL 16+ e MySQL 8.4+.
* **Parte 4 (Vínculo AGR-Docs / Teatro-ABC):** No projeto greenfield `teatro-abc :8090`, o Flyway gerencia desde o dia 1 a criação das tabelas `tb_espetaculo`, `tb_sala`, `tb_sessao`, `tb_assento` e `tb_reserva`, além de constraints de unicidade parciais que garantem que nenhum assento seja reservado duas vezes mesmo que a aplicação falhe.

---

## 5. Matriz de Rastreabilidade Cruzada do Módulo 03

Para garantir a integração total exigida no Milestone 6 (`README.md`), a tabela abaixo sintetiza a rastreabilidade cruzada entre as transcrições AlgaWorks, os microsserviços do AGR-Docs e as soluções modernas de elite:

| Eixo Temático | Aula Canônica AlgaWorks (Citação Literal) | Microsserviço Real AGR / Porta | Legado Real Auditado (A Dor) | Solução de Elite Moderna (Java 21 / Spring Boot 3.3+) |
| :--- | :--- | :--- | :--- | :--- |
| **SQM & JPA Puro** | `864_28.1` / `1361_EJPA_01_01` | `portalservice` (:8080) e `cadu` (:8081) | DAOs manuais com `session.createCriteria` e classes proprietárias do Hibernate; quebra do namespace `javax.*`. | Jakarta Persistence 3.1 puro, Hibernate 6.5+ Semantic Query Model (SQM) e dirty checking nativo. |
| **Eager Loading & N+1**| `412_6.10` (*"Uma única consulta gerou 6 selects..."*) | `cadu` (:8081 - Frotas) e `regular` (:8082 - Linhas) | `FetchType.EAGER` em cascata em `@ManyToOne` gerando 100+ selects ao listar 20 veículos no banco corporativo. | `FetchType.LAZY` obrigatório em 100% dos relacionamentos, `JOIN FETCH`, `@EntityGraph` e DTOs com Java 21 Records. |
| **Antipadrão OSIV** | Mapeamento transversal AlgaFood / Spring Boot 2.x | Todos os 25 microsserviços da AGR (:8080 a :8119) | `spring.jpa.open-in-view=true` segurando conexões JDBC até a serialização Jackson; travamento da pool HikariCP. | `open-in-view=false` com fronteiras transacionais estritas no `@Service` (`@Transactional(readOnly = true)`). |
| **Lock Otimista** | `1598_EJPA_14_02` (*Conflito de Maria e João*) | `fiscalizacao` (:8083) e `cadu` (:8081) | *Lost Updates* em processos regulatórios; sobrescrita cega de autos de infração e baixas de veículos. | `@Version private Long versao;` com interceptação global e resposta RFC 7807 (409 Conflict). |
| **Lock Pessimista** | `1602_EJPA_14_06` (*pessimistic_write*) | `teatro-abc` (:8090) e `daredtoservice` (:8088) | Duplicação de numeração de autos em blitz simultâneas e risco de overbooking em assentos de espetáculos. | `@Lock(LockModeType.PESSIMISTIC_WRITE)` emitindo `SELECT ... FOR UPDATE` com timeout estrito de 3000ms. |
| **Versionamento Flyway**| `460_9.1` a `465_9.6` (ESR Flyway) | Base de dados MySQL centralizada (`10.243.1.27:3306`) | Scripts SQL rodados na mão via DBeaver; `ddl-auto=update` corrompendo schemas em deploys com cluster. | `ddl-auto=validate` com Flyway 10+ gerenciando scripts versionados imutáveis (`V1__`, `V2__`) e repetíveis (`R__`). |

---

## 6. Diretrizes Técnicas de Redação para o Agente Autor

Ao redigir `/home/lan/dotfiles/templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md`, o agente autor DEVE seguir obrigatoriamente as diretrizes abaixo:

1. **Volume e Completude:** O documento não pode conter resumos preguiçosos ou seções truncadas. Cada subtópico deve ser redigido como uma masterclass detalhada, superando 800 linhas no total.
2. **Proibição Absoluta de Placeholders:**
   - NUNCA utilize `TODO`, `FIXME`, `[TBD]`, `implementar depois` ou similares.
   - NUNCA utilize reticências bare `...` isoladas dentro de blocos de código Java ou SQL. Todo código deve ter cabeçalho, imports necessários e corpo completo ou comentários semânticos explicativos (ex: `// Mapeamento das demais propriedades auditáveis`).
3. **Consistência de Nomenclatura das 4 Partes:**
   - Utilizar estritamente os títulos canônicos que satisfazem o `verify_docs_suite.py`:
     - `#### Parte 1: O que é o conceito / Analogia Didática`
     - `#### Parte 2: A Dor Histórica / O Desastre do Legado`
     - `#### Parte 3: A Solução Moderna de Elite`
     - `#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC`
4. **Verificação Imediata pós-criação:**
   - Após salvar o arquivo, executar no terminal:
     `python3 scripts/verify_docs_suite.py`
   - O teste deve reportar aprovação nos checks relativos ao Módulo 03 (`T1-FILE-03-P`, `T2-LEN-03-P`, `T2-PH-03-P`, `T2-ELLIP-03-P`, `T3-PART1-03-P` a `T3-PART4-03-P`, `T3-CONTRAST-03-P-1` a `T3-CONTRAST-03-P-4`).
