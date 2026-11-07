#!/usr/bin/env python3
"""
mixmods-scraper.py (GTA Mods Multi-Engine Scraper & Curador)
Plataformas suportadas:
  - MixMods (WordPress REST API v2 oficial)
  - GTAall (Scraping direto com links de download)
  - LibertyCity (Busca e catalogação internacional)
Suporta:
  - Busca federada em múltiplas fontes (--engine all|mixmods|gtaall|libertycity)
  - Banco local SQLite (~/.cache/mixmods/mixmods.db)
  - Modo interativo TUI
  - Exportação para Markdown curado
"""

import sys
import os
import re
import json
import html
import sqlite3
import argparse
import urllib.request
import urllib.parse
from datetime import datetime
from pathlib import Path

BASE_API = "https://www.mixmods.com.br/wp-json/wp/v2"
DEFAULT_DB_DIR = Path.home() / ".cache" / "mixmods"
DEFAULT_DB_PATH = DEFAULT_DB_DIR / "mixmods.db"

USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"

ESSENTIAL_CATEGORIES = {
    583: ("destaques", "Destaques Soberanos"),
    581: ("correcoes-e-melhorias", "Correções e Melhorias"),
    605: ("graficos", "Gráficos & Shaders"),
    587: ("ferramentas", "Ferramentas & Loaders"),
    564: ("animacoes", "Animações & Física"),
    565: ("armas", "Armas"),
    575: ("carros", "Veículos"),
    588: ("gangues", "Pedestres & Gangues")
}

def get_headers():
    return {
        "User-Agent": USER_AGENT,
        "Accept": "text/html,application/xhtml+xml,application/xml,application/json;q=0.9,*/*;q=0.8",
        "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7"
    }

