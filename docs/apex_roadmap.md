# 🗺️ APEX-DL — Roadmap & Próximas Evoluções

Registro de melhorias arquiteturais, resiliência contra quedas de provedores e planos de expansão para transformar o APEX na suíte definitiva de mídia multiplataforma.

---

## 🛡️ 1. Resiliência de Streaming (Anti-Queda do Pomfy / Multi-Provider)
Para garantir que o módulo de Filmes & Séries nunca fique indisponível caso o Pomfy sofra instabilidade ou mude proteções:
- [ ] **Arquitetura Multi-Engine Plugável**:
  - Abstrair o extrator atual (`pomfy-extractor.js`) em uma interface genérica de streaming (`StreamProvider`).
  - Adicionar provedores alternativos como fallback automático caso o primário falhe:
    - **MegaFilmesHD / WarezCDN / EmbedDer**
    - **Torrent Streaming / WebTorrent on-the-fly** (assistir/baixar simultaneamente via `peerflix` ou `webtorrent-cli`).
  - Se um provedor retornar HTTP 5xx ou timeout de stream `.m3u8`, o APEX tenta o próximo provedor de forma transparente.
- [ ] **Smart Cache de Links .m3u8**:
  - Guardar streams já resolvidos em cache temporário (`~/.cache/apex/streams/`) para evitar passar pelo headless browser em reproduções recentes.

---

## 💻 2. Port Nativo para Windows (`apex.ps1` / Standalone Go)
- [ ] **Compatibilidade Multiplataforma**:
  - Script empacotado em **PowerShell Core 7+** (`apex.ps1`) ou compilação em binário único em **Go/Rust**.
  - Detecção automática de ambiente Windows:
    - Mapear diretórios de destino para `$HOME\Videos\Downloads`, `$HOME\Music\Downloads`, etc.
    - Suporte ao Windows Terminal (com cores 24-bit TrueColor e Chafa/FZF para Windows).
  - Instalador via Scoop ou Winget:
    ```powershell
    scoop bucket add apex https://github.com/wheslancardoso/apex-dl
    scoop install apex
    ```

---

## 🎵 3. Cockpit de Áudio e Letras (MPV + Amberol + LRCLIB + Anki)
- [x] **Auto-Download de Letras Sincronizadas (.lrc) via LRCLIB & spotDL**:
  - Toda música baixada pelo Apex (Spotify ou YouTube Music) agora recebe automaticamente o arquivo de letra sincronizada `.lrc`.
- [x] **Modo Estudo de Inglês & Shadowing (`dl -e` ou opção `e` no menu FZF)**:
  - Integração profunda com MPV (`music-study.lua`): atalhos de replay de versos (`r`), shadowing loop contínuo (`l`) e mineração de áudio fatiado com 1 clique para o Anki (`M`).
- [ ] **Auto-Embed de Letras Sincronizadas (.lrc)**:
  - Adicionar opção para embutir as letras `.lrc` diretamente dentro dos metadados ID3/MP4 do arquivo de áudio (SYLT frame) para reprodutores compatíveis.
- [ ] **Painel TUI de Letras Integrado no Próprio APEX**:
  - Comando `dl --lyrics` ou tecla de atalho dentro da busca FZF para visualizar a letra completa da música antes mesmo de iniciar o download.
- [ ] **Modo Playlist Inteligente**:
  - Ao baixar uma playlist do Spotify ou YouTube, gerar automaticamente o arquivo `.m3u8` ordenado na pasta de destino para carregar tudo no Amberol com 1 clique.


---

## ⚡ 4. Interface TUI & Experiência Visual
- [ ] **Miniaturas com Sixel / iTerm2 além do Kitty Graphics**:
  - Detecção dinâmica de terminais para cobrir WezTerm, Foot, Alacritty e Mintty com o melhor renderizador suportado (Kitty > Sixel > Sextant Symbols).
- [ ] **Barra de Progresso Unificada no Terminal**:
  - Uniformizar a saída do `aria2c` e `yt-dlp` em uma barra de progresso única no estilo Catppuccin com velocidade, ETA e porcentagem em 1 linha limpa.
- [ ] **Histórico Interativo com Player Rápido**:
  - No menu `dl -h` (Histórico de Downloads), permitir pressionar `p` em qualquer item para reproduzir imediatamente no Amberol (áudios) ou Celluloid (vídeos).

---

## 📦 5. Integração com Webhooks e Notificações Remotas
- [ ] **Notificação no Telegram / Discord**:
  - Parâmetro `--notify-webhook` para avisar no celular quando um download pesado (temporada inteira de série ou lote grande de vídeos) terminar.

---

## ⛩️ 6. APEX Anime Engine (Multi-Áudio & Dublagens Flexíveis)
*Planejamento detalhado em: [APEX_ANIME_ENGINE_ROADMAP.md](file:///home/lanwsl/dotfiles/docs/APEX_ANIME_ENGINE_ROADMAP.md)*
- [ ] **Seletor Universal de Idioma para Animes (`dl -a "Nome"`)**:
  - 🇧🇷 **Dublado em Português (PT-BR)**: Releases dublados oficiais via stream/scrapers.
  - 🇬🇧 **Dublado em Inglês (EN Dub)**: Imersão auditiva com dublagem em inglês de alta velocidade.
  - 🇧🇷 **Legendado em Português (PT-BR)**: Áudio original Japonês + Legenda PT-BR.
  - 🇬🇧 **Legendado em Inglês (EN Sub)**: Áudio original Japonês + Legenda EN (Nyaa.si).
  - 💎 **Multi-Audio / Dual Audio Master**: Releases em MKV contendo faixas de áudio e legendas múltiplas para controle total pelo MPV (`Alt+e`, `Alt+p`, `Ctrl+e`).
