# Módulo 03: Persistência Relacional Avançada: JPA Puro, Hibernate 6.5+, Concorrência Crítica & Migrations com Flyway

---

## Sumário Executivo & Manifesto da Persistência de Elite

A persistência de dados em aplicações corporativas e governamentais de missão crítica é historicamente o componente mais incompreendido, mal utilizado e causador de incidentes graves em ambientes de produção. Durante anos, a indústria de desenvolvimento de software propagou a perigosa ilusão de que frameworks de Mapeamento Objeto-Relacional (ORM) operam como uma "extensão infinita e transparente da memória Heap da Máquina Virtual Java (JVM)". Desenvolvedores foram condicionados a acreditar que podiam manipular coleções de entidades, navegar por associações bidirecionais e acionar operações de persistência sem qualquer consideração sobre a física subjacente de entrada e saída (I/O) de banco de dados relacional.

A realidade física de um sistema corporativo de alto volume, contudo, é implacável:
1. **Conexões JDBC são Recursos Escassos e Caros:** Cada conexão com o banco de dados representa um processo ou thread dedicada no servidor de banco de dados, alocação de buffers de memória (como o `sort_buffer_size` e `join_buffer_size`), descritores de sockets TCP e overhead constante de rede. O pool de conexões (HikariCP) não possui capacidade infinita; em ambientes de alta concorrência, o esgotamento do pool (pool starvation) paralisa o cluster de aplicação em questão de segundos.
2. **Latência de Rede e Round-Trips:** Trafegar centenas de consultas SQL individuais pela rede para renderizar uma única tela ou payload JSON (o famigerado Problema do N+1) transforma uma operação que deveria durar 5 milissegundos em um pesadelo de 15 segundos de latência acumulada.
3. **Isolamento ACID e Concorrência Real:** Em sistemas web com milhares de usuários simultâneos acessando e modificando os mesmos registros sob uma arquitetura HTTP inerentemente stateless, os níveis de isolamento nativos do motor relacional (como *Read Committed* ou *Repeatable Read*) não impedem a perda catastrófica de dados por sobrescrita silenciosa (*Lost Updates*). Sem controle explícito de versionamento (*Lock Otimista*) ou bloqueios atômicos exclusivos (*Lock Pessimista*), a integridade dos dados governamentais e financeiros é completamente corrompida.
4. **Governança Estrutural de Schema:** O uso do gerador automático de tabelas `hibernate.hbm2ddl.auto=update` em produção é um dos maiores pecados de engenharia já concebidos. Ele cria esquemas inconsistentes, não suporta rollback, falha em ambientes de cluster com nós concorrentes e oculta a evolução histórica do banco de dados, demandando obrigatoriamente ferramentas de migração imutáveis e versionadas como o **Flyway 10+**.

No ecossistema da **Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos (AGR)** — formado por mais de 25 microsserviços reais em produção, incluindo o `portalservice` (`:8080`), o Cadastro Único Regulatório `cadastrounicoservice` (`:8081`), o Sistema de Gestão de Fiscalização e Autos de Infração `fiscalizacaoservice` / `agrfiscalservice` (`:8082` / `:8083`), o Módulo de Emissão de Guias DARE `daredtoservice` (`:8088`), a Gestão de Receitas `receitaservice` (`:8092`) e o banco de dados MySQL centralizado (`10.243.1.27:3306`) —, bem como na infraestrutura de alta densidade concorrente da bilhetagem do **Teatro-ABC** (`:8090`), a superação desses antipadrões é o divisor de águas entre o colapso operacional e a resiliência institucional.

Este documento consolida o guia definitivo de engenharia de persistência relacional. Cada conceito é dissecado através da **Quadrupleta Didática Canônica**:
- **Parte 1: O que é o conceito / Analogia Didática** (construindo a intuição física e conceitual imediata);
- **Parte 2: A Dor Histórica / O Desastre do Legado** (analisando o que quebrava em produção, integrando citações literais das transcrições das masterclasses da AlgaWorks no curso *Especialista JPA* - EJPA e *Especialista Spring REST* - ESR);
- **Parte 3: A Solução Moderna de Elite** (fornecendo implementações completas, tipadas, compiláveis e otimizadas em Java 21 LTS, Spring Data JPA e Hibernate 6.5+);
- **Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC** (ancorando a solução no código e na topologia de produção real do Estado de Goiás e do greenfield de eventos).

```
ARQUITETURA DE PERSISTÊNCIA DE ELITE (SPRING BOOT 3.3+ & HIBERNATE 6.5+)

 ┌────────────────────────────────────────────────────────────────────────┐
 │ CAMADA DE APLICAÇÃO / SERVIÇO (@Service)                                │
 │ - Fronteira Transacional Estrita: @Transactional(readOnly = true)       │
 │ - spring.jpa.open-in-view = false (HikariCP isolado de latência HTTP)   │
 └──────────────────┬─────────────────────────────────────────────────────┘
                    │
                    ▼ Invocação de Repositório Spring Data JPA
 ┌────────────────────────────────────────────────────────────────────────┐
 │ ENGINE DE PERSISTÊNCIA (HIBERNATE 6.5+ / JAKARTA PERSISTENCE 3.1)       │
 │ - Semantic Query Model (SQM) -> Compilação Tipada AST                  │
 │ - Dirty Checking Otimizado no Persistence Context L1                   │
 │ - FetchType.LAZY Estrito + Consultas com JOIN FETCH / @EntityGraph     │
 │ - Projeções Diretas via DTO Constructors (Java 21 Records)             │
 └──────────────────┬─────────────────────────────────────────────────────┘
                    │
                    ▼ Emissão de SQL Otimizado & Controle de Concorrência
 ┌────────────────────────────────────────────────────────────────────────┐
 │ BANCO DE DADOS RELACIONAL (POSTGRESQL 16+ / MYSQL 8.4+)                │
 │ - Controle de Lost Updates: @Version (Lock Otimista -> HTTP 409)       │
 │ - Contenção de Recursos Escassos: PESSIMISTIC_WRITE (SELECT FOR UPDATE)│
 │ - Evolução Estrutural Imutável: Flyway 10+ (V1__, V2__, R__)           │
 │ - spring.jpa.hibernate.ddl-auto = validate (Zero DDL em runtime)       │
 └────────────────────────────────────────────────────────────────────────┘
```

---

## 1. JPA Puro vs Hibernate 6.5+: Especificação Jakarta Persistence 3.1 & Otimizações de Engine

### Matriz Conceitual: JPA 2.x vs Jakarta Persistence 3.1 & Hibernate 6.5+

A persistência corporativa em Java sofreu uma evolução sísmica na última década. A tabela abaixo sintetiza a ruptura entre as abordagens arcaicas ensinadas nos cursos tradicionais e o padrão contemporâneo de engenharia:

| Dimensão de Engenharia | JPA 2.x / Hibernate 5.x Legado | Jakarta Persistence 3.1 & Hibernate 6.5+ Moderno |
| :--- | :--- | :--- |
| **Namespace Corporativo** | `javax.persistence.*` (propriedade histórica da Oracle Corporation). | `jakarta.persistence.*` (governança aberta pela Eclipse Foundation - Jakarta EE 10). |
| **Arquitetura de Compilação HQL/JPQL** | Parser Antlr v2 clássico gerando AST textual direta; fragilidade sintática e limitações de subqueries. | **Semantic Query Model (SQM)**; pipeline semântico com otimizações em nível de árvore lógica, suporte nativo a Window Functions e Common Table Expressions (CTEs). |
| **Mecanismo de Dirty Checking** | Inspeção profunda baseada em arrays reflexivos comparando o estado original snapshot com o estado corrente de cada campo de cada entidade gerenciada. | Dirty checking otimizado por bytecode enhancement ou verificação seletiva em SQM, minimizando varreduras completas no encerramento da transação. |
| **Tratamento de APIs Proprietárias** | Uso disseminado de classes internas (`org.hibernate.Session`, `org.hibernate.Criteria`, `Restrictions`). | Adoção estrita de contratos padronizados `jakarta.persistence.EntityManager` e Spring Data JPA Specifications, desacoplando o código de aplicação. |
| **Interoperabilidade com Recursos Modernos** | Focado em Java Beans clássicos mutáveis com anotações manuais. | Suporte nativo a Java 21 Records em projeções de construtor JPQL (`SELECT new MeuRecord(...)`) com alocação otimizada. |

---

### 1.1 Especificação (JPA / Jakarta Persistence 3.1) vs Implementação (Hibernate ORM 6.5+)

#### Parte 1: O que é o conceito / Analogia Didática
A distinção entre especificação e implementação pode ser perfeitamente compreendida através da analogia entre a **Constituição Federal / Normas Técnicas ABNT** e a **Construtora de Engenharia Civil**:
- A **especificação (Jakarta Persistence 3.1 / JPA)** é o livro de leis e normas técnicas. Ela define o vocabulário, os contratos e as interfaces: estabelece que deve existir uma interface chamada `EntityManager`, que uma anotação chamada `@Entity` identifica uma tabela relacional, que o método `persist()` agenda a inclusão de um registro e que o método `find()` localiza uma entidade pela chave primária. Contudo, a especificação é puramente abstrata: ela não contém uma única linha de código capaz de abrir um socket de rede, conectar em um servidor MySQL ou emitir comandos SQL.
- A **implementação (Hibernate ORM 6.5+)** é a empreiteira de engenharia operacional. É ela que implementa os milhares de métodos definidos pelas interfaces, gerencia os pools de prepared statements JDBC, traduz JPQL em dialetos de banco específicos, interpreta tipos primitivos para tipos SQL (como converter `java.time.Instant` em `TIMESTAMP WITH TIME ZONE`) e executa o dirty checking na memória.

Acoplar o código de negócio diretamente às classes proprietárias da construtora (Hibernate) destrói a portabilidade da arquitetura e viola o princípio da inversão de dependência. O desenvolvedor de elite programa voltado para as interfaces padronizadas da especificação `jakarta.persistence.*` e utiliza a injeção declarativa do Spring Data JPA.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Durante anos, sistemas corporativos acoplaram-se intimamente às classes internas do Hibernate 3, 4 e 5. Em vez de usar a padronizada `jakarta.persistence.EntityManager`, os desenvolvedores injetavam `org.hibernate.SessionFactory` ou desempacotavam a sessão com `em.unwrap(Session.class)`, utilizando a arcaica `org.hibernate.Criteria` para consultas dinâmicas.

