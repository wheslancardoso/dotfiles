# 🐉 SKYRIM ANNIVERSARY EDITION — CHECKLIST DE MODS INSTALADOS & AUDITORIA

> **Ambiente:** Linux (CachyOS / Hyprland / Proton-GE / Heroic Games Launcher)  
> **Caminho do Jogo:** `/mnt/dados/Jogos/Skyrim-AE/`  
> **Executável Primário:** `skse64_loader.exe` (Versão do Skyrim: `1.6.318.0`)  
> **Total de Plugins Ativos:** **107 Plugins** (74 DLCs Creation Club + 33 Mods da Comunidade)  
> **Total de DLLs SKSE Nativas em C++:** **14 DLLs**

---

## 📊 1. MATRIZ DE MODS POR CAMADA (STATUS REAL DE DISCO)

| # | Camada | Mod / Ferramenta | Nexus ID | Status no Jogo | Função / Impacto |
| :-: | :--- | :--- | :-: | :-: | :--- |
| 1 | **Camada 0: Engine** | **SKSE64 AE (2.1.1)** | *Externo* | 🟢 **Ativo** | Extensor de scripts nativo 64-bit para AE 1.6.318. |
| 2 | **Camada 0: Engine** | **Address Library (All-in-One)** | `32444` | 🟢 **Ativo** | Offsets de memória universais (`versionlib-1-6-318-0.bin`). |
| 3 | **Camada 0: Engine** | **SSE Engine Fixes** | `17230` | 🟢 **Ativo** | Reativa conquistas Steam com mods, física destravada e anti-crash. |
| 4 | **Camada 0: Engine** | **Recursion FPS Fix** | `76867` | 🟢 **Ativo** | Impede loops infinitos de scripts e quedas de FPS. |
| 5 | **Camada 0: Engine** | **PapyrusUtil AE** | `13048` | 🟢 **Ativo** | Aceleração de rotinas e I/O de scripts para MCM. |
| 6 | **Camada 1: Quests** | **Quest Journal Limit Fixer** | `56130` | 🟢 **Ativo** | Remove limite de missões ativas no diário. |
| 7 | **Camada 1: Quests** | **Timing is Everything SE** | `25464` | 🟢 **Ativo** | Calibra ataques de vampiros e dragões para não matar NPCs cedo. |
| 8 | **Camada 2: 100% Run** | **Stones of Barenziah Markers** | `684` | 🟢 **Ativo** | Marcadores no mapa para as 24 Gemas da Thieves Guild. |
| 9 | **Camada 2: 100% Run** | **Crimson Nirnroot Markers** | `1736` | 🟢 **Ativo** | Marcadores para as 30 Nirnroots Vermelhas em Blackreach. |
| 10 | **Camada 2: 100% Run** | **Dragon Priest Masks (No Mask Unturned)** | `128879` | 🟢 **Ativo** | Rastreamento dos 8 Sacerdotes Dragão para o santuário Bromjunaar. |
| 11 | **Camada 2: 100% Run** | **Jiub's Opus Markers** | `17056` | 🟢 **Ativo** | Marcadores para as 10 páginas da Soul Cairn (Dawnguard). |
| 12 | **Camada 2: 100% Run** | **Arvak's Skull Quest Marker** | `172837` | 🟢 **Ativo** | Marcador para o crânio do cavalo esqueleto da Soul Cairn. |
| 13 | **Camada 2: 100% Run** | **Unread Books Glow SSE** | `1296` | 🟢 **Ativo** | Livros de perícia e feitiços não lidos brilham na estante. |
| 14 | **Camada 3: Interface** | **SkyUI SE (v5.2)** | `12604` | 🟢 **Ativo** | Inventário em lista de PC, filtros e Mod Configuration Menu (MCM). |
| 15 | **Camada 3: Interface** | **TrueHUD Additions** | `62775` | 🟢 **Ativo** | Barras de chefes flutuantes, barra de postura e dano numérico. |
| 16 | **Camada 3: Interface** | **Compass Navigation Overhaul** | `74484` | 🟢 **Ativo** | Bússola moderna no topo mostrando distância em metros. |
| 17 | **Camada 3: Interface** | **Infinity UI** | `74483` | 🟢 **Ativo** | Framework de interface para elementos dinâmicos modernos. |
| 18 | **Camada 3: Interface** | **MCM Helper SE** | `53000` | 🟢 **Ativo** | Pré-requisito de configuração em JSON/TOML dos menus do SkyUI. |
| 19 | **Camada 3: Interface** | **Dear Diary Dark Mode** | `60837` | 🟢 **Ativo** | Tema escuro elegante com textura de papel e textos brancos. |
| 20 | **Camada 4: Combate** | **True Directional Movement (TDM)** | `51614` | 🟢 **Ativo** | Movimentação fluida 360° em 3ª pessoa e trava de mira (Lock-On). |
| 21 | **Camada 4: Combate** | **Precision - Melee Collisions** | `72347` | 🟢 **Ativo** | Hitbox milimétrica baseada na lâmina da arma (zero hit fantasma). |
| 22 | **Camada 4: Combate** | **SmoothCam** | `41252` | 🟢 **Ativo** | Câmera dinâmica de 3ª pessoa sem trepidação. |
| 23 | **Camada 5: Mago RPG** | **Ordinator - Perks of Skyrim** | `1137` | 🟢 **Ativo** | Mais de 400 novos perks (Mago, Necromante, Destruição). |
| 24 | **Camada 5: Mago RPG** | **Odin - Magic Overhaul** | `46000` | 🟢 **Ativo** | Rebalanceamento de magias básicas com dano escalável real. |
| 25 | **Camada 5: Mago RPG** | **Apocalypse - Magic of Skyrim** | `1090` | 🟢 **Ativo** | 155 feitiços únicos e combos arcanos avançados. |
| 26 | **Camada 5: Mago RPG** | **Apocalypse - Ordinator Patch** | `1090` | 🟢 **Ativo** | Sinergia oficial entre perks do Ordinator e magias do Apocalypse. |
| 27 | **Camada 5: Mago RPG** | **Summermyst - Enchantments** | `6285` | 🟢 **Ativo** | Dezenas de novos encantamentos para vestes e cajados de mago. |
| 28 | **Camada 5: Mago RPG** | **Smart Cast SSE Patch** | `32847` | 🟢 **Ativo** | Automação lógica de feitiços (cura ao cair vida, armadura em combate). |
| 29 | **Camada 5: Mago RPG** | **Nether's Follower Framework** | `55653` | 🟢 **Ativo** | Controle tático de múltiplos seguidores e companheiros. |
| 30 | **Camada 6: Economia** | **Experience** | `17751` | 🟢 **Ativo** | Progressão por exploração e quests (padrão RPG moderno). |
| 31 | **Camada 6: Economia** | **Honed Metal** | `61015` | 🟢 **Ativo** | Ferreiros e magos da corte forjam e encantam por encomenda. |
| 32 | **Camada 6: Economia** | **Trade and Barter SE** | `23081` | 🟢 **Ativo** | Economia justa e preços dinâmicos conforme reputação. |
| 33 | **Camada 6: Economia** | **Rich Skyrim Merchants (5x)** | `1772` | 🟢 **Ativo** | Ouro multiplicado nos mercadores das capitais. |
| 34 | **Camada 6: Economia** | **Smart Training Tweaked SE** | `18048` | 🟢 **Ativo** | Aulas de mestre por nível acumulam créditos sem se perderem. |
| 35 | **Camada 7: QoL** | **Better Third Person Selection** | `64339` | 🟢 **Ativo** | Seleção cirúrgica de itens e recipientes em 3ª pessoa. |
| 36 | **Camada 7: QoL** | **Quick Loot RE** | `21085` | 🟢 **Ativo** | Menu de saque em tempo real ao olhar para corpos e baús. |
| 37 | **Camada 7: QoL** | **Disable Follower Collision** | `35925` | 🟢 **Ativo** | Jogador atravessa NPCs e invocações (fim de portas travadas). |
| 38 | **Camada 7: QoL** | **Acquisitive Soul Gems MT** | `1469` | 🟢 **Ativo** | Gemas grandes só capturam almas grandes. |
| 39 | **Camada 7: QoL** | **Simple Dual Sheath** | `50049` | 🟢 **Ativo** | Armas esquerdas, báculos e escudos embainhados no corpo. |
| 40 | **Camada 7: QoL** | **Run For Your Lives** | `2272` | 🟢 **Ativo** | Cidadãos trancam portas durante ataques de dragões/vampiros. |
| 41 | **Camada 7: QoL** | **Simple Offence Suppression** | `41764` | 🟢 **Ativo** | Impede que aliados e guardas fiquem hostis por dano acidental. |
| 42 | **Camada 8: Combate** | **Wheeler - Action Wheel** | `97345` | 🟢 **Ativo** | Roda rápida de magias em slow-motion estilo GTA V/Monster Hunter. |
| 43 | **Camada 8: Combate** | **Sound Record Distributor** | `77815` | 🟢 **Ativo** | Distribuição de acústica e áudio avançado para feitiços. |
| 44 | **Camada 9: Religião** | **Wintersun - Faiths of Skyrim** | `22506` | 🟢 **Ativo** | Devoção aos Nove Divinos e Príncipes Daédricos com bênçãos arcanas. |
| 45 | **Camada 9: Religião** | **Andromeda - Standing Stones** | `14910` | 🟢 **Ativo** | Pedras guardiãs com árvores vivas de habilidades. |
| 46 | **Camada 9: Religião** | **Dragon Souls to Perk Points** | `2879` | 🟢 **Ativo** | Conversão de almas de dragão excedentes em pontos de perk. |
| 47 | **Camada 9: Religião** | **Ish's Respec Mod** | `1960` | 🟢 **Ativo** | Poção de respec vendida em alquimistas para redistribuir magias. |
| 48 | **Camada 10: Mapas** | **A Quality World Map (Vivid)** | `5804` | 🟢 **Ativo** | Estradas e trilhas desenhadas em relevo no mapa-múndi. |
| 49 | **Camada 10: Mapas** | **A Clear Map of Skyrim** | `56367` | 🟢 **Ativo** | Mapa limpo sem névoa cobrindo Skyrim e DLCs. |

