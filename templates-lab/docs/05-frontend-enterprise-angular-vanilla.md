# Módulo 05: Frontend Corporativo Enterprise com Angular Moderno, TypeScript Estrito, Signals & PrimeNG

---

## Sumário Executivo & Manifesto da Engenharia de Frontend de Elite

O desenvolvimento de interfaces de usuário corporativas de missão crítica no setor público e em ecossistemas de alta demanda operacional atingiu um ponto de inflexão definitivo. Durante quase uma década (2016-2023), o ecossistema Angular esteve associado a uma pesada herança de abstrações burocráticas: `NgModules` monolíticos e confusos, injeção de dependências estritamente vinculada a construtores com dezenas de parâmetros, gerenciamento de estado síncrono forçado via streams reativos RxJS repletos de vazamentos de memória (*memory leaks*), e uma detecção de mudanças (*Change Detection*) de força bruta orquestrada pelo `Zone.js`, que varria a árvore de componentes inteira a cada evento de clique, requisição HTTP ou tecla digitada no teclado.

Nas entidades governamentais do Estado de Goiás — com ênfase no complexo ecossistema da **Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos (AGR)**, que opera 25 microsserviços distribuídos —, essa herança técnica gerou aplicações front-end pesadas, frágeis e de difícil manutenção. Bundles iniciais de JavaScript ultrapassavam 12 MB no **Portal Web Central** (`:4200`) e no módulo de **Fiscalização Web** (`:4203`). Dispositivos móveis de fiscais rodoviários operando em estradas remotas sofriam com travamentos frequentes no navegador devido ao consumo descontrolado de heap por subscrições RxJS não canceladas e tabelas renderizadas com o componente legado `<p-dataTable>` do PrimeNG clássico.

Paralelamente, em projetos modernos greenfield de alta concorrência — como o sistema de bilhetagem e reserva de assentos em tempo real do **Teatro-ABC** (`teatro-abc :4250` / backend `:8090`) no Centro Cultural Oscar Niemeyer —, o atraso de milissegundos na reconciliação de estado e a falta de tipagem estrita nos contratos de API resultavam em conflitos de concorrência e reservas duplicadas de poltronas.

Este documento constitui a **Masterclass Definitiva de Engenharia de Frontend Enterprise**. Ele desmantela as práticas arcaicas perpetuadas por cursos tradicionais — com destaque para o acervo de 1.625 aulas da AlgaWorks (*Fullstack Angular & Spring* - FAS) — e estabelece a arquitetura moderna de elite adotada pelo Top 5% dos engenheiros globais:
1. **TypeScript 5.x Estrito Enterprise**: Rejeição absoluta do tipo `any`, imutabilidade com `readonly` e `as const`, união discriminada (*discriminated unions*), tipos genéricos ricos e validação de contratos com *type guards*.
2. **Angular Moderno Standalone & Nova Arquitetura**: Eliminação sumária de `AppModule`, `SharedModule` e `CoreModule`, inicialização limpa via `bootstrapApplication`, provedores funcionais desacoplados e injeção moderna via função `inject()`.
3. **Reatividade Fina com Signals**: Substituição do Zone.js e de subscrições RxJS desnecessárias por primitivas finas de reatividade síncrona (`signal()`, `computed()`, `effect()`), controle automático de ciclo de vida com `takeUntilDestroyed()` e ponte síncrona `toSignal()`.
4. **Controle de Fluxo Nativo & Deferrable Views**: Extinção de diretivas estruturais (`*ngIf`, `*ngFor`) em prol da nova sintaxe embutida `@if`, `@for (track)` e divisão cirúrgica de bundles sob demanda com `@defer`.
5. **Formulários Reativos Tipados & PrimeNG Industrial**: `Typed Reactive Forms` rigorosamente tipados, validadores customizados para documentos oficiais brasileiros (CPF com cálculo de módulo 11 e placas veiculares bivalentes formato antigo e Mercosul), e grids server-side de alto desempenho com PrimeNG `p-table` lazy loading.

---

## Matriz Comparativa Definitiva: Paradigmas Legados vs Modernos

Para orientar arquitetos e engenheiros de software, a tabela abaixo consolida os quatro contrastes obrigatórios de versão e arquitetura, confrontando o código legado ensinado em treinamentos tradicionais com o padrão de excelência de produção:

| Eixo Tecnológico | Paradigma Legado (AlgaWorks FAS / Legado AGR) | Paradigma Moderno de Elite (Angular 17/18+ Vanilla) | Impacto Físico no Browser & Manutenção |
|---|---|---|---|
| **Angular Legado (v2-15 com NgModules) vs Angular Moderno (v17/18+ Standalone & Signals)** | Aplicação estruturada em `AppModule`, `SharedModule`, `CoreModule` e módulos de funcionalidade. Declarações manuais obrigatórias em `declarations: []`. Bootstrap via `platformBrowserDynamic().bootstrapModule(AppModule)`. | **Standalone Components** (`standalone: true`). Eliminação completa de `NgModule`. Importações granulares diretamente no metadado `@Component`. Bootstrap funcional via `bootstrapApplication(AppComponent, appConfig)`. | Redução de até 85% no tamanho do bundle JavaScript inicial. Eliminação de dependências circulares ocultas. Suporte nativo a *Tree-Shaking* agressivo no build com Esbuild. |
| **RxJS Puro (.toPromise / memory leaks) vs Signals & takeUntilDestroyed** | Uso do operador depreciado `.toPromise()` com tipagem `Promise<any>`. Inscrições manuais via `.subscribe()` no `ngOnInit()` sem cancelamento no `ngOnDestroy()`. Change Detection conduzida pelo `Zone.js` varrendo toda a árvore de componentes. | **Angular Signals** (`signal`, `computed`, `effect`) para estado de tela síncrono. Subscrições RxJS necessárias gerenciadas via `takeUntilDestroyed()` ou convertidas diretamente com `toSignal()`. Modo **Zoneless** nativo. | Fim dos vazamentos de memória (*heap exhaustion*). Re-renderização cirúrgica focada exclusivamente no nó do DOM que depende do sinal alterado, sem varrer componentes não relacionados. |
| **PrimeNG Legado (p-dataTable / ui-g) vs PrimeNG Moderno (p-table / Flex / Tailwind)** | Tabelas com `<p-dataTable>` e `<p-column field="campo">` com tipagem opaca e reflexão de strings. Layout diagramado com sistema CSS proprietário depreciado PrimeUI Grid (`ui-g`, `ui-g-12`). | **`<p-table>` (TurboTable)** com paginação server-side obrigatória (`[lazy]="true"`), *Virtual Scrolling*, tipagem estrita de payloads (`TableLazyLoadEvent`) e estilização moderna via Flexbox, CSS Grid e PrimeNG Unstyled / Tailwind CSS. | Estabilidade contra travamentos de navegador com bases acima de 50.000 registros. Fim da dependência de bibliotecas de grade CSS legadas e eliminação de seletores profundos `::ng-deep`. |
| **JavaScript Fraco vs TypeScript Estrito Enterprise** | Tipos `any` indiscriminados (`let dados: any;`), retornos de métodos sem contrato (`buscar(): Observable<any>`), casting forçado com `as any`, classes POJO mutáveis com propriedades dinâmicas arbitrárias. | **TypeScript 5.x com Flags Estritas Máximas** (`strict: true`, `noImplicitAny`, `strictNullChecks`, `noUncheckedIndexedAccess`). Contratos imutáveis via `readonly` e `as const`. *Discriminated Unions* e *Type Guards* funcionais. | Detecção de 100% dos erros de contrato em tempo de compilação. Imunidade total ao erro `Uncaught TypeError: Cannot read properties of undefined` em produção. |

---

## Matriz de Conexão Operacional: AGR-Docs & Teatro-ABC

Toda a teoria apresentada neste módulo é diretamente contextualizada nos microfrontends e serviços reais de produção da Agência Goiana de Regulação (AGR) e no greenfield Teatro-ABC:

| Frontend / Microfrontend | Porta Local | Backend Correspondente | Base de Dados | Domínio e Cenário de Negócio no Frontend |
|---|---|---|---|---|
| **Portal Web Central** (`portal`) | `:4200` | `portalservice` (`:8080`) | `portal` | Shell principal de microfrontends, autenticação centralizada OAuth2/JWT com PKCE, alternância contextual de perfil e empresas concessionárias vinculadas (`subUsers`), menu dinâmico RBAC governado por Functional Guards (`authGuard`). |
| **CADU Web** (`cadu`) | `:4201` | `cadastrounicoservice` (`:8081`) | `cadu` | Cadastro Único Regulatório: Gerenciamento unificado de frotas de transporte de passageiros, validação síncrona e assíncrona de placas veiculares (Mercosul e formato clássico) e controle de certidões. |
| **Fiscalização Web** (`fiscalizacao`) | `:4203` | `agrfiscalservice` (`:8083`) | `fiscalizacao` | Operação em campo e blitz rodoviária: Lavratura de Autos de Infração com Typed Reactive Forms, upload assíncrono de laudos fotográficos com `@defer`, e grid de abordagens com `p-table` lazy loading. |
| **Receita Web** (`receita`) | `:4212` | `receitaservice` (`:8092`) | `receitas` | Conciliação contábil da Taxa de Regulação, Controle e Fiscalização (TRCF), processamento de débitos tributários, modal de erros compatível com RFC 7807 (`ProblemDetail`) e emissão de guias de pagamento. |
| **DARE Web** (`dare`) | `:4225` | `daredtoservice` (`:8088`) | `dare` | Documento de Arrecadação de Receitas Estaduais: Renderização de linha digitável FEBRABAN, exibição de QR Code e PIX Copia-e-Cola e impressão de certidões negativas de débito fiscal. |
| **Teatro-ABC Web** (`teatro-abc`) | `:4250` | `teatro-abc` (`:8090`) | `teatro_abc` | Greenfield: Centro Cultural Oscar Niemeyer. Mapa interativo de assentos em tempo real governado por **Angular Signals**, reserva concorrente com lock temporário e scanner de QR Code de ingressos. |

---

## PILAR 1: TypeScript Estrito Enterprise (`tsconfig.json`, Domínio Rico & Imutabilidade)

### 1.1 Configuração Rigorosa de Compilação (`tsconfig.json` de Elite)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma fábrica de peças aeroespaciais onde todas as peças produzidas precisam passar por uma esteira de inspeção a laser antes de serem liberadas para o hangar de montagem. Se o operador desativar os sensores a laser para "acelerar o trabalho", qualquer peça torta, trincada ou com dimensões incompatíveis passa batido pela esteira. O desastre não ocorrerá no galpão, mas a dez mil metros de altitude, quando a turbina falhar em pleno voo com passageiros a bordo.

O compilador TypeScript, em seu modo padrão permissivo, comporta-se exatamente como essa esteira com os sensores desligados. Quando você permite a inferência do tipo `any` ou desativa a verificação estrita de valores nulos, o TypeScript abre mão de sua missão protetora e reduz-se a mero comentário cosmético sobre o código JavaScript.