O desastre explodiu com a cessão do Java EE pela Oracle para a Eclipse Foundation. Por questões de direitos de marca sobre a palavra "Java", a especificação foi renomeada para Jakarta EE, exigindo a mudança completa do namespace corporativo de `javax.*` para `jakarta.*` a partir do Jakarta EE 9 e consolidada no Jakarta EE 10. 

Conforme registrado na aula AlgaWorks `864_28.1. Migrando para o Spring Boot 3.txt`, a transição causou um choque generalizado na indústria:
> *"No Spring Boot 3, a gente tem uma mudança muito importante... o Java EE agora é Jakarta EE. Então todo aquele pacote javax.persistence, javax.validation, virou jakarta.persistence, jakarta.validation... Se você tiver qualquer biblioteca que ainda usa javax.*, ela não vai funcionar no Spring Boot 3. O Hibernate 6 foi totalmente reescrito..."* (`864_28.1`)

E na aula inaugural do curso *Especialista JPA* (EJPA), `1361_EJPA_01_01_Introducao_ao_JPA.txt`, destaca-se a razão de ser da especificação:
> *"O JPA é uma especificação, ou seja, é um conjunto de regras, interfaces e anotações que padronizam o mapeamento objeto-relacional no ecossistema Java. O Hibernate é o provedor, o motor que implementa o JPA... Quando a gente programa usando o JPA puro, a gente ganha a liberdade de não ficar amarrado a detalhes proprietários de uma única ferramenta."* (`1361_EJPA_01_01`)

**O Desastre em Produção na AGR:**
Nos sistemas pioneiros do Portal 1 da AGR, dezenas de classes de serviço utilizavam a `Criteria` legada do Hibernate 4. Quando a equipe tentou atualizar módulos satélites para o Spring Boot 3, o compilador Maven quebrou imediatamente com erros de símbolos inexistentes (`package org.hibernate.criterion does not exist`). Como as consultas dinâmicas de infrações haviam sido escritas acopladas a essas classes proprietárias que foram completamente eliminadas no Hibernate 6, a migração foi abortada e os serviços permaneceram presos no Java 8 durante anos, acumulando vulnerabilidades de segurança e impedindo o uso de contêineres modernos.

#### Parte 3: A Solução Moderna de Elite
A arquitetura moderna de persistência adota estritamente o namespace `jakarta.persistence.*`, combinando a elegância tipada do Spring Data JPA com o poder do `EntityManager` puro quando for necessário controle granular de persistência:

```java
package br.gov.go.agr.cadu.infrastructure.persistence;

import br.gov.go.agr.cadu.domain.model.Empresa;
import br.gov.go.agr.cadu.domain.model.StatusHomologacao;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * Repositório Canônico com Jakarta Persistence 3.1 puro.
 * Demonstra o desacoplamento de classes proprietárias do Hibernate.
 */
@Repository
@Transactional(readOnly = true)
public class EmpresaPersistencePortImpl {

    @PersistenceContext
    private EntityManager entityManager;

    public Optional<Empresa> buscarPorId(Long id) {
        Objects.requireNonNull(id, "O identificador da empresa não pode ser nulo");
        Empresa empresa = entityManager.find(Empresa.class, id);
        return Optional.ofNullable(empresa);
    }

    public List<Empresa> listarPorStatus(StatusHomologacao status) {
        Objects.requireNonNull(status, "O status de homologação é obrigatório");
        
        TypedQuery<Empresa> query = entityManager.createQuery(
            "SELECT e FROM Empresa e WHERE e.statusHomologacao = :status ORDER BY e.razaoSocial ASC",
            Empresa.class
        );
        query.setParameter("status", status);
        return query.getResultList();
    }

    @Transactional
    public Empresa salvar(Empresa empresa) {
        Objects.requireNonNull(empresa, "A entidade empresa não pode ser nula");
        if (empresa.getId() == null) {
            entityManager.persist(empresa);
            return empresa;
        } else {
            return entityManager.merge(empresa);
        }
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `portalservice` (`:8080`) e no `cadastrounicoservice` (`:8081`), o código legado herdado continha métodos que invocavam `session.createSQLQuery()` com casts manuais para arrays de objetos (`Object[]`), gerando falhas em runtime sempre que uma coluna do MySQL era alterada. Ao refatorar para o padrão Jakarta Persistence 3.1 com Spring Boot 3.3, os contratos tornaram-se 100% tipados, viabilizando a execução idêntica tanto no ambiente local com contêineres Docker Testcontainers quanto no MySQL compartilhado de homologação.

---

### 1.2 O Motor Semantic Query Model (SQM) do Hibernate 6+ e a Física da Compilação de Consultas

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o compilador C2 HotSpot da Máquina Virtual Java: quando ele compila código Java em instruções de máquina x86-64, ele não se limita a traduzir palavra por palavra; ele constrói um grafo intermediário de controle de fluxo, elimina código morto, desmembra laços redundantes e gera o código de máquina mais curto e otimizado possível para aquele processador específico.

O **Semantic Query Model (SQM)** é exatamente o "compilador C2" de consultas SQL do Hibernate 6+. No Hibernate clássico (versões 3, 4 e 5), as consultas HQL ou JPQL eram analisadas por um parser textual primitivo que gerava diretamente uma Abstract Syntax Tree (AST) baseada em strings. O Hibernate 6 redesenhou completamente seu núcleo interno: agora, qualquer consulta (seja ela expressa em JPQL ou na Criteria API) é primeiramente traduzida para uma representação semântica intermediária rica chamada **SQM**. O SQM valida tipos, infere contextos semânticos e otimiza a árvore lógica. Somente após essa fase semântica, o SQM é traduzido para uma **SQL AST**, que por sua vez gera a string SQL final especializada no dialeto exato do banco de dados (PostgreSQL 16, MySQL 8.4 ou Oracle 23ai).

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Hibernate 5.x, a fragilidade da AST de consultas produzia aberrações em produção:
1. **Incapacidade de Processar Subqueries Complexas:** Se o desenvolvedor tentasse realizar uma subconsulta na cláusula `SELECT` do HQL ou aplicar funções analíticas modernas (como `ROW_NUMBER()` ou `DENSE_RANK()`), o parser do Hibernate 5 abortava com erros de sintaxe ilegíveis, forçando as equipes a abandonarem o ORM e recorrerem a SQL nativo concatenado no Java.
2. **Explosão de Joins Redundantes:** Ao navegar por relacionamentos em múltiplos critérios de busca, o compilador antigo gerava cláusulas `LEFT OUTER JOIN` repetidas para a mesma tabela física, multiplicando desnecessariamente o custo de processamento do otimizador de consultas do banco.
3. **Falta de Padronização de Tipos em Projeções:** Projeções que envolviam operações aritméticas ou conversões de data frequentemente retornavam tipos inconsistentes (ex: `BigInteger` em um banco e `BigDecimal` em outro), causando falhas de `ClassCastException` quando o sistema era migrado de ambiente.

#### Parte 3: A Solução Moderna de Elite
Graças ao SQM do Hibernate 6.5+, consultas JPQL modernas suportam nativamente recursos que antes demandavam SQL proprietário, incluindo funções analíticas de janela (Window Functions), cláusulas de agrupamento avançadas e subconsultas semânticas:

```java
package br.gov.go.agr.fiscais.infrastructure.persistence;

import br.gov.go.agr.fiscais.domain.dto.RankingFiscalizacaoDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

/**
 * Consulta Analítica Avançada executada sobre o compilador SQM do Hibernate 6.5+.
 * Demonstração do uso de Window Functions e projeção DTO tipada diretamente em JPQL.
 */
@Repository
@Transactional(readOnly = true)
public class RelatorioFiscalizacaoSqmRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public List<RankingFiscalizacaoDTO> gerarRankingAutuacoesPorRegiao(LocalDate dataInicio, LocalDate dataFim) {
        String jpql = "SELECT new br.gov.go.agr.fiscais.domain.dto.RankingFiscalizacaoDTO(" +
                      "    ai.regiaoFiscal.nome, " +
                      "    COUNT(ai.id), " +
                      "    SUM(ai.valorMulta), " +
                      "    ROW_NUMBER() OVER (ORDER BY COUNT(ai.id) DESC) " +
                      ") " +
                      "FROM AutoInfracao ai " +
                      "WHERE ai.dataLavratura BETWEEN :dataInicio AND :dataFim " +
                      "  AND ai.status = br.gov.go.agr.fiscais.domain.model.StatusAuto.HOMOLOGADO " +
                      "GROUP BY ai.regiaoFiscal.nome " +
                      "ORDER BY COUNT(ai.id) DESC";

