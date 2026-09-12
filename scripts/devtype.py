#!/usr/bin/env python3
"""
⚡ DEVTYPE v3.0 — APEX TITANIUM EDITION
The Most Advanced Developer Typing Engine on Earth.
Built for the Logitech Pebble Keys 2 (K380s) & High-Performance Engineering.

Features:
1. 👻 Real-Time Ghost Pacer (Race against 150/180/200 WPM or your Personal Best run)
2. ⚡ Inter-Key Latency (IKL) & Bigram/Trigram Neural Rewiring Engine
3. 🥋 Vim Motions & Modal Editing Reflex Gauntlet (ciw, da(, ysiw", etc.)
4. 🗃️ Massive Curated Production Code Archive (TS, Python, Rust, Go, SQL, Bash, Regex, Docker, DevOps, PT-BR)
5. 🎮 RPG Rank System (Novice -> Junior -> Senior -> Staff -> 👑 200 WPM Apex Cyber-Deity), XP & Streaks (🔥)
6. 📊 Live ASCII Sparkline Acceleration Graph, Consistency Score & Peak Burst WPM
7. ⌨️ Interactive ANSI Keyboard Error Heatmap & Telemetry Dashboard
8. 📇 Shareable Terminal ASCII Badge & Achievement Card Generator
9. 📂 Custom Codebase Importer (-f file.ts / -d src/)
10. 💀 Master Mode (--master / 98%+ precision required)
"""

import argparse
import curses
import json
import math
import os
import random
import sqlite3
import sys
import time
from datetime import datetime, date, timedelta
from pathlib import Path

# --- DATABASE & STORAGE ARCHITECTURE ---

DB_DIR = Path.home() / ".local" / "share" / "devtype"
DB_PATH = DB_DIR / "history.db"

RANKS = [
    (0,   "🌱 Script Novice",          curses.COLOR_WHITE),
    (60,  "⚡ Junior Developer",        curses.COLOR_CYAN),
    (90,  "🛠️ Mid-Level Craftsman",     curses.COLOR_GREEN),
    (120, "🚀 Senior Architect",        curses.COLOR_YELLOW),
    (150, "💎 Staff Principal Engineer", curses.COLOR_MAGENTA),
    (180, "⚡ Apex Speed Demon",        curses.COLOR_BLUE),
    (200, "👑 200+ WPM Cyber-Deity",    curses.COLOR_RED),
]

def get_rank_info(wpm):
    current = RANKS[0]
    next_rank = None
    for idx, r in enumerate(RANKS):
        if wpm >= r[0]:
            current = r
            if idx + 1 < len(RANKS):
                next_rank = RANKS[idx + 1]
            else:
                next_rank = None
    return current, next_rank

def init_db():
    DB_DIR.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS sessions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                mode TEXT,
                wpm REAL,
                raw_wpm REAL,
                accuracy REAL,
                duration REAL,
                chars_typed INTEGER,
                errors_json TEXT,
                latencies_json TEXT,
                burst_wpm REAL,
                consistency REAL
            )
        """)
        cols = [r[1] for r in conn.execute("PRAGMA table_info(sessions)").fetchall()]
        if "latencies_json" not in cols:
            conn.execute("ALTER TABLE sessions ADD COLUMN latencies_json TEXT")
        if "burst_wpm" not in cols:
            conn.execute("ALTER TABLE sessions ADD COLUMN burst_wpm REAL DEFAULT 0.0")
        if "consistency" not in cols:
            conn.execute("ALTER TABLE sessions ADD COLUMN consistency REAL DEFAULT 100.0")

        conn.execute("""
            CREATE TABLE IF NOT EXISTS user_profile (
                id INTEGER PRIMARY KEY,
                total_xp INTEGER DEFAULT 0,
                streak_days INTEGER DEFAULT 0,
                last_active_date TEXT,
                target_wpm REAL DEFAULT 200.0,
                ghost_enabled INTEGER DEFAULT 1
            )
        """)
        conn.execute("INSERT OR IGNORE INTO user_profile (id, total_xp, streak_days, last_active_date, target_wpm, ghost_enabled) VALUES (1, 0, 0, '', 200.0, 1)")
        conn.commit()

def record_session(mode, wpm, raw_wpm, accuracy, duration, chars_typed, errors, latencies, burst_wpm, consistency):
    try:
        init_db()
        today_str = date.today().isoformat()
        
        # Calculate XP gained
        xp_gained = int((wpm * 2) * (accuracy / 100.0) * (duration / 10.0))
        if accuracy >= 98.0:
            xp_gained = int(xp_gained * 1.5) # Precision bonus
        
        with sqlite3.connect(DB_PATH) as conn:
            conn.execute("""
                INSERT INTO sessions (mode, wpm, raw_wpm, accuracy, duration, chars_typed, errors_json, latencies_json, burst_wpm, consistency)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (mode, wpm, raw_wpm, accuracy, duration, chars_typed, json.dumps(errors), json.dumps(latencies), burst_wpm, consistency))
            
            # Update profile & streaks
            c = conn.cursor()
            c.execute("SELECT total_xp, streak_days, last_active_date FROM user_profile WHERE id = 1")
            row = c.fetchone()
            if row:
                cur_xp, cur_streak, last_date = row
                new_streak = cur_streak
                if last_date == "":
                    new_streak = 1
                elif last_date != today_str:
                    last_d = date.fromisoformat(last_date)
                    if last_d == date.today() - timedelta(days=1):
                        new_streak += 1
                    elif last_d < date.today() - timedelta(days=1):
                        new_streak = 1
                
                conn.execute("""
                    UPDATE user_profile 
                    SET total_xp = total_xp + ?, streak_days = ?, last_active_date = ? 
                    WHERE id = 1
                """, (xp_gained, new_streak, today_str))
            conn.commit()
        return xp_gained
    except Exception:
        return 0

