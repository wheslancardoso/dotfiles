#!/usr/bin/env bash
# ==============================================================================
# ⛏️ SETUP DEFINITIVO DO MINECRAFT: "MAPA ETERNO & CASA AUTOMÁTICA" (1.20.1 FABRIC)
# Otimizado para Arch Linux / CachyOS (NVIDIA RTX 5060 + Ryzen 7 5700X)
# Shaders de Cinema (Complementary Reimagined) + Zero Atrito + Automação
# ==============================================================================

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERRO]${NC} $1"; }

PRISM_DIR="$HOME/.local/share/PrismLauncher"
INSTANCE_DIR="$PRISM_DIR/instances/Mapa_Eterno_1.20.1"
MODS_DIR="$INSTANCE_DIR/.minecraft/mods"
SHADERS_DIR="$INSTANCE_DIR/.minecraft/shaderpacks"

echo -e "${BOLD}======================================================================${NC}"
echo -e "${BOLD}🚀 PROVISIONANDO INSTÂNCIA MINECRAFT MAPA ETERNO (FABRIC 1.20.1)${NC}"
echo -e "${BOLD}======================================================================${NC}\n"

# 1. Garante que o Prism Launcher está instalado
if ! command -v prismlauncher &>/dev/null; then
    info "Instalando Prism Launcher..."
    sudo pacman -S --noconfirm prismlauncher
fi
ok "Prism Launcher detectado!"

# 2. Cria a árvore de pastas da instância
info "Criando estrutura da instância em $INSTANCE_DIR..."
mkdir -p "$MODS_DIR" "$SHADERS_DIR" "$INSTANCE_DIR/.minecraft/config"

# 3. Cria o arquivo de manifesto da instância (instance.cfg)
cat << 'CFG_EOF' > "$INSTANCE_DIR/instance.cfg"
InstanceType=OneSix
IntendedVersion=1.20.1
LogPrePostOutput=true
OverrideCommands=false
OverrideConsole=false
OverrideJavaArgs=true
OverrideJavaLocation=false
OverrideMemory=true
MaxMemAlloc=8192
MinMemAlloc=4096
JvmArgs=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1
iconKey=creeper
name=Mapa Eterno (Fabric 1.20.1)
notes=Instância de alta performance com shaders Complementary Reimagined e mods anti-atrito (Mochilas, Vein Miner, Tree Chopper, Carry On, Waystones, Iluminação Dinâmica).
CFG_EOF

# 4. Configura os componentes da instância (mmc-pack.json)
cat << 'PACK_EOF' > "$INSTANCE_DIR/mmc-pack.json"
{
    "components": [
        {
            "cachedName": "Minecraft",
            "cachedRequires": [],
            "cachedVersion": "1.20.1",
            "important": true,
            "uid": "net.minecraft",
            "version": "1.20.1"
        },
        {
            "cachedName": "Intermediary Mappings",
            "cachedRequires": [
                {
                    "suggests": "1.20.1",
                    "uid": "net.minecraft"
                }
            ],
            "cachedVersion": "1.20.1",
            "important": true,
            "uid": "net.fabricmc.intermediary",
            "version": "1.20.1"
        },
        {
            "cachedName": "Fabric Loader",
            "cachedRequires": [
                {
                    "uid": "net.fabricmc.intermediary"
                }
            ],
            "cachedVersion": "0.16.10",
            "important": true,
            "uid": "net.fabricmc.fabric-loader",
            "version": "0.16.10"
        }
    ],
    "formatVersion": 1
}
PACK_EOF
ok "Manifesto e Loader Fabric 1.20.1 configurados!"

# 5. Baixando Mods Anti-Atrito & Gráficos do Modrinth
info "Baixando pacote sagrado de mods anti-atrito via Modrinth API..."

python3 - << 'PY_EOF'
import urllib.request, json, os

mods_dir = os.path.expanduser("~/.local/share/PrismLauncher/instances/Mapa_Eterno_1.20.1/.minecraft/mods")
headers = {'User-Agent': 'Antigravity/1.0'}