Por outro lado, o `tsconfig.json` com **Flags Estritas Máximas** é a ativação total dos sensores laser na esteira de montagem. Ele inspeciona cada declaração de variável, cada retorno de função, cada acesso a índices de arrays e cada propriedade potencialmente indefinida. Se houver a menor ambiguidade de tipos, a compilação falha imediatamente no terminal do desenvolvedor ou na esteira de integração contínua (CI/CD), impedindo categoricamente que qualquer código defeituoso chegue aos servidores de produção.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento front-end corporativo tradicional ensinado na década passada — e largamente reproduzido nos primeiros portais desenvolvidos para a AGR (Portal 1 e Portal 2) —, o TypeScript era tratado como um obstáculo burocrático a ser contornado. Arquivos de serviço e componentes estavam infestados de declarações frouxas como:

```typescript
// Antipadrão arcaico comum no legado da AGR
consultarProcesso(id: any): any {
  return this.http.get('http://api.agr.go.gov.br/processos/' + id)
    .toPromise()
    .then(function(response: any) {
      return response.json();
    });
}
```

Na aula `1029_FAS_16.3-fazendo-requisicao-com-get-e-recebendo-o-retorno.txt` da AlgaWorks, esse tratamento permissivo foi explicitamente ensinado como padrão de conveniência:

> *"Essa chamada do método Get retorna um objeto do tipo Observable, WLtecaRxJS, ou seja, RxJS. A gente vai converter esse retorno para uma promise, para deixar mais simples para a gente. E para fazer isso, é só chamar o método ToPromise. Mas, veja, esse método não existe, observa? Bom, não tem esse operador, por isso a gente precisa importar aqui em cima. Vamos digitar Import, e entre aspas, digitar aqui RxJS, barra Edge, barra Operator, barra ToPromise, com P, maiúsculo... Agora, que a gente já tem uma promessa, a gente pode usar essa promessa da forma que a gente já conhece... inclusive, a gente vai retornar aqui uma promise. Uma promise de qualquer coisa que ene [Promise<any>]."* (`1029_FAS_16.3`)

**A Consequência Catastrófica em Produção**:
Ao retornar `Promise<any>`, o desenvolvedor abdicou de qualquer proteção estática. Se o backend da AGR renomeasse a propriedade `numeroProcesso` para `numeroProtocolo`, o TypeScript continuava compilando o projeto sem nenhum erro. 

Em produção, no entanto, a tela do fiscal em plena rodovia GO-080 congelava com o clássico erro no console do navegador:
`Uncaught TypeError: Cannot read properties of undefined (reading 'split')`.
O fiscal ficava impedido de lavrar o auto de infração, gerando atrasos em blitz integradas e forçando a equipe de TI a lançar hotfixes emergenciais de madrugada.

#### Parte 3: A Solução Moderna de Elite
A engenharia moderna de elite configura o `tsconfig.json` e o compilador do Angular com tolerância zero a tipos implícitos, nulos negligenciados e acessos indexados inseguros. Abaixo está o arquivo de configuração canônico utilizado em projetos enterprise de alto rigor:

```json
{
  "compileOnSave": false,
  "compilerOptions": {
    "target": "ES2022",
    "useDefineForClassFields": true,
    "module": "ES2022",
    "moduleResolution": "bundler",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "isolatedModules": true,

    /* ==========================================================================
       NÚCLEO DE RIGOR ESTRITO ENTERPRISE (ZERO COMPLACÊNCIA)
       ========================================================================== */
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,

    /* ==========================================================================
       PROTEÇÃO CIRÚRGICA CONTRA RUNTIME UNDEFINED ERRORS
       ========================================================================== */
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "allowUnreachableCode": false,

    /* ==========================================================================
       ARQUITETURA DE MÓDULOS E RESOLUÇÃO DE PATHS
       ========================================================================== */
    "declaration": false,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": false,
    "baseUrl": "./",
    "paths": {
      "@core/*": ["src/app/core/*"],
      "@shared/*": ["src/app/shared/*"],
      "@domain/*": ["src/app/domain/*"],
      "@fiscalizacao/*": ["src/app/features/fiscalizacao/*"]
    }
  },
  "angularCompilerOptions": {
    "enableI18nLegacyMessageIdFormat": false,
    "strictInjectionParameters": true,
    "strictInputAccessModifiers": true,
    "strictTemplates": true
  }
}
```

**Análise das Flags Críticas de Proteção**:
1. `noImplicitAny`: Proíbe expressamente que variáveis ou argumentos assumam o tipo `any` quando não especificados, forçando o desenvolvedor a declarar a tipagem exata.
2. `strictNullChecks`: Separa os tipos primitivos (`string`, `number`) de `null` e `undefined`. Se um objeto puder ser nulo, ele deve ser tipado como `string | null`, obrigando o código a realizar a checagem defensiva antes do acesso.
3. `noUncheckedIndexedAccess`: Ao acessar um array ou mapa via índice (`autos[0]`), o TypeScript infere o retorno como `T | undefined` em vez de simplesmente `T`, impedindo que o código assuma que o índice sempre existe.
4. `strictTemplates`: Ativa no compilador Angular a checagem rigorosa de tipos nas expressões dos templates HTML, impedindo a passagem de propriedades incompatíveis em inputs de componentes.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Fiscalização Web** (`fiscalizacao web :4203`), a ativação dessas flags impediu que parâmetros opcionais do veículo — como `municipioEmissao` e `anoFabricacao` — gerassem erros em tempo de execução ao calcular se o veículo de transporte de passageiros excedeu a idade limite regulamentar de 15 anos permitida pela Resolução Normativa da AGR.

No **Teatro-ABC** (`teatro-abc :4250`), a flag `noUncheckedIndexedAccess` assegura que, ao selecionar uma poltrona no mapa bidimensional de assentos (`mapaAssentos[linha][coluna]`), o compilador force a validação de existência do quadrante antes de despachar a reserva via WebSocket para o backend `:8090`.

---

### 1.2 Modelagem de Domínio Rica: Interfaces, Generics e Tipos Utilitários Imutáveis

#### Parte 1: O que é o conceito / Analogia Didática
Pense em um contrato oficial de licitação pública assinado em cartório com firma reconhecida e páginas rubricadas versus uma anotação feita a lápis no verso de um comprovante de padaria. No papel a lápis, qualquer um pode apagar um valor, acrescentar um zero ou riscar uma cláusula sem deixar rastros. No contrato oficial em cartório, o teor das cláusulas é inalterável, as partes são precisamente identificadas por documento legal e qualquer aditivo exige formalização rigorosa.

A modelagem de domínio rica com **interfaces imutáveis**, **generics** e **tipos utilitários** em TypeScript é a garantia de que as entidades fundamentais do negócio mantêm a sua integridade ao longo de toda a aplicação. Ela estabelece tipos imutáveis (`readonly`), impede a mutação acidental de propriedades por componentes secundários e define contratos expressivos que representam com exatidão as regras do negócio governamental.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento front-end legado da AGR, entidades de negócio eram modeladas como classes mutáveis ou objetos anônimos. Frequentemente, componentes de tela alteravam propriedades de objetos compartilhados por referência:

```typescript
// Desastre do legado: mutação de estado compartilhada por referência
export class VeiculoLegado {
  public placa: string = '';
  public proprietario: string = '';
  public bloqueado: boolean = false;
}

// Em um componente secundário qualquer:
this.veiculoSelecionado.bloqueado = true; // Mutação direta afetava outras telas sem Change Detection previsível
```

Outro sintoma grave era a proliferação de classes de transporte sem reaproveitamento genérico. Desenvolvedores criavam dezenas de interfaces repetitivas como `PageAutoInfracao`, `PageVeiculo`, `PageConcessionaria`, reescrevendo campos de paginação (`totalElements`, `totalPages`, `content`) dezenas de vezes, gerando divergências quando o backend ajustava a nomenclatura do envelope de paginação.

#### Parte 3: A Solução Moderna de Elite
A engenharia de elite utiliza contratos declarativos baseados em `interface`, genéricos profundos para estruturas de dados transversais e o modificador `readonly` para blindagem de estado:

```typescript
/**
 * Identificador Nominal Tipado (Branded Type) para segurança em tempo de compilação.
 * Impede que o ID de um Auto de Infração seja acidentalmente passado onde se espera o ID de um Veículo.
 */
export type AutoInfracaoId = string & { readonly __brand: unique symbol };
export type VeiculoId = string & { readonly __brand: unique symbol };

/**
 * União Discriminada (Discriminated Union) modelando o Ciclo de Vida do Auto de Infração.
 */
export type EstadoProcessualInfracao =
  | { readonly status: 'AUTUADO'; readonly dataAutuacao: string; readonly agenteAutuador: string }
  | { readonly status: 'NOTIFICADO'; readonly dataNotificacao: string; readonly prazoDefesa: string }
  | { readonly status: 'JULGADO'; readonly dataJulgamento: string; readonly penalidadeMantida: boolean }
  | { readonly status: 'QUITADO'; readonly dataPagamento: string; readonly autenticacaoBancaria: string }
  | { readonly status: 'CANCELADO'; readonly dataCancelamento: string; readonly justificativaLegal: string };

/**
 * Modelo de Domínio Rico e Imutável do Auto de Infração Rodoviária.
 */
export interface AutoInfracao {
  readonly id: AutoInfracaoId;
  readonly numeroAuto: string;
  readonly placaVeiculo: string;
  readonly renavam: string;
  readonly valorMulta: number;
  readonly descricaoInfracao: string;
  readonly localizacaoKm: number;
  readonly rodovia: string;
  readonly dataHoraLavratura: string;
  readonly estadoProcessual: EstadoProcessualInfracao;
  readonly fotosProvisorias: readonly string[];
}

/**
 * Envelope Genérico Enterprise de Paginação Spring Data.
 */
export interface Page<T> {
  readonly content: readonly T[];
  readonly totalElements: number;
  readonly totalPages: number;
  readonly size: number;
  readonly number: number;
  readonly first: boolean;
  readonly last: boolean;
  readonly empty: boolean;
}

/**
 * Resposta Padronizada de Sucesso da API.
 */
export interface ApiResponse<T> {
  readonly dados: T;
  readonly timestamp: string;
  readonly protocoloRastreio: string;
}
```

Ao declarar as coleções como `readonly T[]` e as propriedades como `readonly`, qualquer tentativa de mutação direta como `auto.valorMulta = 500` gera um erro imediato no editor de código:
`Cannot assign to 'valorMulta' because it is a read-only property`.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **CADU Web** (`cadu web :4201`), a modelagem rica e imutável assegura que a estrutura cadastral da empresa de transporte intermunicipal — com sua lista de veículos autorizados e linhas outorgadas — nunca sofra mutações colaterais durante o preenchimento de formulários de vistoria.

No **Teatro-ABC** (`teatro-abc :8090`), a tipagem discriminada dos estados do assento:
```typescript
export type EstadoAssento =
  | { readonly status: 'LIVRE'; readonly preco: number }
  | { readonly status: 'RESERVADO_TEMPORARIO'; readonly expiracaoMs: number; readonly usuarioId: string }
  | { readonly status: 'CONFIRMADO'; readonly ticketId: string; readonly titular: string };
```
impede matematicamente que uma poltrona no estado `CONFIRMADO` tenha seu preço alterado ou seu timer de reserva acessado por engano.

---

### 1.3 Validação e Narrowing de Tipos: Type Guards, Discriminated Unions e Tratamento Seguro de API

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o scanner biométrico de uma área de alta segurança em um tribunal de justiça. Quando uma pessoa posiciona a mão no scanner, o sistema lê os padrões vasculares da palma e a geometria dos dedos. Somente se o padrão for 100% compatível com a base da polícia científica é que a porta blindada se abre e o sistema atribui àquela pessoa as permissões específicas de Juiz ou Desembargador.

