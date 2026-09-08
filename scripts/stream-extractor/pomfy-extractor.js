#!/usr/bin/env node

/**
 * 🎬 Pomfy & HLS Stream Extractor (Apex Edition)
 * Suporte a filmes e séries completas do pomfy.online / api.pomfy.stream
 * Bypassa PoW Captcha (SHA-256) e WebCrypto AES-256-GCM via browser headless integrado.
 */

const fs = require('fs');
const puppeteer = require('puppeteer-core');

const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

function getBrowserExecutable() {
  const candidates = [
    '/usr/bin/google-chrome-stable',
    '/usr/bin/google-chrome',
    '/usr/bin/brave',
    '/usr/bin/brave-browser',
    '/usr/bin/chromium',
    '/usr/bin/chromium-browser'
  ];
  for (const path of candidates) {
    if (fs.existsSync(path)) return path;
  }
  throw new Error('Nenhum navegador compatível encontrado (Chrome/Brave/Chromium).');
}

function parseUrl(input) {
  if (!input) return null;
  const str = input.trim();

  // Caso seja apenas ID numérico
  if (/^\d+$/.test(str)) {
    return { type: 'serie', id: str };
  }

  try {
    const u = new URL(str);
    const pathname = u.pathname;
    const searchParams = u.searchParams;

    // pomfy.online/serie/1396
    const serieMatch = pathname.match(/\/serie\/(\d+)/);
    if (serieMatch && !searchParams.has('temporada')) {
      return { type: 'serie_info', id: serieMatch[1] };
    }

    // pomfy.online/filme/550
    const filmeMatch = pathname.match(/\/filme\/(\d+)/);
    if (filmeMatch) {
      return { type: 'filme', id: filmeMatch[1] };
    }

    // pomfy.online/assistir/1396?tipo=serie&temporada=1&episodio=1
    const assistirMatch = pathname.match(/\/assistir\/(\d+)/);
    if (assistirMatch) {
      const id = assistirMatch[1];
      const tipo = searchParams.get('tipo') || (searchParams.has('temporada') ? 'serie' : 'filme');
      if (tipo === 'serie') {
        const season = parseInt(searchParams.get('temporada') || '1', 10);
        const episode = parseInt(searchParams.get('episodio') || '1', 10);
        return { type: 'serie', id, season, episode };
      } else {
        return { type: 'filme', id };
      }
    }

    // api.pomfy.stream/serie/1396/1/1
    const apiSerieMatch = pathname.match(/\/serie\/(\d+)\/(\d+)\/(\d+)/);
    if (apiSerieMatch) {
      return {
        type: 'serie',
        id: apiSerieMatch[1],
        season: parseInt(apiSerieMatch[2], 10),
        episode: parseInt(apiSerieMatch[3], 10)
      };
    }

    // api.pomfy.stream/filme/550
    const apiFilmeMatch = pathname.match(/\/filme\/(\d+)/);
    if (apiFilmeMatch) {
      return { type: 'filme', id: apiFilmeMatch[1] };
    }
  } catch (err) {
    // Não é URL padrão válida
  }

  return null;
}

async function fetchHtml(url) {
  const res = await fetch(url, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
      'Referer': 'https://pomfy.online/',
      'Sec-Fetch-Dest': 'iframe'
    }
  });
  if (!res.ok) {
    throw new Error(`Falha HTTP ao acessar ${url}: status ${res.status}`);
  }
  return await res.text();
}