mods_to_download = [
    # Motor Gráfico & Shaders
    "fabric-api", "sodium", "iris", "lithium", "ferrite-core", "indium",
    "cloth-config", "modmenu", "lambdynamiclights",
    # QoL & Anti-Atrito Máximo
    "fallingtree",          # Quebra árvore inteira
    "diggus-maximus",       # Vein miner (minera todo veio de minério)
    "carry-on",             # Carrega baús cheios e villagers no colo com Shift+Direito!
    "travelersbackpack",    # Mochila expansível com auto-coleta na mina
    "universal-graves",     # Seus itens nunca mais queimam nem somem ao morrer
    "waystones",            # Teletransporte instantâneo da mina pra base
    "xaeros-minimap",       # Radar de cavernas e minimapa
    "xaeros-world-map",     # Mapa-múndi apertando M
    "jei",                  # Receitas de craft fáceis
    # Fim do Cascalho e Dores Crônicas do Minecraft
    "gravelminer",          # Cascalho que cai sobre você quebra SOZINHO instantaneamente!
    "nocreepergriefing",    # Creeper da dano em você, mas NUNCA destroi blocos nem sua casa!
    "trashslot",            # Lixeira no inventário (arraste o lixo ou aperte Delete)
    "rightclickharvest",    # Colhe e replanta plantações com 1 clique direito
    "appleskin",            # Mostra valor nutricional e saturação exata da comida
    "shulkerboxtooltip",    # Vê o que tem dentro da Shulker passando o mouse (sem pôr no chão)
    "inventory-sorting",    # Organização de baús e inventário com atalho
    # Exterminadores de Dores Lendárias (Minecraft Pain Killer Suite)
    "elytra-slot",          # Usa Peitoral de Netherita E Elytra JUNTOS (nunca mais morra sem peitoral!)
    "friendly-fire",        # IMPOSSÍVEL bater ou matar seu cachorro/gato sem querer!
    "clumps",               # Agrupa 5.000 orbes de XP em 1 só (zero lag nas suas mega farms automáticas)
    "modernfix",            # Carregamento ultra-rápido do mundo e mata corrupção de memória
    "continuity",           # Vidros conectados perfeitos sem divisórias feias
    # Construção de Elite & Zero Atrito de Blocos
    "building-wands",       # Varinhas mágicas: constrói paredes, pisos e tetos inteiros com 1 clique!
    "bridging-mod",         # Construa pontes no vazio correndo para a frente (sem precisar dar Shift de ré!)
    "litematica",           # Holograma de construções: projete qualquer castelo/farm do YouTube no mapa e monte por cima!
    "malilib",              # Dependência oficial do Litematica
    # Organização Centralizada e Inventário Fiel
    "toms-storage",         # O melhor mod de armazenamento: conecta TODOS os seus baús num terminal único com busca!
    "mouse-tweaks",         # Puxa ou empurra linhas de itens arrastando o mouse
    # Localizadores de Estruturas & Detector de Slime Chunks
    "explorers-compass",    # Bússola que aponta pra QUALQUER estrutura (Fortaleza do Nether, Portal do End, Vila, Mansão, Bastion!)
    "natures-compass",      # Bússola que aponta pra qualquer bioma (Cherry Blossom, Selva, Deserto)
    "minihud",              # Mostra Slime Chunks em tempo real na tela e desenha a caixa 3D do chunk de slime!
    "betterf3",             # Tela F3 colorida, limpa e organizada em blocos
    # Fim da Roleta Russa de Drops Raros & Agricultura Sem Sofrimento
    "always-a-wither-skull", # Wither Skeleton SEMPRE dropa a cabeça (100% de drop)! Adeus 4 horas caçando esqueleto no Nether!
    "shulker-drops-two",     # Shulker SEMPRE dropa 2 cascas (1 caixa de shulker inteira por bicho morto)!
    "trade-cycling",         # Botão de resetar trocas do Villager com 1 clique (sem precisar quebrar o atril 200 vezes pra vir Remendo!)
    "extended-bone-meal",    # Farinha de osso funciona em TUDO: cana de açúcar, cacto, videiras e plantações instantâneas
    "farmers-delight-fabric",# Expansão agrícola: cultive cebola, tomate, arroz, repolho e faça banquetes deliciosos
    "disenchanter",          # Mesa de desencantamento: tire encantamentos de armaduras/ferramentas e passe para LIVROS!
    # Proteção de Vilas & Eliminação de Micro-Atritos
    "zombie-proof-doors",    # Zumbis NUNCA MAIS quebram as portas das vilas! Aldeões 100% seguros dentro de casa.
    "ironchests",            # Baús de Ferro, Ouro, Diamante e Netherita (armazenamento massivo de minérios no mesmo bloco!)
    "anvil-restoration",     # Bigorna NUNCA se desgasta nem quebra! 1 bigorna dura pra sempre.
    "fixed-anvil-repair-cost",# ACABA COM O 'MUITO CARO!' (Too Expensive) na bigorna! Repare e encante infinitas vezes.
    "stack-refill",          # Acabou o bloco ou tocha que estava na sua mão? Puxa outro do inventário automaticamente!
    "infinite-trading",      # Aldeão NUNCA esgota as trocas! Troque quanto trigo, esmeralda ou livro quiser sem travar.
    "neat",                  # Barra de vida em cima dos monstros estilo RPG para saber o dano exato.
    "loot-beams-refork",     # Feixes de luz coloridos saindo dos itens no chão estilo RPG (nunca mais perca um drop no escuro).
    # Fornalhas Industriais Ultra-Rápidas
    "better-furnaces-reforged",# Fornalhas de Ferro, Ouro, Diamante e Netherita (fundem packs inteiros em segundos!)
    # Anti-Warden & Mineração Turbo com Radar de Diamantes
    "no-warden",              # O WARDEN NUNCA MAIS NASCE! Pode correr, pular e saquear as Cidades Ancestrais em paz total.
    "scannable",              # Scanner portátil tecnológico que bipa e destaca Diamantes através das paredes da caverna!
    "just-hammers",           # Martelos que escavam túneis de 3x3 blocos de uma só vez (mineração 9x mais rápida!)
    # Construção de Arquiteto Sem Esforço (Beleza Instantânea)
    "macaws-roofs",           # Telhados inclinados perfeitos (resolve a coisa mais difícil de fazer no Minecraft!)
    "macaws-bridges",         # Pontes suspensas de madeira, corda e ferro pré-fabricadas lindas!
    "macaws-furniture",       # Mesas, cadeiras, gavetas e balcões prontos para decorar quartos e cozinhas
    "handcrafted",            # Móveis rústicos elegantes (sofás com almofadas, bancadas de luxo, louças e cortinas)
    # Captura de Animais & Reprodução Automática (Zero Estresse de Laço e Trigo)
    "mob-lassos",             # Laços Mágicos (Golden/Diamond Lassos): captura animais e mobs no bolso como Pokébolas!
    "animal_feeding_trough",  # Cocho de Alimentação Automática: encha com trigo/sementes e os bichos procriam sozinhos!
    "justenoughbreeding",     # Revela no JEI o alimento exato de procriação e o tempo de cooldown de cada animal
    # Agricultura & Coleta Rápida de Sementes
    "hoes-are-scythes",       # Enxadas funcionam como Foices (Ceifador em área): 1 batida limpa gramas e gera centenas de sementes!
    # Remoção Cirúrgica de Fricções Extras (Combate, Baús, Zoom, Backup e Economia)
    "cut-through",            # Golpes de espada e projéteis atravessam mato e flores (nunca mais erre o zumbi por causa da grama!)
    "clickthrough+",          # Clique em baús atravessa molduras e placas (abre o baú direto sem girar o item da moldura)
    "zoomify",                # Zoom ultra-suave com transição de cinema na tecla C (adeus luneta preta e lenta)
    "dynamic-fps",            # Reduz o consumo de GPU/CPU ao dar Alt+Tab ou minimizar a janela
    "fastback",               # Backup automático e silencioso em .zip do seu mundo para blindar contra corrupção
    # Blindagem de Ferramentas & Anti-Quebra (Nunca mais perca itens valiosos nem perca tempo no inventário)
    "anti-tool-break",        # Bloqueia a ferramenta quando ela chega na beira de quebrar (1 de vida), impedindo destruição acidental!
    "low-durability-switcher",# Troca automaticamente de ferramenta na mão quando a atual estiver quase quebrando
    "show-durability",        # Mostra os números exatos de usos restantes de picaretas, espadas e armaduras diretamente no ícone
    # Movimentação Fluida & HUD Inteligente
    "stepitup",               # Subida suave de 1 bloco sem precisar ficar esmagando a barra de espaço (sem o auto-jump bugado)
    "status-effect-bars",     # Barras visuais na tela mostrando o tempo restante de cada poção (visão noturna, respiração, etc.)
    "loot-log",               # Notificação limpa no canto da tela mostrando exatamente o que você acabou de pegar do chão
    # Eficiência Industrial de Farms (Mobs, Ferro e Spawners)
    "silkier-touch",          # Permite minerar Spawners com Toque de Suave e levá-los para sua base para criar farms de mobs perfeitas!
    "item-collectors",        # Coletores de itens a vácuo em área (aspira drops de mob farms e farms de ferro instantaneamente)
    "copper-hopper",          # Funis de Cobre com filtro embutido: separa itens sem precisar de circuitos quilométricos de redstone
    # Usabilidade Suprema de Menus & Otimização de FPS
    "invmove",                # Permite andar livremente com WASD enquanto organiza inventário, baús ou mochila
    "crafting-tweaks",        # Botões para balancear, girar e limpar a mesa de trabalho com 1 clique
    "entityculling",          # Culling de entidades: não renderiza mobs e baús atrás de paredes, explodindo o FPS em bases gigantes!
    "controlling",            # Barra de busca instantânea e filtro de conflitos no menu de teclas de atalho
    "searchables",            # Biblioteca de busca avançada para menus
    "sodium-extra",           # Painel avançado de opções de renderização e controle de partículas do Sodium
    "reeses-sodium-options",  # Interface moderna com abas organizadas para as configurações de vídeo
    # Micro-Atritos Psicológicos, Sons & Visibilidade
    "boatview360",            # Rotação livre de câmera de 360° em barcos (adeus pescoço travado)
    "silent-mobs",            # Permite silenciar mobs e carrinhos barulhentos renomeando para "silent"
    "cherished-worlds",       # Fixa e protege seu "Mapa Eterno" com estrela e trava anti-deleção no topo da lista
    "item-borders",           # Bordas coloridas sutis de raridade em itens épicos e lendários no inventário
    # Início Imediato Sem Atrito & Fim do Sofrimento com Ovelha/Cama
    "starter-kit",            # Permite nascer no mundo já com a mochila Traveler's Backpack equipada nas costas!
    "mixed-wool-bed",         # Permite craftar cama com qualquer cor de lã misturada (ex: 2 brancas + 1 preta)
    # Fim das Dores de Endgame & Visibilidade Aquática
    "forgiving-void",         # Cair no Void do End não te mata: você ressurge caindo suavemente do céu com todos os itens!
    "better-flight",          # Voo de Elytra sem precisar de foguetes: aperte Espaço durante o voo para bater as asas e ganhar impulso!
    "clear-water",            # Remove a névoa escura e turva debaixo d'água, deixando rios e oceanos cristalinos
    # Troca Inteligente de Ferramenta, Decomposição Rápida de Folhas & Imersão
    "autoswitch",             # Troca automaticamente para a ferramenta certa ao mirar e bater no bloco (picareta, pá, machado ou espada)
    "accelerated-decay",      # Decomposição quase instantânea de folhas após derrubar árvores (chuva rápida de maçãs e mudas)
    "eating-animation",       # Animações visuais detalhadas de mastigação e consumo para todas as comidas do jogo
    # Atração Magnética de Itens Caídos ao Redor
    "supermartijn642s-core-lib",   # Biblioteca essencial para o Simple Magnets
    "supermartijn642s-config-lib", # Biblioteca de configurações do Simple Magnets
    "simple-magnets",              # Ímãs magnéticos que puxam itens caídos e XP num raio de até 11 blocos
    # Abertura Simultânea de Portas Duplas e Portões
    "collective",                  # Biblioteca base essencial para automações de blocos duplos
    "double-doors",                # Abre e fecha ambas as folhas de portas duplas e portões com 1 clique
    # Anti-Lag de XP, Acústica 3D Realista & Animações Naturais
    "clumps",                      # Agrupa orbes de XP em um único bloco, eliminando 100% do lag em farms massivas
    "sound-physics-remastered",    # Física sonora realista com eco e reverberação em cavernas e absorção por paredes
    "not-enough-animations"        # Animações corporais fluidas e realistas em terceira pessoa (comer, remar, mapas)
]