def init_db(db_path=DEFAULT_DB_PATH):
    db_path.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS mods (
            id TEXT PRIMARY KEY,
            source TEXT DEFAULT 'mixmods',
            title TEXT NOT NULL,
            slug TEXT,
            link TEXT NOT NULL,
            date TEXT,
            modified TEXT,
            category_ids TEXT,
            excerpt TEXT,
            content_clean TEXT,
            download_links TEXT,
            scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    # Migração segura caso a tabela já exista sem 'source'
    try:
        cur.execute("ALTER TABLE mods ADD COLUMN source TEXT DEFAULT 'mixmods'")
    except sqlite3.OperationalError:
        pass
    cur.execute("CREATE INDEX IF NOT EXISTS idx_mods_title ON mods(title)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_mods_date ON mods(date)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_mods_source ON mods(source)")
    conn.commit()
    return conn

def clean_html(raw_html):
    if not raw_html:
        return ""
    text = re.sub(r"<script.*?>.*?</script>", "", raw_html, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r"<style.*?>.*?</style>", "", text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r"<[^>]+>", " ", text)
    text = html.unescape(text)
    text = re.sub(r"\s+", " ", text).strip()
    return text

def extract_download_links(content_html):
    links = []
    if not content_html:
        return links
    pattern = r'<a\s+[^>]*href=[\"\'](https?://[^\"\']+)[\"\'][^>]*>(.*?)</a>'
    found = re.findall(pattern, content_html, re.IGNORECASE | re.DOTALL)
    download_domains = [
        "drive.google.com", "mega.nz", "mediafire.com", "sharemods.com",
        "github.com", "gtainside.com", "libertycity.net", "nexusmods.com", "gtaall.com"
    ]
    for url, anchor in found:
        anchor_clean = clean_html(anchor).strip()
        url_lower = url.lower()
        is_dl_domain = any(d in url_lower for d in download_domains)
        is_dl_text = any(w in anchor_clean.lower() for w in ["download", "baixar", "sharemods", "drive", "github", "releases", "clique aqui"])
        if is_dl_domain or (is_dl_text and "mixmods.com.br/wp-content/uploads" not in url_lower):
            links.append({"label": anchor_clean if anchor_clean else "Download / Link", "url": url})
    seen = set()
    unique_links = []
    for l in links:
        if l["url"] not in seen:
            seen.add(l["url"])
            unique_links.append(l)
    return unique_links

def fetch_mixmods_json(url):
    req = urllib.request.Request(url, headers=get_headers())
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            data = resp.read().decode("utf-8")
            total_pages = resp.headers.get("x-wp-totalpages")
            total_items = resp.headers.get("x-wp-total")
            return json.loads(data), int(total_pages or 1), int(total_items or 0)
    except Exception as e:
        print(f"[!] Erro ao acessar {url}: {e}", file=sys.stderr)
        return None, 0, 0

def search_mixmods(term, page=1, per_page=10):
    query = urllib.parse.urlencode({"search": term, "page": page, "per_page": per_page})
    url = f"{BASE_API}/posts?{query}"
    posts, total_pages, total_items = fetch_mixmods_json(url)
    results = []
    if posts:
        for p in posts:
            title = html.unescape(p["title"]["rendered"])
            link = p["link"]
            content = p.get("content", {}).get("rendered", "")
            dls = extract_download_links(content)
            results.append({
                "id": f"mm_{p['id']}",
                "source": "mixmods",
                "title": title,
                "slug": p.get("slug", ""),
                "link": link,
                "date": p.get("date", ""),
                "excerpt": clean_html(p.get("excerpt", {}).get("rendered", ""))[:300],
                "download_links": dls
            })
    return results

def search_gtaall(term, max_results=10):
    url = f"https://www.gtaall.com.br/search?q={urllib.parse.quote(term)}"
    req = urllib.request.Request(url, headers=get_headers())
    results = []
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            body = resp.read().decode("utf-8", errors="ignore")
            # Procura blocos de mods
            items = re.findall(r'<a\s+href=[\"\'](/gta-san-andreas/[^\"\']+\.html)[\"\'][^>]*>(.*?)</a>', body, re.DOTALL)
            seen = set()
            for rel_url, title_block in items:
                clean_title = clean_html(title_block)
                if not clean_title or len(clean_title) < 4:
                    continue
                full_url = f"https://www.gtaall.com.br{rel_url}"
                if full_url in seen:
                    continue
                seen.add(full_url)
                mod_id = rel_url.split("/")[-1].replace(".html", "")
                results.append({
                    "id": f"ga_{mod_id}",
                    "source": "gtaall",
                    "title": clean_title,
                    "slug": mod_id,
                    "link": full_url,
                    "date": datetime.now().strftime("%Y-%m-%d"),
                    "excerpt": f"Mod GTA San Andreas catalogado na GTAall ({clean_title})",
                    "download_links": [{"label": "Página de Download GTAall", "url": full_url}]
                })
                if len(results) >= max_results:
                    break
    except Exception as e:
        print(f"[!] Erro ao buscar no GTAall: {e}", file=sys.stderr)
    return results

def search_libertycity(term, max_results=10):
    url = f"https://libertycity.net/files/gta-san-andreas/?search={urllib.parse.quote(term)}"
    req = urllib.request.Request(url, headers=get_headers())
    results = []
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            body = resp.read().decode("utf-8", errors="ignore")
            items = re.findall(r'<a\s+href=[\"\'](/files/gta-san-andreas/[^\"\']+\.html)[\"\'][^>]*title=[\"\']([^\"\']+)[\"\']', body, re.DOTALL)
            seen = set()
            for rel_url, title_text in items:
                clean_title = clean_html(title_text)
                full_url = f"https://libertycity.net{rel_url}"
                if full_url in seen or not clean_title:
                    continue
                seen.add(full_url)
                mod_id = rel_url.split("/")[-1].replace(".html", "")
                results.append({
                    "id": f"lc_{mod_id}",
                    "source": "libertycity",
                    "title": clean_title,
                    "slug": mod_id,
                    "link": full_url,
                    "date": datetime.now().strftime("%Y-%m-%d"),
                    "excerpt": f"Arquivo catalogado no LibertyCity ({clean_title})",
                    "download_links": [{"label": "Página de Download LibertyCity", "url": full_url}]
                })
                if len(results) >= max_results:
                    break
    except Exception as e:
        print(f"[!] Erro ao buscar no LibertyCity: {e}", file=sys.stderr)
    return results

def save_generic_results_to_db(conn, results):
    cur = conn.cursor()
    saved = 0
    for r in results:
        cur.execute("""
            INSERT INTO mods (id, source, title, slug, link, date, modified, category_ids, excerpt, content_clean, download_links)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(id) DO UPDATE SET
                title=excluded.title,
                link=excluded.link,
                excerpt=excluded.excerpt,
                download_links=excluded.download_links
        """, (
            r["id"], r.get("source", "mixmods"), r["title"], r.get("slug", ""),
            r["link"], r.get("date", ""), r.get("date", ""), json.dumps([]),
            r.get("excerpt", ""), r.get("excerpt", ""), json.dumps(r.get("download_links", []))
        ))
        saved += 1
    conn.commit()
    return saved

def federated_search(conn, term, engine="all"):
    results = []
    print(f"[*] Buscando por '{term}' [Motor: {engine}]...")
    if engine in ["all", "mixmods"]:
        mm = search_mixmods(term, per_page=10)
        print(f"  -> MixMods: {len(mm)} resultados")
        results.extend(mm)
    if engine in ["all", "gtaall"]:
        ga = search_gtaall(term, max_results=8)
        print(f"  -> GTAall: {len(ga)} resultados")
        results.extend(ga)
    if engine in ["all", "libertycity"]:
        lc = search_libertycity(term, max_results=8)
        print(f"  -> LibertyCity: {len(lc)} resultados")
        results.extend(lc)
    save_generic_results_to_db(conn, results)
    return results

def scrape_category(conn, category_id, max_pages=3):
    print(f"[*] Raspando MixMods Categoria ID {category_id} (Máx: {max_pages} páginas)...")
    total_scraped = 0
    for page in range(1, max_pages + 1):
        url = f"{BASE_API}/posts?categories={category_id}&page={page}&per_page=20"
        posts, total_pages, _ = fetch_mixmods_json(url)
        if not posts:
            break
        # Formata posts
        formatted = []
        for p in posts:
            formatted.append({
                "id": str(p["id"]),
                "source": "mixmods",
                "title": html.unescape(p["title"]["rendered"]),
                "slug": p.get("slug", ""),
                "link": p["link"],
                "date": p.get("date", ""),
                "excerpt": clean_html(p.get("excerpt", {}).get("rendered", ""))[:300],
                "download_links": extract_download_links(p.get("content", {}).get("rendered", ""))
            })
        n = save_generic_results_to_db(conn, formatted)
        total_scraped += n
        print(f"  -> Página {page}/{min(total_pages, max_pages)} salva ({n} posts).")
        if page >= total_pages:
            break
    return total_scraped

def export_modpack_markdown(conn, output_path):
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM mods")
    total_db = cur.fetchone()[0]
    cur.execute("SELECT id, source, title, link, date, excerpt, download_links FROM mods ORDER BY date DESC")
    rows = cur.fetchall()
    lines = [
        "# 🎮 Catálogo Supremo Multi-Engine de Mods para GTA San Andreas (2026)",
        f"*Gerado em {datetime.now().strftime('%d/%m/%Y %H:%M')}. Fontes: MixMods, GTAall, LibertyCity.*",
        f"*Total de mods indexados no banco:* `{total_db}`\n",
        "---",
        "## Todos os Mods Indexados (Catálogo Geral)\n"
    ]
    for mid, src, title, link, date, excerpt, dl_json in rows:
        dl_list = json.loads(dl_json or "[]")
        short_date = date.split("T")[0] if date else ""
        lines.append(f"### [{title}]({link}) `[{src.upper()}]`")
        lines.append(f"**Data / Versão:** `{short_date}`")
        if excerpt:
            lines.append(f"> {excerpt[:300]}...")
        if dl_list:
            lines.append("**Links de Download / Referência:**")
            for dl in dl_list[:3]:
                lines.append(f"- [{dl['label']}]({dl['url']})")
        lines.append("")
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"[+] Relatório exportado em: {output_path}")

