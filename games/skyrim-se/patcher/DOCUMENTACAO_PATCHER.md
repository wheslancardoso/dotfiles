# 🔬 DOCUMENTAÇÃO FORENSE DO PATCHER BINÁRIO (SkyrimSE.exe v1.6.1170)

Este documento registra as 3 blindagens cirúrgicas (115 bytes modificados) aplicadas diretamente nos offsets do `SkyrimSE.exe` para eliminar crashes de ponteiro nulo causados por sobreposição de mods.

---

## 🛠️ Como Usar o Patcher

Se você reinstalar o jogo ou tiver um `SkyrimSE.exe` original sem as proteções:
1. Vá até a pasta `00_CONFIGURACOES_E_AUTOMACAO\`
2. Dê **dois cliques** no arquivo:
   `run_patcher.bat`
   *(Ou execute pelo PowerShell: `.\patcher_skyrimse.ps1`)*
3. O script criará automaticamente o backup `SkyrimSE.exe.bak` e aplicará os 3 patches.

Para reverter para os bytes originais de fábrica:
```powershell
.\patcher_skyrimse.ps1 -Revert
```

---

## 📌 Detalhamento Técnico das 3 Blindagens

### 1. Patch 1: Crash no New Game / Carregamento Inicial
* **Função Afetada:** `InventoryChanges::InitScripts`
* **Endereço (RVA):** `0x22D567` (Offset no arquivo: `0x22C966`)
* **Problema:** Quando contêineres e barris do cenário (ex: mods como *JK's Skyrim*) possuem listas de inventário contendo referências de itens ainda não instanciadas, o registrador `r13` (`entry->object`) ficava zerado (`NULL`). Ao tentar executar `mov ecx, [r13+0x10]`, o jogo fechava com `EXCEPTION_ACCESS_VIOLATION`.
* **Solução:** Checagem de ponteiro nulo (`test r14, r14` / `test r13, r13`) antes da instrução de leitura, desviando para a próxima iteração caso o item seja nulo.

### 2. Patch 2: Crash ao Abrir Magias (**P**), Inventário (**I**) ou Favoritos (**Q**)
* **Função Afetada:** `InventoryChanges::Accept` (Visitor loop)
* **Endereço (RVA):** `0x231A70` (Offset no arquivo: `0x230E74`)
* **Problema:** Ao abrir menus como o de Magia (**P**), a engine executa o visitante `StoreEnchantedItemsVisitor` percorrendo a lista `InventoryChanges->entryList`. Se qualquer mod inseriu um nó com item vazio (`[rdx] == 0`), a chamada `call [rax+8]` disparava crash imediato em `SkyrimSE.exe+0941300`.
* **Solução:** Inserido `cmp qword ptr [rdx], 0; je loop` e corrigido o salto de término diretamente para o rótulo de saída (`mov rbx, [rsp+0x30]`), garantindo que listas vazias saiam limpamente preservando os registradores da chamada.

### 3. Patch 3: Crash de Transição de Células / Navegação de NPCs
* **Função Afetada:** `PathingCell`
* **Endereço (RVA):** `0x11BC70B` e `0x11BC77C` (Offset no arquivo: `0x11BBB0B` e `0x11BBB7C`)
* **Problema:** Quando NPCs calculam rotas cruzando bordas de células descarregadas, o ponteiro de célula (`rbx`) ou sua tabela virtual (`rdi`) podiam ser nulos momentaneamente, gerando crash no despacho virtual `call [rdi+0x50]`.
* **Solução:** Teste de validade (`test rbx, rbx` e `test rdi, rdi`) antes do despacho virtual de rota.
