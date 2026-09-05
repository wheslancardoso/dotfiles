# 📥 GUIA DO MEDIA DOWNLOADER UNIVERSAL POWER-USER
### O Gerenciador Definitivo de Mídia no Terminal & Hyprland (yt-dlp + spotDL + aria2c)

> **Chega de anúncios, teasers cortados, vídeos sem áudio ou arquivos soltos bagunçando seu disco.**  
> Este guia documenta como baixar vídeos, músicas, álbuns e playlists completas de qualquer site da internet (YouTube, Spotify, Twitter/X, TikTok, Reddit, Instagram e mais de 1.800 plataformas) com qualidade máxima, capas em alta definição e organização de pastas impecável.

---

## ⚡ 1. Os 3 Modos de Disparo (Zero Fricção)

O sistema foi arquitetado para você nunca precisar abrir páginas de conversores cheias de vírus ou programas pesados.

```
                         ┌─────────────────────────────┐
                         │   Copie o Link de Qualquer  │
                         │    Mídia / Vídeo / Música   │
                         └──────────────┬──────────────┘
                                        │
             ┌──────────────────────────┼──────────────────────────┐
             ▼                          ▼                          ▼
     [ 1. ATALHO GLOBAL ]       [ 2. TERMINAL RÁPIDO ]      [ 3. DENTRO DO YAZI ]
       SUPER + ALT + D                Comando: dl                 Tecla: M y
    Abre o popup do Rofi na       Detecta o clipboard e       Salva direto na pasta
      tela sem abrir janelas.       mostra barra colorida.      em que você está agora.
```

### Modo 1: Atalho Global no Desktop (`SUPER + ALT + D`)
1. Copie o link do vídeo ou da música no seu navegador ou app (`Ctrl + C`).
2. Pressione **`SUPER + ALT + D`** em qualquer lugar da tela.
3. Se for um link de **Vídeo** (YouTube, TikTok, Twitter, etc.):
   - `🎥 Vídeo MP4`: Máxima resolução (1080p/2K/4K) com legendas embutidas.
   - `🎵 Áudio MP3`: Extrai apenas a faixa sonora em 320kbps com capa.
   - `⚡ Vídeo Leve`: 720p rápido para compartilhamento no WhatsApp/Discord.
4. Se for um link do **Spotify**:
   - `🎵 MP3 320kbps`: Qualidade de estúdio com capa HD e letras sincronizadas.
   - `💎 FLAC Lossless`: Áudio sem perdas de compressão.
   - `⚡ M4A AAC`: Formato original direto do stream.
5. O download roda em segundo plano. Quando terminar, uma notificação surge com os botões:
   - **`[ ▶️ Assistir / Ouvir Agora ]`**: Abre a mídia no player padrão na hora.
   - **`[ 📂 Abrir Pasta ]`**: Abre a pasta onde o arquivo foi guardado.

---

### Modo 2: Terminal Ultrarrápido (`dl`)
Se você já está com o terminal aberto, use o comando alias **`dl`**:

```bash
# Se já copiou o link, digite apenas:
dl

# Ou passe a URL diretamente como argumento:
dl "https://www.youtube.com/watch?v=..."
dl "https://open.spotify.com/playlist/..."
```

- Ele lê automaticamente o link da sua área de transferência se você não passar argumentos.
- Exibe o título oficial do vídeo/música capturado direto da API.
- Apresenta barra de progresso interativa colorida em Catppuccin Mocha.

---

### Modo 3: Direto na Pasta Atual do Yazi (`M y`)
Se você está organizando seus arquivos no Yazi e quer baixar um arquivo exatamente na pasta em que está navegando (por exemplo, dentro de `/mnt/dados/01_Faculdade/Trabalho`):

1. Navegue até a pasta desejada no Yazi.
2. Copie o link no navegador.
3. Pressione as teclas **`M`** e depois **`y`** (Media/Yazi).
4. O download será salvo **diretamente dentro dessa pasta**, sem passar pela pasta genérica de Downloads!

---

## 🌐 2. Compatibilidade & Plataformas Suportadas

O motor utiliza **`yt-dlp`** (com mais de 1.800 extratores nativos dedicados) e **`spotdl`** (para o ecossistema Spotify).

