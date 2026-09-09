# ⛩️ APEX Anime Suite — Especificação & Roadmap de Implementação Futura

> **Status:** 📝 Registrado para Desenvolvimento Futuro  
> **Filosofia:** Conforto máximo e liberdade total de escolha de idioma para animes no Linux.  
> **Objetivo:** Permitir ao usuário escolher exatamente como deseja assistir cada anime (Dublado em Português, Dublado em Inglês para imersão, Legendado em PT-BR, Legendado em EN ou arquivos Multi-Áudio completos).

---

## 🎯 1. As 5 Modalidades de Consumo (O Menu de Escolha)

Quando o usuário buscar um anime no Apex (`dl -a "Nome"` ou opção no menu interativo), ele terá um seletor visual limpo no FZF para definir a preferência:

```
╭─────────────────────────────────────────────────────────────╮
│ ⛩️ ESCOLHA O FORMATO DO ANIME:                              │
├─────────────────────────────────────────────────────────────┤
│ [1] 🇧🇷 Dublado em Português (PT-BR)                         │
│ [2] 🇬🇧 Dublado em Inglês (EN Dub — Imersão Auditiva)        │
│ [3] 🇧🇷 Legendado em Português (Áudio Original JA + Sub PT)  │
│ [4] 🇬🇧 Legendado em Inglês (Áudio Original JA + Sub EN)     │
│ [5] 💎 Multi-Audio Master (JAP + ENG + PT embutidos no MKV) │
╰─────────────────────────────────────────────────────────────╯
```

---

## 🎧 2. Detalhamento de Cada Modo

### A. 🇧🇷 Dublado em Português (PT-BR)
* **Público-alvo:** Assistir relaxado, nostalgia de clássicos ou dublagens oficiais modernas de alta qualidade.
* **Fontes Planejadas:**
  * Catálogo Pomfy / TMDB (Streams HTTP diretos de releases dublados oficiais).
  * Scrapers de repositórios nacionais com áudio limpo em 1080p (Crunchyroll/Netflix rips).
* **Entrega:** Arquivo `.mp4` ou `.mkv` com áudio em português brasileiro como faixa primária.

### B. 🇬🇧 Dublado em Inglês (EN Dub — "Melhor para Imersão")
* **Público-alvo:** Aprender e fixar inglês rápido sem precisar ficar lendo legendas o tempo todo.
* **Vantagem:** Desenvolve a escuta de conversação informal, expressões idiomáticas e velocidade de fala em ritmo natural.
* **Fontes Planejadas:**
  * Nyaa.si (filtro de releases `[Dual-Audio]` ou `[Dubbed]`).
  * Grupos conceituados como *Judgement*, *Erai-raws*, *Ember*, *BlurayDub*.
* **Entrega:** 1080p BluRay com áudio em inglês Dolby Digital / AAC estéreo.

### C. 🇧🇷 Legendado em Português (Áudio JA + Legenda PT-BR)
* **Público-alvo:** Fãs do áudio original clássico dos seiyuus japoneses com legendas em português.
* **Fontes Planejadas:**
  * Scrapers de fansubs consolidados (Crunchyroll rips e fansubs lendários).
* **Entrega:** Legendas em formato `.ass` com tipografia estilizada ou `.srt` limpo.

### D. 🇬🇧 Legendado em Inglês (Áudio JA + Legenda EN)
* **Público-alvo:** Imersão avançada com leitura rápida em inglês combinada com áudio japonês.
* **Fontes Planejadas:**
  * Nyaa.si (Categoria `Anime - English-translated` com releases de *SubsPlease*, *Erai-raws*, *HorribleSubs*).
* **Entrega:** Máxima velocidade de download com centenas de seeds via `aria2c` turbo.

### E. 💎 Multi-Audio / Dual Audio Master (O Santo Graal em MKV)
* **Público-alvo:** Usuários exigentes que querem **todas as opções no mesmo arquivo de vídeo**.
* **Como funciona com o nosso MPV God Mode:**
  * O arquivo `.mkv` contém:
    * Trilha de Áudio 1: 🇯🇵 Japonês Original
    * Trilha de Áudio 2: 🇬🇧 Inglês (Dub)
    * Trilha de Áudio 3: 🇧🇷 Português (Dub - quando disponível)
    * Legenda 1: Inglês Completo
    * Legenda 2: Português Brasileiro
  * **Sinergia:** O script `smart-lang.lua` do MPV permite alternar entre os modos com 1 tecla:
    * `Alt + e`: Muda pro áudio em inglês com legenda em inglês.
    * `Alt + p`: Muda pro áudio dublado em português.
    * `Ctrl + e`: Exibe legenda dupla (Inglês embaixo + Português em cima).

---

## 🛠️ 3. Comandos CLI Planejados para o Apex

Quando implementado, o Apex terá atalhos diretos no terminal:

```bash
# Busca interativa (abre o menu com as opções de idioma)
dl -a "Frieren"

# Forçar download dublado em português
dl -a "One Piece" --dub-pt

# Forçar download dublado em inglês (imersão)
dl -a "Chainsaw Man" --dub-en

# Forçar download legendado em português
dl -a "Solo Leveling" --sub-pt

# Baixar temporada inteira em lote no formato escolhido
dl -a "Attack on Titan" --season 1 --batch
```

---

## ⚡ 4. Arquitetura Técnica & Provedores

| Modalidade | Provedor Primário | Protocolo de Download | Resolução Padrão |
| :--- | :--- | :--- | :--- |
| **Dublado PT-BR** | Pomfy / Scraper HTTP | HTTP Multi-Thread (Aria2c / ABDownload) | 1080p |
| **Dublado EN (Imersão)** | Nyaa.si / AnimesDub | BitTorrent P2P Turbo (120 peers + BBR) | 1080p BluRay |
| **Legendado PT-BR** | Pomfy / Fansub Scrapers | HTTP Multi-Thread | 1080p |
| **Legendado EN** | Nyaa.si (SubsPlease/Erai) | BitTorrent P2P Turbo (Seeds > 100) | 1080p WEB-DL / BD |
| **Multi-Audio Master** | Nyaa.si (Dual Audio Packs) | BitTorrent P2P Turbo | 1080p / 4K HEVC |

---

## 🔄 5. Integração com as Ferramentas Atuais

1. **qBittorrent:** Possibilidade de enviar o torrent de anime direto para o qBittorrent Catppuccin ou baixar no terminal via `aria2c`.
2. **Smart-Resume & Continuar Assistindo:**
   * O script `continuar.sh` reconhece automaticamente as pastas das temporadas de animes e aponta para o próximo episódio assistido.
3. **Pular Aberturas (`skip-intro.lua`):**
   * Pressionar `Tab` no MPV pula a abertura de 90 segundos dos animes instantaneamente.