for slug in mods_to_download:
    url = f"https://api.modrinth.com/v2/project/{slug}/version?loaders=%5B%22fabric%22%5D&game_versions=%5B%221.20.1%22%5D"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode())
            if data:
                file_info = data[0]['files'][0]
                target_path = os.path.join(mods_dir, file_info['filename'])
                if not os.path.exists(target_path):
                    print(f"  ⬇️  Baixando {file_info['filename']}...")
                    dl_req = urllib.request.Request(file_info['url'], headers=headers)
                    with urllib.request.urlopen(dl_req) as dl_resp:
                        with open(target_path, 'wb') as f:
                            f.write(dl_resp.read())
                else:
                    print(f"  ✔ {file_info['filename']} já presente.")
    except Exception as e:
        print(f"  ❌ Erro ao baixar {slug}: {e}")
PY_EOF
ok "Mods anti-atrito baixados com sucesso!"

# 6. Baixando Shaders de Cinema: Suíte de Elite Otimizada para RTX 5060
info "Baixando Suíte de Shaders de Alta Performance (Complementary Reimagined, Unbound e BSL)..."
declare -A SHADERS=(
    ["ComplementaryReimagined_r5.9.3.zip"]="https://cdn.modrinth.com/data/HVnmMxH1/versions/Bqen1mJX/ComplementaryReimagined_r5.9.3.zip"
    ["ComplementaryUnbound_r5.9.3.zip"]="https://cdn.modrinth.com/data/R6NEzAwj/versions/B1kyfoUZ/ComplementaryUnbound_r5.9.3.zip"
    ["BSL_v10.1.8.zip"]="https://cdn.modrinth.com/data/Q1vvjJYV/versions/Y68yiql9/BSL_v10.1.8.zip"
)