        return entityManager.createQuery(jpql, RankingFiscalizacaoDTO.class)
            .setParameter("dataInicio", dataInicio)
            .setParameter("dataFim", dataFim)
            .setMaxResults(10)
            .getResultList();
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `agrfiscalservice` (`:8083`), para gerar o relatório semestral de blitz rodoviária com a lista das 10 empresas de ônibus com maior reincidência de infrações, a classe legada `AutoInfracaoDAO` concatenava manualmente strings SQL e abria um `PreparedStatement` JDBC nativo, pois o Hibernate 5 não conseguia compilar a ordenação por `ROW_NUMBER()`. Com a adoção do Hibernate 6.5+ sobre Spring Boot 3.3, a consulta foi reescrita em JPQL puro tipado, protegida contra SQL Injection pelo motor SQM e com performance idêntica ao JDBC bruto.

---

### 1.3 O Ciclo de Vida da Entidade (Transient, Managed, Detached, Removed) e Dirty Checking Otimizado

#### Parte 1: O que é o conceito / Analogia Didática
O ciclo de vida de uma entidade JPA dentro do **Persistence Context L1** pode ser comparado ao protocolo de segurança de crachás de visitantes na sede administrativa da AGR em Goiânia:
- **`Transient` (Novo / Não Gerenciado):** O cidadão está na calçada preenchendo a ficha de cadastro com uma caneta. Ele é um objeto recém-instanciado na memória Heap da JVM através de `new Veiculo()`. O banco de dados não tem ideia de que ele existe, e o `EntityManager` não possui nenhum registro dele. Se a aplicação encerrar, ele é simplesmente descartado pelo Garbage Collector.
- **`Managed` (Sob Custódia / Gerenciado):** O visitante entrega o formulário na recepção, recebe um crachá biométrico numerado e atravessa a catraca da portaria. A entidade entrou no estado `Managed` (via `em.persist()` ou carregamento por `find()`). Ela agora reside dentro do **Contexto de Persistência L1**. Qualquer alteração em seus atributos físicos (mudar o crachá de bolso, trocar de camisa) é monitorada continuamente pelo sistema de vigilância (*Dirty Checking*). Não é necessário pedir autorização a cada passo: no momento em que ele for embora pela catraca (*flush/commit*), o sistema atualiza automaticamente seu registro no banco de dados.
- **`Detached` (Desconectado):** O visitante devolve o crachá temporariamente e sai do edifício para almoçar em um restaurante do Setor Sul. A transação foi encerrada e o `EntityManager` foi fechado. Ele ainda possui um documento de identidade válido (`@Id` preenchido), mas as câmeras do edifício já não o monitoram. Se ele mudar de endereço na rua, o banco de dados da AGR não saberá, a menos que ele retorne pela portaria e realize um novo procedimento de entrada (`em.merge()`).
- **`Removed` (Marcado para Exclusão):** O crachá do visitante é recolhido com ordem de revogação de credencial (`em.remove()`). O registro ainda existe temporariamente na memória, mas no próximo ciclo de sincronização com o banco de dados (*flush*), o comando `DELETE` correspondente será disparado.

```
MÁQUINA DE ESTADOS DO CICLO DE VIDA DA ENTIDADE JPA

      ┌───────────┐
      │ TRANSIENT │ (Objeto Java puro instanciado com new)
      └─────┬─────┘
            │
            │ em.persist(e)
            ▼
      ┌───────────┐  em.detach(e) / close()   ┌──────────┐
      │  MANAGED  │ ────────────────────────> │ DETACHED │
      └─────┬─────┘ <──────────────────────── └──────────┘
            │              em.merge(e)
            │
            │ em.remove(e)
            ▼
      ┌───────────┐
      │  REMOVED  │ (Agendado para comando SQL DELETE no flush)
      └───────────┘
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
O desconhecimento do ciclo de vida das entidades gera dois dos maiores desastres de produção em aplicações corporativas:
1. **O Vício das Chamadas Inúteis de `repository.save()`:** Desenvolvedores que não compreendem o estado `Managed` enchem métodos de serviço com chamadas manuais repetitivas a `empresaRepository.save(empresa)`. Quando uma entidade é carregada dentro de um método anotado com `@Transactional`, ela **já está no estado Managed**. O mecanismo de *Dirty Checking* do Hibernate já monitora o objeto. Invocar `save()` em uma entidade gerenciada adiciona sobrecarga inútil de validação interna e revela falta de maturidade de engenharia.
2. **A Infame `LazyInitializationException` em Entidades `Detached`:** Quando uma entidade no estado `Detached` é devolvida para as camadas superiores (Controller ou Serializador Jackson) e o código tenta acessar uma propriedade preguiçosa (Lazy) fora de uma transação ativa, o proxy do Hibernate intercepta a chamada, descobre que a sessão original de banco já foi fechada e estoura o infame erro em produção:
   `org.hibernate.LazyInitializationException: could not initialize proxy [br.gov.go.agr.cadu.domain.model.Empresa#142] - no Session`.

#### Parte 3: A Solução Moderna de Elite
A engenharia de elite aproveita a transparência do estado `Managed` e o **Dirty Checking otimizado** do Hibernate 6.5+, que compara mutações de forma cirúrgica no encerramento da transação sem necessidade de chamadas redundantes a métodos de gravação:

```java
package br.gov.go.agr.cadu.application.service;

import br.gov.go.agr.cadu.domain.model.Empresa;
import br.gov.go.agr.cadu.domain.model.StatusHomologacao;
import br.gov.go.agr.cadu.domain.repository.EmpresaRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Objects;

/**
 * Serviço de Negócio demonstrando o poder do estado Managed e Dirty Checking.
 * Note a completa ausência de chamadas a repository.save() na atualização.
 */
@Service
public class HomologacaoEmpresaService {

    private final EmpresaRepository empresaRepository;

    public HomologacaoEmpresaService(EmpresaRepository empresaRepository) {
        this.empresaRepository = empresaRepository;
    }

    @Transactional
    public void homologarCadastroEmpresa(Long empresaId, String justificativaTecnica, String auditorCpf) {
        Objects.requireNonNull(empresaId, "ID da empresa é obrigatório");
        Objects.requireNonNull(justificativaTecnica, "Justificativa técnica é obrigatória");

        // 1. Carregamento: a entidade entra imediatamente no estado MANAGED no Contexto de Persistência L1
        Empresa empresa = empresaRepository.findById(empresaId)
            .orElseThrow(() -> new EntityNotFoundException("Empresa não localizada para o ID: " + empresaId));

        // 2. Mutações de Negócio: aplicadas diretamente nos atributos da entidade gerenciada
        empresa.setStatusHomologacao(StatusHomologacao.HOMOLOGADO);
        empresa.setDataHomologacao(Instant.now());
        empresa.setAuditorHomologadorCpf(auditorCpf);
        empresa.setParecerTecnico(justificativaTecnica);

        // 3. Fim do Método: O Spring encerra a transação com commit. 
        // O Hibernate aciona automaticamente o Dirty Checking, detecta as mutações e emite:
        // UPDATE tb_empresa SET status_homologacao = ?, data_homologacao = ?, ... WHERE id = ?;
        // ZERO necessidade de invocar empresaRepository.save(empresa)!
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `cadastrounicoservice` (`:8081`), o fluxo de vistoria veicular recebia a solicitação de renovação de alvará de fretamento. O desenvolvedor buscava a entidade `Veiculo` no banco, alterava o status para `VISTORIADO_APROVADO` e, por desconhecer a mecânica de estados, executava `veiculoRepository.save(veiculo)`. Sob o capô do Spring Data JPA, invocar `save()` em uma entidade existente acionava `em.merge()`, forçando o Hibernate a realizar cópias desnecessárias de propriedades no contexto L1. A remoção dessas invocações espúrias reduziu a alocação de objetos transitórios no Heap em 22% nas operações de frota da AGR.

---

## 2. Mapeamentos Avançados e o Extermínio Definitivo do Problema N+1

### Matriz de Estratégias: Eager Loading vs Lazy Loading com JOIN FETCH / EntityGraph & Projeções DTO

O combate à sobrecarga de consultas no banco de dados exige domínio sobre como e quando os dados são transferidos do motor relacional para a memória da JVM:

| Estratégia de Mapeamento / Busca | Custo de I/O em Produção | Risco de N+1 | Cenário Recomendado |
| :--- | :--- | :--- | :--- |
| **`FetchType.EAGER` Padrão JPA** | Catastrófico: emite consultas adicionais em cascata para cada relação `ToOne` sem consentimento do desenvolvedor. | **Garantido (100% de risco)** em listagens ou buscas paginadas. | **Terminantemente banido** em qualquer sistema de alta performance. |
| **`FetchType.LAZY` Cirúrgico** | Ótimo: busca apenas a entidade solicitada, instanciando proxies bytecode leves para as associações. | Zero por si só, mas pode gerar N+1 se os proxies forem acessados tardiamente em loops. | **Obrigatório como configuração padrão** em 100% dos relacionamentos `@ManyToOne`, `@OneToOne` e `@OneToMany`. |
| **`JOIN FETCH` em JPQL** | Excelente: combina as tabelas no mesmo comando SQL através de `INNER JOIN` ou `LEFT JOIN`, trazendo todos os dados em uma única viagem de rede. | **Zero**. Elimina completamente o N+1 para o caso de uso específico. | Operações de escrita ou leitura completa onde a entidade e suas associações precisam ser alteradas em conjunto. |
| **`@EntityGraph` Declarativo** | Excelente: instrui o motor JPA a aplicar carregamento antecipado dinâmico em endpoints específicos sem reescrever queries JPQL. | **Zero**. Substitui o fetch plan em runtime. | Consultas paginadas no Spring Data JPA (`Page<T>`) onde `JOIN FETCH` manual conflitaria com a query de contagem de páginas. |
| **Projeções DTO com Java 21 Records** | Performance Máxima (Equivalente a JDBC puro): lê unicamente as colunas estritamente necessárias diretamente no ResultSet. | **Zero absoluto**. Não instancia entidades gerenciadas nem cria proxies de ORM. | 90% das telas, grids, relatórios analíticos e payloads de leitura de APIs REST. |

---

### 2.1 A Armadilha do Eager Loading Default em @ManyToOne e @OneToOne

#### Parte 1: O que é o conceito / Analogia Didática
A analogia do delivery de materiais de escritório ilustra com precisão a tragédia do *Eager Loading* (Carregamento Ansioso):
Imagine que a Diretoria da AGR solicita a um estagiário: *"Vá até o almoxarifado central e traga uma caixa de canetas esferográficas"*. O estagiário ansioso vai até o almoxarifado, pega a caixa de canetas, mas observa que no manual dele diz: *"Toda caixa de caneta pertence a um lote de escritório; todo lote pertence a um galpão de patrimônio; e todo galpão possui um catálogo de 5.000 itens cadastrados"*. Em vez de trazer apenas a caixa de caneta solicitada, o estagiário contrata três caminhões de mudança e transporta o galpão inteiro com milhares de caixas para dentro da sala da diretoria.

O **`FetchType.EAGER`** da especificação JPA é esse comportamento destrutivo: ao carregar um registro de uma tabela, ele se considera obrigado a trazer imediatamente todas as tabelas relacionadas que possuem associações de cardinalidade única (`@ManyToOne` e `@OneToOne`), quer a sua lógica de negócio precise delas ou não.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A especificação Java Persistence Architecture definiu, em uma de suas decisões de design mais desastrosas, que os relacionamentos `@ManyToOne` e `@OneToOne` possuem por padrão a estratégia `FetchType.EAGER`. 

Esse comportamento foi dissecado de forma cirúrgica pelo instrutor Thiago na masterclass da AlgaWorks no curso *Especialista Spring REST* (ESR), na aula `412_6.10. Entendendo o Eager Loading.txt`:
> *"Uma única consulta de restaurante gerou um, dois, três, quatro, cinco, seis selects... Por que está fazendo o select de cozinha sendo que a gente não está precisando da cozinha? ... Tudo que termina com 'ToOne' usa a estratégia por padrão eager loading... ele vai buscar a cozinha relacionada a esse restaurante porque é um carregamento ansioso. Então, ah, eu não quero saber se o JPA falando, tá? Não quero saber se vai precisar ou não. Sou ansioso, sou ansioso, vou lá buscar, vai lá e busca a cozinha, tá? Essa é a configuração."* (`412_6.10`)

**O Desastre em Produção na Base Compartilhada da AGR (`10.243.1.27:3306`):**
No `cadastrounicoservice` (`:8081`), a entidade `Veiculo` possuía cinco relacionamentos `@ManyToOne` com valores default da JPA: `Empresa`, `ModeloVeiculo`, `Marca`, `MunicipioEmplacamento` e `TipoCombustivel`. 
Quando a tela de listagem de frota de permissionários executava um simples:
```java
List<Veiculo> veiculos = veiculoRepository.findAll();
```
O banco de dados recebia inicialmente uma consulta para trazer 1.000 veículos. Logo em seguida, para cada um dos 1.000 veículos retornados, o Hibernate emitia 5 consultas adicionais para resolver as relações EAGER. Em uma única requisição HTTP, a aplicação disparava **5.001 consultas SQL simultâneas** contra o servidor MySQL corporativo. As consequências eram imediatas:
- A CPU do servidor de banco em `10.243.1.27` atingia 100% de utilização instantaneamente;
- O pool de conexões de todos os outros 24 microsserviços da AGR esgotava;
- A JVM do microsserviço que disparou a busca alocava centenas de megabytes de entidades em memória, desencadeando pausas de *Stop-the-World* do Garbage Collector e quedas por *OutOfMemoryError*.

#### Parte 3: A Solução Moderna de Elite
A **Regra de Ouro Inegociável da Engenharia de Persistência** dita: **100% dos relacionamentos em entidades JPA DEVEM declarar explicitamente `fetch = FetchType.LAZY`**. O `FetchType.EAGER` deve ser tratado como um defeito gravíssimo de arquitetura em qualquer revisão de código (Pull Request):

```java
package br.gov.go.agr.cadu.domain.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Objects;

/**
 * Entidade Veículo Mapeada com Rigor Arquitetural.
 * Zero tolerância ao Eager Loading: todas as associações configuradas com FetchType.LAZY.
 */
@Entity
@Table(name = "tb_veiculo")
public class Veiculo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "placa", nullable = false, length = 8, unique = true)
    private String placa;

