# Módulo 01: Fundamentos Web, Arquitetura de Interface & JavaScript Vanilla de Alta Performance

---

## Sumário Executivo & Manifesto da Engenharia Vanilla

O desenvolvimento de software para a web moderna atingiu um nível de saturação e dependência onde bibliotecas e frameworks de centenas de megabytes são frequentemente introduzidos antes mesmo de se compreender a mecânica elementar do ambiente de execução: o navegador web. Em sistemas governamentais de missão crítica — como o ecossistema regulatório da **Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos (AGR)** e sistemas de alta concorrência como a bilhetagem do **Teatro-ABC** —, a introdução cega de camadas de abstração cobra um preço altíssimo em consumo de memória, lentidão de renderização, vulnerabilidades de segurança e custos exorbitantes de manutenção.

Este módulo estabelece os alicerces fundamentais da computação na web sob uma ótica de engenharia rigorosa e do zero absoluto. Aqui, nenhuma linha de código se apoia em "mágica" de terceiros. Analisamos detalhadamente a física da máquina: a construção da árvore de renderização (DOM e CSSOM), a mecânica do motor de estilo e cálculo de layout, a física de execução do JavaScript (Call Stack, Heap, Web APIs, Microtasks e Macrotasks orquestradas pelo Event Loop), e os padrões arquiteturais de interfaces resilientes, acessíveis e seguras.

Cada conceito deste documento é dissecado em quatro camadas mandatórias:
1. **O Conceito Explicado de Forma Simples (Analogia Intuitiva do Mundo Real):** Fixação imediata do modelo mental.
2. **A Dor Histórica / O Desastre do Legado:** Análise forense das falhas reais em produção, com citações diretas do acervo de 1.625 aulas da AlgaWorks (*Web Design Responsivo* - WDR e *Mergulho no JavaScript* - MJS) e dos sistemas legados da AGR.
3. **A Solução Moderna de Elite:** Código vanilla limpo, robusto, completo e executável, em estrita conformidade com os padrões da W3C, ECMAScript 2024+ e WCAG 2.1 nível AA.
4. **Vínculo Direto com o AGR-Docs / Teatro-ABC:** Aplicação concreta nos microsserviços reais do Estado de Goiás (`portalservice :8080`, `cadastrounicoservice :8081`, `agrfiscalservice :8083`, `receitaservice :8092`) e no greenfield `teatro-abc :8090`.

---

## 1. HTML5 Semântico, Arquitetura de Documento & Acessibilidade Corporativa (WCAG 2.1 AA)

### 1.1 Eliminação da "Div Soup" e Adoção de Landmarks Estruturais

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um hospital de emergência onde todas as portas fossem idênticas: folhas lisas de compensado sem placas, sem cores, sem maçanetas diferenciadas e sem qualquer sinalização visual ou tátil. Médicos, socorristas e pacientes em desespero precisariam abrir porta por porta para descobrir onde fica a sala de triagem, a UTI, o sanitário ou o centro cirúrgico. Um documento HTML construído exclusivamente com tags `<div>` genéricas é exatamente esse hospital às escuras.

O HTML5 semântico é a sinalização universal padronizada da arquitetura do documento. A tag `<header>` é a recepção identificada na entrada do edifício; `<nav>` são os corredores principais equipados com placas direcionais; `<main>` é o complexo hospitalar onde ocorrem os procedimentos centrais; `<article>` é a ficha médica autônoma de um paciente que tem sentido completo mesmo se destacada da pasta; `<aside>` são os murais informativos com avisos de utilidade pública; e `<footer>` é a saída do prédio contendo as orientações regulamentares e telefones de emergência.

Ao substituir blocos opacos por tags semânticas, você não está apenas organizando código para humanos; você está instruindo diretamente o motor do navegador a preencher a **Accessibility Tree** (Árvore de Acessibilidade), permitindo que tecnologias assistivas naveguem com precisão milimétrica.

```
ESTRUTURA DE DOCUMENTO: SOPA DE DIVS (CAOS) vs LANDMARKS SEMÂNTICOS (ELITE)

      [ Legado: Div Soup ]                         [ Elite: HTML5 Semântico ]
┌───────────────────────────────┐              ┌─────────────────────────────────┐
│ <div id="topo">               │              │ <header role="banner">          │
│   <div class="menu">          │              │   <nav aria-label="Principal">  │
│     <div class="item">...     │              │     <ul><li><a ...>             │
├───────────────────────────────┤              ├─────────────────────────────────┤
│ <div id="conteudo-corpo">     │              │ <main id="conteudo-principal">  │
│   <div class="bloco-noticia"> │              │   <article aria-labelledby="...">│
│   <div class="lateral">       │              │   <aside aria-label="Alertas">  │
├───────────────────────────────┤              ├─────────────────────────────────┤
│ <div id="rodape">             │              │ <footer role="contentinfo">     │
└───────────────────────────────┘              └─────────────────────────────────┘
 (Opaco, sem hierarquia semântica)              (Navegável por teclado e leitores)
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
Durante a era dos anos 2000 a 2015, a indústria web mergulhou na chamada "Div Soup". No curso *Web Design Responsivo* (WDR), na aula `14_WDR - 2.9 - Elementos estruturais.txt`, o instrutor Thiago disseca a rotina que imperava no desenvolvimento legado: antes do HTML5, todo desenvolvedor criava estruturas como `<div id="header">`, `<div id="nav">` ou `<div class="content">`. 

O impacto real dessa prática em sistemas governamentais é catastrófico. Quando um usuário cego ou com baixa visão acessa um portal com leitor de tela (como NVDA, JAWS ou VoiceOver), o leitor varre a página procurando pontos de referência (*landmarks*). Em uma página dominada pela div soup, o leitor não encontra atalhos e é obrigado a ler sequencialmente cada nó de texto desde o topo. Se a barra institucional do governo contiver 60 links de menu, o usuário é forçado a ouvir os 60 links a cada recarregamento de página antes de conseguir ouvir o primeiro número do seu processo administrativo.

Além disso, robôs de indexação e motores de busca (como o Googlebot) rebaixam significativamente a relevância do conteúdo quando não conseguem distinguir o núcleo editorial da página de menus laterais redundantes e rodapés de copyright. No âmbito do controle externo, sistemas públicos que ignoram a semântica violam o Decreto Federal nº 5.296/2004 e a Lei Brasileira de Inclusão (Lei nº 13.146/2015), sujeitando o órgão a notificações do Ministério Público e reprovações em auditorias do Tribunal de Contas do Estado de Goiás (TCE-GO).

#### Parte 3: A Solução Moderna de Elite
A estrutura moderna adota os marcos estruturais nativos reconhecidos pelo W3C Accessible Rich Internet Applications (WAI-ARIA). Além dos landmarks, incorpora-se o link de salto de acessibilidade (*Skip to Main Content*), que permanece visualmente oculto até receber foco via tecla `Tab`.

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Painel de Fiscalização de Transporte Rodoviário Intermunicipal - AGR Goiás">
  <title>AGR - Painel Operacional de Fiscalização Rodoviária</title>
  <style>
    /* Estilos do Link de Salto de Acessibilidade (WCAG 2.1 AA) */
    .sr-only-focusable {
      position: absolute;
      top: -9999px;
      left: -9999px;
      padding: 1rem 1.5rem;
      background-color: #005a2b;
      color: #ffffff;
      font-weight: 700;
      text-decoration: none;
      border-radius: 0 0 8px 8px;
      z-index: 10000;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }

    .sr-only-focusable:focus {
      top: 0;
      left: 1rem;
      outline: 3px solid #ffcc00;
      outline-offset: 2px;
    }
  </style>
</head>
<body>
  <!-- Link de Acessibilidade para Navegação por Teclado -->
  <a href="#conteudo-principal" class="sr-only-focusable">Saltar diretamente para o conteúdo principal</a>

  <!-- Landmark: Banner Institucional do Cabeçalho -->
  <header class="cabecalho-governo" role="banner">
    <div class="cabecalho-governo__faixa-estado">
      <span class="cabecalho-governo__identificador">Governo do Estado de Goiás</span>
      <span class="cabecalho-governo__orgao">AGR - Agência Goiana de Regulação</span>
    </div>

    <!-- Landmark: Navegação Principal da Aplicação -->
    <nav class="navegacao-principal" aria-label="Menu Principal de Operações" role="navigation">
      <ul class="navegacao-principal__lista">
        <li class="navegacao-principal__item">
          <a href="/dashboard" class="navegacao-principal__link navegacao-principal__link--ativo">Painel Geral</a>
        </li>
        <li class="navegacao-principal__item">
          <a href="/blitz" class="navegacao-principal__link">Operações e Blitz</a>
        </li>
        <li class="navegacao-principal__item">
          <a href="/frotas" class="navegacao-principal__link">Consulta de Frotas</a>
        </li>
        <li class="navegacao-principal__item">
          <a href="/autos" class="navegacao-principal__link">Autos de Infração</a>
        </li>
      </ul>
    </nav>
  </header>

  <!-- Landmark: Conteúdo Principal Único da Página -->
  <main id="conteudo-principal" class="painel-fiscalizacao" role="main">
    <header class="painel-fiscalizacao__cabecalho">
      <h1>Operação Especial Rodovias Seguras - Eixo GO-020</h1>
      <p class="painel-fiscalizacao__meta">
        <strong>Data da Operação:</strong> 25/10/2026 | 
        <strong>Posto de Comando:</strong> Bela Vista de Goiás (Km 42) |
        <strong>Auditor Fiscal Coordenador:</strong> Wheslan Cardoso (Matrícula: AGR-8841)
      </p>
    </header>

    <!-- Seção de Ações Operacionais -->
    <section class="painel-fiscalizacao__secao-autos" aria-labelledby="titulo-secao-autos">
      <h2 id="titulo-secao-autos">Autos de Infração Lavrados no Turno Atual</h2>

      <!-- Artigo Autônomo Representando um Auto de Infração -->
      <article class="card-auto" aria-labelledby="auto-num-2026-00412">
        <header class="card-auto__header">
          <h3 id="auto-num-2026-00412">Auto Nº 2026/00412 - Transporte Clandestino de Passageiros</h3>
          <span class="badge badge--perigo">Veículo Apreendido (TRV Emitido)</span>
        </header>
        <div class="card-auto__conteudo">
          <dl class="card-auto__dados">
            <dt>Placa Identificada:</dt>
            <dd>NXY-8890 (Padrão Mercosul Equivalente: NXY8J90)</dd>
            <dt>Condutor Autuado:</dt>
            <dd>Carlos Eduardo Siqueira</dd>
            <dt>Empresa Concessionária / Proprietário:</dt>
            <dd>Viação e Turismo Estrela do Centro-Oeste Ltda</dd>
            <dt>Enquadramento Legal:</dt>
            <dd>Art. 18, Inciso IV da Resolução Normativa AGR nº 024/2015</dd>
          </dl>
        </div>
      </article>
    </section>

    <!-- Landmark: Barra Lateral de Informações Complementares -->
    <aside class="painel-fiscalizacao__alertas" aria-labelledby="titulo-alertas-horus">
      <h2 id="titulo-alertas-horus">Alertas Críticos da Central Hórus (OCR Rodoviário)</h2>
      <ul class="lista-alertas">
        <li class="lista-alertas__item lista-alertas__item--critico">
          <strong>Radar OCR GO-070 Km 12:</strong> Ônibus placa KEL-4401 em trânsito com Certificado de Registro Cadastral (CRC) vencido há 90 dias.
        </li>
      </ul>
    </aside>
  </main>

  <!-- Landmark: Rodapé Institucional com Informações Oficiais -->
  <footer class="rodape-governo" role="contentinfo">
    <p>&copy; 2026 Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos - AGR.</p>
    <p>Avenida Goiás, 305, Edifício Parthenon Center, Centro, Goiânia - GO | CEP: 74005-010</p>
  </footer>
</body>
</html>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `portalservice` (:8080) e Portal do Cidadão:** O portal público de serviços da AGR recebe requisições de consulta de linhas intermunicipais, certidões negativas e protocolos de defesa prévia. A implementação de marcos semânticos garante a conformidade com as diretrizes do Modelo de Acessibilidade em Governo Eletrônico (e-MAG) e com a Lei nº 13.146/2015.
- **No `teatro-abc` (:8090):** No portal de bilhetagem do Centro Cultural Oscar Niemeyer, a página do espetáculo organiza o cabeçalho no `<header>`, o catálogo de sessões e mapa de assentos no `<main>`, a sinopse teatral no `<article>`, as orientações de meia-entrada e acessibilidade física no `<aside>` e os termos de reembolso no `<footer>`.

---

### 1.2 Formulários Nativos & Validação de Borda Sem JavaScript

#### Parte 1: O que é o conceito / Analogia Didática
Imagine a portaria de um edifício comercial de 40 andares. Existem duas formas de organizar a segurança:
Na primeira forma, a catraca do térreo fica aberta e qualquer pessoa sobe no elevador sem crachá. Quando ela chega ao 38º andar e bate na porta da diretoria para assinar um contrato, o diretor abre a porta, percebe que a pessoa não trouxe o documento de identidade com foto e diz: *"Você esqueceu a identidade, pegue o elevador de volta, desça até a portaria e refaça todo o trajeto"*. O elevador fica sobrecarregado, gasta-se energia elétrica e todos perdem tempo.
Na segunda forma, o porteiro no térreo faz a conferência preliminar rigorosa: se faltar a identidade, a catraca não abre e o elevador sequer é acionado.

Os atributos nativos de validação do HTML5 (`required`, `pattern`, `inputmode`, `minlength`, `maxlength`) são o porteiro da catraca no térreo. Eles realizam a validação de borda imediatamente no cliente, antes que qualquer byte de dados seja empacotado e enviado pela rede, poupando processamento no navegador e na API de backend.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No curso *Web Design Responsivo* (WDR), nas aulas `71_WDR - 7.16 - Criando um formulário.txt` e `72_WDR - 7.17`, estuda-se o modelo primitivo da web onde campos eram quase exclusivamente `<input type="text">`. 

Em sistemas legados (como o Portal 1 da AGR construído sob mentalidade JSF/EJB dos anos 2000), o desenvolvedor precisava capturar o evento `onsubmit` do formulário e escrever scripts monolíticos de 600 linhas com dezenas de blocos repetitivos:
```javascript
// ❌ O ANTIPADRÃO DO LEGADO: SCRIPTS MONOLÍTICOS DE VALIDAÇÃO MANUAL
function validarFormularioAuto() {
  var placa = document.getElementById('placa').value;
  var renavam = document.getElementById('renavam').value;
  if (placa == null || placa == '') {
    alert('Erro: Preencha o campo Placa!');
    document.getElementById('placa').focus();
    return false;
  }
  if (renavam.length < 9) {
    alert('Erro: RENAVAM deve conter pelo menos 9 dígitos!');
    return false;
  }
  return true;
}
```
*O Desastre em Produção:* Quando auditores fiscais da AGR utilizavam tablets em viaturas rodoviárias sob sol forte, ao tocar no campo de RENAVAM ou CPF o tablet abria o teclado alfabético genérico comum. O fiscal era forçado a trocar manualmente para o teclado numérico em cada campo. Pior: se o script do `onsubmit` travasse com um `TypeError` não tratado em outro script da página, o formulário era submetido com campos em branco ou com caracteres corrompidos, inundando a base de dados do CADU com registros inválidos.

#### Parte 3: A Solução Moderna de Elite
O HTML5 introduziu a **Constraint Validation API** e atributos específicos de entrada que alteram o comportamento físico do teclado em dispositivos móveis (`inputmode="numeric"`, `inputmode="tel"`), combinados com pseudo-classes CSS modernas (`:user-invalid`, `:valid`) que exibem mensagens de erro apenas após o usuário interagir com o campo, evitando poluição visual precoce.

```html
<form class="formulario-vistoria" novalidate id="form-vistoria-cadastral">
  <fieldset class="formulario-vistoria__grupo">
    <legend class="formulario-vistoria__legenda">Identificação e Regularidade Cadastral do Veículo</legend>

    <!-- Campo de Placa com Validação por Expressão Regular -->
    <div class="campo">
      <label for="placa-veiculo" class="campo__rotulo">
        Placa do Veículo (Padrão Cinza ou Mercosul)
        <span aria-hidden="true" class="campo__obrigatorio">*</span>
      </label>
      <input
        type="text"
        id="placa-veiculo"
        name="placa"
        class="campo__controle"
        required
        maxlength="8"
        placeholder="Ex: NXY8J90 ou NXY-8890"
        pattern="^[A-Za-z]{3}-?[0-9][A-Za-z0-9][0-9]{2}$"
        aria-describedby="ajuda-placa erro-placa"
        autocomplete="off"
        style="text-transform: uppercase;"
      >
      <small id="ajuda-placa" class="campo__ajuda">Aceita formato padrão Mercosul (ABC1D23) ou padrão antigo (ABC-1234).</small>
      <span id="erro-placa" class="campo__mensagem-erro" aria-live="polite"></span>
    </div>

    <!-- Campo de RENAVAM com Teclado Numérico Nativo Mobile -->
    <div class="campo">
      <label for="renavam-veiculo" class="campo__rotulo">
        Código RENAVAM
        <span aria-hidden="true" class="campo__obrigatorio">*</span>
      </label>
      <input
        type="text"
        id="renavam-veiculo"
        name="renavam"
        class="campo__controle"
        required
        inputmode="numeric"
        minlength="9"
        maxlength="11"
        pattern="^[0-9]{9,11}$"
        placeholder="Ex: 00984726154"
        aria-describedby="erro-renavam"
      >
      <span id="erro-renavam" class="campo__mensagem-erro" aria-live="polite"></span>
    </div>

    <!-- Campo de Capacidade com Limites Mínimo e Máximo -->
    <div class="campo">
      <label for="lotacao-veiculo" class="campo__rotulo">
        Lotação Homologada de Passageiros Sentados
        <span aria-hidden="true" class="campo__obrigatorio">*</span>
      </label>
      <input
        type="number"
        id="lotacao-veiculo"
        name="lotacao"
        class="campo__controle"
        required
        min="4"
        max="60"
        value="44"
      >
    </div>
  </fieldset>

  <div class="formulario-vistoria__acoes">
    <button type="submit" class="btn btn--primario">Validar e Consultar CADU</button>
  </div>