for sname in "${!SHADERS[@]}"; do
    sfile="$SHADERS_DIR/$sname"
    if [ ! -f "$sfile" ]; then
        curl -sSL "${SHADERS[$sname]}" -o "$sfile"
        ok "Shader $sname baixado!"
    fi
done

# Configuração do Iris para ativar o shader de cara
cat << 'IRIS_EOF' > "$INSTANCE_DIR/.minecraft/config/iris.properties"
enableShaders=true
shaderPack=ComplementaryReimagined_r5.9.3.zip
IRIS_EOF
ok "Shaders ativados por padrão!"

# Configuração do Diggus Maximus (Mineração de Veio Sempre Automática)
mkdir -p "$INSTANCE_DIR/.minecraft/config/diggusmaximus"
cat << 'DIGGUS_EOF' > "$INSTANCE_DIR/.minecraft/config/diggusmaximus/config.json5"
{
  "enabled": true,
  "keybinding": {
    "rawKey": "key.keyboard.grave.accent"
  },
  "invertActivation": true,
  "sneakToExcavate": false,
  "mineDiag": true,
  "maxMinedBlocks": 64,
  "maxMineDistance": 16,
  "autoPickup": true,
  "requiresTool": true,
  "dontBreakTool": true,
  "stopOnToolBreak": true,
  "toolDurability": true,
  "playerExhaustion": true,
  "exhaustionMultiplier": 1.0,
  "tools": []
}
DIGGUS_EOF
ok "Diggus Maximus configurado: mineração de veios sempre ativa por padrão!"

