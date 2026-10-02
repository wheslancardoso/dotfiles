#!/bin/bash
set -e

INST_DIR="/home/lan/.local/share/PrismLauncher/instances/Mapa_Eterno_1.20.1"
MINECRAFT_DIR="$INST_DIR/.minecraft"
NATIVES_DIR="$INST_DIR/natives"
JAVA_BIN="/home/lan/.local/share/PrismLauncher/java/java-runtime-gamma/bin/java"

# Build classpath strictly using asm 9.10.1, fabric-loader 0.19.5, and all mojang libraries
CP=""
while IFS= read -r jar; do
    if [[ "$jar" == *"org/ow2/asm"* && "$jar" != *"9.10.1"* ]]; then
        continue
    fi
    if [[ "$jar" == *"fabric-loader"* && "$jar" != *"0.19.5"* ]]; then
        continue
    fi
    if [[ "$jar" == *"sponge-mixin"* && "$jar" != *"0.17.4+mixin.0.8.7"* ]]; then
        continue
    fi
    CP="${CP}:${jar}"
done < <(find /home/lan/.local/share/PrismLauncher/libraries -name "*.jar")

CP="${CP#:}"

cd "$MINECRAFT_DIR"
exec "$JAVA_BIN" -Xms4096m -Xmx8192m \
    -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
    -Djava.library.path="$NATIVES_DIR" \
    -cp "$CP" \
    net.fabricmc.loader.impl.launch.knot.KnotClient \
    --version 1.20.1 \
    --gameDir "$MINECRAFT_DIR" \
    --assetsDir /home/lan/.local/share/PrismLauncher/assets \
    --assetIndex 5 \
    --uuid 00000000-0000-0000-0000-000000000001 \
    --accessToken "dummy" \
    --userType legacy \
    --username Jogador \
    --versionType release "$@"
