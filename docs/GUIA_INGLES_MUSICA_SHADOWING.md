# 🎵 GUIA DEFINITIVO: IMERSÃO EM INGLÊS COM MÚSICA & SHADOWING NO MPV
### A Tríade Apex Downloader + MPV Lyrics + Anki 1-Click Miner

> **Aprender inglês com música é o método definitivo para destravar o *Connected Speech*** (reduções como *"gonna"*, *"wanna"*, *"didja"*, elisões consoante-vogal como *"hold on"* → *"hol-don"*, gírias do cotidiano e o ritmo prosódico real dos nativos).
> 
> Com este setup, todo o atrito de cortar áudios, sincronizar letras ou caçar vocabulário é eliminado. Você escuta no MPV com a letra passando em tempo real, repete trechos na hora e fatiar o áudio do verso para o Anki com **1 única tecla**!

---

## ⚡ 1. O Fluxo de Estudo (Zero Atrito)

```
        ┌────────────────────────────────────────┐
        │  1. TERMINAL: dl ou dl -e "Música"     │
        │     Baixa MP3 320k + Letra Sinc (.lrc) │
        └───────────────────┬────────────────────┘
                            │
                            ▼
        ┌────────────────────────────────────────┐
        │  2. MPV: Modo Karaoke & Shadowing      │
        │     Letra passando linha a linha       │
        └───────────────────┬────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
        [ Tecla 'r' / 'l' ]         [ Tecla 'M' ]
       Replay e Loop do Verso     ⚡ MINE TO ANKI
      para destravar a dicção    Corta o áudio exato
                                e gera o card com som!
```

---

## 📥 2. Como Baixar Músicas com Letras Sincronizadas (.lrc)

### Modo 1: Menu Interativo do Apex (`dl`)
1. Digite `dl` no terminal.
2. Escolha a opção **`e`** (`🇬🇧 Estudo de Inglês com Música (MPV Lyrics + Shadowing + Anki)`):
   - Digite o nome da música ou artista (ex: `Coldplay The Scientist`, `Adele Hello`, `Queen Bohemian Rhapsody`).
   - Escolha no menu interativo com capa em HD.
   - O Apex baixa o áudio em 320kbps, baixa o arquivo `.lrc` de letra sincronizada e **abre automaticamente no MPV** pronto para você treinar!

### Modo 2: Linha de Comando Direta
```bash
# Baixa e já abre no MPV em modo estudo:
dl -e "Coldplay The Scientist"

# Baixar link do Spotify (já gera .lrc nativo):
dl -e "https://open.spotify.com/track/..."
```

---

## 🎮 3. Controles Mestre no MPV (Estudo Lírico & Shadowing)

Quando o MPV reproduz uma música acompanhada de `.lrc`, os atalhos de estudo ficam ativos:

| Tecla | Ação | Descrição |
|---|---|---|
| **`r`** ou `Alt+r` | **Replay Verse** | Volta instantaneamente para o início do verso atual para você ouvir de novo sem ter que caçar na barra de tempo. |
| **`l`** ou `Alt+l` | **Shadowing Loop** | Ativa um A-B Loop no verso atual. A frase fica se repetindo em loop contínuo até você conseguir falar junto no mesmo ritmo do cantor. Aperte `l` de novo para desativar. |
| **`M`** ou `Ctrl+m` | **⚡ Mine to Anki** | **O Santo Graal**: Corta os segundos exatos daquela estrofe com `ffmpeg`, salva o áudio no Anki (`collection.media`) e cria o card com áudio original e texto! |
| **`[` / `]`** | **Velocidade** | Desacelere (`[`) para 0.8x ou 0.9x caso o verso seja muito rápido, ou volte para 1.0x (`BS`). |

---

## 🃏 4. Estrutura do Flashcard no Anki

Cada vez que você pressiona **`M`** dentro do MPV, um card de alta qualidade é gerado no padrão do seu **Timeless Life**:

* **FRENTE:**
  - O verso cantado em destaque e tipografia elegante.
  - O botão de áudio original recortado da música: `[sound:song_Coldplay_The_Scientist_1234.mp3]`.
* **VERSO:**
  - Nome da faixa e artista.
  - Box de **Shadowing & Connected Speech** explicando as ligações fonéticas e ritmo.
* **Deck Automático:**
  - Os cards vão para o deck: `🇬🇧 English Immersion :: Music Lyrics & Shadowing`.
  - Se o AnkiConnect estiver rodando, o card entra em tempo real no Anki.
  - Se estiver offline, fica registrado em `docs/anki/Music_Anki_Deck.tsv` para importar quando quiser.

---

## 💡 Por que MPV e não o Amberol para Estudo?

* **Amberol:** É o seu reprodutor GTK minimalista e elegante para curtir músicas e relaxar no dia a dia. Ele não suporta scripts em Lua nem corte de áudio via atalhos.
* **MPV:** É o seu laboratório / Dojo de treino. Ele interpreta a letra `.lrc`, controla loops milimétricos por estrofe e executa o fatiador de áudio em background sem travar a reprodução.

---

## ⚡ Mantra do Aprendizado com Música
> *"A música ensina o cérebro a dançar no ritmo dos nativos. Não decore regras gramaticais secas; sinta a melodia, destrave a língua no Shadowing e minere a essência no Anki!"*
