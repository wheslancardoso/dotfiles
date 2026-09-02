# ✍️ Guia Padrão Ouro de Nomenclatura de Arquivos

Adotar um padrão consistente de nomes de arquivos elimina a necessidade de abrir documentos para saber do que se tratam e facilita buscas instantâneas pelo Windows Search, Everything ou terminal.

---

## 💎 Fórmula Mestre

```text
[DATA_ISO]_[CATEGORIA_OU_PROJETO]_[DESCRICAO-CLARA]_[VERSAO_OU_STATUS].[EXT]
```

### Exemplo Prático:
- ✅ **Bom**: `2026-08-27_TCE-GO_Operacao-Posse-Caderno-Questoes_v2.pdf`
- ❌ **Ruim**: `questoes novas (1) final.pdf`

---

## 📌 Regras de Ouro

1. **Datas sempre no formato ISO (`YYYY-MM-DD` ou `YYYYMMDD`)**:
   - `2026-08-27_Contrato_WFIX.pdf`
   - *Por quê?* Garante que a ordenação alfabética padrão seja sempre cronológica.

2. **Evite caracteres especiais e espaços excessivos**:
   - Use `_` (underline) para separar blocos lógicos.
   - Use `-` (hífen) para separar palavras dentro do mesmo bloco.
   - Exemplo: `2026-07_Viagem-Brasilia_Relatorio-Despesas.xlsx`

3. **Controle de Versão Claro**:
   - Evite `final_do_final.docx`.
   - Use sufixos semânticos: `_v1`, `_v2`, `_draft`, `_review`, `_aprovado`.

4. **Documentos Pessoais & Fiscais**:
   - `Comprovante_Residencia_Enel_2026-08.pdf`
   - `Certificado_Conclusao_Pos-Graduacao_2026.pdf`
   - `Holerite_2026-07_Wheslan.pdf`
