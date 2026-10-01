# 📍 ESTADO ATUAL DO LABORATÓRIO (DIÁRIO DE BORDO VIVO)

> **INSTRUÇÃO PARA O AGENTE DE IA (TECH LEAD MENTOR):**
> 1. Leia este arquivo OBRIGATORIAMENTE no início de cada sessão para recuperar o contexto exato sem perguntar nada ao dev.
> 2. No final de cada sessão concluída ou alteração de código, atualize este arquivo com o progresso real.

---

## 📌 SITUAÇÃO ATUAL DA MISSÃO
* **Fase Atual:** [FASE 1: Fundação, Autenticação e Clean Architecture](file:///PLANO-DE-VOO.md)
* **Status:** 🟡 Pronto para Inicialização do Repositório (Setup Inicial)
* **Última Sessão Realizada:** Planejamento e Arquitetura do Laboratório concluídos.
* **Próximo Passo Imediato (Mãos no Teclado):**
  - Inicializar o projeto Spring Boot 3.x com Java 17+ (dependências: Web, Security, JPA, Validation, Flyway, Postgres/MySQL).
  - Criar o primeiro `docker-compose.yml` para subir o banco de dados de desenvolvimento.

---

## 📋 HISTÓRICO DE MARCOS CONCLUÍDOS
- [x] Mapeamento dos 25 sistemas e acervo de Megadocs concluído.
- [x] Elaboração do Plano de Voo (6 fases de reconstrução).
- [ ] Fase 1: Setup e Autenticação JWT Stateless.
- [ ] Fase 2: CADU & Flyway Migrations.
- [ ] Fase 3: Fiscalização, Vistorias e MinIO Storage.
- [ ] Fase 4: Gateways e Resiliência (Circuit Breakers).
- [ ] Fase 5: Regulação Econômica e Emissão de DARE/PIX.
- [ ] Fase 6: Teatro-ABC (Bilhetagem, Concorrência e QR Code).

---

## 🧠 DECISÕES ARQUITETURAIS TOMADAS (ADRs)
1. **Linguagem & Framework:** Java 17+ / Spring Boot 3.x (Clean Architecture com domínio puro sem dependência de anotações de framework).
2. **Armazenamento de Arquivos:** Substituição do SMB Windows local (`10.6.63.2`) por Object Storage compatível com AWS S3 (MinIO no ambiente local).
3. **Persistência & Migrations:** Flyway como ferramenta mandatória de versionamento de banco (adeus scripts SQL rodados manualmente).
4. **Contratos & DTOs:** Uso extensivo de Java Records para DTOs imutáveis e Bean Validation para rejeitar dados inválidos na borda da aplicação.

---

## 📝 DÚVIDAS / PONTOS DE ATENÇÃO PARA A PRÓXIMA SESSÃO
* Definir se o banco local padrão do laboratório será PostgreSQL ou MySQL 8 (Recomendação: PostgreSQL para Clean Arch moderna, ou MySQL 8 para espelhar a AGR).