Um **Type Guard** (Guardião de Tipo) em TypeScript é o scanner biométrico de código. Ele recebe um objeto cuja estrutura é desconhecida — como um payload JSON cru vindo de uma requisição HTTP ou de um WebSocket — e realiza verificações booleanas precisas em tempo de execução. Uma vez aprovado pelo guardião, o compilador restringe (*type narrowing*) automaticamente aquele objeto ao tipo estrito, garantindo segurança matemática de que todas as propriedades existem antes de serem acessadas.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No código legado, o tratamento de respostas HTTP era feito por coerção forçada (*type casting*) usando a palavra-chave `as`:

```typescript
// Antipadrão perigoso do código legado
this.http.get('/api/autos/' + id).subscribe(dados => {
  const auto = dados as AutoInfracao; // O compilador é enganado!
  console.log(auto.estadoProcessual.status.toUpperCase()); // Se o backend retornar erro, quebra aqui!
});
```

Quando o backend retornava uma resposta de erro no padrão RFC 7807 (`ProblemDetail`) com status HTTP 400 ou 422 em vez do objeto esperado, ou quando uma chave da API vinha com valor nulo, o casting `as AutoInfracao` mentia para o TypeScript. O resultado era que a aplicação tentava acessar propriedades inexistentes, gerando exceções em cascata e telas brancas para o usuário.

#### Parte 3: A Solução Moderna de Elite
A engenharia moderna emprega funções predicadas de tipo (`value is T`) e tratamento exaustivo de respostas através de união discriminada:

```typescript
import { HttpErrorResponse } from '@angular/common/http';

/**
 * Contrato Oficial da RFC 7807 (Problem Details for HTTP APIs).
 */
export interface ProblemDetail {
  readonly type: string;
  readonly title: string;
  readonly status: number;
  readonly detail: string;
  readonly instance: string;
  readonly violations?: readonly { readonly field: string; readonly message: string }[];
}

/**
 * Type Guard personalizado para validação em runtime de ProblemDetail RFC 7807.
 */
export function isProblemDetail(obj: unknown): obj is ProblemDetail {
  if (typeof obj !== 'object' || obj === null) {
    return false;
  }
  const candidate = obj as Record<string, unknown>;
  return (
    typeof candidate['title'] === 'string' &&
    typeof candidate['status'] === 'number' &&
    typeof candidate['detail'] === 'string'
  );
}

/**
 * Processador Seguro de Erros de API com Type Narrowing Exaustivo.
 */
export function processarErroApi(erro: unknown): string {
  if (erro instanceof HttpErrorResponse) {
    if (isProblemDetail(erro.error)) {
      const violacoes = erro.error.violations
        ? ` Violações: ${erro.error.violations.map(v => `${v.field}: ${v.message}`).join(', ')}`
        : '';
      return `[Erro ${erro.error.status}] ${erro.error.title}: ${erro.error.detail}.${violacoes}`;
    }
    return `Falha HTTP ${erro.status}: ${erro.statusText || 'Serviço temporariamente indisponível'}`;
  }

  if (erro instanceof Error) {
    return `Erro de Execução Front-end: ${erro.message}`;
  }

  return 'Ocorreu uma anomalia desconhecida na operação.';
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Receita Web** (`receita web :4212`), o processamento de guias e cálculo de multas regulatórias utiliza esse guardião de tipo para capturar instantaneamente exceções de cálculo expedidas pelo `receitaservice :8092`. Se o cálculo de juros for rejeitado pelo backend, o front-end extrai o `ProblemDetail` com precisão, renderizando um alerta descritivo na tela com os campos exatos que violaram a norma tributária.

---

## PILAR 2: Angular Moderno: Standalone Components & Nova Arquitetura

### 2.1 Extinção Definitiva de NgModules (`AppModule`, `SharedModule`, `CoreModule`)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma grande feira livre onde, para comprar uma única maçã fresca, você fosse obrigado a comprar um fardo lacrado contendo uma caixa de madeira de 20 quilos, dois abacaxis, um pote de maionese, um martelo e um livro de receitas em mandarim. Se você quisesse apenas uma maçã, era forçado a carregar o fardo inteiro nos braços até em casa e pagar pelo frete de tudo aquilo.

Os `NgModules` clássicos do Angular funcionavam exatamente como esse fardo lacrado. Para que um componente utilizasse um simples botão ou formatação de data, você precisava registrar o componente em um módulo, que por sua vez importava módulos inteiros (`SharedModule`, `FormsModule`, `PrimeNgModule`), arrastando centenas de diretivas, pipes e componentes não utilizados para dentro do bundle compilado da tela.

A introdução dos **Standalone Components** é a revolução da compra unitária e cirúrgica: cada componente declara explicitamente apenas as peças exatas que consome (`imports: [CommonModule, ButtonModule]`). Não existem intermediários burocráticos. O componente torna-se um bloco autônomo, modular, reutilizável e perfeitamente otimizado para o compilador descartar todo código supérfluo (*tree-shaking*).

#### Parte 2: A Dor Histórica / O Desastre do Legado
Durante anos, a doutrina canônica do Angular impôs a divisão da aplicação em camadas artificiais de módulos. Na trilha *Fullstack Angular & Spring* (FAS) da AlgaWorks, a necessidade do `AppModule` e do `CoreModule` era ensinada como a fundação elementar da arquitetura.

Na aula `1008_FAS_14.1-introducao-aos-modulos.txt`:
> *"Toda a aplicação Angular tem pelo menos um módulo, que é o rootMódulo, ou seja, o módulo raiz, que normalmente a gente coloca o nome dele de appMódulo. Quando o projeto vai crescendo, começa a ficar bagunçado, a gente fica perdido no meio de tantos componentes e diretivas e a gente precisa criar módulos para organizar melhor o projeto... Chegamos, então, à conclusão que uma aplicação Angular é o conjunto de várias peças, onde cada peça é um módulo que, dentro, tem outras peças, que são os componentes diretivos... Um módulo deve declarar os elementos que ele possui... E, opcionalmente, os módulos podem exportar esses elementos para que eles sejam usados externamente por outros módulos... O conjunto de todos os módulos formam a nossa aplicação completa, mas tudo começa pelo AppModule."* (`1008_FAS_14.1`)

Posteriormente, na aula `1017_FAS_14.10-o-que-e-core-module.txt`, introduziu-se a gambiarra arquitetural do `CoreModule`:
> *"Agora nós vamos estudar uma última categoria de módulos que geralmente usamos em aplicações Angular, que é chamado de CoreModule... O navbarComponent não faz parte de um módulo de funcionalidade, ou seja, um featureMódule e nem de um shareMódule. Não é um componente compartilhado entre os módulos, então esse navbar é usado apenas dentro do appComponent... Então elementos como este que são usados apenas dentro do módulo raiz da aplicação devem ser colocados em um módulo chamado CoreModule... é como uma extensão do appModule, mas a gente cria um novo módule e chama ele de CoreModule para deixar o appModule o mais limpo possível... a gente coloca componentes, diretivas, coisas que a gente só vai usar dentro do appModule mesmo... dentro do CoreModule... é o módulo principal da nossa aplicação."* (`1017_FAS_14.10`)

**O Colapso Operacional nos Sistemas da AGR**:
Na AGR, a existência de `CoreModule` e `SharedModule` gigantescos levou ao fenômeno do "Módulo Buraco Negro". O `SharedModule` acumulou centenas de importações do PrimeNG, bibliotecas de máscara, pipes customizados e utilitários de autenticação. 

Qualquer tela simples — como a consulta de uma certidão no **DARE Web** (`:4225`) — acabava baixando 14 MB de código compilado, pois o Webpack não conseguia descartar componentes do `SharedModule`. Além disso, se um desenvolvedor importasse acidentalmente o `CoreModule` dentro de um módulo lazy-loaded, os serviços singleton eram reinstanciados na memória, resetando o estado da sessão e deslogando o usuário inesperadamente.

#### Parte 3: A Solução Moderna de Elite
No Angular 17/18+ Vanilla, os `NgModules` estão formalmente extintos da arquitetura moderna. Todo componente, diretiva ou pipe é declarado com `standalone: true`:

```typescript
import { Component, ChangeDetectionStrategy, input, output } from '@angular/core';
import { CommonModule, DatePipe, CurrencyPipe } from '@angular/common';
import { ButtonModule } from 'primeng/button';
import { TagModule } from 'primeng/tag';
import { AutoInfracao } from '@domain/models/fiscalizacao.models';

/**
 * Componente Standalone de Visualização Resumida de Auto de Infração.
 * Dependências declaradas granularmente sem necessidade de nenhum NgModule intermediário.
 */
