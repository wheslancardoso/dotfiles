# ⛏️ ENCICLOPÉDIA DEFINITIVA DO MINECRAFT: "MAPA ETERNO & CASA AUTOMÁTICA"
> **Versão do Jogo:** Minecraft 1.20.1 (Fabric Loader 0.16.10)  
> **Launcher Canônico:** Prism Launcher (Nativo CachyOS/Arch com suporte a contas offline)  
> **Hardware de Referência:** AMD Ryzen 7 5700X (8C/16T) • NVIDIA GeForce RTX 5060 (8 GB RAM alocados na JVM)  
> **Script de Automação:** `~/dotfiles/scripts/setup-minecraft.sh`  
> **Total de Mods Instalados e Auditados:** 65 Mods Especializados

---

## 🎯 ÍNDICE GERAL
1. [Filosofia do Setup: Zero Atrito, Zero Traumas](#-1-filosofia-do-setup-zero-atrito-zero-traumas)
2. [Guia de Utilização das Armas Anti-Atrito & Controles](#-2-guia-de-utilização-das-armas-anti-atrito--controles)
3. [Catálogo Completo dos 65 Mods (Nome, Função e Explicação Cirúrgica)](#-3-catálogo-completo-dos-65-mods)
4. [Shaderpack Complementary Reimagined & Motor Gráfico](#-4-shaderpack-complementary-reimagined--motor-gráfico)
5. [Passo a Passo: Como Iniciar e Jogar Hoje](#-5-passo-a-passo-como-iniciar-e-jogar-hoje)
6. [Manutenção, Backup & Reprodutibilidade no Dotfiles](#-6-manutenção-backup--reprodutibilidade-no-dotfiles)

---

## 🛡️ 1. FILOSOFIA DO SETUP: ZERO ATRITO, ZERO TRAUMAS

O Minecraft original (Vanilla) é notório por gerar atrito repetitivo que desestimula jogadores que buscam construir projetos de longo prazo ("Mapa Eterno" ou estilo "Em Busca da Casa Automática"):
* **Atrito de Tempo:** Horas minerando bloco por bloco, quebrando troncos árvore por árvore, organizando centenas de baús individuais.
* **Atrito de Perda & Frustração:** Creepers explodindo construções com fiação de redstone, cascalho caindo na cabeça e sufocando o jogador, perder armadura na lava por conta do timer cruel de 5 minutos, ou matar pets por fogo amigo acidental.
* **Atrito de Deslocamento & Animais:** Ficar 40 minutos andando pelo mapa para voltar da mina, puxar animais burros com laço frágil que arrebenta ou empurrar barcos e trilhos com Villagers teimosos.

Esta suíte foi construída para **eliminar cirurgicamente cada uma dessas dores**, mantendo o jogo 100% fiel à essência Vanilla, mas adicionando a fluidez e a conveniência de um RPG de engenharia moderno.

---

## 🎮 2. GUIA DE UTILIZAÇÃO DAS ARMAS ANTI-ATRITO & CONTROLES

| Ação Desejada | Mod Responsável | Como Executar no Teclado / Jogo |
| :--- | :--- | :--- |
| **Capturar Animais/Mobs no Bolso (Pokébola)** | `Mob Lassos` | Crie o **Golden Lasso** (para animais pacíficos) ou **Diamond Lasso** (para qualquer mob). Mire no bicho e dê **Botão Direito**. O animal vira um item no seu bolso! Clique com Botão Direito no chão para soltá-lo onde quiser. |
| **Carregar Mobs e Baús nos Braços** | `Carry On` | Mãos vazias: mire no animal, Villager ou baú cheio e aperte **`Shift + Botão Direito`**. Solte no destino com outro Botão Direito. |
| **Reprodução Automática de Animais** | `Animal Feeding Trough` | Coloque o bloco do **Cocho de Alimentação** no pasto e encha-o com trigo, sementes ou cenoura. Os animais se alimentam e **procriam sozinhos** sem você precisar clicar em nenhum deles! |
| **Consultar Alimento de Procriação no JEI** | `Just Enough Breeding` | Abra o JEI no inventário, procure o animal e veja exatamente qual comida ele come para cruzar e quanto tempo dura a gestação/cooldown. |
| **Minerar Veio Inteiro em 1 Segundo** | `Diggus Maximus` | Mire no minério (carvão, ferro, diamante, redstone) ou pedra, **segure a tecla de aspa/til (`~` ou `'`)** e minere o primeiro bloco. Todo o veio cai na hora. |
| **Derrubar Árvores Instantaneamente** | `FallingTree` | Pegue qualquer machado e quebre o bloco da base do tronco da árvore. A árvore inteira desaba no chão com folhas, maçãs e mudas. |
| **Abrir Mochila com Auto-Coleta** | `Traveler's Backpack` | Pressione a tecla **`B`** para abrir sua mochila. Equipe-a nas costas para ativar o auto-pickup de pedras e minérios na mina. |
| **Radar de Diamantes nas Paredes** | `Scannable` | Segure o Scanner com **Botão Direito**. Ele dispara um sonar que ilumina todos os minérios de diamante, ouro e ferro através da pedra! |
| **Quebrar Blocos em Área de 3x3** | `Just Hammers` | Equipe um martelo de mineração e bata na rocha. Quebra 9 blocos por clique instantaneamente. |
| **Localizar Qualquer Estrutura do Mundo** | `Explorer's Compass` | Segure a bússola e clique com **Botão Direito**. Escolha a estrutura desejada (Fortaleza do Nether, Portal do End, Vila, Mansão, Bastion) e siga a agulha. |
| **Localizar Qualquer Bioma** | `Nature's Compass` | Segure a bússola e clique com **Botão Direito**. Escolha o bioma (Cerejeiras, Selva, Deserto) e siga a agulha na tela. |
| **Ver Slime Chunks em 3D no Chão** | `MiniHUD` | Pressione **`H`** para abrir o menu de overlays e ative `Slime Chunks` (ou atalho rápido configurável). Uma caixa 3D verde fluorescente aparecerá delimitando os 16x16 blocos do chunk de slime. |
| **Construir Paredes e Pisos com 1 Clique** | `Building Wands` | Mire na face de uma parede ou chão segurando a varinha e dê **Botão Direito**. Ela expandirá a superfície instantaneamente consumindo os blocos do seu inventário. |
| **Fazer Pontes Correndo para Frente** | `Bridging Mod` | Corra em direção ao abismo olhando para a frente e segure o **Botão Direito com blocos na mão**. Os blocos serão posicionados sob os seus pés automaticamente, sem necessidade de andar de ré agachado no Shift. |
| **Acessar Todos os Baús da Base em 1 Tela** | `Tom's Simple Storage` | Coloque o bloco *Inventory Connector* encostado na sua parede de baús e coloque o *Crafting Terminal*. Abra o terminal para ver e buscar todos os itens da base com barra de pesquisa. |
| **Colher e Replantar Fazendas** | `RightClickHarvest` | Mire no trigo, batata ou cenoura madura e dê **Botão Direito**. O alimento vai para sua mão e a semente é replantada automaticamente no mesmo milissegundo. |
| **Apagar Lixo do Inventário** | `TrashSlot` | Abra o inventário, passe o mouse sobre o bloco inútil (ex: cascalho, diorito) e aperte **`Delete`**, ou arraste-o até o ícone de lixeira no canto inferior direito. |
| **Abrir Mapa-Múndi e Ver Coordenadas** | `Xaero's World Map` | Pressione **`M`** para abrir o mapa em tela cheia com relevo, cavernas e marcadores de vilas e mortes. |
| **Ver Receitas de Crafting** | `JEI` | Abra o inventário e clique em qualquer item na lista lateral direita (ou aperte **`R`** sobre o item para ver a receita, e **`U`** para ver onde ele é usado). |
| **Alternar Shaders em Tempo Real** | `Iris` | Pressione a tecla **`K`** para ligar ou desligar os shaders Complementary Reimagined instantaneamente. |

---

## 📚 3. CATÁLOGO COMPLETO DOS 40 MODS INSTALADOS

Abaixo está o registro exato de todos os 40 arquivos `.jar` presentes na pasta `.minecraft/mods/` da instância:

### Grupo A: Eliminação de Dores & Traumas Clássicos (Pain Killers)
1. **`gravelminer-fabric-1.20-16.0.4.jar` (GravelMiner):**  
   *Elimina o sofrimento do cascalho.* Quando um teto de cascalho ou areia desaba sobre você na caverna, o mod detecta a gravidade e destrói os blocos automaticamente no ar, impedindo sufocamento e perda de tempo com pá.
2. **`NoCreeperGriefing-1.2-1.20.1-SNAPSHOT.jar` (No Creeper Griefing):**  
   *Protege sua base de explosões.* Se você vacilar perto de um Creeper, ele explodirá e causará dano normal ao seu jogador, mas **nenhum bloco do cenário, construções ou fiações de redstone será quebrado**.
3. **`FriendlyFire-Fabric-1.20.1-18.0.8.jar` (Friendly Fire):**  
   *Protege seus pets e aliados.* Impede que golpes de espada ou flechas acidentais causem dano a cães domesticados, gatos, cavalos e aldeões amigos durante batalhas.
4. **`elytraslot-fabric-6.4.4+1.20.1.jar` (Elytra Slot):**  
   *Fim da morte boba no ar.* Adiciona um slot dedicado para a Elytra. Você pode usar seu Peitoral de Netherita com Proteção IV **e** a Elytra ao mesmo tempo, voando sempre blindado.
5. **`graves-3.0.3+1.20.1.jar` (Universal Graves):**  
   *Fim do sumiço de itens ao morrer.* Cria um túmulo impenetrável e à prova de lava/fogo no local exato da morte. O ponto é marcado com um ícone no seu minimapa e não existe limite de tempo para resgatar seus equipamentos.
6. **`trashslot-fabric-1.20.1-15.1.5.jar` (TrashSlot):**  
   *Lixeira de inventário rápida.* Adiciona uma lixeira elegante no canto da tela do inventário. Arraste qualquer item indesejado para ela ou passe o mouse e aperte `Delete`.
7. **`shulkerboxtooltip-fabric-4.0.4+1.20.1.jar` (ShulkerBoxTooltip):**  
   *Raio-X de caixas e mochilas.* Mostra uma janela flutuante com a grade visual completa de itens dentro de qualquer Shulker Box, mochila ou bundle simplesmente passando o mouse por cima no inventário, sem necessidade de posicioná-la no chão.
8. **`appleskin-fabric-mc1.20.1-2.5.2.jar` (AppleSkin):**  
   *Previsão de alimentação.* Mostra exatamente quanto de vida, fome e saturação oculta cada comida vai restaurar na sua barra antes de você comê-la.

### Grupo B: Coleta Rápida & Mineração Frugal
9. **`diggusmaximus-1.5.9-1.20.jar` (Diggus Maximus):**  
   *Vein miner personalizável.* Segure a tecla da aspa/til (`~`) e quebre um minério de ferro, carvão, ouro, redstone ou diamante para quebrar todo o veio conectado instantaneamente.
10. **`FallingTree-1.20.1-4.3.4.jar` (FallingTree):**  
    *Corte florestal em cascata.* Quebre o bloco inferior de qualquer árvore com um machado e o tronco inteiro desabará no chão, quebrando também as folhas e dropando mudas e galhos.
11. **`carryon-fabric-1.20.1-2.1.2.7.jar` (Carry On):**  
    *Transporte manual de entidades.* Permite levantar Villagers teimosos, animais domésticos, baús com itens e fornalhas no colo usando `Shift + Botão Direito` com as mãos vazias, eliminando o sofrimento com trilhos e barcos.
12. **`travelersbackpack-fabric-1.20.1-9.1.55.jar` (Traveler's Backpack):**  
    *Mochila de exploração inteligente.* Abre com a tecla `B`. Possui compartimentos extras gigantes, auto-pickup com filtros para blocos de mineração, mesa de trabalho e fornalha embutidas.
13. **`rightclickharvest-fabric-4.6.1+1.20.1.jar` (RightClickHarvest):**  
    *Colheita de fazendas sem quebra.* Basta clicar com o botão direito nas plantações maduras: o alimento é colhido e a semente é replantada no mesmo instante.

### Grupo C: Construção de Elite & Organização de Baús
14. **`building-wands-fabric-MC1.20.1-3.0.5.jar` (Building Wands):**  
    *Varinhas mágicas de construção.* Expande paredes, telhados, pisos e montanhas com um único clique do mouse, consumindo blocos do inventário em formatos customizados (linhas, retângulos, círculos).
15. **`bridging-mod-2.5.1+1.20.1.fabric-release.jar` (Bridging Mod):**  
    *Pontes estilo Bedrock.* Permite construir pontes correndo diretamente para frente sobre o vazio, colocando os blocos à frente do jogador sem risco de queda.
16. **`toms_storage_fabric-1.20-1.7.1.jar` (Tom's Simple Storage Mod):**  
    *Centralização de estoque.* Conecta todos os baús da sua base a um terminal único com barra de busca, eliminando a bagunça de ter dezenas de baús espalhados.
17. **`InventorySorter-1.9.0-1.20.jar` (Inventory Sorter):**  
    *Organização de inventário.* Ordena baús e inventário por nome, quantidade ou categoria através de atalhos configuráveis.
18. **`MouseTweaks-fabric-mc1.20-2.26.jar` (Mouse Tweaks):**  
    *Manipulação ágil de itens.* Permite arrastar o mouse segurando o botão para puxar ou espalhar fileiras inteiras de itens nos baús e grades de crafting.
19. **`litematica-fabric-1.20.1-0.15.4.jar` (Litematica):**  
    *Hologramas 3D de projetos.* Carrega esquemas `.litematic` do YouTube ou da internet e projeta uma cópia holográfica tridimensional no seu mundo para você construir por cima sem margem de erro.
20. **`malilib-fabric-1.20.1-0.16.3.jar` (MaLiLib):**  
    *Biblioteca de suporte.* Fornece a infraestrutura de interface, atalhos e renderização necessária para o Litematica e o MiniHUD.

### Grupo D: Navegação, Deslocamento & Localizadores
21. **`waystones-fabric-1.20.1-14.1.21.jar` (Waystones):**  
    *Pontos de teletransporte rápido.* Permite ativar monumentos de pedra (Waystones) pelo mapa e usar pergaminhos de retorno (*Warp Scrolls*) para voltar instantaneamente da camada -58 para a sua casa.
22. **`ExplorersCompass-1.20.1-2.6.0-fabric.jar` (Explorer's Compass):**  
    *Bússola de estruturas.* Interface gráfica que busca e aponta para qualquer fortaleza do Nether, portal do End, vila, monumento oceânico ou cidade ancestral.
23. **`NaturesCompass-1.20.1-2.6.0-fabric.jar` (Nature's Compass):**  
    *Bússola ecológica.* Busca e aponta para qualquer bioma do mundo normal, do Nether e do End.
24. **`minihud-fabric-1.20.1-0.27.1.jar` (MiniHUD):**  
    *Radar técnico & Slime Chunks.* Desenha caixas 3D coloridas no chão indicando os limites dos Slime Chunks, bounding boxes de fortalezas e níveis de iluminação.
25. **`BetterF3-7.0.2-Fabric-1.20.1.jar` (BetterF3):**  
    *F3 limpo e moderno.* Substitui a poluição visual do F3 padrão por caixas coloridas organizadas (FPS, bioma, coordenadas, memória).
26. **`xaerominimap-fabric-1.20.1-26.5.0.jar` (Xaero's Minimap):**  
    *Minimapa no canto da tela.* Mostra entidades ao redor, terreno, cavernas e pontos de marcação (*waypoints*).
27. **`xaeroworldmap-fabric-1.20.1-1.46.0.jar` (Xaero's World Map):**  
    *Mapa-múndi interativo.* Abre um mapa gigante do mundo explorado com a tecla `M`, permitindo criar marcos e visualizar toda a extensão da sua base.
28. **`jei-1.20.1-fabric-15.62.0.217.jar` (Just Enough Items - JEI):**  
    *Catálogo de receitas.* Exibe todas as receitas de itens, blocos e poções na barra lateral do inventário com teclas de busca rápida (`R` e `U`).

### Grupo E: Performance Extrema & Otimização do Java (CachyOS + RTX 5060)
29. **`sodium-fabric-0.5.13+mc1.20.1.jar` (Sodium):**  
    *Motor de renderização moderno.* Substitui a pipeline arcaica do OpenGL da Mojang por shaders modernos, multiplicando a taxa de quadros e eliminando quedas de FPS.
30. **`iris-1.7.6+mc1.20.1.jar` (Iris Shaders):**  
    *Pipeline de shaders de alta performance.* Permite executar shaders com renderização direta no Sodium, aproveitando o poder bruto da RTX 5060.
31. **`lithium-fabric-mc1.20.1-0.11.4.jar` (Lithium):**  
    *Otimização de física e IA de mobs.* Acelera o processamento de entidades, chunks e redstone no agendador de threads da CPU (Ryzen 7 5700X).
32. **`ferritecore-6.0.1-fabric.jar` (FerriteCore):**  
    *Redução de consumo de RAM.* Compacta modelos 3D e estados de blocos na memória Java, reduzindo o uso de memória em até 40%.
33. **`modernfix-fabric-5.25.2+mc1.20.1.jar` (ModernFix):**  
    *Acelerador de inicialização & Anti-Memory Leak.* Corrige vazamentos de memória na engine do jogo e acelera o carregamento do mapa.
34. **`indium-1.0.36+mc1.20.1.jar` (Indium):**  
    *Compatibilidade com Fabric Rendering API.* Permite que mods de blocos customizados (como Continuity e Create) funcionem perfeitamente em cima do Sodium.
35. **`Clumps-fabric-1.20.1-12.0.0.4.jar` (Clumps):**  
    *Anti-lag de XP.* Agrupa milhares de pequenas esferas de experiência em uma única entidade concentrada, permitindo mega farms sem travamentos.
36. **`continuity-3.0.0+1.20.1.jar` (Continuity):**  
    *Vidros conectados contínuos.* Remove as linhas pretas e bordas feias entre blocos de vidro adjacentes, criando janelas e aquários cristalinos.
37. **`lambdynamiclights-4.4.0+1.20.1.jar` (LambDynamicLights):**  
    *Iluminação dinâmica.* Tochas, lanternas e itens luminosos segurados na mão ou jogados no chão iluminam o ambiente ao redor em tempo real.

### Grupo F: Infraestrutura & Bibliotecas de Suporte
38. **`fabric-api-0.92.12+1.20.1.jar` (Fabric API):**  
    *API central do ecossistema Fabric.* Permite a comunicação e o carregamento seguro de todos os mods instalados.
39. **`cloth-config-11.1.136-fabric.jar` (Cloth Config v11):**  
    *Telas de configuração.* Fornece a interface gráfica padronizada para os menus de configuração de dezenas de mods.
40. **`modmenu-7.2.2.jar` (Mod Menu):**  
    *Menu de gerenciamento.* Adiciona o botão "Mods" na tela inicial do jogo para consultar, ajustar e configurar qualquer um dos mods sem sair do Minecraft.

### Grupo G: Drops Justos (100%), Comércio Sem Quebrar Bancada & Super Agricultura
41. **`alwaysawitherskull-1.20.1-3.5.jar` (Always A Wither Skull):**  
    *Fim da roleta russa do Wither.* Todo Wither Skeleton morto **SEMPRE dropa a caveira de esqueleto wither com 100% de certeza**! Matou 3 no Nether? Já tem as 3 cabeças garantidas para invocar o Wither e pegar o Farol (Beacon).
42. **`shulkerdropstwo-1.20.1-3.5.jar` (Shulker Drops Two):**  
    *Caixa de Shulker garantida.* Todo Shulker morto nas Cidades do End **SEMPRE dropa 2 cascas completas** (o suficiente para montar 1 Shulker Box inteira por bicho, sem chance de dropar zero).
43. **`trade-cycling-fabric-1.20.1-1.0.18.jar` (Trade Cycling):**  
    *Fim do sofrimento com Aldeões.* Quando você estiver escolhendo os livros do Aldeão Bibliotecário, aparece uma **setinha verde dentro do menu de troca**. Basta clicar na setinha para girar os encantamentos instantaneamente, **sem precisar quebrar e recolocar o Atril 300 vezes** até vir Remendo (Mending) ou Fortuna III!
44. **`extendedbonemeal-1.20.1-3.6.jar` (Extended Bone Meal):**  
    *Farinha de osso universal.* Permite usar farinha de osso em **TUDO**: faz crescer cana-de-açúcar instantaneamente, cactos, videiras, fungos do nether e flores, além de acelerar mudas teimosas.
45. **`farmers-delight-fabric-1.4.3.jar` (Farmer's Delight):**  
    *A revolução da agricultura e comida.* Adiciona plantações de tomates, cebolas, arroz e repolho, facas para cortar carne, panelas de cozimento para fazer ensopados e banquetes que concedem efeitos de regeneração e super saturação duradouros.
### Grupo H: Vilas Blindadas, Bigorna Infinita, Mega Baús & Recarga Automática
47. **`zombieproofdoors-1.20.1-3.5.jar` (Zombie-Proof Doors):**  
    *Aldeões imunes a invasão.* Zumbis **NUNCA MAIS conseguem quebrar as portas de madeira das casas das vilas**! Quando a noite cair, os Aldeões entram em casa, fecham a porta e ficam 100% seguros contra qualquer horda. Zero risco de acordar e ver a vila vazia ou infectada.
48. **`ironchests-5.0.2-fabric.jar` (Iron Chests: Restocked):**  
    *Armazenamento massivo de minérios.* Adiciona baús de Cobre, Ferro, Ouro, Diamante e Netherita. Um único Baú de Diamante guarda até **108 slots** (mais que o dobro de um baú duplo comum), ideal para guardar montanhas de pedra, ferro e carvão ocupando o espaço de apenas 1 bloco!
49. **`anvilrestoration-1.20.1-2.4.jar` (Anvil Restoration):**  
    *Bigorna Indestrutível.* No jogo original, consertar itens faz a bigorna rachar e quebrar após alguns usos. Com este mod, a bigorna **NUNCA quebra e dura para sempre**.
50. **`fixedanvilrepaircost-1.20.1-3.5.jar` (Fixed Anvil Repair Cost):**  
    *Fim do 'MUITO CARO!' (Too Expensive).* Acaba com o limite cruel do Minecraft que impedia você de continuar reparando ou combinando livros na sua espada ou armadura favorita após o custo passar de 40 níveis de XP. Agora você pode consertar e aprimorar seus itens eternamente por um custo fixo e justo de XP!
51. **`stackrefill-1.20.1-4.9.jar` (Stack Refill):**  
    *Recarga automática na mão.* Acabou o bloco de pedra, a tocha, a comida ou quebrou a ferramenta que estava na sua mão principal? O mod puxa **automaticamente** outro bloco ou ferramenta idêntica do seu inventário para a sua mão no mesmo instante, sem você precisar abrir o inventário para repor.
52. **`infinitetrading-1.20.1-5.0.jar` (Infinite Trading):**  
    *Aldeões com comércio ilimitado.* O Aldeão **NUNCA bloqueia as trocas com uma cruz vermelha**. Se você tiver 5 baús cheios de trigo, cenoura ou gravetos, você pode trocar tudo por esmeraldas em uma única sessão, sem ele travar e pedir para esperar o dia seguinte.
53. **`Neat-1.20.1-41-FABRIC.jar` (Neat - Health Bars):**  
    *Barras de vida visuais estilo RPG.* Exibe discretamente uma barra de vida, armadura e nome em cima de qualquer monstro, chefe ou animal que você estiver olhando, permitindo saber exatamente quanta vida falta para derrotá-lo.
54. **`Loot Beams Refork-fabric-1.20.1-3.4.7.jar` (Loot Beams):**  
    *Feixes de luz em drops raros.* Itens jogados no chão emitem um feixe vertical de luz brilhante colorido de acordo com a sua raridade (estilo RPG/Borderlands/Diablo). Você nunca mais vai perder um diamante ou barra de Netherita que caiu no meio da grama ou no escuro da caverna.
55. **`BetterFurnacesReforged-1.20.1-1.1.2518.1-fabric.jar` (Better Furnaces Reforged):**  
    *Fornalhas Industriais Ultra-Rápidas.* Adiciona fornalhas de Ferro, Ouro, Diamante e Netherita. Uma fornalha de Diamante ou Netherita com upgrades de velocidade **funde 64 minérios ou carnes em questão de 3 a 5 segundos**! Possui upgrades de auto-inserção de combustível e auto-extração de itens para os baús conectados.

### Grupo I: Anti-Warden & Mineração Turbo com Radar de Diamantes
56. **`no-warden-1.0.jar` (No Warden):**  
    *Extermínio do monstro mais injusto do jogo.* O Warden **NUNCA MAIS NASCE** no seu mundo! Os sensores e shriekers das Cidades Ancestrais não invocam o bicho. Você pode correr, quebrar blocos, pular e saquear os baús mais raros das profundezas em paz absoluta, sem aquela escuridão pulsante cegando sua tela.
57. **`scannable-MC1.20.1-fabric-1.7.12+18ccb75.jar` (Scannable - Radar Portátil de Diamantes):**  
    *O fim de minerar às cegas.* Adiciona um Scanner portátil de mão. Segure o botão direito para disparar uma onda sonora de sonar: o scanner emite um bipe e **projeta um contorno 3D iluminado através da pedra sólida destacando todos os blocos de Diamante, Ouro, Ferro e baús escondidos** num raio de dezenas de blocos! Você cava direto no minério.
58. **`justhammers-fabric-20.1.5+mc1.20.1.jar` (Just Hammers - Mineração 3x3):**  
    *Escavação de túneis 9x mais rápida.* Adiciona martelos de Pedra, Ferro, Diamante e Netherita. Ao invés de quebrar 1 bloquinho por vez, cada batida do martelo quebra uma área inteira de **3x3 blocos (9 blocos por clique)**, abrindo túneis gigantes e desenterrando minérios em velocidade supersônica.

### Grupo J: Construção de Arquiteto Sem Esforço & Decoração de Luxo
59. **`mcw-roofs-2.3.2-mc1.20.1fabric.jar` (Macaw's Roofs):**  
    *Fim da casa em formato de caixa de sapato.* Fazer telhado bonito com escadas comuns no Minecraft é um dos maiores pesadelos para quem não é construtor profissional. Este mod adiciona **telhados inclinados perfeitos, calhas, quinas e cúpulas pré-fabricadas** de todas as madeiras e pedras. Sua casa fica parecendo um chalé suíço ou castelo medieval em 5 minutos!
60. **`mcw-bridges-3.1.2-mc1.20.1fabric.jar` (Macaw's Bridges):**  
    *Pontes cinematográficas instantâneas.* Adiciona pontes suspensas de corda, pontes de madeira rústica e pontes de pedra com corrimão e pilares automáticos que se adaptam à altura da água ou do desfiladeiro.
61. **`mcw-furniture-3.4.1-mc1.20.1fabric.jar` (Macaw's Furniture):**  
    *Móveis funcionais prontos.* Guarda-roupas com portas que abrem, mesas de cabeceira, escrivaninhas, gaveteiros e armários de cozinha que realmente guardam itens. Chega de improvisar mesa com cerca e placa de pressão!
62. **`handcrafted-fabric-1.20.1-3.0.6.jar` (Handcrafted):**  
    *O auge da decoração estética.* Adiciona sofás aconchegantes com almofadas coloridas, cadeiras estofadas, cortinas esvoaçantes para janelas, pratos, xícaras e bancadas de mármore. Transforma qualquer construção simples em uma mansão com cara de projeto de designer de interiores.

### Grupo K: Captura de Animais & Reprodução Automática (Zero Estresse de Laço)
63. **`MobLassos-v8.0.1-1.20.1-Fabric.jar` (Mob Lassos - A "Pokébola" Perfeita):**  
    *Captura instantânea de qualquer animal ou monstro no bolso.* O laço do Vanilla é terrível: exige slime ball (difícil no começo), arrebenta toda hora se você andar rápido e os animais ficam travando em árvores e blocos. O Mob Lassos adiciona o **Golden Lasso** (para animais pacíficos como vacas, ovelhas, cavalos, galinhas e cães) e o **Diamond Lasso** (para qualquer mob). Basta dar **Botão Direito no animal**: ele é capturado instantaneamente para dentro do laço no seu inventário, guardando sua vida, cor e nome! Você pode carregar dezenas de vacas no bolso e soltá-las na sua base com outro clique.
64. **`animal_feeding_trough-1.1.0+1.20.1.jar` (Animal Feeding Trough - Cocho de Procriação Automática):**  
    *Animais reproduzem sozinhos sem você precisar clicar em nenhum.* Elimina o tédio de ficar segurando trigo/cenoura e clicando bicho por bicho num cercado apertado. Cria um bloco de **Cocho de Madeira**. Você coloca o cocho no chão e joga trigo, sementes ou cenoura dentro dele. Os animais do pasto vão até o cocho comer sozinhos e **entram no modo de procriação automaticamente**, multiplicando seu rebanho e gerando filhotes de forma passiva enquanto você constrói sua base!
65. **`justenoughbreeding-fabric-1.20.1-3.1.0.jar` (Just Enough Breeding - Enciclopédia de Cruzamento):**  
    *Integração de reprodução com o JEI.* Nunca mais abra o navegador para pesquisar "o que tatu come?", "qual flor reproduz abelha?" ou "quanto tempo demora para a vaca procriar de novo?". Basta apertar `R` ou consultar a aba do animal no JEI para ver a dieta exata de procriação, tempo de gestação e itens dropados.

---

## ☀️ 4. SHADERPACK COMPLEMENTARY REIMAGINED & MOTOR GRÁFICO

O shaderpack pré-instalado e ativado por padrão na sua instância é o **`ComplementaryReimagined_r5.9.3.zip`**:

* **Estética:** Preserva a alma cúbica do Minecraft (sem parecer um mod fotorrealista artificial que quebra a estética do jogo), mas adiciona:
  * Iluminação volumétrica com raios solares dinâmicos atravessando copas de árvores e janelas.
  * Água com transparência natural, ondas sutis e refração de luz.
  * Sombras suaves projetadas de acordo com a posição do sol e da lua.
  * Céu com nuvens volumétricas e estrelas detalhadas.
  * Suporte nativo à iluminação de tochas nas cavernas através do `LambDynamicLights`.
* **Desempenho:** Na sua **NVIDIA GeForce RTX 5060**, os shaders rodam a mais de **150-240 FPS** em resolução nativa com frametime perfeitamente estável.

---

## 🚀 5. PASSO A PASSO: COMO INICIAR E JOGAR HOJE

1. **Abra o Prism Launcher:**
   * Pelo atalho de aplicativos do Hyprland (Rofi/Wofi: pressione `SUPER + SPACE` e busque por `Prism Launcher`), ou digite no terminal:
     ```bash
     prismlauncher
     ```
2. **Configure seu Perfil de Jogador (1º acesso):**
   * No canto superior direito, clique em **Contas $\rightarrow$ Gerenciar Contas $\rightarrow$ Adicionar Offline**.
   * Digite o seu nome / nickname desejado.
3. **Inicie o Jogo:**
   * Dê dois cliques na instância **Mapa Eterno (Fabric 1.20.1)**.
   * O jogo carregará todos os 40 mods e os shaders automaticamente.
4. **Crie seu Mundo:**
   * Vá em **Um Jogador $\rightarrow$ Criar Novo Mundo**.
   * Escolha o modo Sobrevivência e bom jogo!

---

## 🔄 6. MANUTENÇÃO, BACKUP & REPRODUTIBILIDADE NO DOTFILES

Se você formatar a máquina ou clonar seus dotfiles em outro computador, você não precisa configurar nada manualmente:

* **Script Mestre:** Executando `~/dotfiles/scripts/setup-minecraft.sh`, o script:
  1. Instala o Prism Launcher via Pacman.
  2. Cria a instância `Mapa_Eterno_1.20.1` com o loader Fabric 1.20.1.
  3. Aloca automaticamente 8 GB de RAM com os argumentos de Garbage Collector de baixa latência (`G1GC`).
  4. Baixa e verifica a integridade de todos os 40 mods via API do Modrinth.
  5. Baixa e ativa o shader Complementary Reimagined no Iris.

Tudo está 100% versionado no repositório `~/dotfiles` sob o controle do Git.