def interactive_browser(conn):
    print("=" * 65)
    print("🌐 GTA MODS MULTI-ENGINE SCRAPER (MixMods + GTAall + LibertyCity)")
    print("=" * 65)
    while True:
        print("\nMenu:")
        print("  1. Busca federada (Todas as plataformas ou específica)")
        print("  2. Raspar categorias essenciais do MixMods")
        print("  3. Listar mods recentes no banco de dados local")
        print("  4. Exportar catálogo completo em Markdown")
        print("  0. Sair")
        opt = input("\nOpção > ").strip()
        if opt == "0":
            break
        elif opt == "1":
            term = input("Termo de busca (ex: 'weapon attachments', 'skyline', 'proper fixes') > ").strip()
            if not term:
                continue
            eng = input("Motor (all / mixmods / gtaall / libertycity) [padrão: all] > ").strip().lower() or "all"
            res = federated_search(conn, term, engine=eng)
            print(f"\n[+] Total encontrado: {len(res)} resultados:")
            for idx, r in enumerate(res, 1):
                print(f"  {idx}. [{r['source'].upper()}] {r['title']}")
                print(f"     URL: {r['link']}")
        elif opt == "2":
            max_p = input("Páginas por categoria (padrão: 2) > ").strip()
            pages = int(max_p) if max_p.isdigit() else 2
            for cid, (slug, name) in ESSENTIAL_CATEGORIES.items():
                scrape_category(conn, cid, max_pages=pages)
            print("[✔] Raspagem MixMods concluída!")
        elif opt == "3":
            cur = conn.cursor()
            cur.execute("SELECT source, title, link, date FROM mods ORDER BY date DESC LIMIT 15")
            rows = cur.fetchall()
            print("\n--- 15 Mods Mais Recentes no Cache ---")
            for s, t, l, d in rows:
                print(f"• [{s.upper()}] {t} ({d.split('T')[0]})\n  {l}")
        elif opt == "4":
            out = input("Caminho do arquivo (padrão: MODPACK_MIXMODS.md) > ").strip() or "MODPACK_MIXMODS.md"
            export_modpack_markdown(conn, out)