@Component({
  selector: 'app-auto-infracao-card',
  standalone: true,
  imports: [
    CommonModule,
    DatePipe,
    CurrencyPipe,
    ButtonModule,
    TagModule
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <article class="p-4 border-round-lg shadow-1 surface-card border-left-3 border-red-500">
      <header class="flex justify-content-between align-items-center mb-3">
        <span class="text-xs font-bold text-500 uppercase tracking-wider">Protocolo de Fiscalização</span>
        <p-tag [value]="auto().estadoProcessual.status" severity="warning" />
      </header>

      <section class="mb-3">
        <h3 class="text-xl font-bold text-900 m-0">{{ auto().numeroAuto }}</h3>
        <p class="text-600 font-mono mt-1 mb-2">Placa: {{ auto().placaVeiculo }} | Rodovia: {{ auto().rodovia }} (Km {{ auto().localizacaoKm }})</p>
        <p class="text-700 line-height-3 m-0">{{ auto().descricaoInfracao }}</p>
      </section>

      <footer class="flex justify-content-between align-items-center pt-3 border-top-1 surface-border">
        <div class="flex flex-column">
          <span class="text-xs text-500">Valor da Autuação</span>
          <span class="text-lg font-bold text-red-600">{{ auto().valorMulta | currency: 'BRL' : 'symbol' : '1.2-2' }}</span>
        </div>

        <div class="flex gap-2">
          <p-button label="Imprimir Notificação" icon="pi pi-print" [outlined]="true" severity="secondary" (onClick)="solicitarImpressao.emit(auto().id)" />
          <p-button label="Abrir Julgamento" icon="pi pi-external-link" severity="danger" (onClick)="abrirProcesso.emit(auto().id)" />
        </div>
      </footer>
    </article>
  `
})
export class AutoInfracaoCardComponent {
  // Entradas e saídas baseadas na nova API Signal Inputs do Angular
  readonly auto = input.required<AutoInfracao>();
  readonly solicitarImpressao = output<string>();
  readonly abrirProcesso = output<string>();
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **Portal Central da AGR** (`:4200`), a adoção de componentes standalone em todas as telas eliminou a necessidade de compilar um megabundle de 12 MB. Cada cartão de serviço do portal e cada tela administrativa é roteada via `loadComponent: () => import('./...')`. O carregamento do primeiro frame caiu de 8,4 segundos para impressionantes 420 milissegundos no teste do Google Lighthouse.

---

### 2.2 Bootstrap da Aplicação com `bootstrapApplication` e `ApplicationConfig`

#### Parte 1: O que é o conceito / Analogia Didática
Pense na ignição de um motor de foguete espacial moderno versus uma locomotiva a vapor do século XIX. Na locomotiva a vapor, você precisava colocar carvão na fornalha com horas de antecedência, ferver a água, checar dezenas de válvulas manuais e engrenagens intermediárias antes que as rodas dessem o primeiro giro. No foguete moderno, um único comando eletrônico digital no painel dispara a ignição e os injetores de combustível computadorizados alimentam a câmara de combustão instantaneamente.

O antigo bootstrap baseado em `platformBrowserDynamic().bootstrapModule(AppModule)` era a locomotiva a vapor: carregava compiladores dinâmicos pesados no navegador e processava dezenas de árvores de metadados de módulos. Já o `bootstrapApplication` com `ApplicationConfig` é a ignição digital moderna: injeta os provedores globais essenciais (roteamento, cliente HTTP, animações assíncronas) diretamente no componente raiz da tela sem camadas intermediárias.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Angular tradicional ensinado na AlgaWorks e utilizado no legado da AGR, o arquivo `main.ts` inicializava o monólito:

```typescript
// Legado pesado do Angular 2 a 14
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app/app.module';

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));
```

Dentro de `AppModule`, os provedores de serviços estavam misturados com declarações visuais e importações de bibliotecas. Se um desenvolvedor configurasse um interceptor HTTP com a sintaxe arcaica `{ provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true }`, era extremamente fácil errar a ordem de execução dos interceptores ou esquecer de registrar a flag `multi: true`, fazendo com que um interceptor sobrescrevesse o outro silenciosamente.

#### Parte 3: A Solução Moderna de Elite
No Angular moderno, a inicialização é declarativa, desacoplada e fortemente tipada utilizando `bootstrapApplication` no `main.ts` e um objeto canônico `ApplicationConfig` no `app.config.ts`:

```typescript
// src/app/app.config.ts
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter, withComponentInputBinding, withViewTransitions, withInMemoryScrolling } from '@angular/router';
import { provideHttpClient, withInterceptors, withFetch } from '@angular/common/http';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { routes } from './app.routes';
import { authInterceptor } from '@core/interceptors/auth.interceptor';
import { errorLoggingInterceptor } from '@core/interceptors/error-logging.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    // Otimização de detecção de mudanças (preparatório para Zoneless)
    provideZoneChangeDetection({ eventCoalescing: true }),

    // Roteador moderno com suporte nativo a View Transitions API e binding de inputs
    provideRouter(
      routes,
      withComponentInputBinding(),
      withViewTransitions(),
      withInMemoryScrolling({ scrollPositionRestoration: 'enabled' })
    ),

    // Cliente HTTP moderno com Fetch API nativa e interceptores funcionais baseados em closures
    provideHttpClient(
      withFetch(),
      withInterceptors([authInterceptor, errorLoggingInterceptor])
    ),

    // Animações assíncronas carregadas sob demanda (evita travar o First Contentful Paint)
    provideAnimationsAsync()
  ]
};
```

E o arquivo de entrada `main.ts` torna-se uma obra-prima de concisão:

```typescript
// src/main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';

bootstrapApplication(AppComponent, appConfig)
  .catch((erro: unknown) => console.error('Falha crítica no bootstrap da aplicação:', erro));
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **Teatro-ABC** (`teatro-abc :4250`), o uso de `provideHttpClient(withFetch())` permitiu que as requisições de consulta de assentos aproveitassem a API `fetch` nativa do navegador com suporte a HTTP/2 multiplexado em direção ao backend `:8090`, reduzindo a latência de rede em 40% durante os picos de venda de ingressos para espetáculos no Oscar Niemeyer.

---

### 2.3 Injeção de Dependências Moderna com `inject()` vs Construtores Prolixos

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma oficina mecânica onde, toda vez que um mecânico fosse consertar um parafuso no motor, o supervisor da oficina fosse obrigado a desmontar a carcaça inteira do carro para passar o cabo de força pelo chassi até chegar à mão do mecânico. E se um novo equipamento elétrico fosse comprado, todos os carros da fila precisariam ter seus chassis redesenhados para acomodar o novo cabo.

Essa era a tortura da injeção de dependências tradicional por construtores (`constructor injection`). Cada serviço precisava ser declarado como parâmetro formal do construtor. Se uma classe base abstrata recebesse um novo serviço, dezenas de classes filhas que herdavam dela quebravam instantaneamente, exigindo a atualização manual de todas as chamadas `super(...)`.

A função **`inject()`** é a tomada modular universal sem fio. O componente ou composable conecta-se ao serviço no momento e no local exato em que ele é necessário, sem tocar no construtor da classe e sem exigir herança burocrática.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No código legado da AGR, era frequente encontrar classes de componentes com construtores quilométricos:

```typescript
// O pesadelo da injeção via construtor no legado
@Component({ selector: 'app-auto-infracao-detalhe', template: '...' })
export class AutoInfracaoDetalheComponent extends BaseCadastroComponent {
  constructor(
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private fb: FormBuilder,
    private authService: AuthService,
    private autoService: AutoInfracaoService,
    private mensagemService: MessageService,
    private confirmacaoService: ConfirmationService,
    private relatorioService: RelatorioService,
    private cdr: ChangeDetectorRef
  ) {
    super(router, authService, mensagemService); // Quebrava se a classe base mudasse!
  }
}
```

Qualquer refatoração na classe base abstrata `BaseCadastroComponent` exigia alterar mais de 40 arquivos `.ts` espalhados pelo repositório. Além disso, era impossível injetar dependências dentro de funções puras ou *composables*, forçando os desenvolvedores a criar classes utilitárias complexas para comportamentos reutilizáveis simples.

#### Parte 3: A Solução Moderna de Elite
No padrão moderno de elite, a injeção é declarativa e realizada diretamente nos atributos da classe com `inject()`. Além disso, viabiliza-se a criação de **Composables Funcionais** que encapsulam lógica de ciclo de vida e estado:

```typescript
import { inject, DestroyRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { Observable } from 'rxjs';

/**
 * Composable Funcional Enterprise: Vincula parâmetro de rota diretamente a um fluxo tipado.
 */
export function injectRouteParam(paramName: string): string {
  const route = inject(ActivatedRoute);
  const valor = route.snapshot.paramMap.get(paramName);
  if (!valor) {
    throw new Error(`Parâmetro de rota obrigatório ausente: '${paramName}'`);
  }
  return valor;
}

/**
 * Composable Funcional Enterprise: Autolimpeza de subscrições vinculada ao ciclo de vida.
 */
export function injectAutoCleanup() {
  const destroyRef = inject(DestroyRef);
  return <T>(source$: Observable<T>) => source$.pipe(takeUntilDestroyed(destroyRef));
}
```

E no componente consumidor:

```typescript
import { Component, inject } from '@angular/core';
import { AutoInfracaoService } from '@fiscalizacao/services/auto-infracao.service';
import { injectRouteParam, injectAutoCleanup } from '@core/composables/di-composables';

@Component({
  selector: 'app-auto-detalhe',
  standalone: true,
  template: `<h1>Auto de Infração: {{ idAuto }}</h1>`
})
export class AutoDetalheComponent {
  // Injeção cirúrgica sem construtor
  private readonly autoService = inject(AutoInfracaoService);
  private readonly autoCleanup = injectAutoCleanup();

  // Extração limpa via composable
  readonly idAuto = injectRouteParam('id');
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **Portal Web Central** (`:4200`), essa técnica viabilizou a criação do composable `injectUserSession()`, que injeta de forma transparente o token JWT, as permissões do fiscal e o contexto da empresa selecionada (`subUsers`) em qualquer componente do portal sem acoplamento a hierarquias de herança de classes.

---

## PILAR 3: Reatividade com Signals & Controle de Fluxo (`@if`, `@for`, `@defer`)

### 3.1 Primitivas Reativas Fundamentais: `signal()`, `computed()` e `effect()`

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma orquestra sinfônica composta por 70 músicos tocando em uníssono. Na era clássica do Zone.js, o maestro (framework) não sabia exatamente qual instrumento desafinou quando uma nota soou estranha. Por via das dúvidas, a cada segundo o maestro parava a orquestra inteira, descia do tablado e checava instrumento por instrumento — violinos, tímpanos, trompetes, oboés e harpas — perguntando para cada músico individualmente se a nota dele havia mudado. Isso é o **Change Detection tradicional com Zone.js**: um esforço computacional desmedido, cego e constante.

Os **Angular Signals** funcionam como se cada instrumento da orquestra tivesse um afinador digital iluminado acoplado diretamente à partitura do maestro. Quando o primeiro violino troca de acorde, apenas o sensor do violino acende uma luz verde no painel central do maestro. O maestro olha para o painel e sabe instantaneamente: "apenas o primeiro violino mudou, os outros 69 músicos continuam rigorosamente iguais". Não há interrupção da orquestra, não há varredura desnecessária e a renderização é cirúrgica na velocidade física da luz.

#### Parte 2: A Dor Histórica / O Desastre do Legado
O Angular clássico dependia integralmente da biblioteca **Zone.js**. O Zone.js realizava um procedimento intrusivo denominado *monkey patching*: ele sobrescrevia todas as APIs assíncronas do navegador (`setTimeout`, `setInterval`, `addEventListener`, `fetch`, `XMLHttpRequest`).

Toda vez que o usuário clicava em um botão, digitava uma letra em um campo de texto ou recebia uma resposta HTTP da API, o Zone.js disparava o ciclo `ApplicationRef.tick()`. O Angular iniciava uma varredura completa da árvore de componentes, do nó raiz (`AppComponent`) até a última folha, comparando os valores anteriores de cada expressão do template com os novos valores para decidir se renderizava ou não.

Em telas densas como o painel de fiscalização da AGR — contendo tabelas com centenas de linhas, menus laterais e gráficos de monitoramento —, o navegador ficava sobrecarregado. Fiscais em tablets de campo sofriam com quedas bruscas na taxa de quadros (menos de 15 FPS), travamentos nas digitações e esgotamento rápido da bateria do dispositivo móvel.

#### Parte 3: A Solução Moderna de Elite
O Angular Signals introduz três primitivas fundamentais que permitem ao framework saber com precisão atômica quais nós do DOM dependem de quais dados, viabilizando o modo **Zoneless Angular**:

1. **`signal<T>(valor)`**: Uma caixa reativa que armazena um valor síncrono. Pode ser lido chamando `meuSinal()` e alterado de forma pura via `meuSinal.set(novoValor)` ou `meuSinal.update(v => v + 1)`.
2. **`computed<T>(fn)`**: Um sinal derivado calculado funcionalmente a partir de outros sinais. Possui **memoização automática**: só é recalculado quando os sinais dos quais ele depende sofrerem mutação real. Se o valor não mudar, ele retorna o cache instantaneamente sem reexecutar a função de cálculo.
3. **`effect(fn)`**: Uma função reativa que executa efeitos colaterais (como sincronização com `sessionStorage`, logs analíticos ou operações na API do DOM) sempre que os sinais lidos dentro dela sofrem alteração.

Abaixo está o exemplo canônico demonstrando as três primitivas operando em harmonia na gestão de assentos do Teatro-ABC:

```typescript
import { Component, signal, computed, effect } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface AssentoTeatro {
  readonly id: string;
  readonly numero: number;
  readonly fileira: string;
  readonly valor: number;
  readonly selecionado: boolean;
}