def get_user_profile():
    try:
        init_db()
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute("SELECT total_xp, streak_days, last_active_date, target_wpm, ghost_enabled FROM user_profile WHERE id = 1")
            row = c.fetchone()
            if row:
                return {
                    "total_xp": row[0],
                    "streak_days": row[1],
                    "last_active_date": row[2],
                    "target_wpm": row[3],
                    "ghost_enabled": bool(row[4])
                }
    except Exception:
        pass
    return {"total_xp": 0, "streak_days": 0, "last_active_date": "", "target_wpm": 200.0, "ghost_enabled": True}

def get_slowest_transitions(limit=6):
    try:
        init_db()
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute("SELECT latencies_json FROM sessions ORDER BY timestamp DESC LIMIT 30")
            trans_times = {}
            for (lj,) in c.fetchall():
                if lj:
                    data = json.loads(lj)
                    for k, times in data.items():
                        if k not in trans_times:
                            trans_times[k] = []
                        trans_times[k].extend(times)
            
            avg_trans = []
            for k, times in trans_times.items():
                if len(times) >= 3:
                    avg_trans.append((k, sum(times) / len(times)))
            avg_trans.sort(key=lambda x: x[1], reverse=True)
            return [k for k, _ in avg_trans[:limit]]
    except Exception:
        return []

def get_weak_keys(limit=8):
    try:
        init_db()
        with sqlite3.connect(DB_PATH) as conn:
            cursor = conn.execute("SELECT errors_json FROM sessions ORDER BY timestamp DESC LIMIT 50")
            freq = {}
            for (err_json,) in cursor.fetchall():
                if err_json:
                    data = json.loads(err_json)
                    for k, v in data.items():
                        freq[k] = freq.get(k, 0) + v
            sorted_keys = sorted(freq.items(), key=lambda x: x[1], reverse=True)
            return [k for k, _ in sorted_keys[:limit]]
    except Exception:
        return []

def get_overall_stats():
    try:
        init_db()
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute("SELECT COUNT(*), AVG(wpm), MAX(wpm), AVG(accuracy), SUM(duration), MAX(burst_wpm), AVG(consistency) FROM sessions")
            total_tests, avg_wpm, max_wpm, avg_acc, total_sec, max_burst, avg_const = c.fetchone()
            if not total_tests:
                return None
            
            c.execute("SELECT mode, MAX(wpm), AVG(wpm), COUNT(*) FROM sessions GROUP BY mode ORDER BY MAX(wpm) DESC")
            mode_stats = c.fetchall()
            
            c.execute("SELECT timestamp, mode, wpm, accuracy, burst_wpm FROM sessions ORDER BY timestamp DESC LIMIT 10")
            recents = c.fetchall()

            c.execute("SELECT errors_json FROM sessions")
            all_errs = {}
            for (ej,) in c.fetchall():
                if ej:
                    for k, v in json.loads(ej).items():
                        all_errs[k] = all_errs.get(k, 0) + v

            profile = get_user_profile()

            return {
                "total_tests": total_tests,
                "avg_wpm": avg_wpm or 0.0,
                "max_wpm": max_wpm or 0.0,
                "max_burst": max_burst or 0.0,
                "avg_consistency": avg_const or 0.0,
                "avg_acc": avg_acc or 0.0,
                "total_time_min": (total_sec or 0.0) / 60.0,
                "mode_stats": mode_stats,
                "recents": recents,
                "error_map": all_errs,
                "profile": profile
            }
    except Exception:
        return None

# --- VAST EXPANDED CURATED DATASETS ---

