# 🗺️ MAPEAMENTO COMPLETO DA INSTALAÇÃO - SKYRIM SE v1.6.1170 + MO2

Este documento descreve exatamente a arquitetura da sua instalação para que você possa recriá-la, restaurá-la ou cloná-la a qualquer momento em 1 clique.

---

## 📁 1. Estrutura de Diretórios Críticos

| Caminho | Finalidade |
| :--- | :--- |
| `C:\Games\Skyrim Special Edition` | Instalação limpa do jogo base + SKSE 1.6.1170 + binário com proteções ativas. |
| `C:\Games\MO2` | Gerenciador isolado (Mod Organizer 2 portátil). Nenhum mod encosta na pasta original do jogo. |
| `C:\Games\MO2\mods` | Repositório de todos os mods instalados e descompactados (com correções de FOMOD aplicadas). |
| `C:\Games\MO2\profiles\Default` | Perfil ativo com a ordem de plugins, modlist e arquivos `.ini` otimizados (sem UTF-8 BOM). |
| `C:\Games\Tools\SSEEdit` | Ferramenta de limpeza e inspeção de plugins (registrada no MO2). |
| `C:\Games\Tools\LOOT` | Ordenador de load order compatível com 1.6.1170 (registrado no MO2). |
| `C:\Games\Skyrim_Setup_Automation` | **Base central da automação:** armazena o script de restauração e os backups de configuração. |

---

## ⚡ 2. Automação de Restauração em 1 Passo

Criamos a pasta central em [`C:\Games\Skyrim_Setup_Automation`](file:///C:/Games/Skyrim_Setup_Automation).

### Como rodar a automação:
1. Abra o PowerShell como Administrador.
2. Execute o comando:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Games\Skyrim_Setup_Automation\setup_skyrim.ps1"
```
Ou dê dois cliques no arquivo `run_setup.bat`.

### O que o script faz automaticamente:
1. Encerra qualquer processo pendente do jogo ou do MO2.
2. Restaura o perfil [Default](file:///C:/Games/MO2/profiles/Default) com:
   * Todos os **215 plugins** ativos e na ordem exata de carregamento.
   * Lista de mods com todos os mods desnecessários/conflitantes já desativados.
   * `skyrim.ini` e `skyrimprefs.ini` com alcance de grama expandido (`18000`) e suporte aos mods gráficos.
3. Garante a codificação limpa em UTF-8 sem BOM (evitando erros de leitura do MO2).
4. Restaura o executável blindado `SkyrimSE.exe` com as correções de ponteiro nulo (evitando crashes no *New Game*, menus de magia **P**, inventário **I** e trocas de células).
5. Valida as ferramentas de suporte (SSEEdit e LOOT) vinculadas ao [ModOrganizer.ini](file:///C:/Games/MO2/ModOrganizer.ini).

---

## 💎 3. Principais Modificações e Correções Ativas

1. **Vegetação e Paisagem:**
   * **Ulvenwald 3.3.2:** Árvores com animações e adições de vegetação/troncos densos no mapa todo.
   * **Cathedral Landscapes:** Tundra verde de Whiterun ativa (`20 Green Tundra`) + densidade de grama ajustada para `iMinGrassSize=40`.
   * **Skyland Bits and Bobs:** Retexturização otimizada de objetos e mobília (Performance Version).
2. **Correção de NPCs (FaceGen):**
   * **Bijin NPCs, Warmaidens e Wives:** Pastas de malha/textura de rosto migradas da subpasta `01 Characters` para a raiz, garantindo rostos perfeitos para Gerdur, Irileth, Aela, Lydia, etc.
   * **Pandorable's Males 2 e 3:** Plugins integrados e ativos na base da ordem de carga.
3. **Mundo e Navegação:**
   * **A Quality World Map (Vivid with Stone Roads):** Estradas de pedra desenhadas no mapa 3D com visão limpa.
