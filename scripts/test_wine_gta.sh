export WINEPREFIX="/mnt/dados/Games/pfx_gtasa"
export WINEDLLOVERRIDES="vorbisFile,vorbisHooked=n,b;d3d9=n,b"
export WINEDEBUG="+err"
cd "/mnt/dados/Games/GTA_San_Andreas"

# Rodar por 5 segundos para coletar se o executável inicia e carrega
timeout 5s wine gta_sa.exe 2>&1
echo "Exit code: $?"