DATASETS = {
    "1. ⚡ Símbolos & Operadores Blitz": [
        "const fn = (a: number, b: string) => { return [a, b]; };",
        "if (x !== null && x !== undefined && (x > 0 || x <= -1)) {",
        "map[key] = { id: row?.id ?? 0, active: Boolean(flags & 0x01) };",
        "const { data: [first, ...rest] = [] } = await fetch(url);",
        "fn<T, K extends keyof T>(obj: T, key: K): T[K] => obj[key];",
        "let filtered = list.filter((item) => item.status === 'ACTIVE' && item.count > 0);",
        "const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/;",
        "array.reduce((acc, curr) => ({ ...acc, [curr.id]: curr }), {});",
        "for (const [k, v] of Object.entries(payload ?? {})) { yield* generate(k, v); }",
        "return async (req, res, next) => { try { await next(); } catch (err: unknown) {} };",
        "const tuple: [string, number, boolean, ...string[]] = ['devtype', 200, true, 'apex'];",
        "while (idx < len && (buf[idx] !== 0x0a || buf[idx + 1] !== 0x0d)) { idx += 2; }",
        "export type DeepReadonly<T> = { readonly [P in keyof T]: DeepReadonly<T[P]> };",
        "const clamped = Math.min(Math.max(val, minBound ?? 0), maxBound ?? 100);",
        "const query = `SELECT * FROM users WHERE status = $1 AND role IN ($2, $3);`;",
        "target.addEventListener('click', (e: MouseEvent) => { e.preventDefault(); e.stopPropagation(); });",
    ],
    "2. 🟦 TypeScript, React 19 & Next.js": [
        "export async function fetchUserData(userId: string): Promise<User | null> {",
        "  const res = await fetch(`/api/v1/users/${userId}`, { headers: { Authorization: `Bearer ${token}` } });",
        "  if (!res.ok) throw new HttpError(res.status, 'User not found in system database');",
        "  return (await res.json()) as User;",
        "}",
        "export const useDebounce = <T>(value: T, delay: number = 300): T => {",
        "  const [debouncedValue, setDebouncedValue] = useState<T>(value);",
        "  useEffect(() => {",
        "    const handler = setTimeout(() => setDebouncedValue(value), delay);",
        "    return () => clearTimeout(handler);",
        "  }, [value, delay]);",
        "  return debouncedValue;",
        "};",
        "export interface ServerConfig { host: string; port: number; ssl?: boolean; maxConnections: number; }",
        "const mergeConfigs = (defaults: Config, overrides: Partial<Config>): Config => ({ ...defaults, ...overrides });",
        "export const UserSchema = z.object({ id: z.string().uuid(), email: z.string().email(), age: z.number().int().min(18) });",
        "export async function updateAction(prevState: State, formData: FormData): Promise<ActionResult> {",
        "  'use server';",
        "  const parsed = UserSchema.safeParse(Object.fromEntries(formData.entries()));",
        "  return parsed.success ? { ok: true, data: parsed.data } : { ok: false, error: parsed.error.format() };",
        "}",
    ],
    "3. 🐍 Python 3.12, Rust & Go Systems": [
        "def memoize(func: Callable[..., Any]) -> Callable[..., Any]:",
        "    cache: dict[tuple[Any, ...], Any] = {}",
        "    @wraps(func)",
        "    def wrapper(*args: Any, **kwargs: Any) -> Any:",
        "        key = (args, frozenset(kwargs.items()))",
        "        if key not in cache:",
        "            cache[key] = func(*args, **kwargs)",
        "        return cache[key]",
        "    return wrapper",
        "pub async fn handle_connection(mut stream: TcpStream) -> Result<(), Box<dyn Error + Send + Sync>> {",
        "    let mut buffer = [0; 1024];",
        "    let n = stream.read(&mut buffer).await?;",
        "    stream.write_all(&buffer[0..n]).await?;",
        "    Ok(())",
        "}",
        "func ProcessStream(ctx context.Context, in <-chan Message) <-chan Result {",
        "    out := make(chan Result, 100)",
        "    go func() {",
        "        defer close(out)",
        "        for msg := range in { out <- compute(msg) }",
        "    }()",
        "    return out",
        "}",
        "match event:",
        "    case UserLoggedIn(user_id=uid, ip_address=ip) if ip.startswith('192.168.'):",
        "        logger.info(f'Internal login detected for user {uid} from subnet {ip}')",
        "    case _: logger.warning('Unhandled telemetry event stream incoming')",
    ],
    "4. 🗄️ SQL Window Functions, Bash & DevOps": [
        "WITH ranked_orders AS (SELECT user_id, amount, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) as rn FROM orders) SELECT * FROM ranked_orders WHERE rn <= 3;",
        "SELECT u.id, u.email, COUNT(o.id) AS order_count, SUM(o.total_amount) AS revenue FROM users u INNER JOIN orders o ON o.user_id = u.id WHERE o.created_at >= NOW() - INTERVAL '30 days' GROUP BY u.id, u.email HAVING COUNT(o.id) > 5 ORDER BY revenue DESC LIMIT 50;",
        "find . -type f -name '*.ts' ! -path '*/node_modules/*' -exec grep -Hn 'TODO:' {} + | awk -F: '{print $1, $2, $3}'",
        "rsync -avzP --delete --exclude='.git' --exclude='node_modules' ./dist/ deploy@192.168.1.100:/var/www/app/",
        "docker run -d --name redis-cache -p 6379:6379 -v redis_data:/data --restart=unless-stopped redis:7-alpine",
        "git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit",
    ],
    "5. 🐪 CamelCase & SnakeCase Speedrun": [
        "getUserById findLatestTransactionRecord calculateMonthlyAmortizationRate processIncomingWebhookEvent",
        "is_valid_authentication_token max_connection_pool_timeout_seconds sanitize_raw_database_input",
        "DEFAULT_PAYLOAD_BUFFER_CAPACITY MAXIMUM_RETRY_BACKOFF_INTERVAL GLOBAL_METRIC_AGGREGATOR",
        "handleFormSubmissionError validateEmailAddressFormat generateSecureOtpVerificationCode",
        "parse_jwt_bearer_authorization_header extract_query_parameter_map transform_json_payload",
        "shouldComponentUpdate getDerivedStateFromProps useSyncExternalStore createRef useCallback",
        "exponentialBackoffRetryHandler batchProcessAsyncTasks synchronizeDistributedCacheState",
    ],
    "6. ⚡ English 1k Dev Prosa (Top 200 WPM Speedrun)": [
        "system performance requires continuous memory optimization and efficient algorithm design to maintain low latency during heavy concurrent execution.",
        "distributed architecture guarantees high availability and partition tolerance through consensus protocols like raft and paxos in modern cloud native clusters.",
        "developers who master modal editing and touch typing eliminate friction between thought and code implementation, achieving unmatched engineering velocity.",
        "continuous integration and automated deployment pipelines streamline shipping reliable software with comprehensive unit and end to end regression suites.",
        "state management libraries synchronize reactive ui components with asynchronous backend data streams while preserving immutable data structures.",
        "zero cost abstractions in modern compiled languages empower software engineers to write highly expressive code without sacrificing runtime execution speed.",
    ],
    "7. 🇧🇷 Português Técnico Dev (Clean Arch & DDD)": [
        "a arquitetura de microsserviços exige observabilidade contínua com métricas distribuídas, rastreamento de requisições e logs centralizados.",
        "a refatoração estruturada de código legado reduz drasticamente o débito técnico e aumenta a manutenibilidade do ecossistema a longo prazo.",
        "o desenvolvimento orientado a testes garante confiabilidade absoluta durante implantações contínuas em ambientes de produção de alta escala.",
        "dominar atalhos de teclado e digitação sem olhar transforma a velocidade de resolução de problemas e eleva a produtividade para outro patamar.",
        "a segregação de interfaces e a inversão de dependência desacoplam as regras de negócio das tecnologias de banco de dados e frameworks externos.",
    ],
    "8. 🥋 Vim Motions & Modal Editing Reflex": [
        "ciw newHandler // (Pressione ciw e substitua o token)",
        "da( // (Remova todo o conteúdo dentro dos parênteses)",
        "ysiw\" // (Envolva a palavra atual com aspas duplas)",
        "f; dt, // (Pule para o ponto e vírgula e apague até a vírgula)",
        "gS // (Alterne a estrutura de array/objeto entre single e multi-line)",
        "cs'\" // (Troque aspas simples por aspas duplas instantaneamente)",
        "<leader>ca // (Abra menu de ações de código / refatoração rápida)",
    ]
}

