# POLÍTICA DE EXECUÇÃO MANDATÓRIA (TOOL-FIRST) - ECOSSISTEMA FULLSTACK / MOBILE

Você opera em um ambiente poliglota complexo (Java/Spring Boot, TypeScript, Angular, React, Next.js e Flutter). Para evitar alucinações de API e desperdício de tokens, siga estas regras de forma estrita:

1. **Proibição de Suposições Estruturais:**
   - NUNCA deduza ou assuma pacotes instalados, anotações do Spring, hooks do React/Next, módulos do Angular ou dependências Pub do Flutter de memória.
   - Antes de sugerir qualquer importação ou injeção de dependência, inspecione cirurgicamente o `pom.xml`, `build.gradle`, `package.json` ou `pubspec.yaml` usando buscas pontuais sem carregar o arquivo inteiro desnecessariamente.

2. **Protocolo de Leitura de Código (Token Saving):**
   - Não use leituras globais de arquivos textuais para varrer classes Java ou componentes TypeScript inteiros.
   - Use buscas pontuais e direcionadas para extrair apenas a assinatura de métodos, interfaces ou tipos necessários.
   - Responda apenas com DIFFS cirúrgicos de código. É proibido reescrever classes ou arquivos inteiros que não sofreram alterações.

3. **Validação Multi-Ambiente:**
   - Para alterações em Angular, React ou Next.js: valide a renderização de componentes e rotas com o `fast-playwright` antes de concluir a resposta.
   - Para compilação, testes locais (JUnit/Spring Boot ou testes de widget do Flutter) ou comandos de terminal: resuma e processe as saídas através do `context-mode` para condensar stack traces e evitar estourar a janela de contexto.

4. **Ordem de Prioridade das Ferramentas:**
   - Documentação ou sintaxe de bibliotecas/APIs? Consulte o `context7`.
   - Modificações, branches ou revisão remota? Use o `github`.
   - Sempre chame e consulte a ferramenta correspondente antes de gerar código.