---

## ⏳ 2. PACOTES PENDENTES (BAIXANDO NO AB DOWNLOAD MANAGER)

Os seguintes arquivos estão atualmente na fila do AB Download Manager ou precisam ser finalizados:

1. 🧱 **Static Mesh Improvement Mod (SMIM)** (`659`) — *1.05 GB (reparo de modelos 3D)*
2. 🎵 **Audio Overhaul for Skyrim SE (AOS)** (`12466`) — *268 MB (acústica realista)*
3. 🐎 **Convenient Horses** (`9519`) — *45 MB (alforjes, combate e IA covarde para cavalos)*
4. 🌌 **Arcanum - A New Age of Magic** (`23488`) — *Feitiços de meteoros e buracos negros*
5. 🪧 **Point The Way** (`352`) — *Placas nos cruzamentos*
6. 📜 **Missives** (`17576`) — *Quadro de avisos e contratos nas cidades*
7. 🏕️ **More Bandit Camps** (`1994`) — *Acampamentos nas estradas*
8. 🪄 **Strange Runes** (`19456`) — *Runas mágicas 3D nas mãos*
9. 🩸 **Combat Surrender SSE** (`16729`) — *Rendição pacífica de inimigos*
10. 🔓 **Easy Lockpicking** (`4070`) — *Abertura de fechaduras sem quebrar gazuas*
11. ⚔️ **Dual Wield Parrying** (`18264`) — *Botão dedicado de defesa para Spellsword*
12. ⚡ **Yes I'm Sure** (`24898`) — *Fim dos popups de confirmação*
13. ⚙️ **Stay At The System Page** (`19832`) — *Menu Esc abrindo direto em Salvar/Configurações*
14. 🔍 **More Informative Console** (`19250`) — *Raio-X de IDs e mods no console*
15. 🦘 **Better Jumping SE** (`18967`) — *Pulo livre durante a corrida no sprint*
16. ⚡ **PrivateProfileRedirector SE** (`18860`) — *Telas de loading 5x mais rápidas via RAM*
17. 🔦 **Quick Light SE** (`12633`) — *Lanterna de cinto no botão L sem ocupar as mãos*
18. 🐉 **The Paarthurnax Dilemma** (`365`) — *Solução pacífica com os Blades sem matar Paarthurnax*
19. 🤫 **To Your Face** (`13373`) — *Fim de múltiplos NPCs falando na sua orelha ao mesmo tempo*