# Configuração de Vídeo Otimizada para RTX 5060 + Ryzen 7 5700X (Fidelidade Máxima & 240 FPS)
cat << 'OPT_EOF' > "$INSTANCE_DIR/.minecraft/options.txt"
version:3465
autoJump:false
operatorItemsTab:false
autoSuggestions:true
chatColors:true
chatLinks:true
chatLinksPrompt:true
enableVsync:false
entityShadows:true
forceUnicodeFont:false
discrete_mouse_scroll:false
invertYMouse:false
realmsNotifications:false
reducedDebugInfo:false
showSubtitles:false
directionalAudio:false
touchscreen:false
bobView:true
toggleCrouch:false
toggleSprint:false
darkMojangStudiosBackground:true
hideLightningFlashes:false
mouseSensitivity:0.5
fov:1.0
screenEffectScale:1.0
fovEffectScale:1.0
darknessEffectScale:1.0
gamma:1.0
renderDistance:16
simulationDistance:10
guiScale:3
particles:0
maxFps:240
graphicsMode:2
ao:2
prioritizeChunkUpdates:0
biomeBlendRadius:3
renderClouds:true
resourcePacks:[]
incompatibleResourcePacks:[]
chatDelay:0.0
chatHeightFocused:1.0
chatHeightUnfocused:0.44366195797920227
chatOpacity:1.0
chatScale:1.0
chatWidth:1.0
chatLineSpacing:0.0
textBackgroundOpacity:0.5
textBackground:true
glDebugVerbosity:1
pauseOnLostFocus:true
overrideWidth:0
overrideHeight:0
heldItemTooltips:true
chatVisibility:0
damageTilt:true
attackIndicator:1
tutorialStep:none
mouseWheelSensitivity:1.0
rawMouseInput:true
glintSpeed:0.5
glintStrength:0.75
soundCategory_master:0.7
soundCategory_music:0.2
soundCategory_record:0.7
soundCategory_weather:0.6
soundCategory_block:0.8
soundCategory_hostile:0.8
soundCategory_neutral:0.6
soundCategory_player:0.8
soundCategory_ambient:0.6
soundCategory_voice:0.8
modelPart_cape:true
modelPart_jacket:true
modelPart_left_sleeve:true
modelPart_right_sleeve:true
modelPart_left_pants_leg:true
modelPart_right_pants_leg:true
modelPart_hat:true
mainHand:right
OPT_EOF