</form>

<style>
  /* Feedback Visual Baseado nas Pseudo-classes da Constraint Validation API */
  .campo__controle:user-invalid {
    border-color: #d32f2f;
    background-color: #fff8f8;
    outline: none;
  }

  .campo__controle:user-valid {
    border-color: #2e7d32;
    background-color: #f6fff6;
  }

  .campo__mensagem-erro {
    display: none;
    color: #d32f2f;
    font-size: 0.8125rem;
    font-weight: 600;
    margin-top: 0.25rem;
  }

  .campo__controle:user-invalid + .campo__mensagem-erro {
    display: block;
  }
</style>

<script>
  // Integração fina com a Constraint Validation API sem bibliotecas
  const formulario = document.querySelector('#form-vistoria-cadastral');
  const inputPlaca = document.querySelector('#placa-veiculo');
  const spanErroPlaca = document.querySelector('#erro-placa');

  formulario.addEventListener('submit', (evento) => {
    if (!formulario.checkValidity()) {
      evento.preventDefault(); // Impede o envio de dados inválidos
      
      if (inputPlaca.validity.valueMissing) {
        spanErroPlaca.textContent = 'A placa do veículo é de preenchimento obrigatório.';
      } else if (inputPlaca.validity.patternMismatch) {
        spanErroPlaca.textContent = 'A placa digitada não atende ao formato oficial Mercosul ou antigo.';
      }
      
      // Move o foco para o primeiro campo inválido
      const primeiroInvalido = formulario.querySelector(':invalid');
      if (primeiroInvalido) primeiroInvalido.focus();
    }
  });
</script>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `cadastrounicoservice` (:8081) e Interface do CADU (:4201):** O cadastro de veículos de transporte intermunicipal exige o preenchimento de RENAVAM, Chassi e Placa. O uso de `inputmode="numeric"` assegura que em campo o fiscal utilize diretamente o teclado de dígitos sem erros de digitação de letras em campos puramente numéricos.
- **No `teatro-abc` (:8090):** No fluxo de compra de ingressos, o campo de quantidade de ingressos utiliza `min="1" max="6"` prevenindo compras abusivas por cambistas diretamente no navegador antes da submissão à API de bilhetagem.

---

### 1.3 Acessibilidade Corporativa (WCAG 2.1 Nível AA, WAI-ARIA & Foco por Teclado)

#### Parte 1: O que é o conceito / Analogia Didática
A rampa de acesso instalada na entrada da sede da AGR não existe exclusivamente para atender servidores que utilizam cadeira de rodas. A mesma rampa atende pais com carrinhos de bebê, entregadores transportando caixas pesadas de processos administrativos e auditores que temporariamente sofreram uma lesão no joelho e usam muletas.

A acessibilidade na web segue exatamente o mesmo princípio de design universal. Quando um desenvolvedor constrói uma interface que responde perfeitamente ao teclado (`Tab`, `Shift+Tab`, `Enter`, `Espaço`, `Escape`), ele atende pessoas cegas que utilizam leitores de tela, programadores avançados que trabalham sem mouse para obter velocidade cirúrgica e usuários com deficiências motoras severas. Um elemento que só pode ser acionado com o cursor do mouse é um lance de escadas íngreme sem corrimão em um prédio público.

#### Parte 2: A Dor Histórica / O Desastre do Legado
O vício mais frequente do desenvolvimento legado foi a substituição de botões semânticos por elementos de bloco estilizados:
```html
<!-- ❌ O DESASTRE DO FALSO BOTÃO NO LEGADO -->
<div class="botao-salvar" onclick="salvarProcesso()">
  <span>Salvar Processo</span>
</div>
```
*A Autópsia Forense:* Leitores de tela ignoram a `<div>` como elemento clicável porque ela não possui o papel funcional de botão (`role="button"`), não participa da ordem natural de tabulação do documento (`tabindex="0"`) e o navegador não sintetiza o evento de clique quando o usuário pressiona as teclas `Enter` ou `Barra de Espaço`. 

Além do problema de navegação por teclado, o uso de esquemas de cores de baixo contraste — como texto cinza claro `#888888` sobre fundo cinza `#E0E0E0` — causava reprovação sistemática de portais estaduais em auditorias da Controladoria-Geral do Estado (CGE-GO) e do TCE-GO. A norma **WCAG 2.1 nível AA** impõe uma taxa mínima de contraste de **4.5:1** para texto normal e **3:1** para texto grande (18pt ou 14pt em negrito) e componentes funcionais de interface.

#### Parte 3: A Solução Moderna de Elite
A solução de nível sênior utiliza tags nativas `<button type="button">`, atributos ARIA de estado dinâmico (`aria-expanded`, `aria-controls`), indicadores de foco claros com `:focus-visible` e testes de contraste rigorosos.

```html
<!-- Componente Sanfonado (Accordion) de Evidências Fotográficas de Blitz -->
<div class="sanfona-fiscalizacao">
  <h3 class="sanfona-fiscalizacao__titulo">
    <button
      type="button"
      id="gatilho-evidencias-412"
      class="sanfona-fiscalizacao__gatilho"
      aria-expanded="false"
      aria-controls="painel-evidencias-412"
    >
      <span class="sanfona-fiscalizacao__rotulo">Evidências Fotográficas do Auto nº 2026/00412 (3 Anexos)</span>
      <span class="sanfona-fiscalizacao__icone" aria-hidden="true">▼</span>
    </button>
  </h3>

  <div
    id="painel-evidencias-412"
    class="sanfona-fiscalizacao__painel"
    role="region"
    aria-labelledby="gatilho-evidencias-412"
    hidden
  >
    <ul class="lista-anexos">
      <li class="lista-anexos__item">
        <figure>
          <img
            src="/evidencias/2026-00412-pneu-liso.webp"
            alt="Pneu dianteiro esquerdo do ônibus placa NXY-8890 totalmente desgastado, com arames da lona de aço aparentes na banda de rodagem"
            width="640"
            height="360"
          >
          <figcaption>Foto 01: Estado crítico do pneu dianteiro na barreira da GO-020.</figcaption>
        </figure>
      </li>
    </ul>
  </div>
</div>

<style>
  /* Estilização com Foco Acessível Obrigatório (WCAG 2.1 Critério 2.4.7) */
  .sanfona-fiscalizacao__gatilho {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    padding: 1rem 1.25rem;
    font-size: 1rem;
    font-weight: 700;
    color: #0f172a;
    background-color: #f1f5f9;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    cursor: pointer;
    text-align: left;
  }

  /* O pseudo-seletor :focus-visible aplica o anel de foco APENAS ao navegar por teclado */
  .sanfona-fiscalizacao__gatilho:focus-visible {
    outline: 3px solid #005a2b; /* Verde Goiás com contraste 5.8:1 */
    outline-offset: 3px;
    box-shadow: 0 0 0 6px rgba(0, 90, 43, 0.2);
  }

  .sanfona-fiscalizacao__painel {
    padding: 1.25rem;
    background-color: #ffffff;
    border: 1px solid #cbd5e1;
    border-top: none;
    border-radius: 0 0 6px 6px;
  }

  .sanfona-fiscalizacao__painel[hidden] {
    display: none;
  }
</style>

<script>
  // Comportamento Reativo com ARIA State Management sem Dependências
  const botaoSanfona = document.querySelector('#gatilho-evidencias-412');
  const painelSanfona = document.querySelector('#painel-evidencias-412');
  const iconeSanfona = botaoSanfona.querySelector('.sanfona-fiscalizacao__icone');

  botaoSanfona.addEventListener('click', () => {
    const expandido = botaoSanfona.getAttribute('aria-expanded') === 'true';
    
    // Alterna o estado acessível
    botaoSanfona.setAttribute('aria-expanded', String(!expandido));
    painelSanfona.hidden = expandido;
    iconeSanfona.textContent = expandido ? '▼' : '▲';
  });

  // Fechamento Rápido via Tecla Escape para Conformidade de Teclado
  botaoSanfona.addEventListener('keydown', (evento) => {
    if (evento.key === 'Escape' && botaoSanfona.getAttribute('aria-expanded') === 'true') {
      botaoSanfona.setAttribute('aria-expanded', 'false');
      painelSanfona.hidden = true;
      iconeSanfona.textContent = '▼';
    }
  });
</script>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `agrfiscalservice` (:8083) e Telas de Autos de Infração:** O auditor em gabinete analisa laudos de blitz com múltiplos painéis expansíveis de evidências. A presença de `aria-expanded` e de legendas descritivas nas imagens anexadas (`alt` com descrição forense precisa) permite que auditores portadores de deficiência visual auditem os processos administrativos.
- **No `teatro-abc` (:8090):** No mapa de poltronas, assentos reservados para cadeirantes possuem o atributo `aria-label="Poltrona C12 - Assento Acessível para Cadeirante (PCD) - Valor: R$ 40,00"`, garantindo que o cliente com deficiência visual compre o ingresso correto sem necessitar de auxílio de terceiros.

---

### 1.4 O Ciclo Físico de Renderização do Navegador & Layout Thrashing

#### Parte 1: O que é o conceito / Analogia Didática
Pense em uma gráfica de alta velocidade imprimindo a edição matinal de um jornal. O diagramador monta o texto e as fotos (construção do DOM e CSSOM), a mesa de cálculo define a largura exata de cada coluna de papel (fase de Layout/Reflow), os cilindros passam a tinta no papel (fase de Paint) e as esteiras organizam as camadas de cores (fase de Composite).

Imagine que, no meio da rotação das máquinas imprimindo 10.000 exemplares, o gerente de produção entrasse na fábrica, parasse a esteira a cada parágrafo impresso, colocasse uma régua física para medir a altura do papel (`offsetHeight`) e em seguida mandasse o operador alterar a fonte em 2 milímetros (`element.style.height`). Toda a linha de produção entraria em colapso mecânico. Na renderização web, esse desastre chama-se **Layout Thrashing** (ou Reflow Síncrono Forçado).

```
O PIPELINE FÍSICO DE RENDERIZAÇÃO CRÍTICA (CRITICAL RENDERING PATH)

