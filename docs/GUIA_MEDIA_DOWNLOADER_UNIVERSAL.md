# 📥 GUIA DO MEDIA DOWNLOADER SUITE DEFINITIVO (APEX V2)
### O Gerenciador Definitivo de Mídia no Terminal & Hyprland (yt-dlp + spotDL + gallery-dl + aria2c + ffmpeg + playerctl + ripdrag)

> **Chega de anúncios, teasers cortados, vídeos sem áudio ou arquivos soltos bagunçando seu disco.**  
> Este guia documenta como baixar vídeos, músicas, álbuns, playlists completas, carrosséis de fotos e clipes cirúrgicos de qualquer site da internet com qualidade máxima, capas em alta definição e organização impecável.

---

## ⚡ 1. Os 4 Modos de Disparo (Zero Fricção)

O sistema foi arquitetado para você nunca precisar abrir páginas de conversores cheias de vírus ou programas pesados.

```
                         ┌─────────────────────────────┐
                         │   Copie o Link de Qualquer  │
                         │    Mídia / Vídeo / Música   │
                         └──────────────┬──────────────┘
                                        │
             ┌──────────────────────────┼──────────────────────────┬──────────────────────────┐
             ▼                          ▼                          ▼                          ▼
     [ 1. ATALHO GLOBAL ]       [ 2. TOCANDO AGORA ]       [ 3. TERMINAL RÁPIDO ]      [ 4. DENTRO DO YAZI ]
       SUPER + ALT + D            SUPER + CTRL + D               Comando: dl                 Tecla: M y
    Abre o popup do Rofi na    Baixa o que está tocando    Detecta o clipboard e       Salva direto na pasta
      tela sem abrir janelas.    no Spotify ou Browser.      mostra menu interativo.     em que você está agora.
```

### Modo 1: Atalho Global no Desktop (`SUPER + ALT + D`)
1. Pressione **`SUPER + ALT + D`** em qualquer lugar da tela.
2. O menu Rofi oferece opções completas:
   - `🎥 Vídeo Completo (1080p/4K MP4)`: Máxima resolução com legendas embutidas.
   - `🎵 Áudio MP3 (320kbps)`: Faixa sonora em alta fidelidade com capa oficial.
   - `🎧 Baixar o que está Tocando Agora`: Captura o player ativo via MPRIS.
   - `⚡ Vídeo Leve`: 720p rápido.
   - `✂️ Cortar Trecho de Vídeo (Clip)`: Pede o início e fim (ex: `01:20-02:40`) e baixa só aquele trecho.
   - `🗜️ Comprimir para Discord / WhatsApp`: Reduz automaticamente para caber em <10MB.
   - `🎞️ Gerar GIF Animado`: Gera um GIF fluido a 15-30fps com paleta inteligente.
   - `📸 Galeria de Fotos / Imagens`: Baixa álbuns inteiros com `gallery-dl`.
   - `📝 Baixar Apenas Legendas (.srt)`: Extrai as legendas para estudo ou IA.
   - `🖼️ Baixar Apenas Capa / Thumbnail`: Salva a imagem oficial em 4K.
   - `📜 Ver Histórico de Downloads`: Busca rápida de tudo que você já baixou.

---

### Modo 2: Baixar o Que Está Tocando Agora (`SUPER + CTRL + D` ou `dl --now`)
- Está ouvindo uma música no Spotify ou assistindo a um vídeo no Brave/Firefox?
- Pressione **`SUPER + CTRL + D`** no teclado ou digite `dl --now` no terminal.
- O script consulta a interface MPRIS via `playerctl`, identifica o que está tocando e faz o download completo em segundo plano com tags e capa oficial!

---

### Modo 3: Terminal Ultrarrápido (`dl`)
O comando alias **`dl`** aceita flags e argumentos avançados:

