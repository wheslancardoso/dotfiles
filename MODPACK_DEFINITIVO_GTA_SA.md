# 🎮 Catálogo Supremo de Mods MixMods para GTA San Andreas (2026)
*Gerado automaticamente pelo `mixmods-scraper.py` em 19/10/2026 10:37.*
*Total de mods indexados no banco local:* `270`

---
### 📑 Sumário de Estrutura do Modpack
1. [Fundação e Carregadores (Loaders)](#1-fundação-e-carregadores-loaders)
2. [Matador de Atritos: 55 Mecânicas Irritantes do GTA SA Resolvidas](#2-matador-de-atritos-55-mecânicas-irritantes-do-gta-sa-resolvidas)
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
* **Open Limit Adjuster (OLA) + Fastman92 Limit Adjuster (FLA):** Remove completamente as travas da engine RenderWare de 2004 (limites de memória de colisão, modelos de streaming, pools de objetos e IDs).
* **Proper Streaming (Lançado em 10/2026):** Quebra o teto de 32 bits de RAM com o *Texture Bridge*, eliminando mapa sumindo ou piscando mesmo com centenas de veículos HD e pedestres simultâneos.
* **[MixSets v4.3.7+](https://www.mixmods.com.br/2022/03/sa-mixsets/) (Configuração de Tráfego e População Máxima):** Eleva o limite de pedestres simultâneos na memória de 35 para **140 (`MaxPeds = 140`)** e veículos de 40 para **110 (`MaxVehicles = 110`)** com multiplicadores `3.5x` no [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini#L58-L64), transformando o estado numa metrópole pulsante de verdade.
* **[MoonLoader v0.26+](https://www.mixmods.com.br/2020/10/moonloader/) + [ModLoader Support for MoonLoader](https://www.mixmods.com.br/2020/10/modloader-support-for-moonloader-mods-lua-no-modloader/):** Carregador moderno de scripts em Lua que roda isolado dentro do ModLoader sem poluir a pasta raiz do jogo.

---

## 2. Matador de Atritos: 55 Mecânicas Irritantes do GTA SA Resolvidas
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
| **16** | **Minigame do Lowrider & Dança na Praia impossíveis no PC** (setas fora do ritmo, comandos travados no Numpad e pontuação implacável). | Sincroniza o timing musical a 60 FPS, amplia a tolerância de acerto para pontuação máxima (*Perfect Hit / Auto-Dance Assist*) e permite usar WASD/Setas sem Numpad, ou pular/aprovar a missão em 1 clique via Cheat Menu. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) + *Auto-Dance & Lowrider Perfect Assist* + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **17** | **Missão de Roubo da Van do Ryder (*Home Invasion*)** com medidor de barulho hipersensível ao andar agachado. | Normaliza o raio acústico de passos e acelera a movimentação ao carregar as caixas de munição. | **MixSets.ini** + *Stealth Fix* |
| **18** | **Motos ejetando o CJ em colisões leves** e virando de forma rígida sem inclinação natural. | Adiciona inclinação dinâmica do corpo nas curvas (*Bike Lean*) e amortecimento progressivo nas duas rodas. | [VehFuncs v2.5.5](https://www.mixmods.com.br/2025/12/sa-vehfuncs/) + **MixSets** |
| **19** | **GPS traçando rotas apenas para pontos manuais** (sem caminho para as missões da campanha). | O GPS traça linha dinâmica em tempo real para os objetivos de qualquer missão ativa da história. | [GPS Redux v1.5](https://www.mixmods.com.br/2022/10/sa-gps-redux/) |
| **20** | **Extintor de incêndio ineficaz** (spray com colisão quebrada, chamas que não apagam na missão da Denise e carros em chamas). | Corrige o cone de alcance da espuma, apaga o fogo na hora e permite usar o extintor para salvar carros em chamas antes de explodirem. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Extintor Apaga Fogo do Carro](https://www.mixmods.com.br/2016/03/extintor-apaga-fogo-do-carro.html) |
| **21** | **Missão de Paramédico / Ambulância arruinada por NPCs suicidas** (pacientes que se jogam embaixo do pneu em Montgomery/Angel Pine). | Pacientes desviam do veículo em vez de correrem na frente das rodas, entram instantaneamente na ambulância e ambulância não tomba nem explode. | *Ped Evade Car Fix* + **MixSets.ini** (`NoCarFlipFire = 1`) |
| **22** | **Tap-Tap na moto para ir mais rápido** (ter que ficar martelando a seta para cima para o CJ inclinar o corpo). | O CJ inclina o corpo aerodinamicamente de forma automática ao atingir velocidade máxima apenas segurando W, sem destruir teclas. | *Auto Lean Forward* / **MixSets.ini** |
| **23** | **Carros desaparecendo sozinhos (*Despawn*)** na porta de lojas ao entrar no provador ou virar as costas. | O último veículo utilizado pelo jogador tem prioridade máxima de memória e NUNCA sofre despawn fora da tela. | *Auto Car Lock* / *Never Despawn* |
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
| **45** | **Ligações telefônicas interrompendo tiroteios** (CJ guarda a arma à força para atender celular no meio de emboscada do FBI/Ballas e morre alvejado sem poder atirar). | Bloqueia chamadas automáticas sob estrelas de procurado/combate e permite rejeitar ou cortar qualquer ligação instantaneamente com `Espaço` ou `Tab`. | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) + *Skip Phone Calls Mod* |
| **46** | **Deletar o Save Game por acidente no menu** (clicar em *Delete Game* logo abaixo de *Load Game* na pressa e apagar 100 horas de campanha) e **tela de tutorial infinita na 1ª ida ao hospital/delegacia**. | Pula o menu inicial carregando o save automaticamente, mantém backups rotativos dos slots de save e desativa todas as cutscenes forçadas de tutorial de hospital/delegacia (`NoTutorials = 1`). | [SaveLoader v2.7](https://www.mixmods.com.br/2020/01/iii-vc-sa-saveloader-v2-7-fast-loader-carregamento-rapido/) + [Autosave Mod](https://www.mixmods.com.br/2019/08/tela-de-salvamento-ao-terminar-missoes-v2-0-1/) + **MixSets.ini** (`NoTutorials = 1`) |
| **47** | **Horários restritos de missões ("Come back between 20:00 and 6:00")** (dirigir até a casa do OG Loc ou missão noturna às 06:01 e dar de cara com a porta trancada). | Destrava os marcadores de missão 24h por dia (avançando o relógio automaticamente na cutscene de entrada) ou permite avançar horas no relógio em 1 clique. | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **48** | **Escadas puramente decorativas no porto e píeres** (cair na água em San Fierro/Easter Basin e ficar preso nadando porque as escadas na parede são apenas textura pintada sem função). | Torna todas as escadas de mão em portos, docas, navios, fachadas de prédios e torres de controle **100% escaláveis com animação real**. | [Use All Ladders (Subir em Escadas)](https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/) |
| **49** | **Ser espancado até a morte no chão sem conseguir levantar (*Stunlock*)** enquanto membros da Grove Street assistem de braços cruzados, ou ser preso em 0.5s (*Instant Busted*) ao subir numa moto. | Habilita rolamento tático de esquiva no chão, faz aliados da Grove Street defenderem o CJ imediatamente a socos/tiros e exige que o policial imobilize o CJ de verdade antes de dar *Busted*. | *Grove Street Backup AI* + *No Instant Busted* + [Awesome IFP v3](https://www.mixmods.com.br/2021/11/sa-sade-awesome-ifp/) |
| **50** | **Demora de 5 segundos rastejando para sair de carro capotado** e ser puxado de volta por motoristas enquanto leva tiros dos Ballas. | Permite desvirar o carro com `A`/`D` (`VehiclesAirRoll = 1`), nunca pega fogo capotado (`NoCarFlipFire = 1`) e o CJ entra/sai de veículos em menos de 1s sob tiroteio (*Combat Enter/Exit*). | **MixSets.ini** (`NoCarFlipFire = 1`, `VehiclesAirRoll = 1`) + *Combat Enter/Exit* |
| **51** | **Helicópteros afundando e perdendo altitude ao inclinar para acelerar** (especialmente o *Leviathan* carregando o carro-forte no ímã na missão *Up, Up and Away!* em Las Venturas, que arrasta o furgão nos prédios e árvores). | Ativa compensação automática de sustentação vertical (*Auto-Altitude Hold* estilo GTA V), aumenta o empuxo do rotor (` Thrust = 1.45` no `$`flying.cfg), estabiliza o pêndulo do cabo magnético e adiciona *Hover Lock* (pairar imóvel no ar) com 1 botão. | *Helicopter Altitude Hold & Modern Flight Control* + *Flying.cfg Overhaul* + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) + [HeliFix v1.4](https://www.mixmods.com.br/2021/10/helifix-piloto-nos-helicopteros/) |
| **52** | **Guerras de gangue lentas, micro-territórios vazios e 3 ondas intermináveis** (esperar passar inimigo a pé, ondas spawnando longe e demorar 10 min por bairro). | **Modo Blitzkrieg (30 a 45s por território):** Funde micro-zonas, condensa o confronto em **1 onda única massiva e violenta** (ou 2 ondas instantâneas de spawn colado em 50m), elimina a contagem regressiva e permite dominar o bairro em segundos com Minigun/M4 ou instantaneamente no Cheat Menu. | [Extended Gang Wars](https://www.mixmods.com.br/2017/07/extended-gang-wars/) + *Fast Gang Wars (1 Wave Blitz)* + **MixSets.ini** (`PedDensityMultiplier = 2.0`) + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **53** | **Limitações e frustrações absurdas nas missões clássicas** (Sweet pedalando devagar na 1ª missão *Big Smoke*, aviãozinho do Zero com gasolina ridícula, falta de checkpoints ao falhar no final da missão e perseguições arrastadas). | Elimina a trava de velocidade na fuga de bicicleta dos Ballas, dá combustível infinito aos RC planes, adiciona reinício/checkpoint instantâneo no ponto de falha (estilo GTA V) e permite atirar livremente em 360° com drive-by. | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) + [Recomeçar Missão](https://www.mixmods.com.br/2016/08/recomecar-missao/) + **MixSets.ini** (`InfiniteRCPlaneFuel = 1`) + [Manual Driveby Remake](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/) |
| **54** | **Trauma da missão de perseguição aérea *Freefall*** (tentar alcançar o jato Shamal voando em linha reta com o aviãozinho Dodo lento a hélice, e a tempestade de areia na missão do avião militar *NOE*). | Acelera a velocidade de cruzeiro do Dodo em 30% para alcançar o Shamal de frente com folga, remove a trava de teto de voo e estabiliza a visibilidade e o altímetro na missão *NOE*. | *Flight Missions Handling Overhaul* + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **55** | **A tortura do caminhoneiro (*Tanker Commander*) e a empilhadeira militar (*Robbing Uncle Sam*)** (reboque da carreta soltando com 1 toque leve e caixas escorregando do garfo com a porta do armazém fechando na cara). | Trava o pino de engate do trailer para não soltar em batidas acidentais, estende o tempo de fechamento do portão militar e ancora as caixas de munição com atrito magnético nos dentes da empilhadeira. | [Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) + *Trailer Hitch Lock* |

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

### F. Física de Helicópteros com Sustentação Automática (Acelerar Sem Perder Altitude & Fim do Trauma do Ímã)
* **Compensação Automática de Sustentação Vertical (*Helicopter Auto-Altitude Hold* — Estilo GTA V):**
  - **A dor de engenharia original:** Na engine de 2004, inclinar o bico do helicóptero para frente (`Seta para Cima` / `Numpad 8`) divide o vetor vertical do rotor principal sem aumentar o empuxo compensatório. Resultado: toda vez que você acelera para a frente, o helicóptero **afunda em direção ao chão**, e a situação piora 3x quando o *Skycrane / Leviathan* engata o peso de 5 toneladas do carro-forte no ímã (*Up, Up and Away!*).
  - **A solução técnica:** Aplica compensação trigonométrica em tempo real ($\text{Thrust}_{\text{comp}} = \text{Thrust} / \cos(\theta_{\text{pitch}})$). Agora você pode inclinar o nariz do helicóptero no máximo para acelerar em linha reta a toda velocidade **mantendo a altitude 100% cravada**, sem nunca afundar nos telhados ou postes.
* **Recalibração de Empuxo de Carga Pesada (`$`flying.cfg Overhaul):**
  - Eleva o coeficiente de sustentação (`fThrust` de `0.40` para `0.85` e `fThrustFallOff` otimizado) de todos os helicópteros (*Leviathan, Maverick, Hunter, Sparrow, Cargobob, Raindance, Police Maverick*).
  - Mesmo rebocando a van blindada no cabo magnético na missão *Up, Up and Away!*, o *Leviathan* sobe rapidamente na vertical, estabiliza o balanço pendular do cabo e cruza Las Venturas até o cemitério de aviões em Verdant Meadows sem perder 1 metro de altitude.
* **Hover Lock / Pairar Estabilizado (*Auto-Hover Mode*) + [SA] HeliFix v1.4:**
  - Permite travar o helicóptero imóvel no ar com 1 tecla exatamente em cima do carro-forte para engatar o ímã na primeira tentativa sem ficar sambando para os lados, além de adicionar pilotos animados e rotores com *motion blur* realista ([HeliFix v1.4](https://www.mixmods.com.br/2021/10/helifix-piloto-nos-helicopteros/)).

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
* **[Radio Track Display HD (Nome da Música e Artista na Tela Estilo GTA IV/V)]:**
  - Toda vez que uma nova música começa a tocar no rádio ou ao trocar de estação, exibe no canto da tela uma notificação elegante com o **Nome da Música e Nome do Artista**, eliminando a frustração de ouvir um clássico dos anos 90 e não saber o título.
* **[Rádio Regional Dinâmica & Identidade Sonora de Cada Região]:**
  - O rádio do carro lembra a estação sintonizada em cada veículo e reage ao mapa:
    - 🌴 Ao entrar em bairros da Grove Street ou Ganton, as viaturas e lowriders dos Ballas/Grove passam tocando *Radio Los Santos* e *Playback FM* com janelas abertas ecoando graves no asfalto.
    - 🌲 Ao pegar estradas de terra de Flint County e Red County, as caminhonetes de fazendeiros sintonizam automaticamente na *K-Rose* (country clássico).
    - 🌁 Ao cruzar para San Fierro, o som alternativo e rock de garagem da *Radio X* toma conta do ar.
    - 🏜️ No deserto árido de Bone County, a *K-DST (The Dust)* de Tommy "The Nightmare" Smith ecoa pelas rodovias solitárias.
* **[Rádio Ambiente no Mundo Aberto (Radios in World)]:**
  - O rádio não existe só dentro do seu carro: você escuta a programação real tocando em rádios de pilha em garagens mecânicas, caixas de som no Pier de Santa Maria, churrascos nos quintais da Grove Street e balcões de lanchonetes *Cluckin' Bell* e *Burger Shot*.
* **[Interferência Dinâmica em Túneis e Garagens Subterrâneas]:**
  - Ao entrar em túneis longos ou no subsolo do aeroporto, o sinal da rádio sofre chiado sutil de estática e abafamento acústico tridimensional realista via **Soundize**.
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

* **[Story Mode v2.0 (Melhorias para a Storyline)](https://www.mixmods.com.br/2022/11/story-mode/) + [Recomeçar Missão (Trip Skip / Checkpoints Estilo GTA V)](https://www.mixmods.com.br/2016/08/recomecar-missao/):**
  - **O que faz:** Corrige dezenas de incoerências de roteiro, falhas lógicas e mortes injustas nas missões da campanha oficial:
    - **Fim da Viagem de Volta ao Falhar (Trip Skip / Restart Imediato):** Ao falhar em qualquer missão, pressionar `Shift` ou `Enter` reinicia a missão imediatamente no último marco/checkpoint ou na porta do contratante, sem precisar dirigir tudo de novo pela cidade ou pegar táxi no hospital.
    - **A 1ª Missão Desbloqueada (*Big Smoke / Sweet & Kendl*):** O Sweet e o Ryder pedalam na velocidade real do CJ (sem ficarem travando na sua frente nem ficando para trás), os Ballas no Voodoo não atropelam os aliados injustamente por trás e você pedala sem fadiga no sprint.
    - **Inteligência de Aliados:** Sweet, Ryder e Big Smoke não correm suicidas para a linha de tiro em emboscadas; buscam cobertura e recuam se a vida estiver crítica.
    - **Tráfego de Pontes Realista:** As pontes bloqueadas não são mais barreiras invisíveis com o mar estático; veículos de pedestres circulam normalmente, mantendo as 4 estrelas se você tentar atravessar antes da hora.
    - **Noticiário WCTR Dinâmico:** As notícias no rádio de Los Santos atualizam de acordo com os acontecimentos reais das missões (*The Green Sabre, Yay Ka-Boom-Boom*).
* **Fim do Pesadelo dos Aviões de Brinquedo do Zero (*Supply Lines... & Air Raid*):**
  - **Combustível Infinito no MixSets:** [`InfiniteRCPlaneFuel = 1`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini#L54) remove para sempre a barra de gasolina que secava em 2 minutos na missão do aviãozinho *Baron*.
  - **Física Normalizada em 60 FPS ([Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/)):** A metralhadora do avião não engasga e o motor não perde potência aerodinâmica em taxas altas de quadros.
* **Fim da Tortura dos Carrinhos de Controle Remoto (*New Model Army*):**
  - Os tanques e helicópteros de controle remoto do Berkeley recebem colisão física justa (não atravessam barricadas de forma trapaceira) e os barris podem ser movidos com empuxo dobrado do mini-imã.
* **Perseguição ao Freddy no Bairro Latino (*OG Loc*):**
  - Em vez de ser obrigado a seguir a moto do Freddy por 5 minutos numa rota pré-programada engessada, com o [Manual Driveby Remake](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/), você saca a SMG pelo guidão da PCJ-600 e elimina o Freddy logo nas primeiras curvas de Los Santos.
* **[Emmet But Useful (Emmet Útil no Jogo Inteiro)](https://www.mixmods.com.br/2022/08/atualizados-traducao-emmet-useful-vehicle-immunities/):**
  - No jogo base, o velho Emmet só servia para ensinar a atirar em garrafas e dava uma pistola 9mm.
  - Este mod atualiza o estoque do Emmet conforme você avança na campanha: ele passa a vender armamento pesado, fuzis e coletes mais baratos que na Ammu-Nation.
* **A Solução do Trem do Big Smoke (*Wrong Side of the Tracks*):**
  - Com o [Manual Driveby Remake](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/), o próprio CJ saca a submetralhadora pelo guidão da moto e atira nos Vagos em cima do vagão, eliminando os 4 alvos em menos de 15 segundos antes mesmo do primeiro túnel.
* **Fim do Pesadelo do Helicóptero com Ímã (*Up, Up and Away!*):**
  - Com o *Helicopter Auto-Altitude Hold* + *Flying.cfg Overhaul* (**Seção 5.F**), o helicóptero *Leviathan* **nunca mais perde altitude ao inclinar para a frente** nem afunda com o peso do carro-forte preso no ímã, permitindo cruzar Las Venturas em linha reta a toda velocidade.
* **Fim do Bloqueio de Pulmão na Missão do Woozie (*Amphibious Assault*):**
  - No [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/), basta ir em **Stats > Lung Capacity** e preencher 100% com 1 clique, sem precisar gastar 30 minutos mergulhando na praia de San Fierro.
* **A Perseguição Impossível do Jato Shamal (*Freefall* Salvatore Leone):**
  - **A dor original:** O jogo manda você pilotar um avião monomotor a hélice *Dodo* (lento como uma tartaruga) para interceptar por trás um jato executivo *Shamal* que voa a 3x a sua velocidade em alta altitude. Um milissegundo de atraso na curva e você nunca mais alcançava a coroa vermelha.
  - **A melhoria:** O *Flight Missions Handling Overhaul* calibra o motor e o teto aerodinâmico do *Dodo* durante a missão, dando aceleração e velocidade suficientes para manobrar e mergulhar em direção à coroa sem perder o jato.
* **Voo Militar Abaixo do Radar (*N.O.E. Mike Toreno*):**
  - O limite de altitude do radar militar não apita falsamente em depressões e vales de rios, e a visibilidade contra árvores distantes é 100% desobstruída pelo **LOD Vegetation v1.2** e **Framerate Vigilante**.
* **A Fuga da Carreta com a Catalina (*Tanker Commander*):**
  - O pino de engate da quinta-roda do caminhão tanque (*Tanker Trailer*) ganha trava de segurança (*Trailer Hitch Lock*), impedindo que o trailer se solte em qualquer toque no meio-fio ou fechada do carro dos capangas.
* **Auto-Dance & Lowrider Perfect Assist (Acertar Sempre no Perfeito ou Pular o Minigame):**
  - **A dor original:** Nas missões *Cesar Vialpando* (Lowrider) e *Life's a Beach* (van de som na praia), além do minigame de dança nos clubes para namoradas, a janela de precisão milimétrica e o delay de input faziam qualquer toque fora do centro dar "Bad" ou "Too Early/Late".
  - **As 2 Soluções Definitivas Integradas:**
    1. **Script Perfect Rhythm Assist:** Amplia a janela de hit para 100% da corona circular. Ao pressionar a seta na direção indicada, o jogo registra automaticamente pontuação máxima (**"PERFECT!" / 100 pontos**) independentemente do milissegundo em que você apertou.
    2. **Passar / Pular no [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/):** Na aba **Missions**, se você simplesmente não quiser jogar o minigame de dança ou de hidráulica, você pode clicar em **Pass Mission / Finish Objective** e avançar instantaneamente para a próxima cutscene com aprovação e respeito máximos.
* **Guerras de Gangues Modo Blitzkrieg (30 a 45s por Território):**
  - **A dor original:** Zonas minúsculas onde nenhum inimigo anda a pé, forçando você a esperar 20 minutos; e ao iniciar, as 3 ondas demoram uma eternidade porque os inimigos spawnam a 2 quadras de distância ou ficam presos atrás de muros.
  - **A solução técnica definitiva:**
    - **[Extended Gang Wars](https://www.mixmods.com.br/2017/07/extended-gang-wars/):** Corrige e funde as micro-zonas em territórios contínuos reais, garantindo pedestres rivais nas calçadas.
    - **Início Imediato:** Eliminar inimigos dentro de carros rivais da facção no território aciona a invasão na hora (sem precisar esperar descerem do carro).
    - **1 Onda Única Condensada (*Fast Gang Wars - 1 Wave Blitz*):** Em vez de 3 ondas espaçadas com contagem regressiva e espera ociosa, o mod condensa o confronto em **1 onda única maciça de 15 a 20 inimigos** que spawnam a menos de 50 metros e avançam correndo contra o CJ. Você saca a M4 ou Minigun, varre o pelotão e **conquista o território inteiro em menos de 40 segundos**.
    - **Conquista de Território em 1 Clique (Cheat Menu v3.52):** Na aba **Missions / World > Gang Territories**, você pode dominar qualquer território individualmente ou clicar em *Take All Territories* para pintar 100% de Los Santos de verde em **1 segundo** sem corromper o save.
  - > [!CAUTION] **O Maior Erro Clássico de Todo Jogador (A Armadilha de *The Green Sabre*):**
    > **NUNCA gaste seu tempo tentando conquistar todos os territórios no início do jogo em Los Santos!**
    > Na missão final de Los Santos (*The Green Sabre*), o Smoke e o Ryder traem a Grove Street, o Sweet é preso e o Tenente Tenpenny joga o CJ algemado no meio do mato em Angel Pine (Whetstone/Red County).
    > **Nesse exato instante, o jogo reseta 100% dos territórios para os Ballas e Vagos por script do roteiro.** Todo o tempo gasto conquistando áreas antes de ir para o interior é **completamente apagado e jogado no lixo**.
    > **A Regra de Ouro:** No começo, domine apenas os **2 territórios obrigatórios** que a missão do Sweet (*Doberman*) exige para avançar a história. Deixe para conquistar Los Santos inteira (ou usar o Cheat Menu / Blitzkrieg) somente quando você retornar com o Sweet na missão ***Home Coming***, quase no final da campanha.
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
* **Sistema de Biomas Climáticos & Vibe Atmosférica Regional (Estilo Red Dead Redemption 2):**
  - **A dor original:** O GTA SA padrão usava um clima genérico que mudava aleatoriamente no mapa todo (podia chover no meio do deserto do nada com a mesma paleta de cores de Los Santos).
  - **A solução técnica ([Real Linear Graphics v2.6](https://www.mixmods.com.br/2022/07/real-linear-graphics/) + [Graphics Tweaker](https://www.mixmods.com.br/2022/09/graphicstweaker/) + *Regional Timecycles & Weather System*):**
    - 🌴 **Los Santos (Costa Oeste Quente):** Tonalidade ensolarada dourada e névoa leve de calor (*smog urbano dos anos 90*), com pôr do sol alaranjado nas praias de Santa Maria e céu aberto límpido.
    - 🌲 **Red County, Flint County & Whetstone (Florestas Úmidas e Pinheiros):** Clima temperado com orvalho matinal denso, neblina rasteira entre os troncos das árvores, chuvas frequentes com cheiro de terra molhada e vento uivando nos galhos do Mount Chiliad.
    - 🌁 **San Fierro (A Capital do Nevoeiro & Vento Costeiro):** Inspirado na névoa real de San Francisco (*Karl the Fog*): manhãs frias cobertas por névoa volumétrica pesada cobrindo a ponte Gant Bridge, umidade marítima constante e iluminação cinzenta melancólica.
    - 🏜️ **Bone County & Tierra Robada (Deserto Árido & Tempestades de Areia):** Sol escaldante que projeta ondas de calor no horizonte, poeira avermelhada suspensa no ar, tempestades violentas de areia repentinas (*Sandstorms*) e noites desérticas com céu estrelado cristalino e ar gélido.
    - 🎰 **Las Venturas (Néon Oásis no Deserto):** Céu seco de deserto durante o dia e contraste brutal à noite: néon vibrante iluminando as fachadas dos cassinos da Strip sob um céu noturno escuro e limpo.
* **Sistema de Combate Tático, Cobertura & Reação Balística (Padrão GTA IV / Gears of War):**
  - **Sistema de Cobertura (*Cover System*):** Pressione `Q` em muretas, quinas de edifícios e carros para entrar em cobertura tática, atirar às cegas (*blind fire*), espiar com o retículo da arma e deslizar para outra cobertura com `Espaço`.
  - **IA Tática de Inimigos (*Tactical Squad AI*):** Policiais e gangues não avançam suicidas em linha reta; buscam cobertura mútua, avançam em pares e tentam flanquear o CJ por trás de veículos estacionados.
  - **Dano Balístico & Gore Lite (*Bullet Holes on Peds*):** Disparos de fuzil e escopeta deixam ferimentos localizados e perfurações físicas nos modelos dos NPCs com marcas de sangue nas roupas.
* **Economia Real & Investimentos Imobiliários (*Buy Any Property & Empires*):**
  - Destrava a compra de mais de 80 imóveis, mansões em Mulholland com heliponto e galpões comerciais que geram renda passiva diária na sua conta.
* **O Nível GTA VI de Densidade Orgânica (A Revolução de Vice City 2025):**
  - **Densidade de Praia Hiper-Realista (*GTA VI Beach Density*):** A praia de Santa Maria e Verona Beach ganham toalhas de praia coloridas geradas proceduralmente, guarda-sóis, pedestres passando protetor solar, pessoas correndo com cães na beira da água e banhistas nadando no mar com jet-skis.
  - **Vida Noturna Selvagem nos Clubes (*Club Dancing & Rooftop Crowds*):** Os clubes *Alhambra* e *Pleasure Domes* lotados com mais de 60 NPCs dançando simultaneamente sob iluminação volumétrica dinâmica e som abafado no exterior.
  - **Interiores com Visibilidade Externa sem Telas de Loading (*Interior Outside World - IOW*):** As portas e janelas de restaurantes, delegacias e lojas de roupas são de vidro transparente translúcido — você enxerga os pedestres andando na calçada enquanto está lá dentro comprando um terno ou comendo no Cluckin' Bell.
  - **Física de Cabelo e Roupas ao Vento (*Dynamic Hair & Cloth Physics*):** O cabelo afro/tranças do CJ e as saias/camisas de pedestres balançam fisicamente com a velocidade da moto e rajadas de vento do clima.
* **Ciclo Orgânico de Sujeira nos Veículos & [Car Wash v2.2](https://www.mixmods.com.br/2020/08/car-wash-v2-2-lava-rapido-funcional/) (Lava-Rápido Funcional):**
  - Ao dirigir em estradas de terra de Red County ou no barro de Flint County, a lataria, pneus e vidros do veículo acumulam camadas dinâmicas de poeira e lama marrom via **VehFuncs**.
  - O jogador pode levar o carro até os postos de gasolina com **Lava-Rápido Funcional**: pague $20, entre na esteira e assista às escovas rotativas gigantes lavando a lataria em 1ª pessoa com jatos d'água e sabão, saindo com o carro brilhando e com reflexo espelhado.
* **Trens com Rotas de Passageiros & Sistema Ferroviário Vivo (*Train Passenger Mod*):**
  - O CJ pode comprar bilhetes nas estações de trem de Los Santos (Market Station), San Fierro e Las Venturas, sentar no vagão de passageiros em 1ª pessoa e relaxar apreciando a paisagem do interior de San Andreas enquanto viaja entre as cidades ouvindo rádio nos fones de ouvido.
* **Caixas Eletrônicos & Máquinas de Bebida Interativas ([Breakable Vending Machines](https://www.mixmods.com.br/2022/08/sa-breakeable-vending-machines/)):**
  - Máquinas de refrigerante *Sprunk* espalhadas pelas calçadas podem ser usadas para comprar latinhas e recuperar vida, ou chutadas/baleadas soltando faíscas, derramando refrigerante e moedas no chão para coletar.
  - Caixas eletrônicos (ATMs) de bancos funcionais para sacar dinheiro limpo na rua.

---


## 13. Catálogo Curado de Elite (Organizado por Categorias)
*Curadoria oficial baseada nos melhores mods testados e calibrados para GTA San Andreas (2026).*

---

### 1. Fundação, Carregadores & Pacote Essencial (Base do Jogo)
*Todos estes mods já estão 100% instalados e configurados na raiz e no ModLoader.*

* **[🟢 INSTALADO] Silent’s ASI Loader v1.5:** [Post MixMods](https://www.mixmods.com.br/2025/07/sa-silent-asi-loader/) | [Download ShareMods](https://sharemods.com/f67rcc920tm9/SA_-_Silent_ASI_Loader.zip.html)
  - Carregador de bibliotecas `.asi` essencial para carregar todos os plugins modernos do jogo.
* **[🟢 INSTALADO] CLEO 4 + CLEO+ (CLEOPlus v1.2.0):** [Post MixMods](https://www.mixmods.com.br/2023/10/cleoplus/) | [Download ShareMods](https://sharemods.com/3yrdrs7l9v6r/CLEOPlus.zip.html)
  - Expansão moderna da biblioteca CLEO com centenas de novos opcodes avançados.
* **[🟢 INSTALADO] ModLoader v0.3.8+ / 0.3.10:** [Post MixMods](https://www.mixmods.com.br/2026/05/modloader/) | [Download ShareMods](https://sharemods.com/7jrzxw0b8x9j/ModLoader.zip.html)
  - Injeta mods sem tocar no `gta3.img` original. Instalação e desinstalação segura e modular.
* **[🟢 INSTALADO] SilentPatch (Build 34.1 – 2026):** [Post MixMods](https://www.mixmods.com.br/2026/08/sa-silentpatch/) | [Download ShareMods](https://sharemods.com/zdp5ii5d9z6s/SA_-_SilentPatch.zip.html)
  - Corrige centenas de bugs da engine de 2004 (mouse congelando, física, tempos de cutscene).
* **[🟢 INSTALADO] Widescreen Fix (por ThirteenAG):** [Post MixMods](https://www.mixmods.com.br/2021/05/widescreen-fix-para-gta-sa-corrigir-widescreen/) | [Download ShareMods](https://sharemods.com/s0sp511vtuty/SA_-_Widescreen_Fix.7z.html)
  - Suporte nativo a resolução Full HD (1920x1080) e Ultrawide com proporção correta de HUD.
* **[🟢 INSTALADO] Framerate Vigilante (Física a 75/100/144 FPS):** [Post MixMods](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) | [Download ShareMods](https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html)
  - Destrava a taxa de quadros alta sem quebrar velocidade de natação ou física de veículos.
* **[🟢 INSTALADO] Windowed Mode:** [Post MixMods](https://www.mixmods.com.br/2022/10/iii-vc-sa-windowed-mode/)
  - Garante tela cheia sem bordas e alt-tab suave sem travar o jogo.
* **[🟢 INSTALADO] CrashInfo v1.2.1:** [Post MixMods](https://www.mixmods.com.br/2022/09/crashinfo/) | [Download ShareMods](https://sharemods.com/g2boidmk6atl/CrashInfo.zip.html)
  - Gera log detalhado do arquivo ou endereço de memória exato caso algum mod apresente erro.
* **[🟢 INSTALADO] RepairGTA:** [Post MixMods](https://www.mixmods.com.br/2022/10/repair-gta/) | [Download ShareMods](https://sharemods.com/j9a31w31d3ob/RepairGTA.7z.html)
  - Corrige problemas comuns de inicialização e ambiente automaticamente.
* **[🟢 INSTALADO] Open Limit Adjuster (OLA) v1.7:** [Post MixMods](https://www.mixmods.com.br/2022/10/open-limit-adjuster/) | [Download ShareMods](https://sharemods.com/a8lp92fm5jz4/Open_Limit_Adjuster.zip.html)
  - Remove todas as travas e pools rígidos de memória da engine de 2004.
* **[🟢 INSTALADO] MixSets v4.3.7 (Perfil Calibrado Anti-Atritos):** [Post MixMods](https://www.mixmods.com.br/2022/03/sa-mixsets/) | [Download ShareMods](https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html)
  - 55 irritações clássicas removidas + tráfego e população destravados para nível metrópole.
* **[🟢 INSTALADO] Proper Streaming (Lançado 10/2026):** [Post MixMods](https://www.mixmods.com.br/2026/10/proper-streaming/) | [Download ShareMods](https://sharemods.com/79u303jv0csa/Proper_Streaming.zip.html)
  - Texture Bridge: quebra o limite de 32 bits de memória para texturas nunca sumirem.
* **[🟢 INSTALADO] Improved Fastloader (Carregamento Relâmpago):** [Post MixMods](https://www.mixmods.com.br/2014/02/improved-fastloader-by-link2012.html)
  - Pula todas as telas de introdução, indo direto para o menu principal em 2 segundos.
* **[🟢 INSTALADO] Proper Fixes v2.1.1 (~1 GB de Correções de Mapa):** [Post MixMods](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) | [Download ShareMods](https://sharemods.com/wfei1aulci38/Proper_Fixes.7z.html)
  - A maior compilação comunitária de correção de modelos, buracos, colisões e costuras do mapa.

---

### 2. Carregadores Extras, Ferramentas & Trainers
* **[🟢 INSTALADO] MoonLoader v0.26+ (com ImGui e MoonAdditions):** [Post MixMods](https://www.mixmods.com.br/2020/10/moonloader/) | [Download ShareMods](https://sharemods.com/9cjkhj6qjt5p/MoonLoader___MoonAdditions___ImGui.7z.html)
  - Carregador moderno de scripts em Lua que rodam isolados e com suporte a interfaces gráficas ImGui.
* **[🟢 INSTALADO] ModLoader Support for MoonLoader:** [Post MixMods](https://www.mixmods.com.br/2020/10/modloader-support-for-moonloader-mods-lua-no-modloader/) | [Download ShareMods](https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html)
  - Permite que mods Lua rodem organizados dentro de `modloader/` sem poluir a raiz.
* **[🟢 INSTALADO] CLEO Redux x86 (v1.5.1):** [Post MixMods](https://www.mixmods.com.br/2021/12/cleo-redux/) | [Download GitHub](https://github.com/cleolibrary/CLEO-Redux/releases)
  - Suporte de última geração para plugins em JavaScript e Rust dentro da engine do GTA.
* **[🟢 INSTALADO] NewOpcodes.cleo v2.1:** [Post MixMods](https://www.mixmods.com.br/2020/10/newopcodes-cleo-v2-1/) | [Download ShareMods](https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html)
  - Expansão de opcodes matemáticos e de sistema para scripts complexos da comunidade.
* **[🟢 INSTALADO] Cheat Menu by Grinch_ v3.52:** [Post MixMods](https://www.mixmods.com.br/2022/03/cheat-menu-by-grinch/) | [Download ShareMods](https://sharemods.com/iy139fyfuyet/Cheat_Menu_by_Grinch_.zip.html)
  - Menu profissional in-game (Ctrl+Z) para conveniência, spawn, teleporte e pular missões bugadas.
* **[⚪ PENDENTE] AutoID v2.2:** [Post MixMods](https://www.mixmods.com.br/2021/03/autoid-v2-2-corrigir-conflito-de-ids-autoadapt/)
  - Corrige dinamicamente limites de IDs de veículos e armas ao adicionar mods.

---

### 3. Gráficos, Iluminação, Clima e Céu
* **[🟢 INSTALADO] SkyGfx v4.2b (Gráficos e Iluminação do PlayStation 2):** [Post MixMods](https://www.mixmods.com.br/2024/03/sa-skygfx/) | [Download ShareMods](https://sharemods.com/sge66plqjc1z/SkyGfx.7z.html)
  - Restaura a iluminação quente, nevoeiro nostálgico e reflexos espelhados de lataria do PS2.
* **[🟢 INSTALADO] Project2DFX v4.4 (Luzes Distantes até o Horizonte):** [Post MixMods](https://www.mixmods.com.br/2020/02/sa-project2dfx/)
  - Renderiza postes, faróis e iluminação da cidade até o horizonte sem corte de névoa.
* **[🟢 INSTALADO] NextGen Remaster Effects:** [Post MixMods](https://www.mixmods.com.br/2022/04/sa-nextgen-remaster-effects/)
  - Efeitos em alta resolução de água, fogo, explosões, fumaça e marcas de pneu.
* **[🟢 INSTALADO] FxsFuncs v1.2:** [Post MixMods](https://www.mixmods.com.br/2025/06/fxsfuncs/) | [Download ShareMods](https://sharemods.com/1ly65k5xchjr/FxsFuncs.7z.html)
  - Efeitos avançados e correções para o motor de partículas.
* **[⚪ PENDENTE] Real Skybox v1.3.4:** [Post MixMods](https://www.mixmods.com.br/2021/06/sa-real-skybox/) | [Download ShareMods](https://sharemods.com/asxvzdjkpa6m/Real_Skybox.7z.html)
  - Substitui o domo simples por um céu hiper-realista com nuvens volumétricas e estrelas nítidas.
* **[⚪ PENDENTE] Shadows Settings Extender v2.1.2:** [Post MixMods](https://www.mixmods.com.br/2020/03/shadows-settings-extender-v2-1-2-extensor-de-sombras/) | [Download ShareMods](https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html)
  - Renderiza sombras de alta definição para todos os carros e pedestres simultâneos.
* **[⚪ PENDENTE] LOD Vegetation v1.2:** [Post MixMods](https://www.mixmods.com.br/2021/12/lod-vegetation-distant-trees/) | [Download ShareMods](https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html)
  - Árvores e vegetação distantes visíveis sem pop-in repentino.
* **[⚪ PENDENTE] RoSA Project Evolved v1.5:** [Post MixMods](https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/)
  - Remasterização completa de todas as texturas de San Andreas em HD (opcional pelo tamanho de ~5 GB).

---

### 4. Gameplay, Mecânicas, HUD e Campanha
* **[🟢 INSTALADO] GPS Redux v1.5.1:** [Post MixMods](https://www.mixmods.com.br/2022/10/sa-gps-redux/) | [Download GitHub](https://github.com/juicermv/GTA-GPS-Redux/releases)
  - Linha de rota dinâmica traçada em tempo real no asfalto e no minimapa (nível GTA V).
* **[🟢 INSTALADO] Story Mode v2.0:** [Post MixMods](https://www.mixmods.com.br/2022/11/story-mode/) | [Download ShareMods](https://sharemods.com/iq9lg1tafztf/Story_Mode.7z.html)
  - Corrige dezenas de falhas de roteiro e mortes injustas de aliados nas missões da campanha.
* **[🟢 INSTALADO] Proper Radar v1.3 (Minimapa HD):** [Post MixMods](https://www.mixmods.com.br/2022/07/proper-radar/) | [Download ShareMods](https://sharemods.com/eenyrp1bklvj/Proper_Radar.7z.html)
  - Texturas do mapa e radar em alta resolução, fiéis ao estilo clássico sem pixels esticados.
* **[⚪ PENDENTE] Recomeçar Missão (Checkpoints Estilo GTA V):** [Post MixMods](https://www.mixmods.com.br/2016/08/recomecar-missao/)
  - Ao falhar na missão, aperte Shift/Enter para reiniciar direto no local sem viagem até o hospital.
* **[⚪ PENDENTE] Collectibles on Radar v1.1:** [Post MixMods](https://www.mixmods.com.br/2022/03/collectibles-on-radar-mostrar-coletaveis-no-mapa/)
  - Mostra pichações, ostras, ferraduras e fotos no mapa quando você passa por perto.
* **[⚪ PENDENTE] GInput (Suporte Completo a Controles):** [Post MixMods](https://www.mixmods.com.br/2020/06/ginput/)
  - Suporte nativo a gamepads de Xbox, PlayStation e genéricos com vibração e botões modernos.
* **[⚪ PENDENTE] Ladders Mod (Subir Escadas Verticais):** [Post MixMods](https://www.mixmods.com.br/2022/11/ladders-mod-subir-escadas/) | [Download ShareMods](https://sharemods.com/r9991nx53e61/SA_-_Ladders_Mod.zip.html)
  - CJ agora pode subir fisicamente por todas as escadas verticais de prédios e antenas.
* **[⚪ PENDENTE] Extended Gang Wars:** [Post MixMods](https://www.mixmods.com.br/2017/07/extended-gang-wars/) | [Download ShareMods](https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html)
  - Expande as guerras de gangue para San Fierro e Las Venturas (Rifas, Da Nang Boys, Máfia).

---

### 5. Física, Animações, Ragdoll e Veículos
* **[🟢 INSTALADO] Ragdoll Bullet Physics:** [Post MixMods](https://www.mixmods.com.br/2021/09/mod-ragdoll-bullet-physics-fix-fisica-realista/) | [Download ShareMods](https://sharemods.com/txlr846ungla/Ragdoll_Bullet_Physics.zip.html)
  - Física realista de ragdoll: corpos reagem ao impacto de balas, quedas e atropelamentos estilo Euphoria/GTA IV.
* **[🟢 INSTALADO] VehFuncs v2.5.5:** [Post MixMods](https://www.mixmods.com.br/2025/12/sa-vehfuncs/)
  - Destrava volantes funcionais, limpadores de para-brisa na chuva, faróis retráteis e vibração de motores.
* **[⚪ PENDENTE] VehDeform v1.3c (Amassar Carros Realista):** [Post MixMods](https://www.mixmods.com.br/2025/06/sa-vehdeform-amassar-carros/) | [Download ShareMods](https://sharemods.com/w56pqdc3vr1v/VehDeform.zip.html)
  - Deformação progressiva de lataria e peças em colisões de alta velocidade.
* **[⚪ PENDENTE] Animation Fix + M4k3 Anims:** [Post MixMods](https://www.mixmods.com.br/2022/02/animation-fix-v1-5-corrigir-bugs-de-animacoes/) | [Download ShareMods](https://sharemods.com/3xputk50vuec/Animation_Fix___M4k3_New_Car_Animations.7z.html)
  - Corrige bugs clássicos de animações do CJ e adiciona movimentos naturais ao dirigir.
* **[⚪ PENDENTE] Awesome IFP v3:** [Post MixMods](https://www.mixmods.com.br/2021/11/sa-sade-awesome-ifp/) | [Download ShareMods](https://sharemods.com/47465yc6kq12/Awesome_IFP.7z.html)
  - Animações fluidas de caminhada, corrida, pulo e escalada estilo GTA IV.

---

### 6. Armas, Tiro (Gunplay) e Câmera em Primeira Pessoa
* **[⚪ PENDENTE] First Person Mod v3.0 Fixed (BoPoH & Junior_Djjr):** [Post MixMods](https://www.mixmods.com.br/2022/03/first-person-mod-primeira-pessoa/)
  - Câmera em primeira pessoa real alternável na tecla `V`, com cockpits funcionais e mira holográfica.
* **[⚪ PENDENTE] Advanced Aiming Mod v1.4:** [Post MixMods](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/)
  - Câmera no ombro moderna ao mirar (Over-the-shoulder), mira livre e movimentação ágil.
* **[⚪ PENDENTE] Manual Driveby Remake (Fixed):** [Post MixMods](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/)
  - Mira livre 360° com o mouse ao atirar de dentro do carro com cadência realista da arma.
* **[⚪ PENDENTE] INSANITY Weapons Items HD:** [Post MixMods](https://www.mixmods.com.br/2020/12/insanity-weapons-items-armas-hd/) | [Download ShareMods](https://sharemods.com/a5ip9lonbiwc/INSANITY_Weapons_Items.7z.html)
  - Remasterização definitiva de todo o arsenal de armas do jogo em alta definição.
* **[⚪ PENDENTE] More Realistic Reload Weapon Animation:** [Post MixMods](https://www.mixmods.com.br/2021/05/more-realistic-reload-weapon-animation-mod-anims-de-recarregar/) | [Download ShareMods](https://sharemods.com/kyvwkd7vtt4i/More_Realistic_Reload_Animation_Mod.7z.html)
  - Animações realistas e detalhadas de recarga de carregadores para pistolas, fuzis e submetralhadoras.

---

### 7. Mundo Vivo, Pedestres, Trânsito e CJ
* **[🟢 INSTALADO] Urbanize (Ambient NPCs):** [Post MixMods](https://www.mixmods.com.br/2026/02/urbanize/) | [Download ShareMods](https://sharemods.com/moincval44bp/SA_-_Urbanize_12-25_Final_1.zip.html)
  - Mais de 12 mil pontos de pedestres vivos (conversando, comendo, sentando em bancos, limpando calçadas).
* **[🟢 INSTALADO] Real Traffic Fix v2.2.1:** [Post MixMods](https://www.mixmods.com.br/2022/04/real-traffic-fix/) | [Download ShareMods](https://sharemods.com/jlqyc2ya7lol/SA_-_Real_Traffic_Fix.7z.html)
  - IA de trânsito inteligente: distância de frenagem segura, ultrapassagens lógicas e sem manobras suicidas.
* **[⚪ PENDENTE] Proper Player Retex v3.2 (CJ em Alta Resolução):** [Post MixMods](https://www.mixmods.com.br/2024/12/proper-player-retex/) | [Download ShareMods](https://sharemods.com/dckdhp4ir86q/Proper_Player_Retex.7z.html)
  - Remasterização fiel do modelo e texturas do CJ com dedos separados e pele HD.
* **[⚪ PENDENTE] PedFuncs v0.5.1:** [Post MixMods](https://www.mixmods.com.br/2022/07/pedfuncs/) | [Download ShareMods](https://sharemods.com/fkum0x0mhyu6/PedFuncs.7z.html)
  - Variações infinitas de roupas, chapéus, óculos e mochilas para pedestres sem repetir modelos.
* **[⚪ PENDENTE] Peds Extender v1.1.5:** [Post MixMods](https://www.mixmods.com.br/2022/08/peds-extender/) | [Download ShareMods](https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html)
  - Corrige e expande a variedade demográfica de pedestres por bairros e biomas de San Andreas.
* **[⚪ PENDENTE] Santa Maria Pier Extended:** [Post MixMods](https://www.mixmods.com.br/2022/12/sa-santa-maria-pier-extended/) | [Download ShareMods](https://sharemods.com/qa2p3422m9am/SA_-_Santa_Maria_Pier_Extended.7z.html)
  - Parque de diversões funcional na praia com carrossel animado, música e pedestres passeando.