    @Column(name = "renavam", nullable = false, length = 11, unique = true)
    private String renavam;

    @Column(name = "ano_fabricacao", nullable = false)
    private Integer anoFabricacao;

    // REGRA DE OURO: FetchType.LAZY explícito em TODAS as relações ToOne
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "empresa_id", nullable = false)
    private Empresa empresa;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "modelo_id", nullable = false)
    private ModeloVeiculo modelo;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "municipio_id", nullable = false)
    private Municipio municipio;

    @Version
    @Column(name = "versao", nullable = false)
    private Long versao;

    public Veiculo() {}

    public Long getId() { return id; }
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getRenavam() { return renavam; }
    public void setRenavam(String renavam) { this.renavam = renavam; }
    public Integer getAnoFabricacao() { return anoFabricacao; }
    public void setAnoFabricacao(Integer anoFabricacao) { this.anoFabricacao = anoFabricacao; }
    public Empresa getEmpresa() { return empresa; }
    public void setEmpresa(Empresa empresa) { this.empresa = empresa; }
    public ModeloVeiculo getModelo() { return modelo; }
    public void setModelo(ModeloVeiculo modelo) { this.modelo = modelo; }
    public Municipio getMunicipio() { return municipio; }
    public void setMunicipio(Municipio municipio) { this.municipio = municipio; }
    public Long getVersao() { return versao; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Veiculo veiculo)) return false;
        return Objects.equals(getId(), veiculo.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId());
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `cadastrounicoservice` (`:8081`), a conversão de todos os relacionamentos `@ManyToOne` da entidade `Veiculo` para `FetchType.LAZY` eliminou instantaneamente mais de 4.000 consultas desnecessárias que eram emitidas no carregamento de lotes de auditoria. No greenfield `teatro-abc` (`:8090`), a entidade `Assento` possui relacionamento `@ManyToOne(fetch = FetchType.LAZY)` com `Sessao` e `SetorPlateia`. Ao renderizar o mapa interativo de 300 assentos de uma sala no Centro Cultural Oscar Niemeyer, a aplicação carrega a listagem em uma única instrução SQL enxuta, sem varrer os espetáculos e contratos vinculados.

---

### 2.2 As Armas de Elite contra o N+1: JOIN FETCH, @EntityGraph Declarativo e Projeções DTO com Java 21 Records

#### Parte 1: O que é o conceito / Analogia Didática
Configurar associações como `FetchType.LAZY` é a primeira linha de defesa contra o N+1, mas não resolve o cenário em que o caso de uso **realmente necessita** dos dados relacionados. Se você tem 100 veículos e precisa iterar sobre cada um exibindo o nome de sua empresa proprietária, acessar `veiculo.getEmpresa().getRazaoSocial()` dentro de um laço de repetição fará o proxy do Hibernate disparar 100 consultas individuais adicionais — reintroduzindo o problema do N+1.

Para trazer os dados complementares com eficiência cirúrgica, a engenharia dispõe de três armas de elite:
1. **`JOIN FETCH` em JPQL:** É o transporte rodoviário em comboio único. Em vez de enviar uma van para buscar cada passageiro, uma única carreta frigorífica consolidada é despachada para o banco, trazendo a entidade pai e suas associações filhas em um único itinerário de rede via `INNER JOIN` relacional.
2. **`@EntityGraph` Declarativo:** É uma planta arquitetural dinâmica. Ele permite dizer à consulta básica do Spring Data JPA: *"Para esta requisição de API específica, acenda os holofotes e traga carregados em um único JOIN os atributos X e Y, ignorando temporariamente o modo LAZY desses campos sem que seja preciso duplicar métodos no repositório"*.
3. **Projeções DTO com Java 21 Records:** É a transmissão expressa via telegrama cifrado. Em vez de carregar entidades JPA completas para dentro do contexto gerenciado L1 (com todo o peso de proxies, dirty checking e estado de persistência), o banco de dados projeta apenas as 4 colunas estritamente necessárias diretamente na instanciação de um Java Record imutável.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Quando desenvolvedores descobriam o `JOIN FETCH`, frequentemente tentavam resolver todos os relacionamentos em uma única consulta descontrolada:
```java
// ERRO CLÁSSICO DE ARQUITETURA: Produto cartesiano explosivo!
@Query("SELECT DISTINCT r FROM Restaurante r " +
       "JOIN FETCH r.produtos " +
       "JOIN FETCH r.formasPagamento")
List<Restaurante> buscarTodosComTudo();
```
Essa abordagem produz o temido **Produto Cartesiano Explosivo**: se um restaurante tem 100 produtos cadastrados e aceita 10 formas de pagamento, a junção relacional das tabelas resulta em `100 * 10 = 1.000` linhas retornadas pelo ResultSet do JDBC para um único restaurante! 
O Hibernate 5 reagia a isso lançando a infame exceção:
`org.hibernate.loader.MultipleBagFetchException: cannot simultaneously fetch multiple bags`.
Para contornar o erro de compilação, desenvolvedores convertiam coleções `List` em `Set`, mascarando o problema e forçando a JVM a processar gigabytes de dados redundantes de rede, derrubando o gateway da AGR.

#### Parte 3: A Solução Moderna de Elite
A solução de elite combina o uso adequado de cada uma das três ferramentas:

```java
package br.gov.go.agr.cadu.domain.repository;

import br.gov.go.agr.cadu.domain.dto.VeiculoResumoDTO;
import br.gov.go.agr.cadu.domain.model.Veiculo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VeiculoRepository extends JpaRepository<Veiculo, Long> {

    // ARMA 1: JOIN FETCH cirúrgico em JPQL para carregar agregados específicos em 1 única query SQL
    @Query("SELECT DISTINCT v FROM Veiculo v " +
           "JOIN FETCH v.empresa e " +
           "JOIN FETCH v.modelo m " +
           "JOIN FETCH m.marca " +
           "WHERE e.id = :empresaId " +
           "ORDER BY v.placa ASC")
    List<Veiculo> buscarFrotaCompletaPorEmpresa(@Param("empresaId") Long empresaId);

    // ARMA 2: @EntityGraph declarativo perfeitamente compatível com paginação do Spring Data JPA
    @EntityGraph(attributePaths = {"empresa", "modelo.marca", "municipio"})
    Page<Veiculo> findAllBy(Pageable pageable);

    // ARMA 3: Projeção DTO direta com Java 21 Record (Zero overhead de ORM, máxima velocidade de I/O)
    @Query("SELECT new br.gov.go.agr.cadu.domain.dto.VeiculoResumoDTO(" +
           "    v.id, " +
           "    v.placa, " +
           "    v.renavam, " +
           "    e.razaoSocial, " +
           "    m.nome, " +
           "    mun.nome " +
           ") " +
           "FROM Veiculo v " +
           "JOIN v.empresa e " +
           "JOIN v.modelo m " +
           "JOIN v.municipio mun " +
           "WHERE e.statusHomologacao = br.gov.go.agr.cadu.domain.model.StatusHomologacao.HOMOLOGADO " +
           "ORDER BY v.placa ASC")
    List<VeiculoResumoDTO> listarResumoOperacional();
}
```

O DTO correspondente implementado como um Java 21 Record puro e transparente:

