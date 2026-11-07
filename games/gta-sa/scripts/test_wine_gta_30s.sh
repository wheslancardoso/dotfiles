export WINEPREFIX="/mnt/dados/Games/pfx_gtasa"
export WINEDLLOVERRIDES="vorbisFile,vorbisHooked=n,b;d3d9=n,b"
export WINEDEBUG="-all"
cd "/mnt/dados/Games/GTA_San_Andreas"

# Rodar por 20 segundos
timeout 20s wine gta_sa.exe > /tmp/wine_gta_run.log 2>&1
echo "Exit code: $?"