@Component({
  selector: 'app-reserva-assentos-teatro',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="p-4 surface-card border-round shadow-2">
      <h2 class="text-xl font-bold mb-3">Bilheteria do Teatro-ABC: Centro Cultural Oscar Niemeyer</h2>

      <div class="flex gap-4 mb-4">
        <div class="text-600 font-medium">Assentos Selecionados: <span class="text-900 font-bold">{{ totalAssentosSelecionados() }}</span></div>
        <div class="text-600 font-medium">Investimento Total: <span class="text-green-600 font-bold">{{ valorTotalCalculado() | currency: 'BRL' }}</span></div>
        <div class="text-600 font-medium">Desconto Institucional Aplicado: <span class="text-blue-600 font-bold">{{ percentualDesconto() }}%</span></div>
      </div>

      <div class="grid grid-cols-5 gap-2">
        @for (assento of assentos(); track assento.id) {
          <button
            type="button"
            [class.bg-green-500]="assento.selecionado"
            [class.text-white]="assento.selecionado"
            [class.surface-200]="!assento.selecionado"
            class="p-3 border-round border-none font-bold cursor-pointer transition-colors"
            (click)="alternarSelecaoAssento(assento.id)"
          >
            {{ assento.fileira }}{{ assento.numero }}
          </button>
        }
      </div>
    </div>
  `
})
export class ReservaAssentosTeatroComponent {
  // 1. Sinal Primário de Estado Síncrono
  readonly assentos = signal<readonly AssentoTeatro[]>([
    { id: 'A1', numero: 1, fileira: 'A', valor: 80.0, selecionado: false },
    { id: 'A2', numero: 2, fileira: 'A', valor: 80.0, selecionado: false },
    { id: 'A3', numero: 3, fileira: 'A', valor: 80.0, selecionado: false },
    { id: 'B1', numero: 1, fileira: 'B', valor: 60.0, selecionado: false },
    { id: 'B2', numero: 2, fileira: 'B', valor: 60.0, selecionado: false }
  ]);

  // 2. Sinais Computados Puros com Memoização Inteligente
  readonly totalAssentosSelecionados = computed(() => {
    return this.assentos().filter(a => a.selecionado).length;
  });

  readonly percentualDesconto = computed(() => {
    const qtd = this.totalAssentosSelecionados();
    if (qtd >= 4) return 20; // Desconto família/grupo
    if (qtd >= 2) return 10;
    return 0;
  });

  readonly valorTotalCalculado = computed(() => {
    const subtotal = this.assentos()
      .filter(a => a.selecionado)
      .reduce((soma, a) => soma + a.valor, 0);
    const desconto = (subtotal * this.percentualDesconto()) / 100;
    return subtotal - desconto;
  });

  constructor() {
    // 3. Efeito Colateral Declarativo com Rastreamento Automático de Dependências
    effect(() => {
      const qtd = this.totalAssentosSelecionados();
      const total = this.valorTotalCalculado();
      console.info(`[Auditoria Teatro-ABC] Carrinho atualizado: ${qtd} poltronas selecionadas. Total líquido: R$ ${total.toFixed(2)}`);
      sessionStorage.setItem('carrinho_reserva_assentos', JSON.stringify({ qtd, total }));
    });
  }

  alternarSelecaoAssento(id: string): void {
    this.assentos.update(lista =>
      lista.map(a => a.id === id ? { ...a, selecionado: !a.selecionado } : a)
    );
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **Teatro-ABC** (`teatro-abc :4250`), o mapa de poltronas da Grande Sala de Espetáculos (com mais de 1.200 assentos) foi convertido para Signals. Quando um espectador clica em uma cadeira na fileira H, apenas o nó SVG correspondente àquela cadeira no DOM é redesenhado, eliminando qualquer repintura dos outros 1.199 assentos.

---

### 3.2 O Fim dos Memory Leaks por Subscrições Manuais RxJS (`takeUntilDestroyed` & `toSignal`)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que você contratou um serviço de assinatura de um jornal impresso diário. Você morou naquela casa por seis meses e depois mudou-se para outra cidade. Se você não cancelar a assinatura formalmente na central do jornal antes de partir, o entregador continuará jogando exemplares no quintal da casa vazia todos os dias. Com o passar dos meses, o quintal ficará soterrado por pilhas de jornais acumulados, bloqueando os portões e apodrecendo no chão.

Uma subscrição manual em Observable (`.subscribe()`) sem o devido cancelamento é exatamente o entregador jogando jornais na casa abandonada. Quando o usuário navega para outra tela, o componente é destruído visualmente, mas o callback RxJS continua registrado na memória da máquina. O Garbage Collector do navegador não consegue liberar o componente porque o stream retém referências a ele, gerando o famigerado **Vazamento de Memória** (*Memory Leak*).

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento tradicional ensinado em cursos legados, o gerenciamento de subscrições era repleto de armadilhas. 

Na aula `1029_FAS_16.3-fazendo-requisicao-com-get-e-recebendo-o-retorno.txt` da AlgaWorks, a solução ensinada para simplificar a vida do aluno foi converter tudo para Promises via `.toPromise()`:

> *"Essa chamada do método Get retorna um objeto do tipo Observable, WLtecaRxJS, ou seja, RxJS. A gente vai converter esse retorno para uma promise, para deixar mais simples para a gente. E para fazer isso, é só chamar o método ToPromise. Mas, veja, esse método não existe, observa? Bom, não tem esse operador, por isso a gente precisa importar aqui em cima... E quando essa chamada HTTP for feita e a promessa for resolvida, a gente vai receber aqui uma resposta... inclusive, a gente vai retornar aqui uma promise. Uma promise de qualquer coisa que ene [Promise<any>]."* (`1029_FAS_16.3`)

**As Duas Dores Históricas**:
1. O `.toPromise()` destruía o cancelamento de requisições: se o usuário clicasse no menu e saísse da página antes da resposta do servidor, a Promise continuava executando e tentando manipular elementos de tela que já não existiam mais. Além disso, o operador foi formalmente removido do RxJS 7+.
2. Quando desenvolvedores utilizavam `.subscribe()` diretamente no `ngOnInit()`, raramente implementavam o padrão do `Subject` com `takeUntil(this.destroy$)` no `ngOnDestroy()`, pois exigia escrever mais de 15 linhas de código burocrático em cada componente.

**O Desastre nos Sistemas da AGR**:
No módulo de **Fiscalização Web** (`:4203`), os fiscais consultavam a listagem de autos, entravam nos detalhes de uma autuação, voltavam para a listagem e repetiam o processo dezenas de vezes durante a jornada de trabalho. A cada entrada na tela, novas subscrições eram criadas e nunca liberadas. Após 40 minutos de uso contínuo, a aba do Google Chrome consumia 2.8 GB de memória RAM e travava com a mensagem de erro do navegador: `Out of Memory: Aw, Snap!`.

#### Parte 3: A Solução Moderna de Elite
No Angular moderno, os vazamentos de memória foram erradicados através de duas ferramentas de primeira classe:

1. **`takeUntilDestroyed()`**: Um operador RxJS inteligente que se conecta diretamente ao contexto de destruição (`DestroyRef`) do componente ou serviço, cancelando a subscrição automaticamente assim que o componente é desmontado, sem necessidade de implementar `ngOnDestroy()`.
2. **`toSignal()`**: Converte um Observable diretamente em um Signal, gerenciando sua subscrição de forma transparente e síncrona.

```typescript
import { Component, inject } from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import { AutoInfracaoService } from '@fiscalizacao/services/auto-infracao.service';

@Component({
  selector: 'app-monitor-fiscalizacao',
  standalone: true,
  template: `
    <div class="card p-4">
      <h3>Radar Rodoviário em Tempo Real</h3>
      @if (autosRecentes(); as lista) {
        <p>Total de autuações recentes carregadas: {{ lista.length }}</p>
      } @else {
        <p>Conectando ao radar de fiscalização...</p>
      }
    </div>
  `
})
export class MonitorFiscalizacaoComponent {
  private readonly autoService = inject(AutoInfracaoService);

  // Conversão direta de Observable para Signal com autodescadastro nativo!
  // Elimina 100% da necessidade de .subscribe() manual e previne memory leaks.
  readonly autosRecentes = toSignal(this.autoService.obterAutosUltimaHora$(), {
    initialValue: []
  });
}
```

E para casos onde o Observable precisa ser mantido (ex: websockets ou listeners de eventos contínuos):

```typescript
import { Component, OnInit, inject, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { WebSockFiscalService } from '@fiscalizacao/services/websocket-fiscal.service';

@Component({
  selector: 'app-alertas-blitz',
  standalone: true,
  template: `<div>Alertas de Campo em Operação</div>`
})
export class AlertasBlitzComponent implements OnInit {
  private readonly wsService = inject(WebSockFiscalService);
  private readonly destroyRef = inject(DestroyRef);

  ngOnInit(): void {
    this.wsService.conectarFluxoAlertas$()
      .pipe(
        // O takeUntilDestroyed garante o unsubscribe imediato na destruição do componente!
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe(alerta => {
        console.info('Novo veículo irregular detectado no leitor de OCR:', alerta);
      });
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Fiscalização Web** (`fiscalizacao web :4203`), a substituição de todos os `.subscribe()` soltos por `toSignal()` e `takeUntilDestroyed()` estabilizou o consumo de memória RAM dos navegadores dos fiscais em menos de 120 MB constantes durante jornadas ininterruptas de 12 horas de blitz.

---

### 3.3 A Nova Sintaxe de Controle de Fluxo Embutido (`@if`, `@for`, `@switch`)

#### Parte 1: O que é o conceito / Analogia Didática
Pense na diferença entre falar a sua língua nativa com fluência natural versus conversar por meio de um aplicativo de tradução simultânea que exige digitar a frase, aguardar o processamento na nuvem e reproduzir um áudio robótico com segundos de atraso.

A nova sintaxe de controle de fluxo embutido (`@if`, `@for`, `@switch`) é a gramática nativa do compilador Angular. As antigas diretivas estruturais (`*ngIf`, `*ngFor`) eram o aplicativo de tradução: exigiam que o compilador transformasse cada `*ngIf` em um elemento invisível `<ng-template [ngIf]="...">`, instanciando diretivas e manipulando a árvore de visualização com alto custo de memória e processamento. O controle nativo é resolvido diretamente no parser do template, gerando instruções de máquina diretas para o motor do navegador.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Angular 2 ao 16, as diretivas estruturais sofriam de problemas crônicos:

1. **A Dor do `*ngFor` sem `trackBy`**:
   No código padrão ensinado nos cursos legados, tabelas e listas eram escritas simplesmente como:
   `<tr *ngFor="let item of itens">...</tr>`.
   Sem a função explícita de `trackBy`, toda vez que o array sofria uma atualização (ex: uma nova página de dados carregada da API), o Angular não conseguia associar quais elementos da lista eram os mesmos. Consequentemente, ele **destruía e recriava todos os elementos do DOM da tabela**, causando um tremor visual perceptível na tela (*flickering*), perda de foco no teclado e alto consumo de CPU.
2. **A Dor do `@empty` Inexistente**:
   Para exibir uma mensagem de lista vazia no legado, era necessário duplicar código com múltiplos `*ngIf` concorrentes:
   ```html
   <div *ngIf="itens && itens.length > 0">...</div>
   <div *ngIf="!itens || itens.length === 0">Nenhum registro encontrado</div>
   ```

#### Parte 3: A Solução Moderna de Elite
A nova sintaxe integrada é concisa, oferece tipagem estrita de variáveis de bloco e torna o rastreamento (`track`) de itens obrigatoriamente explícito no `@for`:

```html
<section class="p-4 surface-card border-round shadow-1">
  <header class="flex justify-content-between align-items-center mb-3">
    <h2 class="text-xl font-bold text-900 m-0">Linhas de Transporte Intermunicipal de Passageiros</h2>
    <span class="text-sm text-500">Monitoramento AGR Regular (:4202)</span>
  </header>

  <!-- Controle Condicional de Elite com @if / @else if / @else -->
  @if (carregando()) {
    <div class="flex justify-content-center p-5">
      <span class="text-primary font-bold">Consultando banco de dados de frotas...</span>
    </div>
  } @else if (erroCarregamento()) {
    <div class="p-3 bg-red-100 text-red-700 border-round mb-3">
      <strong>Falha de Comunicação:</strong> Não foi possível sincronizar as linhas regulares.
    </div>
  } @else {
    <!-- Loop Estrutural de Alta Performance com @for e Bloco Nativo @empty -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
      @for (linha of linhasRegulares(); track linha.codigoLinha) {
        <article class="p-3 surface-border border-1 border-round hover:surface-100 transition-colors">
          <div class="flex justify-content-between align-items-start">
            <div>
              <span class="font-mono text-xs text-primary font-bold">{{ linha.codigoLinha }}</span>
              <h4 class="text-base font-bold text-800 m-0 mt-1">{{ linha.origem }} ➔ {{ linha.destino }}</h4>
              <p class="text-xs text-500 m-0 mt-1">Concessionária: {{ linha.concessionaria }}</p>
            </div>

            <!-- Seleção Multivalorada Estrita com @switch -->
            @switch (linha.situacaoOperacional) {
              @case ('REGULAR') {
                <span class="p-tag p-tag-success">Operação Normal</span>
              }
              @case ('INTERROMPIDA') {
                <span class="p-tag p-tag-danger">Linha Suspensa</span>
              }
              @case ('EM_MANUTENCAO') {
                <span class="p-tag p-tag-warning">Desvio de Rota</span>
              }
              @default {
                <span class="p-tag p-tag-info">Sob Auditoria</span>
              }
            }
          </div>
        </article>
      } @empty {
        <!-- Renderização Imediata e Declarativa de Estado Vazio -->
        <div class="col-span-full p-5 text-center text-500 surface-50 border-round">
          <i class="pi pi-search text-3xl mb-2 text-400 block"></i>
          Nenhuma linha de transporte cadastrada para a região metropolitana selecionada.
        </div>
      }
    </div>
  }
</section>
```

**Principais Ganhos**:
1. **Obrigatoriedade do `track`**: O compilador impede o build se o parâmetro `track` for omitido, garantindo que o algoritmo de reconciliação de DOM mantenha 60 FPS constantes mesmo ao atualizar listas com milhares de itens.
2. **Type Narrowing no Template**: Dentro do bloco `@if (veiculo(); as v)`, a variável `v` é automaticamente tipada e livre de `null` ou `undefined`.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Transporte Regular da AGR** (`regular web :4202`), o controle de fluxo integrado reduziu o tempo de renderização de grades com mais de 350 linhas de ônibus intermunicipais de 380ms para apenas 18ms durante a digitação de filtros de pesquisa.

---

### 3.4 Deferrable Views (`@defer`) para Otimização de Performance e Bundle Splitting

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que você vai viajar e contrata uma transportadora para levar suas malas. Em vez de colocar tudo em um único caminhão gigantesco de 30 toneladas que entope as ruas do bairro e demora 6 horas para descarregar, a transportadora moderna envia uma moto expressa com a sua escova de dentes e sua troca de roupa básica para você entrar na casa nova imediatamente. Os móveis pesados e as caixas de ferramentas só serão despachados pelo caminhão no momento exato em que você abrir a porta do quarto ou solicitar a montagem da estante.

As **Deferrable Views (`@defer`)** no Angular 17/18+ são a logística expressa da web. Elas permitem que componentes pesados — como visualizadores de PDF, bibliotecas de gráficos estatísticos ou mapas interativos — não façam parte do pacote principal de carregamento da página. O código desses componentes só é baixado pela rede quando o elemento estiver prestes a entrar na área visível da tela (*viewport*) ou quando o usuário interagir com um botão específico.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Angular clássico, a divisão de código (*code splitting*) só podia ser feita no nível de rotas através do `loadChildren`. 

Se uma tela de detalhes contivesse uma aba secundária escondida com um componente pesado (por exemplo, um visualizador de laudos fotográficos em alta resolução ou um gráfico de barras complexo), o código JavaScript daquele componente era baixado e compilado logo na entrada da página, mesmo que 90% dos usuários nunca clicassem naquela aba. Isso penalizava drasticamente as métricas Core Web Vitals do Google, especialmente o **Largest Contentful Paint (LCP)** e o **Total Blocking Time (TBT)**.

#### Parte 3: A Solução Moderna de Elite
O bloco `@defer` oferece uma sintaxe declarativa completa com suporte a gatilhos avançados (`viewport`, `interaction`, `hover`, `timer`, `idle`), além de blocos integrados para carregamento, estado de reserva e tratamento de falhas:

```html
<section class="p-4 surface-card border-round shadow-2 mt-4">
  <h3 class="text-xl font-bold mb-3">Laudos Fotográficos Probatórios da Fiscalização Rodoviária</h3>

  <!-- O código do componente pesado só é requisitado quando ele entra na tela do fiscal! -->
  @defer (on viewport; prefetch on idle) {
    <app-galeria-fotos-infracao [fotos]="fotosInfracao()" />
  } @placeholder (minimum 500ms) {
    <!-- Esqueleto exibido antes de iniciar o carregamento -->
    <div class="p-4 surface-100 border-round">
      <p-skeleton width="100%" height="180px" />
      <p class="text-xs text-500 mt-2 text-center">Role a página para visualizar os laudos fotográficos da autuação.</p>
    </div>
  } @loading (after 150ms; minimum 400ms) {
    <!-- Indicador de progresso enquanto o chunk JavaScript é baixado pela rede -->
    <div class="flex justify-content-center align-items-center p-5">
      <p-progressSpinner styleClass="w-3rem h-3rem" />
      <span class="ml-3 text-sm font-medium text-600">Baixando módulo de fotos de alta resolução...</span>
    </div>
  } @error {
    <!-- Tratamento resiliente em caso de queda de conexão 4G/5G em rodovia -->
    <div class="p-3 bg-red-50 text-red-700 border-round border-1 border-red-200">
      <i class="pi pi-exclamation-triangle mr-2"></i>
      Não foi possível carregar o módulo visual de fotos. Verifique a cobertura de rede do terminal móvel.
    </div>
  }
</section>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Fiscalização Web** (`fiscalizacao web :4203`), os laudos fotográficos de infrações de veículos continham bibliotecas pesadas de zoom e marcação de imagens. O encapsulamento dessa galeria com `@defer (on viewport; prefetch on idle)` reduziu o peso inicial da página de autuação em 65%, permitindo que a tela abrisse instantaneamente mesmo em áreas rurais de Goiás com sinal de celular instável.

No **Teatro-ABC** (`teatro-abc :4250`), os gráficos estatísticos de faturamento da bilheteria na tela administrativa só são baixados quando o gestor clica na aba "Relatório Executivo de Ocupação", poupando dados dos usuários móveis.

---

## PILAR 4: Formulários Reativos Tipados & PrimeNG Moderno

### 4.1 Typed Reactive Forms (`FormGroup`, `FormControl`, `FormArray`)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine preencher uma declaração de imposto de renda em um formulário de papel onde os campos fossem apenas linhas em branco sem rótulos. Você poderia escrever um número de telefone no campo de renda bruta, desenhar um emoji no campo de CPF e assinar no lugar do valor dedutível. O auditor da receita só descobriria os erros meses depois ao tentar processar a declaração.

O formulário reativo tipado (**Typed Reactive Forms**) do Angular moderno é o software da Receita Federal com validação de dados em tempo real: ele sabe com precisão cirúrgica quais campos existem, qual o tipo exato de cada valor (`string`, `number`, `boolean`), quais campos são obrigatórios e proíbe matematicamente o envio de formulários incompletos ou corrompidos.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Do Angular 2 ao 13, os formulários reativos eram inteiramente desprovidos de tipagem estática (*untyped*). O tipo `FormGroup` operava como uma caixa preta onde qualquer chamada a `form.get('meuCampo')?.value` retornava invariavelmente `any`.

Se um desenvolvedor alterasse o nome do controle no template de `placaVeiculo` para `placa`, o TypeScript não acusava nenhum erro. O método continuava retornando `null` ou `undefined`, e o payload enviado via POST para a API chegava incompleto. 

Além disso, ao resetar o formulário com `form.reset()`, todos os controles passavam a conter o valor `null`, quebrando propriedades que esperavam strings vazias ou números zeros e causando falhas de runtime na renderização de máscaras e cálculos monetários.

#### Parte 3: A Solução Moderna de Elite
Com a introdução dos **Typed Forms** no Angular 14+, complementados pelo utilitário `NonNullableFormBuilder`, os formulários ganharam contratos estritos:

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, NonNullableFormBuilder, Validators, FormControl, FormGroup } from '@angular/forms';
import { InputTextModule } from 'primeng/inputtext';
import { InputNumberModule } from 'primeng/inputnumber';
import { ButtonModule } from 'primeng/button';
import { PlacaValidator } from '@fiscalizacao/validators/placa.validator';
import { CpfValidator } from '@fiscalizacao/validators/cpf.validator';

/**
 * Contrato de Tipagem Estrita do Formulário de Auto de Infração.
 */
export interface FormularioAutoInfracao {
  placa: FormControl<string>;
  cpfCondutor: FormControl<string>;
  renavam: FormControl<string>;
  valorMulta: FormControl<number>;
  observacoes: FormControl<string>;
}

@Component({
  selector: 'app-cadastro-auto-infracao',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    InputTextModule,
    InputNumberModule,
    ButtonModule
  ],
  template: `
    <form [formGroup]="formulario" (ngSubmit)="salvarAutuacao()" class="p-fluid surface-card p-4 border-round shadow-2">
      <h3 class="text-xl font-bold mb-4">Lavratura Oficial de Auto de Infração (AGR Fiscalização)</h3>

      <div class="field mb-3">
        <label for="placa" class="font-bold">Placa do Veículo (Padrão Antigo ou Mercosul)</label>
        <input id="placa" type="text" pInputText formControlName="placa" placeholder="Ex: NGM-4580 ou BRA2E19" class="uppercase" />
        @if (formulario.controls.placa.invalid && formulario.controls.placa.touched) {
          <small class="p-error block mt-1">Informe uma placa válida no padrão DENATRAN/Mercosul.</small>
        }
      </div>

      <div class="field mb-3">
        <label for="cpf" class="font-bold">CPF do Condutor Abordado</label>
        <input id="cpf" type="text" pInputText formControlName="cpfCondutor" placeholder="000.000.000-00" />
        @if (formulario.controls.cpfCondutor.invalid && formulario.controls.cpfCondutor.touched) {
          <small class="p-error block mt-1">CPF matematicamente inválido (Módulo 11).</small>
        }
      </div>

      <div class="field mb-3">
        <label for="valorMulta" class="font-bold">Valor da Penalidade Regulamentar (R$)</label>
        <p-inputNumber id="valorMulta" formControlName="valorMulta" mode="currency" currency="BRL" locale="pt-BR" />
        @if (formulario.controls.valorMulta.invalid && formulario.controls.valorMulta.touched) {
          <small class="p-error block mt-1">O valor da penalidade deve ser superior a zero.</small>
        }
      </div>

      <p-button type="submit" label="Emitir Notificação Fiscal" icon="pi pi-check" severity="danger" [disabled]="formulario.invalid" />
    </form>
  `
})
export class CadastroAutoInfracaoComponent implements OnInit {
  private readonly fb = inject(NonNullableFormBuilder);

  // Formulário estritamente tipado: qualquer erro de campo é detectado na compilação!
  formulario!: FormGroup<FormularioAutoInfracao>;

  ngOnInit(): void {
    this.formulario = this.fb.group<FormularioAutoInfracao>({
      placa: this.fb.control('', [Validators.required, PlacaValidator.validar()]),
      cpfCondutor: this.fb.control('', [Validators.required, CpfValidator.validar()]),
      renavam: this.fb.control('', [Validators.required, Validators.pattern(/^\d{9,11}$/)]),
      valorMulta: this.fb.control(0, [Validators.required, Validators.min(0.01)]),
      observacoes: this.fb.control('')
    });
  }

  salvarAutuacao(): void {
    if (this.formulario.invalid) {
      this.formulario.markAllAsTouched();
      return;
    }

    // Extração 100% tipada sem necessidade de castings!
    const dadosFormulario = this.formulario.getRawValue();
    console.info('Enviando auto de infração autenticado para agrfiscalservice :8083:', dadosFormulario);
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Fiscalização Web** (`fiscalizacao web :4203`), os formulários tipados impedem que autuações com campos numéricos nulos sejam submetidas para o `agrfiscalservice :8083`. No **CADU Web** (`cadu web :4201`), garantem que todos os campos obrigatórios da apólice de seguro de responsabilidade civil dos ônibus sejam preenchidos antes de permitir a emissão da licença de viagem.

---

### 4.2 Validadores Assíncronos e de Negócio Customizados (Validação de CPF e Validação de Placa Mercosul)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o caixa eletrônico do banco quando você insere um envelope para depósito. Primeiro, o sensor mecânico da boca do caixa mede as dimensões físicas do envelope para garantir que não há objetos estranhos (validação síncrona). Em seguida, o sistema conecta-se instantaneamente à rede central do banco de dados para verificar se o número da conta destinatária existe e não está bloqueada judicialmente (validação assíncrona). Somente se as duas etapas forem aprovadas é que o comprovante é impresso.

Validadores síncronos e assíncronos no Angular seguem exatamente esse protocolo de dupla esteira: validadores síncronos realizam checagens matemáticas puras e instantâneas no próprio cliente (como conferência de dígitos verificadores de CPF e sintaxe de placas), enquanto validadores assíncronos consultam a API via rede para garantir a consistência do registro antes da gravação final.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No código legado, validações de documentos oficiais brasileiros eram implementadas através de expressões regulares simplistas no HTML (`pattern="[0-9]{11}"`) ou deixadas exclusivamente para o backend.

Isso gerava dois problemas graves:
1. O usuário preenchia um formulário com mais de 30 campos e digitava um CPF inválido como `111.111.111-11`. O front-end permitia clicar em "Salvar", enviava a requisição pela rede e, 2 segundos depois, a página inteira recarregava com mensagem de erro do servidor, limpando campos já digitados e gerando frustração extrema.
2. Em consultas de duplicidade (ex: verificar se uma placa já estava autuada naquele mesmo dia), os desenvolvedores disparavam chamadas HTTP a cada letra digitada pelo fiscal no campo de texto, sobrecarregando o backend com centenas de requisições desnecessárias.

#### Parte 3: A Solução Moderna de Elite
Abaixo estão as implementações canônicas, puras e matematicamente rigorosas dos validadores corporativos:

```typescript
import { AbstractControl, ValidationErrors, ValidatorFn, AsyncValidatorFn } from '@angular/forms';
import { Observable, of, timer } from 'rxjs';
import { map, switchMap, catchError } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';

/**
 * Validador Oficial de CPF com Cálculo Exaustivo de Módulo 11 (DV1 e DV2).
 */
export class CpfValidator {
  static validar(): ValidatorFn {
    return (control: AbstractControl<string | null>): ValidationErrors | null => {
      const valor = control.value;
      if (!valor) {
        return null; // O validador Validators.required cuida de campo vazio
      }

      const cpfLimpo = valor.replace(/\D/g, '');

      if (cpfLimpo.length !== 11) {
        return { cpfInvalido: { motivo: 'O CPF deve possuir exatamente 11 dígitos numéricos.' } };
      }

      // Rejeita padrões conhecidos com todos os dígitos idênticos
      if (/^(\d)\1{10}$/.test(cpfLimpo)) {
        return { cpfInvalido: { motivo: 'CPF com dígitos repetidos é matematicamente inválido.' } };
      }

      // Cálculo do primeiro dígito verificador (DV1)
      let soma1 = 0;
      for (let i = 0; i < 9; i++) {
        soma1 += parseInt(cpfLimpo.charAt(i), 10) * (10 - i);
      }
      let resto1 = (soma1 * 10) % 11;
      let dv1Esperado = (resto1 === 10 || resto1 === 11) ? 0 : resto1;

      if (dv1Esperado !== parseInt(cpfLimpo.charAt(9), 10)) {
        return { cpfInvalido: { motivo: 'Primeiro dígito verificador inconsistente.' } };
      }

      // Cálculo do segundo dígito verificador (DV2)
      let soma2 = 0;
      for (let i = 0; i < 10; i++) {
        soma2 += parseInt(cpfLimpo.charAt(i), 10) * (11 - i);
      }
      let resto2 = (soma2 * 10) % 11;
      let dv2Esperado = (resto2 === 10 || resto2 === 11) ? 0 : resto2;

      if (dv2Esperado !== parseInt(cpfLimpo.charAt(10), 10)) {
        return { cpfInvalido: { motivo: 'Segundo dígito verificador inconsistente.' } };
      }

      return null;
    };
  }
}

/**
 * Validador Bivalente de Placas Veiculares Brasileiras (Padrão Antigo e Mercosul).
 */
export class PlacaValidator {
  private static readonly REGEX_PLACA_ANTIGA = /^[A-Z]{3}-\d{4}$/;
  private static readonly REGEX_PLACA_MERCOSUL = /^[A-Z]{3}\d[A-Z]\d{2}$/;

  static validar(): ValidatorFn {
    return (control: AbstractControl<string | null>): ValidationErrors | null => {
      const valor = control.value;
      if (!valor) {
        return null;
      }

      const placaNormalizada = valor.trim().toUpperCase();
      const ehAntiga = PlacaValidator.REGEX_PLACA_ANTIGA.test(placaNormalizada);
      const ehMercosul = PlacaValidator.REGEX_PLACA_MERCOSUL.test(placaNormalizada);

      if (!ehAntiga && !ehMercosul) {
        return {
          placaInvalida: {
            valorInformado: valor,
            formatoEsperado: 'AAA-9999 (Clássico) ou AAA9A99 (Mercosul)',
            motivo: 'A placa informada não atende ao padrão regulatório nacional do DENATRAN.'
          }
        };
      }

      return null;
    };
  }

  /**
   * Converte instantaneamente uma placa clássica (AAA-9999) para a equivalente Mercosul (AAA9A99).
   * Mapeamento do segundo dígito numérico: 0->A, 1->B, 2->C, 3->D, 4->E, 5->F, 6->G, 7->H, 8->I, 9->J.
   */
  static converterParaMercosul(placaAntiga: string): string {
    const limpa = placaAntiga.replace('-', '').toUpperCase();
    if (!/^[A-Z]{3}\d{4}$/.test(limpa)) {
      return placaAntiga;
    }
    const mapeamentoLetras = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    const prefixo = limpa.substring(0, 3);
    const primeiroDigito = limpa.charAt(3);
    const segundoDigito = parseInt(limpa.charAt(4), 10);
    const sufixoFinal = limpa.substring(5, 7);
    const letraMercosul = mapeamentoLetras[segundoDigito] ?? 'A';
    return `${prefixo}${primeiroDigito}${letraMercosul}${sufixoFinal}`;
  }

  /**
   * Validador Assíncrono com Debounce para checagem de bloqueio judicial de veículo.
   */
  static verificarBloqueioJudicial(http: HttpClient): AsyncValidatorFn {
    return (control: AbstractControl<string | null>): Observable<ValidationErrors | null> => {
      const valor = control.value;
      if (!valor || control.pristine) {
        return of(null);
      }

      // Aguarda 400ms após o fiscal parar de digitar antes de consultar a API
      return timer(400).pipe(
        switchMap(() => http.get<{ bloqueado: boolean; motivo?: string }>(`/api/v1/veiculos/bloqueio?placa=${valor}`)),
        map(resposta => {
          if (resposta.bloqueado) {
            return { veiculoBloqueadoJudicialmente: { motivo: resposta.motivo || 'Ordem judicial ativa' } };
          }
          return null;
        }),
        catchError(() => of(null)) // Resiliência em caso de falha de conexão
      );
    };
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No **CADU Web** (`cadu web :4201`), o validador `PlacaValidator` é utilizado para cadastrar ônibus de turismo e transporte escolar, garantindo que placas migradas para o padrão Mercosul sejam devidamente convertidas e validadas antes do envio para o `cadastrounicoservice :8081`.

---

### 4.3 Grid Industrial com PrimeNG Moderno: `p-table` com Paginação e Ordenação Server-Side vs o Antipadrão Legado `p-dataTable`

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma biblioteca pública contendo 500.000 livros em seu acervo central. Se um leitor chegar ao balcão e pedir para ver a lista de livros sobre direito regulatório, o bibliotecário não vai carregar 500.000 livros nos braços e despejá-los em cima da mesa do leitor, quebrando a mesa e impedindo qualquer um de se mover na sala. O bibliotecário consulta o fichário e traz para a mesa exatamente os 10 primeiros livros correspondentes à pesquisa. Se o leitor quiser ver mais, ele pede a próxima página de 10 livros.

A paginação e ordenação no servidor (*lazy loading*) com o componente moderno `<p-table>` do PrimeNG é o bibliotecário eficiente: o navegador recebe e renderiza exclusivamente as 10 ou 20 linhas que o usuário está visualizando no momento, mantendo a aplicação ultrarrápida e o consumo de memória baixo, mesmo que o banco de dados da agência possua milhões de registros.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No treinamento tradicional ensinado na AlgaWorks (aula `967_FAS_10.5`) e reproduzido nas primeiras versões dos sistemas da AGR, utilizava-se o antigo componente `<p-dataTable>` em conjunto com o sistema de layout PrimeUI Grid (`ui-g`):

Na aula `967_FAS_10.5-adicionando-uma-tabela-de-dados.txt`:
> *"Mas antes, vamos colocar uma nova div aqui com uma classe da Grid, UID [ui-g], que é a Grid do PrimeMD. Da mesma forma que a gente já fez em uma aula anterior. E dentro da Grid, deixa eu ver aqui, dentro dessa Grid, eu vou colocar uma classe UI de 12 [ui-g-12], para ocupar 12 colunas. E aqui dentro, eu vou colocar a minha tabela de dados... E o que a gente vai usar é o DataTable, esse aqui... Então, vamos lá para o código. A gente tem que usar esse componente Petraço DataTable [p-dataTable]. Petraço DataTable, fecho ele... Dentro do P DataTable, eu coloco aqui P traço Colum [p-column]... Opa, deu um erro... não encontrou propriedade DataTable... Tem que importar ele dentro do NG module... DataTableModule..."* (`967_FAS_10.5`)

**O Colapso em Produção**:
1. O `<p-dataTable>` carregava todas as linhas na memória do cliente e dependia de reflexão de strings no atributo `field="propriedade"`, sem suporte a tipagem estrita de templates.
2. Quando a base de autos de infração da AGR atingiu 80.000 registros, a tentativa do `<p-dataTable>` de instanciar nós de DOM para todos os registros travava instantaneamente o navegador Google Chrome dos fiscais, exigindo reinicialização forçada do computador.
3. Pouco tempo depois, a equipe do PrimeNG descontinuou sumariamente o `<p-dataTable>` e lançou o `<p-table>` (TurboTable), quebrando o layout de centenas de sistemas que ficaram congelados em versões legadas do Angular por medo do custo de refatoração.

#### Parte 3: A Solução Moderna de Elite
A solução moderna implementa o `<p-table>` com `[lazy]="true"`, carregamento sob demanda através de eventos tipados `TableLazyLoadEvent`, esqueletos de carregamento (*skeleton loading*) e integração nativa com Signals:

```typescript
import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { CommonModule, DatePipe, CurrencyPipe } from '@angular/common';
import { TableModule, TableLazyLoadEvent } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { TagModule } from 'primeng/tag';
import { SkeletonModule } from 'primeng/skeleton';
import { AutoInfracaoService } from '@fiscalizacao/services/auto-infracao.service';
import { AutoInfracao, Page } from '@domain/models/fiscalizacao.models';

@Component({
  selector: 'app-tabela-autos-infracao',
  standalone: true,
  imports: [
    CommonModule,
    DatePipe,
    CurrencyPipe,
    TableModule,
    ButtonModule,
    TagModule,
    SkeletonModule
  ],
  template: `
    <div class="card p-4 surface-card border-round shadow-2">
      <div class="flex justify-content-between align-items-center mb-4">
        <div>
          <h2 class="text-2xl font-bold text-900 m-0">Autos de Infração Lavrados</h2>
          <p class="text-500 m-0 mt-1">Gestão de autuações rodoviárias em tempo real (AGR Fiscalização :4203)</p>
        </div>
        <div class="flex align-items-center gap-3">
          <span class="font-medium text-600">Total Auditado: {{ totalRegistros() }} autos</span>
          <p-button label="Nova Autuação" icon="pi pi-plus" severity="danger" />
        </div>
      </div>

      <p-table
        [value]="autos()"
        [lazy]="true"
        (onLazyLoad)="carregarDados($event)"
        [paginator]="true"
        [rows]="tamanhoPagina()"
        [totalRecords]="totalRegistros()"
        [loading]="carregando()"
        [rowsPerPageOptions]="[10, 25, 50]"
        [showCurrentPageReport]="true"
        currentPageReportTemplate="Exibindo {first} a {last} de {totalRecords} autos"
        styleClass="p-datatable-striped p-datatable-sm"
        responsiveLayout="scroll"
      >
        <ng-template pTemplate="header">
          <tr>
            <th pSortableColumn="numeroAuto">Número Auto <p-sortIcon field="numeroAuto" /></th>
            <th pSortableColumn="placaVeiculo">Placa <p-sortIcon field="placaVeiculo" /></th>
            <th pSortableColumn="dataHoraLavratura">Data/Hora <p-sortIcon field="dataHoraLavratura" /></th>
            <th pSortableColumn="valorMulta">Valor (R$) <p-sortIcon field="valorMulta" /></th>
            <th>Status Processual</th>
            <th class="text-center">Ações</th>
          </tr>
        </ng-template>

        <ng-template pTemplate="body" let-auto>
          <tr>
            <td class="font-bold">{{ auto.numeroAuto }}</td>
            <td>
              <span class="p-tag p-tag-warning font-mono">{{ auto.placaVeiculo }}</span>
            </td>
            <td>{{ auto.dataHoraLavratura | date: 'dd/MM/yyyy HH:mm' }}</td>
            <td class="font-bold text-right">{{ auto.valorMulta | currency: 'BRL' : 'symbol' : '1.2-2' }}</td>
            <td>
              <p-tag [value]="auto.estadoProcessual.status" [severity]="obterSeveridadeStatus(auto.estadoProcessual.status)" />
            </td>
            <td class="text-center">
              <p-button icon="pi pi-eye" [rounded]="true" [text]="true" severity="info" />
              <p-button icon="pi pi-print" [rounded]="true" [text]="true" severity="secondary" />
            </td>
          </tr>
        </ng-template>

        <ng-template pTemplate="loadingbody">
          @for (item of [1, 2, 3, 4, 5]; track item) {
            <tr>
              <td><p-skeleton width="8rem" /></td>
              <td><p-skeleton width="6rem" /></td>
              <td><p-skeleton width="10rem" /></td>
              <td><p-skeleton width="7rem" /></td>
              <td><p-skeleton width="5rem" /></td>
              <td><p-skeleton width="4rem" /></td>
            </tr>
          }
        </ng-template>

        <ng-template pTemplate="emptymessage">
          <tr>
            <td colspan="6" class="text-center p-5 text-500">
              <i class="pi pi-inbox text-4xl mb-3 block text-300"></i>
              Nenhum auto de infração localizado para os filtros informados.
            </td>
          </tr>
        </ng-template>
      </p-table>
    </div>
  `
})
export class TabelaAutosInfracaoComponent implements OnInit {
  private readonly autoService = inject(AutoInfracaoService);

  // Estados reativos com Angular Signals
  readonly autos = signal<readonly AutoInfracao[]>([]);
  readonly totalRegistros = signal<number>(0);
  readonly carregando = signal<boolean>(false);
  readonly paginaAtual = signal<number>(0);
  readonly tamanhoPagina = signal<number>(10);

  // Sinal computado para monitoramento do montante financeiro da página atual
  readonly montanteFinanceiroPagina = computed(() => {
    return this.autos().reduce((acumulador, item) => acumulador + item.valorMulta, 0);
  });

  ngOnInit(): void {
    this.carregarDados({ first: 0, rows: 10 });
  }

  carregarDados(evento: TableLazyLoadEvent): void {
    this.carregando.set(true);
    const pagina = (evento.first ?? 0) / (evento.rows ?? 10);
    const tamanho = evento.rows ?? 10;
    const ordenacao = evento.sortField as string | undefined;
    const direcao = evento.sortOrder === 1 ? 'ASC' : 'DESC';

    this.autoService.listarPaginado(pagina, tamanho, ordenacao, direcao).subscribe({
      next: (resposta: Page<AutoInfracao>) => {
        this.autos.set(resposta.content);
        this.totalRegistros.set(resposta.totalElements);
        this.paginaAtual.set(resposta.number);
        this.tamanhoPagina.set(resposta.size);
        this.carregando.set(false);
      },
      error: () => {
        this.carregando.set(false);
        this.autos.set([]);
      }
    });
  }

  obterSeveridadeStatus(status: string): 'success' | 'info' | 'warning' | 'danger' | 'secondary' {
    switch (status) {
      case 'QUITADO': return 'success';
      case 'AUTUADO': return 'warning';
      case 'JULGADO': return 'danger';
      case 'CANCELADO': return 'secondary';
      default: return 'info';
    }
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No módulo de **Fiscalização Web** (`fiscalizacao web :4203`) e no **Receita Web** (`receita web :4212`), o grid industrial com `p-table` lazy loading permite que a agência manipule uma base histórica com mais de 380.000 autos de infração e conciliações contábeis de TRCF sem qualquer perda de performance no navegador, com consumo de CPU estável e resposta de transição de páginas em menos de 100 milissegundos.

---

## Roteiro de Governança & Migração de Sistemas Legados para a Arquitetura de Elite

Para garantir a transição ordenada de sistemas legados construídos sob a arquitetura de `NgModules` clássicos (como o Portal 1 e Portal 2 da AGR) para a arquitetura de ponta baseada em **Standalone Components**, **Signals** e **TypeScript Estrito**, as equipes de engenharia devem seguir rigorosamente o plano de migração em 6 etapas:

1. **Ativação da Blindagem no `tsconfig.json`**:
   - Ativar `strict: true`, `noImplicitAny: true` e `strictNullChecks: true`.
   - Adicionar `noUncheckedIndexedAccess: true` e `exactOptionalPropertyTypes: true`.
   - Corrigir todas as ocorrências de variáveis tipadas como `any`, substituindo-as por contratos de domínio ricos e `unknown` acompanhado de *Type Guards*.
2. **Execução do Schematics de Migração Standalone**:
   - Rodar o comando oficial `ng generate @angular/core:standalone`.
   - Selecionar a opção 1 (*Convert all components, directives and pipes to standalone*).
   - Selecionar a opção 2 (*Remove unnecessary NgModule classes*).
   - Selecionar a opção 3 (*Bootstrap the application using standalone APIs*).
3. **Substituição do `HttpModule` e Interceptores Legados**:
   - Eliminar `HttpClientModule` de qualquer módulo residual ou arquivo de configuração.
   - Adotar `provideHttpClient(withFetch(), withInterceptors([authInterceptor, errorLoggingInterceptor]))` no `app.config.ts`.
   - Reescrever interceptores baseados em classes para interceptores funcionais baseados em closures `HttpInterceptorFn`.
4. **Erradicação de Memory Leaks e Adoção de Signals**:
   - Varrer a base de código por chamadas soltas a `.subscribe()`.
   - Adotar `takeUntilDestroyed()` em streams que persistem além de uma única emissão.
   - Migrar fluxos de estado síncrono de componentes para `signal()` e `computed()`.
   - Converter requisições assíncronas para Signals via `toSignal()`.
5. **Modernização dos Templates com Controle de Fluxo Embutido**:
   - Executar o schematics oficial `ng generate @angular/core:control-flow`.
   - Auditar todos os blocos `@for`, assegurando que o parâmetro `track` utilize identificadores únicos e imutáveis (`track item.id` ou `track item.codigo`).
   - Aplicar `@defer (on viewport; prefetch on idle)` em componentes pesados e abas secundárias.
6. **Migração do PrimeNG Legado para PrimeNG Moderno**:
   - Substituir qualquer menção remanescente a `<p-dataTable>` por `<p-table>` com lazy loading server-side obrigatório.
   - Remover classes legadas de grid CSS (`ui-g`, `ui-g-12`) e adotar Flexbox nativo, CSS Grid ou classes utilitárias modernas do Tailwind CSS / PrimeFlex.

Com esse padrão arquitetural, as aplicações governamentais da AGR e os projetos greenfield como o Teatro-ABC alcançam o mais alto padrão de robustez, confiabilidade, velocidade e manutenibilidade da engenharia de software contemporânea.