```java
package br.gov.go.agr.cadu.domain.dto;

import java.io.Serializable;

/**
 * Projeção DTO imutável de leitura ultrarrápida com Java 21 Record.
 * Utilizado pelo construtor JPQL para eliminar o overhead de tracking de entidades gerenciadas.
 */
public record VeiculoResumoDTO(
    Long id,
    String placa,
    String renavam,
    String razaoSocialEmpresa,
    String nomeModelo,
    String nomeMunicipio
) implements Serializable {}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `agrfiscalservice` (`:8083`), a tela de consulta de histórico de autos de infração que listava 50 registros por página disparava anteriormente 151 consultas SQL no MySQL corporativo para resolver os relacionamentos de infrator, veículo e auditor fiscal. A reescrita do método do repositório utilizando `@EntityGraph(attributePaths = {"infrator", "veiculo", "auditor"})` reduziu as consultas para exatamente 2 instruções SQL (uma consulta de dados com os `JOIN`s correspondentes e uma consulta `SELECT count(id)` para o cálculo do total de páginas). A latência do endpoint caiu de 1.800 ms para 42 ms.

---

### 2.3 O Antipadrão Open Session In View (OSIV) e o Esgotamento do Pool HikariCP

#### Parte 1: O que é o conceito / Analogia Didática
A analogia da torneira aberta no restaurante ilustra com clareza a toxicidade do padrão Open Session In View (OSIV):
Imagine um restaurante cuja água é fornecida por um reservatório de capacidade limitada com apenas 10 torneiras principais (as 10 conexões padrão do pool HikariCP). O garçom anota o pedido na cozinha e serve a refeição ao cliente na mesa. Contudo, a regra da gerência dita: *"Enquanto o cliente estiver sentado à mesa mastigando, escolhendo se vai pedir a sobremesa ou pedindo a conta para pagar, o garçom deve manter uma das 10 torneiras principais totalmente aberta jorrando água na pia"*.

Se 10 clientes sentarem à mesa simultaneamente e demorarem 15 minutos para almoçar, as 10 torneiras ficam presas. Quando o 11º cliente chegar ao balcão querendo apenas um copo d'água rápido para tomar um remédio de urgência, a cozinha inteira está paralisada por falta de água e o restaurante entra em colapso.

O **Open Session In View (OSIV)** é essa torneira aberta: ele mantém a sessão do Hibernate e a conexão física JDBC do banco de dados abertas durante todo o ciclo de vida da requisição HTTP — desde o instante em que a requisição passa pelo filtro web do Spring MVC até a serialização completa do payload JSON de resposta pelo Jackson.

#### Parte 2: A Dor Histórica / O Desastre do Legado
O Spring Boot mantém, por padrão de fábrica em sua configuração inicial, a propriedade:
```properties
spring.jpa.open-in-view=true
```
A justificativa histórica dessa decisão de design amigável para iniciantes era evitar a temida `LazyInitializationException` em projetos de estudantes e tutoriais rápidos: se o desenvolvedor esquecesse de carregar um relacionamento Lazy na camada de serviço e o serializador Jackson tentasse acessar o getter no Controller, a sessão do Hibernate ainda estaria aberta e uma consulta SQL seria disparada silenciosamente em plena camada de apresentação web.

**O Efeito Dominó em Produção:**
Em sistemas corporativos reais, o OSIV é devastador:
1. **Retenção de Conexões por Latência de Rede:** Se um fiscal da AGR estiver em uma rodovia estadual no interior de Goiás utilizando um modem 4G instável com alta perda de pacotes e a resposta JSON demorar 8 segundos para ser completamente transmitida ao dispositivo móvel, a conexão física com o MySQL fica retida e bloqueada para aquele único usuário durante todos os 8 segundos, mesmo que a consulta no banco tenha durado apenas 2 milissegundos.
2. **Pool Starvation Catastrófico no HikariCP:** Sob uma carga concorrente modesta de apenas 50 requisições simultâneas, o pool padrão de 10 ou 20 conexões do HikariCP esgota instantaneamente:
   ```
   java.sql.SQLTransientConnectionException: HikariPool-1 - Connection is not available, request timed out after 30000ms.
   ```
3. **Consultas Ocultas na Serialização JSON:** O desenvolvedor não percebe que a serialização do Jackson está acionando getters Lazy, gerando dezenas de consultas SQL em loop durante o parse para JSON.

#### Parte 3: A Solução Moderna de Elite
A engenharia de elite **desativa compulsoriamente o OSIV** no arquivo de propriedades da aplicação e impõe que toda e qualquer transação de persistência seja iniciada e finalizada rigorosamente dentro dos limites da camada de serviço (`@Service`):

```yaml
# application.yml - Configuração Obrigatória para Ambientes Corporativos de Alta Performance
spring:
  jpa:
    # BANIMENTO COMPULSÓRIO DO ANTIPADRÃO OSIV
    open-in-view: false
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        default_batch_fetch_size: 30
        jdbc:
          batch_size: 50
  datasource:
    hikari:
      pool-name: AgrHikariPool
      maximum-pool-size: 20
      minimum-idle: 10
      connection-timeout: 30000 # 30 segundos
      idle-timeout: 600000       # 10 minutos
      max-lifetime: 1800000      # 30 minutos
```

Com `open-in-view: false`, a conexão física JDBC é devolvida ao pool HikariCP imediatamente no retorno do método do serviço. A camada Web (Controller e Jackson) trabalha exclusivamente com DTOs ou entidades já desanexadas cujos dados necessários foram previamente carregados. Se houver tentativa de acesso preguiçoso na camada web, o Hibernate falha imediatamente nos testes automatizados, forçando o desenvolvedor a escrever uma consulta explícita via DTO ou `JOIN FETCH`.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No ecossistema legado da AGR, todos os 25 microsserviços rodavam com `spring.jpa.open-in-view=true`. O colapso frequente do MySQL compartilhado em `10.243.1.27:3306` ocorria precisamente quando servidores da sede abriam relatórios Jasper ou tabelas de histórico com centenas de linhas. Centenas de conexões ficavam presas em estado `Sleep` no MySQL esperando a serialização HTTP dos navegadores dos clientes, impedindo que os auditores fiscais em campo conseguissem conexão para lavrar autos de infração urgentes no tablet. A desativação sistemática do OSIV restabeleceu a estabilidade operacional da autarquia.

---

## 3. Concorrência Crítica e Mecanismos de Lock (Lost Updates, Otimista & Pessimista)

### Matriz de Concorrência: Lock Otimista (@Version) vs Lock Pessimista (PESSIMISTIC_WRITE)

O tratamento de concorrência em sistemas transacionais distribuídos requer a seleção precisa do mecanismo de contenção adequado para a natureza do recurso:

| Característica de Engenharia | Lock Otimista (`@Version`) | Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`) |
| :--- | :--- | :--- |
| **Mecânica Operacional** | Não-bloqueante. Assume que conflitos de colisão são a exceção. Valida a versão no momento do comando `UPDATE`. | Bloqueante no nível do banco de dados. Executa `SELECT ... FOR UPDATE`, impedindo que outras transações acessem o registro. |
| **Impacto no Banco de Dados** | Mínimo: zero travamento de linhas durante a leitura; excelente escalabilidade horizontal em leituras massivas. | Alto: segura travas de linha (*Row-level Locks*) no mecanismo de armazenamento (InnoDB do MySQL / MVCC do PostgreSQL) até o commit ou rollback. |
| **Comportamento em Colisão** | Lança `jakarta.persistence.OptimisticLockException` no primeiro thread que tentar salvar com versão defasada. | Enfileira threads concorrentes no banco até a liberação do lock ou estouro de timeout (`jakarta.persistence.lock.timeout`). |
| **Tratamento de Interface Web** | Retorna status **HTTP 409 Conflict** padronizado via especificação **RFC 7807 (ProblemDetail)** para refação amigável pelo usuário. | Transparente para o usuário (a transação aguarda a fila do lock e processa em ordem sequencial atômica). |
| **Casos de Uso Primários** | Cadastros administrativos gerais, processos regulatórios, vistorias veiculares, atualização de perfis de usuário. | Recursos estritamente escassos e indivisíveis: assentos numerados de espetáculos (**Teatro-ABC**), contadores de autos fiscais e guias DARE. |

---

### 3.1 A Anatomia da Concorrência: O Fenômeno do Lost Update (Atualização Perdida)

#### Parte 1: O que é o conceito / Analogia Didática
A analogia dos dois editores na lousa da sala de conferências ilustra a essência do problema de concorrência:
Imagine que na sala de operações da AGR existe uma lousa branca contendo o valor da tarifa de pedágio autorizada para uma concessão rodoviária: "R$ 10,00". Dois técnicos regulatórios, João e Maria, entram na sala simultaneamente para atualizar o valor com base em índices econômicos distintos.
1. Maria olha para a lousa e anota em seu caderno: "Valor atual: R$ 10,00".
2. João olha para a lousa e também anota em seu caderno: "Valor atual: R$ 10,00".
3. Maria é rápida em seus cálculos: após 1 minuto, ela levanta-se, apaga a lousa e escreve o novo valor reajustado por inflação: "R$ 11,50". Maria sai da sala convicta de que sua decisão foi registrada.
4. João demorou 3 minutos para concluir seus cálculos de compensação tarifária. Sem olhar novamente para a lousa, João levanta-se, apaga o valor que Maria acabou de escrever e crava o seu resultado: "R$ 10,80".

O trabalho técnico de Maria foi sumariamente destruído e varrido do histórico sem deixar rastros. Isso é o **Lost Update (Atualização Perdida)**: o último que salva sobrescreve cegamente as modificações concorrentes realizadas por outros atores do sistema.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A trágica dinâmica do Lost Update em aplicações web comerciais foi imortalizada pelo instrutor da AlgaWorks no curso *Especialista JPA* (EJPA), na aula `1598_EJPA_14_02_Resolvendo_problemas_de_concorrência_com_Lock_Otimista.txt`:
> *"Imagina aí no e-commerce, tem dois funcionários ali, o João e a Maria... os dois pegaram ali o produto de identificador igual a um, os dois pegaram ele para poder editar a descrição desse produto... abriram o browser, carregaram o produto ao mesmo tempo... A Maria vai demorar 1 segundo só... O João vai demorar 3 segundos... A Maria clica em salvar, comita e é jogada para o banco... Aí depois o João vai sobrescrever o trabalho da Maria... a Maria vai perder o trabalho que ela fez... Como que a gente garante isso? Colocando na entidade @Version private Integer versao... O Hibernate vai pensar: 'o João está querendo atualizar aqui um registro, mas a versão dele é zero e a que está no banco, que no caso a Maria atualizou, está na versão 1'... aí o Hibernate vai lançar uma exceção que é OptimisticLockException."* (`1598_EJPA_14_02`)