```bash
# Se copiou um link, digite apenas 'dl' e dê Enter para confirmar:
dl

# Baixar vídeo padrão em qualidade máxima:
dl "https://www.youtube.com/watch?v=..."

# Extrair apenas o áudio MP3 320k:
dl -a "https://www.youtube.com/watch?v=..."

# Baixar direto para a pasta .privado (modo furtivo):
dl -p "https://..."

# Cortar apenas um trecho sem baixar o vídeo inteiro de gigabytes:
dl -c 01:30-02:45 "https://www.youtube.com/watch?v=..."

# Gerar GIF animado a partir de um trecho:
dl -g 00:15-00:25 "https://www.youtube.com/watch?v=..."

# Comprimir vídeo para Discord/WhatsApp (<10MB ou <25MB):
dl -z 10 "https://..."
dl -z 25 "https://..."

# Modo Estudo (Remove silêncios e acelera em 1.5x mantendo afinação de voz):
dl --study 1.5 "https://www.youtube.com/watch?v=..."

# Dividir álbuns/shows do YouTube por capítulos em faixas numeradas:
dl --split-chapters "https://www.youtube.com/watch?v=..."

# Sincronizar playlist (baixa somente as músicas novas sem duplicatas):
dl --sync "https://www.youtube.com/playlist?list=..."

# Usar cookies do navegador para vídeos restritos (18+):
dl --cookies brave "https://www.youtube.com/watch?v=..."

# Baixar carrossel de fotos (Instagram / Twitter / Reddit):
dl --gallery "https://www.instagram.com/p/..."

# Ver histórico de downloads com busca fuzzy (FZF):
dl -h
```

---

### Modo 4: Direto na Pasta Atual do Yazi (`M y`)
1. Navegue até a pasta desejada no Yazi.
2. Copie o link da mídia.
3. Pressione as teclas **`M`** e depois **`y`** (Media/Yazi).
4. O download será salvo **diretamente dentro dessa pasta**, sem passar pela pasta genérica de Downloads!

---

## 🚀 2. Notificação Interativa com "Arrastar" (ripdrag)

Ao concluir qualquer download, uma notificação surge com 3 botões:
- **`[ ▶️ Assistir / Ouvir ]`**: Reproduz imediatamente a mídia no app padrão.
- **`[ 📂 Abrir Pasta ]`**: Abre a pasta de destino no explorador de arquivos.
- **`[ 🚀 Arrastar (ripdrag) ]`**: Abre uma caixinha flutuante do `ripdrag` para você arrastar o arquivo com o mouse e soltar no Discord, WhatsApp Web ou Telegram sem sequer abrir pastas!

---

## 🌐 3. Compatibilidade Universal de Plataformas

| Plataforma | Suporte | Recursos Especiais |
|---|---|---|
| **YouTube** | Vídeos, Shorts, Playlists, Músicas | 1080p, 4K, 60fps, legendas, split de capítulos, cortes |
| **Spotify** | Músicas, Álbuns, Playlists, Artistas | MP3 320k, FLAC, capa 3000px, letras sincronizadas `.lrc` |
| **Twitter / X** | Vídeos, GIFs e carrosséis de fotos | Extração via yt-dlp e gallery-dl |
| **Instagram** | Reels, Vídeos e Carrosséis de Fotos | Baixa todos os posts e fotos em resolução nativa |
| **Reddit** | Vídeos com áudio e posts de imagens | Junta canais de áudio/vídeo e baixa galerias |
| **TikTok** | Vídeos avulsos e perfis | MP4 sem marca d'água |
| **Twitch** | Clipes e transmissões | Stream gravado sem perdas |
| **Sites Adultos** | XVideos, Pornhub, SpankBang, etc. | Roteamento furtivo automático para `.privado` |
| **Álbuns de Fotos** | ArtStation, Pinterest, Imgur | Baixa a coleção inteira em alta resolução com gallery-dl |

---

## 📁 4. Organização Inteligente de Pastas

O Media Downloader respeita sua hierarquia de diretórios:

- **Vídeos Públicos**: `05_Midias_Design_e_Criacao/Videos/Downloads/` (ou `05.4_Filmes_e_Series/`)
- **Músicas & Áudios**: `05_Midias_Design_e_Criacao/Musicas_e_Audios/Downloads/` (ou `05.2_Audios_e_Midias/`)
- **Imagens & Fotos**: `05_Midias_Design_e_Criacao/Imagens/Downloads/` (ou `05.1_Artes_e_Wallpapers/`)
- **Privados / Ocultos**: `01_Pessoal_e_Vida/.privado/` (com escudo anti-vazamento)
- **Histórico**: `~/.local/state/media-downloader/history.log`

---

## ⏪ 5. Como Cancelar ou Desfazer

* **Cancelar download em andamento**: Pressione **`Ctrl + C`** no terminal. O script encerra sem deixar arquivos temporários corrompidos.
* **Apagar mídia recente**: No Yazi, selecione o arquivo e pressione **`d`** (lixeira) ou **`D`** (apagar permanente).
* **Histórico**: Digite `dl -h` para pesquisar seus downloads passados, abrir arquivos com `[Enter]` ou copiar o caminho absoluto com `[Ctrl + Y]`.