cat << 'SOD_EOF' > "$INSTANCE_DIR/.minecraft/config/sodium-options.json"
{
  "quality": {
    "weatherQuality": "HIGH",
    "leavesQuality": "HIGH",
    "enableVignette": true
  },
  "performance": {
    "chunkBuilderThreads": 0,
    "alwaysDeferChunkUpdates": false,
    "animateOnlyVisibleTextures": true,
    "useEntityCulling": true,
    "useFogOcclusion": true,
    "useBlockFaceCulling": true,
    "useNoErrorGLContext": true
  },
  "advanced": {
    "enableMemoryTracing": false,
    "useAdvancedStagingBuffers": true,
    "cpuRenderAheadLimit": 3
  },
  "notifications": {
    "hasClearedDonationButton": true,
    "hasSeenDonationPrompt": true
  }
}
SOD_EOF
ok "Configurações visuais de alta fidelidade e performance calibradas para RTX 5060!"

# Configuração do StarterKit (Nascer com Mochila nas costas e Cama)
mkdir -p "$INSTANCE_DIR/.minecraft/config/starterkit/active"
cat << 'STARTER_EOF' > "$INSTANCE_DIR/.minecraft/config/starterkit/active/Default.txt"
'head' : '',
'chest' : '',
'legs' : '',
'feet' : '',
'offhand' : '',
0 : '{Count:1b,id:"travelersbackpack:standard"}',
1 : '{Count:1b,id:"minecraft:red_bed"}',
2 : '',
3 : '',
4 : '',
5 : '',
6 : '',
7 : '',
8 : '',
9 : '',
10 : '',
11 : '',
12 : '',
13 : '',
14 : '',
15 : '',
16 : '',
17 : '',
18 : '',
19 : '',
20 : '',
21 : '',
22 : '',
23 : '',
24 : '',
25 : '',
26 : '',
27 : '',
28 : '',
29 : '',
30 : '',
31 : '',
32 : '',
33 : '',
34 : '',
35 : '',
'effects' : '',
STARTER_EOF
ok "StarterKit configurado: nascer com Traveler's Backpack e Cama no inventário!"

echo -e "\n${BOLD}======================================================================${NC}"
echo -e "${GREEN}${BOLD}✔ INSTÂNCIA MINECRAFT MAPA ETERNO 100% PRONTA!${NC}"
echo -e "${BOLD}======================================================================${NC}"
echo -e "🎮 Como iniciar:"
echo -e "   1. Abra o ${GREEN}Prism Launcher${NC} (no menu do Hyprland ou terminal 'prismlauncher')"
echo -e "   2. Adicione uma conta em: ${BLUE}Contas -> Gerenciar Contas -> Adicionar Offline${NC}"
echo -e "   3. Dê dois cliques na instância ${GREEN}Mapa Eterno (Fabric 1.20.1)${NC}"
echo -e ""
echo -e "🌟 Destaques do seu setup:"
echo -e "   • ${BOLD}Villagers & Baús no Colo:${NC} Shift + Botão Direito com a mão vazia (Carry On)!"
echo -e "   • ${BOLD}Mineração Instantânea:${NC} Segure a tecla da aspa/til (~) e quebre minérios (Diggus Maximus)"
echo -e "   • ${BOLD}Madeira Rápida:${NC} Quebre a base do tronco que a árvore inteira desaba (FallingTree)"
echo -e "   • ${BOLD}Inventário Infinito:${NC} Mochila inteligente com auto-pickup de minérios (Traveler's Backpack, tecla B)"
echo -e "   • ${BOLD}Sem Perda de Itens:${NC} Túmulo seguro ao morrer (Universal Graves)"
echo -e "   • ${BOLD}Voltar pra Base Sem Andar:${NC} Waystones (pergaminhos e pedras de teletransporte)"
echo -e "   • ${BOLD}Gráficos RTX 5060:${NC} Sodium + Iris + Complementary Reimagined rodando a centenas de FPS!"
echo -e "======================================================================\n"