**Por Que os Níveis de Isolamento do Banco não Resolvem Esse Problema na Web?**
Muitos desenvolvedores acreditam ingenuamente que configurar o nível de isolamento de transação do banco de dados como *Repeatable Read* ou *Serializable* resolve o conflito de João e Maria. **Essa premissa é completamente falsa na arquitetura Web HTTP**:
1. Quando Maria abre o navegador, uma requisição `GET /produtos/1` é disparada. Uma transação é aberta no banco, lê os dados e é imediatamente **fechada** no retorno da resposta HTTP.
2. Maria passa 45 segundos preenchendo o formulário na tela. Durante esses 45 segundos, **não existe nenhuma conexão ou transação aberta no banco de dados**.
3. Quando Maria clica em salvar, uma segunda requisição `PUT /produtos/1` abre uma nova transação relacional isolada e grava a alteração.
4. Quando João clica em salvar 10 segundos depois, uma terceira transação isolada abre e grava por cima. Como cada requisição HTTP opera em sua própria transação independente, para o motor relacional não há nenhuma colisão de ACID: todas as transações foram executadas com perfeição. O conflito é de **lógica de aplicação**, e requer controle de concorrência que transcenda o ciclo de vida de uma única transação JDBC.

#### Parte 3: A Solução Moderna de Elite
A solução definitiva para o conflito de concorrência em sistemas web é o desacoplamento de controle através do **Lock Otimista**, gerenciado pela anotação padronizada `@Version` do Jakarta Persistence 3.1:

```java
package br.gov.go.agr.fiscais.domain.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "tb_auto_infracao")
public class AutoInfracao implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_auto", nullable = false, unique = true, length = 20)
    private String numeroAuto;

    @Column(name = "valor_multa", nullable = false, precision = 12, scale = 2)
    private BigDecimal valorMulta;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    private StatusAuto status;

    @Column(name = "data_lavratura", nullable = false)
    private LocalDate dataLavratura;

    // CONTROLE CRÍTICO DE CONCORRÊNCIA OTIMISTA
    // O Hibernate incrementa este campo automaticamente a cada UPDATE emitido
    @Version
    @Column(name = "versao", nullable = false)
    private Long versao;

    public AutoInfracao() {}

    public Long getId() { return id; }
    public String getNumeroAuto() { return numeroAuto; }
    public void setNumeroAuto(String numeroAuto) { this.numeroAuto = numeroAuto; }
    public BigDecimal getValorMulta() { return valorMulta; }
    public void setValorMulta(BigDecimal valorMulta) { this.valorMulta = valorMulta; }
    public StatusAuto getStatus() { return status; }
    public void setStatus(StatusAuto status) { this.status = status; }
    public LocalDate getDataLavratura() { return dataLavratura; }
    public void setDataLavratura(LocalDate dataLavratura) { this.dataLavratura = dataLavratura; }
    public Long getVersao() { return versao; }
}
```

Sob o capô, quando a transação de persistência for sincronizada, o Hibernate não emitirá um comando `UPDATE` ingênuo. Em vez disso, ele injetará o controle de versão na cláusula `WHERE`:
```sql
UPDATE tb_auto_infracao
SET valor_multa = 1500.00, status = 'HOMOLOGADO', versao = versao + 1
WHERE id = 1042 AND versao = 0;
```
Se Maria já tiver gravado a versão 1 no banco, o comando disparado pela transação de João encontrará `0 rows affected`. O Hibernate detecta imediatamente que o registro foi alterado concorrentemente e lança `jakarta.persistence.OptimisticLockException`, abortando a sobrescrita e preservando o trabalho de Maria.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `agrfiscalservice` (`:8083`), ocorria frequentemente um incidente em processos de blitz: enquanto o auditor em campo autuava uma empresa de ônibus por descumprimento de horário via tablet, um analista jurídico da sede em Goiânia incluía uma liminar judicial autorizando a operação da linha no mesmo registro. Sem `@Version`, o clique do analista jurídico na sede apagava a autuação lavrada pelo fiscal no tablet, gerando prejuízos arrecadatórios e anulação judicial de multas por inconsistência documental.

---

### 3.2 Lock Otimista com @Version e Tratamento Elegante de OptimisticLockException

#### Parte 1: O que é o conceito / Analogia Didática
A analogia do carimbo notarial de versão:
Quando um cidadão protocola um requerimento no balcão da AGR, ele recebe uma cópia carimbada com "Versão 1, 10:00h". Se 15 minutos depois ele retornar querendo emendar o requerimento, o atendente confere o documento: se o original do arquivo arquivado ainda estiver marcado como "Versão 1", a emenda é aceita e o documento recebe o carimbo "Versão 2". Se, contudo, outro procurador da empresa tiver comparecido 5 minutos antes e alterado o documento para a "Versão 2", o atendente recusa prontamente a folha defasada: *"O senhor está se baseando em um documento ultrapassado; retire uma cópia atualizada da Versão 2 antes de propor novas emendas"*.

Tratar a exceção `OptimisticLockException` de forma elegante é transformar o erro técnico em uma resposta amigável e estruturada para a aplicação cliente, instruindo o usuário sobre a necessidade de recarregar os dados mais recentes.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Em muitos sistemas que ativam `@Version`, os desenvolvedores esquecem de capturar e tratar a exceção na camada de Controller REST. Quando a colisão concorrente acontece em produção:
1. O Spring Data JPA traduz a `jakarta.persistence.OptimisticLockException` para `org.springframework.orm.ObjectOptimisticLockingFailureException`.
2. A exceção sobe sem interceptação até a camada do servidor Tomcat.
3. A API devolve um erro genérico e feio **`HTTP 500 Internal Server Error`** com um stack trace de 80 linhas exposto no console do navegador do usuário.
4. O usuário, acreditando que a internet oscilou ou que o sistema travou, clica repetidamente no botão "Salvar", disparando múltiplos erros em sequência e saturando o log do microsserviço.

#### Parte 3: A Solução Moderna de Elite
A arquitetura de elite intercepta globalmente a exceção através de um `@RestControllerAdvice`, emitindo uma resposta padronizada em conformidade com a especificação internacional **RFC 7807 (Problem Details for HTTP APIs)** com o status canônico **`HTTP 409 Conflict`**:

```java
package br.gov.go.agr.fiscais.api.handler;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.orm.ObjectOptimisticLockingFailureException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;

import java.net.URI;
import java.time.Instant;

/**
 * Interceptador Global de Erros de Concorrência REST.
 * Converte falhas de Lock Otimista em respostas canônicas RFC 7807 HTTP 409 Conflict.
 */
@RestControllerAdvice
public class ConcorrenciaExceptionHandler {

    @ExceptionHandler(ObjectOptimisticLockingFailureException.class)
    public ProblemDetail handleOptimisticLockFailure(ObjectOptimisticLockingFailureException ex, WebRequest request) {
        String uriPath = request instanceof ServletWebRequest swr 
            ? swr.getRequest().getRequestURI() 
            : "/api";

        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
            HttpStatus.CONFLICT,
            "O registro solicitado foi modificado ou homologado por outro usuário enquanto você realizava a edição. " +
            "Para garantir a integridade das decisões regulatórias, recarregue a página antes de reenviar as alterações."
        );

        problemDetail.setTitle("Conflito de Concorrência Regulatório");
        problemDetail.setType(URI.create("https://api.agr.go.gov.br/erros/conflito-concorrencia"));
        problemDetail.setInstance(URI.create(uriPath));
        problemDetail.setProperty("timestamp", Instant.now());
        problemDetail.setProperty("codigoErro", "AGR-CONC-409");

        return problemDetail;
    }
}
```

Payload JSON emitido para o frontend Angular:
```json
{
  "type": "https://api.agr.go.gov.br/erros/conflito-concorrencia",
  "title": "Conflito de Concorrência Regulatório",
  "status": 409,
  "detail": "O registro solicitado foi modificado ou homologado por outro usuário enquanto você realizava a edição. Para garantir a integridade das decisões regulatórias, recarregue a página antes de reenviar as alterações.",
  "instance": "/api/v1/autos-infracao/1042",
  "timestamp": "2026-10-25T14:30:00Z",
  "codigoErro": "AGR-CONC-409"
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No `cadu` (`cadastrounicoservice` `:8081`), quando duas empresas concessionárias tentavam realizar o remanejamento simultâneo do mesmo veículo em linhas distintas, o frontend do Portal 2 agora intercepta o status `HTTP 409 Conflict` e exibe um modal amigável do PrimeNG (`p-dialog`) informando que o veículo acabou de ser alterado por outro operador, oferecendo um botão para atualizar os dados da tela em um clique.

---

### 3.3 Lock Pessimista (LockModeType.PESSIMISTIC_WRITE) em Recursos Escassos

#### Parte 1: O que é o conceito / Analogia Didática
A analogia da cabine de votação eleitoral ou da catraca de acesso exclusivo:
Existem situações em que o controle otimista é inadequado porque a concorrência incide sobre um **recurso escasso e não-reversível**. Imagine a poltrona A12 do show de gala no Teatro Oscar Niemeyer: você não pode deixar 500 pessoas comprarem o mesmo assento e depois dizer para 499 delas: *"Desculpe pelo conflito de concorrência, o assento já foi vendido para outro cidadão"*. Isso geraria um motim no balcão de atendimento e processos judiciais imediatos por danos morais.

O **Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`)** é a tranca de ferro da cabine de votação: o primeiro cliente que acessa o recurso tranca a cabine por dentro através do comando relacional `SELECT ... FOR UPDATE`. O banco de dados suspende e enfileira fisicamente qualquer outro thread que tentar ler ou modificar aquela mesma linha física até que a transação do primeiro cliente seja concluída com `COMMIT` ou `ROLLBACK`.

#### Parte 2: A Dor Histórica / O Desastre do Legado
O uso inadequado de locks ou a ausência de mecanismos de trava em recursos compartilhados causou incidentes históricos na emissão de documentos fiscais e guias de arrecadação:
1. **Numeração Duplicada em Picos de Blitz:** Para gerar o número do Auto de Infração, o legado da AGR executava:
   `SELECT MAX(numero) FROM tb_auto WHERE ano = 2026;`
   Em operações de blitz integradas com a Polícia Rodoviária Estadual com dezenas de auditores autuando simultaneamente, duas requisições liam o mesmo número `00142` no mesmo milissegundo, somavam 1 em memória (`00143`) e tentavam gravar. Resultado: exceções de chave duplicada (`DataIntegrityViolationException`) abortavam autuações em plena rodovia ou, em tabelas sem restrição de unicidade, dois autos oficiais recebiam o mesmo número legal.
2. **Deadlocks Eternos por Falta de Timeout:** Sistemas que aplicavam locks pessimistas sem definir tempo limite de espera (`lock timeout`) sofriam travamento de banco de dados: duas transações concorrentes tentavam travar registros cruzados em ordem invertida, gerando deadlocks que mantinham conexões do pool HikariCP penduradas indefinidamente.