| Plataforma | Suporte | O que ele baixa? |
|---|---|---|
| **YouTube** | Vídeos, Shorts, Playlists, Músicas | 1080p, 4K, 60fps, legendas pt/en, capítulos |
| **Spotify** | Músicas, Álbuns, Playlists, Artistas | MP3 320kbps, tags oficiais, capa 3000px, letras `.lrc` |
| **Twitter / X** | Vídeos e GIFs de tweets | Melhor qualidade MP4 direta |
| **TikTok** | Vídeos avulsos e perfis | MP4 sem marca d'água |
| **Instagram** | Reels, Vídeos e Stories | MP4 de alta resolução |
| **Reddit** | Vídeos com áudio | Junta os canais separados de áudio e vídeo |
| **Twitch** | Clipes e VODs completos | Stream gravado sem travamentos |
| **Sites Adultos** | XVideos, Pornhub, SpankBang, etc. | Vídeo principal 1080p (ignora previews/anúncios) |
| **Vimeo, Dailymotion** | Vídeos hospedados | Melhor resolução nativa |

---

## 📁 3. Organização Automática das Pastas

O script respeita estritamente a hierarquia do seu disco de dados:

```
/mnt/dados/05_Midias_Design_e_Criacao/
│
├── Videos/Downloads/
│   ├── Tutorial de Hyprland [dQw4w9WgXcQ].mp4
│   │
│   └── 📁 Nome da Playlist do YouTube/         <-- Playlists ganham subpasta própria!
│       ├── 01 - Aula de Abertura.mp4
│       ├── 02 - Estrutura de Pastas.mp4
│       └── 03 - Conclusão.mp4
│
└── Musicas_e_Audios/Downloads/
    ├── Daft Punk - Get Lucky.mp3
    ├── Daft Punk - Get Lucky.lrc                <-- Letras sincronizadas para Karaokê
    │
    ├── 📁 Nome do Álbum/                       <-- Álbuns criam subpasta organizada!
    │   ├── 01 - Artista - Faixa 1.mp3
    │   ├── 02 - Artista - Faixa 2.mp3
    │   └── ...
    │
    └── 📁 Nome da Playlist Spotify/            <-- Playlists inteiras organizadas!
        ├── 01 - Artista A - Música 1.mp3
        └── 02 - Artista B - Música 2.mp3
```

---

## 🛡️ 4. Por que a Qualidade é Muito Superior?

1. **Aceleração com 16 Conexões (`aria2c`)**:
   - Diferente do navegador que baixa usando uma única conexão lenta, o `aria2c` divide o arquivo em 16 pedaços e baixa tudo em paralelo, saturando sua internet na velocidade máxima.
2. **Capas HD Embutidas Dentro do Arquivo**:
   - Não cria arquivos soltos `.jpg` ou `.png`. A imagem da capa é injetada diretamente nos metadados ID3 do MP3 ou container do MP4.
3. **Legendas e Capítulos Embutidos**:
   - Vídeos do YouTube vêm com legendas em PT/EN embutidas e capítulos de tempo gravados para você navegar com setas no reprodutor de vídeo.
4. **Sem Nomes Quebrados**:
   - Sanitização de caracteres proibidos (`:`, `?`, `*`, `|`, `/`, `\`) que protege seu sistema de arquivos de erros de leitura.

---

## ⏪ 5. Como Cancelar ou Desfazer Ações

* **Para cancelar um download antes de terminar**:
  - No terminal (`dl` ou `M y`): Pressione **`q`** ou dê **`Ctrl + C`**. Ele aborta na hora sem deixar arquivos corrompidos.
* **Para apagar um arquivo que acabou de ser baixado**:
  - No **Yazi**: Vá até o arquivo e tecle **`d`** (move para lixeira) ou **`D`** (apaga de vez).
  - *(Dica: Pressione **`u`** no Yazi para dar **Undo** em operações de renomear ou mover).*
* **Para gerenciar o atalho `M y` do Yazi**:
  - Ele fica registrado na linha 57 do arquivo `~/.config/yazi/keymap.toml`. Se um dia quiser desativar essa tecla dentro do gerenciador, basta comentar essa linha.