┌─────────┐   ┌───────────┐
│  HTML   │   │    CSS    │
└────┬────┘   └─────┬─────┘
     │              │
     ▼              ▼
┌─────────┐   ┌───────────┐
│   DOM   │   │   CSSOM   │
└────┬────┘   └─────┬─────┘
     │              │
     └──────┬───────┘
            ▼
     ┌─────────────┐
     │ Render Tree │  (Apenas nós visíveis com estilos computados)
     └──────┬──────┘
            ▼
     ┌─────────────┐
     │   Layout    │  (Cálculo geométrico: coordenadas X, Y, Largura, Altura)
     │  (Reflow)   │  ⚠️ Ler propriedades geométricas aqui força recálculo síncrono!
     └──────┬──────┘
            ▼
     ┌─────────────┐
     │    Paint    │  (Rasterização: pixels de texto, cores de fundo, sombras)
     └──────┬──────┘
            ▼
     ┌─────────────┐
     │  Composite  │  (GPU: sobreposição de camadas aceleradas: transform, opacity)
     └─────────────┘
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento com bibliotecas como jQuery ou scripts vanilla desestruturados, era comum encontrar laços de repetição que alternavam leituras e escritas no DOM:
```javascript
// ❌ O CRIME DO LAYOUT THRASHING NO LEGADO
const cards = document.querySelectorAll('.card-infracao');
for (let i = 0; i < cards.length; i++) {
  // LEITURA: Força o navegador a calcular o layout geométrico imediatamente!
  const altura = cards[i].offsetHeight;
  // ESCRITA: Invalida o layout que o navegador acabou de calcular!
  cards[i].style.height = (altura + 15) + 'px';
  // Na próxima volta do loop, o navegador é forçado a recalcular tudo de novo (N vezes!)
}
```
*Impacto Real em Produção:* Nas telas de monitoramento de frotas e blitz da AGR, que exibiam 200 veículos interceptados, esse loop forçava 200 reflows consecutivos no mesmo frame. A taxa de quadros por segundo caía de 60 FPS para 3 FPS, travando o tablet do fiscal por 4 a 6 segundos e disparando o alerta de *"A página não está respondendo"* no navegador.

#### Parte 3: A Solução Moderna de Elite
A engenharia de alta performance separa rigorosamente a fase de leitura em lote (*Batch Read*) da fase de escrita em lote (*Batch Write*), agendando a mutação visual para o momento ideal do pipeline através de `window.requestAnimationFrame()`:

```javascript
// ✅ EQUALIZAÇÃO DE ALTURAS COM BATCH READ/WRITE E ZERO LAYOUT THRASHING
function equalizarAlturasCards(seletorCards) {
  const elementos = Array.from(document.querySelectorAll(seletorCards));
  if (elementos.length === 0) return;

  // FASE 1: LEITURA EM LOTE (Batch Read)
  // O navegador calcula o layout exatamente UMA vez para responder a todas as consultas
  const alturas = elementos.map(el => el.getBoundingClientRect().height);
  const alturaMaxima = Math.max(...alturas);

  // FASE 2: ESCRITA EM LOTE (Batch Write)
  // A escrita é agendada para o início do próximo ciclo de renderização do monitor (V-Sync)
  window.requestAnimationFrame(() => {
    elementos.forEach(el => {
      el.style.minHeight = `${alturaMaxima}px`;
    });
  });
}

// Otimização Extrema para Animações: Uso exclusivo de propriedades de composição (GPU)
function animarCardDestaque(elemento) {
  // ✅ NÃO altere top, left, width ou height (provocam Layout e Paint caros)
  // ✅ Altere transform e opacity (afetam apenas a fase de Composite na GPU)
  elemento.style.transform = 'translateY(-4px) scale(1.02)';
  elemento.style.opacity = '0.95';
  elemento.style.transition = 'transform 0.2s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.2s ease';
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `agrfiscalservice` (:8083) / Módulo Frontend (:4203):** Na visualização de blitz em tempo real, painéis que exibem informações de veículos interceptados utilizam o padrão de leitura e escrita em lote com `requestAnimationFrame`, permitindo rolagem fluida e expansão de cards a 60 FPS estáveis mesmo em dispositivos com hardware modesto.
- **No `teatro-abc` (:8090):** Durante a seleção e destaque interativo de poltronas na plateia, os efeitos visuais utilizam `transform: scale(...)`, garantindo que a renderização de 1.200 assentos não dispare reflows globais na página.

---

## 2. CSS3 Moderno, Metodologia BEM & Layout Engine (Flexbox e Grid)

### 2.1 O Caos do CSS Legado & Metodologia BEM (Especificidade Plana 0-1-0)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma empresa com 5.000 funcionários onde ninguém usa crachá e a única forma de chamar alguém fosse pela localização física transitória: *"Aquele analista sentado na quarta cadeira da terceira fileira da sala sul do segundo andar"*. Se a mesa mudar de lugar, se uma divisória for derrubada ou se o analista for tomar um café no térreo, ninguém mais consegue localizá-lo.

Seletores CSS como `#conteudo-principal ul li a` são essa descrição geográfica frágil. A Metodologia **BEM (Block, Element, Modifier)** é o crachá funcional definitivo: não importa onde o botão esteja localizado (no cabeçalho, na barra lateral ou dentro de um modal), ele possui um nome autodescritivo único e imutável (`.botao-acao--sucesso`), eliminando qualquer dependência da árvore genealógica de onde ele reside.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Com Citações Literais da AlgaWorks)
Na aula `50_WDR_6_2_Caos_no_CSS_porque_uma_metodologia_é_importante_.txt`, o instrutor Thiago expõe a autópsia da guerra de especificidade em projetos que não adotam metodologia:
> *"Geralmente quando você coloca `!important`, a maioria das vezes os desenvolvedores que usam isso sem conhecer muito fazem porque perderam totalmente o caminho, não sabem mais o que está fazendo e para funcionar tem que colocar... não tem reusabilidade, não dá para compartilhar código."* (`50_WDR_6_2`)

Ele demonstra visualmente o colapso estrutural quando um componente estilizado com seletores de descendência acoplados (`#conteudo ul li`) é movido para o rodapé:
> *"Olha o que vai acontecer, nossa que bagunça... não pode mover uma parte do código, isso aqui não deveria ser independente? ... Ela não é independente, ela é dependente do local que ela está. E se você tem algo que é dependente do local que ela está, você não consegue mover isso para outro lugar sem quebrar nada."* (`50_WDR_6_2`)

E complementa com a tragédia das colisões de classes genéricas como `.novo`:
> *"Como a gente não tem um padrão de nomenclaturas, a gente usou um mesmo nome que acabou se colidindo e afetando de forma que é algo imprevisível... a gente não sabia que ia acontecer isso. Uma solução seria colocar outro nome: `novo2`... ou seja, você está batalhando demais com as especificidades."* (`50_WDR_6_2`)

*O Cenário de Desastre na AGR:* Nas folhas de estilo do Portal 1 da AGR, encontravam-se seletores com especificidade monstruosa como `body #wrapper #content-box .formulario table tbody tr td.campo input[type="text"]` (especificidade `0-2-3-5`). Quando a equipe precisava ajustar um padding de 4px em uma tela específica, a regra não aplicava a menos que adicionassem `!important`. Em poucos anos, o arquivo CSS principal acumulou mais de 400 declarações `!important`, inviabilizando qualquer manutenção.

```
A GUERRA DE ESPECIFICIDADE DO LEGADO vs O PADRÃO BEM DE ESPECIFICIDADE PLANA

  [ O Pesadelo do Legado ]                              [ A Solução BEM de Elite ]
  Seletor:                                               Seletor:
  #portal .box ul li a.ativo { ... }                     .menu-fiscalizacao__link--ativo { ... }
  
  Cálculo de Especificidade:                             Cálculo de Especificidade:
  IDs: 1 | Classes: 2 | Tags: 3                           IDs: 0 | Classes: 1 | Tags: 0
  Score: (1-2-3) -> Altíssima e Acoplada                 Score: (0-1-0) -> Especificidade Plana
  
  Resultado: Impossível de sobrepor sem !important       Resultado: Manutenção previsível e modular
```

#### Parte 3: A Solução Moderna de Elite
Adoção do padrão BEM com **Especificidade Plana 0-1-0**:
- **Block (`bloco`):** Entidade autônoma reutilizável (ex: `.card-auto`).
- **Element (`bloco__elemento`):** Segmento interno que não tem sentido fora do bloco (ex: `.card-auto__placa`).
- **Modifier (`bloco--modificador` ou `bloco__elemento--modificador`):** Variação de estado, tema ou comportamento (ex: `.card-auto--apreendido`, `.card-auto__status--ativo`).
- **Regra Mandatória de Engenharia:** Proibição estrita de seletores de ID (`#id`) para estilização e banimento absoluto da cláusula `!important`.

```css
/* ==========================================================================
   COMPONENTE: CARD DE AUTO DE INFRAÇÃO (PADRÃO BEM - ESPECIFICIDADE 0-1-0)
   ========================================================================== */

/* 1. BLOCO AUTÔNOMO (Score: 0-1-0) */
.card-auto {
  display: flex;
  flex-direction: column;
  padding: 1.5rem;
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-borda-md);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card-auto:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
}

/* 2. ELEMENTOS DEPENDENTES DO BLOCO (Score: 0-1-0) */
.card-auto__cabecalho {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.card-auto__numero {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--cor-texto-primaria);
}

.card-auto__corpo {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.card-auto__placa {
  font-family: var(--fonte-mono);
  font-weight: 800;
  font-size: 1.25rem;
  color: var(--cor-primaria);
}

.card-auto__status {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  font-size: 0.75rem;
  font-weight: 700;
  border-radius: 9999px;
  text-transform: uppercase;
}

/* 3. MODIFICADORES DE ESTADO E VARIAÇÃO (Score: 0-1-0) */
.card-auto__status--regular {
  background-color: #dcfce7;
  color: #15803d;
}

.card-auto__status--notificado {
  background-color: #fef9c3;
  color: #854d0e;
}

.card-auto__status--apreendido {
  background-color: #fee2e2;
  color: #991b1b;
}

/* Modificador do Bloco: Auto com recurso judicial pendente */
.card-auto--em-recurso {
  border-left: 5px solid #2563eb;
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `agrfiscalservice` (:8083):** O bloco `.card-auto` é utilizado tanto na listagem de fiscalizações em tempo real quanto dentro da janela modal de julgamento de defesas prévias da Diretoria Colegiada. Por possuir especificidade plana `0-1-0`, ele pode ser inserido em qualquer contexto visual sem sofrer mutações e sem quebrar os estilos internos da página.
- **No `teatro-abc` (:8090):** O bloco de assento `.teatro-poltrona` possui os modificadores `.teatro-poltrona--livre`, `.teatro-poltrona--ocupada`, `.teatro-poltrona--selecionada` e `.teatro-poltrona--pcd`, operando de forma desacoplada e reutilizável em todas as salas do Centro Cultural Oscar Niemeyer.

---

### 2.2 A Morte dos Floats & Clearfix Hacks: Flexbox Unidimensional

#### Parte 1: O que é o conceito / Analogia Didática
Imagine pendurar quatro quadros na parede de uma sala amarrando balões de hélio em cada um e esticando barbantes até o chão para tentar fazê-los flutuar no mesmo alinhamento horizontal (`float: left`). Qualquer rajada de vento ou alteração no peso de uma moldura desequilibra o arranjo, derruba os quadros e exige que você coloque calços improvisados no rodapé para a parede não parecer vazia (`clearfix`).

O **CSS Flexbox** é um trilho de sustentação de precisão instalado na parede. Você encaixa os quatro quadros no trilho e o próprio sistema se encarrega de distribuir os espaçamentos uniformemente (`justify-content: space-between`), centralizar o alinhamento vertical das molduras (`align-items: center`) e criar uma segunda fileira automaticamente caso a parede encolha (`flex-wrap: wrap`).

#### Parte 2: A Dor Histórica / O Desastre do Legado (Com Citações Literais da AlgaWorks)
Na aula `34_WDR - 4.5 - Flutuando elementos.txt`, o instrutor da AlgaWorks explica a anomalia física que ocorria ao utilizar `float` para diagramação estrutural:
> *"Quando a gente especifica que um elemento está flutuando, o elemento é retirado do fluxo normal do documento. Então, mesmo que esses dois parágrafos estejam dentro da área verde, que é o artigo, ela não enxerga isso... a altura do artigo terminou antes... porque o P saiu do fluxo normal."* (`34_WDR`)

E na sequência detalha o surgimento do hack artificial de limpeza de fluxo:
> *"Esse div Clear Fix aqui, ele não é muito interessante... porque ele não é semântico, né? A gente está colocando simplesmente algo aqui para resolver um problema que o CSS que a gente colocou gerou. Ele não é semântico, ele não representa nada no documento."* (`34_WDR`)

*O Desastre do Legado:* O uso de floats gerava o colapso de altura dos containers pais (que passavam a ter altura calculada como `0px`), empurrando rodapés para cima do conteúdo editorial. As páginas eram povoadas por elementos parasitas como `<div class="clearfix" style="clear: both;"></div>` ou pseudo-elementos obscuros com hacks de `zoom: 1` para o Internet Explorer.

#### Parte 3: A Solução Moderna de Elite
O Flexbox moderno W3C opera em uma dimensão por vez (eixo principal *main-axis* ou eixo transversal *cross-axis*), provendo controle posicional matemático via propriedade `gap`:

```css
/* BARRA DE AÇÕES OPERACIONAIS DO AUDITOR FISCAL COM FLEXBOX */
.barra-operacoes {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 1.25rem;
  padding: 1rem 1.5rem;
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-borda-md);
}