#### Parte 3: A Solução Moderna de Elite
A implementação moderna exige a combinação de `@Lock(LockModeType.PESSIMISTIC_WRITE)` com a especificação estrita de timeout (`jakarta.persistence.lock.timeout`), garantindo a contenção atômica com liberação previsível:

```java
package br.gov.go.agr.fiscais.domain.repository;

import br.gov.go.agr.fiscais.domain.model.SequenciadorDocumento;
import br.gov.go.agr.fiscais.domain.model.TipoDocumentoFiscal;
import jakarta.persistence.LockModeType;
import jakarta.persistence.QueryHint;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SequenciadorDocumentoRepository extends JpaRepository<SequenciadorDocumento, Long> {

    /**
     * Adquire trava pessimista exclusiva de linha (SELECT ... FOR UPDATE)
     * Configurado com timeout de 3.000 ms (3 segundos) para proteção anti-deadlock.
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @QueryHints({
        @QueryHint(name = "jakarta.persistence.lock.timeout", value = "3000")
    })
    @Query("SELECT s FROM SequenciadorDocumento s " +
           "WHERE s.tipoDocumento = :tipo AND s.ano = :ano")
    Optional<SequenciadorDocumento> buscarComLockExclusivo(
        @Param("tipo") TipoDocumentoFiscal tipo,
        @Param("ano") Integer ano
    );
}
```

Serviço de emissão atômica de numeração fiscal estritamente isolado:

```java
package br.gov.go.agr.fiscais.application.service;

import br.gov.go.agr.fiscais.domain.model.SequenciadorDocumento;
import br.gov.go.agr.fiscais.domain.model.TipoDocumentoFiscal;
import br.gov.go.agr.fiscais.domain.repository.SequenciadorDocumentoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Objects;

@Service
public class GeradorNumeroFiscalService {

    private final SequenciadorDocumentoRepository sequenciadorRepository;

    public GeradorNumeroFiscalService(SequenciadorDocumentoRepository sequenciadorRepository) {
        this.sequenciadorRepository = sequenciadorRepository;
    }

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public String gerarProximoNumeroAutoInfracao() {
        int anoCorrente = LocalDate.now().getYear();

        // 1. O banco emite: SELECT ... FOR UPDATE com bloqueio exclusivo da linha daquele ano
        SequenciadorDocumento sequenciador = sequenciadorRepository
            .buscarComLockExclusivo(TipoDocumentoFiscal.AUTO_INFRACAO, anoCorrente)
            .orElseGet(() -> {
                SequenciadorDocumento novo = new SequenciadorDocumento(TipoDocumentoFiscal.AUTO_INFRACAO, anoCorrente);
                return sequenciadorRepository.save(novo);
            });

        // 2. Incremento seguro em memória com a certeza de que nenhuma outra thread acessa o registro
        Long proximoNumero = sequenciador.incrementarProximo();

        // Formatação canônica do auto de infração: AAAA/NNNNNN (ex: 2026/000142)
        return String.format("%04d/%06d", anoCorrente, proximoNumero);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Greenfield Teatro-ABC (`:8090`):** No sistema de venda de ingressos do Centro Cultural Oscar Niemeyer em Goiânia, a concorrência na compra de 300 assentos no instante de abertura das vendas do show inaugural atinge picos de 5.000 requisições simultâneas. O endpoint de reserva temporária utiliza `@Lock(LockModeType.PESSIMISTIC_WRITE)` sobre o registro do `Assento` solicitado. Se dois clientes clicarem na mesma poltrona na mesma fração de segundo, a transação que obteve o lock reserva o assento com um TTL de 10 minutos no Redis; a transação concorrente recebe uma resposta instantânea de que o assento acabou de ser bloqueado, garantindo **zero double-booking (reserva duplicada)**.
- **AGR `daredtoservice` (`:8088`):** Na geração de guias de recolhimento DARE vinculadas à SEFAZ-GO, a atribuição do código de barras e número sequencial estadual utiliza a mesma estratégia de lock pessimista, prevenindo colisões no sistema financeiro da Secretaria da Fazenda.

---

## 4. Evolução e Governança Estrutural de Banco com Flyway

### Matriz de Governança Estrutural: Flyway Versioning vs ddl-auto=update

A evolução de esquemas de banco de dados em ambientes corporativos exige controle de versão idêntico ao aplicado ao código-fonte:

| Critério de Governança | `hibernate.ddl-auto = update` (Antipadrão) | Migrações com Flyway 10+ (Padrão de Elite) |
| :--- | :--- | :--- |
| **Previsibilidade de Schema** | Nenhuma: o Hibernate infere alterações dinâmicas em runtime com base no mapeamento das entidades. | Absoluta: cada comando DDL é expressado em SQL explícito, revisado em PR e versionado no Git. |
| **Comportamento em Ambientes Clusterizados** | Catastrófico: múltiplos contêineres sobem ao mesmo tempo e executam comandos DDL concorrentes, travando tabelas. | Resiliente: o Flyway adquire travas de metadados na tabela de controle (`flyway_schema_history`), garantindo execução linear estrita. |
| **Limpeza de Estruturas Depreciadas** | Nula: o Hibernate nunca remove colunas, índices ou tabelas excluídas do Java para evitar perda de dados acidental. | Total: scripts versionados (`V...`) permitem `DROP COLUMN`, `ALTER TABLE` e recriação controlada de índices. |
| **Rastreabilidade e Auditoria** | Zero: impossível auditar quem, quando e por que uma tabela foi alterada no banco de produção. | Completa: a tabela `flyway_schema_history` registra a versão, autor, data, tempo de execução e hash CRC32. |
| **Paridade de Ambientes** | Caótica: disparidade crônica entre a máquina local do desenvolvedor e os servidores de homologação. | Perfeita: o mesmo pipeline de scripts é executado deterministicamente em dev, testes e produção. |

---

### 4.1 O Perigo Mortal de ddl-auto=update / create-drop em Produção

#### Parte 1: O que é o conceito / Analogia Didática
A analogia da obra civil sem planta arquitetural arquivada:
Imagine uma construtora contratada para erguer um hospital estadual. O engenheiro-chefe decide: *"Não precisamos de plantas, projetos hidrossanitários ou memoriais de cálculo arquivados na prefeitura. Toda vez que um médico achar que precisa de uma tomada ou uma pia nova, basta que o pedreiro entre na sala com uma marreta e quebre a parede no escuro"*. Com o passar do tempo, vigas estruturais mestras são perfuradas sem autorização, canos de esgoto são emendados na tubulação de água potável e a fiação elétrica vira uma bomba-relógio.

O parâmetro `spring.jpa.hibernate.ddl-auto=update` é esse pedreiro cego com marreta dentro do banco de dados corporativo. Toda vez que a aplicação Java inicia, o Hibernate inspeciona o banco e executa comandos DDL não auditados em tempo de execução.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A utilização de `ddl-auto=update` ou `create-drop` em produção causou alguns dos incidentes mais graves da história dos sistemas estatais:
1. **Acúmulo de Lixo Estrutural e Colunas Zumbis:** Quando uma propriedade da entidade Java era renomeada (por exemplo, de `numeroPlaca` para `placa`), o Hibernate não alterava o nome da coluna existente. Em vez disso, ele criava uma nova coluna `placa` vazia e abandonava a coluna antiga `numeroPlaca` com dados desatualizados. Com o tempo, as tabelas de fiscalização da AGR acumulavam mais de 40 colunas zumbis, índices duplicados e constraints sem manutenção.
2. **Concorrência Destrutiva no Startup de Contêineres:** Quando um microsserviço era escalado no Kubernetes ou Docker Compose para atender a um aumento de demanda e 3 instâncias subiam em paralelo, todas tentavam executar instruções `ALTER TABLE` simultâneas no MySQL corporativo. As requisições colidiam em *Metadata Locks*, abortando a inicialização de todos os contêineres e gerando indisponibilidade total do sistema.
3. **O Risco do `create-drop` Acidental:** Um erro de digitação no arquivo de configuração de produção que mantivesse `ddl-auto=create-drop` apagava o banco de dados inteiro no momento em que a aplicação era reiniciada.

#### Parte 3: A Solução Moderna de Elite
A **Norma Inviolável de Engenharia de Persistência** estabelece: **em ambientes de homologação e produção, `ddl-auto` deve ser configurado OBRIGATORIAMENTE como `validate`**:

```yaml
# application-prod.yml - Parâmetro Obrigatório de Produção
spring:
  jpa:
    hibernate:
      ddl-auto: validate # Banimento absoluto de update ou create-drop!
```

Com `ddl-auto: validate`, o Hibernate atua estritamente como um auditor de integridade: durante a inicialização, ele compara as anotações das classes Java com o catálogo de metadados físico do banco de dados relacional. Se uma tabela estiver faltando, uma coluna tiver tipo incompatível ou uma restrição de nulidade estiver violada, o Hibernate aborta imediatamente a subida da JVM com uma mensagem clara, impedindo que código incompatível entre em produção. Toda a responsabilidade de alteração do banco é transferida com exclusividade para o **Flyway**.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No servidor compartilhado MySQL corporativo da AGR (`10.243.1.27:3306`), equipes de sistemas legados realizavam alterações estruturais rodando scripts manuais via DBeaver diretamente em produção. Toda sexta-feira após deploys de novas versões, os servidores caíam porque alguém havia incluído um atributo na classe Java, mas esquecido de executar o `ALTER TABLE` manual no banco. A adoção de `ddl-auto: validate` acoplado ao Flyway 10+ eliminou 100% dos erros humanos de divergência de schema na infraestrutura da autarquia.

---

### 4.2 Estrutura Canônica de Versionamento Flyway 10+: V1__, V2__, R__ e flyway_schema_history

#### Parte 1: O que é o conceito / Analogia Didática
A analogia do livro-razão de um cartório notarial público:
Em um cartório de notas oficial, cada escritura é registrada em folhas numeradas sequencialmente de forma estrita: Página 1, Página 2, Página 3. Cada página é assinada pelo tabelião e recebe um selo criptográfico com carimbo temporal. É terminantemente proibido rasgar uma folha antiga, apagar um parágrafo que já foi selado ou colar uma folha adulterada no meio do livro. Se uma retificação for necessária, a única maneira legal permitida é abrir uma nova página numerada subsequente (Página 4) lavrando uma certidão de rerratificação.

O **Flyway 10+** é esse cartório notarial imutável dentro do seu banco de dados:
- Cada script de migração versionado recebe um prefixo sequencial imutável: `V1__...sql`, `V2__...sql`, `V3__...sql`.
- Uma vez executado em qualquer ambiente, o Flyway calcula o hash criptográfico (checksum CRC32) do arquivo e registra na tabela de controle `flyway_schema_history`. Se qualquer desenvolvedor alterar um único espaço em branco de um arquivo `V` antigo, o Flyway detecta a violação de integridade e recusa-se a inicializar a aplicação.
- Migrações repetíveis (`R__...sql`) são utilizadas para objetos idempotentes de banco de dados, como Views analíticas, Funções e Stored Procedures, sendo reexecutadas automaticamente sempre que seu conteúdo for modificado.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Antes da padronização com Flyway, novos desenvolvedores contratados para manter os sistemas da AGR demoravam até 4 dias para conseguir subir o ambiente local de desenvolvimento. Eles precisavam solicitar um dump desatualizado do MySQL de produção, rodar scripts de correção manuais com dezenas de erros de chaves estrangeiras e tentar adivinhar quais alterações estruturais haviam sido feitas nos últimos 6 meses. O versionamento de código no Git não correspondia ao estado do banco de dados, tornando os testes de integração frágeis e inviáveis.

#### Parte 3: A Solução Moderna de Elite
Configuração do Flyway 10+ integrado ao Spring Boot 3.3 com validação estrita no `application.yml`:

```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
    baseline-version: 0
    validate-on-migrate: true
    out-of-order: false
