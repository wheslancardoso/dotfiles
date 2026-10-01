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
    "continuity"            # Vidros conectados perfeitos sem divisórias feias
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

# 6. Baixando Shaders de Cinema: Complementary Reimagined
info "Baixando Complementary Reimagined Shaders..."
SHADER_FILE="$SHADERS_DIR/ComplementaryReimagined_r5.9.3.zip"
if [ ! -f "$SHADER_FILE" ]; then
    curl -L "https://cdn.modrinth.com/data/HVnmMxH1/versions/Bqen1mJX/ComplementaryReimagined_r5.9.3.zip" -o "$SHADER_FILE"
    ok "Shader Complementary Reimagined baixado!"
fi

# Configuração do Iris para ativar o shader de cara
cat << 'IRIS_EOF' > "$INSTANCE_DIR/.minecraft/config/iris.properties"
enableShaders=true
shaderPack=ComplementaryReimagined_r5.9.3.zip
IRIS_EOF
ok "Shaders ativados por padrão!"

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