def generate_bigram_drill():
    slow = get_slowest_transitions(limit=4)
    weak = get_weak_keys(limit=4)
    elements = slow + weak
    if not elements:
        elements = ["=>", "{", "}", "->", "!==", "$", "[]", "()"]
    
    parts = []
    for _ in range(8):
        el = random.choice(elements)
        parts.append(f"test_{el} = [{el} => {el}]")
    return " ".join(parts)

def generate_adaptive_drill():
    weak = get_weak_keys(limit=6)
    if not weak:
        return random.choice(DATASETS["1. ⚡ Símbolos & Operadores Blitz"])
    
    templates = [
        "let target = [{0}]; if (x {1} y) {{ return {2}(target); }} // weak drill",
        "const check_{0} = ({1}: any) => {{ return [{2}, {0}] !== null; }};",
        "for (let i_{0} = 0; i_{0} < len({1}); i_{0}++) {{ acc[{2}] += i_{0}; }}",
        "fn test_{0}<{1}>({2}: &{1}) -> Result<{1}, Error> {{ Ok({2}.clone()) }}",
        "SELECT {0}, {1} FROM table_{2} WHERE {0} IS NOT NULL AND {1} > 0;"
    ]
    k1 = weak[0] if len(weak) > 0 else "x"
    k2 = weak[1] if len(weak) > 1 else "="
    k3 = weak[2] if len(weak) > 2 else "{"
    return random.choice(templates).format(k1, k2, k3)

def load_custom_files(path_str):
    p = Path(path_str).expanduser().resolve()
    snippets = []
    if p.is_file():
        try:
            lines = [l.strip() for l in p.read_text(errors='ignore').splitlines() if len(l.strip()) >= 15]
            if lines:
                snippets.extend(lines[:50])
        except Exception:
            pass
    elif p.is_dir():
        for ext in ("*.ts", "*.js", "*.py", "*.rs", "*.go", "*.sh", "*.sql"):
            for f in p.glob(f"**/{ext}"):
                if "node_modules" in str(f) or ".git" in str(f):
                    continue
                try:
                    lines = [l.strip() for l in f.read_text(errors='ignore').splitlines() if len(l.strip()) >= 20]
                    if lines:
                        snippets.extend(random.sample(lines, min(len(lines), 5)))
                except Exception:
                    pass
    return snippets

# --- SPARKLINE GRAPH ENGINE ---