/* Grupo de Filtros com Quebra Automática Fluida */
.barra-operacoes__filtros {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap; /* Em telas menores, quebra em nova linha sem colapsar */
}

/* Grupo de Botões com Alinhamento à Direita */
.barra-operacoes__botoes {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* Campo de Busca que Ocupa Todo o Espaço Restante */
.barra-operacoes__busca {
  flex: 1 1 280px; /* Flex-grow: 1 | Flex-shrink: 1 | Flex-basis: 280px */
}

@media (max-width: 640px) {
  .barra-operacoes {
    flex-direction: column;
    align-items: stretch;
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `cadastrounicoservice` (:8081) e `fiscalizacao` (:8083):** Cabeçalhos de processos, barras de ferramentas de pesquisa com filtros dinâmicos de frotas e cartões de estatísticas rápidas ("Total de Veículos Abordados", "TRVs Emitidos", "Autuações Concluídas") utilizam Flexbox puro com zero necessidade de cálculos manuais de margens ou hacks de limpeza de float.

---

### 2.3 CSS Grid Moderno: Diagramação Bidimensional & Auto-fit

#### Parte 1: O que é o conceito / Analogia Didática
Se o Flexbox é uma fila de passageiros em uma plataforma de embarque de ônibus (uma linha ou coluna fluida), o **CSS Grid** é o tabuleiro de xadrez: você define antecipadamente e com precisão absoluta as linhas e colunas bidimensionais (`grid-template-columns` e `grid-template-rows`). Você pode declarar que a rainha ocupa da coordenada B2 até a coordenada D4 (`grid-area` ou `span`), e todos os demais elementos respeitam essa área reservada sem que ninguém seja empurrado para fora da mesa.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A tentativa de criar layouts bidimensionais durante a década passada dependia de frameworks gigantescos como Bootstrap 3/4. Para criar uma listagem de veículos, o código HTML era soterrado por camadas redundantes:
```html
<!-- ❌ O INFERNO DE CLASSES E DIVS DE FRAMEWORKS DE GRID LEGADOS -->
<div class="container">
  <div class="row">
    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
      <div class="thumbnail">Card 1</div>
    </div>
    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
      <div class="thumbnail">Card 2</div>
    </div>
  </div>
</div>
```
*O Impacto no Mundo Real:* Se o Card 1 tivesse três linhas de texto a mais que o Card 2, a quebra de linha do Bootstrap travava (*Grid Lock*), deixando buracos vazios e desalinhamentos grotescos no layout. Além disso, quando se precisava diagramar algo complexo como o mapa de assentos de uma sala de teatro ou o layout de um painel de comando, os sistemas de 12 colunas não permitiam frações customizadas nem auto-adaptação sem media queries quilométricas.

#### Parte 3: A Solução Moderna de Elite
O CSS Grid permite definir diagramações bidimensionais que se adaptam automaticamente ao espaço da tela sem precisar de uma única `@media query`, utilizando a fórmula matemática `repeat(auto-fit, minmax(largura-minima, 1fr))`:

```css
/* ==========================================================================
   DASHBOARD BIDIMENSIONAL DA FISCALIZAÇÃO (CSS GRID RESPONSIVO SEM MEDIA QUERY)
   ========================================================================== */
.grade-dashboard {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 1.5rem;
  padding: 1.5rem;
}

/* ==========================================================================
   MAPA DE ASSENTOS BIDIMENSIONAL DO TEATRO-ABC (20 COLUNAS POR SALA)
   ========================================================================== */
.mapa-plateia {
  display: grid;
  /* Coluna 1: Letra da Fileira | Colunas 2-21: Poltronas | Coluna 22: Letra da Fileira */
  grid-template-columns: 44px repeat(20, minmax(36px, 1fr)) 44px;
  grid-auto-rows: 40px;
  gap: 8px;
  padding: 2rem;
  background-color: #0b0f19;
  border-radius: 12px;
  overflow-x: auto; /* Garante scroll suave caso o dispositivo tenha tela estreita */
}

/* O Palco ocupa toda a extensão horizontal do Grid */
.mapa-plateia__palco {
  grid-column: 1 / -1; /* Estende da primeira até a última linha da grade */
  height: 52px;
  background: linear-gradient(180deg, #1e40af 0%, rgba(30, 64, 175, 0.2) 100%);
  border-bottom: 3px solid #60a5fa;
  border-radius: 8px 8px 50% 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  letter-spacing: 3px;
  color: #ffffff;
  margin-bottom: 2rem;
}

/* Assento PCD reservado que ocupa duas posições na grade */
.teatro-poltrona--pcd {
  grid-column: span 2;
  background-color: #0284c7;
  color: #ffffff;
}
```

#### Parte 4: Vínculo Direto com o Teatro-ABC (:8090)
- **No `teatro-abc` (:8090):** Toda a diagramação das salas do Centro Cultural Oscar Niemeyer (Plateia Baixa com 600 lugares e Frisas com 200 lugares) é construída em CSS Grid bidimensional nativo. A renderização de centenas de poltronas é fluida, sem nenhum framework CSS externo, com suporte a assentos especiais PCD via `grid-column: span 2`.

---

### 2.4 Design Tokens & CSS Custom Properties para Alto Contraste Governamental

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma casa de espetáculos com 600 lâmpadas refletoras. No modelo antigo, cada lâmpada possuía uma película colorida manual fixa. Se a direção de arte ordenasse mudar a iluminação de um espetáculo infantil para um tema clássico noturno, uma equipe precisaria subir em escadas e trocar as películas das 600 lâmpadas uma a uma.

As **CSS Custom Properties** (Variáveis CSS declaradas com `--nome-da-variavel`) são a mesa de controle central DMX da iluminação: com um único ajuste no comando central (`:root`), todas as lâmpadas do prédio alteram sua frequência de cor no mesmo instante.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Nos sistemas legados da AGR, as cores institucionais do Governo de Goiás (como o verde `#005A2B` e o amarelo `#FFCC00`) eram declaradas de forma literal repetida em centenas de seletores espalhados por dezenas de arquivos `.css`.

*O Desastre em Produção:* Quando a identidade visual do Estado de Goiás foi atualizada ou quando a Promotoria de Justiça de Defesa do Cidadão exigiu a implementação do **Modo de Alto Contraste** nos sistemas de atendimento ao público, a equipe de TI da AGR levou meses vasculhando arquivos de estilo. Sempre que uma cor era alterada manualmente, quebravam-se botões e contrastes em páginas secundárias, deixando textos invisíveis (texto branco sobre fundo branco) e gerando novas notificações do TCE-GO por não conformidade com a WCAG 2.1 AA.

#### Parte 3: A Solução Moderna de Elite
Arquitetura baseada em **Design Tokens** estruturados no elemento raiz `:root`, permitindo alternância de temas em tempo real através do atributo `data-tema` no elemento `<html>`, sem necessidade de recarregar a página e sem tocar em bibliotecas externas:

```css
/* ==========================================================================
   DESIGN TOKENS INSTITUCIONAIS DO ESTADO DE GOIÁS & MODOS DE CONTRASTE
   ========================================================================== */

:root {
  /* Tokens de Cor Institucionais (Padrão Dia / Luminoso) */
  --cor-primaria: #005a2b;          /* Verde Goiás Oficial (Contraste 6.1:1 sobre branco) */
  --cor-primaria-hover: #00401e;
  --cor-secundaria: #d97706;        /* Amarelo Ouro Queimado */
  --cor-superficie: #ffffff;
  --cor-fundo: #f8fafc;
  --cor-borda: #cbd5e1;
  --cor-texto-primaria: #0f172a;    /* Contraste 15.8:1 sobre branco */
  --cor-texto-secundaria: #475569;  /* Contraste 5.5:1 sobre branco */

  /* Estados de Negócio da Fiscalização */
  --cor-sucesso: #16a34a;
  --cor-aviso: #ca8a04;
  --cor-perigo: #dc2626;

  /* Tipografia do Sistema */
  --fonte-sans: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --fonte-mono: 'JetBrains Mono', Consolas, 'Fira Code', monospace;

  /* Espaçamento e Geometria */
  --raio-borda-md: 6px;
  --raio-borda-lg: 12px;
}

/* ==========================================================================
   MODO ALTO CONTRASTE (WCAG 2.1 AAA - TAXA DE CONTRASTE > 7:1 MANDATÓRIA)
   ========================================================================== */
[data-tema="alto-contraste"] {
  --cor-primaria: #ffff00;          /* Amarelo Puro sobre Fundo Preto (Contraste 19.5:1) */
  --cor-primaria-hover: #ffffff;
  --cor-secundaria: #00ffff;        /* Ciano Puro */
  --cor-superficie: #000000;
  --cor-fundo: #000000;
  --cor-borda: #ffffff;
  --cor-texto-primaria: #ffffff;
  --cor-texto-secundaria: #ffff00;
  --cor-sucesso: #00ff00;
  --cor-aviso: #ffff00;
  --cor-perigo: #ff3333;
}

/* ==========================================================================
   MODO ESCURO (DARK MODE) PARA OPERAÇÕES NOTURNAS EM VIATURAS
   ========================================================================== */
[data-tema="dark"] {
  --cor-primaria: #22c55e;
  --cor-primaria-hover: #16a34a;
  --cor-superficie: #1e293b;
  --cor-fundo: #0f172a;
  --cor-borda: #334155;
  --cor-texto-primaria: #f8fafc;
  --cor-texto-secundaria: #94a3b8;
}

/* Aplicação Global dos Tokens */
body {
  font-family: var(--fonte-sans);
  background-color: var(--cor-fundo);
  color: var(--cor-texto-primaria);
  margin: 0;
  transition: background-color 0.25s ease, color 0.25s ease;
}
```

```javascript
// Controle Vanilla de Chaveamento de Tema com Persistência
class GerenciadorTemaGovernamental {
  static CHAVE_STORAGE = 'agr:tema-interface';

  static inicializar() {
    const temaSalvo = localStorage.getItem(this.CHAVE_STORAGE) || 'claro';
    this.aplicar(temaSalvo);
  }

  static alternarAltoContraste() {
    const temaAtual = document.documentElement.dataset.tema;
    const novoTema = (temaAtual === 'alto-contraste') ? 'claro' : 'alto-contraste';
    this.aplicar(novoTema);
  }

  static aplicar(tema) {
    if (tema === 'claro') {
      delete document.documentElement.dataset.tema;
    } else {
      document.documentElement.dataset.tema = tema;
    }
    localStorage.setItem(this.CHAVE_STORAGE, tema);
  }
}

// Inicializa no carregamento do DOM
document.addEventListener('DOMContentLoaded', () => {
  GerenciadorTemaGovernamental.inicializar();
});
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `portalservice` (:8080) e Tablets da `fiscalizacao` (:4203):** O cidadão idoso ou com baixa visão clica no botão "Alto Contraste" presente no topo do portal do cidadão, invertendo as paletas instantaneamente para preto e amarelo puro sem piscar a tela. Nas viaturas da fiscalização rodoviária, o auditor ativa o modo `dark` durante fiscalizações noturnas na GO-080 para evitar ofuscamento da visão sem perder legibilidade.

---

## 3. JavaScript ES6+ Profundo & Assincronismo de Alta Performance

### 3.1 Escopo Léxico de Bloco: `const`/`let` vs O Vício Histórico do `var` & Temporal Dead Zone (TDZ)

#### Parte 1: O que é o conceito / Analogia Didática
Declarar variáveis com a palavra-chave `var` é o equivalente a transmitir um comunicado pelo alto-falante central de um condomínio residencial: mesmo que você queira apenas dar um recado para quem está dentro da cozinha (dentro de uma condicional `if`), o som reverbera por todas as salas, corredores e pelo saguão principal do edifício.

O uso de `let` e `const` é como fechar a porta de um cômodo acústico: o que é dito dentro daquele bloco `{ ... }` nasce, vive e morre rigorosamente dentro daquele cômodo, sem vazar para o restante da casa. Além disso, a **Temporal Dead Zone (TDZ)** funciona como uma trava de segurança biométrica: se você tentar pegar o crachá da mesa antes que ele seja formalmente registrado e depositado ali, um alarme dispara imediatamente (`ReferenceError`).

#### Parte 2: A Dor Histórica / O Desastre do Legado (Com Citações Literais da AlgaWorks)
Na aula `90_MJS - 3.3 - Entendendo o uso do var.txt`, a AlgaWorks detalha a aberração semântica provocada pelo içamento (*hoisting*) e pela ausência de escopo de bloco no `var`:
> *"As nossas variáveis, quando a gente declara elas utilizando a keyword var, elas são delimitadas apenas por funções e elas não são delimitadas por blocos... isso significa que mesmo que eu tenha criado ela dentro desse if, ela está disponível aqui fora dele... tanto que se eu coloco aqui `console.log(test)` ele já fez o log de 35, que é basicamente o valor de uma variável que foi declarada lá em cima."* (`90_MJS`)

O sintoma clássico desse vício revelava-se no infame bug do contador de iteração em laços de repetição com callbacks assíncronos:
```javascript
// ❌ O CLÁSSICO BUG DE ESCOPO DO VAR EM LOOPS COM TIMERS OU EVENTOS
for (var i = 0; i < 3; i++) {
  setTimeout(function() {
    console.log('Veículo fiscalizado: ' + i); // Imprime 3, 3, 3!
  }, 100);
}
```
*O Desastre Real nos Microsserviços da AGR:* Em rotinas do Portal 1 que geravam o parcelamento de multas da `receitaservice` (:8092), variáveis `var valorParcela` declaradas dentro de condicionais `if (quantidadeParcelas > 6) { var valorParcela = ... }` vazavam para o escopo externo. Se a primeira condição não fosse atendida em um laço subsequente, o sistema reutilizava silenciosamente o valor residual da iteração anterior, emitindo boletos com valores de juros corrompidos.

#### Parte 3: A Solução Moderna de Elite
Adoção inegociável de **`const` por padrão** (imutabilidade de atribuição de referência) e **`let`** estritamente quando houver necessidade comprovada de reatribuição de valor primitivo. A eliminação do `var` assegura que a Temporal Dead Zone impeça acessos prévios à inicialização física da variável:

```javascript
// ✅ ESCOPO LÉXICO RIGOROSO, TDZ E IMUTABILIDADE DE REFERÊNCIA
function liquidarAutoInfracao(idAuto, valorOriginal, condutorCompareceu) {
  const DESCONTO_DEFESA_TEMPESTIVA = 0.20; // Imutável por definição (const)

  // console.log(valorFinal); // ERRO: ReferenceError (TDZ - variável existe na memória mas está inacessível!)

  if (condutorCompareceu) {
    const descontoReais = valorOriginal * DESCONTO_DEFESA_TEMPESTIVA;
    let valorFinal = valorOriginal - descontoReais; // Confinada estritamente a este bloco if
    
    console.log(`Auto ${idAuto}: valor com desconto aplicado: R$ ${valorFinal.toFixed(2)}`);
  }

  // console.log(valorFinal); // ERRO: ReferenceError: valorFinal is not defined (Imunidade total a vazamento)
}

// ✅ RESOLUÇÃO DEFINITIVA DO LOOP COM LET:
// Cada iteração do laço cria uma nova amarração léxica independente na memória
for (let i = 0; i < 3; i++) {
  setTimeout(() => {
    console.log('Veículo fiscalizado ordem: ' + i); // Imprime fielmente: 0, depois 1, depois 2!
  }, 100);
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No módulo de cálculo de mora da `receitaservice` (:8092):** Na liquidação de autos de infração e cálculo de juros pela taxa SELIC, as variáveis de amortização são confinadas via `const` e `let`, assegurando que o processamento concorrente de dezenas de parcelas não contamine os ponteiros de memória de transações fiscais adjacentes.

---

### 3.2 Funções Tradicionais vs Arrow Functions & `this` Léxico

#### Parte 1: O que é o conceito / Analogia Didática
Uma função tradicional declarada com `function()` é como um ator mercenário de teatro: onde quer que ele pise, ele assume a identidade do palco em que acabou de aterrissar. Se você o colocar dentro de um botão do DOM, o `this` dele passa a ser o próprio botão HTML; se você o invocar solto no console, o `this` dele vira o objeto global `window`.

Uma **Arrow Function** (`() => {}`) é um astronauta com seu próprio rádio e identidade fixa da base espacial: não importa se ele pisou na Lua, em Marte ou em uma estação orbital desconhecida, o comunicador dele sempre conversa e se refere à cabine de comando original de onde foi despachado. Em termos técnicos: o `this` de uma Arrow Function é **estritamente léxico** (amarrado ao escopo onde foi declarada).

#### Parte 2: A Dor Histórica / O Desastre do Legado (Com Citações Literais da AlgaWorks)
Na aula `95_MJS - 3.8 - Criando arrow functions.txt`, a AlgaWorks explica as armadilhas clássicas do contexto dinâmico do JavaScript antigo:
> *"As arrow functions elas não têm o contexto de this próprio... você trabalhar com o contexto dentro de arrow functions pode ser uma coisa um pouco tricky... na hora que eu executasse esse método, o contexto de this estaria valendo o quê? Ele estaria valendo o meu objeto window... porque a arrow function ignora basicamente o contexto na qual ela está sendo executada e captura o contexto léxico de onde foi declarada... Você não consegue fazer bind, apply ou call para mudar o this de uma arrow function."* (`95_MJS`)

*A Autópsia do Legado:* Para contornar a perda do `this` em manipuladores de eventos e temporizadores, desenvolvedores eram obrigados a introduzir hacks grotescos como `var that = this;` ou `var self = this;`:
```javascript
// ❌ O HACK ANTIGO DE "VAR THAT = THIS" PARA SOBREVIVER À PERDA DE CONTEXTO
function GerenciadorBlitz() {
  this.totalAutos = 0;
  var self = this; // Hack defensivo para armazenar o ponteiro original

  document.getElementById('btn-autuar').addEventListener('click', function() {
    // Se usasse this.totalAutos aqui, this seria o elemento <button> do DOM!
    self.totalAutos++; 
  });
}
```

#### Parte 3: A Solução Moderna de Elite
Com o ECMAScript moderno, classes com métodos encapsulados utilizam Arrow Functions para amarrar o contexto do objeto instanciado sem nenhuma necessidade de variáveis intermediárias ou chamadas a `.bind(this)`:

```javascript
// ✅ CLASSE ORIENTADA A OBJETOS MODERNA COM THIS LÉXICO GARANTIDO
class PainelComandoBlitz {
  constructor(nomeOperacao, auditorResponsavel) {
    this.nomeOperacao = nomeOperacao;
    this.auditorResponsavel = auditorResponsavel;
    this.veiculosFiscalizados = [];
    
    this.conectarElementos();
  }

  conectarElementos() {
    const botaoRegistrar = document.querySelector('#btn-registrar-abordagem');
    if (!botaoRegistrar) return;

    // A Arrow Function captura o 'this' da instância da classe PainelComandoBlitz!
    botaoRegistrar.addEventListener('click', (evento) => {
      evento.preventDefault();
      
      this.registrarAbordagem({
        placa: document.querySelector('#campo-placa').value,
        timestamp: new Date().toISOString()
      });
    });
  }

  registrarAbordagem(dados) {
    this.veiculosFiscalizados.push(dados);
    console.log(`[${this.nomeOperacao}] Auditor ${this.auditorResponsavel} registrou placa: ${dados.placa}`);
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `teatro-abc` (:8090):** No componente de seleção de assentos, a classe `MapaPlateiaController` vincula escutadores de eventos de clique em botões de poltrona através de Arrow Functions. O `this` dentro do handler permanece confinado à instância da classe que gerencia a reserva de ingressos e o carrinho de compras, sem sofrer desvios para o botão HTML clicado.

---

### 3.3 Física da Execução JS: Call Stack, Web APIs, Microtasks vs Macrotasks e Event Loop

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o atendimento de um caixa exclusivo em uma agência bancária de altíssima demanda (a **Call Stack** da thread única do motor V8). O caixa só pode conversar com um cliente por vez. Se um cliente apresenta uma solicitação que depende de uma checagem de certidão externa em cartório (uma requisição de rede HTTP ou leitura de arquivo), o caixa não cruza os braços para esperar: ele encaminha a solicitação para os despachantes externos do banco (as **Web APIs** fornecidas pelo navegador) e imediatamente chama o próximo cliente da fila.

Quando o despachante externo conclui a busca da certidão, ele não interrompe o caixa no meio de uma frase: ele encaminha a resposta para uma sala de espera. No entanto, existem duas filas de espera com prioridades radicalmente diferentes:
1. **Fila VIP de Microtasks:** Onde entram as **Promises resolvidas** (`.then()`, `await`), `queueMicrotask` e mutações do DOM (`MutationObserver`). O caixa possui uma regra inquebrável: assim que ele termina o atendimento síncrono da Call Stack, ele é obrigado a esvaziar **100% de todas as Microtasks** pendentes antes de dar atenção a qualquer outra coisa!
2. **Fila Geral de Macrotasks (Task Queue):** Onde entram `setTimeout`, `setInterval`, `setImmediate` e eventos de I/O de mouse e teclado. O caixa atende rigorosamente **UMA** Macrotask por vez e, em seguida, libera o navegador para rodar o ciclo de renderização visual (Layout e Paint).

O maestro que vigia a Call Stack e organiza esse tráfego ininterrupto é o **Event Loop**.

```
A FÍSICA DO EVENT LOOP E A HIERARQUIA DE FILAS DE EXECUÇÃO

┌────────────────────────────────────────────────────────┐
│                      CALL STACK                        │
│   (Thread Única: Execução Síncrona Instrução a Instrução)│
└──────────────────────────┬─────────────────────────────┘
                           │ 1. Invoca chamada assíncrona
                           ▼
                 ┌───────────────────┐
                 │     Web APIs      │ (Fetch, Timers, DOM Events)
                 └─────────┬─────────┘
                           │ 2. Conclui operação em background
         ┌─────────────────┴─────────────────┐
         │                                   │
         ▼                                   ▼
┌──────────────────┐               ┌───────────────────┐
│ MICROTASKS QUEUE │               │ MACROTASKS QUEUE  │
│ (VIP / Prioritária)              │ (Geral / Timers)  │
│ • Promises (.then)               │ • setTimeout      │
│ • async / await  │               │ • setInterval     │
│ • queueMicrotask │               │ • UI Click Events │
└────────┬─────────┘               └─────────┬─────────┘
         │ 3. ESVAZIA TODAS                          │ 5. Pega APENAS UMA
         ▼                                           ▼
┌──────────────────┐                       ┌───────────────────┐
│   EVENT LOOP     │───► [RENDER PHASE] ──►│   PRÓXIMA MACRO   │
│ (Stack vazia?)   │     (Layout / Paint)  └───────────────────┘
└──────────────────┘
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
A maior ilusão dos programadores da era pré-ES6 era acreditar que executar `setTimeout(funcao, 0)` significava executar a função imediatamente no milissegundo zero:
```javascript
console.log('1: Início');
setTimeout(() => console.log('2: Timeout 0ms'), 0);
Promise.resolve().then(() => console.log('3: Promise resolvida'));
console.log('4: Fim');
// Ordem real da física da máquina: 1 -> 4 -> 3 -> 2!
```
*O Desastre em Produção:* Desenvolvedores legados tentavam sincronizar dependências de tela encadeando múltiplos timers mágicos (`setTimeout(..., 50)`, seguido de `setTimeout(..., 100)`). Sob condições de processador saturado nas viaturas da AGR, as macrotasks atrasavam, disparando modais de confirmação de autuação antes que os dados da frota tivessem retornado do backend, gerando falhas operacionais e salvamentos de cadastros incompletos.

#### Parte 3: A Solução Moderna de Elite
Domínio da ordem de prioridade de tarefas para manter a Call Stack livre e orquestrar operações pesadas sem congelar a taxa de quadros (FPS) da interface:

```javascript
// ✅ AUDITORIA FORENSE E COMPROVAÇÃO DA FÍSICA DO EVENT LOOP
function auditoriaForenseEventLoop() {
  console.log('[STACK] 1. Instrução Síncrona Inicial');

  // Macrotask agendada para entrar na Task Queue
  setTimeout(() => {
    console.log('[MACROTASK] 5. setTimeout(0) executado (após esvaziamento das microtasks e renderização)');
  }, 0);

  // Microtask 1: Injetada diretamente na fila VIP
  Promise.resolve().then(() => {
    console.log('[MICROTASK] 3. Primeira Promise resolvida imediatamente após a Stack esvaziar');
  }).then(() => {
    console.log('[MICROTASK] 4. Encadeamento de Microtask esvaziado antes da Macrotask!');
  });

  // Microtask 2: Agendamento explícito via API nativa da engine
  queueMicrotask(() => {
    console.log('[MICROTASK] 3.1. queueMicrotask executada com prioridade VIP');
  });

  console.log('[STACK] 2. Instrução Síncrona Final (Call Stack terminando)');
}

// Saída no console da máquina:
// [STACK] 1. Instrução Síncrona Inicial
// [STACK] 2. Instrução Síncrona Final (Call Stack terminando)
// [MICROTASK] 3. Primeira Promise resolvida imediatamente após a Stack esvaziar
// [MICROTASK] 3.1. queueMicrotask executada com prioridade VIP
// [MICROTASK] 4. Encadeamento de Microtask esvaziado antes da Macrotask!
// [MACROTASK] 5. setTimeout(0) executado (após esvaziamento das microtasks e renderização)
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Na captura de assinaturas digitais na `fiscalizacao` (:8083):** A serialização dos vetores de traçado do canvas para imagem PNG Base64 roda envelopada em uma Promise (Microtask), assegurando que o encerramento do traço seja concluído e a UI exiba o spinner de confirmação visual sem que frames da animação de toque sofram engasgos (*jank*).

---

### 3.4 Promises Nativas & Async/Await com Tratamento Estruturado e `AbortController`

#### Parte 1: O que é o conceito / Analogia Didática
Realizar requisições assíncronas utilizando callbacks legados era como despachar um mensageiro a pé dizendo: *"Vá ao cartório. Quando conseguir a certidão, ligue para a secretária. A secretária deve ligar para o despachante. O despachante deve telefonar para o fiscal..."*. Essa cadeia produzia a infame pirâmide da destruição (*Callback Hell*), onde qualquer erro no meio do caminho sumia no vácuo sem tratamento centralizado.

A sintaxe moderna `async/await` com Promises nativas é dar ao mensageiro um rádio comunicador criptografado: o código é escrito de forma linear, limpa e legível como se fosse síncrono (`const auto = await buscarAuto()`), mas a thread do navegador permanece 100% liberada. E o **`AbortController`** é o botão de cancelamento de emergência no painel: se o usuário mudar de ideia ou digitar uma nova placa, o sinal de abortar é enviado pela rede imediatamente, descartando o tráfego obsoleto e liberando a memória do cliente.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Com Citações Literais da AlgaWorks)
Na aula `125_MJS - 7.1 - Introdução às Promises.txt`, a AlgaWorks sintetiza o avanço arquitetural das Promises:
> *"Um código assíncrono é basicamente um código que é executado sem bloquear a execução principal de um programa... utilizando as promises, objetos que representam um valor que pode estar disponível agora, depois ou nunca."* (`125_MJS`)

E na aula `128_MJS - 7.4 - Async e Await.txt`, comprova a superioridade de legibilidade da sintaxe moderna:
> *"Quando você usa essa keyword async, antes de você definir uma função, basicamente a sua função já vai retornar uma nova promise... e o que você retornar dentro dela vai ser o valor da promise... você não precisa daquele resolve e reject manual... o código fica muito mais clean e legível."* (`128_MJS`)

*A Autópsia das Condições de Corrida (Race Conditions):* No Portal 1 da AGR, a consulta de veículos enquanto o usuário digitava na caixa de busca (*search-as-you-type*) sofria de graves condições de corrida de rede. Se o auditor digitasse `ABC1234`, sete requisições eram disparadas. Se a resposta da requisição correspondente a `ABC1` levasse 800ms para responder devido a lentidão no MySQL central e a requisição final da placa completa `ABC1234` respondesse em 200ms, a resposta desatualizada de `ABC1` chegava por último e sobrescrevia a tela com os dados do veículo errado.

#### Parte 3: A Solução Moderna de Elite
Construção de um serviço resiliente de consulta à API utilizando `fetch` nativo, tratamento de exceções com `try/catch/finally` consumindo o padrão RFC 7807 ProblemDetail e cancelamento ativo com `AbortController`:

```javascript
// ✅ SERVIÇO DE CONSULTA REGULATÓRIA COM CANCELAMENTO ATIVO VIA ABORTCONTROLLER
class ServicoConsultaCadu {
  constructor() {
    this.controladorAtivo = null;
  }

  async consultarVeiculoPorPlaca(placa) {
    // 1. Se já existir uma requisição em andamento para este campo, aborta imediatamente!
    if (this.controladorAtivo) {
      this.controladorAtivo.abort();
    }

    // 2. Instancia um novo AbortController e extrai o sinal de cancelamento
    this.controladorAtivo = new AbortController();
    const { signal } = this.controladorAtivo;

    try {
      const url = `/api/v1/frotas/veiculos?placa=${encodeURIComponent(placa)}`;
      
      const resposta = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'X-Origem-Requisicao': 'Portal-Fiscalizacao-AGR'
        },
        signal // O sinal de cancelamento é plugado diretamente na requisição de rede
      });

      // 3. Validação do Código de Estado HTTP
      if (!resposta.ok) {
        // Extrai o ProblemDetail padrão RFC 7807 emitido pelo backend em Spring Boot 3
        const detalheProblema = await resposta.json().catch(() => ({}));
        throw new Error(detalheProblema.detail || `Erro na consulta cadastral: HTTP ${resposta.status}`);
      }

      const dadosVeiculo = await resposta.json();
      return dadosVeiculo;

    } catch (erro) {
      // 4. Tratamento diferenciado para cancelamento intencional
      if (erro.name === 'AbortError') {
        console.warn(`[CADU] Consulta da placa "${placa}" descartada por digitação de novo termo.`);
        return null; // Cancelamento intencional não deve exibir mensagem de erro na UI
      }

      console.error('[CADU] Falha irrecuperável na comunicação com o microsserviço:', erro.message);
      throw erro; // Repassa o erro de negócio para a camada de apresentação tratar

    } finally {
      // 5. Liberação do ponteiro do controlador
      this.controladorAtivo = null;
    }
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `cadastrounicoservice` (:8081) e `tripregularservice` (:8082):** Na tela de consulta de linhas intermunicipais de ônibus, conforme o passageiro digita as letras do município de destino ("Goiânia", "Caldas Novas"), requisições obsoletas são canceladas em tempo real via `AbortController`, poupando dezenas de conexões concorrentes no pool HikariCP do backend e garantindo a exibição dos horários corretos.
- **No `teatro-abc` (:8090):** Durante a busca de espetáculos e peças em cartaz por título ou elenco, as buscas parciais descartadas impedem a sobreposição de resultados no catálogo de sessões.

---

## 4. Manipulação de DOM Vanilla & Arquitetura Sem Framework (F04)

### 4.1 Travessia Cirúrgica no DOM (`querySelector`, `closest`, `matches`) sem jQuery

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um fiscal tributário que precisa encontrar o responsável legal de um estabelecimento durante uma fiscalização. A abordagem amadora seria contratar uma comitiva de guias turísticos caros e barulhentos (a biblioteca jQuery de 90 KB compactados) para gritar por megafones em todas as salas do prédio.

A abordagem moderna de elite utiliza a visão direta e precisa do fiscal: ele entra na sala e aponta cirurgicamente para a pessoa identificada (`document.querySelector('.gerente')`), ou olha para um funcionário no balcão e pergunta imediatamente: *"Quem é o superior hierárquico imediato deste departamento?"* (`elemento.closest('.diretoria')`).

#### Parte 2: A Dor Histórica / O Desastre do Legado
A web dos anos 2010 viciou-se em carregar pacotes pesados como jQuery apenas para executar seleções básicas como `$('#item')` ou manipulações como `$('button').addClass('ativo')`. 

Pior do que carregar dependências desnecessárias eram as travessias manuais frágeis na árvore genealógica do DOM:
```javascript
// ❌ O FRÁGIL ANTIPADRÃO DO LEGADO PARA SUBIR NA ÁRVORE
var botaoExcluir = document.getElementById('btn-del');
var linha = botaoExcluir.parentNode.parentNode; // Assume cegamente que há exatamente dois pais!
linha.style.display = 'none';
```
*A Quebra em Produção:* Se no dia seguinte outro desenvolvedor envolvesse o botão dentro de uma nova `<div class="botoes-grupo">` para aplicar um estilo de borda ou alinhamento, `parentNode.parentNode` passava a apontar para a `div` e não mais para a linha `<tr>` da tabela. O script excluía o elemento errado ou falhava silenciosamente com erro de execução.

#### Parte 3: A Solução Moderna de Elite
Uso exclusivo da especificação W3C Selectors API Nível 4:
- `querySelector(seletor)`: Retorna o primeiro elemento correspondente ao critério CSS.
- `querySelectorAll(seletor)`: Retorna uma `NodeList` estática de alta performance nativamente iterável via `.forEach()`.
- `elemento.closest(seletor)`: Sobe a cadeia de ancestrais inspecionando o próprio elemento e seus pais até encontrar o primeiro que atenda ao seletor CSS, imune a alterações intermediárias na marcação.
- `elemento.matches(seletor)`: Retorna um booleano avaliando se o elemento atende ao critério especificado.

```javascript
// ✅ TRAVESSIA CIRÚRGICA E TOTALMENTE RESILIENTE A MUTAÇÕES DE LAYOUT
document.addEventListener('click', (evento) => {
  // 1. Identifica se o clique ocorreu sobre ou dentro de um botão de autuação
  const botaoAutuar = evento.target.closest('[data-acao="lavrar-auto"]');
  if (!botaoAutuar) return;

  // 2. Localiza o card do veículo ancestral independente de quantos containers existam no meio
  const cardVeiculo = botaoAutuar.closest('.card-veiculo');
  if (!cardVeiculo) return;

  // 3. Extrai atributos de dados limpos do elemento pai
  const idVeiculo = cardVeiculo.dataset.veiculoId;
  const placa = cardVeiculo.dataset.placa;

  console.log(`[FISCALIZAÇÃO] Iniciando lavratura do Auto para o Veículo ID ${idVeiculo} (Placa: ${placa})`);
});
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `vistoriadoraservice` (:4205):** Ao marcar o checkbox de reprovação de um item de segurança veicular (ex: "Extintor de Incêndio com Carga Vencida"), o script utiliza `checkbox.closest('.item-inspecao')` para localizar o contêiner do item e exibir o campo de justificativa obrigatória, sem quebrar quando a equipe de UI adiciona novos painéis ou badges informativos ao formulário.

---

### 4.2 Delegação Eficiente de Eventos (Event Delegation) via Bubbling

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma assembleia com 1.200 fiscais sentados em um auditório. Se a presidência quiser saber quem gostaria de fazer uma pergunta, ela tem duas opções:
Na primeira opção, contrata-se uma equipe para instalar 1.200 microfones individuais com fios e baterias nas 1.200 cadeiras (adicionar 1.200 event listeners na memória do navegador).
Na segunda opção, coloca-se um único coordenador de microfone na porta central do auditório que atende quando qualquer participante levanta a mão e fala (um único listener anexado no elemento pai contêiner).

A segunda opção consome uma fração mínima de recursos e possui uma vantagem mágica: se mais 300 fiscais entrarem na sala e sentarem em cadeiras novas adicionadas depois, o coordenador na porta continua ouvindo a todos com perfeição, sem necessidade de instalar novos cabos. Isso é a **Delegação de Eventos** baseada no borbulhamento (*Event Bubbling*).

```
A FÍSICA DO EVENT BUBBLING E A DELEGAÇÃO DE EVENTOS

   Fase de Captura (Desce a árvore)
   │
   ▼
[ <table> #tabela-autos ] ◄────── 1. ÚNICO EVENT LISTENER REGISTRADO AQUI!
   │                               ▲
   ├─ [ <tbody> ]                  │
   │    │                          │ Fase de Borbulhamento (Event Bubbling)
   │    ├─ [ <tr> ]                │ O evento sobe notificando os pais!
   │    │    │                     │
   │    │    └─ [ <td> ]           │
   │    │         │                │
   │    │         └─ [ <button> ] ─┘ 2. O Fiscal clica no botão (Target)
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
O antipadrão mais comum em páginas com tabelas e listagens dinâmicas consistia em iterar sobre todos os botões e registrar um ouvinte para cada nó:
```javascript
// ❌ O ANTIPADRÃO QUE ESGOTA A MEMÓRIA HEAP E QUEBRA ELEMENTOS DINÂMICOS
const botoes = document.querySelectorAll('.btn-apreender');
botoes.forEach(btn => {
  btn.addEventListener('click', function() {
    // Problema 1: Centenas de closures alocadas na memória Heap
    // Problema 2: Quando a tabela carrega a página 2 via Ajax, os novos botões NÃO FUNCIONAM!
  });
});
```
*Impacto Real na AGR:* Em painéis operacionais onde centenas de autos de infração eram paginados via chamadas assíncronas, registrar ouvintes individuais esgotava a memória de tablets rodoviários. Pior: ao mudar a página da tabela, os novos botões renderizados ficavam "mortos", forçando os desenvolvedores a reexecutar scripts de ligação de eventos após cada requisição HTTP, gerando listeners duplicados e múltiplos envios da mesma operação.

#### Parte 3: A Solução Moderna de Elite
Registra-se rigorosamente **um único ouvinte de evento** no elemento pai da tabela, utilizando a propriedade `evento.target` combinada com `.closest('[data-acao]')` para capturar a intenção de forma resiliente:

```javascript
// ✅ DELEGAÇÃO DE EVENTOS DE ALTA PERFORMANCE (1 LISTENER PARA INFINITOS REGISTROS)
const containerTabelaAutos = document.querySelector('#tabela-autos-fiscalizacao');

containerTabelaAutos.addEventListener('click', (evento) => {
  // 1. Verifica se o clique ocorreu sobre um gatilho de ação (ou dentro dele, ex: em um ícone <i>)
  const gatilho = evento.target.closest('[data-acao]');
  if (!gatilho || !containerTabelaAutos.contains(gatilho)) return;

  // 2. Extrai a linha do registro e a identificação do auto
  const linhaAuto = gatilho.closest('tr');
  const idAuto = linhaAuto ? linhaAuto.dataset.idAuto : null;
  const acao = gatilho.dataset.acao;

  if (!idAuto) return;

  // 3. Despacha cirurgicamente a ação solicitada
  switch (acao) {
    case 'visualizar-auto':
      console.log(`[AÇÃO] Exibindo detalhes do Auto ID: ${idAuto}`);
      abrirModalDetalhesAuto(idAuto);
      break;

    case 'gerar-dare':
      console.log(`[AÇÃO] Solicitando emissão de DARE SEFAZ para o Auto ID: ${idAuto}`);
      emitirDarePagamento(idAuto);
      break;

    case 'apreender-veiculo':
      console.log(`[AÇÃO] Abrindo termo de apreensão (TRV) para o Auto ID: ${idAuto}`);
      iniciarTermoApreensao(idAuto);
      break;

    default:
      console.warn(`[AÇÃO] Operação não mapeada: ${acao}`);
  }
});
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `teatro-abc` (:8090):** O container do mapa de plateia com 1.200 assentos possui um único event listener de clique registrado no elemento `<div class="mapa-plateia">`. Quando o cliente toca ou clica em qualquer uma das 1.200 poltronas, o evento borbulha até o contêiner raiz, que extrai o número da poltrona (`evento.target.closest('.teatro-poltrona')`) consumindo quase zero memória RAM.
- **No `agrfiscalservice` (:8083):** A tabela de autos lavrados em tempo real suporta inserção de novas linhas geradas via WebSocket ou Server-Sent Events (SSE) sem necessidade de reatachar nenhum escutador de eventos.

---

### 4.3 Renderização Declarativa Nativa com `<template>` e `DocumentFragment`

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um operário assentando tijolos em uma obra residencial. Existem duas formas de trabalhar:
Na primeira forma, a cada tijolo que ele coloca, ele corre até a loja de materiais na esquina, compra uma pá de cimento fresco, mistura na colher e assenta o tijolo na parede (concatenar strings no DOM com `innerHTML += '...'`). A calçada fica bloqueada a cada metro e o tráfego da rua para constantemente.
Na segunda forma, o operário leva um carrinho de mão para dentro da obra (o **`DocumentFragment`** em memória). Ele monta a fileira inteira de tijolos dentro do carrinho com cimento de secagem rápida e, quando a fileira está pronta, assenta o bloco completo na parede do edifício em um único movimento de poucos segundos.

O motor do navegador executa o recálculo de layout e rasterização de pixels exatamente **UMA** vez.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A prática mais destrutiva do desenvolvimento legado era a interpolação insegura de strings de marcação HTML em loops utilizando `innerHTML`:
```javascript
// ❌ O DESASTRE DUPLO: CONGELAMENTO DE TELA E VULNERABILIDADE GRAVE A XSS
for (let i = 0; i < dados.length; i++) {
  // A cada volta do loop, o navegador destrói e remonta todo o DOM interno!
  tabela.innerHTML += '<tr><td>' + dados[i].infrator + '</td><td>' + dados[i].valor + '</td></tr>';
}
```
*A Autópsia Forense:* Se a lista contivesse 200 itens, o navegador destruía e reconstruía a árvore DOM 200 vezes seguidas. Pior: se o nome do condutor autuado contivesse uma injeção como `<img src="x" onerror="fetch('/roubar-token?t=' + localStorage.getItem('token'))">`, a string era interpretada e executada diretamente pelo navegador do auditor fiscal (Vulnerabilidade Crítica de **Cross-Site Scripting - XSS**).

#### Parte 3: A Solução Moderna de Elite
Combinação da tag semântica nativa `<template>` (cujo conteúdo é inerte e não renderiza durante o carregamento da página), clonagem de nós em memória e montagem com `DocumentFragment`, com preenchimento estrito via `.textContent` para neutralizar 100% de qualquer tentativa de injeção XSS:

```html
<!-- TEMPLATE DECLARATIVO DECLARADO NO HTML (CONTEÚDO TOTALMENTE INERTE) -->
<template id="template-linha-auto">
  <tr class="linha-tabela-auto">
    <td class="linha-tabela-auto__numero"></td>
    <td class="linha-tabela-auto__placa"></td>
    <td class="linha-tabela-auto__infrator"></td>
    <td class="linha-tabela-auto__valor"></td>
    <td class="linha-tabela-auto__status"></td>
    <td class="linha-tabela-auto__acoes">
      <button type="button" class="btn btn--sm btn--secundario" data-acao="visualizar-auto">
        Detalhes
      </button>
      <button type="button" class="btn btn--sm btn--primario" data-acao="gerar-dare">
        Emitir DARE
      </button>
    </td>
  </tr>
</template>

<table class="tabela-operacional">
  <thead>
    <tr>
      <th>Número do Auto</th>
      <th>Placa</th>
      <th>Condutor / Infrator</th>
      <th>Valor da Multa</th>
      <th>Situação</th>
      <th>Ações Regulatórias</th>
    </tr>
  </thead>
  <tbody id="corpo-tabela-autos">
    <!-- As linhas são inseridas aqui via DocumentFragment -->
  </tbody>
</table>

<script>
  // ✅ RENDERIZAÇÃO EM LOTE: ZERO LAYOUT THRASHING E IMUNIDADE TOTAL CONTRA XSS
  function renderizarAutosEmLote(listaAutos) {
    const template = document.querySelector('#template-linha-auto');
    const corpoTabela = document.querySelector('#corpo-tabela-autos');

    // 1. Criação do container virtual em memória (o carrinho de mão da alvenaria)
    const fragmento = document.createDocumentFragment();

    const formatadorMoeda = new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    });

    listaAutos.forEach(auto => {
      // 2. Clona a estrutura profunda (deep clone) do template
      const clone = template.content.cloneNode(true);
      const linha = clone.querySelector('.linha-tabela-auto');

      linha.dataset.idAuto = auto.id;

      // 3. Inserção Segura via textContent (Qualquer payload malicioso vira texto puro inofensivo)
      clone.querySelector('.linha-tabela-auto__numero').textContent = auto.numeroAuto;
      clone.querySelector('.linha-tabela-auto__placa').textContent = auto.placa;
      clone.querySelector('.linha-tabela-auto__infrator').textContent = auto.nomeInfrator;
      clone.querySelector('.linha-tabela-auto__valor').textContent = formatadorMoeda.format(auto.valor);
      clone.querySelector('.linha-tabela-auto__status').textContent = auto.situacao;

      // 4. Anexa o nó clonado ao fragmento virtual em memória (zero impacto no DOM real)
      fragmento.appendChild(clone);
    });

    // 5. UMA ÚNICA mutação física no DOM: descarrega todas as 200 linhas de uma só vez
    corpoTabela.replaceChildren(fragmento);
  }
</script>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **No `agrfiscalservice` (:8083):** Na recepção da carga de blitz rodoviária com centenas de abordagens, a renderização com `DocumentFragment` ocorre em menos de 8 milissegundos, com total proteção contra injeções de scripts provenientes de nomes cadastrais adulterados.
- **No `teatro-abc` (:8090):** No carregamento inicial do catálogo de 50 peças em cartaz e horários de apresentação, os cards dos espetáculos são gerados a partir de `<template id="template-card-espetaculo">`, garantindo consistência visual e velocidade de inicialização instantânea.

---

### 4.4 Componentização Nativa com Custom Elements (Web Components)

#### Parte 1: O que é o conceito / Analogia Didática
Se você pudesse solicitar à W3C para adicionar oficialmente ao catálogo mundial de tags HTML a sua própria tag — como `<agr-status-veiculo>` ou `<teatro-poltrona>` —, dotada de comportamento próprio, estilo encapsulado e propriedades observáveis nativamente pelo navegador, você não precisaria importar 500 KB de bibliotecas de componentes de terceiros.

Os **Custom Elements** (pilar da especificação Web Components da W3C) são exatamente isso: você cria blocos de Lego com comportamento de engenharia nativo da própria plataforma web.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento corporativo legado, a criação de pequenos componentes reutilizáveis (como indicadores de situação, badges com pontos coloridos pulsantes e barras de progresso) exigia a inclusão de frameworks pesados ou plugins jQuery de terceiros.

*Impacto no Mundo Real:* No Portal 1 da AGR, a inclusão de plugins de terceiros para exibir badges de status provocava conflitos crônicos entre versões do jQuery e vazamento de regras de estilo globais que distorciam os formulários das telas vizinhas.

#### Parte 3: A Solução Moderna de Elite
Criação de um componente web nativo estendendo a classe padrão `HTMLElement`, registrando-o formalmente no registro de elementos customizados (`customElements.define`) com ciclo de vida estruturado:

```javascript
// ✅ WEB COMPONENT NATIVO AUTOCONTIDO: <agr-status-veiculo>
class AgrStatusVeiculo extends HTMLElement {
  // 1. Declara quais atributos HTML o navegador deve monitorar ativamente
  static get observedAttributes() {
    return ['status', 'motivo'];
  }

  constructor() {
    super();
  }

  // 2. Ciclo de Vida: Invocado quando o elemento é conectado à árvore do DOM
  connectedCallback() {
    this.render();
  }

  // 3. Ciclo de Vida: Invocado quando um dos observedAttributes é modificado
  attributeChangedCallback(nomeAtributo, valorAntigo, valorNovo) {
    if (valorAntigo !== valorNovo) {
      this.render();
    }
  }

  render() {
    const status = (this.getAttribute('status') || 'REGULAR').toUpperCase();
    const motivo = this.getAttribute('motivo') || '';

    const configuracoes = {
      REGULAR: {
        rotulo: 'Veículo Regular',
        classeCss: 'status-veiculo--regular',
        icone: '✓'
      },
      NOTIFICADO: {
        rotulo: 'Notificação Pendente',
        classeCss: 'status-veiculo--notificado',
        icone: '!'
      },
      APREENDIDO: {
        rotulo: 'Retido em Blitz (TRV)',
        classeCss: 'status-veiculo--apreendido',
        icone: '✕'
      }
    };

    const config = configuracoes[status] || configuracoes.REGULAR;

    this.innerHTML = `
      <span class="status-veiculo ${config.classeCss}" role="status" title="${motivo}">
        <span class="status-veiculo__icone" aria-hidden="true">${config.icone}</span>
        <span class="status-veiculo__texto">${config.rotulo}</span>
      </span>
    `;
  }
}

// 4. Registro oficial da tag no ecossistema do navegador
if (!customElements.get('agr-status-veiculo')) {
  customElements.define('agr-status-veiculo', AgrStatusVeiculo);
}
```

Uso declarativo direto no HTML puro sem nenhum build step ou transpilador:
```html
<!-- Utilização direta da tag customizada -->
<agr-status-veiculo status="APREENDIDO" motivo="Transporte clandestino de passageiros na GO-020"></agr-status-veiculo>
<agr-status-veiculo status="REGULAR"></agr-status-veiculo>
```

#### Parte 4: Vínculo Direto com o Teatro-ABC (:8090)
- **No `teatro-abc` (:8090):** A poltrona da plateia é encapsulada na tag nativa `<teatro-poltrona numero="14B" setor="PLATEIA_VIP" status="LIVRE">`. Ao alterar o atributo via `poltrona.setAttribute('status', 'OCUPADA')`, o próprio ciclo de vida nativo do Custom Element redesenha a cor e atualiza o `aria-label` do assento sem depender de nenhum framework externo.

---

## 5. Caderno de Casos Práticos Reais (Aplicação de Ponta a Ponta)

### Caso Prático 1: Canvas de Assinatura Digital de Blitz Rodoviária em Tablets de Campo

- **Microsserviço de Backend:** `agrfiscalservice` (:8083) / Frontend de Campo (:4203).
- **Problema de Negócio & Conformidade Legal:** Durante a fiscalização de trânsito em rodovias estaduais, ao lavrar um Auto de Infração ou Termo de Apreensão de Veículo (TRV), o fiscal e o infrator devem assinar o documento digitalmente na tela do tablet. De acordo com os requisitos de auditoria do TCE-GO e com a Lei Federal nº 14.063/2020 (Assinaturas Eletrônicas na Administração Pública), o sistema deve capturar a assinatura de forma vetorial fluida, suportar canetas Stylus ou toque digital, ajustar a resolução para telas de alta densidade (HiDPI/Retina) e impedir o envio de assinaturas em branco (evitando a anulação jurídica do auto).

```javascript
/**
 * Componente Vanilla de Captura de Assinatura Digital para Dispositivos de Campo
 */
class CanvasAssinaturaDigital {
  constructor(seletorCanvas, opcoes = {}) {
    this.canvas = document.querySelector(seletorCanvas);
    if (!this.canvas) {
      throw new Error(`Elemento canvas não encontrado para o seletor: ${seletorCanvas}`);
    }

    this.ctx = this.canvas.getContext('2d');
    this.estaDesenhando = false;
    this.houveTracoEfetivo = false; // Trava contra assinatura em branco

    this.larguraTraco = opcoes.larguraTraco || 2.5;
    this.corTraco = opcoes.corTraco || '#002b49'; // Azul oficial caneta governamental

    this.configurarResolucaoHiDPI();
    this.inicializarPointerEvents();
  }

  configurarResolucaoHiDPI() {
    // Corrige o efeito de linhas pixeladas/borradas em telas Retina/HiDPI
    const dpr = window.devicePixelRatio || 1;
    const rect = this.canvas.getBoundingClientRect();

    // Define a resolução física da matriz gráfica
    this.canvas.width = rect.width * dpr;
    this.canvas.height = rect.height * dpr;

    // Escala o contexto 2D para manter as proporções CSS
    this.ctx.scale(dpr, dpr);

    this.ctx.lineCap = 'round';
    this.ctx.lineJoin = 'round';
    this.ctx.lineWidth = this.larguraTraco;
    this.ctx.strokeStyle = this.corTraco;
  }

  inicializarPointerEvents() {
    // Unificação de Mouse, Caneta Stylus de tablet e Touch em uma única API padrão
    this.canvas.addEventListener('pointerdown', this.iniciarDesenho.bind(this));
    this.canvas.addEventListener('pointermove', this.desenhar.bind(this));
    this.canvas.addEventListener('pointerup', this.finalizarDesenho.bind(this));
    this.canvas.addEventListener('pointerleave', this.finalizarDesenho.bind(this));
  }

  obterCoordenadas(evento) {
    const rect = this.canvas.getBoundingClientRect();
    return {
      x: evento.clientX - rect.left,
      y: evento.clientY - rect.top
    };
  }

  iniciarDesenho(evento) {
    this.estaDesenhando = true;
    this.houveTracoEfetivo = true;
    
    // Captura o ponteiro no elemento canvas impedindo perda de rastreio ao mover rápido
    this.canvas.setPointerCapture(evento.pointerId);

    const { x, y } = this.obterCoordenadas(evento);
    this.ctx.beginPath();
    this.ctx.moveTo(x, y);
  }

  desenhar(evento) {
    if (!this.estaDesenhando) return;

    const { x, y } = this.obterCoordenadas(evento);
    this.ctx.lineTo(x, y);
    this.ctx.stroke();
  }

  finalizarDesenho(evento) {
    if (!this.estaDesenhando) return;
    this.estaDesenhando = false;
    this.ctx.closePath();

    if (evento.pointerId && this.canvas.hasPointerCapture(evento.pointerId)) {
      this.canvas.releasePointerCapture(evento.pointerId);
    }
  }

  limpar() {
    const dpr = window.devicePixelRatio || 1;
    this.ctx.clearRect(0, 0, this.canvas.width / dpr, this.canvas.height / dpr);
    this.houveTracoEfetivo = false;
  }

  exportarPngBase64() {
    if (!this.houveTracoEfetivo) {
      throw new Error('Assinatura obrigatória ausente. O fiscal ou condutor autuado deve assinar o termo.');
    }
    return this.canvas.toDataURL('image/png');
  }
}
```

---

### Caso Prático 2: Chaveador de Contexto Multi-Empresa com `localStorage` e `CustomEvent`

- **Microsserviço de Backend:** `portalservice` (:8080) e Hub Central de Microfrontends.
- **Problema de Negócio:** Um único representante legal logado via autenticação unificada Gov.br pode responder por múltiplas empresas permissionárias de transporte intermunicipal (por exemplo: Viação Araguarina, Expresso Goianésia e Cooperativa Central). Ao alternar a concessionária ativa no cabeçalho do portal, todos os microfrontends carregados na tela (frota, financeiro, certidões) precisam receber imediatamente o novo contexto empresarial com segurança, sem recarregar a página e sem quebrar a sessão.

```javascript
/**
 * Gerenciador de Contexto Multi-Empresa Reativo sem Frameworks
 */
class ContextoEmpresaManager {
  static CHAVE_LOCAL_STORAGE = 'agr:contexto:empresa_ativa';
  static NOME_EVENTO_CUSTOMIZADO = 'agr:contexto-alterado';

  /**
   * Define a empresa concessionária ativa e propaga o evento na janela
   */
  static definirEmpresaAtiva(empresa) {
    if (!empresa || !empresa.cnpj || !empresa.razaoSocial) {
      throw new Error('Dados da concessionária incompletos ou inválidos.');
    }

    // 1. Persistência local para sobreviver a recarregamentos de página (F5)
    localStorage.setItem(this.CHAVE_LOCAL_STORAGE, JSON.stringify(empresa));

    // 2. Disparo do CustomEvent nativo da W3C no escopo global
    const eventoNotificacao = new CustomEvent(this.NOME_EVENTO_CUSTOMIZADO, {
      detail: {
        cnpj: empresa.cnpj,
        razaoSocial: empresa.razaoSocial,
        registroRegulatorio: empresa.registroRegulatorio,
        timestampAlteracao: Date.now()
      },
      bubbles: true,
      composed: true // Atravessa Shadow DOM caso existam Web Components isolados
    });

    window.dispatchEvent(eventoNotificacao);
    console.log(`[CONTEXTO] Concessionária alterada com sucesso: ${empresa.razaoSocial} (CNPJ: ${empresa.cnpj})`);
  }

  /**
   * Recupera a empresa ativa atualmente no armazenamento local
   */
  static obterEmpresaAtiva() {
    const dadosSalvos = localStorage.getItem(this.CHAVE_LOCAL_STORAGE);
    if (!dadosSalvos) return null;
    try {
      return JSON.parse(dadosSalvos);
    } catch {
      return null;
    }
  }

  /**
   * Registra um ouvinte para que qualquer microfrontend reaja à troca de empresa
   */
  static escutarAlteracao(callbackReativo) {
    window.addEventListener(this.NOME_EVENTO_CUSTOMIZADO, (evento) => {
      callbackReativo(evento.detail);
    });
  }
}

// Exemplo de Inscrição em um Microfrontend de Frotas:
ContextoEmpresaManager.escutarAlteracao((contexto) => {
  console.log(`[FROTAS-APP] Recarregando frotas autorizadas para o CNPJ: ${contexto.cnpj}`);
  // Dispara nova consulta ao microsserviço cadastrounicoservice :8081
});
```

---

### Caso Prático 3: Validador e Conversor Bidirecional de Placas Mercosul em Tempo Real

- **Microsserviço de Backend:** `cadastrounicoservice` (:8081).
- **Problema de Negócio:** Na blitz rodoviária, o fiscal digita a placa tanto no padrão antigo de três letras e quatro números (`ABC-1234`) quanto no padrão Mercosul (`ABC1D23`). O sistema deve validar a máscara em tempo real e executar a conversão algorítmica exata segundo a **Resolução CONTRAN nº 780/2019**, na qual o segundo dígito numérico é mapeado para uma letra correspondente (`0=A, 1=B, ..., 9=J`).

```javascript
/**
 * Validador e Conversor de Padrão de Placas Veiculares Brasileiras (Resolução CONTRAN 780/2019)
 */
class ValidadorPlacaVeiculo {
  // Regex oficial Mercosul: 3 letras + 1 número + 1 letra + 2 números
  static REGEX_MERCOSUL = /^[A-Z]{3}[0-9][A-Z][0-9]{2}$/;

  // Regex oficial Antiga: 3 letras + 4 números (com ou sem hífen)
  static REGEX_ANTIGA = /^[A-Z]{3}-?[0-9]{4}$/;

  // Tabela oficial de conversão do segundo dígito numérico para letra
  static TABELA_CONVERSAO = {
    '0': 'A', '1': 'B', '2': 'C', '3': 'D', '4': 'E',
    '5': 'F', '6': 'G', '7': 'H', '8': 'I', '9': 'J'
  };

  // Tabela inversa: letra para dígito numérico
  static TABELA_INVERSA = {
    'A': '0', 'B': '1', 'C': '2', 'D': '3', 'E': '4',
    'F': '5', 'G': '6', 'H': '7', 'I': '8', 'J': '9'
  };

  /**
   * Sanitiza a entrada removendo espaços e caracteres especiais
   */
  static sanitizar(placaBruta) {
    return (placaBruta || '').replace(/[^A-Za-z0-9]/g, '').toUpperCase();
  }

  /**
   * Valida se a placa pertence a um dos dois padrões vigentes
   */
  static validar(placaBruta) {
    const placaLimpa = this.sanitizar(placaBruta);
    return this.REGEX_MERCOSUL.test(placaLimpa) || /^[A-Z]{3}[0-9]{4}$/.test(placaLimpa);
  }

  /**
   * Converte uma placa do padrão antigo (ex: NXY8890) para padrão Mercosul (NXY8J90)
   */
  static converterAntigaParaMercosul(placaAntigaBruta) {
    const limpa = this.sanitizar(placaAntigaBruta);
    if (!/^[A-Z]{3}[0-9]{4}$/.test(limpa)) {
      throw new Error(`A placa "${placaAntigaBruta}" não atende ao formato antigo válido (AAA9999).`);
    }

    const letrasIniciais = limpa.substring(0, 3);
    const primeiroNumero = limpa.charAt(3);
    const segundoNumero = limpa.charAt(4); // O segundo número torna-se a letra Mercosul
    const doisUltimosNumeros = limpa.substring(5, 7);

    const letraMercosul = this.TABELA_CONVERSAO[segundoNumero];
    return `${letrasIniciais}${primeiroNumero}${letraMercosul}${doisUltimosNumeros}`;
  }

  /**
   * Converte uma placa Mercosul (ex: NXY8J90) para o padrão antigo (NXY8890)
   */
  static converterMercosulParaAntiga(placaMercosulBruta) {
    const limpa = this.sanitizar(placaMercosulBruta);
    if (!this.REGEX_MERCOSUL.test(limpa)) {
      throw new Error(`A placa "${placaMercosulBruta}" não atende ao formato Mercosul válido (AAA9A99).`);
    }

    const letrasIniciais = limpa.substring(0, 3);
    const primeiroNumero = limpa.charAt(3);
    const letraMercosul = limpa.charAt(4);
    const doisUltimosNumeros = limpa.substring(5, 7);

    const digitoOriginal = this.TABELA_INVERSA[letraMercosul];
    if (!digitoOriginal) {
      throw new Error(`A letra "${letraMercosul}" não possui correspondente numérico na tabela CONTRAN.`);
    }

    return `${letrasIniciais}-${primeiroNumero}${digitoOriginal}${doisUltimosNumeros}`;
  }
}
```

---

## 6. Guia de Auditoria, Testes Manuais & Verificação Forense

### Matriz de Contrastes Tecnológicos (Legado vs Moderno)

| Dimensão Técnica | Padrão Legado (AlgaWorks / Portal 1 AGR) | Solução Moderna de Elite (Padrões 2026) |
|---|---|---|
| **Estrutura de Documento** | Div Soup (`<div id="header">`, `<div class="content">`), sem pontos de ancoragem acessíveis. | HTML5 Semântico (`<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`) com landmarks WAI-ARIA e Skip Links. |
| **Acessibilidade** | Falsos botões `<div onclick="...">`, ausência de ordem de foco por teclado, contraste deficiente (< 2:1). | WCAG 2.1 AA obrigatório, contraste superior a 4.5:1, foco visível com `:focus-visible` e atributos ARIA dinâmicos. |
| **Estilização e Nomenclatura** | Seletores fortemente acoplados à árvore (`#conteudo ul li a`), abuso generalizado de `!important`. | Metodologia BEM com especificidade plana `0-1-0`, proibição de IDs e eliminação de `!important`. |
| **Diagramação de Layout** | `float: left;` e `float: right;` com colapso de containers e hacks não semânticos de `clearfix`. | **Flexbox** para arranjos unidimensionais com `gap`; **CSS Grid** para arranjos bidimensionais com `auto-fit`. |
| **Identidade e Temas** | Códigos de cores hexadecimais literais espalhados por 50 arquivos; refatorações lentas e frágeis. | Design Tokens no `:root` via CSS Custom Properties (`var(--...)`), suporte a Dark Mode e Alto Contraste Governamental. |
| **Escopo de Variáveis** | Uso de `var` com escopo restrito a funções, vazamento fora de blocos `if` e poluição do objeto `window`. | Escopo de bloco estrito com `const` por padrão e `let` estrito; proteção nativa contra acessos prévios via Temporal Dead Zone (TDZ). |
| **Contexto de Funções** | Funções tradicionais `function()` com perda do `this` dinâmico, forçando o uso de hacks `var self = this;`. | Arrow Functions com `this` estritamente léxico, amarrado ao escopo da classe envolvente. |
| **Física do Assincronismo** | Suposição ingênua de que `setTimeout(..., 0)` é imediato; encadeamento de timers gerando condições de corrida. | Domínio do Event Loop: esvaziamento prioritário da fila de **Microtasks** (Promises) antes da fila de **Macrotasks** (Timers). |
| **Requisições de Rede** | Callback Hell em pirâmide de 10 níveis; requisições concorrentes obsoletas sobrescrevendo dados na tela. | `async/await` estruturado com `try/catch/finally`, consumo do padrão RFC 7807 e cancelamento cirúrgico via `AbortController`. |
| **Manipulação do DOM** | Injeção de 90 KB de jQuery para tarefas simples; travessias frágeis com `parentNode.parentNode`. | W3C Selectors API Nível 4 (`querySelector`, `closest`, `matches`), imune a mutações estruturais intermediárias. |
| **Performance e Segurança** | Concatenação de strings com `innerHTML += '...'`, gerando dezenas de reflows e vulnerabilidade crítica a XSS. | Renderização declarativa com `<template>`, montagem em lote com `DocumentFragment` e sanitização nativa com `.textContent`. |
| **Componentização** | Dependência de frameworks pesados para criar elementos visuais simples de status. | **Custom Elements** nativos da especificação Web Components estendendo `HTMLElement` com ciclo de vida padrão. |

---

## 7. Rastreabilidade com o Ecossistema AGR-Docs e Teatro-ABC

```
                                  MAPA DE INTEGRAÇÃO DO MÓDULO 01
                                  
   [ 01-fundamentos-web-e-javascript-vanilla.md ]
        │
        ├─► portalservice (:8080)
        │     • Chaveador de Concessionária Multi-Empresa (Caso Prático 2)
        │     • Modo de Alto Contraste Governamental e Tokens CSS (Seção 2.4)
        │     • Landmarks Semânticos e Acessibilidade WCAG 2.1 AA (Seção 1.1)
        │
        ├─► cadastrounicoservice (:8081)
        │     • Validação e Conversão de Placas Mercosul CONTRAN 780/2019 (Caso Prático 3)
        │     • Formulários Nativos com Constraint Validation API e inputmode (Seção 1.2)
        │     • Componente Nativo Web Component <agr-status-veiculo> (Seção 4.4)
        │
        ├─► agrfiscalservice / fiscalizacao (:8083 / :4203)
        │     • Canvas de Assinatura Digital com Pointer Events e HiDPI (Caso Prático 1)
        │     • Delegação de Eventos na Tabela de Abordagens e Autos (Seção 4.2)
        │     • Renderização em Lote com <template> e DocumentFragment (Seção 4.3)
        │     • Eliminação de Layout Thrashing com Batch Read/Write (Seção 1.4)
        │
        ├─► receitaservice (:8092)
        │     • Escopo de Bloco Lexical e Imutabilidade no Parcelamento de Autos (Seção 3.1)
        │     • Emissão de Guias de Arrecadação DARE via Delegação de Eventos (Seção 4.2)
        │
        └─► teatro-abc (:8090)
              • Mapa de Plateia Bidimensional com CSS Grid (Seção 2.3)
              • Delegação de Eventos de Clique em 1.200 Poltronas (Seção 4.2)
              • Assentos Especiais PCD com grid-column: span 2 e WAI-ARIA (Seção 1.3)
```

---
*Documento de Fundamentos Web & JavaScript Vanilla concluído com profundidade máxima, fidelidade aos padrões internacionais da W3C, conformidade com a Lei Brasileira de Inclusão e aplicação direta aos microsserviços do Estado de Goiás.* 🏛️⚡💻