```

Estrutura de scripts em `src/main/resources/db/migration/`:

**Arquivo 1: `V1__criar_tabelas_iniciais_fiscalizacao.sql`**
```sql
-- V1: Criação da estrutura canônica de fiscalização de transporte
CREATE TABLE tb_regiao_fiscal (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo_regional VARCHAR(20) NOT NULL UNIQUE,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tb_auto_infracao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_auto VARCHAR(20) NOT NULL UNIQUE,
    placa_veiculo VARCHAR(8) NOT NULL,
    valor_multa DECIMAL(12, 2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    data_lavratura DATE NOT NULL,
    regiao_fiscal_id BIGINT NOT NULL,
    auditor_cpf VARCHAR(11) NOT NULL,
    versao BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_auto_regiao FOREIGN KEY (regiao_fiscal_id) REFERENCES tb_regiao_fiscal(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_auto_placa ON tb_auto_infracao(placa_veiculo);
CREATE INDEX idx_auto_data ON tb_auto_infracao(data_lavratura);
```

**Arquivo 2: `V2__adicionar_tabela_sequenciador_autos.sql`**
```sql
-- V2: Tabela de sequenciamento atômico para suporte a Lock Pessimista
CREATE TABLE tb_sequenciador_documento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_tipo_ano UNIQUE (tipo_documento, ano)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tb_sequenciador_documento (tipo_documento, ano, ultimo_numero)
VALUES ('AUTO_INFRACAO', 2026, 0);
```

**Arquivo 3: `R__criar_view_analitica_autuacoes_mensais.sql`**
```sql
-- R: Migration Repetível - View de Consolidação de Arrecadação por Regional
CREATE OR REPLACE VIEW vw_relatorio_mensal_autuacoes AS
SELECT 
    rf.nome AS regiao_nome,
    YEAR(ai.data_lavratura) AS ano_lavratura,
    MONTH(ai.data_lavratura) AS mes_lavratura,
    COUNT(ai.id) AS total_autos_lavrados,
    SUM(ai.valor_multa) AS montante_multas_reais
FROM tb_auto_infracao ai
INNER JOIN tb_regiao_fiscal rf ON rf.id = ai.regiao_fiscal_id
WHERE ai.status = 'HOMOLOGADO'
GROUP BY rf.nome, YEAR(ai.data_lavratura), MONTH(ai.data_lavratura);
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Teatro-ABC (`:8090`):** O projeto greenfield de bilhetagem do Centro Cultural Oscar Niemeyer utiliza scripts Flyway imutáveis desde a versão `V1__init_schema_teatro.sql` (criando as tabelas `tb_sala`, `tb_setor_plateia`, `tb_assento`, `tb_espetaculo`, `tb_sessao` e `tb_reserva`). Uma restrição de unicidade parcial no banco impede que qualquer assento possua mais de uma reserva com status `CONFIRMADA` para a mesma sessão:
  ```sql
  CREATE UNIQUE INDEX uk_assento_sessao_ativa ON tb_reserva(assento_id, sessao_id) 
  WHERE status IN ('RESERVADO', 'PAGO');
  ```
- **AGR `portalservice` (`:8080`):** Com a migração de todos os microsserviços para Flyway 10+, um novo desenvolvedor clona o repositório, sobe o contêiner com `docker compose up -d db` e inicializa a aplicação Spring Boot: em menos de 10 segundos, todas as tabelas, índices e dados base de migração são construídos automaticamente, viabilizando pipelines de Integração Contínua (CI/CD) com GitHub Actions e testes de integração com Testcontainers.

---

## 5. Guia Prático de Implementação, Tabela Comparativa & Checklist de Engenharia

### 5.1 Tabela Comparativa Consolidada: Padrões Legados AlgaWorks/AGR vs Padrões Modernos de Elite

| Dimensão Técnica | Padrão Histórico Legado (AlgaWorks / Portal 1) | Padrão Moderno de Elite (Java 21 / Spring Boot 3.3+) | Impacto na Física do Sistema |
| :--- | :--- | :--- | :--- |
| **Namespace** | `javax.persistence.*` | `jakarta.persistence.*` | Elimina dependências mortas e assegura compatibilidade com Jakarta EE 10. |
| **Consultas Dinâmicas** | `org.hibernate.Criteria` proprietária ou concatenação manual de SQL em DAOs. | Spring Data JPA Specifications ou JPQL moderno sobre o compilador SQM. | Elimina riscos de SQL Injection e viabiliza cache de planos de execução no banco. |
| **Carregamento de Relações** | `FetchType.EAGER` padrão em `@ManyToOne` e `@OneToOne`. | `FetchType.LAZY` estrito em 100% dos relacionamentos com `JOIN FETCH` sob demanda. | Reduz consultas SQL em até 95%, eliminando o desastre do N+1. |
| **Sessão Web (OSIV)** | `spring.jpa.open-in-view = true` | `spring.jpa.open-in-view = false` | Previne o esgotamento do pool HikariCP por latência de clientes HTTP lentos. |
| **Projeções de Leitura** | Entidades completas mapeadas com ModelMapper reflexivo. | Projeções diretas em construtores JPQL utilizando Java 21 Records. | Desempenho equivalente a JDBC puro, sem alocação de proxies ou dirty checking. |
| **Atualizações de Entidades** | Chamadas desnecessárias de `save()` em entidades gerenciadas. | Atualização transparente via Dirty Checking nativo do Persistence Context L1. | Reduz alocação de memória no Heap da JVM e simplifica a camada de serviço. |
| **Controle de Concorrência** | Inexistente (sobrescrita cega de registros por Lost Updates). | `@Version` para Lock Otimista com retorno RFC 7807 (HTTP 409 Conflict). | Impede a corrupção de decisões administrativas concorrentes. |
| **Recursos Escassos** | `SELECT MAX()` desprotegido gerando duplicações e colisões. | `@Lock(LockModeType.PESSIMISTIC_WRITE)` com timeout estrito de 3000ms. | Garante unicidade atômica e previne overbooking de assentos e guias DARE. |
| **Gestão Estrutural (DDL)** | `hibernate.hbm2ddl.auto = update` e scripts rodados na mão no DBeaver. | `hibernate.ddl-auto = validate` acoplado ao versionamento estrito com Flyway 10+. | Garante rastreabilidade total, pipelines de CI/CD automatizados e zero downtime em deploy. |

---

### 5.2 Checklist de Auditoria de Código para Pull Requests (PRs) de Persistência

Antes de submeter ou aprovar qualquer alteração de código envolvendo persistência relacional no repositório, o engenheiro de software deve validar rigorosamente os 10 itens abaixo:

1. [ ] **Auditoria de `FetchType.LAZY`:** Todos os mapeamentos `@ManyToOne` e `@OneToOne` declaram explicitamente `(fetch = FetchType.LAZY)`? Não há nenhum relacionamento utilizando a estratégia EAGER padrão da JPA?
2. [ ] **Banimento do OSIV:** O arquivo `application.yml` declara expressamente `spring.jpa.open-in-view: false`? Não há getters de proxies sendo invocados fora da camada `@Service`?
3. [ ] **Mapeamento de Lock Otimista:** Todas as entidades que representam registros transacionais mutáveis contêm o campo `@Version private Long versao;` mapeado?
4. [ ] **Tratamento Global de Conflito:** As exceções de colisão de concorrência (`ObjectOptimisticLockingFailureException`) são interceptadas e convertidas em respostas RFC 7807 com status `HTTP 409 Conflict`?
5. [ ] **Timeout em Locks Pessimistas:** Todas as consultas anotadas com `@Lock(LockModeType.PESSIMISTIC_WRITE)` possuem o hint de tempo limite configurado (`@QueryHint(name = "jakarta.persistence.lock.timeout", value = "3000")`) para evitar deadlocks permanentes?
6. [ ] **Extermínio do N+1:** Métodos de listagem paginada utilizam `@EntityGraph` ou consultas específicas com `JOIN FETCH`? Grids de leitura e relatórios utilizam projeções com Java 21 Records em vez de carregar entidades completas?
7. [ ] **Zero `save()` Redundante:** O código de serviço evita invocar `repository.save()` em entidades que já estão no estado `Managed` dentro de métodos `@Transactional`?
8. [ ] **Validação Estrita de Schema:** A configuração de DDL para ambientes integrados está definida estritamente como `spring.jpa.hibernate.ddl-auto: validate`?
9. [ ] **Scripts Flyway Imutáveis:** Os novos comandos DDL foram empacotados em migrações versionadas com a nomenclatura canônica `V{TIMESTAMP}__{descricao}.sql` e devidamente testados contra instâncias reais de banco?
10. [ ] **Zero Placeholders e Código Real:** Todos os blocos de código Java e SQL são autocontidos, completos, compiláveis e com tipagem estrita no ecossistema Java 21 LTS e Spring Boot 3.3+?