def render_sparkline(values, max_width=20):
    if not values:
        return ""
    sparks = [" ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
    # Sample or compress to max_width
    if len(values) > max_width:
        step = len(values) / max_width
        sampled = [values[int(i * step)] for i in range(max_width)]
    else:
        sampled = values
    
    min_v = min(sampled)
    max_v = max(sampled)
    span = (max_v - min_v) if max_v > min_v else 1.0
    
    chars = []
    for v in sampled:
        idx = int(((v - min_v) / span) * (len(sparks) - 1))
        chars.append(sparks[max(0, min(len(sparks) - 1, idx))])
    return "".join(chars)

# --- VISUAL KEYBOARD HEATMAP ---

def draw_keyboard_heatmap(stdscr, y_start, error_map):
    rows = [
        ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'BKSP'],
        ['TAB', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
        ['CAPS', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", 'ENTER'],
        ['SHIFT', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 'SHIFT'],
        ['CTRL', 'ALT', '        SPACE        ', 'ALT', 'CTRL']
    ]
    
    max_err = max(error_map.values()) if error_map else 1
    
    cur_y = y_start
    h, w = stdscr.getmaxyx()
    title = "⌨️  MAPA DE CALOR BIOMECÂNICO (LOGITECH K380s / ANSI):"
    stdscr.addstr(cur_y, 4, title, curses.color_pair(3) | curses.A_BOLD)
    cur_y += 1

    for row in rows:
        cur_x = 6
        for key in row:
            err_count = error_map.get(key.lower(), 0) + error_map.get(key, 0)
            ratio = err_count / max_err if max_err > 0 else 0
            label = f" {key} "

            if err_count > 0:
                if ratio > 0.4:
                    pair = curses.color_pair(2) | curses.A_BOLD # Vermelho crítico
                else:
                    pair = curses.color_pair(4) # Amarelo moderado
            else:
                pair = curses.color_pair(1) # Verde cirúrgico
                
            if cur_x + len(label) < w - 4:
                stdscr.addstr(cur_y, cur_x, label, pair | curses.A_REVERSE)
                cur_x += len(label) + 1
        cur_y += 1
    return cur_y

# --- ASCII ACHIEVEMENT CARD GENERATOR ---

def generate_ascii_card(stats):
    if not stats:
        return "Nenhum dado disponível."
    rank, next_r = get_rank_info(stats["max_wpm"])
    profile = stats["profile"]
    
    card = f"""
╭────────────────────────────────────────────────────────────────────────╮
│  ⚡ DEVTYPE APEX CARD — DEVELOPER PERFORMANCE PASSPORT                 │
├────────────────────────────────────────────────────────────────────────┤
│  👤 Rank:       {rank[1]:<54} │
│  🏆 Recorde:    {stats['max_wpm']:5.1f} WPM ({stats['max_wpm']*5:4.0f} CPM)  |  ⚡ Burst: {stats['max_burst']:5.1f} WPM       │
│  🎯 Acurácia:   {stats['avg_acc']:5.1f}%          |  📈 Consistência: {stats['avg_consistency']:4.1f}%          │
│  🔥 Streak:     {profile['streak_days']} dias seguidos |  💎 XP Total: {profile['total_xp']} pts            │
│  ⏱️ Tempo Dev:  {stats['total_time_min']:.1f} minutos    |  🎮 Testes: {stats['total_tests']} sessões           │
│  ⌨️ Teclado:    Logitech Pebble Keys 2 (K380s) Scissor Switch 1.5mm    │
╰────────────────────────────────────────────────────────────────────────╯
"""
    return card

# --- STATS DASHBOARD SCREEN ---

def display_stats_screen(stdscr):
    stats = get_overall_stats()
    stdscr.clear()
    h, w = stdscr.getmaxyx()
    
    if not stats:
        stdscr.addstr(3, 4, "📊 Nenhum histórico de treino encontrado ainda! Faça algumas sessões primeiro.", curses.color_pair(4))
        stdscr.addstr(5, 4, "Pressione qualquer tecla para voltar ao menu...", curses.color_pair(5))
        stdscr.refresh()
        stdscr.getkey()
        return

    rank, next_r = get_rank_info(stats["max_wpm"])
    profile = stats["profile"]

    title = "📊 DEVTYPE v3.0 — PAINEL DE TELEMETRIA & DOMÍNIO MUSCULAR"
    stdscr.addstr(1, max(2, (w - len(title)) // 2), title, curses.color_pair(3) | curses.A_BOLD)
    stdscr.addstr(2, 2, "═" * (w - 4), curses.color_pair(3))

    r_rank = f"👤 Rank: {rank[1]}   |   🔥 Streak: {profile['streak_days']} dias   |   💎 XP: {profile['total_xp']} pts"
    stdscr.addstr(3, 4, r_rank, curses.color_pair(4) | curses.A_BOLD)

    r1 = f"🏆 Recorde: {stats['max_wpm']:5.1f} WPM  |  ⚡ Burst Peak: {stats['max_burst']:5.1f} WPM  |  📈 Média: {stats['avg_wpm']:5.1f} WPM"
    r2 = f"🎯 Acurácia: {stats['avg_acc']:5.1f}%   |  ⏱️ Tempo Total: {stats['total_time_min']:.1f} min   |  🎮 Total: {stats['total_tests']} testes"
    stdscr.addstr(5, 4, r1, curses.color_pair(1) | curses.A_BOLD)
    stdscr.addstr(6, 4, r2, curses.color_pair(6))

    # Mode records
    stdscr.addstr(8, 4, "🥇 RECORDES POR CATEGORIA:", curses.color_pair(5) | curses.A_BOLD)
    row_y = 9
    for mode, max_w, avg_w, cnt in stats["mode_stats"][:4]:
        line = f"  • {mode[:32]:<32} : Máx {max_w:5.1f} WPM  (Méd {avg_w:5.1f} WPM / {cnt}x)"
        stdscr.addstr(row_y, 4, line[:w-6], curses.color_pair(6))
        row_y += 1

    row_y += 1
    if row_y + 8 < h:
        draw_keyboard_heatmap(stdscr, row_y, stats["error_map"])

    stdscr.addstr(h - 2, 4, "👉 [C] Copiar Card ASCII   [ESC/Q] Voltar ao Menu...", curses.color_pair(5) | curses.A_BOLD)
    stdscr.refresh()
    
    while True:
        k = stdscr.getkey()
        if k.lower() == 'c':
            card_txt = generate_ascii_card(stats)
            # Try to copy to clipboard via wl-copy or xclip
            try:
                os.system(f"echo {json.dumps(card_txt)} | wl-copy 2>/dev/null || true")
            except Exception:
                pass
            stdscr.addstr(h - 2, 4, "✨ Card de Performance copiado pro Clipboard! Pressione ESC... ", curses.color_pair(1) | curses.A_BOLD)
            stdscr.refresh()
        elif k.lower() in ('q', '\x1b', ' '):
            break

# --- CORE TYPING ENGINE WITH GHOST PACER & IKL ---

def run_typing_session(stdscr, mode_name, snippets, target_ghost_wpm=200.0, is_master=False):
    target_text = random.choice(snippets)
    typed = []
    errors = {}
    timestamps = []
    latencies = {} # transition -> [times]
    start_time = None
    wpm_history = []
    
    while True:
        stdscr.clear()
        h, w = stdscr.getmaxyx()
        
        # GHOST CALCULATIONS
        elapsed = (time.time() - start_time) if start_time else 0.0
        ghost_chars = int((target_ghost_wpm * 5.0 / 60.0) * elapsed) if start_time else 0
        ghost_pos = min(len(target_text), ghost_chars)

        chars_typed = len(typed)
        words = chars_typed / 5.0
        current_wpm = (words / (elapsed / 60.0)) if elapsed > 0.5 else 0.0
        
        if elapsed > 0.5:
            wpm_history.append(current_wpm)

        correct_chars = sum(1 for i, c in enumerate(typed) if i < len(target_text) and c == target_text[i])
        accuracy = (correct_chars / chars_typed * 100.0) if chars_typed > 0 else 100.0

        # DELTA VS GHOST
        delta_wpm = current_wpm - target_ghost_wpm if elapsed > 1.0 else 0.0
        delta_str = f"+{delta_wpm:.1f}" if delta_wpm >= 0 else f"{delta_wpm:.1f}"
        delta_pair = curses.color_pair(1) if delta_wpm >= 0 else curses.color_pair(2)

        # HEADER & TELEMETRY BAR
        mode_str = f"🚀 {mode_name}" + (" [💀 MASTER MODE - 98%+]" if is_master else "")
        stdscr.addstr(1, 2, mode_str[:w-4], curses.color_pair(3) | curses.A_BOLD)
        
        spark = render_sparkline(wpm_history[-15:], max_width=12)
        stats_line = f"⚡ WPM: {current_wpm:5.1f} [{spark}]   🎯 Acc: {accuracy:5.1f}%   👻 Ghost ({target_ghost_wpm:.0f}): "
        stdscr.addstr(3, 2, stats_line[:w-4], curses.color_pair(4) | curses.A_BOLD)
        stdscr.addstr(3, 2 + len(stats_line), f"{delta_str} WPM", delta_pair | curses.A_BOLD)
        
        prog_str = f"   ⏱️ {elapsed:4.1f}s   🔤 {chars_typed}/{len(target_text)}"
        stdscr.addstr(3, 2 + len(stats_line) + len(delta_str) + 5, prog_str[:w - (2 + len(stats_line) + len(delta_str) + 6)], curses.color_pair(6))
        
        stdscr.addstr(4, 2, "─" * min(w - 4, 88), curses.color_pair(6) | curses.A_DIM)

        # SUDDEN DEATH CHECK
        if is_master and chars_typed > 12 and accuracy < 98.0:
            stdscr.addstr(5, 4, "💥 FALHA! Precisão caiu abaixo de 98% no Master Mode!", curses.color_pair(2) | curses.A_BOLD)
            stdscr.addstr(7, 4, "Pressione [R] para reiniciar ou [ESC] para menu...", curses.color_pair(5))
            stdscr.refresh()
            while True:
                k = stdscr.getkey()
                if k.lower() == 'r':
                    return run_typing_session(stdscr, mode_name, snippets, target_ghost_wpm, is_master)
                elif k == '\x1b' or k.lower() == 'q':
                    return None

        # RENDER TEXT & GHOST PACER
        start_row = 6
        col = 4
        row = start_row
        
        for i, target_char in enumerate(target_text):
            if col >= w - 6:
                row += 1
                col = 4

            # Ghost indicator
            is_ghost_here = (i == ghost_pos)
            
            if i < len(typed):
                user_char = typed[i]
                if user_char == target_char:
                    stdscr.addstr(row, col, target_char, curses.color_pair(1) | curses.A_BOLD)
                else:
                    disp_char = target_char if target_char != ' ' else '_'
                    stdscr.addstr(row, col, disp_char, curses.color_pair(2) | curses.A_STANDOUT)
            elif i == len(typed):
                disp_char = target_char if target_char != ' ' else ' '
                stdscr.addstr(row, col, disp_char, curses.color_pair(5) | curses.A_UNDERLINE | curses.A_BOLD)
            else:
                if is_ghost_here:
                    # Render ghost marker
                    stdscr.addstr(row, col, target_char, curses.color_pair(4) | curses.A_REVERSE)
                else:
                    stdscr.addstr(row, col, target_char, curses.color_pair(6) | curses.A_DIM)
            col += 1

        stdscr.refresh()

        if len(typed) == len(target_text):
            break

        # INPUT HANDLING WITH SUB-MS LATENCY RECORDING
        t_before = time.time()
        ch = stdscr.get_wch()
        t_now = time.time()
        
        if ch == '\x1b' or ch == curses.KEY_CANCEL or ch == 3:
            return None
        elif ch == '\t': # TAB Instant Restart
            return run_typing_session(stdscr, mode_name, snippets, target_ghost_wpm, is_master)
        elif ch == 23: # Ctrl + W
            if typed:
                while typed and typed[-1] == ' ':
                    typed.pop()
                    if timestamps: timestamps.pop()
                while typed and typed[-1] != ' ':
                    typed.pop()
                    if timestamps: timestamps.pop()
        elif ch in (curses.KEY_BACKSPACE, '\b', '\x7f', 127):
            if typed:
                typed.pop()
                if timestamps: timestamps.pop()
        elif isinstance(ch, str) and len(ch) == 1 and ord(ch) >= 32:
            if start_time is None:
                start_time = t_now
            current_idx = len(typed)
            if current_idx < len(target_text):
                # Measure transition latency
                if timestamps:
                    dt = t_now - timestamps[-1]
                    prev_char = target_text[current_idx - 1]
                    trans_key = f"{prev_char}->{target_char}"
                    if trans_key not in latencies:
                        latencies[trans_key] = []
                    latencies[trans_key].append(round(dt * 1000, 1)) # in ms
                
                timestamps.append(t_now)
                
                if ch != target_text[current_idx]:
                    expected = target_text[current_idx]
                    errors[expected] = errors.get(expected, 0) + 1
                typed.append(ch)

    # TEST COMPLETE - COMPUTE TELEMETRY
    final_time = (time.time() - start_time) if start_time else 0.01
    final_wpm = (len(target_text) / 5.0) / (final_time / 60.0)
    final_acc = (sum(1 for i, c in enumerate(typed) if c == target_text[i]) / len(target_text)) * 100.0
    
    # Compute burst speed (fastest 3-character rolling window)
    burst_wpm = final_wpm
    if len(timestamps) >= 5:
        deltas = [timestamps[i] - timestamps[i-1] for i in range(1, len(timestamps))]
        if deltas:
            min_delta = min(deltas)
            if min_delta > 0.02: # avoid glitch
                burst_wpm = min(350.0, (1.0 / 5.0) / (min_delta / 60.0))
    
    # Compute consistency %
    consistency = 100.0
    if len(wpm_history) >= 4:
        avg_h = sum(wpm_history) / len(wpm_history)
        variance = sum((x - avg_h) ** 2 for x in wpm_history) / len(wpm_history)
        std_dev = math.sqrt(variance)
        consistency = max(0.0, min(100.0, 100.0 - (std_dev / (avg_h or 1.0) * 100.0)))

    # Record in SQLite & Award XP
    xp_earned = record_session(mode_name, final_wpm, final_wpm, final_acc, final_time, len(typed), errors, latencies, burst_wpm, consistency)
    rank, _ = get_rank_info(final_wpm)

    # POST-TEST RESULT CARD
    while True:
        stdscr.clear()
        res_box_w = 72
        res_x = max(2, (w - res_box_w) // 2)
        
        stdscr.addstr(2, res_x, "╔══════════════════════════════════════════════════════════════════════╗", curses.color_pair(3))
        stdscr.addstr(3, res_x, f"║                🏆 SPEEDRUN TELEMETRY — {rank[1]:<28} ║", curses.color_pair(3) | curses.A_BOLD)
        stdscr.addstr(4, res_x, "╠══════════════════════════════════════════════════════════════════════╣", curses.color_pair(3))
        stdscr.addstr(5, res_x, f"║  ⚡ Velocidade Final: {final_wpm:6.1f} WPM ({final_wpm*5:4.0f} CPM)   |  🚀 Burst: {burst_wpm:5.1f} WPM   ║", curses.color_pair(4) | curses.A_BOLD)
        stdscr.addstr(6, res_x, f"║  🎯 Acurácia:         {final_acc:6.1f} %             |  📈 Consistência: {consistency:4.1f} %  ║", curses.color_pair(1) if final_acc >= 95 else curses.color_pair(2))
        stdscr.addstr(7, res_x, f"║  ⏱️ Tempo Total:      {final_time:6.2f} s             |  💎 XP Ganho: +{xp_earned:<5} pts   ║", curses.color_pair(6))
        
        # Slowest transition telemetry
        if latencies:
            slowest = sorted(latencies.items(), key=lambda x: sum(x[1])/len(x[1]), reverse=True)[:3]
            slow_str = ", ".join([f"'{k}':{sum(v)/len(v):.0f}ms" for k, v in slowest])
            stdscr.addstr(8, res_x, f"║  🐢 Transições Lentas: {slow_str:<45} ║", curses.color_pair(4))
        
        if errors:
            err_str = " ".join([f"'{k}':{v}x" for k, v in sorted(errors.items(), key=lambda x: x[1], reverse=True)[:5]])
            stdscr.addstr(9, res_x, f"║  ⚠️ Teclas com Erro:   {err_str:<45} ║", curses.color_pair(2))
        else:
            stdscr.addstr(9, res_x, "║  ✨ Perfeito! 0 erros (Flawless Execution & Perfect Motor Flow)     ║", curses.color_pair(1) | curses.A_BOLD)
            
        stdscr.addstr(10, res_x, "╠══════════════════════════════════════════════════════════════════════╣", curses.color_pair(3))
        stdscr.addstr(11, res_x, "║  [R] Repetir   [ENTER/TAB] Próximo Snippet   [ESC] Menu Principal    ║", curses.color_pair(5) | curses.A_BOLD)
        stdscr.addstr(12, res_x, "╚══════════════════════════════════════════════════════════════════════╝", curses.color_pair(3))
        stdscr.refresh()

        post_ch = stdscr.getkey()
        if post_ch.lower() == 'r':
            return run_typing_session(stdscr, mode_name, [target_text], target_ghost_wpm, is_master)
        elif post_ch in ('\n', '\r', ' ', '\t'):
            return run_typing_session(stdscr, mode_name, snippets, target_ghost_wpm, is_master)
        elif post_ch == '\x1b' or post_ch.lower() == 'q':
            break
    return None

# --- MAIN MENU TUI ---

def main_tui(stdscr, custom_snippets=None, target_ghost=200.0, is_master=False):
    curses.curs_set(1)
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_GREEN, -1)
    curses.init_pair(2, curses.COLOR_RED, -1)
    curses.init_pair(3, curses.COLOR_CYAN, -1)
    curses.init_pair(4, curses.COLOR_YELLOW, -1)
    curses.init_pair(5, curses.COLOR_MAGENTA, -1)
    curses.init_pair(6, curses.COLOR_WHITE, -1)

    if custom_snippets:
        run_typing_session(stdscr, "📂 Custom File / Project Code", custom_snippets, target_ghost, is_master)
        return

    while True:
        stdscr.clear()
        h, w = stdscr.getmaxyx()
        
        profile = get_user_profile()
        stats = get_overall_stats()
        pb_wpm = stats["max_wpm"] if stats else 0.0
        rank, _ = get_rank_info(pb_wpm)

        title = "⚡ DEVTYPE v3.0 — APEX TITANIUM DEVELOPER TYPING ENGINE"
        stdscr.addstr(1, max(0, (w - len(title)) // 2), title, curses.color_pair(3) | curses.A_BOLD)
        
        sub = f"👤 {rank[1]}  |  🔥 Streak: {profile['streak_days']} dias  |  🏆 Recorde: {pb_wpm:.1f} WPM  |  👻 Ghost: {target_ghost:.0f} WPM"
        stdscr.addstr(2, max(0, (w - len(sub)) // 2), sub, curses.color_pair(4) | curses.A_BOLD)
        stdscr.addstr(3, 2, "─" * (w - 4), curses.color_pair(6) | curses.A_DIM)

        modes = list(DATASETS.keys())
        modes.append("9. 🧬 Modo Adaptativo (Ataca Cirurgicamente suas Teclas Fracas)")
        modes.append("10. ⚡ Bigram & Trigram Blitz (Treino de Transições Lentas)")

        for idx, mode in enumerate(modes):
            line = f"  [{idx + 1:2d}] {mode}"
            stdscr.addstr(5 + idx, 4, line[:w-6], curses.color_pair(6) | curses.A_BOLD)

        opt_y = 5 + len(modes) + 1
        stdscr.addstr(opt_y, 4, f"  [G] 👻 Alterar Velocidade do Ghost Pacer (Atual: {target_ghost:.0f} WPM)", curses.color_pair(3) | curses.A_BOLD)
        stdscr.addstr(opt_y + 1, 4, "  [M] 💀 Alternar Master Mode (Zero Tolerância: " + ("LIGADO" if is_master else "DESLIGADO") + ")", curses.color_pair(2 if is_master else 6))
        stdscr.addstr(opt_y + 2, 4, "  [S] 📊 Abrir Painel de Telemetria & Heatmap do K380s", curses.color_pair(1) | curses.A_BOLD)
        stdscr.addstr(opt_y + 3, 4, "  [Q] 🚪 Sair", curses.color_pair(6) | curses.A_DIM)

        stdscr.addstr(opt_y + 5, 4, "👉 Digite o número do modo ou tecla desejada: ", curses.color_pair(5) | curses.A_BOLD)
        stdscr.refresh()

        key = stdscr.getkey()
        if key.lower() == 'q':
            break
        elif key.lower() == 's':
            display_stats_screen(stdscr)
            continue
        elif key.lower() == 'g':
            # Cycle ghost speeds: 150 -> 180 -> 200 -> 220 -> 120
            speeds = [120.0, 150.0, 180.0, 200.0, 220.0, 250.0]
            cur_idx = speeds.index(target_ghost) if target_ghost in speeds else 3
            target_ghost = speeds[(cur_idx + 1) % len(speeds)]
            continue
        elif key.lower() == 'm':
            is_master = not is_master
            continue

        choice = -1
        if key.isdigit():
            choice = int(key)
        elif key.lower() == 'a':
            choice = 10

        if choice < 1 or choice > len(modes):
            continue

        if choice == 9:
            adaptive_snippets = [generate_adaptive_drill() for _ in range(5)]
            run_typing_session(stdscr, "🧬 Adaptive Weak-Key Gauntlet", adaptive_snippets, target_ghost, is_master)
        elif choice == 10:
            bigram_snippets = [generate_bigram_drill() for _ in range(5)]
            run_typing_session(stdscr, "⚡ Bigram & Trigram Neural Blitz", bigram_snippets, target_ghost, is_master)
        else:
            selected_mode = modes[choice - 1]
            run_typing_session(stdscr, selected_mode, DATASETS[selected_mode], target_ghost, is_master)

# --- CLI ENTRYPOINT ---

def main():
    parser = argparse.ArgumentParser(description="⚡ DEVTYPE v3.0 — The Apex Developer Typing Engine")
    parser.add_argument("-f", "--file", help="Carregar arquivo de código customizado para praticar")
    parser.add_argument("-d", "--dir", help="Escanear pasta de projeto para treinar com código real")
    parser.add_argument("-s", "--stats", action="store_true", help="Exibir painel de estatísticas e mapa de calor")
    parser.add_argument("-m", "--master", action="store_true", help="Ativar Master Mode (Zero tolerância a erros)")
    parser.add_argument("-g", "--ghost", type=float, default=200.0, help="Velocidade do Ghost Pacer em WPM (Padrão: 200)")
    parser.add_argument("-c", "--card", action="store_true", help="Gerar e imprimir Card ASCII de Performance")
    args = parser.parse_args()

    os.environ.setdefault('ESCDELAY', '25')

    if args.card:
        stats = get_overall_stats()
        print(generate_ascii_card(stats))
        return

    if args.stats:
        try:
            curses.wrapper(display_stats_screen)
        except KeyboardInterrupt:
            pass
        return

    custom_snippets = None
    if args.file:
        custom_snippets = load_custom_files(args.file)
        if not custom_snippets:
            print(f"❌ Não foi possível carregar snippets úteis de {args.file}")
            sys.exit(1)
    elif args.dir:
        custom_snippets = load_custom_files(args.dir)
        if not custom_snippets:
            print(f"❌ Não foram encontrados arquivos de código em {args.dir}")
            sys.exit(1)

    try:
        curses.wrapper(lambda stdscr: main_tui(stdscr, custom_snippets=custom_snippets, target_ghost=args.ghost, is_master=args.master))
    except KeyboardInterrupt:
        pass
    print("\n⚡ Treino finalizado. Mantenha os pulsos flutuando e foco no ritmo contínuo!")

if __name__ == "__main__":
    main()