def main():
    parser = argparse.ArgumentParser(description="Multi-Engine Scraper & Curador de Mods GTA San Andreas")
    parser.add_argument("--search", "-s", help="Busca mods por termo")
    parser.add_argument("--engine", "-e", choices=["all", "mixmods", "gtaall", "libertycity"], default="all", help="Motor de busca")
    parser.add_argument("--scrape-essentials", action="store_true", help="Raspa automaticamente categorias essenciais do MixMods")
    parser.add_argument("--pages", type=int, default=2, help="Páginas por categoria")
    parser.add_argument("--export-md", help="Exporta banco local para Markdown")
    parser.add_argument("--interactive", "-i", action="store_true", help="Inicia o modo interativo TUI")
    args = parser.parse_args()
    conn = init_db()
    if args.scrape_essentials:
        for cid, (slug, name) in ESSENTIAL_CATEGORIES.items():
            scrape_category(conn, cid, max_pages=args.pages)
    elif args.search:
        results = federated_search(conn, args.search, engine=args.engine)
        for r in results:
            print(f"• [{r['source'].upper()}] {r['title']}: {r['link']}")
    elif args.export_md:
        export_modpack_markdown(conn, args.export_md)
    elif args.interactive or len(sys.argv) == 1:
        interactive_browser(conn)

if __name__ == "__main__":
    main()
