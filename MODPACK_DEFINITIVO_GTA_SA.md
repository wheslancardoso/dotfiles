# 🎮 Catálogo Supremo de Mods MixMods para GTA San Andreas (2026)
*Gerado automaticamente pelo `mixmods-scraper.py` em 19/10/2026 10:37.*
*Total de mods indexados no banco local:* `270`

---
## 📑 Sumário de Estrutura do Modpack
1. [Fundação e Carregadores (Loaders)](#1-fundação-e-carregadores-loaders)
2. [Matador de Atritos: 43 Mecânicas Irritantes do GTA SA Resolvidas](#2-matador-de-atritos-43-mecânicas-irritantes-do-gta-sa-resolvidas)
3. [Guia Cirúrgico: 100% do Jogo, Coletáveis no Radar & Ouro em Todas as Escolas](#3-guia-cirúrgico-100-do-jogo-coletáveis-no-radar--ouro-em-todas-as-escolas)
4. [Gráficos de Última Geração (Pacote Otimizado para RTX / 4K)](#4-gráficos-de-última-geração-pacote-otimizado-para-rtx--4k)
5. [Física Realista, Ragdoll & Animações de Nova Geração](#5-física-realista-ragdoll--animações-de-nova-geração)
6. [Gunplay AAA & Ammu-Nation de Próxima Geração (Nível GTA V / Superior)](#6-gunplay-aaa--ammu-nation-de-próxima-geração-nível-gta-v--superior)
7. [Lojas de Roupas, Barbearias Modernas & Customização Tática de Armas](#7-lojas-de-roupas-barbearias-modernas--customização-tática-de-armas)
8. [A Trindade Final: Tradução PT-BR Sem Censura, Rádios Restauradas, 1ª Pessoa & Casas Abertas](#8-a-trindade-final-tradução-pt-br-sem-censura-rádios-restauradas-1ª-pessoa--casas-abertas)
9. [Overhaul das Missões & Campanha: Story Mode v2.0 & Lógica da História](#9-overhaul-das-missões--campanha-story-mode-v20--lógica-da-história)
10. [Vida Urbana Viva, Trânsito Inteligente & Qualidade de Vida (QoL)](#10-vida-urbana-viva-trânsito-inteligente--qualidade-de-vida-qol)
11. [Overhaul de Sub-Missões (R3): Emergência, Vigilante, Táxi & Recompensas de Elite](#11-overhaul-de-sub-missões-r3-emergência-vigilante-táxi--recompensas-de-elite)
12. [A Fronteira Viva: Transformando o GTA San Andreas no Nível RDR2 (Wilderness, Fauna & Imersão Orgânica)](#12-a-fronteira-viva-transformando-o-gta-san-andreas-no-nível-rdr2-wilderness-fauna--imersão-orgânica)
13. [Todos os Mods Indexados (Catálogo Geral do Scraper)](#13-todos-os-mods-indexados-catálogo-geral-do-scraper)

---

## 1. Fundação e Carregadores (Loaders)
*Instalados na pasta raiz do GTA San Andreas (v1.0 US).*

* **Silent's ASI Loader (`vorbisFile.dll`):** Permite injeção de bibliotecas dinâmicas `.asi`.
* **ModLoader v0.3.8+ (`modloader/` + `modloader.asi`):** Injeta arquivos sem corromper `gta3.img`.
* **CLEO 4 + CLEO+ (`cleo/` + `cleo.asi` + `cleo_plus.asi`):** Suporte moderno a opcodes de scripts criados por Junior_Djjr.
* **Open Limit Adjuster (OLA):** Remove travas da engine (limites de colisão, modelos, IDs).
* **Proper Streaming (Lançado em 10/2026):** Quebra o teto de 32 bits de RAM com o *Texture Bridge*, eliminando mapa sumindo ou piscando com texturas em alta resolução.
* **[MoonLoader v0.26+](https://www.mixmods.com.br/2020/10/moonloader/) + [ModLoader Support for MoonLoader](https://www.mixmods.com.br/2020/10/modloader-support-for-moonloader-mods-lua-no-modloader/):** Carregador moderno de scripts em Lua que roda isolado dentro do ModLoader sem poluir a pasta raiz do jogo.

---

## 2. Matador de Atritos: 43 Mecânicas Irritantes do GTA SA Resolvidas
*Como resolver cada frustração clássica de gameplay usando o MixSets e mods dedicados.*  
*(Um perfil pronto e customizado foi gerado e salvo em [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini) com desfoque de movimento, calor e atritos 100% desativados).*

| # | Atrito / Irritação Original do Jogo | Solução Técnica Definitiva | Mod / Configuração Responsável |
| :--- | :--- | :--- | :--- |
| **01** | **Carro capotado pega fogo em 3 segundos** e explode com o CJ dentro. | Desativa o fogo automático quando o veículo está de cabeça para baixo. | **MixSets.ini** -> `NoCarFlipFire = 1` |
| **02** | **Câmera do veículo girando sozinha** (auto-center forçado ao mexer o mouse ao dirigir). | Libera a câmera 360° no mouse sem reset forçado para a frente. | **MixSets.ini** -> `NoMouseCentering = 1` |
| **03** | **Perder todas as armas ao morrer ou ser preso** (Wasted / Busted). | Mantém todo o arsenal do CJ após sair do hospital ou da delegacia. | **MixSets.ini** -> `KeepWeaponsAfterWasted = 1` e `KeepWeaponsAfterBusted = 1` |
| **04** | **Correr travado em interiores** (CJ só anda a passo de tartaruga em casas, lojas e cassinos). | Habilita o sprint / corrida máxima dentro de qualquer interior. | **MixSets.ini** -> `SprintInInteriors = 1` |
| **05** | **Ataques de Gangue no meio de viagens** (perder território em LS quando estiver em SF ou Las Venturas). | Bloqueia alertas e ataques aleatórios enquanto estiver fora ou focado em missões. | **MixSets.ini** -> `NoGangAttacks = 1` |
| **06** | **Sem GPS no minimapa** (apenas um quadrado cinza estático no radar sem caminho no asfalto). | Traça rota dinâmica em tempo real no asfalto e no minimapa (estilo GTA IV/V). | [GPS Redux v1.5](https://www.mixmods.com.br/2022/10/sa-gps-redux/) |
| **07** | **Mira estática e dura** (CJ vira estátua ao mirar com rifles; sem strafe ou movimentação). | Mira moderna no ombro (Over-The-Shoulder), movimentação livre e câmera fluida. | [Advanced Aiming Mod v1.4](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/) |
| **08** | **Drive-By com cadência lenta artificial** e mira travada em 90° em Q e E (pesadelo nas perseguições do Freddy/OG Loc e Jizzy B). | Libera mira 360° no mouse disparando com a cadência REAL da arma, dano total baseado na Weapon Skill e suporte a fuzis/granadas. | [Manual Driveby Remake (Fixed)](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/) |
| **09** | **Troca de armas lenta** (ter que ficar rolando a scroll wheel passando por 10 armas). | Roda de armas moderna com slow motion tático estilo GTA V / RDR2. | [GTA V HUD / Weapon Wheel](https://www.mixmods.com.br/2022/03/atualizados-anderius-manual-driveby-v-hud-mesh-smoothed/) |
| **10** | **Perda constante de músculos e fome excessiva** (ter que parar missões para ir à lanchonete). | Congela a degradação passiva forçada de atributos físicos do CJ. | **MixSets.ini** -> `NoMuscleDecay = 1` e `NoFatDecay = 1` |
| **11** | **Intros e vídeos longos na inicialização** que não podem ser pulados rapidamente. | Inicialização relâmpago direta para o menu principal. | **MixSets.ini** -> `FastLoading = 1` ou *Improved Fastloader* |
| **12** | **Física e natação quebradas em monitores de 60Hz/144Hz** (CJ nada devagar, carros aceleram errado). | Ajusta todos os laços de física e timers para taxas altas de quadros. | [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **13** | **Salvar o jogo apenas em safehouses** (ter que cruzar o estado para registrar o progresso). | Quick Save a qualquer momento pressionando F4 fora de missões. | [Save Anywhere Mod](https://www.mixmods.com.br/) / Script CLEO |
| **14** | **Tráfego homicida** (NPCs batendo de propósito na traseira e mudando de faixa de forma caótica). | IA de trânsito realista com distância segura, frenagem lógica e sem manobras suicidas. | [Real Traffic Fix](https://www.mixmods.com.br/2023/02/atualizados-radar-map-by-wd-d159-gps-redux-rvp/) |
| **15** | **Suporte horrível a controles modernos** (falta de vibração, botões trocados, mira descalibrada). | Suporte completo a gamepads de Xbox e PS4/PS5 com XInput nativo e ícones na tela. | [GInput](https://www.mixmods.com.br/) |
| **16** | **Minigame do Lowrider & Dança na Praia impossíveis no PC** (setas fora do ritmo e comandos travados no Numpad). | Sincroniza o timing musical com taxas altas de quadros e libera o uso de WASD ou Setas sem depender de teclado numérico. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **17** | **Missão de Roubo da Van do Ryder (*Home Invasion*)** com medidor de barulho hipersensível ao andar agachado. | Normaliza o raio acústico de passos e acelera a movimentação ao carregar as caixas de munição. | **MixSets.ini** + *Stealth Fix* |
| **18** | **Motos ejetando o CJ em colisões leves** e virando de forma rígida sem inclinação natural. | Adiciona inclinação dinâmica do corpo nas curvas (*Bike Lean*) e amortecimento progressivo nas duas rodas. | [VehFuncs v2.5.5](https://www.mixmods.com.br/2025/12/sa-vehfuncs/) + **MixSets** |
| **19** | **GPS traçando rotas apenas para pontos manuais** (sem caminho para as missões da campanha). | O GPS traça linha dinâmica em tempo real para os objetivos de qualquer missão ativa da história. | [GPS Redux v1.5](https://www.mixmods.com.br/2022/10/sa-gps-redux/) |
| **20** | **Extintor de incêndio ineficaz** (spray com colisão quebrada, chamas que não apagam na missão da Denise e carros em chamas). | Corrige o cone de alcance da espuma, apaga o fogo na hora e permite usar o extintor para salvar carros em chamas antes de explodirem. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Extintor Apaga Fogo do Carro](https://www.mixmods.com.br/2016/03/extintor-apaga-fogo-do-carro.html) |
| **21** | **Missão de Paramédico / Ambulância arruinada por NPCs suicidas** (pacientes que se jogam embaixo do pneu em Montgomery/Angel Pine). | Pacientes desviam do veículo em vez de correrem na frente das rodas, entram instantaneamente na ambulância e ambulância não tomba nem explode. | *Ped Evade Car Fix* + **MixSets.ini** (`NoCarFlipFire = 1`) |
| **22** | **Tap-Tap na moto para ir mais rápido** (ter que ficar martelando a seta para cima para o CJ inclinar o corpo). | O CJ inclina o corpo aerodinamicamente de forma automática ao atingir velocidade máxima apenas segurando W, sem destruir teclas. | *Auto Lean Forward* / **MixSets.ini** |
| **23** | **Carros desaparecendo sozinhos (*Despawn*)** na porta de lojas ao entrar no provador ou virar as costas. | O último veículo utilizado pelo jogador tem prioridade máxima de memória e NUNCA sofre despawn fora da tela. | *Never Despawn* / *Lock And Park* |
| **24** | **Aviões caindo do céu do nada na sua cabeça** (aviões de ambiente colidindo com prédios e explodindo o CJ). | Corrige a altitude das rotas aéreas dos aviões de ambiente em San Andreas, impedindo quedas acidentais sobre o jogador. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + **MixSets** |
| **25** | **Limite mentiroso das garagens** (garagem vazia dizendo que está cheia ao tentar guardar mais de 4 veículos). | Remove a trava arbitrária da Rockstar, permitindo armazenar até 8 veículos por garagem sem sumir com nenhum. | *Garage eXtender* / [Open Limit Adjuster] |
| **26** | **Pedestres ladrões roubando seu carro raro estacionado** (CJ desce do Turismo e um NPC entra e foge). | Tranca automaticamente as portas do veículo e aciona alarme sonoro ao descer, impedindo qualquer pedestre de abrir. | *Auto Car Lock* / *Lock And Park* |
| **27** | **O pesadelo da missão *Stowaway*** (subir de moto na rampa do avião enquanto barris caem). | Normaliza a taxa de aceleração da moto e do avião cargueiro, permitindo alcançar a rampa com facilidade em 60 FPS. | [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **28** | **Carro recém-tunado batido na saída da oficina** (NPCs spawnando e colidindo na porta da Wheel Arch Angels). | Cria um raio de colisão limpo e seguro na saída das oficinas de modificação para manobrar sem toques. | *Safe Tuning Exit* + [Real Traffic Fix](https://www.mixmods.com.br/) |
| **29** | **Tiros batendo em paredes invisíveis** (quinas de prédios e muretas com colisão estendida no ar e cercas de arame bloqueando balas como concreto). | Recorta as caixas de colisão de mais de 10.000 objetos milimetricamente no contorno visual e permite tiros através de grades e cercas. | [Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + *Shooting Through Fences Fix* |
| **30** | **Empilhadeira da missão do Ryder (*Robbing Uncle Sam*)** com garfo travado no Numpad e caixas escorregando e caindo ao carregar 2 ao mesmo tempo. | Remapeia a elevação do garfo para Shift/Espaço, adiciona atrito estático nas caixas para não escorregarem nas curvas e Ryder ganha IA defensiva para não morrer. | [Proper Fixes](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **31** | **Lança-mísseis lerdo e frustrante** (missão da plantação de maconha do The Truth — *Are You Going to San Fierro?* com o helicóptero da polícia) e **trava de mira lerda do caça Hydra e helicóptero Hunter**. | Reduz o lock-on do Hydra de 1000ms para 150ms no MixSets, mísseis ganham física supersônica e curva de perseguição realista contra aeronaves, e mira livre em 3ª pessoa para armas pesadas sem câmera travada. | [SA] Missile by Ryosuke839 + **MixSets.ini** (`HydraLockDelay = 150`, `HydraRocketDelay = 150`, `NoHydraSpeedLimit = 1`) + *Third Person Aiming for Heavy Weapons* |
| **32** | **Alcance ridículo da Sniper Rifle** (pedestres e veículos somem na mira telescópica a ~100 metros e balas não causam dano à longa distância). | Aumenta o raio de renderização de alvos e o alcance balístico do projétil na mira da Sniper em até 10x, permitindo tiros de precisão de topos de arranha-céus e montanhas. | [Sniper Distance Fix](https://www.mixmods.com.br/2018/09/sniper-distance-fix-aumentar-alcance-da-sniper/) |
| **33** | **Alvos de sub-missões gerados no fim do mundo** (pacientes da ambulância e bandidos do vigilante spawnando a quilômetros de distância no nível 11/12 fazendo o tempo expirar). | Restringe o raio de spawn dos alvos para até 600m do veículo, salva checkpoints por nível para não recomeçar do 1 se falhar, e escala pagamentos para fortunas reais ($50k+ e renda passiva). | *Local Sub-Missions Spawns* + *Sub-Missions Checkpoints* + [Vigilante Special](https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/) |
| **34** | **Correr travado como uma tartaruga com armas longas** (fuzis M4, AK-47, escopetas e sniper forçando o CJ a andar devagar) e **cair da moto por raspar no meio-fio a 10 km/h**. | Permite sprintar e correr no máximo segurando rifles e armas de duas mãos, e ajusta a tolerância de queda de motos apenas para choques frontais violentos. | [Sprinting With Two Handed Weapons](https://www.mixmods.com.br/2018/10/correr-com-armas-pesadas-correr-com-rifle/) + *Bike Fall Physics Fix* + **MixSets** |
| **35** | **Interior e florestas sem nenhuma vida selvagem** (deserto biológico no Mount Chiliad e Flint County cortado pela Rockstar em 2004) e **armas invisíveis no bolso do CJ**. | Povoa florestas e desertos com animais nativos, caça e cães com IA própria, e torna armas do inventário visíveis em coldres e bandoleiras nas costas. | [Myths Maker – Animals Pack](https://www.mixmods.com.br/2022/10/myths-maker-animals-pack-mod-de-animais/) + [Weapons OutFit](https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/) |
| **36** | **Veículos com rodas quadradas/octogonais, interiores borrados e câmera interna dura** (painéis sem instrumentos ativos e rodas poligonais de 2004). | Remasteriza todos os carros originais com alta contagem poligonal, adiciona interiores com texturas PBR, rodas perfeitamente redondas, painéis com velocímetros/RPM funcionais e câmera de cockpit estilo Forza. | [Revamped Vehicles Project](https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/) + [Proper Vehicles Retex](https://www.mixmods.com.br/2022/02/sa-sade-proper-vehicles-retex/) + [Round Tuning Wheels CE](https://www.mixmods.com.br/2022/01/sa-round-tuning-wheels-ce-rodas-mais-redondas/) |
| **37** | **Chuva arcaica de "linhas de giz" brancas piscando que cegam a visão** (para-brisas secos, tempestades sem raios reais e pedestres tomando chuva sem reação). | Substitui a tempestade por chuva translúcida com gotas no para-brisa limpas pelos limpadores, raios dinâmicos com delay sônico de trovão, asfalto com poças refletivas PBR e pedestres com guarda-chuva. | [Proper Shaders](https://www.mixmods.com.br/2026/10/sa-proper-shaders/) + [Thunder Mod](https://www.mixmods.com.br/2022/07/thunder-mod-cleo/) + [Rain Drops on Screen](https://www.mixmods.com.br/2017/07/rain-drops-on-screen-pingos-de-chuva-na-tela/) + [Hard Rain Remake](https://www.mixmods.com.br/2019/07/hard-rain-remake-pedestres-com-guarda-chuva/) |
| **38** | **Cidades escuras como breu à noite, prédios com janelas apagadas e postes sem projeção real de luz** (visão noturna cortada a 50m por névoa cinza e ruas sem vida após o pôr do sol). | Renderiza coronas de luzes LOD até o horizonte, acende janelas aleatórias em alta definição com profundidade interna nos arranha-céus, refaz o prelight de solo em degradê suave nos postes e adiciona insetos voando nas lâmpadas. | [Project2DFX v4.4](https://www.mixmods.com.br/2020/02/sa-project2dfx/) + [Improved Night Windows](https://www.mixmods.com.br/2022/09/sa-improved-night-windows-by-hysen-mais-janelas-noturnas/) + [Project Immerse-Yourself](https://www.mixmods.com.br/2022/01/project-immerse-yourself-prelight-melhorado/) + [Missing Lampposts Fix](https://www.mixmods.com.br/2022/04/missing-lampposts-fix-more-light-posts/) + [Proper Shaders](https://www.mixmods.com.br/2026/10/sa-proper-shaders/) |
| **39** | **Ter que espremer e martelar teclas na academia (*Button Mashing*)** (ficar apertando Espaço e Shift freneticamente no supino, esteira e bicicleta, além do limite diário de treino e degradação passiva de massa muscular). | Converte o minigame em "segurar a tecla" (*Hold Key to Workout*), remove o limite diário de treino permitindo evoluir sem interrupções e congela a perda passiva de músculos permanentemente. | *Hold Key Gym Minigame* + *No Gym Daily Limit* + **MixSets.ini** (`NoMuscleDecay = 1`, `NoFatDecay = 1`) ou *Cheat Menu Stats Editor* |
| **40** | **Polícia onisciente/telepática e cega para outras gangues** (atirar no deserto vazio dá estrela sem testemunhas enquanto Ballas atiram na viatura impunes) e **paramédicos/bombeiros que não salvam ninguém**. | A polícia só é acionada se testemunhas ligarem no 911 ou verem o crime, policiais enquadram e atiram em gangues rivais armadas, médicos reanimam pedestres caídos com desfibrilador e bombeiros apagam fogo em veículos. | [Sensible Police & Crime Report Mod] + [Paramedics Revive Peds] + [Firefighters Extinguish Cars] + [More Locked Cars] + [Alarm Touching Cars] + **MixSets.ini** (`CopsShootGangs = 1`) |
| **41** | **Carros com física de "banheira sobre sabão"** (carroceria rolando excessivamente nas curvas feito barco, direção instável e falta de ângulo de contra-esterço para drift). | Calibra o centro de gravidade e rigidez da suspensão de todas as categorias automotivas, aumenta o ângulo de esterço para 55° e adiciona modo de drift em tempo real com contador de pontos e fumaça volumétrica. | *Proper & Realistic Handling Pack* + *Toggle Drift Mod* + **MixSets.ini** (`BrakePower = 1.25`, `CarsSteeringAngleHighSpeed = 0.6`) |
| **42** | **Telas pretas de loading a cada porta, menus demorados, limite de 3 aliados em vans e roubo de casas restrito à Boxville**. | Auto-carrega o save direto na rua em <2s sem menus, elimina fade preto em interiores, libera 7 aliados armados em vans/caçambas, permite roubar casas com qualquer veículo e adiciona arsenal no porta-malas. | [SaveLoader v2.7](https://www.mixmods.com.br/2020/01/iii-vc-sa-saveloader-v2-7-fast-loader-carregamento-rapido/) + [Gang Rider v2](https://www.mixmods.com.br/2020/08/gang-rider-v2-carregar-mais-gangue/) + [Burglary With Any Car v2.0](https://www.mixmods.com.br/2022/01/sa-sade-burglary-with-any-car-roubar-casa-com-qualquer-carro/) + [Trunk Store Weapons](https://www.mixmods.com.br/2021/04/trunk-store-weapons-guardar-armas-no-porta-malas/) |
| **43** | **Armas substituindo e apagando umas às outras no mesmo slot** (comprar ou coletar uma AK-47 destrói a M4 e toda a munição dela; pegar uma 9mm apaga a Desert Eagle). | Permite carregar simultaneamente todas as armas de cada categoria (AK-47 + M4, Desert Eagle + 9mm Silenciada + 9mm, todas as escopetas e submetralhadoras) alternando entre elas na Roda de Armas ou nas teclas numéricas sem perder nenhuma. | [[III/VC/SA] AllWeapon](https://www.mixmods.com.br/2021/06/iii-vc-sa-allweapon-ter-todas-as-armas/) + [Weapon Inventory](https://www.mixmods.com.br/2015/04/weapon-inventory-inventario-de-armas.html) + **MixSets.ini** (`NoWeaponDropOnPickup = 1`) |
| **44** | **Milhares de bugs no mapa original** (árvores e postes flutuando no ar, buracos no chão onde o CJ cai no limbo, paredes invisíveis que param carros, montanhas distantes "carecas" sem árvores, ruas quadradas sem meio-fio 3D e 60+ prédios trancados). | Corrige mais de **15.000 bugs de mapa da Rockstar**, adiciona malhas 3D com meio-fio chanfrado nas ruas, renderiza florestas até o horizonte, ativa fumaça nas fábricas e destrava mais de 60 interiores ocultos povoados no mapa aberto. | [[SA] Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + [[SA/Mobile] SA:DE Roads For SA Classic](https://www.mixmods.com.br/2022/08/sade-roads-for-sa-classic-hd/) + [LOD Vegetation v1.2](https://www.mixmods.com.br/2021/12/lod-vegetation-distant-trees/) + [Enterable Hidden Interiors (EHI)](https://www.mixmods.com.br/2021/01/enterable-hidden-interiors-entrar-em-interiores-escondidos/) |

---

## 3. Guia Cirúrgico: 100% do Jogo, Coletáveis no Radar & Ouro em Todas as Escolas

### A. Coletáveis com Ponto Exato no Radar & Mapa
* **[Collectibles on Radar v1.1](https://www.mixmods.com.br/2022/03/collectibles-on-radar-mostrar-coletaveis-no-mapa/):**
  * **O que faz:** Pluga diretamente no radar e no mapa grande do menu de pausa a localização exata de cada um dos **250 coletáveis** do jogo:
    - 🏷️ **100 Pichações (Tags)** em Los Santos
    - 📸 **50 Fotografias (Snapshots)** em San Fierro
    - 🧲 **50 Ferraduras (Horseshoes)** em Las Venturas
    - 🦪 **50 Ostras (Oysters)** submersas por todo o estado
  * **Comportamento Dinâmico:** O marcador do coletável **some do radar no exato instante em que você o coleta ou fotografa**.
  * **Configuração (`CollectiblesOnRadar.ini`):** Permite configurar tecla de atalho para ocultar/mostrar marcadores, trocar as cores dos ícones e até mostrar armas e coletes espalhados pelo mapa.

---

### B. Ouro em Todas as Escolas (Carro, Moto, Barco e Avião)
Tirar medalha de ouro em todas as escolas é obrigatório para destravar veículos especiais (*Super GT, Bullet, Hotknife, Freeway, FCR-900, Jetmax, Marquês, Hunter*) e pontuar rumo aos 100%.

1. **Correção de Física Obrigatória: [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/)**
   * *A Causa-Raiz da Dor:* No PC, rodar a 60 FPS ou mais **quebra a física da autoescola** (a taxa de giro no teste dos 360°, o tempo de cronômetro e a frenagem aceleram desproporcionalmente, tornando o ouro quase impossível no teste *City Slicking*).
   * O *Framerate Vigilante* normaliza a física de testes e timers independentemente do seu monitor.
2. **Garantia de Ouro Via Trainer Oficial: [Cheat Menu by Grinch_ v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/)**
   * Interface gráfica moderna (ImGui).
   * Na aba **Missions / Stats**:
     - Permite definir as medalhas das 4 Escolas (*Driving, Flying, Boat, Bike*) diretamente para **Gold** com 1 clique.
     - Permite maximizar as habilidades de pilotagem (*Driving Skill*, *Flying Skill*) para 100% imediatamente.
     - **Não corrompe nem invalida o savegame**.

---

### C. Rastreador e Diagnóstico Forense de 100%
* **[Save Tools – Save Game Helper & Checklist](https://www.mixmods.com.br/wp-content/uploads/):**
  * Analisa o arquivo de save (`GTASAsf1.b`) e exibe exatamente o checklist do que falta para atingir 100%:
    - Missões de veículos restantes (Vigilante nível 12, Paramédico nível 12, Bombeiro nível 12, Taxista 50 corridas, Cafetão nível 10).
    - Desafios de Courier (Roboi's Food Mart, Hippy Shopper, Burger Shot).
    - Corridas de rua e desafios de estádio (8-Track, Bloodring, Dirt Track, Kickstart).
    - Listas de exportação do porto de Easter Basin.
    - Pulos únicos (*Unique Stunt Jumps*) pendentes.
* **[Achievements and Trophies System v2](https://www.mixmods.com.br/):**
  * Adiciona conquistas em tela estilo PlayStation/Steam notificando o cumprimento de cada etapa rumo aos 100%.

---

---

## 4. Gráficos de Última Geração (Pacote Otimizado para RTX / 4K)
*Arquitetado para rodar a 60 FPS cravados sem engasgos ou crashes de memória.*

* **[RoSA Project Evolved (v1.5 - 2026)](https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/):** Remasterização completa de todas as texturas do estado de San Andreas em Ultra HD (4K/2K) com fidelidade artística original.
* **[Proper Shaders (10/2026)](https://www.mixmods.com.br/2026/10/sa-proper-shaders/):** Pipeline gráfico PBR moderno que substitui ENB arcaicas:
  - *Normal Maps* reais (tijolos, asfalto e pedras com relevo 3D).
  - *Roughness* e *Metallicness* em veículos e armas.
  - Suporte ao motor de nuvens dinâmicas volumétricas *CloudWorks*.
* **[SkyGfx v4.2b + Extended](https://www.mixmods.com.br/2024/03/sa-skygfx/):** Restaura os reflexos cromados em tempo real na lataria dos veículos (*Neo Car Reflections*) e a paleta de cores atmosférica de PS2.
* **[Project2DFX v4.4](https://www.mixmods.com.br/):** Distância de visão infinita e iluminação noturna volumétrica (*LOD lights*) por todo o horizonte de San Andreas.
* **[Behind Space of Realities (BSOR) / Insanity Vegetation]:** Árvores, palmeiras e grama densa em modelos 3D volumétricos completos.
* **[FxsFuncs v1.2 (2025/2026)](https://www.mixmods.com.br/2025/06/fxsfuncs/):** Efeitos de partículas em HD (fumaça volumétrica, chamas, explosões e faíscas dinâmicas).
* **[Sistema de Tempestades & Chuva Hiper-Realista]:**
  - **[Proper Rain & PBR Wet Road Reflections (Proper Shaders + FxsFuncs)]:**
    - Substitui as linhas cinzas arcaicas da tempestade original por chuva com refração ótica de luz, sem cegar a visão do jogador.
    - O asfalto e calçadas ganham poças d'água dinâmicas com mapa de relevo que refletem faróis de carros, postes e letreiros de néon em tempo real (*Screen-Space Reflections*).
    - Pneus de veículos levantam spray e névoa d'água volumétrica (*water mist*) ao acelerar sobre pistas molhadas.
  - **[Rain Drops on Screen & Windshield (Pingos na Tela e Para-brisa)](https://www.mixmods.com.br/2017/07/rain-drops-on-screen-pingos-de-chuva-na-tela/):**
    - Gotas d'água atingem dinamicamente a tela e o para-brisa dos carros em tempo real, escorrendo com o vento da velocidade.
    - Os limpadores de para-brisa do **VehFuncs** varrem as gotas fisicamente ao passarem pelo vidro.
  - **[Thunder Mod (Raios Volumétricos & Trovões com Atraso Sônico)](https://www.mixmods.com.br/2022/07/thunder-mod-cleo/):**
    - O céu se ilumina com raios volumétricos bifurcados cortando as nuvens, seguidos por estrondos de trovão com delay sônico realista (a luz do raio chega antes do som, de acordo com a distância).
    - Trovões próximos geram um leve tremor de câmera e estrondo de sub-graves no áudio 3D do **Soundize**.
  - **[Hard Rain Remake (Reação Social e Guarda-Chuvas)](https://www.mixmods.com.br/2019/07/hard-rain-remake-pedestres-com-guarda-chuva/):**
    - Pedestres sacam guarda-chuvas coloridos automaticamente e correm procurando abrigo sob marquises e pontos de ônibus.
    - Motoristas acionam faróis baixos e os limpadores de para-brisa dos veículos começam a funcionar na hora.
* **[Iluminação Noturna de Próxima Geração (Padrão GTA V / Superior: Prédios, Casas e Postes)]:**
  - **[SA] Project2DFX v4.4 (LOD Lights & Horizonte sem Fim)](https://www.mixmods.com.br/2020/02/sa-project2dfx/):**
    - Renderiza coronas de luzes de postes, semáforos, antenas e edifícios até o limite do mapa de San Andreas sem neblina de corte.
    - Do topo do Mount Chiliad ou de um avião à noite, as metrópoles de Los Santos, San Fierro e Las Venturas brilham como um mar infinito de luzes pulsantes, idêntico à vista panorâmica de Los Santos no GTA V.
  - **[SA] Improved Night Windows by Hysen (Janelas Vivas & Interiores de Arranha-Céus)](https://www.mixmods.com.br/2022/09/sa-improved-night-windows-by-hysen-mais-janelas-noturnas/):**
    - Elimina os monólitos pretos e apagados de 2004. Acende janelas aleatórias em alta definição com interiores visíveis de escritórios e apartamentos, dando vida arquitetônica noturna a todos os edifícios e casas.
  - **[SA] Proper Night Windows & Project Lumos (Proper Fixes Pack)](https://www.mixmods.com.br/2022/11/sa-project-lumos/):**
    - Adiciona iluminação noturna 2DFX detalhada em marcos urbanos esquecidos pela Rockstar: a pirâmide de Las Venturas acesa, outdoors publicitários iluminados por refletores de topo, igrejas históricas com vitrais brilhando e torres de transmissão com luzes de balizamento aéreo.
  - **[Project Immerse-Yourself v0.3 & Pre-lighting Fixes Pack (Prelight de Solo & Fachadas)](https://www.mixmods.com.br/2022/01/project-immerse-yourself-prelight-melhorado/):**
    - Reconstrói a iluminação de vértices pré-computada (pre-lighting) do mapa: a luz das lâmpadas dos postes agora banha o asfalto, calçadas e muros com cones e gradientes quentes e suaves de cor âmbar, acabando com a sensação de escuridão plástica e plana.
  - **[SA] Missing Lampposts Fix (Rede de Postes de Luz Completa)](https://www.mixmods.com.br/2022/04/missing-lampposts-fix-more-light-posts/):**
    - Adiciona postes de iluminação pública em rodovias interestaduais, avenidas expressas e ruelas que a Rockstar deixou na escuridão total em 2004.
  - **[SA/SA:DE/Mobile] Insects Mod v1.1 (Moscas e Mariposas nas Lâmpadas dos Postes)](https://www.mixmods.com.br/2022/08/insects-mod/):**
    - Adiciona enxames sutis de insetos noturnos voando ao redor das cúpulas de luz dos postes de iluminação pública, recriando o detalhe biológico e imersivo presente no GTA V e RDR2.
  - **Faróis Volumétricos e Sombras em Tempo Real (Proper Shaders + VehFuncs):**
    - Os faróis dos veículos e lâmpadas dos postes projetam cones volumétricos nítidos que geram sombras dinâmicas de pedestres e carros no chão, integrando-se aos reflexos no asfalto molhado.
* **[Sombras Suaves em Tempo Real (Soft Shadows & Ambient Occlusion)]:**
  - **[Shadows Settings Extender v2.1.2](https://www.mixmods.com.br/2020/03/shadows-settings-extender-v2-1-2-extensor-de-sombras/):**
    - Substitui as sombras redondas estáticas simplórias por sombras dinâmicas de alta definição em tempo real para **todos os veículos do tráfego, pedestres, postes, árvores e prédios**, projetadas pela rotação física do sol e da lua.
  - **[Dynamic Shadow Color (Sombras com Cores Atmosféricas)](https://www.mixmods.com.br/2019/04/dynamic-shadow-color-sombras-com-cor-realista/):**
    - As sombras absorvem a luz difusa da atmosfera: ganham tonalidade azulada sob o céu aberto de San Andreas e tonalidade dourada/âmbar ao entardecer, eliminando o aspecto preto plástico de 2004.
* **[Propagação de Fogo & Física Térmica (Estilo Far Cry / RDR2)]:**
  - Explosões, coquetéis molotov e lança-chamas criam focos de incêndio com física ativa que se **alastram organicamente por grama seca, cercas de madeira e arbustos**, criando barreiras de chamas dinâmicas em áreas rurais e florestais.
* **[Overhaul Forense do Mapa: +15.000 Correções, Geometria 3D & Mundo Vivo]:**
  - **[[SA] Proper Fixes v2.1.1 (06/2026 - O Maior Pack de Correções da História)](https://www.mixmods.com.br/2026/06/sa-proper-fixes/):**
    - Corrige **mais de 15.000 bugs de mapa deixados pela Rockstar** em 2004: árvores, postes e placas flutuando no ar, buracos na geometria onde o CJ cai no limbo (*Blue Hell*), colisões invisíveis que param carros e tiros do nada, texturas invertidas ou esticadas, falhas de iluminação de vértices (*prelight*) e objetos que desapareciam no LOD.
  - **[[SA/Mobile] SA:DE Roads For SA Classic (Ruas e Rodovias 3D em HD)](https://www.mixmods.com.br/2022/08/sade-roads-for-sa-classic-hd/) + [High Poly Desert](https://www.mixmods.com.br/2021/05/mesh-smoothed-pack-objetos-mais-redondos/):**
    - Substitui as ruas achatadas e quadradas de 2004 pelas malhas 3D remasterizadas com **meio-fios chanfrados, curvas suaves sem quinas poligonais**, faixas de pedestres desgastadas e colinas arredondadas no deserto de Bone County.
  - **[LOD Vegetation v1.2 (Florestas Visíveis até o Horizonte)](https://www.mixmods.com.br/2021/12/lod-vegetation-distant-trees/) + [[SA] Wind Project v1.0.2 (Vento Físico nas Árvores)](https://www.mixmods.com.br/2022/10/wind-project/):**
    - Acaba com o efeito de "montanhas carecas" à distância (onde todas as árvores sumiam após 80 metros). Mantém florestas densas renderizadas até o horizonte e faz copas de árvores, pinheiros e palmeiras balançarem fisicamente com a força do vento.
  - **[[SA] Proper HD Models (Mobiliário Urbano 3D)](https://www.mixmods.com.br/2022/10/sa-proper-hd-models/) + [Improved Lamps v0.8](https://www.mixmods.com.br/2021/09/improved-lamps-v0-8-postes-remasterizados-em-hd/) + [[SA] Missing Smokes Fix](https://www.mixmods.com.br/2022/05/missing-smokes-fix/):**
    - Remasteriza em 3D semáforos, cabines telefônicas, caixas de correio, placas de trânsito, cercas, bancas de jornal e postes de luz, além de restaurar as fumaças dinâmicas saindo das chaminés industriais de Los Santos, San Fierro e Las Venturas.
  - **[Enterable Hidden Interiors (EHI)](https://www.mixmods.com.br/2021/01/enterable-hidden-interiors-entrar-em-interiores-escondidos/) + [More Radar Icons v2.0](https://www.mixmods.com.br/2022/01/more-radar-icons/):**
    - Destrava, conecta ao mapa aberto e povoa com NPCs **mais de 60 interiores ocultos ou trancados fora de missões** (Marco's Bistro, delegacias de SF e LV, hospitais, mercados 24/7, estúdios, mansões e clubes), exibindo novos ícones dedicados no radar.
* **[Remastered GUI 4K]:** HUD, mapa, radar, miras e fontes vetorizados em alta resolução nativa.

---

## 5. Física Realista, Ragdoll & Animações de Nova Geração

### A. Física Dinâmica de Veículos & Colisões
* **[VehDeform v1.3c (Amassar Carros Dinamicamente)](https://www.mixmods.com.br/2025/06/sa-vehdeform-amassar-carros/):**
  - **O que faz:** Adiciona deformação de lataria realista nas colisões (estilo *GTA IV / Wreckfest*).
  - Em vez dos carros apenas trocarem texturas para "amassado pré-programado", a malha metálica se deforma de acordo com a velocidade, ângulo e ponto de impacto do choque.
* **[VehFuncs v2.5.5 (Física de Peças Móveis)](https://www.mixmods.com.br/2025/12/sa-vehfuncs/):**
  - Adiciona peças dinâmicas com física ativa a todos os veículos: suspensão independente que amortece e oscila de verdade em buracos, limpadores de para-brisa em dias de chuva, pedais de freio e acelerador móveis acionados pelos pés do CJ, volantes funcionais e faróis escamoteáveis (*pop-up*).
* **[Improved Surface Physics (Superfícies com Física Aprimorada)](https://www.mixmods.com.br/2021/11/improved-surface-physics-superficies-com-fisica-melhorada/):**
  - Diferencia o atrito físico e aderência dos pneus em: asfalto molhado, areia, terra fofa, cascalho e grama.
* **[Wheel Detach (Soltar e Arrancar Rodas em Colisões)](https://www.mixmods.com.br/2020/07/wheel-detach-soltar-ou-estourar-roda/):**
  - Impactos violentos em alta velocidade agora têm chance de romper eixos e arrancar rodas, obrigando o jogador a manobrar no aro metálico soltando faíscas.
* **Tolerância Realista de Queda de Moto (*Bike Fall Physics Fix*):**
  - Acaba com o CJ sendo ejetado da moto por esbarrar no meio-fio ou raspar num poste a 10 km/h; quedas só acontecem em batidas frontais violentas.

### B. Ragdoll Euphoria / Bullet Physics para Pedestres & CJ
* **[Mod Ragdoll Bullet Physics + Fix](https://www.mixmods.com.br/2021/09/mod-ragdoll-bullet-physics-fix-fisica-realista/):**
  - **O fim das mortes duras e pré-gravadas de 2004:** Injeta física esquelética ativa (*ragdoll*) usando a biblioteca *Bullet Physics* (estilo *Euphoria* do GTA IV/V).
  - Tiros de espingarda arremessam corpos para trás; tiros nas pernas fazem o inimigo mancar e tombar de joelhos.
  - Atropelamentos fazem o pedestre rolar por cima do capô e chocar-se contra o para-brisa com peso e inércia reais.
  - Corpos alvejados no alto de escadarias ou sacadas rolam naturalmente degrau por degrau pela gravidade.

### C. Animações de Nova Geração & Movimentação Fluida
* **[Animation Fix + M4k3's Car Animations](https://www.mixmods.com.br/2022/02/animation-fix-v1-5-corrigir-bugs-de-animacoes/):**
  - Corrige **mais de 70 bugs e inconsistências anatômicas**:
    - As mãos seguram o volante no ângulo correto e os pés não atravessam o assoalho do veículo.
    - O CJ vira o rosto e usa o espelho retrovisor lateral ao engatar a marcha a ré em caminhões e vans.
    - Corrige sincronização labial e expressões faciais em diálogos.
* **[Awesome IFP v3 (Movimentação Atlética e Fluida)](https://www.mixmods.com.br/2021/11/sa-sade-awesome-ifp/):**
  - Substitui o andar engessado do CJ por animações atléticas modernas: passada fluida, corrida com impulso, transição natural de peso sem cortes bruscos e esquivas suaves.
* **[Sprinting With Two Handed Weapons (Correr com Armas Longas)](https://www.mixmods.com.br/2018/10/correr-com-armas-pesadas-correr-com-rifle/):**
  - Permite correr em velocidade máxima segurando fuzis (M4, AK-47), escopetas táticas e rifles sniper, eliminando a lentidão forçada em combates abertos.
* **Entrada e Saída Tática de Veículos (*Combat Enter/Exit*):**
  - Sob tiroteio ou perseguição policial, o CJ mergulha para dentro do carro e fecha a porta com rapidez e urgência tática, em vez da animação lenta de passeio.
* **Subida Ágil de Muros (*Fluid Vaulting & Climbing*):**
  - Permite transpor muros, cercas e muretas em movimento contínuo sem travar no topo, com aterrissagem amortecida.

### D. Cockpit Nível Forza & Remasterização Completa de Veículos (Interiores, Exteriores e Rodas HD)
* **[Revamped Vehicles Project (RVP)](https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/):**
  - **O projeto definitivo de veículos do GTA SA:** Remasteriza todos os carros e motos originais do jogo mantendo a identidade visual da Rockstar dos anos 90, mas com contagem poligonal moderna (sem arestas pontudas e sem geometrias quebradas).
  - 100% adaptado para **VehFuncs** e **ImVehFt (IVF)**: luzes de ré, pisca-alerta/setas funcionais, faróis de neblina, luzes de freio em LED, limpadores de para-brisa em chuva e motor vibrando sob o capô.
* **[Proper Vehicles Retex (Interiores e Detalhes HD)](https://www.mixmods.com.br/2022/02/sa-sade-proper-vehicles-retex/):**
  - Substitui as texturas borradas de 128x128 dos veículos por texturas de alta definição:
    - **Interiores:** Bancos em couro ou tecido com costuras visíveis, painéis com botões nítidos e legíveis, saídas de ar condicionado detalhadas e volantes com acabamento realista.
    - **Exteriores:** Faróis e lanternas com lentes de vidro translúcido em vez de adesivos opacos, grades de radiador abertas e emblemas cromados em alto relevo.
* **[Round Tuning Wheels CE (Rodas e Pneus Redondos em Alta Definição)](https://www.mixmods.com.br/2022/01/sa-round-tuning-wheels-ce-rodas-mais-redondas/):**
  - Elimina para sempre as rodas octogonais/poligonais do PS2. Todas as rodas originais e de oficinas de modificação (TransFender, Wheel Arch Angels, Loco Low Co.) tornam-se perfeitamente redondas, acompanhadas de pneus com bandas de rodagem esportivas e sulcos profundos.
* **Câmera de Cockpit Inercial estilo Simulador (*Forza / Assetto Corsa Style*):**
  - Ao entrar em qualquer veículo em 1ª pessoa:
    - **Instrumentos Vivos:** Velocímetro analógico e conta-giros (RPM) têm agulhas 3D que sobem e descem em tempo real no painel de acordo com a aceleração e marcha engatada.
    - **Volante Ativo:** As mãos do CJ giram o volante suavemente até 900° nas curvas, com os pés acionando os pedais de acelerador e freio.
    - **Inércia Dinâmica:** A cabeça do piloto inclina para a frente em frenagens fortes, recua na aceleração e inclina nas curvas reagindo à força G.
* **[Car Audio Bass Resonance (Vibração e Ressonância de Graves)]:**
  - Ao sintonizar rádios de rap e hip-hop dos anos 90 (*Radio Los Santos, Playback FM*) com o som automotivo ligado, a pressão sonora dos subwoofers gera vibração física audível e visual: a tampa do porta-malas, os espelhos retrovisores e a lataria tremem levemente no ritmo das batidas graves, reproduzindo a cultura real de *Lowriders*.

### E. Handling Firme (Fim das "Banheiras") & Máquina de Drift
* **[SA] Proper & Realistic Handling Overhaul:**
  - Elimina a física de "banheira sobre sabão" do jogo original: baixa o centro de gravidade (`CentreOfMass.z`), calibra barras estabilizadoras (`SuspensionAntiRollBarMult`) e ajusta a tração (RWD/AWD/FWD) real para cada classe (Tuners/JDM, Muscle Cars, Sedans e Esportivos).
* **[SA] Toggle Drift Mod + Steering Lock 55° & Drift Counter HUD:**
  - Amplia o ângulo máximo de esterçamento das rodas dianteiras de 35° para **55°**, permitindo contra-esterço profundo em alta velocidade sem rodar.
  - Ativa modo drift sob demanda segurando `Shift` / `Espaço`, acompanhado de fumaça volumétrica densa nos pneus traseiros (**FxsFuncs**) e contador de pontuação e combos na tela (*Wall Taps*).
* **[Mesh Smoothed Pack (Objetos Mais Redondos)](https://www.mixmods.com.br/2021/05/mesh-smoothed-pack-objetos-mais-redondos/) + [[SA] Meshsmooth Pack by Hysen](https://www.mixmods.com.br/2022/07/sa-meshsmooth-pack-by-hysen/):**
  - "Despoligona" hidrantes, lixeiras, tambores, barris, postes, bicicletas ([Smooth Criminal Bicycles](https://www.mixmods.com.br/2019/06/smooth-criminal-bicycles-bicicletas-mais-arredondadas/)) e estruturas cilíndricas por todo o mapa.

---

## 6. Gunplay AAA & Ammu-Nation de Próxima Geração (Nível GTA V / Superior)
*Transforma o combate com armas de estalos plásticos dos anos 90 em um shooter tático moderno com física e áudio espacial.*

### A. A Loja Ammu-Nation Reinventada
* **[Custom Ammunation Mod v3.5](https://www.mixmods.com.br/2022/01/custom-ammunation-mod-adicionar-armas-pra-comprar/):**
  - **O que faz:** Remove as travas arcaicas do menu de compras da Ammu-Nation.
  - Permite comprar **todas as armas do jogo** diretamente no balcão (incluindo armas raras que a Rockstar bloqueou, como a *Minigun*, *Sniper Rifle Militar*, *Desert Eagle*, *Katana* e *Lança-chamas*).
  - Permite adicionar armas customizadas novas no catálogo de compra sem quebrar o arquivo de missões `main.scm`.
* **[Ammu-Nation Interior HD & Walk-In Shelves]:**
  - Substitui as prateleiras embaçadas da loja por vitrines em 3D iluminadas em alta definição, com caixas de munição realistas e pôsteres temáticos.
* **[[III/VC/SA] AllWeapon (Carregar Todas as Armas Sem Substituir)](https://www.mixmods.com.br/2021/06/iii-vc-sa-allweapon-ter-todas-as-armas/) + [Weapon Inventory](https://www.mixmods.com.br/2015/04/weapon-inventory-inventario-de-armas.html):**
  - **O fim da perda de armas do mesmo slot:** No jogo original, o array `m_aWeapons[13]` só permite 1 arma por categoria (comprar uma *M4* apaga a sua *AK-47* e toda a munição dela; pegar uma *9mm* apaga a *Desert Eagle*).
  - Com o *AllWeapon* integrado ao `NoWeaponDropOnPickup = 1` do [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini#L39), todas as armas da mesma categoria ficam salvas simultaneamente com suas respectivas munições. Você alterna entre elas dentro do próprio slot na **Roda de Armas (GTA V HUD)** ou pressionando a tecla numérica correspondente (`1`–`9`), exatamente como no *GTA V*.

---

### B. Sons de Armas e Acústica Espacial (Áudio de Estúdio)
* **[Soundize (AAA Audio System - 06/2026)](https://www.mixmods.com.br/2026/06/soundize/):**
  - O mod de áudio mais revolucionário do MixMods.
  - Implementa acústica tridimensional realista: tiros dentro de prédios e túneis geram **reverberação metálica pesada**; em campos abertos ou no deserto, os disparos ecoam no horizonte com som de trovão.
  - Sons de estalos supersônicos quando balas passam raspando pela cabeça do CJ (*Bullet Whiz*).
  - Barulho metálico nítido de cápsulas ejetadas quicando no asfalto e no chão.

---

### C. Modelos 3D de Armas em Altíssima Resolução (PBR)
* **[INSANITY Weapons Items HD](https://www.mixmods.com.br/2020/12/insanity-weapons-items-armas-hd/):**
  - Recriação completa de todas as armas do jogo com malhas poligonais detalhadas, canos estriados, empunhaduras de madeira fosca e metais cromados com suporte a *Normal Maps*.
* **[Faithful Weapons Pack 2.0](https://www.mixmods.com.br/2020/07/faithful-weapons-pack-2-0-pack-de-armas-fieis/):**
  - Alternativa ideal para quem deseja os designs 100% originais dos anos 90, mas renderizados em alta definição.

---

### D. Mecânica de Tiro & Balística Tática
* **[Advanced Aiming Mod v1.4](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/):**
  - Câmera tática no ombro (*Over-The-Shoulder*). Permite andar agachado, recuar e atirar sem travar o CJ no chão como estátua.
* **[Manual Reload Mod]:**
  - Permite recarregar a qualquer momento pressionando a tecla `R` (estilo FPS moderno), sem precisar gastar todo o pente de munição na parede para forçar a animação.
* **[Bullet Tracers & Dynamic Recoil (FxsFuncs)]:**
  - Balas deixam rastro balístico luminoso visível (*tracers*).
  - Recuo vertical real e progressivo nos disparos, exigindo controle fino de mira e disparos em rajada.

---

### E. Miras de Alta Precisão, Ícones HD & Feedback de Tiro
* **[CustomCrosshairs v2.0](https://www.mixmods.com.br/2022/04/customcrosshairs-personalizar-miras/):**
  - Elimina o círculo verde esticado e pixelizado original em telas 16:9 / 4K.
  - Permite retículos dedicados por classe de arma: ponto holográfico (*red dot*) para pistolas, retículo militar tático para fuzis M4/AK, e retículo balístico mil-dot com escala correta para snipers.
* **[Crosshairs Pack (300+ Miras & 46 Discos de Radar)](https://www.mixmods.com.br/2018/08/crosshairs-mais-de-300-miras-e-46-discos-de-radar-pack-colecao/):**
  - Coleção completa de texturas de miras customizadas em alta definição prontas para uso com o CustomCrosshairs.
* **[nadalao Weapon Icons (Ícones HD Fiéis Corrigidos)](https://www.mixmods.com.br/2022/02/icones-de-armas-fieis-desenhos-corrigidos/):**
  - Redesenha todos os ícones de armas do HUD em alta resolução, corrigindo erros anatômicos históricos da Rockstar (cano da MP5, silhueta truncada da Sniper, proporções de escopeta).
* **[Sniper Distance Fix](https://www.mixmods.com.br/2018/09/sniper-distance-fix-aumentar-alcance-da-sniper/):**
  - Remove o limite artificial de alcance da mira telescópica (~100m). O tiro e a renderização de alvos acompanham o alcance visual de centenas de metros.
* **[Hit Indicator (Damage Indicator / Hitmarker Tático)](https://www.mixmods.com.br/2016/09/iii-vc-hit-indicator-mudar-mira-ao-acertar/):**
  - Adiciona o marcador dinâmico em X na mira ao acertar disparos e indicação vermelha em tiros fatais na cabeça (*headshots*), estilo GTA V e shooters modernos.

---

## 7. Lojas de Roupas, Barbearias Modernas & Customização Tática de Armas

### A. Eliminação de Atritos nas Lojas de Roupas
* **[All Clothing Stores & Items Unlocked]:**
  - **O que faz:** Desbloqueia todas as redes de lojas (*Binco, Suburban, ProLaps, Zip, Didier Sachs*) desde a primeira missão do jogo em Los Santos.
  - Elimina a restrição de ter que viajar para Las Venturas só para comprar ternos de luxo ou esperar o final da campanha.
* **[Fast Wardrobe / Skip Fitting Room Animation]:**
  - **Adeus provador lento:** Remove a animação arrastada e repetitiva do CJ entrando e saindo da cortina do provador a cada camiseta ou tênis que você experimenta.
  - A troca de peças é **instantânea na tela**, permitindo testar dezenas de combinações em segundos com visualização fluida em tempo real.
* **[Wardrobe Anywhere (Guarda-Roupa em Qualquer Lugar)]:**
  - Permite acessar o seu guarda-roupa completo e trocar de roupas em qualquer ponto do mapa pressionando uma tecla de atalho, sem precisar viajar até uma safehouse.

---

### B. A Barbearia Reinventada: Fim do Menu Arcaico e Barba Dinâmica
* **[Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)](https://www.mixmods.com.br/2021/02/hairstyles-beards-escolher-penteado-e-barba/):**
  - **A dor original:** No GTA SA padrão, a barba e o cabelo vinham grudados na mesma opção fixa (você não conseguia usar um corte Afro ou Tranças com barba rala, pois barba só existia com cortes carecas).
  - **A solução:** Desacopla 100% o cabelo da barba. Escolha qualquer penteado da sua preferência e combine com cavanhaque, barba por fazer, bigode ou costeletas em mais de **300 combinações novas**.
* **[Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)](https://www.mixmods.com.br/2019/09/beard-grow-mod-v1-2-crescer-barba/):**
  - **Mecânica realista:** A barba do CJ cresce dinamicamente com o passar dos dias no relógio interno do jogo.
  - Começa com o rosto liso pós-barba, passa pela fase de barba rala, barba cerrada até atingir barba cheia.
  - A barbearia ganha propósito real no jogo para manter o corte aparado e desenhado.
* **[MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)](https://www.mixmods.com.br/2021/09/menuui-v1-5-menus-modernos/):**
  - Substitui a lista de texto arcaica dos anos 90 por uma interface gráfica com preview em tempo real e corte instantâneo, sem precisar esperar a animação do barbeiro passar a tesoura devagar.
* **[Proper Player Retex v3.2 & CJ Upscale HD]:**
  - Texturas de alta definição para todos os cortes de cabelo (com degradê/fade nítido e natural) e barbas com sombreamento e textura realista.

---

### C. Customização de Armas & Anexos Táticos (Attachments)
* **[Weapon Details Mod (ArtemQa146)]:**
  - Adiciona **partes móveis e mecânica funcional em 3D** para as armas:
    - O ferrolho e o cão das pistolas recuam dinamicamente a cada disparo.
    - O pente de munição é retirado fisicamente da arma durante a animação de recarga.
    - Seletores de tiro e gatilhos animados.
* **[Tactical Attachments & Silencer Toggle]:**
  - Permite equipar e desequipar **silenciadores táticos** nas armas com uma tecla rápida.
  - Adiciona suporte a modelos com **miras ópticas (Red Dot / Holográfica)** e **lanternas funcionais** para operações táticas noturnas.
* **[Custom Ammunation Mod v3.5](https://www.mixmods.com.br/2022/01/custom-ammunation-mod-adicionar-armas-pra-comprar/):**
  - Catálogo irrestrito: compre Minigun, Desert Eagle, Sniper Militar, Lança-Chamas e armas customizadas táticas diretamente no balcão.

---

### D. Dedos Separados e Articulados para CJ e Personagens
* **[Mobile/Xbox Hands (Mãos com Dedos Separados para o CJ)](https://www.mixmods.com.br/):**
  - **Adeus mãos de lego:** Substitui as famosas "luvas de boxe / blocos fechados" por mãos em alta definição com **5 dedos articulados independentes**.
  - Os dedos se curvam de forma realista ao segurar volantes, canos de fuzis, gatilhos de pistolas e na hora de desferir socos.
* **[Personagens de Cutscene & Pedestres com Dedos Separados]:**
  - Sweet, Ryder, Big Smoke, Kendl, Cesar e pedestres de toda San Andreas também recebem mãos com dedos modelados individualmente e bocas articuladas.

---

## 8. A Trindade Final: Tradução PT-BR Sem Censura, Rádios Restauradas, 1ª Pessoa & Casas Abertas

### A. Tradução PT-BR Definitiva (MixMods & MJay)
* **[Tradução Português para GTA SA (PC)](https://www.mixmods.com.br/):**
  - **O que resolve:** Substitui a tradução arcaica e truncada da GameVicio/Tribo Gamer.
  - Traduzida do zero com gírias reais da Costa Oeste dos anos 90, sem censura em palavrões e diálogos das gangues.
  - Corrige erros crassos de tradução que confundiam a história e causavam bugs em objetivos de missões.
  - Fontes em alta resolução perfeitamente alinhadas para monitores Widescreen e 4K.

---

### B. Músicas Cortadas Restauradas & Rádio em Alta Fidelidade
* **[Original Radio Extended (1000 Músicas Sem Cortes)](https://www.mixmods.com.br/2024/08/original-radio-extended/):**
  - A Rockstar removeu dezenas de músicas históricas em relançamentos por expiração de direitos autorais.
  - Este mod restaura todas as faixas lendárias de *2Pac, N.W.A, Dr. Dre, Snoop Dogg, Guns N' Roses, Rage Against the Machine e James Brown*, expandindo o acervo para **mais de 1.000 músicas** fiéis aos anos 90 com vinhetas raras de DJs e comerciais de rádio completos da época.
  - Áudio sem compressão (qualidade Master de estúdio / Lossless) em todas as estações de rádio (*Radio Los Santos, K-DST, Radio X, Bounce FM, K-Rose*).
* **[MP3 Player & Sony Headphones (Ouvir Rádio e Músicas a Pé)](https://www.mixmods.com.br/):**
  - Permite ao CJ escutar as rádios do jogo ou suas próprias faixas em fones de ouvido portáteis enquanto caminha pelas ruas, faz musculação na academia, anda de skate ou pilota bicicleta.
  - Inclui controles completos de reprodução (play/pause, shuffle, avançar faixa) e exibe o fone de ouvido 3D modelado na cabeça do CJ.

---

### C. Câmera em Primeira Pessoa Real (*GTA V First Person Style*)
* **[First Person Mod v3.0 Fixed (por BoPoH & Junior_Djjr)](https://www.mixmods.com.br/):**
  - Permite alternar instantaneamente entre terceira pessoa e primeira pessoa pelos olhos do CJ pressionando a tecla `V`.
  - Inclui visada holográfica e alinhamento de ferrolho ao mirar com fuzis e pistolas.
  - Cockpits detalhados em veículos: dirija olhando pelos retrovisores, volante e velocímetros em alta definição.

---

### D. Casas e Interiores Abertos no Mapa (*Open Houses*)
* **Ativado diretamente no [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini) (`OpenHouses = 1`):**
  - Permite entrar livremente em centenas de casas residenciais, motéis, escritórios e armazéns espalhados por Los Santos, San Fierro e Las Venturas sem precisar estar em missões de roubo noturno com o Ryder.

---

## 9. Overhaul das Missões & Campanha: Story Mode v2.0 & Lógica da História

* **[Story Mode v2.0 (Melhorias para a Storyline)](https://www.mixmods.com.br/2022/11/story-mode/):**
  - **O que faz:** Corrige dezenas de incoerências de roteiro, falhas lógicas e mortes injustas nas missões da campanha oficial:
    - **Inteligência de Aliados:** Sweet, Ryder e Big Smoke não correm suicidas para a linha de tiro em emboscadas; buscam cobertura e recuam se a vida estiver crítica.
    - **Tráfego de Pontes Realista:** As pontes bloqueadas não são mais barreiras invisíveis com o mar estático; veículos de pedestres circulam normalmente, mantendo as 4 estrelas se você tentar atravessar antes da hora.
    - **Noticiário WCTR Dinâmico:** As notícias no rádio de Los Santos atualizam de acordo com os acontecimentos reais das missões (*The Green Sabre, Yay Ka-Boom-Boom*).
* **[Emmet But Useful (Emmet Útil no Jogo Inteiro)](https://www.mixmods.com.br/2022/08/atualizados-traducao-emmet-useful-vehicle-immunities/):**
  - No jogo base, o velho Emmet só servia para ensinar a atirar em garrafas e dava uma pistola 9mm.
  - Este mod atualiza o estoque do Emmet conforme você avança na campanha: ele passa a vender armamento pesado, fuzis e coletes mais baratos que na Ammu-Nation.
* **A Solução do Trem do Big Smoke (*Wrong Side of the Tracks*):**
  - Com o [Manual Driveby Remake](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/), o próprio CJ saca a submetralhadora pelo guidão da moto e atira nos Vagos em cima do vagão, eliminando os 4 alvos em menos de 15 segundos antes mesmo do primeiro túnel.
* **Fim do Bloqueio de Pulmão na Missão do Woozie (*Amphibious Assault*):**
  - No [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/), basta ir em **Stats > Lung Capacity** e preencher 100% com 1 clique, sem precisar gastar 30 minutos mergulhando na praia de San Fierro.
* **[Things To Do In San Andreas (TTDISA) - Mais de 25 Missões Novas](https://www.mixmods.com.br/):**
  - Adiciona novos contratos de assassinato por cabines telefônicas (estilo Vice City), entregas expressas pelas rodovias, missões de caminhoneiro expandidas e encontros aleatórios de pedestres precisando de carona e resgate pelo mapa.
* **[Storyline Cutscenes 60 FPS Remastered (Cutscenes em Alta Fidelidade)]:**
  - Elimina o travamento e os engasgos das cutscenes originais limitadas a 30 FPS; todas as cinemáticas de história rodam a **60 FPS nativos**.
  - Sincroniza com as texturas HD e dedos separados do RoSA Evolved e INSANITY Weapons, eliminando discrepâncias visuais entre história e gameplay.

---

## 10. Vida Urbana Viva, Trânsito Inteligente & Qualidade de Vida (QoL)

* **[Urbanize (Ambient NPCs & World Props - 02/2026)](https://www.mixmods.com.br/2026/02/urbanize/):**
  - **O que faz:** O projeto mais ambicioso de vida urbana do MixMods. Preenche o mapa de San Andreas com **mais de 20.000 objetos de ambientação** e comportamentos dinâmicos para pedestres (animações do GTA IV e Mixamo):
    - Gangues jogam dados e conversam nas esquinas da Grove Street, Glen Park e El Corona.
    - Caçadores armados com cães exploram as florestas de Flint County (integrado com animais silvestres).
    - Policiais e paramédicos conversam e interagem em frente a delegacias e hospitais.
    - Banhistas deitados em espreguiçadeiras e quiosques com vendedores ativos no Pier de Santa Maria.
    - Filas de pessoas aguardando sessões nas portas dos cinemas de Los Santos.
* **[Real Traffic Fix v2.2.1 beta](https://www.mixmods.com.br/2022/04/real-traffic-fix/):**
  - **O que faz:** Reescreve a inteligência artificial dos motoristas do trânsito:
    - Motoristas respeitam os semáforos e freiam na luz vermelha/amarela.
    - Mantêm distância de segurança do carro da frente, impedindo colisões idiotas e engavetamentos em cadeia.
    - Desaceleram antes de fazer curvas fechadas em vez de capotar ou rodar.
    - Elimina motoristas que mudam de faixa repentinamente para colidir no carro do jogador na rodovia.
* **[Autosave Mod & Tela de Salvamento ao Concluir Missões](https://www.mixmods.com.br/2019/08/tela-de-salvamento-ao-terminar-missoes-v2-0-1/):**
  - Salva o progresso automaticamente ao completar qualquer missão ou checkpoint (ou abre imediatamente a tela de seleção de slot), eliminando a necessidade de dirigir de volta até uma safehouse.
* **[Taxi Fare / Ride as Passenger (Andar de Táxi como Passageiro)](https://www.mixmods.com.br/):**
  - Permite assobiar e embarcar no banco de trás de qualquer táxi (`F` ou buzina). Você pode pular direto para o destino marcado no radar ou curtir a viagem ouvindo as rádios em 1ª pessoa.
* **[HD Underwater v2.0 (Corais, Peixes e Vida Marinha)](https://www.mixmods.com.br/2022/06/sa-hd-underwater/):**
  - Substitui o fundo do oceano cinzento e vazio por corais coloridos em alta definição, algas animadas e cardumes de peixes tropicais convertidos do GTA Trilogy.
* **[GInput (Suporte Nativo a Controles Modernos Xbox / DualSense)](https://www.mixmods.com.br/2020/06/ginput/):**
  - Suporte completo a XInput e DirectInput com vibração tátil realista (rumble), aceleração suave nos gatilhos analógicos e ícones dos botões exibidos na interface do jogo.
* **[SA] CamHunt (Modo Foto Profissional & Câmera Livre 360°)](https://www.mixmods.com.br/2022/09/sa-camhunt/):**
  - Permite desacoplar a câmera livremente a qualquer momento (a pé ou dirigindo a 200 km/h) com controle total de rotação 360°, ângulo de visão (FOV), inclinação lateral (*roll*) e profundidade de campo (*Depth of Field* / desfoque cinematográfico estilo DSLR).
  - Inclui congelamento de cena para capturas fotográficas de explosões, saltos acrobáticos e paisagens de San Andreas em resolução nativa 4K.
* **[Lógica & Bom Senso do Mundo Vivo (World Logic Overhaul)]:**
  - **[Sensible Police & Crime Report Mod]:** A polícia só recebe chamados se testemunhas correrem até orelhões/celulares ou se viaturas presenciarem o crime. Disparos no deserto ou áreas isoladas sem testemunhas não geram estrelas de procurado.
  - **Polícia Equânime (MixSets `CopsShootGangs = 1`):** Policiais enquadram, perseguem e trocam tiros com membros de gangues rivais (Ballas, Vagos) armados em vez de focarem cegamente apenas no CJ.
  - **[Paramedics Revive Peds Mod]:** Paramédicos utilizam desfibrilador em vítimas de atropelamento/tiroteio no chão, reanimando pedestres com sucesso.
  - **[Firefighters Extinguish Cars & Fires]:** Bombeiros miram jatos d'água no motor de carros em chamas e em focos de incêndio, salvando veículos antes da explosão.
  - **[More Locked Cars](https://www.mixmods.com.br/2018/08/more-locked-cars-mais-carros-trancados-e-com-alarme/) + [Alarm Touching Cars](https://www.mixmods.com.br/2021/07/alarm-touching-cars-alarme-ao-tocar-carros/):** Carros estacionados têm chances de estarem trancados; forçar portas ou quebrar vidros dispara o alarme automotivo e atrai pedestres e policiais.
  - **[Open Door Anim v1.2.2](https://www.mixmods.com.br/2021/04/open-door-anim-v1-2-1-animacao-abrindo-porta/):** CJ gira maçanetas fisicamente para entrar em edifícios em vez de teletransportar magicamente em cones amarelos.
  - **[Swim FPS Fix](https://www.mixmods.com.br/2019/04/swim-fps-fix-corrigir-nadar-com-fps-alto/):** Calibra a impulsão e fôlego das braçadas ao nadar para monitores de 60 FPS cravados sem afogamentos acidentais.
* **[NPCs & Todos os Personagens Realistas (Fim dos Clones)]:**
  - **[[SA] Proper Characters Retex HD](https://www.mixmods.com.br/2021/08/proper-characters-retex-hd-peds-remasterizados/):** Remasteriza 100% dos personagens da história e mais de 300 pedestres civis/gangues com texturas 2K/4K fiéis à arte original da Rockstar.
  - **[PedFuncs v0.5.1](https://www.mixmods.com.br/2022/07/pedfuncs/) + [Peds Extender](https://www.mixmods.com.br/2022/08/peds-extender/) + [Model Variations](https://www.mixmods.com.br/2022/06/model-variations/):** Gera quase 4.000 variações procedurais (roupas, óculos, bonés, tons de pele e tatuagens), erradicando pedestres gêmeos.
  - **[Peds Bleeding](https://www.mixmods.com.br/2022/12/atualizados-peds-bleeding-wind-project-skygfx-extended/) + [Death In Car](https://www.mixmods.com.br/2022/06/death-in-car-morrer-dentro-do-carro/):** Sangramento dinâmico localizado e motoristas abatidos ao volante que tombam sobre a buzina.
* **[Praias Vivas & Píer de Santa Maria Expandido]:**
  - **[[SA] Santa Maria Pier Extended](https://www.mixmods.com.br/2022/12/sa-santa-maria-pier-extended/) + [[SA] Pacific Park Rotating Ferris Wheel](https://www.mixmods.com.br/2022/12/sa-pacific-park-rotating-ferris-wheel-roda-gigante-animada/):** Roda-gigante animada iluminada 24h, barracas de feira, quiosques, banhistas em toalhas, salva-vidas e redes de vôlei de praia.
* **[Zero Loading, Arsenal Móvel, Comboios de Gangue & Concessionárias]:**
  - **[[III/VC/SA] SaveLoader v2.7](https://www.mixmods.com.br/2020/01/iii-vc-sa-saveloader-v2-7-fast-loader-carregamento-rapido/) + [Phoenix Mode](https://www.mixmods.com.br/2018/03/phoenix-mode-voltar-onde-estava-quando-morrer/) + *No Fade Interiors* + *Borderless Gaming*:** Carrega o último save direto na rua em menos de 2s sem passar por menus, elimina telas pretas ao entrar em lojas e permite `Alt + Tab` instantâneo em 0 ms.
  - **[Trunk Store Weapons (Arsenal no Porta-Malas)](https://www.mixmods.com.br/2021/04/trunk-store-weapons-guardar-armas-no-porta-malas/):** Permite abrir fisicamente o porta-malas do carro para armazenar e retirar armamento pesado e coletes.
  - **[[SA/SA:DE] Burglary With Any Car v2.0](https://www.mixmods.com.br/2022/01/sa-sade-burglary-with-any-car-roubar-casa-com-qualquer-carro/) + [24/7 Robbery](https://www.mixmods.com.br/2019/08/24-7-robbery-roubar-lojas/):** Permite realizar roubos residenciais noturnos com qualquer veículo (sem depender da van Boxville) e assaltar caixas de lojas 24/7.
  - **[Gang Rider v2 (Comboio de 7 Aliados)](https://www.mixmods.com.br/2020/08/gang-rider-v2-carregar-mais-gangue/) + [Random Car Talk](https://www.mixmods.com.br/2022/06/sa-random-car-talk/):** Libera todos os assentos e caçambas de caminhonetes/vans para levar até 7 membros da Grove Street atirando simultaneamente e conversando durante o trajeto.
  - **[Car Dealership (Concessionárias Funcionais)](https://www.mixmods.com.br/2020/06/car-dealership-concessionaria-de-carros/) + *Garage eXtender*:** Showrooms interativos em Los Santos, San Fierro e Las Venturas para compra e *test-drive*, com garagens suportando até 8 veículos salvos sem sumiço.
  - **Ciclo Solar Estendido & Tempestades de Areia (*Sandstorm Overhaul*):** Relógio interno ajustado (1h in-game = 2 a 3 min reais) e tempestades volumétricas densas em Bone County.

---

## 11. Overhaul de Sub-Missões (R3): Emergência, Vigilante, Táxi & Recompensas de Elite

* **Geração Local de Alvos (*Local Sub-Missions Spawner*):**
  - **O fim dos alvos no outro lado do mapa:** Restringe a criação de pacientes da ambulância, bandidos do vigilante e incêndios para um raio máximo de **600 metros** do veículo atual dentro do mesmo bairro/distrito.
  - Elimina o absurdo do jogo vanilla de mandar você buscar um paciente em Mulholland ou atravessar três rodovias com 40 segundos restantes no nível 11.
* **Sistema de Checkpoint por Nível (*Sub-Missions Checkpoints*):**
  - No jogo base, se a ambulância capotar ou explodir no nível 12, você é punido voltando para o nível 1.
  - Com o mod de checkpoints, o progresso é gravado a cada 3 níveis (Checkpoints nos níveis 3, 6, 9 e 12). Se falhar ou o veículo quebrar, você recomeça imediatamente do último marco alcançado.
* **[Vigilante Special (Missão de Polícia em Qualquer Veículo)](https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/):**
  - Permite acionar o serviço de vigilante em **qualquer carro, moto esportiva, helicóptero ou tanque**. Você não fica mais refém das viaturas lentas e frágeis da polícia.
* **Imunidade Policial durante Serviços Públicos (*No Wanted Level in Sub-Missions*):**
  - Policiais não concedem estrelas de procurado ao jogador por atirar nos criminosos do Vigilante nem por derrubar postes/hidrantes ao socorrer vítimas na ambulância.
* **Recompensas Exponenciais e Ativos de Renda Passiva:**
  - **Ambulância (Nível 12):** +50% de Vida Máxima permanente (Barra em 150%) + **$50.000 em dinheiro limpo** + Ambulância de resgate especial permanente na safehouse com kit de primeiros socorros que recupera a vida do CJ instantaneamente.
  - **Bombeiro (Nível 12):** Imunidade 100% contra fogo (*Fireproof*) + **$50.000** + Caminhão de Bombeiros com canhão d'água de alta pressão na garagem de Doherty.
  - **Vigilante (Nível 12):** +50% de Colete Máximo (Barra em 150%) + **$100.000** + Viaturas especiais (Enforcer blindado e moto HPV-1000) estacionadas na Grove Street com coletes grátis.
  - **Táxi (50 Corridas):** Todos os táxis ganham nitro hidráulico ao buzinar + **Empresa de Táxi de Los Santos vira um ativo financeiro com $5.000 de renda passiva diária** coletável na porta de casa + Corridas de táxi gratuitas para o CJ viajar como passageiro.
  - **Cafetão (Pimping - Nível 10):** Prostitutas pagam a você + **$3.000 de renda passiva diária** + Broadway tunada blindada permanente na garagem.
  - **Ladrão (Burglary - $10.000 roubados):** Stamina infinita para corrida + **$30.000 de bônus**.

---

## 12. A Fronteira Viva: Transformando o GTA San Andreas no Nível RDR2 (Wilderness, Fauna & Imersão Orgânica)

* **[Myths Maker – Animals Pack (Fauna Selvagem e Doméstica Completa)](https://www.mixmods.com.br/2022/10/myths-maker-animals-pack-mod-de-animais/):**
  - **O que faz:** Acaba com o "deserto biológico" do mapa original da Rockstar. Povoa todo o interior do estado com vida selvagem e inteligência artificial biológica:
    - **Florestas e Montanhas (Flint County, Whetstone, Mount Chiliad):** Cervos, veados e javalis pastando e reagindo ao som de passos/tiros; predadores territoriais como ursos pardos e lobos selvagens que atacam o jogador se encurralados.
    - **Deserto de Bone County:** Coiotes caçando em bandos noturnos e abutres voando em círculos sobre carcaças.
    - **Áreas Rurais e Cidades:** Vacas e galinhas em celeiros de fazendas; cães domésticos passeando com moradores e latindo para estranhos.
    - **Céu Vivo:** Bandos de pássaros com formação em "V" que reagem a disparos de armas e sobrevoos de aeronaves.
* **[Weapons OutFit (Armas Visíveis no Corpo Estilo Red Dead Redemption)](https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/):**
  - **Fim das armas mágicas que somem no bolso:** Todas as armas equipadas no inventário ficam fisicamente presas ao corpo do CJ:
    - Fuzis (M4, AK-47) e espingardas pendurados nas costas por bandoleiras.
    - Pistolas, revólveres e submetralhadoras repousando em coldres táticos na cintura.
    - Facas de caça e katanas embainhadas na lateral do corpo.
* **Sistema de Diálogo com Pedestres (*Greet & Antagonize Mod*):**
  - Permite interagir verbalmente com qualquer NPC na calçada usando teclas dedicadas:
    - **Cumprimentar (*Greet*):** CJ dá bom dia amigável, puxa conversa com membros da comunidade e ganha respeito.
    - **Provocar (*Antagonize*):** CJ insulta, intimida e desafia pedestres para brigas de rua ou trocas de tiros, com dezenas de falas dubladas pelo dublador original (Young Maylay).
* **[Camping Mobile Save House 2.0a (Acampamento Selvagem & Sobrevivência)](https://www.mixmods.com.br/2015/11/camping-mobile-save-house-20a-trailer-attach.html):**
  - Permite acampar nas matas e no topo do Mount Chiliad: monte fogueiras de acampamento para descansar, passar o tempo e salvar o jogo sob céu estrelado, com suporte a engate de trailers e casas móveis na van *Journey*.
* **Pegadas Dinâmicas na Areia, Lama e Trilhas de Pneus (*Dynamic Tracks & Footprints*):**
  - CJ, pedestres e animais deixam pegadas físicas profundas na areia da praia de Santa Maria e no barro úmido das estradas de Red County.
  - Carros e motos deixam rastros de terra e sulcos de lama nas estradas de chão batido.
* **Física de Vento nas Árvores & Vegetação (*Dynamic Foliage & Wind Physics*):**
  - Pinheiros do Mount Chiliad, copas das árvores florestais e palmeiras de Los Santos balançam fisicamente de acordo com a velocidade do vento e rajadas de tempestades.

---

## 13. Todos os Mods Indexados (Catálogo Geral do Scraper)

### [[SA] Proper Streaming (corrigir mapa não carregando)](https://www.mixmods.com.br/2026/10/proper-streaming/)
**Data da Publicação:** `2026-10-16`
> Sucessor do nosso antigo mod “Improved Streaming“: melhora o funcionamento e limitações do carregamento de arquivos do jogo, especialmente .dff (modelos), .txd (texturas) etc. Para um melhor gerenciamento de uso de disco e RAM.Um mod revolucionárioTexture Bridge: as texturas do jogo agora são armaze...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/79u303jv0csa/Proper_Streaming.zip.html)

### [[SA] Proper Shaders (gráficos HD para GTA SA)](https://www.mixmods.com.br/2026/10/sa-proper-shaders/)
**Data da Publicação:** `2026-10-01`
> Atualizado 01/09/26Nova versão: Outubro (10-26) lançada para apoiadores alpha! E versão de 1 mês atrás agora disponível para apoiadores beta, e 2 meses atrás disponível para o público.Em destaque: Implementado suporte à texturas shadermaps PBR (normal map, roughness map, metallicness map); implement...
**Links de Referência / Download:**
- [Cloudworks (by Brian Tu)](https://github.com/keroroxzz/CloudWorks)
- [Download / Link](https://sharemods.com/px30jmq1k2xo/SA_-_Proper_Shaders_08-26___40_py8vte2gr7a__41_.zip.html)

### [[SA] SilentPatch (Build 34.1 – 2026)](https://www.mixmods.com.br/2026/08/sa-silentpatch/)
**Data da Publicação:** `2026-08-01`
> Atualizado 16/08/26Hotfix: Várias correções importantes. A versão anterior foi gigante, e isso causou vários pequenos novos problemas causados pelo mod em si, inclusive incompatibilidades/conflitos com outros mods como SAMP, FLA e MVL (mais informações aqui). Tudo agora foi corrigido, e também adici...
**Links de Referência / Download:**
- [mais informações aqui](https://github.com/CookiePLMonster/SilentPatch/releases/tag/1.1-BUILD34.1-SA)
- [Download / Link](https://sharemods.com/zdp5ii5d9z6s/SA_-_SilentPatch.zip.html)

### [[SA/PC/Mobile] Improved Streaming v1.1 (corrigir mapa não carregando)](https://www.mixmods.com.br/2026/07/improved-streaming/)
**Data da Publicação:** `2026-07-17`
> Atenção:Novo mod melhor foi lançado:Proper StreamingInclusive quebra o limite de 32 bits de RAM do jogo!Atualizado 17/07/26Adicionar novas opções avançadas neste mod causou mais malefícios do que benefícios – aumentou muito a quantidade de pessoas leigas pedindo ajuda no nosso Discord por estarem us...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dnlu9kd7wejz/Improved_Streaming.zip.html)
- [Download / Link](https://sharemods.com/2gnk5klzuhwp/SA_Mobile_-_Improved_Streaming.zip.html)

### [[SA] Proper Fixes v2.1.1 (pack de correções para PC)](https://www.mixmods.com.br/2026/06/sa-proper-fixes/)
**Data da Publicação:** `2026-06-30`
> Atualizado 16/07/26Hotfix: No download da versão para o RoSA estava vindo sem texturas adicionais em HD (provavelmente substituí sem querer no último hotfix). Corrigido.Atualizado 30/06/26Hotfix: Corrigido pequenos problemas da nova versão (principalmente as cadeiras da auto-escola) e adiciona algum...
**Links de Referência / Download:**
- [este .bat](https://drive.google.com/file/d/115LMhaNP6mh-Sip9Sbtdl9EulSUlaq2F/view)
- [Download / Link](https://sharemods.com/wfei1aulci38/Proper_Fixes.7z.html)
- [Download / Link](https://drive.google.com/file/d/1-3y5MTDi01kGJuOgyt4fOrn79WFP4trv/view?usp=sharing)
- [Download / Link](https://sharemods.com/1gcvzcxijafz/Proper_Fixes_-_for_RoSA_Evolved.7z.html)

### [[SA] Soundize (AAA audio system)](https://www.mixmods.com.br/2026/06/soundize/)
**Data da Publicação:** `2026-06-01`
> Atualizado 02/10/26Agora o som do RPM é suave mesmo em FPS baixo.Agora o efeito de reverb dos veículos em tuneis e embaixo de pontes só serão ouvidos se você estiver também no tunel, ou fora dele mas próximo, para o efeito ser mais natural. e lógico.Corrigido problemas de carregamento do mesmo carro...
**Links de Referência / Download:**
- [aqui (Soundize)](https://github.com/JuniorDjjr/soundize/wiki/)
- [aqui (VehFuncs)](https://github.com/JuniorDjjr/VehFuncs/wiki/%5BEN%5D-Characteristics)
- [Download / Link](https://mega.nz/file/XZUBDTIK#EXiQsfRIg78fHKYU5p6tNlEVkOXDkiVwUoDZSyNQV2s)

### [ModLoader 0.3.10 para GTA SA / VC / III](https://www.mixmods.com.br/2026/05/modloader/)
**Data da Publicação:** `2026-05-17`
> Português English Atualizado v0.3.10 – 10/08/26Contribuições do Silent e sndth.Adicionado suporte para carregar pasta modloader junto com ASI (exemplo, scripts/modloader).Melhorado a compatibilidade com ajuste de limites de IDs (fastman92 limit adjuster, Open Limit Adjuster Extended).Atualizado v0.3...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/7jrzxw0b8x9j/ModLoader.zip.html)
- [baixar a tradução para o ModLoader](https://www.mixmods.com.br/2017/05/traducao-modloader-portugues-pt-br.html)
- [this](https://github.com/thelink2012/modloader/blob/v0.3.9/doc/config/modloader.ini.0#L6)

### [[SA] Urbanize (ambient NPCs)](https://www.mixmods.com.br/2026/02/urbanize/)
**Data da Publicação:** `2026-02-02`
> Atualizado 02/02/26E aqui está a versão final do Urbanize, agora para o público!Agora, também foi corrigido aparecendo pedestres de guarda chuva em interiores, e outros 12 scripts foram atualizados para corrigir um crash raríssimo.Urbanize é um projeto de mod com o objetivo de reviver o GTA San Andr...
**Links de Referência / Download:**
- [mod “GTA V Bahama Mama’s” da Michelle](https://www.gtainside.com/en/sanandreas/mods/139330-gta-v-bahama-mama-s-evolution-undercover/)
- [atualizar a CLEO 4](https://github.com/cleolibrary/CLEO4/pull/25)
- [Download / Link](https://sharemods.com/moincval44bp/SA_-_Urbanize_12-25_Final_1.zip.html)

### [[GTA SA] Proper Shaders (teaser)](https://www.mixmods.com.br/2026/02/gta-sa-proper-shaders-teaser/)
**Data da Publicação:** `2026-02-01`
> Proper Shaders é um novo mod de gráficos HD realistas criado por nós, com objetivo de ser estável, otimizado, não intrusivo, altamente compatível com mods, e com todas as funcionalidades opcionais.﻿Me apoie para baixar o mod no Patreon (acesso antecipado dia 1 de Março).Apoie também a Jéssica Natáli...

### [[SA] VehFuncs v2.5.5](https://www.mixmods.com.br/2025/12/sa-vehfuncs/)
**Data da Publicação:** `2025-12-06`
> Português English Atualizado – 03/09/26Adicionado f_an5 (inverso da f_an2, para quando não há ocupante).Adicionado mais informações no log para identificar conflitos com mods.Atualizado – 01/09/26Código revisado corrigindo várias pequenas coisas, para melhor estabilidade. Também foi implementado cor...
**Links de Referência / Download:**
- [ModelExtras](https://github.com/user-grinch/ModelExtras)
- [Extras Recursivos](https://github.com/JuniorDjjr/VehFuncs/wiki/%5BPT%5D-Extras-Recursivos)
- [Características](https://github.com/JuniorDjjr/VehFuncs/wiki/%5BPT%5D-Caracter%C3%ADsticas)
- [Velocímetro Digital](https://github.com/JuniorDjjr/VehFuncs/wiki/%5BPT%5D-Painel-Digital:-Veloc%C3%ADmetro)

### [Muitos mods importantes foram atualizados](https://www.mixmods.com.br/2025/07/muitos-mods-importantes-foram-atualizados/)
**Data da Publicação:** `2025-07-27`
> Esta postagem é um aviso geral que hoje e dias atrás houve atualizações importantes em vários mods:Lembrando que Essentials Pack já vem com alguns dos mods que foram atualizados, então basta baixar ele.Silent’s ASI Loader *Agora também é case-insensitive (não diferencia maiúsculas de minúsculas).Cas...

### [[SA] Silent’s ASI Loader v1.5](https://www.mixmods.com.br/2025/07/sa-silent-asi-loader/)
**Data da Publicação:** `2025-07-27`
> Atualizado 27/07/25Agora também é case-insensitive (não diferencia maiúsculas de minúsculas).Caso estiver o mesmo mod .asi instalado na pasta do jogo e pasta “scripts” mostrará um aviso. Mas isto não inclui ModLoader.Atualizado 11/07/25Depois de mais de uma década, fastman92 atualizou o mod para GTA...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/f67rcc920tm9/SA_-_Silent_ASI_Loader.zip.html)

### [[SA] VehDeform v1.3c (amassar carros)](https://www.mixmods.com.br/2025/06/sa-vehdeform-amassar-carros/)
**Data da Publicação:** `2025-06-23`
> Atualizado 27/07/25Corrigido vários problemas e crashes com peças tuning.Corrigido mais incompatibilidades com VCParticles.Atualizado 18/07/25Provas de invencibilidade, como colisão, tiros, explosões, são usadas como condições para deformar algo.VDCOL agora muda todas as deformações em vez de só col...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/w56pqdc3vr1v/VehDeform.zip.html)

### [FxsFuncs v1.2 (melhorias para efeitos especiais)](https://www.mixmods.com.br/2025/06/fxsfuncs/)
**Data da Publicação:** `2025-06-15`
> Atualizado 15/06/25Com o passar dos anos eu fui fazendo pequenas melhorias à pedido do Ezekiel, que são úteis para os mods de efeitos dele. Então aqui está a versão atualizada do mod.Adicionado uma maneira de adicionar efeitos pelo mapa de maneira altamente otimizada, sem uso de scripts, usando arqu...
**Links de Referência / Download:**
- [Exemplo](https://gist.github.com/JuniorDjjr/24d38f89d798cab00db571ede8576ce8)
- [Download / Link](https://sharemods.com/1ly65k5xchjr/FxsFuncs.7z.html)

### [[SA/SA:DE] Proper Player Retex v3.2 (CJ com texturas em HD) (PC/Android)](https://www.mixmods.com.br/2024/12/proper-player-retex/)
**Data da Publicação:** `2024-12-22`
> Atualizado 5/12/25Nova versão para PC, com correções e melhorias para roupas!Port oficial para Android (mobile)!Todas as texturas do CJ remasterizadas em HD, preservando o estilo original do jogo!Compramos a versão premium do Remini para recriar todos os rostos em maior definição, entre muitos outro...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dckdhp4ir86q/Proper_Player_Retex.7z.html)
- [Download / Link](https://sharemods.com/44gazw5mqqjt/Proper_Player_Retex_for_Android.7z.html)
- [Download / Link](https://sharemods.com/gewtp59idbrn/SADE_-_Proper_Player_Retex.7z.html)

### [In-Game Map Editor v0.7 (editor de mapa dentro do jogo)](https://www.mixmods.com.br/2024/12/in-game-map-editor/)
**Data da Publicação:** `2024-12-19`
> Atualizado 19/12/24Para posicionar os mais de 12 mil objetos do meu projeto Urbanize, eu andei atualizando este mod para ficar mais fácil e estável de usar. Então está aqui ele atualizado com todas as melhorias que eu andei fazendo nos últimos meses:Corrigido todos os problemas com rotações complexa...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/kmxsdpto6re8/In-Game_Map_Editor.zip.html)
- [Source code](https://gist.github.com/JuniorDjjr/9cb8bf9d4d8d57af0afc82cd6aa381e9)

### [[SA] Original Radio Extended (1000 músicas)](https://www.mixmods.com.br/2024/08/original-radio-extended/)
**Data da Publicação:** `2024-08-13`
> Atualizado 13/08/24Foi estendida também a rádio K-Jah West! Total de 109 músicas, com opção de restaurar ela no lugar da Non Stop Pop, ou adicionando sem substituir na User Tracks Player. Agora o mod totaliza 1122 músicas!Todas as músicas tiveram os anos revisados. Das quase 900, 16 músicas eram rec...
**Links de Referência / Download:**
- [Download / Link](https://www.mediafire.com/file/o1i176yzp1qbj9y/Original+Radio+Extended.zip/file)
- [Download / Link](https://www.mediafire.com/file/u9stkjz6ar5hhz7/Original+Radio+Extended+-+Alternative+Version.zip/file)
- [Download / Link](https://www.mediafire.com/file/xawonfwgpjjgxh0/Restore+K-JAH+West.zip/file)

### [[SA] SkyGfx v4.2b + Extended v1.7](https://www.mixmods.com.br/2024/03/sa-skygfx/)
**Data da Publicação:** `2024-03-25`
> Atualizado (Extended v1.7) 25/03/24 17:05Corrigido a posição dos reflexos cubemap/env (usado em carros): Agora é usada a posição da câmera em vez da posição do player, o que faz muito mais sentido e é assim que quase todos os jogos funcionam (inclusive GTA V). Possibilita um melhor uso dos reflexos,...
**Links de Referência / Download:**
- [Código fonte](https://github.com/JuniorDjjr/skygfx)
- [Download / Link](https://sharemods.com/stxvlyt5j4q4/SA_-_SkyGfx_Extended.zip.html)
- [Download / Link](https://sharemods.com/sge66plqjc1z/SkyGfx.7z.html)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)

### [[SA] CLEO+ v1.2.0](https://www.mixmods.com.br/2023/10/cleoplus/)
**Data da Publicação:** `2023-10-01`
> Atualizado 01/10/23 17:05Adicionado 28 novos comandos! Novos mods podem só funcionar nesta nova versão.As configurações de todos os comandos foram revisadas, e agora há tudo documentado no Sanny Builder Library. Agradecimentos ao OrionSR.Destaque: “LOAD_SPECIAL_MODEL”: Carrega arquivos .dff e .txd a...
**Links de Referência / Download:**
- [plugin-sdk](https://github.com/DK22Pac/plugin-sdk)
- [Download / Link](https://sharemods.com/3yrdrs7l9v6r/CLEOPlus.zip.html)
- [Source code](https://github.com/JuniorDjjr/CLEOPlus)
- [Github](https://github.com/JuniorDjjr/CLEOPlus/)

### [[SA] RoSA Evolved v1.5 (remaster texturas HD 2026) PC/Android](https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/)
**Data da Publicação:** `2023-07-16`
> Atualizado 5/12/25Adicionado nova versão oficial para Android, portado pela própria autora.Note que o mod continua sendo atualizado mensalmente, dia 15 de todo mês.O melhor pack de texturas remasterizadas em HD para GTA San Andreas (PC/mobile).Para GTA SA The Definitive Edition, baixe: [SA:DE] RoSA ...
**Links de Referência / Download:**
- [Tutorial da autora aqui (em inglês)](https://github.com/jessicanataliagta/tutorials_for_gta/wiki/GTA-SA-‐-How-to-Install-RoSA-Evolved)
- [veja o tutorial da autora](https://github.com/jessicanataliagta/tutorials_for_gta/wiki/GTA-SA-‐-How-to-Install-RoSA-Evolved#how-to-use-rosa-project-evolved-in-samp)

### [[SA] RTX Remix (download)](https://www.mixmods.com.br/2023/05/sa-rtx-remix/)
**Data da Publicação:** `2023-05-23`
> Atualização 2025:A compatibilidade com o GTA San Andreas foi simplesmente abandonada pela NVIDIA. Nós revisitamos outras vezes, e o jogo continua péssimo, muito instável para o RTX Remix. Nós não pretendemos continuar esse projeto, são muito bugs, instabilidades e é pesado demais. Continue no bom e ...
**Links de Referência / Download:**
- [RTX Remix](https://github.com/NVIDIAGameWorks/rtx-remix/releases/latest)
- [Download / Link](https://sharemods.com/5i461ooex6jt/SA_-_RTX_Remix.zip.html)

### [GTA San Andreas com RTX Remix supera expectativas](https://www.mixmods.com.br/2023/05/gta-san-andreas-com-rtx-remix-supera-expectativas/)
**Data da Publicação:** `2023-05-17`
> RTX Remix foi lançado há pouco tempo e ainda está na versão 0.2, dando seus primeiros passos, mas já demonstra resultados impressionantes!As imagens e o vídeo foi gravado numa RTX 3060 com RoSA Evolved, e já roda muito bem.Para contexto, desde o primeiro anúncio do RTX Remix, a NVIDIA deixou claro q...

### [[SA] Santa Maria Pier Extended (parque de diversões)](https://www.mixmods.com.br/2022/12/sa-santa-maria-pier-extended/)
**Data da Publicação:** `2022-12-25`
> Atualizado 22/11/24Corrigido incompatibilidade com o novo Proper Fixes.Corrigido problema do carregamento do colisor (caso já tenha instalado, apague o mod antes de atualizar).Mod que expande o pier da praia de Santa Maria adicionando um lindo carrossel animado com pessoas e música:O movimento do ca...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/qa2p3422m9am/SA_-_Santa_Maria_Pier_Extended.7z.html)
- [Código-fonte](https://gist.github.com/JuniorDjjr/9f6c0d79f165cb7f4c431af0dd906a58)

### [[SA] Pacific Park Rotating Ferris Wheel (roda-gigante animada)](https://www.mixmods.com.br/2022/12/sa-pacific-park-rotating-ferris-wheel-roda-gigante-animada/)
**Data da Publicação:** `2022-12-24`
> Roda-gigante funcional para GTA San Andreas, que gira, com luzes animadas, remasterizada em HD com base na real de Los Angeles em 1992.Mod criado com base no mod “[SA] Rotating Ferris Wheel (roda gigante animada do GTA V e vanilla)“, mas agora combinando com a época do GTA San Andreas!Como no mod or...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/y5pkv6qmpy9y/SA_-_Pacific_Park_Rotating_Ferris_Wheel.7z.html)

### [SA Snow Conversion 2022 (mod pack)](https://www.mixmods.com.br/2022/12/sa-snow-conversion-mod-pack/)
**Data da Publicação:** `2022-12-23`
> Atualizado 23/12/22Adaptado ao LOD Vegetation (que também inclui no Proper Fixes)! Agora as árvores distantes também ficarão com neve.Adicionado uma versão do Proper Radar (minimapa HD e corrigido) com cores que combinam com neve.Corrigido mais várias texturas distantes que ainda estavam sem neve.Sn...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/bn17c3snstt1/SA_Snow_Conversion.7z.html)
- [Para desenvolvedores (arquivos .png)](https://sharemods.com/3ze6mgwah98q/Snow_Andreas_-_PNG_DEV.7z.html)

### [[SA] DYOM – Design Your Own Mission (2022)](https://www.mixmods.com.br/2022/11/sa-dyom/)
**Data da Publicação:** `2022-11-08`
> Atualizado 08/11/22Adicionado nova versão e addon.Postagem reescrita e download reorganizado (pois estava uma bagunça).Um mod clássico de 2 milhões de downloads e 67 mil missões publicadas desde 2008 até hoje (2022).Este mod revolucionou e levantou a comunidade do GTA San Andreas na época.Se trata d...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/gq01h5shttg9/DYOM_8.1.zip.html)
- [Download / Link](https://sharemods.com/g0sgqn2gbg48/DYOM_8.2.zip.html)
- [Site oficial para baixar missões](https://dyom.gtagames.nl/)

### [[SA] Tree House v1.1 (mod casa na árvore)](https://www.mixmods.com.br/2022/11/sa-tree-house-mod-casa-na-arvore/)
**Data da Publicação:** `2022-11-04`
> Atualizado 04/11/22Adaptado para o shader de efeito de vento! SkyGfx Extended.Adaptado para o mod de subir escadas! Ladders Mod.Nota: Ambos são opcionais, e a escada foi editada para encaixar melhor.Um mod muito legal e único criado por nós!﻿Nota: Agora o mod inclui shader de efeito de vento e é ada...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zf4cw8dt5y0j/SA_-_Tree_House.7z.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/b4fb03f09189a5e49e66f58852c12944)

### [[SA] Story Mode v2.0 (melhorias pra storyline)](https://www.mixmods.com.br/2022/11/story-mode/)
**Data da Publicação:** `2022-11-03`
> Atualizado 28/07/25Corrigido falta de alguns arquivos que causava crash em algumas missões (não faço ideia do motivo do arquivo estar faltando, provavelmente foi um update do main.scm).Mod que corrige e melhora diversos elementos e aspectos do modo história (campanha) do GTA San Andreas, para um gam...
**Links de Referência / Download:**
- [este](https://www.mediafire.com/file/ip2ye06jo9h1l8b/Modded_Chaos.zip/file)
- [Download / Link](https://sharemods.com/iq9lg1tafztf/Story_Mode.7z.html)
- [Download / Link](https://drive.google.com/file/d/11fAYbdAY-DbdR9VdOPWw6f5xf9JIambS/view?usp=sharing)

### [[SA] Ladders Mod (subir escadas)](https://www.mixmods.com.br/2022/11/ladders-mod-subir-escadas/)
**Data da Publicação:** `2022-11-02`
> Atualizado 27/04/25Corrigido morrer enquanto está na escada.Depois de quase 2 décadas, o GTA San Andreas finalmente ganha um bom mod de subir escadas!Eu o criei da melhor forma possível. As animações são excelentes e muito naturais!﻿Boa adaptação para gamepad, e eu não testei, mas teoricamente funci...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/r9991nx53e61/SA_-_Ladders_Mod.zip.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/6e7a1427d4dd4685b2b9e0603296da4d)

### [Projeto Urbanize – Apoie!](https://www.mixmods.com.br/2022/10/projeto-urbanize-apoie/)
**Data da Publicação:** `2022-10-27`
> Atualizado 27/10/22Pessoas perguntaram se o mod realmente é otimizado e roda em PCs fracos. Eu criei o “núcleo” do mod e fiz um teste de performance e estabilidade com 50 mil urbanizações e 100 mil NPCs! Valores absurdos, e mesmo assim mais de 100 FPS e nenhum stutter num i5. Veja o vídeo.Até o mome...

### [[SA] Wind Project v1.0.2 (mod de vento)](https://www.mixmods.com.br/2022/10/wind-project/)
**Data da Publicação:** `2022-10-23`
> Atenção:Wind Project agora é continuado dentro do mod Proper Fixes v2 ou mais novo!Se você tem o novo Proper Fixes, NÃO instale o Wind Project!Um projeto que vai revolucionar o GTA SA, para um cenário mais vivo e com movimento!O objetivo é adaptar todo o mapa do jogo para o shader de vento do SkyGfx...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/3b7uuwotoncu/SA_-_Wind_Project.7z.html)

### [[SA] RepairGTA (corrigir problemas automaticamente)](https://www.mixmods.com.br/2022/10/repair-gta/)
**Data da Publicação:** `2022-10-22`
> Atualizado 14/08/23Corrigido um bug onde fazia remover os carros das namoradas (teoricamente, a versão trancada deles, antes do 50% de progresso). Caso exista esse problema no seu jogo, instale este script para corrigir.Atualizado 22/10/22Mais uma revolução: Agora você pode instalar e desinstalar mo...
**Links de Referência / Download:**
- [instale este script para corrigir](https://sharemods.com/6s9h92i8pfd0/Girlfriend_Parked_Cars_Restore_Fix.zip.html)
- [Download / Link](https://sharemods.com/j9a31w31d3ob/RepairGTA.7z.html)
- [Source code](https://github.com/JuniorDjjr/RepairGTA)

### [Myths Maker v2.7 (criar mitos e lendas)](https://www.mixmods.com.br/2022/10/myths-maker-criar-mitos-lendas/)
**Data da Publicação:** `2022-10-21`
> Atualizado v2.7 21/10/22Esqueça de como o mod era, esta atualização muda muita coisa!Novo menu, agora não usa mais o menu original do jogo, este novo é controlável com o mouse e é mais rápido para manusear;Agora é possível escolher um tamanho de área para criar em cada localização de cada lenda/anim...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/qi1khsdznvmg/Myths_Maker.7z.html)

### [Myths Maker – Animals Pack (mod de animais)](https://www.mixmods.com.br/2022/10/myths-maker-animals-pack-mod-de-animais/)
**Data da Publicação:** `2022-10-21`
> Atualizado 21/10/22Esqueça de como o mod era, esta atualização muda muita coisa!Todo o pack de animais foi reformado e re-imaginado, muitos modelos trocados etc.Totalmente adaptado ao novo Myths Maker, que adiciona muitas novas funções para animais, como inteligências (os animais se assustam e ataca...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/wia802k6ikkm/Myths_Maker_-_Animals_Pack.7z.html)

### [[SA] Furniture Mod v1.0 beta (comprar móveis)](https://www.mixmods.com.br/2022/10/sa-furniture-mod/)
**Data da Publicação:** `2022-10-20`
> Um grande mod para você comprar móveis no GTA San Andreas!Uma total nova mecânica de gameplay, trazendo mais utilidade ao seu dinheiro e deixando suas casas mais únicas e detalhadas.É com certeza um dos mods mais legais que eu já criei.Compre móveis para qualquer casa (interior com pickup de salvame...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/0zi4kjql48g1/SA_-_Furniture_Mod.zip.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/900c72052fd385fab4512a840acfcf0d)

### [[III|VC|SA] OLA – Open Limit Adjuster v1.7](https://www.mixmods.com.br/2022/10/open-limit-adjuster/)
**Data da Publicação:** `2022-10-17`
> Mods ajustadores de limites são importantes para instalar mods no GTA, para aumentar o limite de quantidade de pessoas, carros, objetos etc. Mas este tem um diferencial: Ele aumenta os limites automaticamente conforme o necessário! Assim evitando a necessidade de configurar arquivos, sempre automati...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/a8lp92fm5jz4/Open_Limit_Adjuster.zip.html)
- [Download / Link](https://sharemods.com/rl25v7qrylbv/Open_Limit_Adjuster_Windows_XP.7z.html)
- [Origem](https://github.com/GTAmodding/III.VC.SA.LimitAdjuster)

### [[SA] Cyber Cafe Interior (lan-house)](https://www.mixmods.com.br/2022/10/sa-cyber-cafe-interior/)
**Data da Publicação:** `2022-10-16`
> Um lindo interior de cyber cafe para GTA San Andreas, ambientado com NPCs!Convertido do GTA IV, mas altamente editado para combinar com a época do GTA San Andreas. Um total de 16 NPCs aleatórios (com base na região, com Ped Spawn Creator) fazendo animações, e a tela dos PCs também são animadas!No mo...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/jvdsgr5n0kf9/SA_-_Cyber_Cafe_Interior.7z.html)

### [[SA/SAMP] GPS Redux v1.5 (mostrar caminho no mapa)](https://www.mixmods.com.br/2022/10/sa-gps-redux/)
**Data da Publicação:** `2022-10-09`
> Atualizado 21/06/25Muitas otimizações.Agora os ícones de missões são ordenados pelo mais próximo, mostrando o caminho do mais próximo.Nova versão do mod de GPS no mapa, para GTA San Andreas.Nesta nova versão, finalmente aparecerá o caminho para os objetivos das missões!O desenho da linha também foi ...
**Links de Referência / Download:**
- [mas gera uns caminhos muito longos](https://github.com/juicermv/GTA-GPS-Redux/issues/8)
- [Download / Link](https://sharemods.com/6gxnkrbws5wr/GPS_Redux.zip.html)
- [Download / Link](https://sharemods.com/7buxh1tvl0ob/GPU_Redux_-_For_SAMP.zip.html)
- [Origem](https://github.com/juicermv/GTA-GPS-Redux)

### [[SA] Proper HD Models (objetos remasterizados)](https://www.mixmods.com.br/2022/10/sa-proper-hd-models/)
**Data da Publicação:** `2022-10-08`
> Atualizado 10/10/22E eu havia esquecido dos arquivos pro hidrante e saco de lixo…Atualizado 09/10/22Eu havia adaptado o modelo do pier para o efeito de vento (para as cordas balançarem), mas upei o arquivo errado. Corrigido.Projeto para remasterizar os modelos e texturas do GTA San Andreas em HD.O o...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/uj564y9f94iy/SA_-_Proper_HD_Models.7z.html)

### [[III/VC/SA] Windowed Mode (modo janela)](https://www.mixmods.com.br/2022/10/iii-vc-sa-windowed-mode/)
**Data da Publicação:** `2022-10-07`
> O melhor mod de jogar em modo janela para GTA San Andreas, Vice City e III.E melhor: o mod corrige outros bugs relacionados com o Windows, mesmo em tela cheia!Você pode redimensionar livremente a janela em qualquer proporção.Ou até mesmo remover toda a borda, deixando somente a tela do jogo.Você ati...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/4qoj2ti1l74c/SA_VC_III_-_Windowed_Mode.zip.html)
- [Origem](https://github.com/ThirteenAG/III.VC.SA.WindowedMode)

### [[SA] Radar Map by wD.D159 (mapa redesenhado)](https://www.mixmods.com.br/2022/10/sa-radar-map-by-wd-d159/)
**Data da Publicação:** `2022-10-06`
> Atualizado 26/02/23Adicionado opção de estilo dark (escuro)! (por algum motivo, nesta não tem marca d’água).Mais melhorias e correções no desenho.Novo desenho HD pro mapa de San Andreas, reimaginado e recolorido, muito bonito!Este é um remake do mod “Radar Redesigned/Recolor“.Este é um dos pouquíssi...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/xhb7m223eofm/Radar_Map_by_wD_D159.7z.html)

### [[SA/SA:DE/Mobile] Cars On Dirt Roads Mod (veículos em estradas)](https://www.mixmods.com.br/2022/09/sa-cars-on-dirt-roads-mod/)
**Data da Publicação:** `2022-09-19`
> Atualizado 21/07/26Se não funcionou pra você, baixe de novo agora.Atualizado 22/09/22Corrigido carros dirigindo no meio da fazenda na saída de LS.Mod CLEO para GTA SA que adiciona NPCs dirigindo em estradas de terra por toda San Andreas.O funcionamento é simples e nada intrusivo. Reativa paths origi...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/8f2odk9nzebs/Cars_On_Dirt_Roads.7z.html)

### [[SA] Visual Path Editor (in-game)](https://www.mixmods.com.br/2022/09/sa-visual-path-editor-in-game/)
**Data da Publicação:** `2022-09-17`
> Os paths/nodes (que indicam as ruas onde carros dirigem, e calçadas onde pessoas andam) até hoje é uma das piores coisas para se criar no GTA San Andreas, pois não existe nenhuma boa ferramenta para isso, por isso é raro mods que adicionam carros e pessoas em novos mapas.Pensando nisso, Lightvelox c...

### [[III|VC|SA] CrashInfo v1.2.1 (mostrar solução de crash)](https://www.mixmods.com.br/2022/09/crashinfo/)
**Data da Publicação:** `2022-09-13`
> Atualizado 30/01/25Adicionado lista em espanhol.Atualizado 13/09/22Adaptado para GTA III e GTA Vice City! Ainda sem documentações, mas em breve começarei a colocar.Adicionado um botão “Force Quit” para fechar o jogo de maneira forçada, e textos melhorados.Um mod que irá revolucionar o modding do GTA...
**Links de Referência / Download:**
- [Lista de Crash](https://github.com/JuniorDjjr/CrashInfo/tree/main/Lists)
- [Download / Link](https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html)

### [[SA] Color Mod by Ryosuke v2 + Fix](https://www.mixmods.com.br/2022/09/sa-color-mod/)
**Data da Publicação:** `2022-09-11`
> Atualizado 11/09/22Atualização não-oficial por sociopart: Compatível com SkyGfx e pode ser instalado no ModLoader. Postagem reescrita.ColorMod é um mod clássico do Ryosuke839 que possibilita fazer ajustes de cor/brilho (postfx) do GTA SA, tudo dentro do jogo de maneira muito amigável.Chroma (saturaç...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/7pj7gxozu63l/Color_Mod_and_Fix.zip.html)

### [[SA] Graphics Tweaker v1.3.1 (melhorar gráficos)](https://www.mixmods.com.br/2022/09/graphicstweaker/)
**Data da Publicação:** `2022-09-04`
> Atualizado 06/08/24Melhorado TweakDynamicInteriorAmbientLighting: Agora não deixa pessoas escuras em alguns interiores.GraphicsTweaker é um mod ASI para melhorar os gráficos no GTA San Andreas, criado com a intenção de não ser intrusivo ao jogo, sendo compatível com outros mods gráficos.“Oh, deve se...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/6xafx05pnj6v/GraphicsTweaker.7z.html)
- [Source code](https://github.com/JuniorDjjr/GraphicsTweaker)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)

### [[SA] Z Menu (mod trainer)](https://www.mixmods.com.br/2022/08/z-menu-trainer/)
**Data da Publicação:** `2022-08-31`
> Um dos melhores cheat/trainer menus para GTA SA contendo algumas funcionalidades que nenhum ou poucos têm.Por exemplo, assistir qualquer cutscene, editar handling e configurações de armas e carros em tempo real, iniciar guerra de gangues, executar qualquer opcode (para usuários avançados), trocar to...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1euifjsacuwu/SA_-_Z_Menu.7z.html)

### [[SA] Throw Rotate Fix v2.0 (molotov/granada rodando no ar)](https://www.mixmods.com.br/2022/08/throw-rotate-fix-molotov-granada-rodando-no-ar/)
**Data da Publicação:** `2022-08-28`
> Atualizado 28/08/22Mod de 2017 agora recriado do zero usando CLEO+: mais otimização, e cada objeto irá girar de forma diferente, mesmo que existam ao mesmo tempo.Com este fix, granadas e molotovs irá girar/rotacionar no ar quando arremessados.A rotação é aleatória e bem natural, há não motivos de nã...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/4bgzyt2gtpj2/SA_-_Throw_Rotate_Fix.7z.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/739c34a81d8e3c80da248491df3fa86d)

### [[SA] Revamped Vehicles Project (carros corrigidos e adaptados)](https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/)
**Data da Publicação:** `2022-08-18`
> Depois de tantos anos, finalmente um projeto com o objetivo de corrigir e melhorar “definitivamente” os veículos originais do GTA San Andreas.Além centenas de correções de bugs originais do jogo (mesmo os mais pequenos), inclui adaptação para ImVehFt e VehFuncs! E também rodas mais redondas. Assim s...

### [[III/VC/SA] Framerate Vigilante (corrigir bugs de FPS alto)](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/)
**Data da Publicação:** `2022-08-14`
> Português English Updated 01/10/26 (DD/MM/YY)Corrigido [SA]: Removido um ajuste de força que não devia ter sido feito, no balanço de componentes dos carros.Melhorado [SA]: Ajustado a correção de nado para ficar mais correto mesmo em centenas de FPS. Também aplicado a correção para o efeito de partíc...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html)
- [Source code](https://github.com/GTAmodding/FramerateVigilante)

### [[SA] Peds Extender v1.1.5 (corrigir, restaurar e variar pedestres)](https://www.mixmods.com.br/2022/08/peds-extender/)
**Data da Publicação:** `2022-08-13`
> Atualizado 21/12/24Corrigido crash ao adicionar policiais com IDs altos.Atualizado 15/09/22 07:20Agora a correção de motorista de trem também funciona em trens adicionados sem substituir.Atualizado 27/08/22 17:10Restaurado o “poolguy” mas requer usar o nome “poolgy2” (agora atualizado no “Restored U...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html)
- [Código fonte](https://github.com/JuniorDjjr/PedsExtender)

### [[SA] Destructive Rhino Mod (explodir tanques)](https://www.mixmods.com.br/2022/08/sa-destructive-rhino-mod/)
**Data da Publicação:** `2022-08-05`
> Mod CLEO para destruir tanques de guerra usando explosões, como granada, bazuca, lança-mísseis), atirar com canhão de outro tanque etc.Isto é considerado uma correção pro jogo, pois provavelmente a Rockstar deixou eles à prova de explosões porque eles explodem os carros que tocam, portanto, eu criei...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/a4lbda6sgq5v/Destructive_Rhino_Mod.7z.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/3e40a133129b1815009ad513c63e8c2b)

### [[SA] PedSkills v2.2 (aumentar dificuldade)](https://www.mixmods.com.br/2022/08/pedskills/)
**Data da Publicação:** `2022-08-01`
> Atualizado 01/08/22Adicionado PlayerVehMissionDamMult: Ajusta o dano que o veículo de missão do player recebe. Ajuda a facilitar missões como “Just Business” e “Drive By”. Duplica caso não seja o motorista.Adicionado AccuracyOnJetpackFactor: Dificulta acertar o player caso ele esteja num jetpack. Aj...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2xibsxei9gan/PedSkills.7z.html)
- [Source code](https://github.com/JuniorDjjr/PedSkills)

### [Real Linear Graphics v2.6 (cores realistas)](https://www.mixmods.com.br/2022/07/real-linear-graphics/)
**Data da Publicação:** `2022-07-22`
> Atualizado v2.6 22/08/22Corrigido o clima nublado causando cortes no oceano fora, ao ver de longe com Project2DFX, e agora haverá um sol fraco.Atualizado v2.5 22/07/22Corrigido a luz do Sol ainda visível embaixo d’água no final da tarde.Agora não há sol em climas nublados e de chuva.Atualizado v2.4 ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dhjea67wrhm1/Real_Linear_Graphics.7z.html)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)

### [[SA/SADE/Mobile] Remove Brass Knuckles (desativar soco-inglês)](https://www.mixmods.com.br/2022/07/remove-brass-knuckles/)
**Data da Publicação:** `2022-07-16`
> Mod que remove completamente o soco-inglês do GTA San Andreas, a arma mais odiada de todas! É a segunda coisa mais perguntada no Google quando pesquisa por ela.O grande problema é que substitui a mão quando desarmado, assim ficando com algo feio na sua mão o tempo todo, e caso você tenha as namorada...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/w1gml4nqvlo8/Remove_Brass_Knucles.7z.html)

### [[SA/SA:DE] Proper Radar v1.3 (mapa em HD corrigido)](https://www.mixmods.com.br/2022/07/proper-radar/)
**Data da Publicação:** `2022-07-14`
> Atualizado 14/07/22Mais várias pequenas correções, e foi removido as bordas finas por volta da água.Liberado o projeto fonte! Assim qualquer pessoa pode ajudar ou criar novas opções de cores.Atualizado 25/04/22Ainda havia muita coisa para melhorar, mas agora eu espero que seja a versão final (por en...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/eenyrp1bklvj/Proper_Radar.7z.html)
- [Download / Link](https://sharemods.com/xskii1j30e2p/SADE_-_Proper_Radar.7z.html)
- [Download / Link](https://sharemods.com/8cxnu0k4xtdu/Proper_Radar_-_Source_Project.7z.html)

### [[SA] Body Stats Fix in Interiors (corrigir corpo sem mudar)](https://www.mixmods.com.br/2022/07/sa-body-stats-fix-in-interiors/)
**Data da Publicação:** `2022-07-11`
> Simples mod CLEO que corrige o corpo do CJ não mudando logo após ficar musculoso ou gordo.﻿O corpo atualizava somente após entrar ou sair de um interior. Ainda na época do PS2 eu já havia notado e ficado frustrado com isso, e finalmente agora existe uma correção.Em teoria, também funciona no GTA SA ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/a3tl94dgrzrb/Body_Stats_Fix.7z.html)

### [[SA] PedFuncs v0.5.1](https://www.mixmods.com.br/2022/07/pedfuncs/)
**Data da Publicação:** `2022-07-07`
> Atualizado 15/09/22Corrigido os “peds*.txd” não funcionando para o pedestre “MALE01” e policiais, assim corrigindo mods como GTA Trilogy Peds Pack.Atualizado 07/07/22Agora é possível usar arquivos “peds1.txd” até “peds5.txd” para texturas genéricas compartilhadas entre todos os peds, por exemplo olh...
**Links de Referência / Download:**
- [Variações de texturas (remap)](https://github.com/JuniorDjjr/PedFuncs/wiki/%5BPT%5D-Varia%C3%A7%C3%B5es-de-texturas-(remap))
- [aqui](https://github.com/JuniorDjjr/PedFuncs/wiki)
- [Download / Link](https://sharemods.com/fkum0x0mhyu6/PedFuncs.7z.html)
- [Source code](https://github.com/JuniorDjjr/PedFuncs)

### [[SA/SA:DE] Torch Mod (tocha com luz)](https://www.mixmods.com.br/2022/06/sa-sade-torch-mod-tocha-com-luz/)
**Data da Publicação:** `2022-06-27`
> Mod de tocha com luz funcional, para ambos: GTA SA The Definitive Edition e clássico.No GTA SA:DE, devido à engine moderna, usa luz per-pixel, que de fato ilumina o ambiente.No GTA SA clássico, eu criei um pequeno script que simula iluminação, um resultado também muito legal e compatível com 2 jogad...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/pknk1m9jkooc/SADE_-_Torch_Mod.7z.html)
- [Download / Link](https://sharemods.com/nuioeuncz8zd/SA_-_Torch_Mod.7z.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/53b70bba5213cb7e988a18a11313f7d2)

### [Death In Car (morrer dentro do carro)](https://www.mixmods.com.br/2022/06/death-in-car-morrer-dentro-do-carro/)
**Data da Publicação:** `2022-06-20`
> Atualizado 20/06/22 05:15A nova versão do CLEO+ corrigiu um bug do jogo onde não detectava que uma pessoa estava morta em alguns casos, como dentro do carro, e este mod usava esse bug para não fazer a pessoa não “re-morrer”. Então eu atualizei este mod corrigindo o problema. Caso haja outros mods ou...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2289owg3jx0m/Death_In_Car.7z.html)

### [[SA] Gang Hands Texture Fix (corrigir mãos bugadas)](https://www.mixmods.com.br/2022/06/sa-gang-hands-texture-fix/)
**Data da Publicação:** `2022-06-08`
> Atenção:Já está incluso no PedFuncs v0.5 ou mais novo!Mod que corrige um bug de textura errada nas mãos quando membros de gangue fazem sinais.Isto acontece normalmente em mods de skins HD mal adaptados, porque o jogo procura por uma textura de mesmo nome do “.dff”, e caso não encontrar, usa a primei...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1u3i9l2uo4ao/Gang_Hands_Texture_Fix.7z.html)

### [[SA/SA:DE/Mobile] SFDP Heli Fix (helicóptero da polícia de SF)](https://www.mixmods.com.br/2022/06/sa-sfdp-heli-fix/)
**Data da Publicação:** `2022-06-07`
> Pequeno mod CLEO que corrige o helicóptero errado na delegacia de polícia de San Fierro.Originalmente o GTA SA erroneamente usou o Maverick (civil) em vez da variação (“polmav”). Diferente da versão anteriormente postada aqui, esta é compatível com fastman92 limit adjuster (antes o mod causava crash...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s4l7mw43heuk/SFDP_Heli_Fix.7z.html)

### [[SA] Proper Night Windows (mais janelas noturnas)](https://www.mixmods.com.br/2022/06/proper-night-windows/)
**Data da Publicação:** `2022-06-05`
> Mod que adiciona mais janelas acesas aos prédios do GTA SA.Há 4 anos atrás foi criado o mod IWNL, era mal feito e exagerado, mas faz sucesso até hoje com muita gente usando no mobile etc. Portanto eu decidi recriar.No momento somente adiciona mais janelas acesas em 1 prédio de Los Santos, provavelme...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/q2gr7fu98fml/Proper_Night_Windows.7z.html)

### [[SA/SA:DE] Skateboarding Mod (mod de skate)](https://www.mixmods.com.br/2022/06/skateboarding-mod-mod-de-skate-para-gta-sa/)
**Data da Publicação:** `2022-06-04`
> Atualizado 04/06/22 09:35Portado para o GTA SA The Definitive Edition!O motivo de eu nunca ter postado um mod de andar de skate aqui no blog antes era de que eu não sabia qual era o melhor.Mas agora sim: o melhor mod de skate para GTA SA que existe.Mod originalmente criado por Linevariy e melhorado ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/33090codslex/Skate_Mod.7z.html)
- [Download / Link](https://sharemods.com/icmqku1s5twm/SADE_-_Skateboarding_Mod.7z.html)
- [Download / Link](https://drive.google.com/file/d/1xiLRUuRpGwwCVaxiwmBbPprASTrtjtOo/view?usp=sharing)

### [[SA] No Auto Pickups (coletar armas manualmente)](https://www.mixmods.com.br/2022/05/no-auto-pickups/)
**Data da Publicação:** `2022-05-13`
> Mod que desativa os pickups de armas sendo coletados automaticamente. Agora você precisará apertar o botão para pegar uma nova arma, igual quando pega uma arma diferente de mesmo tipo.Afinal, quantas vezes você já pegou uma arma que você não queria? Principalmente soco-inglês. Lembrando que há també...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/vmhimyh5mm0k/No_Auto_Pickups.7z.html)
- [Código fonte](https://github.com/JuniorDjjr/NoAutoPickups)

### [[SA] Missing Smokes Fix (fumaça na tubulação das fábricas)](https://www.mixmods.com.br/2022/05/missing-smokes-fix/)
**Data da Publicação:** `2022-05-08`
> Atualizado 29/08/22Disseram nos comentários que o crash ao reiniciar ainda acontecia com Project2DFX, eu instalei e de fato aconteceu, e mesmo removendo, continuou. Eu tentei muito e acontece mesmo com um objeto original do jogo, já é o quarto dia, então desisti. Deixei um aviso até que uma solução ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/0ff3q5jkuabp/Missing_Smokes_Fix.7z.html)

### [[SA] Manual Firing v2.2.1 (tiros manuais)](https://www.mixmods.com.br/2022/05/manual-firing-tiros-manuais/)
**Data da Publicação:** `2022-05-04`
> Atualizado 26/05/22Ainda não havia sido corrigido para uzis, agora sim.Atualizado 24/05/22Corrigido o tiro manual se ativando na habilidade baixa das uzis e sawnoff, e SPAS-12.Atualizado 04/05/22Mod recriado do zero, agora com melhor script usando funções do CLEO+.Compatível com armas adicionadas se...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/u2fwrrrj6hvn/Manual_Firing.7z.html)
- [Código fonte](https://gist.github.com/JuniorDjjr/9f15f2042e92c50194b3695c06d58bc9)

### [[SA] Map Editor (editar mapa dentro do jogo com mouse)](https://www.mixmods.com.br/2022/04/sa-map-editor/)
**Data da Publicação:** `2022-04-30`
> O mais novo editor de mapa in-game (durante o jogo), que usa interface gráfica com mouse!Se assemelha ao editor de mapa do MTA:SA, com até mesmo um menu de pesquisa e visualização prévia dos modelos. Tudo através de um mod .asi pro singleplayer! Note que ele também não edita os objetos originais do ...
**Links de Referência / Download:**
- [Download / Link](https://github.com/user-grinch/Map-Editor/releases)

### [[SA] Prostitutes Money Drop Fix (corrigir dinheiro de prostitutas)](https://www.mixmods.com.br/2022/04/prostitutes-money-drop-fix/)
**Data da Publicação:** `2022-04-28`
> Mod que corrige a quantidade de dinheiro que prostitutas dropam após sair com elas, ou seja, o dinheiro que elas têm inclui o dinheiro que você pagou pra elas (ou cobrou, com o cheat delas pagarem).Existia um mod desse, mas era em Lua, eu fiz em CLEO usando funcionalidades do jogo, com menos gambiar...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/0l8a752l17ui/Prostitutes_Money_Drop_Fix.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/74abeda99982046898b1a0ad5c75c033)

### [[SA] No Minimap In Interiors (desativar mapa em interiores)](https://www.mixmods.com.br/2022/04/no-minimap-in-interiors/)
**Data da Publicação:** `2022-04-27`
> Um simples mod CLEO para PC e Android/iOS para desativar o minimapa/radar dentro de interiores.— safe-house corrigida do Proper Fixes —Afinal, era inútil, a única coisa que mostrava era a direção norte (que quase sempre não faz sentido com fora da casa), tanto que isto já foi removido no GTA SA The ...

### [[SA] NextGen Remaster Effects (efeitos realistas HD)](https://www.mixmods.com.br/2022/04/sa-nextgen-remaster-effects/)
**Data da Publicação:** `2022-04-22`
> Atualizado 28/10/22 09:55Atualizado para a nova versão do FxsFuncs (veja o post), agora as cápsulas de bala e estilhaços de madeira caem com física.O mais novo grande mod de efeitos especiais realistas em HD para GTA San Andreas!Criado por Ezekiel com meus auxílios (Junior_Djjr), este mod é muito ma...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/l0oi1e2w49d1/SA_-_NextGen_Remaster_Effects.7z.html)

### [[VC/SA] Real Traffic Fix v2.2.1 beta](https://www.mixmods.com.br/2022/04/real-traffic-fix/)
**Data da Publicação:** `2022-04-19`
> Atualizado 11/03/24SA: Adicionado “Ext_TogglePlayerAutoDrive” para scripts externos poderem aplicar correção de IA inclusive para o player dirigindo. Útil para scripts de auto-drive.RTF é um mod .asi que realmente corrige a inteligência artificial do trânsito do GTA San Andreas e GTA Vice City.Força...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/jlqyc2ya7lol/SA_-_Real_Traffic_Fix.7z.html)
- [Download / Link](https://sharemods.com/pxi03srhvive/VC_-_Real_Traffic_Fix.7z.html)
- [Source code](https://github.com/JuniorDjjr/real-traffic-fix)

### [[SA] Missing Lampposts Fix (mais postes de luz)](https://www.mixmods.com.br/2022/04/missing-lampposts-fix-more-light-posts/)
**Data da Publicação:** `2022-04-17`
> Mod que adiciona mais de 300 postes de luz faltando por toda San Andreas.A Rockstar havia adicionado os postes, gerou a luz no prelight e depois os removeu (provavelmente porque eram obstáculos para o gameplay).Portanto, diferente de outros mods do tipo, eu usei esses pontos de luz para re-adicionar...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html)

### [[SA/SA:DE] Proper Vehicles Retex v2.1 (texturas HD para veículos)](https://www.mixmods.com.br/2022/04/sa-sade-proper-vehicles-retex/)
**Data da Publicação:** `2022-04-10`
> Atualizado 10/04/22Uma grande atualização para ambos, GTA SA clássico e The Definitive Edition!Criado as texturas dos carros que faltavam em 2K.Refeito todas as propagandas de marca (Benson, Yankee etc), dessa vez baseado nas originais.Corrigida escala exagerada em algumas portas.Corrigido bug no in...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html)
- [Download / Link](https://sharemods.com/28ypvnxc3daa/Proper_Vehicles_Retex_v2.1_1024x_VERSION.7z.html)
- [Download / Link](https://sharemods.com/xd5lex6v5pme/Proper_Vehicles_Retex_v2.1_2K_VERSION.7z.html)
- [Download / Link](https://sharemods.com/3ullpauu22ab/SADE_-_Proper_Vehicles_Retex-V2.1.7z.html)

### [[SA] GTA V Vehicles to SA by _F_ (carros convertidos do GTA V)](https://www.mixmods.com.br/2022/04/sa-gta-v-vehicles-converted/)
**Data da Publicação:** `2022-04-03`
> Um incrível pack de mais de 100 veículos convertidos do GTA V para GTA San Andreas pelo _F_.Não só converte os modelos, mas também as funcionalidades, como luzes, tuning, variações extras etc! Como o próprio autor diz, ele não está feliz com o resultado de outros mods de veículos, pois sempre têm pr...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1PUR5J0BexJI2lXtATiu68U86EXkNM7tC/view?usp=sharing)

### [[SA] Project Web Anims v7.5 (pack de animações)](https://www.mixmods.com.br/2022/04/sa-project-web-anims/)
**Data da Publicação:** `2022-04-02`
> Atualizado 02/04/22Atualizado pra nova versão! Muita coisa mudou e foi melhorada, novas animações melhores, adicionado novos mods em conjunto etc. Veja o novo vídeo do autor.Sempre há uma busca por bons mods de animações. A maioria das pessoas não estão felizes, pois sempre há animações estranhas, r...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/o07xb22y59nf/Project_Web_Anims.7z.html)
- [Download / Link](https://sharemods.com/mbet6rslp0nu/Project_Web_Anims.7z.html)

### [Cheat Menu by Grinch_ v3.52](https://www.mixmods.com.br/2022/03/cheat-menu-by-grinch/)
**Data da Publicação:** `2022-03-31`
> O mais avançado e completo mod de “cheat menu”/”trainer” para GTA San Andreas!Criado em .asi (opção em .lua) utilizando uma interface gráfica com mouse através do ImGui.Este mod faz tudo! Você pode alterar diversas coisas no jogo, além de utilidades para trapaças, testes, ou simplesmente diversão. H...
**Links de Referência / Download:**
- [ImGui](https://github.com/ocornut/imgui)
- [Lista de mods incompatíveis (poucos).](https://github.com/user-grinch/Cheat-Menu#incompatible-mods)
- [Download / Link](https://sharemods.com/iy139fyfuyet/Cheat_Menu_by_Grinch_.zip.html)
- [Download / Link](https://sharemods.com/dvuo7sxezawl/VC_-_Cheat_Menu_by_Grinch_.zip.html)

### [[SA] Projectile Shoot (atirar para explodir)](https://www.mixmods.com.br/2022/03/sa-projectile-shoot-atirar-para-explodir/)
**Data da Publicação:** `2022-03-30`
> Mod que lhe possibilita atirar na satchel charge (carga explosiva) para força-la a explodir.Ao explodir um, os outros próximos também irão explodir de forma recursiva! Note também que com isso, você tem o controle de explodir somente alguns explosivos, em vez de todos ao mesmo tempo.Limitação: O sat...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1rj82p2q33cz/Projectile_Shoot.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/915be607c534b9821d38c51eb0faaf3a)

### [Rules Mod v1.2 (estrela de procurado ao quebrar leis)](https://www.mixmods.com.br/2022/03/rules-mod-estrela-de-procurado-ao-quebrar-leis/)
**Data da Publicação:** `2022-03-21`
> Atualizado 21/03/22Adicionado “receber estrela por dirigir veículos de emergência“, há opção de não se ativar caso o CJ esteja usando uniforme de policial ou skin de ped de emergência, e só é afetado caso houver algum policial próximo de você, olhando em sua direção.Mod anteriormente chamado de “Rul...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/o4fco3bicyin/Rules_Mod.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/731b8641ba4e9688d87402464b2765d2)

### [LS Lit Church (igreja com luzes acesas)](https://www.mixmods.com.br/2022/03/ls-lit-church-igreja-com-luzes-acesas/)
**Data da Publicação:** `2022-03-14`
> Atualizado 14/03/22Texturas recriadas: Agora vem com a textura do GTA SA The Definitive Edition (é um redesenho HD fiel e bem feito), editada para um efeito realista de iluminação de fundo. Há opção da textura original do jogo editada, ou a textura antiga do mod (upscale com bloom falso).Há uma igre...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ilp0t25k29gz/LS_Lit_Church.7z.html)

### [[SA] MixSets v4.3.7](https://www.mixmods.com.br/2022/03/sa-mixsets/)
**Data da Publicação:** `2022-03-10`
> Atualizado 03/05/22 19:50Adicionado NoMinimapOnInteriors: Desativar minimapa/radar dentro de interiores (fora de missão). Eu havia feito este mod em CLEO mas havia problemas, então refiz em .asi que é melhor.Corrigido BrakeReverseFix não funcionando com o modo de controles do GTA IV do GInput.Atuali...
**Links de Referência / Download:**
- [plugin-sdk](https://github.com/DK22Pac/plugin-sdk)
- [Download / Link](https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html)
- [Código fonte](https://github.com/JuniorDjjr/SA-MixSets)

### [Shader Stochastic no GTA San Andreas (correção de tiling nas texturas)](https://www.mixmods.com.br/2022/03/shader-stochastic-gta-sa/)
**Data da Publicação:** `2022-03-01`
> Eu (Junior_Djjr) fiz algo que eu mesmo dizia ser impossível: eu corrigi o padrão de repetição de texturas do GTA San Andreas!Você deve estar se perguntando qual “gambiarra” foi usada, mas na verdade a solução é excelente e substitui nada do seu jogo, através de uma técnica de shader chamada de “proc...
**Links de Referência / Download:**
- [paper de Thomas Deliot e Eric Heitz publicado em 2019](https://drive.google.com/file/d/1QecekuuyWgw68HU9tg6ENfrCTCVIjm6l/view)
- [projeto SkyGfx (que é open source)](https://github.com/aap/skygfx)

### [[SA] Sprint Everywhere (correr em interiores)](https://www.mixmods.com.br/2022/02/sa-sprint-everywhere-correr-em-interiores/)
**Data da Publicação:** `2022-02-28`
> Mod .asi que remove uma limitação do GTA SA: agora o CJ consegue correr dentro de interiores.A Rockstar fez isto de uma péssima maneira, pois diferentes tipos de chão fazem você conseguir ou não correr (por exemplo dentro do Four Dragons Casino). Este mod deixa o gameplay mais agradável e previsível...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/z6yo02u4xvaf/Sprint_Everywhere.7z.html)

### [[SA] Glasses Color Overlay (filtro de cor ao usar óculos)](https://www.mixmods.com.br/2022/02/sa-glasses-color-overlay/)
**Data da Publicação:** `2022-02-25`
> Mod que muda a cor da tela ao usar algum óculos colorido ou escuro.Há configurações de intensidade e opção de ativar somente em câmera primeira pessoa no arquivo .ini (como funciona no GTA V).A opção de ativar somente durante câmera em primeira pessoa funciona com qualquer mod de câmera FPS, como Fi...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/o74eq9y76hjj/Glasses_Color_Overlay.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/8a86396a7a4d819eb421e624374c182d)

### [[SA] nadalao Weapon Icons (ícones HD fiéis corrigidos)](https://www.mixmods.com.br/2022/02/icones-de-armas-fieis-desenhos-corrigidos/)
**Data da Publicação:** `2022-02-16`
> Atualizado 16/02/22Download atualizado com os últimos ícones (taco e para-quedas).Corrigido alguns ícones com linhas brancas nos cantos.Adaptado ao mod “Weapon Icons TXD“, assim você não precisa substituir suas armas para instalar os ícones! O .txd inclui ícones HD do mobile e mira de câmera e snipe...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/tysasyrhqebt/nadalao_Weapon_Icons_-_icones_fieis_corrigidos.7z.html)

### [MW Project (mais água por SA)](https://www.mixmods.com.br/2022/02/mw-project-mais-agua-por-sa/)
**Data da Publicação:** `2022-02-15`
> Atualizado 15/02/22 21:02O link de download não havia mudado, corrigido.Atualizado 15/02/22Adicionado uma opção “Lite”: somente águas rasas (como piscinas), não adiciona água no canal de LS, menos intrusivo ao jogo (substitui poucos arquivos), compatível com outros mods de mapa (como Proper Fixes), ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/l01yekk929dh/MW_Project.7z.html)

### [[SA] Animation Fix + M4k3 Anims (corrigir bugs de animações)](https://www.mixmods.com.br/2022/02/animation-fix-v1-5-corrigir-bugs-de-animacoes/)
**Data da Publicação:** `2022-02-13`
> Atualizado 13/02/22Adicionado opção que inclui o mod M4k3’s Car Animations! Muda mais de 70 animações de veículos do GTA SA, corrigindo posicionamentos, bugs e erros de lógica.Mod que corrige vários bugs das animações das pessoas do GTA San Andreas.Diferente dos pequenos mods, como Wayfarer.ifp Fix ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/3xputk50vuec/Animation_Fix___M4k3_New_Car_Animations.7z.html)

### [[SA/SA:DE] Ped Run Fix v2.2 (corrigir velhinhas correndo)](https://www.mixmods.com.br/2022/01/sa-sade-ped-run-fix-corrigir-velhinhas-correndo/)
**Data da Publicação:** `2022-01-22`
> Atualizado 22/01/22Repostado com novo nome.Removido a animação de andar com sacola do GTA VC (leftover), eu adicionei como variação, mas ficou estranho.Adaptado ao GTA SA:DE.Mod que corrige as velhinhas do GTA SA (e SA:DE) correndo rápido, agora elas terão dificuldades ao correr.Para ilustrar, Heric...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/c08l1q6s8kxy/SA_SADE_-_Peds_Run_Fix.7z.html)

### [Custom Ammunation Mod v3.5 (adicionar armas pra comprar)](https://www.mixmods.com.br/2022/01/custom-ammunation-mod-adicionar-armas-pra-comprar/)
**Data da Publicação:** `2022-01-08`
> Finalmente foi criado um mod que as pessoas pedem há muitos anos!Adicionar mais armas para o menu da loja Ammu-nation.Assim, você pode adicionar armas sem substituir no seu jogo, e deixá-las à venda na Ammu-nation, ou simplesmente poder comprar mais armas originais, como minigun e RPG.Devido aos lim...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/mods/169525-custom-ammunation/)

### [LOD Vegetation v1.2 (árvores distantes)](https://www.mixmods.com.br/2021/12/lod-vegetation-distant-trees/)
**Data da Publicação:** `2021-12-11`
> Atualizado 11/12/21Aumentado a distância de visão, assim as árvores ainda serão visíveis mesmo se você aumentar a distância padrão do Project2DFX enquanto no chão. As árvores maiores são mais distantes do que as menores (por otimização). Se a distância de visão do seu jogo é baixa, o jogo ignorará a...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html)

### [CLEO Redux](https://www.mixmods.com.br/2021/12/cleo-redux/)
**Data da Publicação:** `2021-12-09`
> CLEO Redux é uma re-implementação da CLEO reescrita do zero. O projeto é liderado pelo Seemann, o criador da CLEO antiga! Portanto é confiável.Jogos compatíveis:GTA IIIGTA Vice CityGTA San Andreasre3reVCGTA III The Definitive EditionGTA Vice City The Definitive EditionGTA San Andreas The Definitive ...
**Links de Referência / Download:**
- [poucos opcodes da CLEO](https://github.com/cleolibrary/CLEO-Redux#compatibility-with-the-trilogy-the-definitive-edition)
- [veja instruções aqui](https://github.com/cleolibrary/CLEO-Redux#javascript-support)
- [(github contribuitors)](https://github.com/cleolibrary/CLEO-Redux/graphs/contributors)
- [Download / Link](https://github.com/cleolibrary/CLEO-Redux/releases)

### [[SA/SA:DE] Awesome IFP v3 (novas animações)](https://www.mixmods.com.br/2021/11/sa-sade-awesome-ifp/)
**Data da Publicação:** `2021-11-12`
> Atualizado 12/11/21Adicionado versão para GTA SA The Definitive Edition.Download reorganizado.Foi um dos poucos mods de animações que gostei, ao meio de tantos mods de animações estilo GTA IV, este tem um diferencial.As animações não são exageradamente diferentes das do GTA SA, parecem na verdade “m...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/47465yc6kq12/Awesome_IFP.7z.html)
- [Download / Link](https://sharemods.com/5c1yvuq4l5x4/SADE_-_Awesome_IFP.7z.html)

### [MP5 (convertida do SA:DE)](https://www.mixmods.com.br/2021/11/mp5-convertida-do-sade/)
**Data da Publicação:** `2021-11-11`
> Um dos primeiros mods para GTA SA clássico convertido do GTA San Andreas The Definitive Edition (GTA Trilogy)! A arma MP5 (uma das únicas realmente boas). É uma conversão direta, exatamente a mesma posição, texturas e normal maps. Recomendado Normal Map by DK. Modelo: Grove Street Games (GTA SA DE) ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s13yawvkfnwn/SADE_MP5.7z.html)

### [Tesla Model S 2014 (fix + script)](https://www.mixmods.com.br/2021/11/tesla-model-s-2014-fix-script/)
**Data da Publicação:** `2021-11-07`
> Atualizado 07/11/21 10:57Corrigido a lanterna acesa sempre mesmo de dia.Corrigido o nome (eu havia colocado “Model 3”).Já faz muito tempo que eu não trago um carro aqui, mas agora é especial…Se trata de um Tesla Model S ano 2014 que, diferente das outras opções na internet, este funciona de fato com...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/i8pyupgkl3ia/Tesla_Model_S_2014.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/71689-2014-tesla-model-s/)

### [Illuminated Vinewood Sign (placa de Vinewood iluminada)](https://www.mixmods.com.br/2021/10/illuminated-vinewood-sign-placa-de-vinewood-iluminada/)
**Data da Publicação:** `2021-10-24`
> Atualizado 24/05/22Instalação melhor adaptada para mobile (já funcionava antes sem conversão mas deixei mais didático).Atualizado 24/10/21Agora com a chegada no GTA SA The Definitive Edition, as pessoas gostaram das luzes nas placas de Vinewood, portanto estou revivendo este mod de 2016 para quem nã...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/uelr5g9m1eff/Illuminated_Vinewood_Sign.7z.html)

### [Pre-lighting Fixes Pack (correções de iluminação)](https://www.mixmods.com.br/2021/10/pre-lighting-fixes-pack-correcoes-de-iluminacao/)
**Data da Publicação:** `2021-10-15`
> Atenção: Este mod já está incluído no Proper Fixes!Nele, você tem estas e literalmente MILHARES de outras correções!Já passou da hora de termos uma boa coleção de correções para os bugs de iluminação/brilho dos objetos do mapa do GTA SA.371 arquivos .dffBasicamente, 371 correções.Centenas de correçõ...
**Links de Referência / Download:**
- [abaixar a prioridade da pasta deste mod no modloader](https://www.mixmods.com.br/2015/07/tutorial-dicas-tudo-sobre-mod-loader.html#Priority)
- [Download / Link](https://sharemods.com/z2uh6naoyg1i/Pre-lighting_Fixes_Pack.7z.html)

### [Upgraded Vehicles Pack (carros originais corrigidos)](https://www.mixmods.com.br/2021/10/upgraded-vehicles-pack-carros-originais-corrigidos/)
**Data da Publicação:** `2021-10-04`
> Atenção:Este projeto mudou e agora é Revamped Vehicles Pack!UVP é o mais novo mod que corrige os bugs dos carros originais do GTA San Andreas!Neste, além de corrigir centenas de erros, foca em adicionar reflexos/cromados onde falta.Só o atual change log (1.8) do projeto já tem mais de 100 itens!Tamb...
**Links de Referência / Download:**
- [Github](https://github.com/)
- [Download / Link](https://sharemods.com/4s905tmgiphk/Upgraded_Vehicles_Pack.7z.html)

### [RenderHook Fix (correções para o RH)](https://www.mixmods.com.br/2021/10/renderhook-fix-correcoes-para-o-rh/)
**Data da Publicação:** `2021-10-03`
> RenderHookFix.SA.asi é um mod que eu (Junior_Djjr) fiz para corrigir problemas do mod RenderHook, pois o projeto está muito parado.— imagem do RenderHook – Serendipity preset —Corrigido incompatibilidade com “DrawDistanceChanger” do Project2DFX.Corrigido os limites “VisibleEntityPtrs” e “VisibleLodP...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dgcbm6ixj1pl/RenderHookFix.7z.html)
- [Source code](https://github.com/JuniorDjjr/RenderHookFix)

### [GTA Healer (check & backup)](https://www.mixmods.com.br/2021/10/gta-healer-check-backup/)
**Data da Publicação:** `2021-10-01`
> Uma ferramenta que verifica a integridade dos arquivos do seu GTA, para identificar arquivos alterados, e recuperá-lo (backup) automaticamente fazendo download dos arquivos necessários.— referência —São 3 ferramentas diferentes:Hash Checker — Verifica a integridade e mostra quais arquivos originais ...
**Links de Referência / Download:**
- [baixar a pasta audio aqui](https://www.mixmods.com.br/2012/07/pasta-audio-para-gta-sa-rip.html)
- [MD5_tool](https://github.com/Smithsonian/MD5_tool/)
- [md5.bat](https://github.com/npocmaka/batch.scripts/blob/master/fileUtils/md5.bat)
- [Download / Link](https://sharemods.com/q2pnidt84vet/GTA_Healer.7z.html)

### [RenderHook – Serendipity v1.1 (gráficos remasterizados em HD)](https://www.mixmods.com.br/2021/09/renderhook-serendipity-graficos-remasterizados-em-hd/)
**Data da Publicação:** `2021-09-30`
> Um dos melhores presets de gráficos HD para RenderHook da atualidade (2021).Mas este não é um preset qualquer, é praticamente uma atualização não-oficial do RenderHook feita pelo autor do CloudWorks!O resultado visual é incrível, ele corrigiu e melhorou todo o visual do RenderHook, agora de fato se ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/y6emrqj5rvbo/RenderHook_-_Serendipity.7z.html)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)

### [[SA] Effects Mod by Ezekiel / Junior_Djjr (efeitos realistas)](https://www.mixmods.com.br/2021/09/effects-mod-by-ezekiel-junior_djjr-efeitos-realistas/)
**Data da Publicação:** `2021-09-28`
> Nova versão lançada!O mod foi totalmente reformado.[SA] NextGen Remaster Effects (efeitos realistas HD)Atualizado 28/10/22 10:26Atualizado para a nova versão do FxsFuncs (veja o post), agora as cápsulas de bala e estilhaços de madeira caem com física.Atualizado 06/06/22 17:10Atualizado para a nova v...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2m9bwht7zw96/Effects_Mod_-_by_Ezekiel_-_Junior_Djjr.7z.html)
- [Download / Link](https://drive.google.com/file/d/10spWLp19GQeW-uWvrcEj_9-XbKNb0wHa/view?usp=sharing)
- [Download / Link](https://sharemods.com/uc2ujtl8z75p/Effects_Mod_-_by_Ezekiel_-_Junior_Djjr_-_Effects_Loader.7z.html)

### [CloudWorks (volumetric clouds for ENB/RenderHook)](https://www.mixmods.com.br/2021/09/cloudworks-volumetric-clouds-for-enb-renderhook/)
**Data da Publicação:** `2021-09-23`
> Atualizado 23/09/21Lançado versão para Renderhook!Adicionado nova versão que substitui outro arquivo da ENB, onde as nuvens não são influenciadas pela correção/filtro de cor do jogo. Dependente do seu caso, é útil ou não, portanto eu deixei as duas opções para download.Um trabalho impressionante!Nuv...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/cz2vbf9kc9a2/ENB_Series_CloudWorks.7z.html)
- [Download / Link](https://sharemods.com/ht103j85mncm/CloudWorks_For_RenderHook.7z.html)

### [Clipboard Teleport (teletransporte com CTRL+V)](https://www.mixmods.com.br/2021/09/clipboard-teleport-teletransporte-com-ctrlv/)
**Data da Publicação:** `2021-09-10`
> Um simples mod CLEO que você pode teleportar para uma posição específica simplesmente “colando” (CTRL+V) os números da coordenada durante o jogo. Você também pode copiar com CTRL+C (as teclas são configuráveis).Ou seja, você pode criar um ponto de volta, copiando (CTRL+C), e quando quiser voltar pra...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1c6sk6faws7z/Clipboard_Teleport.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/e5190853c492a99eee1f4a268aa39360)

### [Mod Ragdoll Bullet Physics + Fix (física realista)](https://www.mixmods.com.br/2021/09/mod-ragdoll-bullet-physics-fix-fisica-realista/)
**Data da Publicação:** `2021-09-08`
> Atualizado 08/09/21Correção não-oficial feita por sociopart: Agora é automaticamente adaptado ao Compact EXE (sem a necessidade de trocar arquivos), se desativa automaticamente no SAMP, e compatível para instalar o .ini dentro do ModLoader!Adicionei uma opção de configuração própria minha que deixa ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/txlr846ungla/Ragdoll_Bullet_Physics.zip.html)

### [[SA] ImprovedMove v0.2.2 (melhorar movimentos e anims)](https://www.mixmods.com.br/2021/08/improvedmove/)
**Data da Publicação:** `2021-08-24`
> Atualizado 25/11/24 Agora o blend padrão é 1.0 e os blends de andar e correr são ignorados durante cinemáticas de gameplay. Isto deve corrigir vários bugs deixando o mod mais estável.Também foi ajustado alguns outros valores de blends, e agachamento um pouco mais rápido.Um projeto que pretende melho...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/98xo43wqfjlm/ImprovedMove.7z.html)
- [Source code](https://github.com/JuniorDjjr/ImprovedMove)

### [FireType v6.0 (tiro seletivo: auto, semi, burst)](https://www.mixmods.com.br/2021/08/firetype-v6-0-tiro-seletivo-auto-semi-burst/)
**Data da Publicação:** `2021-08-06`
> Atualizado 06/08/21Melhorado o código para suportar uma quantidade dinâmica de armas configuradas, e agora cada arma pode ter cada modo de tiro ativado ou desativado separadamente (por .ini). Um simples mod CLEO onde você troca o modo de tiro das armas, entre “auto” (automática), “semi” (semi-automá...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/6ljnksq0hmrq/FireType.7z.html)
- [Download / Link](https://sharemods.com/y900dwixtnwf/FireType_-_Basic_version.7z.html)

### [Mipmapping](https://www.mixmods.com.br/2021/07/mipmapping/)
**Data da Publicação:** `2021-07-21`
> Atualizado 21/07/21Adicionado o arquivo dos arquivo .img do GTA SA já com mipmaps aplicados, para não ser necessário seguir o tutorial.Mipmaps é como um anti-aliasing para texturas, que além de deixar o gráfico mais bonito e agradável, pode até aumentar o FPS do jogo diminuindo o uso da placa de víd...
**Links de Referência / Download:**
- [Clique aqui](https://en.wikipedia.org/wiki/Mipmap)
- [Download / Link](https://drive.google.com/file/d/1KcMiIBNyF7Z-hND1f8G4K3aRUzg6A7se/view?usp=sharing)
- [Download / Link](https://sharemods.com/el5sjq7p9s0k/VC_-_Mipmaps.7z.html)
- [Download / Link](https://sharemods.com/bvsovmmgoadq/III_-_Mipmaps.7z.html)

### [Generate Free IDs List (mostrar IDs vazios)](https://www.mixmods.com.br/2021/07/generate-free-ids-list-mostrar-ids-vazios/)
**Data da Publicação:** `2021-07-16`
> Um mod CLEO que gera um arquivo .txt listando todos os IDs vazios (disponíveis) em seu jogo, útil para criar mods que adicionam novos objetos, armas, carros, peds etc ao jogo, ou simplesmente corrigir conflito de IDs (tutorial aqui), um dos motivos do crash 0x00534134.Já existe um criado pelo fastma...
**Links de Referência / Download:**
- [aqui](https://gist.github.com/JuniorDjjr/a6096af530835a6411799ecf86126740)
- [Download / Link](https://sharemods.com/qipof5weizvy/Generate_Free_IDs_List.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/1b8abb1706e409e16ccb0e92393935ed)

### [IMBEL IA2 & FN FAL (armas brasileiras em HD)](https://www.mixmods.com.br/2021/06/imbel-ia2-fn-fal-armas-brasileiras-em-hd/)
**Data da Publicação:** `2021-06-16`
> Duas armas detalhadas em HD, usadas pelo exército brasileiro: FN FAL / PARAFAL e IMBEL IA2.Inclui configuração própria para o weapon.dat, que ajusta a posição do tiro, dano, cadência e capacidade, baseado nas armas reais.O mod é também pré-adaptado ao GunFuncs (que no momento ainda não existe). Mode...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/v4buqzhgmour/IMBEL_IA2_FN_FAL.7z.html)

### [Pistolas Taurus 24/7 e PT 58 (lowpoly)](https://www.mixmods.com.br/2021/06/pistolas-taurus-24-7-e-pt-58-lowpoly/)
**Data da Publicação:** `2021-06-12`
> Duas pistolas brasileiras muito comuns que eu fiz para o GTA Brasil e agora estou postando (a PT-58 foi removida, então agora só tem aqui).Extremamente leves, mesmo peso de uma arma original do jogo, com uma textura 512px.A PT-58 há opções oxidada fosco e inóx.Infelizmente o jogo só tem 1 pistola pa...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/xiqp6ec07z44/Taurus_24_7_PT_58.7z.html)

### [Proper Weapons Retex v1.3 (armas com texturas HD)](https://www.mixmods.com.br/2021/06/proper-weapons-retex-v1-3-armas-com-texturas-hd/)
**Data da Publicação:** `2021-06-10`
> Atualizado 25/10/21Melhorado mais modelos/texturas de cutscenes: pistola silenciada, taco de golfe e SPAS-12.Atualizado 28/06/21Alterado a M4 pelo modelo do gameplay.Adicionado opção preta para a Desert Eagle (mais parecida com a original).Atualizado 14/06/21Melhorado MP5/SMG, SPAS-12, Shotgun, Kata...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zh4lmnw9s3m4/Proper_Weapon_Retex.7z.html)

### [Real Skybox v1.3.4 (céu realista)](https://www.mixmods.com.br/2021/06/sa-real-skybox/)
**Data da Publicação:** `2021-06-09`
> Atualizado 09/06/21 02:25Corrigido o mod bugando a quantidade de tempo que o jogo pula (por exemplo, ao salvar, ser preso etc).Corrigido problemas com a rotação na simulação de pular o tempo, entre outros ajustes no código.Atualizado 26/02/21 18:38Corrigido Windows Defender acusando vírus (somente a...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/asxvzdjkpa6m/Real_Skybox.7z.html)
- [Source code](https://github.com/JuniorDjjr/RealSkybox)

### [Widescreen Fix para GTA SA (corrigir widescreen)](https://www.mixmods.com.br/2021/05/widescreen-fix-para-gta-sa-corrigir-widescreen/)
**Data da Publicação:** `2021-05-28`
> Atualizado 16/06/26A nova versão oficial do mod se transformou em outra coisa muito além de corrigir monitores widescreen, se transformou num mod que muda o menu, os gráficos do jogo, o movimento da câmera etc. Por decisão minha e de seguidores, pensando na estabilidade doe quem baixa vários mods, e...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html)
- [Download / Link](https://sharemods.com/zv55ubycrdp8/Car_Speed_Dependant_FOV.zip.html)
- [Download / Link](https://sharemods.com/ati4o4vcxk6c/SA_-_Widescreen_Fix.7z.html)

### [More Realistic Reload Weapon Animation Mod (anims de recarregar)](https://www.mixmods.com.br/2021/05/more-realistic-reload-weapon-animation-mod-anims-de-recarregar/)
**Data da Publicação:** `2021-05-24`
> Mod que muda as animações de recarregar as armas do GTA SA por novas mais realistas. Novas animações para:Pistola, Tec9, Micro UziPistola silenciadaDesert EagleSpas12MP5AK47, M4Shotgun (versão alternativa não-oficial)Na minha opinião o destaque está na animação de recarregar da Spas12, agora ela é d...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/kyvwkd7vtt4i/More_Realistic_Reload_Animation_Mod.7z.html)

### [GTA SA Discord Rich Presence (mostrar informações no Discord)](https://www.mixmods.com.br/2021/05/gta-sa-discord-rich-presence-mostrar-informacoes-no-discord/)
**Data da Publicação:** `2021-05-22`
> Atualizado 17/07/21Corrigido crash ao dirigir veículos com nome longo.Corrigido Camera e Night Vision com nomes alternados.Atualizado 22/05/21Adicionado opção em CLEO! Discord chegou pra ficar, e há jogos sendo adaptados para mostrar dados sobre o gameplay no seu perfil. Este mod, para CLEO ou MoonL...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ipzt2b4jipim/Discord_Rich_Presence.7z.html)
- [Download / Link](https://sharemods.com/azxe17aqhwel/GTA_SA_Discord_Rich_Presence.7z.html)

### [NeXtGen Remaster Weapons (pack de armas em HD)](https://www.mixmods.com.br/2021/05/nextgen-remaster-weapons-pack-de-armas-em-hd/)
**Data da Publicação:** `2021-05-19`
> Ezekiel voltou com um mod para substituir o seu antigo INSANITY Weapons Items, um real bom mod que remasteriza todas as armas do GTA San Andreas por novas em HD, preservando o estilo original do jogo.Substitui todas as armas, do gameplay e cutscenes (filmes de missões).Diferente de outros mods do gê...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1fAxvXqia40TEKuFvyDw-KGaQZEIBf3Wo/view?usp=sharing)

### [View Models Info v1.1 (ver ID de objetos)](https://www.mixmods.com.br/2021/04/view-models-info/)
**Data da Publicação:** `2021-04-22`
> Atualizado 14/06/21 Adicionado: Ao clicar enquanto mirando, o ID e coordenada daquele objeto será mostrado no “ViewObjectsInfo.log”. Também enquanto mirando, pressionar o botão do meio do mouse faz log de todos os objetos atuais no mapa.Um mod .asi que mostra, in-game, o número ID de todos os objeto...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/21ot2q919vjr/View_Models_Info.7z.html)

### [Race Creator v0.1 (criador de corridas)](https://www.mixmods.com.br/2021/04/race-creator-v0-1-criador-de-corridas/)
**Data da Publicação:** `2021-04-20`
> Um mod CLEO que eu venho idealizando há muito tempo: Um criador de corridas personalizadas por .ini, para você facilmente instalar novas corridas no seu jogo, por exemplo, ao baixar novas pistas de corrida, mods de conversão/reforma total etc.Você pode iniciar as corridas com qualquer veículo, assim...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/j7ee0xxh4rjn/Race_Creator.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/38ca02f5c1af1e63831e1f5ae68c12bf)

### [Skyline Timecyc (cores corrigidas)](https://www.mixmods.com.br/2021/04/skyline-timecyc-cores-corrigidas/)
**Data da Publicação:** `2021-04-07`
> Um excelente mod de timecycle, que revisa corrigindo totalmente as configurações de cor de climas, iluminação etc do GTA San Andreas, para um gráfico mais realista e correto, sem bugs e lag.Muito melhor do que o velho Timecyc Update, com mais correções, e baseado no timecycle de 24 hroas (timecyc_24...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/izvr4xkn8brr/Skyline_Timecyc.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/mods/112326-skyline-timecyc-san-andreas)

### [Open Door Anim v1.2.2 (animação abrindo porta)](https://www.mixmods.com.br/2021/04/open-door-anim-v1-2-1-animacao-abrindo-porta/)
**Data da Publicação:** `2021-04-04`
> Atualizado 24/07/24Corrigido a animação repetindo mesmo com a pessoa parada.Agora não faz a animação caso esteja muito distante da porta (evita bugs).Atualizado 02/05/21Uma pequena melhoria no código do mod: agora ele usa a função apropriada para fazer a animação, não é mais uma animação considerada...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html)
- [Source code](https://github.com/JuniorDjjr/OpenDoorAnim)

### [Mesa Plus+ (SA style)](https://www.mixmods.com.br/2021/03/mesa-plus-sa-style/)
**Data da Publicação:** `2021-03-30`
> Atualizado 24/04/21Corrigido algumas peças invisíveis.Novo motor para as variações 4X4, da versão Xbox do VC.O jipe Mesa original do GTA SA, agora melhorado, ainda preservando o estilo original!Ele pode aparecer com literalmente centenas de combinações diferentes!O arquivo .dff tem 4 MB, mas não é p...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1i8s8xh9yhsn/Mesa_Plus.7z.html)

### [Improved Default Armoury (armas melhoradas com reflexos)](https://www.mixmods.com.br/2021/03/improved-default-armoury-armas-melhoradas-com-reflexos/)
**Data da Publicação:** `2021-03-19`
> Atualizado 29/05/23Os ícones do nadalao estavam desatualizados. Agora o download vem com os ícones atualizados.Remasteriza todas as armas do GTA SA com texturas restauradas utilizando inteligência artificial (upscale ERSGAN), além de ícones redesenhados em HD, alguns modelos mais detalhados (com gat...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/j7nwrbkgywll/Improved_Default_Armoury.7z.html)
- [Download / Link](https://sharemods.com/zq2h5phit29b/Improved_Default_Armoury_-_nadalao_icons.7z.html)
- [Download / Link](https://sharemods.com/o1v6qcux59kv/Improved_Default_Armoury_-_BONUS_files.7z.html)

### [Improved Default Armoury For Cutscenes (armas remasterizadas)](https://www.mixmods.com.br/2021/03/improved-default-armoury-for-cutscenes-armas-remasterizadas/)
**Data da Publicação:** `2021-03-08`
> Mod que adapta os mods Improved Default Armoury (armas melhoradas com reflexos) e Revamped Arsenal (armas originais melhoradas) para mudar as armas das cutscenes (cenas de missões).Também inclui correções de sobras da versão beta (beta leftovers fix), por exemplo, a glock preta.Tudo separado em past...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/z8idkvw7pxvs/Improved_Default_Armoury_For_Cutscenes.7z.html)

### [AutoID (corrigir conflito de IDs) + AutoAdapt](https://www.mixmods.com.br/2021/03/autoid-v2-2-corrigir-conflito-de-ids-autoadapt/)
**Data da Publicação:** `2021-03-04`
> AutoID é um mod Lua + CLEO que ajusta automaticamente o uso de IDs dos modelos do jogo para não causarem conflitos entre mods que adicionam novos modelos, assim, corrigindo crashes como 0x00534134 e 0x005B6B2F.Por exemplo, SAMP Object for Singleplayer adiciona mais de mil objetos no jogo, portanto, ...

### [ENB Series v0.430 (.asi) + complex shadows, soft particles](https://www.mixmods.com.br/2021/02/enb-series-v0-430-asi-complex-shadows-soft-particles/)
**Data da Publicação:** `2021-02-23`
> Atualizado 23/02/21Adicionado “Complex Shadows Culling Fix” que corrige (parcialmente) as sombras dinâmicas sumindo quando o objeto sai da tela. Ainda não 100%, mas melhor do que nada.ENB Series é um projeto que visa trazer gráficos realistas (HD) para os jogos, onde um dos focos é o GTA San Andreas...
**Links de Referência / Download:**
- [Baixe este pequeno mod CLEO, tecla Insert.](https://sharemods.com/6o30hb6d20nc/Disable_camera_-_Insert_key.7z.html)
- [Download / Link](https://sharemods.com/tupuccmn5z43/ENB_Series.7z.html)
- [Download / Link](https://sharemods.com/wa6l1ql42jda/Complex_Shadows_Culling_Fix.7z.html)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)

### [Added 70 Weapons Pack (70 novas armas adicionadas)](https://www.mixmods.com.br/2021/02/added-70-weapons-pack-70-novas-armas-adicionadas/)
**Data da Publicação:** `2021-02-13`
> Pra você que tem preguiça de, manualmente, adicionar novas armas sem substituir, eis aqui um pack que adiciona 70 novas armas, preservando o estilo original do GTA San Andreas!São armas que minimamente combinam com o estilo original do jogo, e inclui um script CLEO que adiciona um pickup de cada arm...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/m7m47k8pbah5/Added_Weapons_Pack.7z.html)

### [Save Tools – Jogo salvo 100% + Save Game Helper + Backup](https://www.mixmods.com.br/2021/01/save-tools-jogo-salvo-100-save-game-helper-backup/)
**Data da Publicação:** `2021-01-18`
> Save game completo com 100% de progresso.Este é o jogo salvo que eu (Junior_Djjr) passarei a usar a partir de 2019, substituindo o antigo que eu usava desde 2015.Este jogo salvo foi criado utilizando GTA SA Savegame Editor 3.2, sendo assim, totalmente limpo e bem planejado. O anterior também foi cri...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/v0mqs5d7wick/Save_Tools.7z.html)
- [Download / Link](https://sharemods.com/3dbi88seuxyu/Backup_MAIN.scm_SCRIPT.img.7z.html)

### [Rikintosh’s Small Details Mod (carros com texturas HD)](https://www.mixmods.com.br/2021/01/rikintoshs-small-details-mod-carros-com-texturas-hd/)
**Data da Publicação:** `2021-01-14`
> Atualizado 14/01/21Baseado na atualização do Zera, a Jéssica Natália re-adicionou os aviões, agora com upscale nas texturas. Em principal, foi removido todas as texturas ruins e com textos escritos em português, sobre pau, saco, peido etc (sim, tinha muitas).Baseado na atualização da Jéssica Natália...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/cg6r9vwvtdik/Rikintosh__x27_s_Small_Details_Mod_-_Improved.7z.html)
- [Download / Link](https://sharemods.com/wy0gbhr71ga2/Rikintosh__x27_s_Small_Details.7z.html)

### [First Person Fixed Weapon Anims (corrigir anims em FPS)](https://www.mixmods.com.br/2021/01/first-person-fixed-weapon-anims-corrigir-anims-em-fps/)
**Data da Publicação:** `2021-01-05`
> Mod que corrige a posição das shotguns, ficando assim corretas na câmera em primeira pessoa do First Person Mod.E claro, também fica ótimo em terceira pessoa, com por exemplo, segurar uzi com duas mãos — se você não quiser, basta não instalar o weapon.dat e default.ide.Atenção: Houve relatos de cras...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/aaykvgve52wa/First_Person_Fixed_Weapon_Anims.7z.html)

### [Mod VR (Virtual Reality)](https://www.mixmods.com.br/2021/01/mod-vr-virtual-reality/)
**Data da Publicação:** `2021-01-03`
> Mod que possibilita jogar GTA San Andreas com óculos VR (realidade virtual).Inclui um shader universal de realidade virtual para ReShade, esse shader pode ser instalado em qualquer jogo ou aplicativo que suporte ReShade.O funcionamento é o mais básico de todos: somente uma repetição da mesma tela pa...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/5x07pblbqpxz/Mod_VR.7z.html)

### [SAORS v2 (mod rádio online)](https://www.mixmods.com.br/2020/12/saors-v2-mod-radio-online/)
**Data da Publicação:** `2020-12-28`
> Atualizado 28/12/20Corrigido um crash.Corrigido não funcionando com https ou ftp.Adicionado configuração netradiobuffer.Adicionado limite de sinal: você coloca a posição e intensidade do sinal no mapa. SAORS (San Andreas Own Radio Station) é um mod para você ouvir rádios online dentro do GTA SA. O m...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/3bet7r9pi53t/SAORS.7z.html)

### [Acceleratorgen (gerador de MINFO.BIN e CINFO.BIN)](https://www.mixmods.com.br/2020/12/acceleratorgen-gerador-de-minfo-bin-e-cinfo-bin/)
**Data da Publicação:** `2020-12-26`
> Acceleratorgen.asi é um mod que cria os arquivos de cachê MINFO.BIN (modelos) e CINFO.BIN (colisores) na pasta “models” do seu GTA SA caso não exista. Isto aumenta a velocidade de carregamento do jogo devido ao caching das informações. Uma função utilizada nas versões de PS2 e Xbox do jogo.Aviso ant...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dacnu6i4jbps/Acceleratorgen.7z.html)

### [San Andreas Farming Equipment DLC (SAFE DLC) (trator HD)](https://www.mixmods.com.br/2020/12/san-andreas-farming-equipment-dlc-safe-dlc-trator-hd/)
**Data da Publicação:** `2020-12-15`
> Depois de tantos anos, finalmente um bom pacote de máquinas agrícolas em HD para o GTA San Andreas!Criado por Mad Driver, ou seja, sempre com alto padrão de qualidade de conversão e adaptação.Muito bem convertido, adaptado ao Improved Vehicle Features (opcional) e VehFuncs.Baseados em:Case IH 1660 A...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/z7cnx7ur9s5n/San_Andreas_Farming_Equipment_DLC.7z.html)
- [Origem](https://libertycity.net/files/gta-san-andreas/149973-san-andreas-farming-equipment-dlc-safe.html)

### [INSANITY Weapons Items (armas HD)](https://www.mixmods.com.br/2020/12/insanity-weapons-items-armas-hd/)
**Data da Publicação:** `2020-12-13`
> Atualizado 13/12/20 Agora também troca os modelos das cutscenes! Pack que substitui todas as armas e itens por novos remasterizados em HD respeitando os modelos originais e com texturas com mip-mapping e normal map. E agora as armas também aparecem em HD em todas as cutscenes! (um dos primeiros mods...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/a5ip9lonbiwc/INSANITY_Weapons_Items.7z.html)
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYTWMwcEhZbDZ5Tm8/view?usp=sharing)

### [Draw Cols SA (modo debug de colisores)](https://www.mixmods.com.br/2020/12/draw-cols-sa-modo-debug-de-colisores/)
**Data da Publicação:** `2020-12-11`
> Um mod .asi que mostra na tela, durante o jogo, informações do modelo de colisão dos objetos, pedestres e carros.Isto é baseado numa visualização de depuração utilizada pela Rockstar North durante o desenvolvimento do GTA San Andreas.Para entender, veja: [Curiosidades] A maior perda da história do m...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1swhpdai23zn/Draw_Cols_SA.7z.html)
- [Origem](https://github.com/saml1er/DrawColsSA)

### [SA_DirectX 2.0 Final + Unofficial update (ASI version)](https://www.mixmods.com.br/2020/12/sa_directx-2-0-final-unofficial-update-asi-version/)
**Data da Publicação:** `2020-12-07`
> Atualizado 10/03/21Adicionado mais informações sobre compatibilidade do SkyGfx, inclusive arquivos .ini adaptados. Atualizado 07/12/20Adicionado todos os presets (High, Medium, Low e Very Low), que também altera a qualidade das nuvens volumétricas e sombras complexas, deixando-as mais leves para PCs...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/e07ksm6zefr3/SA_DirectX_2.7z.html)
- [Baixar o mod Proper Shaders](https://www.mixmods.com.br/2026/05/sa-proper-shaders/)
- [Origem](https://www.gtainside.com/en/sanandreas/mods/119369-sa-directx-2-0/)

### [Vehicle Shared HD Wheels (carros com rodas HD)](https://www.mixmods.com.br/2020/11/vehicle-shared-hd-wheels-carros-com-rodas-hd/)
**Data da Publicação:** `2020-11-20`
> Uma solução alternativa para carros originais com rodas mais redondas (ou ISDC)!No GTA III e GTA VC os carros do jogo têm rodas genéricas compartilhadas, diferente do GTA SA onde cada roda fica dentro do arquivo do carro. Este mod transforma as rodas tuning do jogo em rodas compartilhadas, assim, ad...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/kgi120yjoqgc/Vehicle_Shared_HD_Wheels.7z.html)
- [source code](https://gist.github.com/JuniorDjjr/443d0e304438f13d2d36589dfc24ba2e)

### [Beta Gang Skins Added (restaurar gangue beta)](https://www.mixmods.com.br/2020/11/beta-gang-skins-added-restaurar-gangue-beta/)
**Data da Publicação:** `2020-11-05`
> Mod que restaura basicamente todas as skins de gangues removidas da versão final do jogo (20 delas).Normalmente modelos restaurados de arquivos não usados, ou recriados de screenshots da versão beta.6 Ballas9 Grove St Families2 Vagos3 AztecasCorreções que eu fiz:Originalmente o mod dizia incluir um ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/t1oa3uuqyl8p/Beta_Gang_Skins_Added.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/skins/116012-beta-gang-skins-added/)

### [Revamped Arsenal (armas originais melhoradas)](https://www.mixmods.com.br/2020/10/revamped-arsenal-armas-originais-melhoradas/)
**Data da Publicação:** `2020-10-13`
> Atualizado 13/10/20Nova versão (provavelmente final) logo após postar aqui.Corrigido um buraco na M4Removido o rótulo e melhorado reflexos do molotov.Diminuído um pouco a MP5.Agora o colete é preto.Melhorado as cores das balas e reflexos da Minigun.Granada recriada.Adicionado alça no Satchel. Mod qu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/04ywd5k9r0ps/Revamped_Arsenal.7z.html)

### [NewOpcodes.cleo v2.1](https://www.mixmods.com.br/2020/10/newopcodes-cleo-v2-1/)
**Data da Publicação:** `2020-10-11`
> NewOpcodes é um projeto antigo que adiciona mais de 100 novos opcodes/comandos para a CLEO, que deixa scripts avançados mais simples de serem criados, simplificando certas operações avançadas (como quaterniões e matrizes) e possibilitando o carregamento de texturas por arquivos .bmp, .png e .dds, en...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html)

### [[III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)](https://www.mixmods.com.br/2020/10/iii-vc-sa-scrlog-2020-3-descobrir-crash-em-mod-cleo/)
**Data da Publicação:** `2020-10-07`
> Atualizado 30/09/23Arquivos .ini atualizados com mais novos comandos do CLEO+ v1.2. Atualizado 23/11/20Corrigido GET_COLPOINT_DEPTH e GET_COLPOINT_SURFACE com opcode diferente do newOpcodes.Atualizado 07/10/20Arquivos .ini atualizados com mais novos comandos do CLEO+. Atualizado 07/10/20Adicionado c...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html)
- [Source code](https://github.com/JuniorDjjr/scrlog)

### [MoonLoader](https://www.mixmods.com.br/2020/10/moonloader/)
**Data da Publicação:** `2020-10-04`
> Atualizado 04/10/20Adicionado a versão preview (que antes da beta e da alpha). Eu estava esperando por uma versão beta mais estável, mas o projeto parece parado, e mods já começaram a serem criados para a nova, portanto eu recomendo a atualização, mas caso um mod funcione na antiga e não na nova, in...
**Links de Referência / Download:**
- [plugin-sdk](https://github.com/DK22Pac/plugin-sdk)
- [Clique aqui para baixar mods Lua, CLEO, ASI etc.](http://www.mixmods.com.br/search/label/Mods%20Scripts%20%28CLEO%20etc%29)
- [Download / Link](https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html)
- [Download / Link](https://sharemods.com/9cjkhj6qjt5p/MoonLoader___MoonAdditions___ImGui.7z.html)

### [ModLoader support for MoonLoader (mods Lua no ModLoader)](https://www.mixmods.com.br/2020/10/modloader-support-for-moonloader-mods-lua-no-modloader/)
**Data da Publicação:** `2020-10-01`
> Finalmente agora você pode instalar mods Lua (para MoonLoader) dentro do ModLoader!Esta é uma (ótima) solução do HzanRsxa2959, que também serve de API para outros mods Lua (infos).Como instalar mods Lua no ModLoader:Instale este mod. Ele lê todo o arquivo “modloader/modloader.log” à procura dos arqu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html)

### [VPJ – Vertex Paint Job (novas sombras e iluminação)](https://www.mixmods.com.br/2020/09/vpj-vertex-paint-job-novas-sombras-e-iluminacao/)
**Data da Publicação:** `2020-09-25`
> Mais uma das ideias inovadoras do Ezekiel.Um mod que recria o sombreamento dos modelos do jogo (pre-lighting), e com isto, também adiciona o desenho das sombras, agora, tudo rodando no vertex color.Isto quer dizer que você terá uma sombra muito semelhante às configurações de gráficos altas, mas sem ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/d4ad9tj5ip4z/VPJ_by_Ezekiel.7z.html)

### [Skyscrapers Reflections (reflexos nos vidros dos prédios)](https://www.mixmods.com.br/2020/09/skyscrapers-reflections-reflexos-nos-vidros-dos-predios/)
**Data da Publicação:** `2020-09-24`
> Mod que adiciona reflexos reais aos prédios do centro de Los Santos.Utiliza o sistema de reflexos por cubemap do SkyGfx (necessário “vehiclePipe=Env” no .ini do SkyGfx). Diferente da versão antiga que utiliza normal map.Mod do vídeo: Spider-Man Mod for GTA SA by J16D O mod também inclui, como um bôn...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/i6mfm8lk10zv/Skyscrapers_Reflections.7z.html)

### [Dynamic FOV v1.1 (campo de visão dinâmico)](https://www.mixmods.com.br/2020/09/dynamic-fov/)
**Data da Publicação:** `2020-09-20`
> Atualizado 20/09/20 01:50Eu havia feito um erro que fazia o mod se ativar em qualquer modo de câmera, não só a de gameplay. Corrigido. Isto inclusive corrige a mira da sniper.Em adição, agora o mod é configurável num arquivo .ini. Por padrão o efeito vem um pouco mais fraco agora, você pode ajustar,...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/mzim2ufqseez/Dynamic_FOV.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/ad046809c33d7a3b542a98b4c92bcd77)

### [SIG Sauer P226R do Escape from Tarkov](https://www.mixmods.com.br/2020/09/sig-sauer-p226r-do-escape-from-tarkov/)
**Data da Publicação:** `2020-09-17`
> Pistola convertida diretamente de um dos jogos de tiro mais realistas dos últimos tempos. Contém quatro variações de skin, cada uma em sua respectiva pasta. Além de também ser adaptado ao normal map (necessário normal map by DK) mas não é obrigatório usá-lo. Inclui versão com e sem silenciador para ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dj1g4aw1puhz/SIG_SAUER_P226R.7z.html)

### [[SA] Glowing Pickups v1.0.3 (weapon coronas)](https://www.mixmods.com.br/2020/09/glowing-pickups-weapon-coronas/)
**Data da Publicação:** `2020-09-12`
> Atualizado 16/08/25Agora inclui um arquivo .ini para adicionar cores nas armas (adaptado para armas adicionadas sem substituir)Corrigido renderizar mesmo que o modelo esteja invisível.Corrigido as coronas enfiadas no chão.Atualizado 23/08/22Corrigido um possível crash.Atualizado 22/08/22Corrigido um...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/c6bqk7phv6m5/Glowing_Pickups.zip.html)
- [Origem](https://github.com/kagikn/GlowingPickupsSA)

### [Rhino Animated (tanque original animado)](https://www.mixmods.com.br/2020/09/rhino-animated-tanque-original-animado/)
**Data da Publicação:** `2020-09-10`
> Rhino vanilla com lagartas (tracks) animadas/funcionais!O estilo das lagartas continua no “SA style”, parece uma atualização oficial para algo que realmente faz falta.E de bônus, agora você pode pintá-lo! (opcional)Originalmente a lagarta era muito amarela e o interior da roda muito branco, eu ajust...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ebrx0xurrrq6/Rhino_Animated.7z.html)
- [Origem](https://libertycity.net/files/gta-san-andreas/98137-rhino-animated.html)

### [Cutscene Weapons Fix (corrigir armas das cutscenes)](https://www.mixmods.com.br/2020/09/cutscene-weapons-fix-corrigir-armas-das-cutscenes/)
**Data da Publicação:** `2020-09-04`
> Atualizado 05/09/20Adicionado correção para a missão Mike Toreno, e Epílogo (última cutscene).Alguns filmes de missões (cutscenes) do GTA SA têm armas diferentes das que foram usadas no momento do gameplay, e é este o objetivo deste mod: trocar as armas das cutscenes para as mesmas do gameplay.No mo...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/o7x9wiu40e31/Cutscene_Weapons_Fix.7z.html)

### [Beta Weapons Pack (armas restauradas da versão beta)](https://www.mixmods.com.br/2020/09/beta-weapons-pack-armas-restauradas-da-versao-beta/)
**Data da Publicação:** `2020-09-03`
> Mod que restaura todas as armas da versão beta do GTA SA, isto é, como o jogo seria antes de ser lançado.Normalmente são modelos presentes nos arquivos do jogo, mas não usados, ou usados em cutscenes, alguns deles usados também no jogo Manhunt com uma textura de maior definição.Vídeo do Vadim M sobr...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html)

### [Real Skybox skyboxes by Crowdigger (novos céus HD)](https://www.mixmods.com.br/2020/08/real-skybox-skyboxes-by-crowdigger-novos-ceus-hd/)
**Data da Publicação:** `2020-08-30`
> Novos céus em HD, texturas geradas/criadas pelo Zeneric, editadas e adaptadas pelo Crowdigger para o mod Real Skybox.Imagens do autor.O estilo é bem diferente dos céus originais do Real Skybox, são nuvens mais dispersas (lindas no pôr do sol), há muito mais variação e com mais opções de definição.Qu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/6bqvoaye4s8o/Real_Skybox_-_skyboxes_1024.7z.html)
- [Download / Link](https://sharemods.com/tuf12u1srf24/Real_Skybox_-_skyboxes_2048.7z.html)
- [Download / Link](https://sharemods.com/2pdarqejc397/Real_Skybox_-_skyboxes_4096.7z.html)
- [Download / Link](https://sharemods.com/m3krz85iucbq/Real_Skybox_-_skyboxes_-_Real_Linear_Graphics.7z.html)

### [Handshake Mod (aperto de mão)](https://www.mixmods.com.br/2020/08/handshake-mod-aperto-de-mao/)
**Data da Publicação:** `2020-08-29`
> Remake de um mod que eu criei lá em 2011.Mire na pessoa e aperte Y (ou comando equivalente) para fazer uma animação de aperto de mãos com seus membros de gangue. Um pequeno detalhe para a imersão do gameplay.São 7 animações, sendo 1 delas exclusiva para o CJ gordo junto com FAM1 (a “barrigada”). Com...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/3e8fd0e923fc5a28f66d83924d4367f6)

### [Stress Test (forçar jogo a crashar)](https://www.mixmods.com.br/2020/08/stress-test-forcar-jogo-a-crashar/)
**Data da Publicação:** `2020-08-28`
> Um mod que testa o seu jogo automaticamente, um “stress test”, teste de estresse, para você saber se o seu jogo está causando erro ou está estável.Eu o criei rapidamente e o uso há muito tempo para testar a estabilidade de mods muito intrusivos, como GTA Brasil, VehFuncs e packs de carros. Eu ainda ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/shb6ml79ruhj/Stress_Test.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/83c7f8db204638104a534c968806fb0f)

### [Gang Rider v2 (carregar mais gangue)](https://www.mixmods.com.br/2020/08/gang-rider-v2-carregar-mais-gangue/)
**Data da Publicação:** `2020-08-22`
> Atualizado 22/08/20Versão Lua recriada, com um editor muito avançado e amigável.Repost da versão CLEO com melhores explicações. Um mod muito legal que possibilita carregar mais membros de gangue nos carros do GTA SA, por exemplo na caçamba de caminhonetes.Esta nova versão Lua (para MoonLoader) inclu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html)
- [Download / Link](https://sharemods.com/wus6c66kjang/Gang_Rider_CLEO.7z.html)

### [fastman92 processor v1.9 + GUI](https://www.mixmods.com.br/2020/08/programa-fastman92-processor-v1-5-gui/)
**Data da Publicação:** `2020-08-19`
> O fastman92’s processor além de mover mapas consegue fazer conversões entre arquivos do GTA III, GTA VC, GTA SA, GTA IV, GTA V e Bully Scholarship Edition. Inclui também arquivos binários desses jogos e IDB e IPB do Bully.É um aplicativo que roda por console com argumentos configurados num .bat, ass...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html)
- [Download / Link](https://sharemods.com/xvx8na5ffljr/fastman92_processor_GUI.7z.html)

### [GTA SA Comic Edition](https://www.mixmods.com.br/2020/08/gta-sa-comic-edition/)
**Data da Publicação:** `2020-08-08`
> Mod que faz uma reforma total dos gráficos do GTA San Andreas, para um estilo “cômico”, inspirado em história de quadrinhos e outros jogos, como Borderlands.Diferente de qualquer outro mod cartoon, como este, o GTA SA Comic Edition não só adiciona shaders de cell shading e outline com ReShade, como ...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/drive/folders/1gPYZm_H0i-h22r1TjSZCcKY8hiCEqI8t)
- [Como baixar uma pasta no Google Drive](https://1.bp.blogspot.com/-D9EZxZ45U7I/Xy4R0MaRiHI/AAAAAAAAZv0/bQgCCGcvkGkT7LsCoWmV_AWC1Uu3bAAmwCLcBGAsYHQ/s0/0.png)

### [Faithful Weapons Pack 2.0 (pack de armas fiéis)](https://www.mixmods.com.br/2020/07/faithful-weapons-pack-2-0-pack-de-armas-fieis/)
**Data da Publicação:** `2020-07-31`
> Atualizado 30/07/20 Todas as armas foram substituídas! (Completei o pack com armas melee e equipamentos do Atmosphere Weapons Pack 2.0) Incluso agora os pickups do Insanity Weapons. Trocado o lança-chamas pelo do AWP 2.0. Agora usa os ícones do nadalao! Faithful Weapons Pack (FWP) é um pack de armas...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing)
- [Download / Link](https://drive.google.com/file/d/1JJLIYR79zjsnm-e8-5zaXEBgszr4SIQN/view?usp=sharing)

### [Banshee Plus+ (SA style)](https://www.mixmods.com.br/2020/07/banshee-plus-sa-style/)
**Data da Publicação:** `2020-07-18`
> Novas variações para o Banshee, inspiradas nos Dodge Viper entre os anos 1995 e 2000, através do VehFuncs.Volante funcional; 2 spoilers para cada versão; 3 variações de faróis, 2 variações de para-choques; 1 variação de capô, motor da versão de Xbox do GTA VC editado; múltiplas variações de escapame...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/t0qrb187b7qr/Banshee_Plus.7z.html)

### [Euryopa (visualizador de mapa para GTA)](https://www.mixmods.com.br/2020/07/euryopa-visualizador-de-mapa-para-gta/)
**Data da Publicação:** `2020-07-14`
> A imagem abaixo não é uma screenshot dentro do GTA San Andreas, mas sim um visualizador de mapa que simula a mesma engine gráfica do jogo.O mesmo para GTA Vice City:E GTA III:E ainda LCS e VCS de PS2.Extremamente útil para descobrir o nome do arquivo .txd, .dff, .col etc de cada objeto do jogo:Com …...
**Links de Referência / Download:**
- [num trabalho dele e da comunidade de modding que visa recriar os gráficos da RenderWare](https://github.com/aap/librw)
- [Download / Link](https://sharemods.com/jm60r1j8pr72/Euryopa.7z.html)

### [Futo Trueno + Levin (AE86 SA style)](https://www.mixmods.com.br/2020/07/futo-trueno-levin-ae86-sa-style/)
**Data da Publicação:** `2020-07-11`
> Futo Trueno e Futo Levin, inspirado no Toyota Sprinter Trueno e Toyota Corolla Levin, da série AE86.Um carro icônico devido principalmente ao anime Initial D.Esta é uma adaptação SA style impecável, parece um DLC.Faróis “pop-up” pelo VehFuncs. Tunável. Todas as adaptações (danos, colisão, LOD, sombr...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ywqqzuky007z/Futo_Trueno_Levin.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/100849-futo-trueno-levin/)

### [90s AWP – 90s Atmosphere Weapons Pack Reborn 4.0](https://www.mixmods.com.br/2020/07/90s-awp-atmosphere-weapons-pack-reborn/)
**Data da Publicação:** `2020-07-08`
> Atualização 08/07/20 Nova versão focada em melhorar e otimizar o mod. Normal maps removidos (o mod de Normal Map causa crash, não sei sabe o motivo, se é incompatibilidade com outro mod etc, se você tiver informações, diga). Gunflashes 3D removidos (bugava com enb series e é feio). Texturas 4K reduz...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s8bmfqkshpzo/90s_Atmosphere_Weapons_Pack_Reborn.7z.html)

### [ENB Series Auto Toggle (desativar ENB em interior e menu)](https://www.mixmods.com.br/2020/07/enb-series-auto-toggle-desativar-enb-em-interior-e-menu/)
**Data da Publicação:** `2020-07-02`
> Assim como ReShade Auto Toggle, este mod .asi desativa automaticamente a ENB Series caso no menu (necessário para versões antigas) e em interiores. Por exemplo, corrige este bug que acontece em todos os interiores, e maioria das cutscenes, no mod SA_DirectX 2.0: E também o efeito de chuva, tanto SA_...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/coxoxpb23p35/ENBSeriesAutoToggle.7z.html)

### [Peugeot 206 GTI (tunável)](https://www.mixmods.com.br/2020/06/peugeot-206-gti-tunavel/)
**Data da Publicação:** `2020-06-18`
> O atual melhor Peugeot 206 para GTA San Andreas! Modelo convertido hibridamente dos jogos NFSU2, Juiced e Forza, portanto, malha e texturas de qualidade profissional, muito bem convertido pelo armin360. Peso mediano, 5 MB de .dff, aceitável para PCs fracos-medianos. Modelos próprios de sombra, colis...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/jvzzb61srlpb/Peugeot_206_GTI.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/146293-peugeot-206-gti/)

### [Clean Render (RenderHook)](https://www.mixmods.com.br/2020/06/clean-render-renderhook/)
**Data da Publicação:** `2020-06-15`
> Um preset (configuração) para RenderHook + ReShade com o objetivo de gráficos limpos e realistas para GTA San Andreas. Muita gente não gosta do RenderHook devido aos gráficos “poluídos”, “lavados”, assim, Kitazawa Garage criou esta configuração com gráficos mais limpos e corrigidos. Não é só um pres...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/w955w0xtii2a/Clean_Render_-_Renderhook.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/mods/148041-clean-render-1-0-renderhook/)

### [Hangout with Story Characters (recrutar personagens)](https://www.mixmods.com.br/2020/06/hangout-with-story-characters-recrutar-personagens/)
**Data da Publicação:** `2020-06-14`
> Um novo excelente mod para quem procura melhorar a experiência original do GTA San Andreas. Você pode recrutar personagens da história a qualquer momento! São adicionados como “recompensas” ao concluir missões do modo história/campanha, semelhante ao GTA Vice City, cada um com suas características e...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zprw8r1npn0f/Hangout_with_Story_Characters.7z.html)

### [Beta Gang Restore (restaurar gangue beta)](https://www.mixmods.com.br/2020/06/beta-gang-restore-restaurar-gangue-beta/)
**Data da Publicação:** `2020-06-06`
> Um mod muito simples e pequeno que restaura os peds FAM4 e FAM5 para a Grove Street Families, que foram removidos da versão final do jogo.São os modelos originais da Rockstar, usados numa cutscene, re-adicionados no gameplay. Agora os Families terão 5 variações de modelos. ‎Autor: Junior_Djjr Recome...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1gegyekjbnht/Beta_Gang_Restore.7z.html)

### [LCS PlayIdles to SA](https://www.mixmods.com.br/2020/06/lcs-playidles-to-sa/)
**Data da Publicação:** `2020-06-05`
> Animações de variações quando o CJ está parado durante muito tempo (chamadas de “idle”), convertidas do jogo GTA Liberty City Stories (versão Mobile) para o arquivo playidles.ifp. Eu (Junior_Djjr) diminui a velocidade das animações para ficarem mais naturais, pois as originais são muito rápidas comp...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/3mapd6624i7k/LCS_PlayIdles_to_SA.7z.html)

### [PCJ600 Remastered HD](https://www.mixmods.com.br/2020/05/pcj600-remastered-hd/)
**Data da Publicação:** `2020-05-28`
> Moto PCJ-600 original do GTA SA, remasterizada pelo Zeneric com ajuda do Kkjj, Grinch_. Preservando a essência original, e muito bem trabalhada e adaptada para o jogo, e mods. Vídeo do autor: Adaptado para o novo mod Functional Vehicle Components: Luzes de danos, neutro e energia. Freios animados. O...
**Links de Referência / Download:**
- [Functional Vehicle Components](https://github.com/user-grinch/Functional-Vehicle-Components)
- [Download / Link](https://sharemods.com/nti33jp135j3/PCJ600_Remastered_HD.7z.html)

### [Arma MAC-10 (lowpoly)](https://www.mixmods.com.br/2020/05/arma-mac-10-lowpoly/)
**Data da Publicação:** `2020-05-18`
> Ingram MAC-10 para substituir a Micro Uzi do GTA San Andreas.Eu a criei para usá-la na próxima versão do GTA Brasil, portanto, mesmo realista, ela é super leve (38 KB de .dff, a original do jogo é 28 KB, quase mesmo peso).E como de costume, uma versão com textura HD e outra low (mais próxima … Ler m...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/8kbzd9j6ez1s/Arma_MAC-10.7z.html)

### [Big Gangster Mod (mais gangues)](https://www.mixmods.com.br/2020/05/big-gangster-mod-v13-5-mais-gangues/)
**Data da Publicação:** `2020-05-15`
> Uma renovação completa nas guerras de gangue do GTA SA!Uma atualização não-oficial, feita por um brasileiro, ao mod Big Gangster, que adiciona novas gangues e territórios por toda San Andreas.Nota: Os territórios mudam conforme o passar da história do jogo e com o seu jogo salvo. Abaixo há o downloa...
**Links de Referência / Download:**
- [download da versão antiga revisada por nós (13.5)](https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html)
- [Download / Link](https://sharemods.com/4ydl0gxpgoas/Big_Gangster_Mod_-_Saves.7z.html)

### [86′ Deluxo (SA style)](https://www.mixmods.com.br/2020/04/86-deluxo-sa-style/)
**Data da Publicação:** `2020-04-29`
> Carro Deluxo (inspirado no DeLorean DMC-12) do GTA Vice City convertido para GTA San Andreas, incluindo suas texturas e estilo (SA style). Muito bem convertido pelo ceec: tunável, bons reflexos na carroceria (recomendado vehiclePipe em “PS2” ou “Env” no SkyGfx), colisão, danos, LOD, sombra, handling...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/r17sebrganh9/Deluxo.7z.html)

### [Chroma Key Mod](https://www.mixmods.com.br/2020/04/chroma-key-mod/)
**Data da Publicação:** `2020-04-25`
> Estúdio chroma key (tela verde), útil para gravar vídeos, tirar fotos/prints/screenshots para edição etc. Diferente dos outros mods, este é verde total, sem sombras, e fechado em todas as direções (360°). O resultado é perfeito para a remoção de fundo. Há um (opcional) no aeroporto de Los Santos. Eu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2hzskb32rm52/Chroma_Key.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/d69af2ef3d12e265e4f7d23e02a530ef)

### [Comet Plus+ (SA style)](https://www.mixmods.com.br/2020/04/comet-plus-sa-style/)
**Data da Publicação:** `2020-04-22`
> Isto é algo que eu adoro ver pessoas fazendo para o VehFuncs: um só carro; várias variações. Comet original do GTA SA editado com melhorias e variações, como a traseira do Comet do GTA Vice City, incluindo funções do novo VehFuncs, como ele aparecer com teto em caso de chuva. Também inclui rodas mai...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html)

### [Como copiar pastas sem ocupar espaço em disco (symbolic link)](https://www.mixmods.com.br/2020/04/como-copiar-pastas-sem-ocupar-espaco-em-disco-symbolic-link/)
**Data da Publicação:** `2020-04-18`
> Um problema comum em quem instala mods e tem várias instalações do mesmo jogo (eu por exemplo tenho 20 GTA SA), é o grande espaço em disco que cada instalação e cada mod ocupa, principalmente quando estamos falando de mods grandes de vários GB, como RoSA Project.Quando eu pedi para o LINK/2012 adici...

### [90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)](https://www.mixmods.com.br/2020/04/90s-atmosphere-vehicles-pack-reborn-3/)
**Data da Publicação:** `2020-04-14`
> Atenção: Não existe Reborn 4, nem 5 nem 6! Fizeram isso sem nossa permissão e os novos modelos que adicionou foi relatado crash. Reborn 3 é a nossa mais recente versão oficial! Schrader postou uma versão “não-oficial” deste mod na GTA Inside usando ele como o autor, e na descrição colocou coisas com...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view)
- [Download / Link](https://sharemods.com/cq6dm0d6plas/90s_AVP_Reborn_3_Fix.7z.html)

### [[III/VC/SA] ReShade Auto Toggle (desativar efeitos no menu)](https://www.mixmods.com.br/2020/04/iii-vc-sa-reshade-auto-toggle-desativar-efeitos-no-menu/)
**Data da Publicação:** `2020-04-09`
> Um problema do ReShade, é que, por ser um mod para qualquer jogo, é praticamente impossível ele diferenciar o que é a renderização do gameplay do menu dele, assim, os efeitos gráficos continuam mesmo no menu do jogo. Portanto eu fiz este mod que automaticamente desativa os shaders do ReShade ao abri...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/y1o3rvh75rzr/ReShade_Auto_Toggle.7z.html)
- [código fonte](https://github.com/JuniorDjjr/ReShadeAutoToggle)

### [PBR materials for RenderHook by jujubao (materiais para RH)](https://www.mixmods.com.br/2020/04/pbr-materials-for-renderhook-by-jujubao-materiais-para-rh/)
**Data da Publicação:** `2020-04-05`
> Download corrigido Um grande (e demorado) trabalho do jujubao: Adiciona materiais PBR para 176 texturas originais/vanilla do GTA San Andreas, para RenderHook. PBR (Physically Based Rendering; renderização baseada na física) é o padrão atual de gráficos realistas, e RenderHook nos proporciona o uso d...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ov81mu97sllm/PBR_materials_for_RenderHook_by_jujubao.7z.html)

### [Shadows Settings Extender v2.1.2 (extensor de sombras)](https://www.mixmods.com.br/2020/03/shadows-settings-extender-v2-1-2-extensor-de-sombras/)
**Data da Publicação:** `2020-03-30`
> Um mod clássico e muito usado, repostado agora com melhores explicações e opções de configurações.Shadows Settings Extender by DK22Pac é um mod que melhora as sombras do GTA San Andreas, deixando-as mais configuráveis, aumentando limites, distância de visão, resolução configurável e, principalmente,...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html)
- [Origem](https://libertycity.net/files/gta-san-andreas/78846-shadows-settings-extender-2.1.2.html)

### [Wayfarer Plus+ (sa style)](https://www.mixmods.com.br/2020/03/wayfarer-plus-sa-style/)
**Data da Publicação:** `2020-03-26`
> Atualizado 30/06/20 Corrigido um bug nas rodas. Nova Wayfarer, baseada na Freeway, inspirada na Honda GL1500 gold wing 1998 e Honda Gl1500 Valkyrie Tourer 1998. Preservando o “SA style”, leve, lowpoly, com variações extras e pezinho funcional que funciona com o VehFuncs. Há também rodas mais redonda...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html)

### [Cartoon Mod Fixed (texturas e gráficos cartoon)](https://www.mixmods.com.br/2020/03/cartoon-mod-fixed-texturas-e-graficos-cartoon/)
**Data da Publicação:** `2020-03-16`
> Há alguns mods que são vistos como “mal gosto”, mas mods existem para modificar, e MixMods existe para provar que tudo tem como ficar melhor. Esta é uma versão melhorada e corrigida do Cartoon Mod, onde além dos arquivos .txds corrigidos e com mipmapping, eu incluí um cel shading e tonemap por ReSha...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/9is4rzz7fd7w/Cartoon_Mod_Fixed.7z.html)

### [Dream Grass (grama HD do GTA V)](https://www.mixmods.com.br/2020/03/dream-grass-grama-hd-do-gta-v/)
**Data da Publicação:** `2020-03-14`
> Se você procura por um mod de grama HD bonita e de alto preenchimento, está aqui!Usa texturas convertidas do GTA V, modelos mais detalhados, e uma nova configuração de gramas para deixá-las mais preenchidas.Há dois motivos que demonstram que o autor criou este mod pensando em screenshots:São muito p...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/mods/105321-dream-grass-last-version)

### [ReShade + Tutorial de como usar](https://www.mixmods.com.br/2020/03/reshade-tutorial-de-como-usar/)
**Data da Publicação:** `2020-03-12`
> O que é ReShade? ReShade é um post-processing injector genérico para jogos, isto é, ele injeta pós-processamentos gráficos (com shaders) em basicamente qualquer jogo, pincelando a tela para aplicar efeitos visuais como ambient occlusion, DOF, correções de cores, anti-aliasing SMAA, chromatic aberrat...

### [Grip Animation (nova animação de segurar arma)](https://www.mixmods.com.br/2020/02/grip-animation-nova-animacao-de-segurar-arma/)
**Data da Publicação:** `2020-02-08`
> Nova animação de empunhadura para submetralhadoras (uzi.ifp) e rifles/fuzis (rifle.ifp). Com o mod o CJ vai segurar as armas apoiando de modo diferente, uma nova empunhadura (grip). ‎Autor: FilipeS Veja também: Military Animation (animações militares) Correr com armas pesadas (correr com rifle) [Tóp...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html)

### [Military Animation v9 (unofficial fix)](https://www.mixmods.com.br/2020/02/military-animation-v9-unofficial-fix/)
**Data da Publicação:** `2020-02-07`
> Um mod de animações já bem antigo, com destaque à animações que combinam com um gameplay militar, principalmente ao segurar fuzis e rifles. Se trata de um novo ped.ifp com novas animações pro GTA SA. Ao testar, eu não esperava que o mod fosse tão bom. As animações foram bem escolhidas. Além das anim...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html)

### [ModdedSAA (carregar arquivos bloqueados no SAMP)](https://www.mixmods.com.br/2020/01/moddedsaa-carregar-arquivos-bloqueados-no-samp/)
**Data da Publicação:** `2020-01-29`
> SAMP não possibilita modificar alguns arquivos, e esta é a solução. Com este mod .asi instalado, você vai poder carregar mods para os seguintes arquivos no SAMP: HANDLING.CFG VEHICLES.IDE CARMODS.DAT WEAPON.DAT VEHICLE.TXD GTA.DAT TIMECYC.DAT LOADSCS.TXD STREAM.INI Basta instalá-los na pasta “Modded...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/vqvsr7ykuobm/ModdedSAA.7z.html)

### [VW Gol G1 GTI 2000 Turbo](https://www.mixmods.com.br/2020/01/vw-gol-g1-gti-2000-turbo/)
**Data da Publicação:** `2020-01-15`
> Atualizado 15/01/20 zyrowh adaptou para ImVehFt, fez as peças de dano e colocou pinça de freio do GTA V. Um dos carros mais amados pelos brasileiros: o famoso Gol Quadrado. Este é o atual melhor Gol G1 GTI que você encontra para GTA SA. Ele aparecerá nas cores comuns do carro real: vermelho, vinho, ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/uhuafeex1b5x/VW_Gol_G1_GTI_2000_Turbo.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/43501-volkswagen-gol-gti-2000-turbo/)

### [ImVehFt – Improved Vehicle Features](https://www.mixmods.com.br/2020/01/imvehft-improved-vehicle-features/)
**Data da Publicação:** `2020-01-01`
> Atualizado 01/01/20Nova versão não-oficialmente lançada. Sim, sempre existiu desde outubro de 2014.Foi uma atualização enviada para um modelador de carros, na qual corrige alguns bugs (não sabemos quais, diga qualquer coisa). É praticamente o mesmo arquivo da versão 2.1.1 original, só que com um ou ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html)
- [Download / Link](https://sharemods.com/n6y88j5b3tsx/ImVehFt_211.7z.html)
- [Download / Link](https://sharemods.com/p3fgjmintbcm/ImVehFt_211_new_unofficial.7z.html)

### [Snowmobile (SA style)](https://www.mixmods.com.br/2019/12/snowmobile-sa-style/)
**Data da Publicação:** `2019-12-25`
> Snowmobile para GTA San Andreas montado em cima do quadriciclo (quadbike) original do jogo, preservando o estilo original. Infelizmente os “tracks” não são animados. Antes de postar aqui eu (Junior_Djjr) o adaptei para o “f_trifork” do VehFuncs, assim as lâminas na frente viram com o guidão. O arqui...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/x0i8t4lx8ayo/Snowmobile_SA_style.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/bikes/140182-snow-mobile-sa-style/)

### [Rename vehicles (car names.fxt)](https://www.mixmods.com.br/2019/11/rename-vehicles-car-names-fxt/)
**Data da Publicação:** `2019-11-13`
> Já existe mods para renomear os carros do GTA SA facilmente durante do jogo: Vehicle Renamer (renomear carros in-game) Visual Veh Spawner (escolher carros por imagens) Mas a solução deste mod também é super bem vinda e várias pessoas podem preferir. Se trata de um arquivo de texto para você trocar o...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html)

### [NRG-500 Remastered HD by Ezekiel](https://www.mixmods.com.br/2019/10/nrg-500-remastered-hd-by-ezekiel/)
**Data da Publicação:** `2019-10-28`
> Mais um belo trabalho de remasterização do Ezekiel. Uma remasterização da moto NRG-500 do GTA SA, agora em HD. De longe parece a mesma, de perto você nota o quão detalhada ela está, idêntica à original. Eu e _F_ acompanhamos o desenvolvimento realizando testes, e aprendemos muito com este projeto. U...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html)

### [Ford Focus ZX3/SVT 2000-2004 by Avant](https://www.mixmods.com.br/2019/10/ford-focus-zx3-svt-2000-2004-by-avant/)
**Data da Publicação:** `2019-10-03`
> Sem dúvidas, este é o atual carro mais complexo já criado para GTA San Andreas. Imagem do autor: Um Ford Focus do ano 2000-2004 criado pelo Avant convertido do Forza Motorsport 4. Eu acompanhei o desenvolvimento, testando, dando dicas e verificando as adaptações. Nome completo: Ford Focus ZX3/SVT 20...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/133522-ford-focus-zx3-svt-2000-2004-low-high-trim/)

### [Infernus HD Remastered by Ezekiel](https://www.mixmods.com.br/2019/09/infernus-hd-remastered-by-ezekiel/)
**Data da Publicação:** `2019-09-16`
> Nova versão do Infernus remasterizado em HD pelo Ezekiel, melhor do que antes! Infernus remodelado em alta definição, baseado no carro original do jogo, mas com algumas alterações de design. Parece uma versão sucessora do Infernus, como um Infernus 93″. Mesmo que seja uma remasterização, ele quis nã...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html)
- [Download / Link](https://sharemods.com/huo64vpo5wcf/Infernus_HD_Remastered_by_Ezekiel_-_IVF.7z.html)

### [[SA] Improved Original Weapons (mod pack)](https://www.mixmods.com.br/2019/09/improved-original-weapons-mod-pack/)
**Data da Publicação:** `2019-09-01`
> Atualizado 21/04/22Ícones das armas recompilado, assim corrigindo bordas brancas em alguns ícones.Adicionado mira em HD para sniper (criada por mim).Isto é um pack de correções e melhorias para armas, criado inteiramente pela nossa comunidade do Fórum MixMods.A.I. Upscaled Weapon TexturesEste mod tr...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html)

### [Arma Taurus M972/MT12 (brasileira) (lowpoly)](https://www.mixmods.com.br/2019/08/arma-taurus-m972-mt12-brasileira-lowpoly/)
**Data da Publicação:** `2019-08-30`
> Atualização 30/08/19 08:44 Agora vem com ícone de hud personalizado. Outra nova arma brasileira que eu criei para o projeto GTA Brasil, mas como não gosto de exclusividade, está aqui ela separada para vocês, com opção de textura HD. A Taurus MT12 é a pistola-metralhadora padrão da Força Aérea Brasil...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html)

### [IndieVehicles](https://www.mixmods.com.br/2019/08/indievehicles/)
**Data da Publicação:** `2019-08-29`
> IndieVehicles.asi é um mod tool que adiciona algumas independências aos veículos do GTA SA:HandlingTamanho de rodasModelo de colisãoEle substitui o antigo “IndieVehHandlings.cs” usado por alguns mods como Tuning Mod, Real Traffic Fix e Traffic & Travel.Atenção: Este mod está OBSOLETO! Agora ele é in...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html)
- [código-fonte](https://github.com/JuniorDjjr/IndieVehicles)

### [ImGui (interface gráfica para MoonLoader)](https://www.mixmods.com.br/2019/08/imgui-interface-grafica-para-moonloader/)
**Data da Publicação:** `2019-08-26`
> Atualizado 12/11/19 Adicionado opção para a versão antiga pois alguns mods antigos só funcionam nela e ainda precisam ser atualizados. Atualizado 26/08/19 O mod passou por atualizações (atualmente na v1.1.5). Não sei quais foram as mudanças (não tô afim de procurar por isso em fóruns russos). Mas é ...
**Links de Referência / Download:**
- [de um projeto open source](https://github.com/ocornut/imgui)
- [Clique aqui e veja todas as possibilidades!](https://user-images.githubusercontent.com/8225057/29072770-aef614e2-7c7b-11e7-8861-212c2c416439.png)
- [Download / Link](https://sharemods.com/3duli5cpn9bb/ImGui.7z.html)
- [Download / Link](https://sharemods.com/nync1aknfgwq/ImGui.7z_1.1.2.7z.html)

### [Low Life Animation v1.2.2 (animação de saúde baixa)](https://www.mixmods.com.br/2019/07/low-life-animation-v1-2-2-animacao-de-saude-baixa/)
**Data da Publicação:** `2019-07-12`
> Atualizado 09/10/19 Corrigido a animação se repetindo quando anda agachado. Atualizado 18/08/19 Corrigido a animação se repetindo junto com a animação do CJ cansado. Atualizado 12/07/19 Corrigido incompatibilidade com mods de recarregar armas, como Reload Mod. Corrigido o CJ não perdendo vida enquan...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/0cf8a63f63a9ed81c5b35aa44f3d66c9)

### [Tuning Mod v3.0.1](https://www.mixmods.com.br/2019/06/tuning-mod/)
**Data da Publicação:** `2019-06-23`
> Veja aqui as principais novidades do TMv3!TMv3 é um mod cleo de tuning sandbox onde o limite é a sua criatividade.Se trata do meu (Junior_Djjr) atual maior projeto, algo que iniciei em 2012 e se tornou o maior mod cleo do mundo.Você pode adicionar literalmente qualquer modelo em qualquer veículo!Qua...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html)

### [Kawasaki Ninja H2R 2019](https://www.mixmods.com.br/2019/06/kawasaki-ninja-h2r-2019/)
**Data da Publicação:** `2019-06-12`
> Que tal experimentar a moto mais rápida do mundo no GTA San Andreas? Se trata da Kawasaki Ninja H2R 1000cc, mais veloz que um carro de F1, e um caça. (é a segunda mais rápida caso considerar a Tomahawk). Adaptada ao VehFuncs: Pezinho (parking legs) Pedaleiras (footpegs) Ventoinha Escapamento vibrand...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/bikes/133207-kawasaki-ninja-h2-r-2019-v2-0/)

### [Panic Face (expressão facial nos pedestres)](https://www.mixmods.com.br/2019/05/panic-face-expressao-facial-nos-pedestres/)
**Data da Publicação:** `2019-05-18`
> Atualizado 18/05/19 Mod recriado em .asi. Foi relatado crash com este mod instalado, recriei o mod e acredito que o problema foi corrigido. O desempenho também ficou muito melhor do que em cleo. Avisem caso encontrar problemas. Um mod pequeno que criei que re-adiciona uma feature removida da versão ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/kah8arfbnvx0/Panic_Face.7z.html)

### [Revive Friend (reanimar parceiro)](https://www.mixmods.com.br/2019/05/revive-friend-reanimar-parceiro/)
**Data da Publicação:** `2019-05-06`
> Você acha chato quando sua gangue morre muito rápido e você não pode fazer nada para evitar? E quando você está jogando em modo coop (2 jogadores) com um amigo e tem que voltar tudo quando um dos jogadores morre? Aqui está um mod cleo para reanimar membros de gangue recrutados ou um dos jogadores … ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/8zyh3jyrt3hs/Revive_Friend_-_Junior_Djjr.7z.html)
- [[1]](https://gist.github.com/JuniorDjjr/874671b522258af0e7a94c4e1891bcac)
- [[2]](https://gist.github.com/JuniorDjjr/5ce3e71582c3d0116c7c9ebee61fb0ff)

### [Sly’s Veh Textures Unofficial Build v1 (vehicle.txd HD)](https://www.mixmods.com.br/2019/04/slys-veh-textures-unofficial-build-v1-vehicle-txd-hd/)
**Data da Publicação:** `2019-04-27`
> Indicado por Zangy e outros. O arquivo vehicle.txd é onde é armazenado as texturas genéricas compartilhadas entre todos os veículos do jogo. Ou seja, basta baixar um mod para ele que quase todas as texturas de todos os carros do jogo ficarão mais definidas! (os que usam elas) Este é um dos melhores ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/2sny0oq1g1m6/Sly_Veh_Textures_Unofficial_Build.7z.html)

### [Change Gear Anim v3.2 (animação de mudar marcha)](https://www.mixmods.com.br/2019/04/change-gear-anim-mudar-marcha/)
**Data da Publicação:** `2019-04-04`
> Atualizado 30/01/20 02:20Mod atualizado para CLEO+. Agora a animação funcionará corretamente mesmo em missões e não causará confusões em outros mods. Na teoria o bug dos bombeiros e ambulâncias não chegando no destino também foi corrigido.Um mod cleo que faz uma animação trocando de marcha.Funciona ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/cuews8z5k6ew/Change_Gear_Anim.7z.html)

### [Mod Airsoft + Glock 18C](https://www.mixmods.com.br/2019/04/mod-airsoft-glock-18c/)
**Data da Publicação:** `2019-04-02`
> Atualizado 06/08/19 04:17 Corrigido um crash que acontece ocasionalmente durante o jogo (mesmo sem usar a arma). Atualizado 04/04/19 15:52 Melhorada a textura da versão SA Style. Atualizado 02/04/19 14:37 Corrigido potenciais incompatibilidades com alguns mods. Especialmente com algumas funções da p...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/nt2bhj7tspt9/Airsoft_Glock_18C.7z.html)
- [Download / Link](https://sharemods.com/3v5gw8ojitsi/Glock_18C.7z.html)

### [Gangs Relationships](https://www.mixmods.com.br/2019/03/gangs-relationships/)
**Data da Publicação:** `2019-03-06`
> Uma ideia simples e legal: A gangue que você mais odeia, mais vai te odiar! O mod usa um stat nativo do jogo que define qual a gangue que você tem mais treta, e assim aplica uma função da inteligência artificial que causa “hate” (ódio) contra você, enquanto as outras gangues ficam como “dislike” (nã...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/sjhzmtv05o0t/Gangs_relationships.7z.html)

### [BeSlim (opções para o CJ musculoso e gordo)](https://www.mixmods.com.br/2019/03/beslim-opcoes-para-o-cj-musculoso-e-gordo/)
**Data da Publicação:** `2019-03-05`
> Atualizado 01/08/20Versão de PS2 recriada, corrigido 2 crashes. Atualizado 05/03/19 Mod convertido para .asi, pois para algumas pessoas o cleo era iniciado após a construção do player, portanto o mod não funcionava. Com .asi não existe este problema. Adicionado possibilidade de desativar a textura d...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zzblq4idkq1p/BeSlim.7z.html)
- [Download / Link](https://drive.google.com/file/d/1otcc6HbXeJJAW6ZuNorNAmr7VBZxmk4c/view?usp=sharing)

### [Land Mines (minas terrestres)](https://www.mixmods.com.br/2019/02/land-mines-minas-terrestres/)
**Data da Publicação:** `2019-02-26`
> Atualizado 28/02/19 Fiz uma pequena correção de tradução (você mesmo pode corrigir abrindo o .fxt no bloco de notas). Provavelmente o GTA SA teria minas terrestres funcionais (há um objeto de mina terrestre nunca usado no jogo). Este mod reativa a funcionalidade em forma de pickups, onde você coleta...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/cp2ftd9u0re3/Land_Mines.7z.html)

### [[Tutorial] Adicionar armas sem substituir](https://www.mixmods.com.br/2019/02/tutorial-adicionar-armas-sem-substituir/)
**Data da Publicação:** `2019-02-05`
> Atualizado 09/10/21Adicionado Custom Ammunation para poder comprar as armas adicionadas.Veja também: [Tutorial] Adicionar CARROS sem substituir.Simples, direto, eficaz. Agora você pode adicionar armas, sem substituir!Seja armas de fogo, brancas etc!Usando Mod Loader! Se você caiu de para-quedas aqui...
**Links de Referência / Download:**
- [Clique para baixar armas na MixMods!](http://www.mixmods.com.br/search/label/Armas%20B%C3%A1sicas?&amp;max-results=7)

### [Car Kick (chutar motorista pela janela do carro)](https://www.mixmods.com.br/2019/02/car-kick-chutar-motorista-pela-janela-do-carro/)
**Data da Publicação:** `2019-02-01`
> Mod cleo inspirado no “bo-duke-en” do Saint’s Row. Chegando correndo pelo lado do motorista, faça o comando para o CJ se jogar pela janela do carro, jogando o motorista pela outra porta assim roubando o carro de maneira rápida. ‎Script: AguiaX2 Animação: Saga Recomendado usar Bullet Physics Ragdoll....
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/hiy3o47xxd7w/Car_Kick.7z.html)

### [Kawasaki Z1000 A1 1977](https://www.mixmods.com.br/2019/01/kawasaki-z1000-a1-1977/)
**Data da Publicação:** `2019-01-28`
> Atualizado 28/01/19 Agora com versão opcional adaptada ao IVF! Agora as texturas incluem mip-mapping e foi corrigido a resolução duma delas. Uma das motos para GTA SA mais bem feitas que já vi. Modelo e texturas ótimas e leve, num estilo que combina com o jogo. Ainda mais para o Tuning Mod, onde con...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/9fu5fbdw3e5h/Kawasaki_Z1000_A1_1977.7z.html)

### [Plymouth Belvedere Station Wagon 1965 by Avant](https://www.mixmods.com.br/2019/01/plymouth-belvedere-station-wagon-1965-by-avant/)
**Data da Publicação:** `2019-01-21`
> Um dos melhores carros já criados para GTA San Andreas, muito semelhante ao Perennial. Ele inclui todas as atuais possíveis adaptações, sendo um trabalho a beira do perfeito. Se você já viu antes, esta é uma nova versão. Placas funcionais; Handling próprio realista; colisão, sombras e LOD próprios; ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/vj9mky5k373a/Plymouth_Belvedere_Station_Wagon_1965_by_Avant.7z.html)
- [Origem](https://www.gtainside.com/en/sanandreas/cars/124940-plymouth-belvedere-station-wagon-1965/)

### [Anim Play v2.0 (tocar animações)](https://www.mixmods.com.br/2019/01/anim-play-v2-0-tocar-animacoes/)
**Data da Publicação:** `2019-01-19`
> Atualizado 19/01/19 Agora cada configuração de animação fica em um arquivo .ini separado com nome personalizado. Assim o mod está muito mais prático de configurar e compartilhar configurações. Agora é possível utilizar sequências de 3 animações (foi pensado nas animações in-loop-out, por exemplo se ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/1pshm7jmw1tf/Anim_Play.7z.html)

### [Surrender Mod (se render / se entregar)](https://www.mixmods.com.br/2019/01/surrender-mod-se-render-se-entregar/)
**Data da Publicação:** `2019-01-12`
> Atualizado 05/11/19 Corrigido o mod se ativando somente com 1 tecla, era para se ativar com as duas. Nunca estive feliz com os atuais mods de se render para a polícia, portanto eu (Junior_Djjr) fiz um utilizando uma animação muito legal criada pelo jojo2971. Com nível de procurado, você pode fazer u...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/8dy2ncqtysbg/Surrender.7z.html)
- [Source code](https://gist.github.com/JuniorDjjr/86f74658f9bcce1082ad028e6cdd7417)

### [Original Weapons Fix 2.0 + Retex (corrigir posição das armas)](https://www.mixmods.com.br/2018/12/original-weapons-fix-retex/)
**Data da Publicação:** `2018-12-12`
> Atualizado 14/12/19Novo detonador corrigido.Atualizado 12/12/18Adicionado novas texturas do camil1999 (mod Weapon Retex).Taco de baseball originalmente foi retexturizado para de madeira, trocado para de alumínio (como o original do jogo).Extintor corrigido.Re-adicionado o gunflash 3D (se você não qu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/b8q8e55loi0q/Original_Weapons_Fix___Retex.7z.html)

### [VW Gol G2 1.0 Plus (bola) by Dean 3D](https://www.mixmods.com.br/2018/11/vw-gol-g2-1-0-plus-bola-by-dean-3d/)
**Data da Publicação:** `2018-11-23`
> Já faz muito tempo que estou segurando ele pois ainda falta coisas para fazer, mas vou liberar agora para qualquer um que queira terminá-lo… O modelo de Gol G2 mais fiel que já vi na vida! O carro que é um símbolo brasileiro: o famoso Gol bolinha. Atualmente tenho ele na vida real (outro modelo) e …...
**Links de Referência / Download:**
- [renders do Dean 3D mas sempre sem download](http://eq-kikiavelinho.blogspot.com/2014/04/vw-gol-g2-plus-10-1997-by-dean-3d.html)
- [Agradecimentos ao Lucas Macedo por me passar o download](https://web.facebook.com/groups/tuningmod/permalink/875086222689863/)
- [Download / Link](https://sharemods.com/vf80kq9lsrhq/VW_Gol_G2_1.0_Plus___40_bola__41__by_Den_3D.7z.html)

### [Correr com armas pesadas (correr com rifle)](https://www.mixmods.com.br/2018/10/correr-com-armas-pesadas-correr-com-rifle/)
**Data da Publicação:** `2018-10-30`
> Atualizado 18/08/19 Ou o autor da animação de musculoso se enganou, ou fomos enganados: o .ifp que vinha no mod vinha com um monte de animações do CJ dançando. Não aparenta causar crash pois ele era ignorado. Enfim, simplesmente removi do download, se você tem este mod instalado, apague o “muscular....
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html)

### [Handbrake Mod [sound + anim] (freio de mão com som e anim)](https://www.mixmods.com.br/2018/09/handbrake-mod-sound-anim-freio-de-mao-com-som-e-anim/)
**Data da Publicação:** `2018-09-13`
> Atualizado 26/10/19 Agora o volume do som segue a configuração do menu. Baseado no antigo mod de travar o freio de mão, eu criei este por pedido (também pois eu achei melhor), onde não trava, mas tem a animação e som de puxar o freio de mão do carro. Ou seja, ao segurar o botão/tecla … Ler mais...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html)
- [source code](https://gist.github.com/JuniorDjjr/1439256d6327fc7de89d08ac3d1a9ab5)

### [Espingarda boito caipira (country bolt rifle) (lowpoly)](https://www.mixmods.com.br/2018/09/espingarda-boito-caipira-country-bolt-rifle-lowpoly/)
**Data da Publicação:** `2018-09-07`
> Uma espingarda bem rural, ou “country side“, que eu (Junior_Djjr) modelei, combinando tanto para um lado americano quanto para brasileiro. É um estilo de espingarda super comum pelo mundo e muito usada para a caça de animais. Mesmo que pareça tão realista, o modelo (.dff) tem somente 50 KB de peso. ...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html)

### [Pack de Armas do Combat Arms](https://www.mixmods.com.br/2018/08/pack-de-armas-do-combat-arms/)
**Data da Publicação:** `2018-08-17`
> Pack de armas do jogo Combat Arms convertido pelo Mystertv. As armas são low poly e combinam bem com o padrão original do jogo, sendo assim ótimo para quem gosta do estilo vanilla mas quer variar um pouco (e porquê não adicionar sem substituir?). O pack vem com 17 armas, elas estavam com compressão ...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1VgA-z5reCSf0NQDIMuP_pinkftjWKj1w/view?usp=sharing)

### [1964 Chevrolet Impala SS Lowrider v2.1](https://www.mixmods.com.br/2018/07/1964-chevrolet-impala-ss-lowrider-v2-1/)
**Data da Publicação:** `2018-07-30`
> O melhor modelo de Chevrolet Impala (Savanna) para GTA SA que você encontrará. O carro tem um dos melhores reflexos cromados já que vi. Veja como os cromados ficam em diferentes configurações do SkyGfx: — abra em nova aba para ver melhor — O carro é muito detalhado, portanto bem pesado: 9,6 MB de .d...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html)
- [Fonte](https://www.gtainside.com/en/sanandreas/cars/81229-1964-chevrolet-impala-ss-v2-1/)

### [Beta Cars Pack (carros da versão beta)](https://www.mixmods.com.br/2018/07/beta-cars-pack-carros-da-versao-beta/)
**Data da Publicação:** `2018-07-21`
> Um pack de praticamente todos os carros da versão beta do GTA San Andreas! São 105 arquivos! Substitui vários veículos e peças tuning com base nas imagens pulicadas durante a versão beta do GTA SA (antes do lançamento). Nem todos são legais, virá alguns no estilo do GTA Vice City que não combina com...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html)

### [Rainbow Weapons (armas coloridas animadas)](https://www.mixmods.com.br/2018/07/rainbow-weapons-armas-coloridas-animadas/)
**Data da Publicação:** `2018-07-18`
> Mods criativos são sempre muito bem vindos!Este mod asi deixa as armas com cores RGB animadas; um arco-íris.Veja o vídeo ao autor:Para ter o brilho (bloom) como no vídeo é necessário usar e configurar o ColorMod.O mod foi criado com foco em SAMP, portanto funciona nele sem problemas. Caso você use S...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/vm0zc1olju4k/Rainbow_Weapons.7z.html)

### [LQ Wheels (rodas tuning lowpoly / SA Style)](https://www.mixmods.com.br/2018/07/lq-wheels-rodas-tuning-lowpoly-sa-style/)
**Data da Publicação:** `2018-07-16`
> Indicado por ViniZ0ZUm pack que substitui todas as rodas tuning do jogo por novas no mesmo estilo original do GTA SA! Perfeito para quem quer dar um novo visual ao jogo continuando no mesmo estilo. Foi criado focado no SAMP com estilos visuais de 1970~2000.As rodas são mais definidas e redondas do q...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html)
- [Origem](https://libertycity.net/files/gta-san-andreas/118356-new-lq-wheels-part-2.html)

### [Honda CRX by AllCash (tunable – tunável)](https://www.mixmods.com.br/2018/07/honda-crx-by-allcash-tunable-tunavel/)
**Data da Publicação:** `2018-07-05`
> É isto mesmo, o Blista Compact da vida real!Se trata do Honda CR-X segunda geração (no entanto o Blista tem a frente mais semelhante à primeira geração).Um modelo de ótima qualidade e leve: 2,5 MB de .dff e 1,6 MB de .txd (incluindo mip-mapping e otimizações aplicadas por mim).Algo interessante é qu...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html)

### [Big Gangster Mod v5](https://www.mixmods.com.br/2018/06/big-gangster-mod-v5/)
**Data da Publicação:** `2018-06-29`
> Atualizado Baixe o Big Gangster Mod v8 aqui! Este mod é para quem realmente gosta de guerra de gangues! Serão adicionadas mais gangues pelo estado inteiro de San Andreas, fazendo com que você possa disputar territórios em Las Venturas e San Fierro também. As gangues padrões do jogo também foram modi...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html)

### [Se jogar para esquivar de carros](https://www.mixmods.com.br/2018/06/se-jogar-para-esquivar-de-carros/)
**Data da Publicação:** `2018-06-25`
> Com este mod lua o CJ poderá se jogar quando um carro estiver vindo em direção a ele. Vídeo demo: Basta apenas apertar o botão de pular quando um carro estiver vindo em sua direção e o CJ se jogará para não ser atropelado. O mod é baseado no GTA Vice City, que também possui … Ler mais...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html)

### [Pack de armas e sons do Fortnite](https://www.mixmods.com.br/2018/06/pack-de-armas-e-sons-do-fortnite/)
**Data da Publicação:** `2018-06-23`
> Este mod irá converter algumas armas e sons das armas do jogo Fortnite. Os sons não são extremamente realistas, para combinar um pouco com o jogo que não é tão ‘sério’ quanto Battlegrounds, desde a arte do jogo, que é meio cartoon. Os sons possuem um efeito de eco legal se afastando aos poucos. Virã...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/4q0zw5rsc74h/Fortnite_Pack.7z.html)

### [Animações de Kung Fu melhoradas](https://www.mixmods.com.br/2018/06/animacoes-de-kung-fu-melhoradas/)
**Data da Publicação:** `2018-06-10`
> Este mod irá melhorar as animações de Kung Fu do jogo. Irá trocar basicamente todas as animações por novas e mais compatíveis com o Kung Fu real, com animações convertidas do jogo Metal Gear Rising. As mais legais são as das prints, que são uma nova voadora e uma espécie de carrinho/rasteira. O mod ...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html)

### [SASD Carpack by MCHammer (pack polícia SA Style)](https://www.mixmods.com.br/2018/05/sasd-carpack-by-mchammer-pack-policia-sa-style/)
**Data da Publicação:** `2018-05-22`
> Um pack de carros de polícia lowpoly / sa style, substituindo o carro da polícia de LS (copcarla), SF (copcarsf), LV (copcarvg) e rural (copcarru). Encontrar um pack assim lowpoly no estilo original do jogo é difícil, ainda mais adaptado ao Improved Vehicle Features! E isso aí, todos os carros têm l...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html)

### [EnhFuncs – Desert Eagle Mark XIX](https://www.mixmods.com.br/2018/05/enhfuncs-desert-eagle-mark-xix/)
**Data da Publicação:** `2018-05-21`
> Arma convertida em alta qualidade e muito bem adaptada para o EnhFuncs. Será adaptada a função de slide cover para o EnhFuncs, que fará com que ao atirar o “ferrolho” da arma vá para trás. Necessário baixar o EnhFuncs para funcionar. Vídeo demo: ‎Autor: Jean Oliveira...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html)

### [Mount Akina + Toyota AE86 Trueno](https://www.mixmods.com.br/2018/05/mount-akina-toyota-ae86-trueno/)
**Data da Publicação:** `2018-05-14`
> Este mod irá trazer a pista de drift do Monte Akina para o GTA SA. do you like my car? A pista é originalmente baseada no Monte Haruna, localizado no Japão, e graças ao anime Initial D se tornou conhecida mundialmente. É um local excelente para quem gosta de drift ou mesmo para quem gosta de … Ler m...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/d1ougyt80b8r/Mount_Akina___Toyota_AE86.7z.html)

### [CJ reclama com carros](https://www.mixmods.com.br/2018/04/cj-reclama-com-carros/)
**Data da Publicação:** `2018-04-25`
> Atualizado! Script corrigido, agora o mod funcionará em missões, agradecimentos ao Junior_Djjr e todos que avisaram; Antes missões falhavam sem motivo entre outros bugs acontecendo, incluindo bugs e crashes em certos mods cleo. Este mod fará com que o CJ reaja quando um carro chegar muito perto dele...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html)

### [London Cabbie](https://www.mixmods.com.br/2018/04/london-cabbie/)
**Data da Publicação:** `2018-04-24`
> Este mod irá trazer um táxi diferente para o jogo, baseado no Perennial e no Hustler. Ele dará uma aparência diferente e talvez mais agradável do que o Cabbie original do jogo, misturando a dianteira do Perennial e a traseira do Hustler. Ele realmente dá um clima de clássico, dando a impressão de al...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/lzxs1w77ffh6/London_Cabbie.7z.html)

### [Ganados v2.0 (Mod Resident Evil 4)](https://www.mixmods.com.br/2018/04/ganados-v2-0-mod-resident-evil-4/)
**Data da Publicação:** `2018-04-08`
> Praticamente todos aqui sentem nostalgia com o jogo Resident Evil 4, né? Este mod te faz lembrar desse incrível jogo. Haverá uma casa convertida do RE4 no deserto de Bone County, entrando lá você entrará numa pequena missão para matar os ganados. Toda a “missão” inclui os áudios do jogo. O mod é ráp...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/bgd4a3kbdjfw/Ganados__Mod_Resident_Evil_4_.7z.html)

### [GTA V Online Original Anims to SA (animações do GTA Online)](https://www.mixmods.com.br/2018/03/gta-v-online-original-anims-to-sa-animacoes-do-gta-online/)
**Data da Publicação:** `2018-03-29`
> Indicado por Hugo Sene Mod que traz animações semelhantes ao GTA V para o GTA San Andreas. O mod teve mais de 100 mil downloads e nota 9,6/10 na GTA Inside, e como o autor diz, “estas são as melhores animações que você pode encontrar na internet”, “criadas com detalhismo para você sentir o espirito ...
**Links de Referência / Download:**
- [O mod teve mais de 100 mil downloads e nota 9,6/10 na GTA Inside](http://3.bp.blogspot.com/--GC198ja7sA/Wr1SUfv-FdI/AAAAAAAARVo/sAHZcgWzQvUSy6j4ZjqwY_LFk0c5g8GXACK4BGAYYCw/s1600/0.jpg)
- [Download / Link](http://sharemods.com/2yhtn7ed2utl/GTA_Online_Anims.7z.html)

### [Parkour Mod v2.0.4 Unofficial Fix](https://www.mixmods.com.br/2018/03/parkour-mod-v2-0-4-unofficial-fix/)
**Data da Publicação:** `2018-03-20`
> Indicado por yunggoth O atual melhor mod de parkour! 25 animações para fazer por comandos. Também inclui um ped.ifp com animações de queda estilo parkour. Se você já usa algum mod de ped.ifp, siga o tutorial de misturar .ifp. As animações são boas baseado na média de mods do gênero, mas infelizmente...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html)
- [source code](https://gist.github.com/JuniorDjjr/938702256ac9932ca7550660066782e2)

### [Trator Valtra 685 + carreta (SA Style)](https://www.mixmods.com.br/2018/03/trator-valtra-685-carreta-sa-style/)
**Data da Publicação:** `2018-03-17`
> Atualizado v1.1 Adaptado ao Gang Rider: Agora você pode dar carona para seus membros de gangue no trator ou na carreta! Mais correções de física para a carreta. Basicamente o primeiro carro que eu modelo! Na verdade, um trator brasileiro! Um clássico Valtra 685, um dos tratores mais comuns do Brasil...
**Links de Referência / Download:**
- [novo sistema de extras](https://github.com/JuniorDjjr/VehFuncs/wiki/%5BPT%5D-Extras-Recursivos)
- [Download / Link](http://sharemods.com/wpmcvchn1nly/Trator_Valtra_685___carreta__SA_Style_.7z.html)

### [Infernus HD by Ezekiel](https://www.mixmods.com.br/2018/03/infernus-hd-by-ezekiel/)
**Data da Publicação:** `2018-03-07`
> Atenção:Nova versão lançada! Recriado do zero, agora melhor, mais leve, mas com design um pouco diferente.Clique para baixar o Infernus HD Remastered by EzekielO inesperado aconteceu: Ezekiel (do Insanity) modelando carros.O objetivo foi criar um Infernus remasterizado em alta definição continuando ...
**Links de Referência / Download:**
- [Clique para baixar o Infernus HD Remastered by Ezekiel](https://www.mixmods.com.br/2019/09/infernus-hd-remastered-by-ezekiel.html)
- [Download / Link](http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html)

### [Pack de armas do Battlegrounds](https://www.mixmods.com.br/2018/02/pack-de-armas-do-battlegrounds/)
**Data da Publicação:** `2018-02-09`
> Este mod irá trazer um pack de armas convertidas do Playerunknown’s Battlegrounds. prints do Pedro O PUBG é um dos jogos mais jogados da atualidade e possui algumas armas interessantes, este mod irá converter cinco delas. Serão elas: AKM, HK416, UMP-45, Kar98k e a pistola P92. As armas são muito bem...

### [Shotgun Reload (espingarda recarregando)](https://www.mixmods.com.br/2018/02/shotgun-reload-espingarda-recarregando/)
**Data da Publicação:** `2018-02-03`
> Você com certeza já percebeu que a espingarda (doze) atira sem nunca recarregar. Não mais com este mod! Agora após 8 tiros, o CJ recarrega a espingarda (com animação própria do jogo), tocado por um script CLEO. ‎Autor: thalilmythos Atenção: Um mod melhor foi criado!More Realistic Reload Weapon Anima...
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html)

### [Bar Drink (mod beber no bar / ficar bêbado)](https://www.mixmods.com.br/2018/01/bar-drink-mod-beber-no-bar-ficar-bebado/)
**Data da Publicação:** `2018-01-16`
> Atualizado Agora o mod está disponível em 15 bares! Basicamente todos os bares do jogo, incluindo EHI. Um projeto iniciado pelo BiPolarBear que decidi me intrometer recriando um script melhor e mais dinâmico. A ideia por trás do mod é possibilitar beber em todos os bares do jogo. Você pode andar com...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view)

### [Animações do GTA VCS/LCS](https://www.mixmods.com.br/2017/12/animacoes-do-gta-vcs-lcs/)
**Data da Publicação:** `2017-12-26`
> Mod que irá converter algumas animações dos jogos GTA Vice City Stories e Liberty City Stories. É um mod para quem tem mais pressa de jogar e quer movimentos rápidos. Estão incluídas animações de andar com uma pistola e correr com rifles, RPG e até minigun. O modo de correr sem arma também foi mudad...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0)

### [Arremessar facas ou katanas](https://www.mixmods.com.br/2017/12/arremessar-facas-ou-katanas/)
**Data da Publicação:** `2017-12-06`
> Com este mod cleo será possível arremessar sua faca ou sua espada katana em outras pessoas. Bastará parar a frente ou atrás de um pedestre e tentar acertá-lo, caso erre a mira a arma irá passar reto e não será possível recuperá-la. Os pedestres terão animações diferentes de serem acertados dependend...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9)

### [Arma IMBEL IA2 (brasileira) (lowpoly)](https://www.mixmods.com.br/2017/12/arma-imbel-ia2-brasileira-lowpoly/)
**Data da Publicação:** `2017-12-03`
> Atualizado Adicionado ícone personalizado. A atual arma adotada pelo nosso exército brasileiro! IA2 é um fuzil de assalto fabricado pela IMBEL (Indústria de Material Bélico do Brasil) de tecnologia 100% nacional, onde decidi modelar para a TC GTA Brasil e, assim como a FN FAL, estou adiantando para ...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view)

### [M4k3’s New Car Animations – Novas animações ao dirigir](https://www.mixmods.com.br/2017/11/m4k3s-new-car-animations-novas-animacoes-ao-dirigir/)
**Data da Publicação:** `2017-11-15`
> Um mod que irá trocar e corrigir algumas animações feitas pelo CJ quando ele está dirigindo um veículo. Entre as correções, há uma nova animação no assento do veículo, evitando que as pernas do CJ ultrapassem o capô do veículo e uma nova animação ao dar ré tanto em carros quanto em caminhões, onde o...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO)

### [Max Payne Mod](https://www.mixmods.com.br/2017/11/max-payne-mod/)
**Data da Publicação:** `2017-11-07`
> Este mod irá trazer alguns recursos do Max Payne para o GTA SA como o Shootdodge e o Bullet Time, marcas icônicas da série. No Shootedge será possível pular para desviar das balas, você pode usá-lo ao mesmo tempo que usa o Bullet Time, onde o tempo desacelera e você pode atirar em outros durante o …...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=1zgWe0bejROV0cdFQDR6zTr0-E7zK2bKD)

### [Amazing Player: Female v2.0 (skin feminina)](https://www.mixmods.com.br/2017/10/amazing-player-female-v2-0-skin-feminina/)
**Data da Publicação:** `2017-10-30`
> Atenção: Nova versão do mod! Clique para baixar o Amazing Player: Female [REMASTERED] 1 em cada 10 visitantes do blog são mulheres, e várias preferem jogar com player mulher… mas também vários homens também preferem (por que será?). Várias pessoas indicaram postá-la aqui no blog, já havia uma, mas e...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYNjhwLXFQTWFneG8/view)

### [Pack de Skins da AK-47 do CS:GO](https://www.mixmods.com.br/2017/10/pack-de-skins-da-ak-47-do-csgo/)
**Data da Publicação:** `2017-10-22`
> Pack de armas que traz a AK-47 do CS:GO com todas as suas skins até a update que introduziu a Hydra Case. São 26 skins disponíveis, todas com normal map e algumas como a skin Fuel Injector têm normal map próprio. ‎Autor: ThePedro004 (Conversão)...

### [Pose Mod (beta)](https://www.mixmods.com.br/2017/10/pose-mod-beta/)
**Data da Publicação:** `2017-10-13`
> Atualizado Finalmente me dediquei um tempinho ao mod: Possibilidade de salvar ou carregar poses salvas (arquivos .pose). O sistema é o mesmo do Tuning Mod. Interface gráfica com algumas informações, incluindo o nome do bone. Adicionado câmera orbital (ative pressionando “V”), onde você rotaciona por...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html)

### [Explosivo TNT (relógio com detonador)](https://www.mixmods.com.br/2017/10/explosivo-tnt-relogio-com-detonador/)
**Data da Publicação:** `2017-10-08`
> Atualizado! Versão em Lua incluída no post. A versão cleo tem gambiarras que são corrigidas na versão em Lua (necessário MoonLoader e MoonAdditions). Este mod irá adicionar uma nova arma ao jogo: um explosivo TNT. Ele conta com um contador de tempo e possui áudios acompanhando, podendo configurar al...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc)
- [Download / Link](https://drive.google.com/open?id=0B04D_5yMCyl9YlFVTWZLaVkySDg)

### [AK74 do Contract Wars](https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/)
**Data da Publicação:** `2017-08-13`
> Uma AK-74 convertida do jogo Contract Wars, mostrada no post do Reshade, assim como a Glock-17 que também foi postada aqui anteriormente. A arma tem detalhes com fita adesiva azul e um pano na coronha, o que deixa ela um pouco mais única e com aparência de uma arma mais desgastada. Ela também vem co...

### [Microphone Talk (mexer a boca ao falar no microfone)](https://www.mixmods.com.br/2017/08/microphone-talk-mexer-a-boca-ao-falar-no-microfone/)
**Data da Publicação:** `2017-08-04`
> Novo mod cleo meu simples e divertido que traz uma nova funcionalidade pro jogo: o CJ mover a boca quando você fala no microfone do PC. É uma ideia que eu já tinha pensado antes, mais recentemente Ziltronic me lembrou e hoje fiz. Outro detalhe engraçado é que você chama atenção das pessoas quando fa...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view)
- [veja o source code](https://gist.github.com/JuniorDjjr/eb6e5685768cca1c0db66ce1f8f85a0d)

### [Parachute Randomizer (variar para-quedas)](https://www.mixmods.com.br/2017/07/parachute-randomizer-variar-para-quedas/)
**Data da Publicação:** `2017-07-31`
> Pra quê ter 1 se você pode ter 16 / 24 para-quedas instalados ao mesmo tempo? São 16 mochilas e 24 parapentes diferentes. (inclui um da “BMS” em nossa homenagem) Eles mudam aleatoriamente quando você entra no jogo e a cada 1 hora passada no relógio (caso você não já esteja com um paraquedas). Para i...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view)

### [Hit the Entity Fix (Bater na parede)](https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/)
**Data da Publicação:** `2017-07-21`
> Esse mod fará com que o CJ simplesmente bata na parede ou obstáculo ao caminhar em direção a eles, e não fique correndo parado. Um script bem simples.O CJ fará uma animação ao ser acertado pela parede, voltando para trás na hora. O mod se ativa em veículos também por padrão, assim o CJ fará … Ler ma...

### [Extended Gang Wars](https://www.mixmods.com.br/2017/07/extended-gang-wars/)
**Data da Publicação:** `2017-07-13`
> Atualizado 01/03/20 Post tualizado por Junior_Djjr Corrigido um overflow aritmético quando mais de 255 territórios pertencem à mesma gangue. Corrigida a classificação das estatísticas para favorecer à Grove St Families, como é por padrão. Este mod possibilita configurar como as gangues do GTA SA fun...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html)

### [Visual Weapon Spawner](https://www.mixmods.com.br/2017/06/visual-weapon-spawner/)
**Data da Publicação:** `2017-06-29`
> Se temos um Visual Car Spawner, por que não um Visual Weapon Spawner? Com o mod, você pode pegar armas clicando nos ícones, simplesmente usando o mouse. Adicionalmente também é possível pegar o jetpack e celular. Até o momento é só isso, não é possível adicionar novas armas à tela (como o Visual Car...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html)

### [Ladders – Subir e descer escadas](https://www.mixmods.com.br/2017/03/ladders-subir-e-descer-escadas/)
**Data da Publicação:** `2017-03-27`
> Atenção:Foi criado um novo mod muito melhor![SA] Ladders Mod (subir escadas)Mais um mod saindo do Fórum da BMS.Quem nunca caiu no mar por volta do Aeroporto Easter Bay em SF e teve que dar uma volta gigante para voltar à terra pois não é possível acessar a escada do local que atire a primeira pedra....
**Links de Referência / Download:**
- [Download / Link](http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html)

### [Colocar/tirar silenciador da 9mm](https://www.mixmods.com.br/2017/03/colocar-tirar-silenciador-da-9mm/)
**Data da Publicação:** `2017-03-18`
> Este mod irá permitir que ao você carregar uma 9mm o CJ coloque ou tire o silenciador dela. O mod conta com animação própria e pode ser ativado tanto parado, quanto agachado ou correndo. O mod ainda conta com um som próprio ao encaixar ou desencaixar o silenciador. O mod não é feito através de … Ler...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk)

### [No Dual Wield + Segurar pistola com duas mãos](https://www.mixmods.com.br/2017/03/no-dual-wield-segurar-pistola-com-duas-maos/)
**Data da Publicação:** `2017-03-17`
> Atualizado v1.1 A correção antiga ainda tinha possibilidade de crashar caso outra pessoa mirar em você. Resolvi fazer de outro modo: Um pequeno mod cleo de 14 bytes que fará todo o serviço… Agora não precisa mais editar o seu default.ide e não tem mais nenhuma chance de crash. Dica: Configure o Peds...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html)

### [Bloodz & CripZ (Remake)](https://www.mixmods.com.br/2016/06/bloodz-cripz-remake/)
**Data da Publicação:** `2016-06-26`
> Um mod pra quem gosta de realismo, que troca as cores das gangues Grove e Ballas para as cores reais das gangues em que foram inspiradas, os Bloods e os Crips.Um mod que eu particulamente achei legal quando vi pela primeira vez foi o Bloodz & Cripz, mas quando eu baixei me deparei com texturas … Ler...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html)

### [Grafites originais em HD](https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/)
**Data da Publicação:** `2015-01-25`
> Esse mod simplesmente substitui os grafites originais do jogo por novos bem mais detalhados e bonitos! Original na esquerda e com o mod na direita. ‎ Autor: Tommy Walker...

### [Pack Skins Da Nang Boyz HD](https://www.mixmods.com.br/2012/09/pack-skins-da-nang-boyz-hd/)
**Data da Publicação:** `2012-09-10`
> Mudando as gangues Grove, Ballas, Vagos mas nao as outras gangues do GTA? Q tal mudar as skins da gangue Da Nang Boyz de San Fierro por umas MUITO mais definidas? Autor: AnRi...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view)

### [Pack de Skins Vagos HD](https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/)
**Data da Publicação:** `2012-08-22`
> Geral com novas skins para grove, para os ballas, mas para os vagos muita gente nem tem neh Corpos e roupas totalmente re-texturizados e melhoras na modelagem assim como mãos com dedos separados e tênis fodásticamente realistas Autor: AnRi...
**Links de Referência / Download:**
- [Download / Link](http://www.mediafire.com/download/0tle8bbat8kx9f9/Pack_de_Skins_Vagos_HD.rar)

### [Pack de skins Grove em HD (by AnRi)](https://www.mixmods.com.br/2012/08/pack-de-skins-grove-em-hd-by-anri/)
**Data da Publicação:** `2012-08-15`
> Há vários mods de skins para a gangue Grove. E eis mais um: Muda todo o modelo e texturas deles (menos o rosto) principalmente as calças, tênis e tatuagens em alta definição; e dedos separados. Autor: AnRi...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view)

### [The Gang War](https://www.mixmods.com.br/2012/05/the-gang-war/)
**Data da Publicação:** `2012-05-05`
> Outra versão de áreas de guerras de gangues AQUI Está sem nada pra fazer no GTA SA? Que tal isso? Ele deixa o mapa literalmente em uma guerra de gangues! Ballas e Vagos por todo o mapa de San Andreas. Agora sim você terá o que fazer! Comando: U Autor: Zaz...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html)

### [Novas Skins para Grove em HD](https://www.mixmods.com.br/2012/03/novas-skins-para-grove-em-hd/)
**Data da Publicação:** `2012-03-03`
> 2018: Download corrigido e refeito. Postei um pack de skins dos Ballas em HD, então não poderia deixar de postar um da Grove! São 6 skins! Agora sua gangue ficará em HD e mais gangster ainda! Autor: Tyler Nixon...
**Links de Referência / Download:**
- [Download / Link](https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html)

### [Novos Ballas em HD](https://www.mixmods.com.br/2012/01/novos-ballas-em-hd/)
**Data da Publicação:** `2012-01-13`
> Skins de verdade! Isso é qualidade: Os Ballas ficarão com um visual renovado, muito mais realista e incrivelmente melhor que os antigos! Autor: gabi 1997, Freonik Dirtyfresh, Arthur$MD, Heavenshock...
**Links de Referência / Download:**
- [Download / Link](https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing)

### [Nova Grove v2](https://www.mixmods.com.br/2011/10/nova-grove-v2/)
**Data da Publicação:** `2011-10-05`
> Mod deletado Motivo: Feito no paint por mim em 2011, feio demais, sério. O mod basicamente trocava a Grove para ser na cor vermelha (e a v2 continuava na verde), se você quer isso, saiba que há um mod incrível: Conheça o Bloodz & Cripz...

### [NOVA GROOVE V1](https://www.mixmods.com.br/2011/05/nova-groove-v1/)
**Data da Publicação:** `2011-05-20`
> Mod deletado Motivo: Feito no paint por mim em 2011, feio demais, sério. O mod basicamente trocava a Grove para ser na cor vermelha, se você quer isso, saiba que há um mod incrível: Conheça o Bloodz & Cripz...