async function getSeriesMetadata(id) {
  // 1. Pega dados da série na API da pomfy
  let serieData = null;
  try {
    const res = await fetch(`https://pomfy.online/api/serie-data?id=${id}`);
    if (res.ok) {
      serieData = await res.json();
    }
  } catch (e) {}

  // 2. Pega título e ano do primeiro episódio
  let title = `Série ${id}`;
  let year = '';
  try {
    const html = await fetchHtml(`https://api.pomfy.stream/serie/${id}/1/1`);
    const titleMatch = html.match(/<h1[^>]*class=["'][^"']*title[^"']*["'][^>]*>(.*?)<\/h1>/i) || html.match(/<h1[^>]*>(.*?)<\/h1>/i);
    if (titleMatch) title = titleMatch[1].trim();

    const yearMatch = html.match(/<span[^>]*class=["'][^"']*info-badge[^"']*["'][^>]*>.*?(\b\d{4}\b).*?<\/span>/i);
    if (yearMatch) year = yearMatch[1].trim();
  } catch (e) {}

  const availableSeasons = (serieData && serieData.availableSeasons) ? serieData.availableSeasons : [1];
  const episodeCountMap = (serieData && serieData.episodeCountMap) ? serieData.episodeCountMap : { "1": 1 };

  return {
    status: 'success',
    id,
    title,
    year,
    availableSeasons,
    episodeCountMap
  };
}

async function extractStreamUrl(item, timeoutMs = 25000) {
  const { type, id } = item;
  const season = item.season || 1;
  const episode = item.episode || 1;

  const targetApiUrl = type === 'serie'
    ? `https://api.pomfy.stream/serie/${id}/${season}/${episode}`
    : `https://api.pomfy.stream/filme/${id}`;

  const html = await fetchHtml(targetApiUrl);

  // Extrai statusToken
  const tokenMatch = html.match(/statusToken\s*=\s*["']([^"']+)["']/);
  if (!tokenMatch) {
    throw new Error('Não foi possível obter statusToken na página da API Pomfy.');
  }
  const statusToken = tokenMatch[1];

  // Extrai título e ano
  let title = type === 'serie' ? `Série_${id}` : `Filme_${id}`;
  const titleMatch = html.match(/<h1[^>]*class=["'][^"']*title[^"']*["'][^>]*>(.*?)<\/h1>/i) || html.match(/<h1[^>]*>(.*?)<\/h1>/i);
  if (titleMatch) title = titleMatch[1].trim();

  let year = '';
  const yearMatch = html.match(/<span[^>]*class=["'][^"']*info-badge[^"']*["'][^>]*>.*?(\b\d{4}\b).*?<\/span>/i);
  if (yearMatch) year = yearMatch[1].trim();

  // Pede o play-token
  const playTokenRes = await fetch(`https://api.pomfy.stream/api/play-token?t=${encodeURIComponent(statusToken)}`, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
      'Referer': targetApiUrl,
      'Sec-Fetch-Dest': 'iframe'
    }
  });
  if (!playTokenRes.ok) {
    throw new Error(`Falha ao obter play-token: status ${playTokenRes.status}`);
  }
  const playTokenData = await playTokenRes.json();
  const byseUrl = playTokenData.byseUrl || playTokenData.url;
  if (!byseUrl) {
    throw new Error('Nenhuma URL do player CDN retornada pela API Pomfy.');
  }

  // Nome do arquivo formatado
  let cleanTitle = title.replace(/[/\\?%*:|"<>]/g, '_').trim();
  let fileName = '';
  if (type === 'serie') {
    const sPad = String(season).padStart(2, '0');
    const ePad = String(episode).padStart(2, '0');
    fileName = `${cleanTitle} - S${sPad}E${ePad}.mp4`;
  } else {
    fileName = year ? `${cleanTitle} (${year}).mp4` : `${cleanTitle}.mp4`;
  }

  // Executa navegador headless para resolver PoW Captcha e capturar o stream
  const execPath = getBrowserExecutable();
  const browser = await puppeteer.launch({
    executablePath: execPath,
    headless: 'new',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--disable-blink-features=AutomationControlled',
      '--mute-audio'
    ]
  });

  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 720 });
    await page.setUserAgent('Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36');

    await page.evaluateOnNewDocument(() => {
      Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
    });

    await page.setExtraHTTPHeaders({
      'Referer': 'https://api.pomfy.stream/'
    });

    let detectedM3u8 = null;
    let streamReferer = 'https://f7hyg4q.org/';

    page.on('request', (req) => {
      const u = req.url();
      if (u.includes('.m3u8') && !detectedM3u8) {
        if (u.includes('master.m3u8') || u.includes('.urlset')) {
          detectedM3u8 = u;
          const headers = req.headers();
          if (headers['referer']) streamReferer = headers['referer'];
        } else if (!detectedM3u8) {
          detectedM3u8 = u;
        }
      }
    });

    await page.goto(byseUrl, { waitUntil: 'networkidle2', timeout: timeoutMs });

    // Loop de espera e clique de gatilho do captcha
    const startTime = Date.now();
    while (Date.now() - startTime < timeoutMs) {
      if (detectedM3u8) break;

      // Procura por botões de captcha em todos os frames
      for (const f of page.frames()) {
        try {
          const clicked = await f.evaluate(() => {
            const btn = document.querySelector('button.captcha-gate__play, .jw-display-icon-display, button[aria-label="Play"], video');
            if (btn) {
              btn.click();
              return true;
            }
            return false;
          });
          if (clicked) {
            // Aguarda resolução da PoW
            await delay(1500);
            break;
          }
        } catch (e) {}
      }

      await delay(600);
    }

    if (!detectedM3u8) {
      throw new Error('Tempo limite esgotado: URL .m3u8 não foi interceptada.');
    }

    return {
      status: 'success',
      type,
      id,
      title,
      year,
      season: type === 'serie' ? season : undefined,
      episode: type === 'serie' ? episode : undefined,
      fileName,
      streamUrl: detectedM3u8,
      referer: streamReferer
    };
  } finally {
    await browser.close().catch(() => {});
  }
}

const GENRES = {
  28: 'Ação',
  12: 'Aventura',
  16: 'Animação',
  35: 'Comédia',
  80: 'Crime',
  99: 'Documentário',
  18: 'Drama',
  10751: 'Família',
  14: 'Fantasia',
  36: 'História',
  27: 'Terror',
  10402: 'Música',
  9648: 'Mistério',
  10749: 'Romance',
  878: 'Ficção Científica',
  10770: 'Cinema TV',
  53: 'Suspense',
  10752: 'Guerra',
  37: 'Faroeste',
  10759: 'Ação & Aventura',
  10762: 'Infantil',
  10763: 'Notícias',
  10764: 'Reality',
  10765: 'Sci-Fi & Fantasy',
  10766: 'Novela',
  10767: 'Talk Show',
  10768: 'Guerra & Política'
};

function getStarGauge(rating) {
  const count = Math.round((rating || 0) / 10 * 10);
  const full = '★'.repeat(Math.max(0, Math.min(count, 10)));
  const empty = '☆'.repeat(Math.max(0, 10 - full.length));
  return `${full}${empty}`;
}

async function searchCatalog(query) {
  let cat = { filmes: [], series: [] };
  try {
    const catRes = await fetch('https://pomfy.online/api/catalogo-ids');
    if (catRes.ok) cat = await catRes.json();
  } catch (e) {}

  const tmdbRes = await fetch(`https://api.themoviedb.org/3/search/multi?query=${encodeURIComponent(query)}&page=1&api_key=9e43f45f94705cc8e1d5a0400d19a7b7&language=pt-BR`);
  if (!tmdbRes.ok) {
    throw new Error(`Erro ao pesquisar TMDB: ${tmdbRes.status}`);
  }
  const tmdb = await tmdbRes.json();
  const results = (tmdb.results || [])
    .filter(r => r.media_type === 'movie' || r.media_type === 'tv')
    .map(r => {
      const isTv = r.media_type === 'tv';
      const available = isTv ? cat.series.includes(r.id) : cat.filmes.includes(r.id);
      const title = isTv ? r.name : r.title;
      const originalTitle = isTv ? r.original_name : r.original_title;
      const year = (isTv ? r.first_air_date : r.release_date || '').split('-')[0] || '';
      const rating = r.vote_average ? r.vote_average.toFixed(1) : '';
      const voteCount = r.vote_count || 0;
      const overview = r.overview || 'Sinopse não cadastrada no catálogo.';
      const genres = (r.genre_ids || []).map(id => GENRES[id]).filter(Boolean).slice(0, 3).join(' • ');
      const posterPath = r.poster_path || '';
      const url = isTv ? `https://pomfy.online/serie/${r.id}` : `https://pomfy.online/assistir/${r.id}?tipo=filme`;
      return {
        id: r.id,
        type: isTv ? 'serie' : 'filme',
        title,
        originalTitle,
        year,
        rating,
        voteCount,
        overview,
        genres,
        posterPath,
        available,
        url
      };
    })
    .sort((a, b) => (b.available ? 1 : 0) - (a.available ? 1 : 0));

  return results;
}

// -----------------------------------------------------------------------------
// CLI HANDLER
// -----------------------------------------------------------------------------
async function main() {
  const args = process.argv.slice(2);
  if (args.length === 0 || args.includes('-h') || args.includes('--help')) {
    console.log(`Uso:
  node pomfy-extractor.js search <Nome do Filme ou Série>
  node pomfy-extractor.js render-preview <arquivo_cache.json> <URL>
  node pomfy-extractor.js info <URL ou ID da Série>
  node pomfy-extractor.js stream <URL ou opções>
`);
    process.exit(0);
  }

  const mode = args[0];

  try {
    if (mode === 'render-preview') {
      const jsonFile = args[1];
      const targetUrl = args[2];
      const fs = require('fs');
      if (!fs.existsSync(jsonFile)) process.exit(0);
      const list = JSON.parse(fs.readFileSync(jsonFile, 'utf8'));
      const item = list.find(x => x.url === targetUrl);
      if (!item) process.exit(0);

      const c = {
        mauve: '\x1b[38;2;203;166;247m',
        blue: '\x1b[38;2;137;180;250m',
        green: '\x1b[38;2;166;227;161m',
        peach: '\x1b[38;2;250;179;135m',
        yellow: '\x1b[38;2;249;226;175m',
        text: '\x1b[38;2;205;214;244m',
        subtext: '\x1b[38;2;166;173;200m',
        red: '\x1b[38;2;243;139;168m',
        bold: '\x1b[1m',
        nc: '\x1b[0m'
      };

      console.log(`${c.mauve}${c.bold}╭────────────────────────────────────────────────────────╮${c.nc}`);
      console.log(`${c.mauve}${c.bold}│  ${item.type === 'serie' ? '📺 SÉRIE' : '🎬 FILME'}: ${item.title}${item.year ? ` (${item.year})` : ''}${c.nc}`);
      console.log(`${c.mauve}${c.bold}╰────────────────────────────────────────────────────────╯${c.nc}`);
      if (item.originalTitle && item.originalTitle !== item.title) {
        console.log(`${c.subtext}Título Original: ${item.originalTitle}${c.nc}`);
      }
      if (item.genres) {
        console.log(`${c.peach}🏷️  Gêneros: ${item.genres}${c.nc}`);
      }
      if (item.rating) {
        const stars = getStarGauge(parseFloat(item.rating));
        console.log(`${c.yellow}⭐ Avaliação: ${c.bold}${stars} ${item.rating}/10${c.nc} (${(item.voteCount || 0).toLocaleString('pt-BR')} avaliações)`);
      }
      if (item.available) {
        console.log(`${c.green}${c.bold}✔️ Status: DISPONÍVEL NO POMFY (1080p Full HD / Dual Áudio)${c.nc}`);
      } else {
        console.log(`${c.red}${c.bold}⏳ Status: Não indexado no momento pelo servidor${c.nc}`);
      }

      // Renderiza pôster com caracteres de texto puro (sem sobreposição gráfica no terminal)
      if (item.posterPath && fs.existsSync('/usr/bin/chafa')) {
        const posterDir = '/tmp/pomfy_posters';
        if (!fs.existsSync(posterDir)) fs.mkdirSync(posterDir, { recursive: true });
        const posterFile = `${posterDir}/${item.id}.jpg`;
        if (!fs.existsSync(posterFile)) {
          try {
            const pRes = await fetch(`https://image.tmdb.org/t/p/w185${item.posterPath}`);
            if (pRes.ok) {
              const buf = Buffer.from(await pRes.arrayBuffer());
              fs.writeFileSync(posterFile, buf);
            }
          } catch (e) {}
        }
        if (fs.existsSync(posterFile)) {
          try {
            const { execSync } = require('child_process');
            const chafaArt = execSync(`chafa --format=symbols --size=20x10 --symbols=block,border,space "${posterFile}"`, { encoding: 'utf8' });
            console.log(`\n${c.subtext}🖼️  Pôster Oficial:${c.nc}`);
            console.log(chafaArt);
          } catch (e) {}
        }
      }

      console.log(`\n${c.blue}${c.bold}📖 SINOPSE:${c.nc}`);
      console.log(`${c.text}${item.overview || 'Sem sinopse disponível.'}${c.nc}\n`);
      return;
    }


    if (mode === 'search') {
      const query = args.slice(1).join(' ');
      if (!query) throw new Error('Forneça um termo de pesquisa.');
      const results = await searchCatalog(query);
      console.log(JSON.stringify(results, null, 2));
      return;
    }

    if (mode === 'info') {
      const target = args[1];
      const parsed = parseUrl(target);
      const id = parsed ? parsed.id : target;
      const info = await getSeriesMetadata(id);
      console.log(JSON.stringify(info, null, 2));
      return;
    }

    if (mode === 'stream') {
      let item = null;
      const target = args[1];

      // Se passou URL direta
      if (target && !target.startsWith('--')) {
        item = parseUrl(target);
      }

      // Se passou argumentos nomeados
      if (!item) {
        const idIndex = args.indexOf('--id');
        const seasonIndex = args.indexOf('--season');
        const epIndex = args.indexOf('--ep');
        const typeIndex = args.indexOf('--type');

        if (idIndex !== -1 && args[idIndex + 1]) {
          item = {
            id: args[idIndex + 1],
            type: typeIndex !== -1 ? args[typeIndex + 1] : (seasonIndex !== -1 ? 'serie' : 'filme'),
            season: seasonIndex !== -1 ? parseInt(args[seasonIndex + 1], 10) : 1,
            episode: epIndex !== -1 ? parseInt(args[epIndex + 1], 10) : 1
          };
        }
      }

      if (!item) {
        throw new Error('Alvo inválido. Forneça uma URL do Pomfy ou --id <id> [--season <S> --ep <E>].');
      }

      const result = await extractStreamUrl(item);
      console.log(JSON.stringify(result, null, 2));
      return;
    }

    // Default: tenta interpretar argumento como URL
    const parsed = parseUrl(mode);
    if (parsed) {
      if (parsed.type === 'serie_info') {
        const info = await getSeriesMetadata(parsed.id);
        console.log(JSON.stringify(info, null, 2));
      } else {
        const result = await extractStreamUrl(parsed);
        console.log(JSON.stringify(result, null, 2));
      }
      return;
    }

    throw new Error(`Comando ou URL desconhecido: ${mode}`);
  } catch (err) {
    console.error(JSON.stringify({
      status: 'error',
      message: err.message
    }));
    process.exit(1);
  }
}

main();
