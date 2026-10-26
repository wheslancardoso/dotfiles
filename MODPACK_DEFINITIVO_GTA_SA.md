# 🎮 Modpack Definitivo GTA San Andreas (Base CyberMaike +100 Mods & Anti-Atritos QoL)

*Arquitetura enxuta, 100% fiel à estética clássica refinada (sem shaders PBR pesados e sem sombras dinâmicas pesadas), combinando a curadoria oficial do vídeo **[GTA San Andreas com +100 MODS é insano! (CyberMaike)](https://youtu.be/Xb5gnd2e_PY)** com o pacote **Matador de 55 Atritos & Qualidade de Vida (QoL)**.*

---

### 📑 Sumário da Estrutura
1. [Fundação e Mods Essenciais (Core & Limites de Memória)](#1-fundação-e-mods-essenciais-core--limites-de-memória)
2. [Gráficos Clássicos Refinados, Céu & Distância de Visão (Stack Leve)](#2-gráficos-clássicos-refinados-céu--distância-de-visão-stack-leve)
3. [Correções Visuais, Iluminação, Texturas & Mundo Aberto](#3-correções-visuais-iluminação-texturas--mundo-aberto)
4. [NPCs, Vida Animal, Tráfego & Efeitos da Natureza/Sons](#4-npcs-vida-animal-tráfego--efeitos-da-naturezasons)
5. [Interface, Menus, HUD, Radar & Rádios](#5-interface-menus-hud-radar--rádios)
6. [Veículos: Modelos, Sons, Deformação & Dirigibilidade](#6-veículos-modelos-sons-deformação--dirigibilidade)
7. [Armas, Combate Tático, Balística & Ragdoll](#7-armas-combate-tático-balística--ragdoll)
8. [Gameplay, Movimentação, Animações & CJ](#8-gameplay-movimentação-animações--cj)
9. [Matador de Atritos: 55 Mecânicas Irritantes do GTA SA Resolvidas (QoL & Campanha)](#9-matador-de-atritos-55-mecânicas-irritantes-do-gta-sa-resolvidas-qol--campanha)
10. [Guia Cirúrgico: 100% do Jogo, Coletáveis no Radar, Escolas & Guerras de Gangue](#10-guia-cirúrgico-100-do-jogo-coletáveis-no-radar-escolas--guerras-de-gangue)

---

## 1. Fundação e Mods Essenciais (Core & Limites de Memória)
*Base obrigatória instalada na raiz do GTA San Andreas v1.0 US (`[01:00 – 01:45]` do vídeo).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[Essentials Pack](https://www.mixmods.com.br/2019/06/sa-essentials-pack/)** | Silent, Seemann, Junior_Djjr, LINK/2012, ThirteenAG, Wesser, Swoorup, Fabio | `[01:00]` | Pacote base contendo `SilentPatch`, `CLEO 4 + CLEO+`, `ModLoader`, `Widescreen Fix`, `Framerate Vigilante` e `Silent's ASI Loader`. |
| **[MixSets](https://www.mixmods.com.br/2022/03/sa-mixsets/)** | Junior_Djjr, Comunidade GTA Era 3D | `[01:20]` | Dezenas de correções de engine e otimizações configuradas no [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini) (densidade de tráfego/pedestres e remoção de atritos). |
| **[Improved Streaming](https://www.mixmods.com.br/2026/07/improved-streaming/) / [Proper Streaming](https://www.mixmods.com.br/2026/10/proper-streaming/)** | Junior_Djjr | `[01:38]` | Gerenciamento avançado de memória de modelos (`.dff`) e texturas (`.txd`), eliminando o bug de ruas e paredes piscando ou sumindo. |
| **[Open Limit Adjuster (OLA)](https://www.mixmods.com.br/2016/02/iii-vc-sa-open-limit-adjuster/)** | LINK/2012, ThirteenAG, Blackbird88 | `[01:45]` | Remove dinamicamente os limites arcaicos de memória da engine RenderWare de 2004 (pools de veículos, pedestres, objetos e colisões). |

---

## 2. Gráficos Clássicos Refinados, Céu & Distância de Visão (Stack Leve)
*Visual fiel à direção de arte original da Rockstar com zero perda de FPS — **sem** shaders PBR pesados e **sem** extensores de sombras dinâmicas pesadas (`[06:57 – 08:52]` e `[27:38 – 28:49]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[SkyGfx](https://www.mixmods.com.br/2024/03/sa-skygfx/)** | aap (The Hero) | `[06:57]` | Traz de volta a iluminação, reflexos de veículos e estética autêntica do PS2 para o PC. |
| **[Real Skybox](https://www.mixmods.com.br/2022/10/sa-real-skybox/)** | Junior_Djjr | `[07:09]` | Domo celeste tridimensional com nuvens reais no horizonte que acompanham o ciclo climático. |
| **[Starry Skies](https://www.mixmods.com.br/2018/05/starry-skies-ceu-estrelado/)** | Junior_Djjr | `[07:45]` | Preenche o céu noturno com milhares de estrelas em alta definição e constelações visíveis no interior e deserto. |
| **[Project 2DFX](https://www.mixmods.com.br/2020/02/sa-project2dfx/)** | ThirteenAG, TJGM | `[08:52]` | Aumenta drasticamente a distância de renderização (LOD) e adiciona coronas de luzes noturnas por todo o horizonte das cidades. |
| **[SkyGrad (Sky Effects)](https://www.mixmods.com.br/2015/06/skygrad-corrigir-linhas-no-ceu/)** | Wesser | `[27:38]` | Suaviza o degradê do céu com dithering, eliminando faixas quadradas de transição de cor (*color banding*). |
| **[Enhanced / Refined Classic Graphics](https://www.mixmods.com.br/2021/10/enhanced-classic-graphics/)** | Junior_Djjr | `[28:37]` | Ciclo de cores (*timecyc.dat*) refinado que preserva a identidade clássica de cada região sem saturar nem escurecer a tela. |
| **[IMFX](https://www.mixmods.com.br/2015/03/imfx-lensflare-2dfx/)** | DK22Pac, Function-X-, oksa8 | `[28:44]` | Efeitos óticos leves de *lens flare* solar, fases reais da lua e partículas aprimoradas. |
| **ReShade (Preset Leve)** | crosire / CyberMaike | `[28:49]` | Pós-processamento sutil de nitidez (*sharpen*) e equilíbrio de contraste sem impacto na GPU. |

---

## 3. Correções Visuais, Iluminação, Texturas & Mundo Aberto
*Correção de milhares de falhas do mapa original, iluminação noturna de pontos turísticos e texturas HD (`[02:30 – 08:32]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[Proper Fixes](https://www.mixmods.com.br/2026/06/sa-proper-fixes/)** | Junior_Djjr, Jéssica Natália, StreetFonso, Hysen, Tripaseca, Aal, MJkun17, KaiQ, Zeneric | `[02:30]` | Corrige +15.000 bugs do mapa original (objetos flutuando, colisões invisíveis, texturas tortas e falhas de prelight). |
| **[Lighthouse & Pyramid Fix](https://www.mixmods.com.br/2020/11/lighthouse-pyramid-fix/)** | Junior_Djjr | `[03:12]` | Restaura o feixe de luz rotativo do farol da praia de Santa Maria e o feixe luminoso vertical da pirâmide do The Camel's Toe em LV. |
| **[re:LIT – San Andreas (Real Lights)](https://www.mixmods.com.br/2023/12/sa-relit/)** | luke_slywalker | `[03:33]` | Corrige e adiciona pontos de iluminação realistas em propriedades, fachadas e ruas escuras. |
| **[Project Immerse-Yourself](https://www.mixmods.br/2022/01/project-immerse-yourself-prelight-melhorado/)** | DaftoNTive | `[03:46]` | Refaz o *prelight* (iluminação de vértices) de Los Santos, projetando a luz dos postes suavemente no asfalto e calçadas. |
| **[LS Lit Church](https://www.mixmods.com.br/2022/10/ls-lit-church/)** | Zeneric | `[03:53]` | Ilumina os vitrais da igreja de Jefferson em Los Santos durante a noite. |
| **[Illuminated Vinewood Sign](https://www.mixmods.com.br/2022/05/illuminated-vinewood-sign/)** | Jéssica Natália (Firefly), Junior_Djjr, alex59f | `[04:01]` | Adiciona refletores funcionais iluminando o letreiro de Vinewood à noite. |
| **[Santa Maria Pier Extended](https://www.mixmods.com.br/2022/12/sa-santa-maria-pier-extended/)** | Zeneric, Jéssica Natália | `[04:15]` | Expande o píer de Santa Maria com iluminação noturna, roda-gigante viva e quiosques detalhados. |
| **[LS Downtown Night Windows](https://www.mixmods.com.br/2022/09/ls-downtown-night-windows/)** | Aal, Rizky Aldiansyah | `[04:30]` | Acende as janelas dos arranha-céus do centro de Los Santos à noite. |
| **[Meshsmooth Pack (Smoother / High Poly Pack)](https://www.mixmods.com.br/2022/07/sa-meshsmooth-pack-by-hysen/)** | Hysen | `[04:51]` | Arredonda objetos cilíndricos e estruturas urbanas que eram quadradas em 2004. |
| **[High Poly Desert](https://www.mixmods.com.br/2022/11/high-poly-desert/)** | Zeneric | `[05:07]` | Suaviza as formações rochosas, arcos naturais e montanhas do deserto de Bone County. |
| **[Big Ear SADE (Big Ear Dish)](https://www.mixmods.com.br/2022/01/sade-big-ear/)** | Jéssica Natália | `[05:18]` | Substitui a antena parabólica gigante (*The Big Ear*) pelo modelo 3D detalhado e arredondado. |
| **[Welcome To LV](https://www.mixmods.com.br/2021/05/welcome-to-lv-sign/)** | Andrey 50 AND | `[05:26]` | Remasteriza o letreiro clássico de boas-vindas na entrada de Las Venturas com néon animado. |
| **[Modelos 3D na Ammu-Nation](https://www.mixmods.com.br/2021/07/3d-models-in-ammu-nation/)** | alex59, Rafael de Queiroz Nunes | `[05:40]` | Substitui as prateleiras chapadas 2D das lojas Ammu-Nation por caixas e itens modelados em 3D. |
| **[Missing Lamppost Fix](https://www.mixmods.com.br/2022/04/missing-lampposts-fix-more-light-posts/)** | Junior_Djjr | `[05:54]` | Restaura postes de luz que faltavam em avenidas e cruzamentos escuros. |
| **[Mais Árvores em San Fierro](https://www.mixmods.com.br/2021/03/more-trees-in-san-fierro/)** | Emanuel23 | `[06:10]` | Arboriza parques, ladeiras e avenidas de San Fierro mantendo o estilo original. |
| **[Green Peace (Mais Árvores em Los Santos)](https://www.mixmods.com.br/2020/09/green-peace/)** | CR_crash, Junior_Djjr | `[06:23]` | Adiciona vegetação nativa e árvores em calçadas e praças áridas de Los Santos. |
| **[HD Underwater](https://www.mixmods.com.br/2022/06/sa-hd-underwater/) + Água HD** | Jéssica Natália, Ktn | `[06:29]` | Texturas de água cristalina e fundo do mar enriquecido com corais e vegetação marinha em HD. |
| **[RoSA Project Evolved](https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/)** | Jéssica Natália (Firefly), KUSTODIY, OjTrue, François Declasse, Trok, Eterno | `[07:58]` | Remasterização completa das texturas do mapa (ruas, calçadas, paredes, fachadas e terrenos) em HD 100% fiel ao original. |
| **[DE Palm Trees (The Palm Trees)](https://www.mixmods.com.br/2021/12/sade-palm-trees/)** | Rizky Aldiansyah | `[08:32]` | Substitui as palmeiras de baixa resolução por modelos densos e fiéis sem derrubar o FPS. |

---

## 4. NPCs, Vida Animal, Tráfego & Efeitos da Natureza/Sons
*Transforma San Andreas em um ecossistema vivo e dinâmico com áudio 3D FMOD (`[12:38 – 24:50]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[PedFuncs](https://www.mixmods.com.br/2022/07/pedfuncs/)** | Junior_Djjr | `[12:38]` | Biblioteca base que adiciona variações dinâmicas de texturas e acessórios nos pedestres. |
| **[Original Peds Vary](https://www.mixmods.com.br/2022/07/original-peds-vary/)** | Thiago555aug, Jéssica Natália, Penguinumber9, Junior_Djjr et al. | `[12:44]` | Multiplica as combinações de roupas, cores e rostos dos pedestres originais para evitar clones nas ruas. |
| **[Hats For Peds](https://www.mixmods.com.br/2022/08/hats-for-peds/)** | ArtemQa146 | `[12:57]` | Adiciona bonés, chapéus e gorros variados aos pedestres que caem fisicamente ao levar tiros. |
| **[Urbanize](https://www.mixmods.com.br/2026/02/urbanize/)** | Junior_Djjr | `[13:19]` | Adiciona milhares de NPCs realizando atividades cotidianas pelo mapa (conversando, trabalhando, acampando, sentados em praças e bares). |
| **[Busy Pedestrians (BusyPeds)](https://www.mixmods.com.br/2022/05/busy-pedestrians/)** | ArtemQa146 | `[14:23]` | Pedestres andam pelas ruas carregando sacolas de compras, mochilas, malas, tomando café ou falando ao celular. |
| **[Lively Trailers (Livelier Trailers)](https://www.mixmods.com.br/2022/03/lively-trailers/)** | Cowboy69 | `[15:42]` | Dá vida aos parques de trailers no interior e deserto com moradores, churrasqueiras, cadeiras e veículos estacionados. |
| **[Realistic Beach](https://www.mixmods.com.br/2021/01/realistic-beach/)** | Junior_Djjr | `[15:54]` | Povoa as praias com banhistas em toalhas, guarda-sóis, salva-vidas e pessoas nadando no mar. |
| **[Real Traffic Fix](https://www.mixmods.com.br/2022/04/real-traffic-fix/)** | Junior_Djjr | `[16:07]` | Corrige a IA do trânsito: motoristas mantêm distância segura, freiam em obstáculos e param de jogar o carro contra o jogador nas rodovias. |
| **[NPC Tuning](https://www.mixmods.com.br/2021/02/npc-tuning/)** | Junior_Djjr | `[16:32]` | Faz aparecerem carros levemente tunados e personalizados dirigidos por NPCs no tráfego comum. |
| **[Truck Trailer](https://www.mixmods.com.br/2019/05/truck-trailer/)** | Kenking | `[16:45]` | Faz caminhões e carretas circularem pelas rodovias rebocando cargas e trailers variados. |
| **[Cars On the Dirt Roads](https://www.mixmods.com.br/2020/07/cars-on-dirt-roads/)** | Junior_Djjr | `[16:51]` | Habilita tráfego de caminhonetes, tratores e jipes nas estradas de terra do interior e deserto. |
| **[Animated Blimp](https://www.mixmods.com.br/2022/09/animated-blimp/) + Blimp Mod** | Jéssica Natália, Junior_Djjr, TrushinVlad, akiri | `[17:22]` | Adiciona dirigíveis publicitários sobrevoando o céu das metrópoles com letreiros iluminados. |
| **[Balloon Of Cities](https://www.mixmods.com.br/2021/08/hot-air-balloons/)** | akiri | `[21:06]` | Balões de ar quente coloridos sobrevoando o horizonte e os vales de San Andreas. |
| **[Air Traffic Pro + Realism](https://www.mixmods.com.br/2020/11/air-traffic/)** | olmstead007, YyHhGgTt | `[22:12]` | Tráfego aéreo inteligente de jatos, helicópteros e aviões comerciais pousando e decolando nos aeroportos sem cair na cabeça do jogador. |
| **[The Birds Update](https://www.mixmods.com.br/2019/10/the-birds-update/)** | LINK/2012, Junior_Djjr | `[23:10]` | Bandos de pássaros e gaivotas voando pelo céu com comportamento natural. |
| **[Wind Project](https://www.mixmods.com.br/2022/10/wind-project/)** | Junior_Djjr | `[23:27]` | Adiciona movimento físico de vento nos galhos e copas de todas as árvores e arbustos do jogo. |
| **[NextGen And Combat FX Plus](https://www.mixmods.com.br/2022/04/nextgen-effects/)** | WarButler, DK22Pac, Junior_Djjr, Ezekiel, Function-X, KaiQ | `[23:41]` | Partículas em alta definição para faíscas, fumaça, respingos de água, poeira e explosões. |
| **[Flying Stuff](https://www.mixmods.com.br/2019/07/flying-stuff/)** | Function-X-, Zaz, Junior_Djjr | `[24:01]` | Folhas secas, papéis e jornais voando pelo chão com o vento nas calçadas e florestas. |
| **[Insects On Country Zones](https://www.mixmods.com.br/2022/08/insects-mod/)** | Junior_Djjr | `[24:08]` | Insetos e mariposas voando em zonas rurais e ao redor de lâmpadas de postes à noite. |
| **[Firefly Mod (Vagalumes)](https://www.mixmods.com.br/2021/06/fireflies-mod/)** | akiri | `[24:20]` | Vagalumes brilhando à noite nas matas de Flint County, Red County e Whetstone. |
| **[Wind Farm (Turbinas Eólicas)](https://www.mixmods.com.br/2022/02/wind-farm/)** | Junior_Djjr, Sket_h, Jéssica Natália | `[24:37]` | Parque de turbinas eólicas gigantes girando no deserto de Bone County. |
| **[Soundize (FMOD Audio Engine)](https://www.mixmods.com.br/2026/06/soundize/)** | Junior_Djjr | `[24:50]` | Revolução sonora com motor FMOD: sons ambientes 3D por bioma, reverberação real em túneis/interiores e novos sons mecânicos e climáticos. |

---

## 5. Interface, Menus, HUD, Radar & Rádios
*Menus em 4K, tradução PT-BR fiel, roda de armas/rádios ágil e acervo de rádio expandido (`[09:55 – 11:42]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[Atmosphere Interface Pack](https://www.mixmods.com.br/2021/11/atmosphere-interface-pack/)** | Jéssica Natália (Firefly), War Drum Studios, IvoryColt, HermeSSentinuS | `[09:55]` | Remasteriza toda a interface de usuário, ícones e menus em alta resolução mantendo o estilo clássico. |
| **[Loadscreens 4K Definitive](https://www.mixmods.com.br/2021/09/loadscreens-4k-definitive/)** | Jéssica Natália, Junior_Djjr, Comunidade MixMods | `[10:02]` | Telas de carregamento originais reconstruídas em 4K nativo e Widescreen. |
| **[Mobile Font Fixes](https://www.mixmods.com.br/2020/05/mobile-font-fixed/)** | War Drum Studios | `[10:15]` | Fontes perfeitamente nítidas e sem serrilhado em monitores Full HD / 2K / 4K. |
| **[Tradução PT-BR Definitiva MixMods](https://www.mixmods.com.br/2020/01/traducao-pt-br-mixmods/)** | Afrânio Bezerra de Souza, MJay/MJarcos, Junior_Djjr, Carinha do GTA | CSV | Tradução revisada sem erros de português, mantendo as gírias originais dos anos 90 sem censura e com acentuação perfeita. |
| **[Show Only Necessary HUD](https://www.mixmods.com.br/2021/04/show-only-necessary-hud/)** | Israel | `[10:34]` | Oculta elementos da HUD quando o CJ está com vida/munição cheias e fora de combate, limpando a tela para máxima imersão. |
| **[Void Weapon Wheel](https://www.mixmods.com.br/2023/05/void-weapon-wheel/)** | Void | `[10:53]` | Roda de seleção rápida de armas estilo GTA V com câmera lenta opcional. |
| **[Void Radio Wheel](https://www.mixmods.com.br/2023/05/void-radio-wheel/)** | Void | `[11:10]` | Roda rápida de estações de rádio exibindo o logo da rádio, nome da música e artista atual. |
| **[Proper Radar](https://www.mixmods.com.br/2022/02/proper-radar/)** | Junior_Djjr, Grove Street Games, Jéssica Natália | `[11:21]` | Mapa e radar redesenhados em alta definição com cores fiéis e precisão geográfica. |
| **[More Radar Icons](https://www.mixmods.com.br/2022/01/more-radar-icons/)** | Junior_Djjr, Rill24_ (iceman_) | `[11:28]` | Adiciona ícones úteis no radar para locais antes ocultos (lojas 24/7, aeroportos, oficinas e pontos de interesse). |
| **[HD Movies](https://www.mixmods.com.br/2020/08/hd-movies/)** | Junior_Djjr, Firefly | `[11:42]` | Vídeos de abertura e logos da Rockstar remasterizados em alta definição e 60 FPS. |
| **[Original Radio Extended (1000 Músicas)](https://www.mixmods.com.br/2024/08/original-radio-extended/)** | Comunidade MixMods | Extra QoL | Restaura 100% das músicas cortadas pela Rockstar e expande as rádios originais com clássicos dos anos 90 e vinhetas oficiais dos DJs. |

---

## 6. Veículos: Modelos, Sons, Deformação & Dirigibilidade
*Frota 100% fiel aos anos 90 com peças móveis, sons sem compressão e física de colisão realista (`[29:31 – 32:42]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[VehFuncs](https://www.mixmods.com.br/2025/12/sa-vehfuncs/)** | Junior_Djjr, Fabio | `[29:31]` | Adiciona peças móveis funcionais nos veículos (volante girando, limpadores de para-brisa, pedais, ventoinhas do motor e engates). |
| **[Model Extras](https://www.mixmods.com.br/2023/01/model-extras/)** | Grinch_ | `[29:31]` | Suporte avançado a recursos visuais extras em veículos e armas (luzes, velocímetros e acessórios). |
| **[Revamped Vehicles Project (RVP)](https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/)** | KiloRyu | `[29:45]` | Remasteriza todos os veículos originais do jogo corrigindo bugs de simetria, rodas redondas e adaptação nativa ao VehFuncs. |
| **[Proper Vehicles Retex](https://www.mixmods.com.br/2022/02/sa-sade-proper-vehicles-retex/)** | Miguel Araújo, Jéssica Natália, Junior_Djjr, CassadorEterno et al. | `[30:20]` | Texturas em alta definição para interiores, painéis, bancos, faróis e emblemas de toda a frota original. |
| **[Uncompressed SFX Pack](https://www.mixmods.com.br/2021/03/uncompressed-sfx-pack/)** | MrFinger, BeyondTheVeilOfDeath, Son Of Big Boss et al. | `[30:32]` | Substitui os áudios abafados de 2004 pelos sons originais de motores, pneus e portas sem compressão (alta fidelidade). |
| **[Camera Settings](https://www.mixmods.com.br/2022/07/camera-settings/)** | ArtemQa146 | `[30:54]` | Adiciona sensação real de velocidade, inércia nas curvas e balanço suave de câmera ao dirigir. |
| **[VehDeform (Back Deform)](https://www.mixmods.com.br/2025/06/sa-vehdeform-amassar-carros/)** | ZZPuma | `[31:05]` | Deformação física dinâmica da lataria dos carros de acordo com o ponto e força da batida (estilo GTA IV). |
| **[Vehicle Collision Cam Shake](https://www.mixmods.com.br/2021/09/vehicle-collision-cam-shake/)** | HybridTheory | `[31:35]` | Tremor proporcional de câmera ao bater o veículo em alta velocidade. |
| **[Blur On Car Collisions](https://www.mixmods.com.br/2021/10/blur-on-car-collisions/)** | Jaehaerys | `[31:47]` | Efeito rápido de impacto visual ao sofrer colisões violentas de trânsito. |
| **[Bike Flip Fix](https://www.mixmods.com.br/2020/11/bike-flip-fix/)** | nadalao | `[32:00]` | Corrige a física de rotação aérea de motos e bicicletas durante mortais e saltos acrobáticos. |
| **[DrIVe Mod](https://www.mixmods.com.br/2022/08/drive-mod/)** | ArtemQa146 | `[32:17]` | Animações detalhadas ao dirigir: CJ abaixa o vidro elétrico ao mirar, quebra o vidro de carros trancados para roubar e olha para trás na ré. |
| **[Rear Lights Mod](https://www.mixmods.com.br/2022/05/rear-lights-mod/)** | ArtemQa146 | `[32:24]` | Rastro luminoso suave nas lanternas traseiras ao acelerar à noite (estilo Need for Speed). |
| **[Advanced Nitro System](https://www.mixmods.com.br/2023/02/advanced-nitro-system/)** | Void | `[32:42]` | Sistema moderno de purga e recarga de Nitro com barra dedicada e labaredas reais pelo escapamento. |

---

## 7. Armas, Combate Tático, Balística & Ragdoll
*Transforma o tiroteio do GTA SA com física de impacto, recarga manual, câmera no ombro e drive-by livre (`[34:28 – 41:25]`).*  
*(Nota: O mod `Combat Improvement and Melee Overhaul` foi **intencionalmente removido** desta categoria para manter a luta corpo a corpo original intacta conforme preferência).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[Weapon Details](https://www.mixmods.com.br/2022/06/weapon-details/)** | ArtemQa146 | `[34:28]` | Adiciona ferrolho móvel nas armas, ejeção física de pentes no chão ao recarregar, fumaça no cano quente e armas sujando na lama. |
| **[Immersive Weapons Pack](https://www.mixmods.com.br/2023/01/immersive-weapons-pack/)** | pedrowav | `[35:00]` | Modelos de armas remasterizados em alta definição e 100% compatíveis com o Weapon Details. |
| **[Weapon is on the Player (Weapons OutFit)](https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/)** | ArtemQa146 | `[35:08]` | Exibe as armas do inventário penduradas nas costas e na cintura do CJ em tempo real. |
| **[Dynamic Weapon Draw Sound](https://www.mixmods.com.br/2022/04/dynamic-weapon-draw-sound/)** | ThePedro004 | `[35:20]` | Sons mecânicos realistas de coldre e bandoleira ao sacar ou guardar cada tipo de arma. |
| **[Realistic Weapons Settings](https://www.mixmods.com.br/2021/07/realistic-weapon-settings/)** | Kawaii_Neko | `[35:40]` | Habilita recarga manual e calibra cadência, alcance e precisão balística de todo o arsenal. |
| **[Throw Rotate Fix (True Rotate Fix)](https://www.mixmods.com.br/2020/03/throw-rotate-fix/)** | Junior_Djjr | `[36:00]` | Faz granadas, coquetéis molotov e bombas remotas girarem no ar com física real ao serem arremessados. |
| **[Spread Fix](https://www.mixmods.com.br/2018/07/spread-fix/)** | Ryosuke839 | `[36:07]` | Corrige a dispersão (recoil/bloom) do retículo de mira em resoluções Widescreen e 60 FPS. |
| **[Advanced Aiming Mod](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/)** | DK22Pac, Junior_Djjr | `[36:19]` | Câmera tática sobre o ombro (*Over-The-Shoulder*) ao mirar, permitindo andar e atirar com qualquer arma. |
| **[Blur On CameraShake](https://www.mixmods.com.br/2017/05/blur-on-camera-shake/)** | LINK/2012 | `[36:31]` | Ondas de choque visual quando granadas, carros e foguetes explodem perto do CJ. |
| **[Shot Cam Shake (Shotgun Shake)](https://www.mixmods.com.br/2021/08/shot-cam-shake/)** | Junior_Djjr, IamMiguel1 | `[36:46]` | Impacto e tremor seco de câmera ao disparar calibres pesados (escopetas, Desert Eagle e Sniper). |
| **[Weapon Recoil Auto](https://www.mixmods.com.br/2021/10/weapon-recoil-auto/)** | HzanRsxa2959 | `[36:53]` | Recuo vertical progressivo e realista ao segurar o dedo no gatilho em armas automáticas. |
| **[Kill Cam](https://www.mixmods.com.br/2022/09/kill-cam/)** | ArtemQa146 | `[37:06]` | Câmera dramática opcional focando na queda do último inimigo abatido em tiroteios intensos (estilo Max Payne). |
| **[Bullet View](https://www.mixmods.com.br/2021/12/bullet-view/)** | XxxSalahxxX | `[37:33]` | Câmera cinematográfica acompanhando o projétil da Sniper em disparos fatais de longa distância (estilo Sniper Elite). |
| **[Stealth Kill Camera](https://www.mixmods.com.br/2020/06/stealth-kill-camera/)** | Junior_Djjr | `[37:53]` | Corrige e suaviza o ângulo de câmera durante execuções furtivas com a faca por trás. |
| **[Sprinting With Two Handed Weapons](https://www.mixmods.com.br/2018/10/correr-com-armas-pesadas-correr-com-rifle/)** | _AG | `[38:10]` | Permite correr em velocidade máxima segurando fuzis (AK-47, M4), escopetas e rifles. |
| **[Weapon Reanimation](https://www.mixmods.com.br/2022/03/weapon-reanimation/)** | Clum_sie | `[38:23]` | Animações táticas fluidas de empunhadura, tiro e recarga para todas as armas de fogo. |
| **[Manual Driveby Remake](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/)** | CatchyKetchup et al. | `[38:39]` | Permite mirar livremente em 360° com o mouse de dentro de qualquer carro, moto ou bicicleta usando a cadência real da arma. |
| **[Gangster Walk Fix](https://www.mixmods.com.br/2021/05/gangster-walk-fix/)** | The Eddo | `[39:10]` | Corrige a postura torta das pernas e tronco ao caminhar mirando com armas no nível *Gangster*. |
| **[PedSkills](https://www.mixmods.com.br/2022/01/pedskills/)** | Junior_Djjr | `[39:16]` | IA avançada em tiroteios: policiais, SWAT, exército e gangues têm níveis distintos de precisão, esquiva e cadência de tiro. |
| **[Ragdoll Bullet Physics](https://www.mixmods.com.br/2021/09/mod-ragdoll-bullet-physics-fix-fisica-realista/)** | madleg, Bullet Physics, sociopart, Crspy | `[40:00]` | Física real de corpos (*ragdoll*): inimigos reagem ao local exato do tiro, rolam escadas e voam sobre o capô em atropelamentos. |
| **[Blood Effects (NextGen & CombatFX Plus)](https://www.mixmods.com.br/2022/04/nextgen-effects/)** | KaiQ, WarButler, DK22Pac, Junior_Djjr | `[40:51]` | Efeitos realistas de impacto balístico e sangue sem exagero cartunesco. |
| **[Reload On The Screen](https://www.mixmods.com.br/2022/07/reload-on-screen/)** | ArtemQa146 | `[41:16]` | Aviso sutil e imersivo quando o pente da arma está prestes a esvaziar. |
| **[SleekHitmarkers](https://www.mixmods.com.br/2023/03/sleek-hitmarkers/)** | pedrowav | `[41:25]` | Marcador minimalista na mira confirmando acertos no alvo e tiros fatais (*headshots*). |
| **[[III/VC/SA] AllWeapon](https://www.mixmods.com.br/2021/06/iii-vc-sa-allweapon-ter-todas-as-armas/)** | Junior_Djjr | Extra QoL | Permite carregar todas as armas da mesma categoria simultaneamente (ex: AK-47 + M4, Desert Eagle + 9mm) sem que uma apague a outra. |

---

## 8. Gameplay, Movimentação, Animações & CJ
*Remasterização do CJ, troca rápida de roupas, escadas funcionais e câmeras dinâmicas (`[41:40 – 45:00]`).*

| Mod | Autor(es) | Timestamp | Função Técnica |
| :--- | :--- | :---: | :--- |
| **[Proper Player Retex](https://www.mixmods.com.br/2022/05/proper-player-retex/)** | Jéssica Natália, Junior_Djjr, OjTrue, Zeneric, Jão, François Declasse | `[41:40]` | Remasteriza em alta definição o corpo, rosto, cortes de cabelo, tatuagens e todas as roupas do CJ mantendo 100% da fidelidade original. |
| **[Faster Clothes Changer](https://www.mixmods.com.br/2019/11/faster-clothes-changer/)** | Junior_Djjr | `[42:10]` | Elimina a demora insuportável do CJ entrando e saindo do provador; as roupas trocam instantaneamente ao clicar no menu. |
| **[Sprint Everywhere](https://www.mixmods.com.br/2021/04/sprint-everywhere/)** | HzanRsxa2959 | `[42:35]` | Permite correr em velocidade máxima dentro de qualquer interior (casas, cassinos, delegacias, lojas). |
| **[Improved Jetpack Control](https://www.mixmods.com.br/2020/09/improved-jetpack-control/)** | Junior_Djjr | `[42:55]` | Torna o voo com o Jetpack mais ágil, responsivo e rápido. |
| **[HeliFix](https://www.mixmods.com.br/2021/10/helifix-piloto-nos-helicopteros/)** | Grinch_ | `[43:15]` | Adiciona pilotos visíveis dentro dos helicópteros da polícia/noticiário e corrige o efeito de rotação das hélices. |
| **[Animation Fix + M4k3 New Car Animations](https://www.mixmods.com.br/2022/02/animation-fix-v1-5-corrigir-bugs-de-animacoes/)** | MMK_033, M4k3 | `[43:40]` | Corrige dezenas de animações quebradas de 2004 e adiciona posturas naturais ao dirigir carros e motos. |
| **[Ladders Mod (Use All Ladders)](https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/)** | Junior_Djjr | `[44:10]` | Torna todas as escadas de mão em prédios, docas, navios e torres 100% escaláveis com animação real. |
| **[SACamFX](https://www.mixmods.com.br/2022/11/sacamfx/)** | 4Arty | `[44:35]` | Câmera de terceira pessoa suave e cinematográfica a pé, em corrida e em queda livre. |

---

## 9. Matador de Atritos: 55 Mecânicas Irritantes do GTA SA Resolvidas (QoL & Campanha)
*Todas as frustrações clássicas do jogo base eliminadas via [`MixSets_Otimizado.ini`](file:///home/lanwsl/dotfiles/MixSets_Otimizado.ini) e scripts cirúrgicos.*

| # | Atrito / Irritação Original do Jogo | Solução Técnica Definitiva | Mod / Configuração Responsável |
| :--- | :--- | :--- | :--- |
| **01** | **Carro capotado pega fogo em 3 segundos** e explode com o CJ dentro. | Desativa o fogo automático quando o veículo está de cabeça para baixo. | **MixSets.ini** -> `NoCarFlipFire = 1` |
| **02** | **Câmera do veículo girando sozinha** (auto-center forçado ao mexer o mouse ao dirigir). | Libera a câmera 360° no mouse sem reset forçado para a frente. | **MixSets.ini** -> `NoMouseCentering = 1` |
| **03** | **Perder todas as armas ao morrer ou ser preso** (Wasted / Busted). | Mantém todo o arsenal do CJ após sair do hospital ou da delegacia. | **MixSets.ini** -> `KeepWeaponsAfterWasted = 1` e `KeepWeaponsAfterBusted = 1` |
| **04** | **Correr travado em interiores** (CJ só anda a passo de tartaruga em casas, lojas e cassinos). | Habilita o sprint / corrida máxima dentro de qualquer interior. | **MixSets.ini** -> `SprintInInteriors = 1` + *Sprint Everywhere* |
| **05** | **Ataques de Gangue no meio de viagens** (perder território em LS quando estiver em SF ou Las Venturas). | Bloqueia alertas e ataques aleatórios enquanto estiver fora ou focado em missões. | **MixSets.ini** -> `NoGangAttacks = 1` |
| **06** | **Sem GPS no minimapa** (apenas um quadrado cinza estático no radar sem caminho no asfalto). | Traça rota dinâmica em tempo real no asfalto e no minimapa (estilo GTA IV/V). | [GPS Redux v1.5](https://www.mixmods.com.br/2022/10/sa-gps-redux/) |
| **07** | **Mira estática e dura** (CJ vira estátua ao mirar com rifles; sem strafe ou movimentação). | Mira moderna no ombro (Over-The-Shoulder), movimentação livre e câmera fluida. | [Advanced Aiming Mod v1.4](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/) |
| **08** | **Drive-By com cadência lenta artificial** e mira travada em 90° em Q e E (pesadelo nas perseguições do Freddy/OG Loc e Jizzy B). | Libera mira 360° no mouse disparando com a cadência REAL da arma, dano total baseado na Weapon Skill e suporte a fuzis/granadas. | [Manual Driveby Remake (Fixed)](https://www.mixmods.com.br/2021/10/manual-driveby-remake-fixed-mirar-de-dentro-do-carro/) |
| **09** | **Troca de armas lenta** (ter que ficar rolando a scroll wheel passando por 10 armas). | Roda de armas moderna com slow motion tático estilo GTA V. | [Void Weapon Wheel](https://www.mixmods.com.br/2023/05/void-weapon-wheel/) |
| **10** | **Perda constante de músculos e fome excessiva** (ter que parar missões para ir à lanchonete). | Congela a degradação passiva forçada de atributos físicos do CJ. | **MixSets.ini** -> `NoMuscleDecay = 1` e `NoFatDecay = 1` |
| **11** | **Intros e vídeos longos na inicialização** e menus demorados antes de jogar. | Auto-carrega o save direto na rua em <2s sem menus. | [SaveLoader v2.7](https://www.mixmods.com.br/2020/01/iii-vc-sa-saveloader-v2-7-fast-loader-carregamento-rapido/) |
| **12** | **Física e natação quebradas em monitores de 60Hz/144Hz** (CJ nada devagar, carros aceleram errado). | Ajusta todos os laços de física e timers para taxas altas de quadros. | [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **13** | **Salvar o jogo apenas em safehouses** (ter que cruzar o estado para registrar o progresso). | Salva automaticamente ao terminar missões ou via Quick Save a qualquer momento. | [Autosave Mod](https://www.mixmods.com.br/2019/08/tela-de-salvamento-ao-terminar-missoes-v2-0-1/) |
| **14** | **Tráfego homicida** (NPCs batendo de propósito na traseira e mudando de faixa de forma caótica). | IA de trânsito realista com distância segura, frenagem lógica e sem manobras suicidas. | [Real Traffic Fix](https://www.mixmods.com.br/2022/04/real-traffic-fix/) |
| **15** | **Suporte horrível a controles modernos** (falta de vibração, botões trocados, mira descalibrada). | Suporte completo a gamepads de Xbox e PS4/PS5 com XInput nativo e ícones na tela. | [GInput](https://www.mixmods.com.br/2020/06/ginput/) |
| **16** | **Minigame do Lowrider & Dança na Praia impossíveis no PC** (setas fora do ritmo, comandos travados no Numpad e pontuação implacável). | Sincroniza o timing musical a 60 FPS, amplia a tolerância de acerto para pontuação máxima (*Perfect Hit / Auto-Dance Assist*) ou permite aprovar a missão em 1 clique no Cheat Menu. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) + *Auto-Dance & Lowrider Perfect Assist* + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **17** | **Missão de Roubo da Van do Ryder (*Home Invasion*)** com medidor de barulho hipersensível ao andar agachado. | Normaliza o raio acústico de passos e acelera a movimentação ao carregar as caixas de munição. | **MixSets.ini** + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **18** | **Motos ejetando o CJ em colisões leves** e capotando fácil em saltos. | Corrige a física de rotação aérea e amortecimento nas duas rodas. | [Bike Flip Fix](https://www.mixmods.com.br/2020/11/bike-flip-fix/) + [VehFuncs](https://www.mixmods.com.br/2025/12/sa-vehfuncs/) |
| **19** | **GPS traçando rotas apenas para pontos manuais** (sem caminho para as missões da campanha). | O GPS traça linha dinâmica em tempo real para os objetivos de qualquer missão ativa da história. | [GPS Redux v1.5](https://www.mixmods.com.br/2022/10/sa-gps-redux/) |
| **20** | **Extintor de incêndio ineficaz** (spray com colisão quebrada e chamas que não apagam na missão da Denise). | Corrige o cone de alcance da espuma e permite usar o extintor para apagar carros em chamas. | [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) + [Extintor Apaga Fogo do Carro](https://www.mixmods.com.br/2016/03/extintor-apaga-fogo-do-carro.html) |
| **21** | **Missão de Paramédico / Ambulância arruinada por NPCs suicidas** (pacientes que se jogam embaixo do pneu). | Pacientes desviam do veículo em vez de correrem na frente das rodas e ambulância não pega fogo se capotar. | *Ped Evade Car Fix* + **MixSets.ini** (`NoCarFlipFire = 1`) |
| **22** | **Tap-Tap na moto para ir mais rápido** (ter que ficar martelando a seta para cima para o CJ inclinar o corpo). | O CJ inclina o corpo aerodinamicamente de forma automática ao atingir velocidade máxima apenas segurando W. | *Auto Lean Forward* / **MixSets.ini** |
| **23** | **Carros desaparecendo sozinhos (*Despawn*)** na porta de lojas ao entrar no provador ou virar as costas. | O último veículo utilizado pelo jogador tem prioridade máxima de memória e nunca sofre despawn fora da tela. | *Never Despawn* + **MixSets.ini** |
| **24** | **Aviões caindo do céu do nada na sua cabeça** (aviões de ambiente colidindo com prédios e explodindo o CJ). | Corrige a altitude e a IA das rotas aéreas em San Andreas, impedindo quedas acidentais sobre o jogador. | [Air Traffic Pro + Realism](https://www.mixmods.com.br/2020/11/air-traffic/) + [SilentPatch](https://www.mixmods.com.br/2026/08/sa-silentpatch/) |
| **25** | **Limite mentiroso das garagens** (garagem vazia dizendo que está cheia ao tentar guardar mais de 4 veículos). | Remove a trava arbitrária da Rockstar, permitindo armazenar até 8 veículos por garagem. | *Garage eXtender* + [Open Limit Adjuster](https://www.mixmods.com.br/2016/02/iii-vc-sa-open-limit-adjuster/) |
| **26** | **Pedestres ladrões roubando seu carro raro estacionado** (CJ desce do Turismo e um NPC entra e foge). | Tranca automaticamente as portas do veículo do jogador ao descer. | *Lock And Park* |
| **27** | **O pesadelo da missão *Stowaway*** (subir de moto na rampa do avião enquanto barris caem). | Normaliza a taxa de aceleração da moto e do avião cargueiro, permitindo alcançar a rampa com facilidade em 60 FPS. | [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **28** | **Carro recém-tunado batido na saída da oficina** (NPCs spawnando e colidindo na porta da Wheel Arch Angels). | Motoristas freiam e respeitam a saída das oficinas de modificação sem bater. | [Real Traffic Fix](https://www.mixmods.com.br/2022/04/real-traffic-fix/) |
| **29** | **Tiros batendo em paredes invisíveis** (quinas de prédios e muretas com colisão estendida no ar e cercas de arame bloqueando balas como concreto). | Recorta as caixas de colisão de mais de 10.000 objetos milimetricamente no contorno visual e permite tiros através de grades. | [Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) |
| **30** | **Empilhadeira da missão do Ryder (*Robbing Uncle Sam*)** com caixas escorregando e Ryder morrendo fácil. | Estabiliza as caixas no garfo, amplia o tempo do portão e dá IA defensiva ao Ryder. | [Proper Fixes](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **31** | **Lança-mísseis lerdo e frustrante** e **trava de mira lerda do caça Hydra e helicóptero Hunter**. | Reduz o lock-on do Hydra de 1000ms para 150ms no MixSets e libera mira em 3ª pessoa para armas pesadas. | **MixSets.ini** (`HydraLockDelay = 150`, `HydraRocketDelay = 150`, `NoHydraSpeedLimit = 1`) + [Advanced Aiming Mod](https://www.mixmods.com.br/2022/06/advanced-aiming-mod/) |
| **32** | **Alcance ridículo da Sniper Rifle** (pedestres e veículos somem na mira telescópica a ~100 metros). | Aumenta o raio de renderização de alvos e o alcance balístico na mira da Sniper. | [Sniper Distance Fix](https://www.mixmods.com.br/2018/09/sniper-distance-fix-aumentar-alcance-da-sniper/) |
| **33** | **Alvos de sub-missões gerados no fim do mundo** e perda de todo o progresso se falhar no nível 11/12. | Permite usar qualquer veículo no Vigilante e garante recompensas/conclusão sem frustração. | [Vigilante Special](https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/) + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **34** | **Correr travado como uma tartaruga com armas longas** (fuzis M4, AK-47, escopetas e sniper forçando o CJ a andar devagar). | Permite sprintar e correr no máximo segurando rifles e armas de duas mãos. | [Sprinting With Two Handed Weapons](https://www.mixmods.com.br/2018/10/correr-com-armas-pesadas-correr-com-rifle/) |
| **35** | **Armas invisíveis no bolso do CJ** e falta de vida biológica no interior/céu. | Torna armas visíveis em coldres/bandoleiras nas costas e povoa céus e matas com pássaros, insetos e vagalumes. | [Weapon is on the Player](https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/) + [The Birds Update](https://www.mixmods.com.br/2019/10/the-birds-update/) + [Firefly Mod](https://www.mixmods.com.br/2021/06/fireflies-mod/) |
| **36** | **Veículos com rodas quadradas/octogonais e interiores borrados de 2004**. | Remasteriza toda a frota original com rodas redondas, peças móveis e texturas internas em HD sem pesar. | [Revamped Vehicles Project](https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/) + [Proper Vehicles Retex](https://www.mixmods.com.br/2022/02/sa-sade-proper-vehicles-retex/) + [VehFuncs](https://www.mixmods.com.br/2025/12/sa-vehfuncs/) |
| **37** | **Efeitos climáticos e de partículas datados** (fumaça quadrada, explosões sem impacto e árvores estáticas). | Partículas em HD leves, vento físico nas árvores e acústica de tempestade realista via FMOD (sem shaders pesados). | [NextGen And Combat FX Plus](https://www.mixmods.com.br/2022/04/nextgen-effects/) + [Wind Project](https://www.mixmods.com.br/2022/10/wind-project/) + [Soundize](https://www.mixmods.com.br/2026/06/soundize/) |
| **38** | **Cidades escuras como breu à noite, prédios apagados e pontos turísticos sem luz**. | Renderiza luzes LOD até o horizonte, acende janelas de arranha-céus, igreja, farol, pirâmide e letreiro de Vinewood. | [Project 2DFX](https://www.mixmods.com.br/2020/02/sa-project2dfx/) + [LS Downtown Night Windows](https://www.mixmods.com.br/2022/09/ls-downtown-night-windows/) + [re:LIT](https://www.mixmods.com.br/2023/12/sa-relit/) + [Project Immerse-Yourself](https://www.mixmods.com.br/2022/01/project-immerse-yourself-prelight-melhorado/) + [Missing Lamppost Fix](https://www.mixmods.com.br/2022/04/missing-lampposts-fix-more-light-posts/) |
| **39** | **Ter que espremer e martelar teclas na academia (*Button Mashing*)** (ficar apertando Espaço e Shift freneticamente, limite diário e perda de músculos). | Converte o minigame em "segurar a tecla" (*Hold Key to Workout*), remove o limite diário de treino e congela a perda passiva de músculos. | *Hold Key Gym Minigame* + **MixSets.ini** (`NoMuscleDecay = 1`, `NoFatDecay = 1`) |
| **40** | **Polícia onisciente/telepática e cega para outras gangues** (atirar no deserto vazio dá estrela sem testemunhas enquanto Ballas atiram na viatura impunes). | A polícia só é acionada se houver testemunhas e policiais enquadram e atiram em gangues rivais armadas. | *Sensible Police & Crime Report* + **MixSets.ini** (`CopsShootGangs = 1`) |
| **41** | **Carros com freios fracos e falta de ângulo para drift**. | Calibra potência de frenagem, esterçamento em alta velocidade e permite ativar modo Drift sob demanda. | *Toggle Drift Mod* + **MixSets.ini** (`BrakePower = 1.25`, `CarsSteeringAngleHighSpeed = 0.6`) |
| **42** | **Demora absurda no provador de roupas e restrição da van Boxville para roubar casas**. | Troca de roupas instantânea no menu e permite roubar casas com qualquer veículo. | [Faster Clothes Changer](https://www.mixmods.com.br/2019/11/faster-clothes-changer/) + [Burglary With Any Car v2.0](https://www.mixmods.com.br/2022/01/sa-sade-burglary-with-any-car-roubar-casa-com-qualquer-carro/) |
| **43** | **Armas substituindo e apagando umas às outras no mesmo slot** (comprar uma AK-47 destrói a M4; pegar uma 9mm apaga a Desert Eagle). | Permite carregar simultaneamente todas as armas de cada categoria alternando na Roda de Armas ou nas teclas `1`–`9`. | [[III/VC/SA] AllWeapon](https://www.mixmods.com.br/2021/06/iii-vc-sa-allweapon-ter-todas-as-armas/) + **MixSets.ini** (`NoWeaponDropOnPickup = 1`) |
| **44** | **Milhares de bugs no mapa original** (árvores flutuando, buracos no chão onde o CJ cai no limbo e montanhas do deserto quadradas). | Corrige +15.000 bugs de mapa da Rockstar e suaviza a malha poligonal do deserto e objetos. | [Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + [High Poly Desert](https://www.mixmods.com.br/2022/11/high-poly-desert/) + [Meshsmooth Pack](https://www.mixmods.com.br/2022/07/sa-meshsmooth-pack-by-hysen/) |
| **45** | **Ligações telefônicas interrompendo tiroteios** (CJ guarda a arma à força para atender celular no meio de emboscada e morre). | Bloqueia chamadas automáticas sob combate e permite cortar qualquer ligação com `Espaço`/`Tab`. | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **46** | **Deletar o Save Game por acidente no menu** e **tela de tutorial forçada na 1ª ida ao hospital/delegacia**. | Pula o menu inicial carregando o save direto e desativa todos os tutoriais forçados (`NoTutorials = 1`). | [SaveLoader v2.7](https://www.mixmods.com.br/2020/01/iii-vc-sa-saveloader-v2-7-fast-loader-carregamento-rapido/) + **MixSets.ini** (`NoTutorials = 1`) |
| **47** | **Horários restritos de missões ("Come back between 20:00 and 6:00")** (dar de cara com a porta trancada às 06:01). | Destrava os marcadores de missão 24h por dia avançando o relógio automaticamente na entrada. | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **48** | **Escadas puramente decorativas no porto e píeres** (cair na água em San Fierro e ficar preso nadando porque as escadas na parede não funcionam). | Torna todas as escadas de mão em portos, docas, navios e fachadas **100% escaláveis**. | [Ladders Mod (Use All Ladders)](https://www.mixmods.com.br/2020/05/use-all-ladders-subir-em-escadas/) |
| **49** | **Postura de caminhada quebrada ao mirar** e inimigos com IA burra em tiroteios. | Corrige a animação de passos mirando e adiciona níveis táticos de habilidade nos inimigos. | [Gangster Walk Fix](https://www.mixmods.com.br/2021/05/gangster-walk-fix/) + [PedSkills](https://www.mixmods.com.br/2022/01/pedskills/) |
| **50** | **Ficar preso de cabeça para baixo ao capotar o carro**. | Permite desvirar o carro com `A`/`D` (`VehiclesAirRoll = 1`) e impede incêndio por capotamento (`NoCarFlipFire = 1`). | **MixSets.ini** (`NoCarFlipFire = 1`, `VehiclesAirRoll = 1`) |
| **51** | **Helicópteros afundando e perdendo altitude ao inclinar para acelerar** (especialmente o *Leviathan* carregando o carro-forte no ímã na missão *Up, Up and Away!*). | Ativa compensação automática de sustentação vertical (*Auto-Altitude Hold*), aumenta o empuxo no `flying.cfg` e adiciona piloto e rotores corrigidos. | *Helicopter Altitude Hold & Flying.cfg Overhaul* + [HeliFix](https://www.mixmods.com.br/2021/10/helifix-piloto-nos-helicopteros/) + [Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/) |
| **52** | **Guerras de gangue lentas, micro-territórios vazios e 3 ondas intermináveis** (esperar passar inimigo a pé e ondas spawnando longe). | **Modo Blitzkrieg (30–40s por território):** Funde micro-zonas, condensa em **1 onda única maciça** de spawn próximo ou conquista em 1 clique no Cheat Menu. | [Extended Gang Wars](https://www.mixmods.com.br/2017/07/extended-gang-wars/) + *Fast Gang Wars (1 Wave Blitz)* + [Cheat Menu v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/) |
| **53** | **Frustrações nas missões clássicas** (Sweet lento na 1ª missão *Big Smoke*, aviãozinho do Zero com gasolina ridícula e ter que cruzar a cidade ao falhar missão). | Remove trava de velocidade na fuga de bike, dá combustível infinito aos RC planes e reinicia a missão na hora se falhar (*Trip Skip*). | [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) + [Recomeçar Missão](https://www.mixmods.com.br/2016/08/recomecar-missao/) + **MixSets.ini** (`InfiniteRCPlaneFuel = 1`) |
| **54** | **Trauma da missão aérea *Freefall*** (tentar alcançar o jato Shamal com o avião Dodo lento a hélice). | Acelera a velocidade de cruzeiro do Dodo na missão para interceptar o jato com folga. | *Flight Missions Handling Overhaul* + [Story Mode v2.0](https://www.mixmods.com.br/2022/11/story-mode/) |
| **55** | **Carreta desengatando sozinha na missão da Catalina (*Tanker Commander*)**. | Trava o pino de engate do trailer de combustível para não soltar em batidas ou curvas fechadas. | [Proper Fixes v2.1.1](https://www.mixmods.com.br/2026/06/sa-proper-fixes/) + *Trailer Hitch Lock* |

---

## 10. Guia Cirúrgico: 100% do Jogo, Coletáveis no Radar, Escolas & Guerras de Gangue

### A. Todos os 250 Coletáveis no Radar ([Collectibles on Radar v1.1](https://www.mixmods.com.br/2022/03/collectibles-on-radar-mostrar-coletaveis-no-mapa/))
* Exibe diretamente no minimapa e no mapa do menu a posição exata das **100 Pichações (Tags)**, **50 Fotografias (Snapshots)**, **50 Ferraduras (Horseshoes)** e **50 Ostras (Oysters)**.
* O ícone desaparece automaticamente assim que o coletável é concluído.

### B. Ouro nas 4 Escolas (Carro, Moto, Barco e Avião)
* **[Framerate Vigilante](https://www.mixmods.com.br/2022/08/iii-vc-sa-framerate-vigilante/):** Corrige o bug de 60 FPS que quebrava a rotação do carro no teste de 360° e acelerava o cronômetro da autoescola.
* **[Cheat Menu by Grinch_ v3.52](https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/):** Permite aprovar qualquer teste irritante ou definir ouro nas 4 escolas em 1 clique sem corromper o save.

### C. Regra de Ouro das Guerras de Gangue (Alerta Crítico da Campanha)
> [!CAUTION] **A Armadilha da Missão *The Green Sabre*:**
> **NUNCA gaste tempo conquistando territórios no início do jogo em Los Santos!**
> Na missão *The Green Sabre* (ida para Angel Pine), o roteiro **reseta 100% dos territórios para os Ballas e Vagos**. No Ato 1, conquiste apenas os **2 territórios obrigatórios** da missão *Doberman*. Deixe para dominar Los Santos inteira no Ato Final, após retornar com o Sweet na missão ***Home Coming***.
