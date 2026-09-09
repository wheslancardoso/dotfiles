-- ==============================================================================
-- 🧠 Smart-Resume — Inteligência de Histórico, Conclusão de Episódios & Binge Watch
-- ==============================================================================
-- 1. Grava continuamente o progresso de séries e filmes em:
--    ~/.local/state/mpv/watch_history.json
-- 2. Regra de Conclusão (>85% ou créditos):
--    Se você assistiu mais de 85% de um episódio e depois abrir ele novamente,
--    o script avisa na tela e faz a contagem regressiva de 4 segundos:
--    "⏭️ Episódio anterior concluído (88%)! Avançando para o próximo em 4s... [Esc ou Espaço para cancelar]"
--    - Se apertar Esc ou Espaço: cancela o salto e assiste onde parou.
--    - Se não apertar nada: pula automaticamente para o próximo episódio (00:00).
-- 3. Atalho 'H' (Shift+h) dentro do MPV:
--    Abre um HUD na tela com as séries/filmes recentes para trocar com 1 tecla.
-- ==============================================================================

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local STATE_DIR = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/mpv"
local DB_PATH = STATE_DIR .. "/watch_history.json"

local COUNTDOWN_ACTIVE = false
local COUNTDOWN_TIMER = nil
local COUNTDOWN_SECS = 4
local TEMP_KEYS_BOUND = false

local SAVE_TIMER = nil
local CURRENT_FILE_PATH = nil

-- Cria pasta de estado se não existir
local function ensure_state_dir()
    local f = io.open(DB_PATH, "r")
    if f then
        f:close()
        return
    end
    os.execute(string.format("mkdir -p '%s'", STATE_DIR))
end

-- Carrega banco de dados JSON
local function load_db()
    local f = io.open(DB_PATH, "r")
    if not f then return {} end
    local content = f:read("*all")
    f:close()
    if not content or #content == 0 then return {} end
    local parsed = utils.parse_json(content)
    return parsed or {}
end

-- Salva banco de dados JSON
local function save_db(db)
    ensure_state_dir()
    local json_str = utils.format_json(db)
    if not json_str then return end
    local f = io.open(DB_PATH, "w")
    if f then
        f:write(json_str)
        f:close()
    end
end

-- Detecta nome amigável da série a partir do caminho
local function detect_series_name(filepath)
    local dir, filename = utils.split_path(filepath)
    if not dir or #dir == 0 then return filename end

    dir = dir:gsub("[/\\]+$", "")
    local parent_dir, current_folder = utils.split_path(dir)

    -- Se estiver em pasta de temporada (Season 1, Temporada 1), o nome da série é a pasta mãe
    local lower_folder = current_folder:lower()
    if lower_folder:match("^[Ss]eason[%s_%-]*(%d+)") or
       lower_folder:match("^[Tt]emporada[%s_%-]*(%d+)") or
       lower_folder:match("^[Ss](%d+)$") or
       lower_folder:match("^[Tt](%d+)$") then
        if parent_dir and #parent_dir > 0 then
            local _, show_folder = utils.split_path(parent_dir:gsub("[/\\]+$", ""))
            if show_folder and #show_folder > 0 then
                return show_folder
            end
        end
    end

    return current_folder
end

-- Salva o progresso da mídia atual
local function record_current_progress()
    local path = mp.get_property("path", "")
    if not path or path:find("^%a[%a%d_]+://") then return end

    local time_pos = mp.get_property_number("time-pos", 0)
    local duration = mp.get_property_number("duration", 0)

    if duration <= 30 or time_pos <= 5 then return end

    local percent = math.floor((time_pos / duration) * 100)
    local remaining = duration - time_pos
    local completed = (percent >= 85) or (remaining <= 120)

    local _, filename = utils.split_path(path)
    local series_name = detect_series_name(path)

    local db = load_db()
    db[path] = {
        path = path,
        filename = filename,
        series_name = series_name,
        time_pos = math.floor(time_pos),
        duration = math.floor(duration),
        percent = percent,
        completed = completed,
        last_watched = os.time()
    }
    save_db(db)
end

-- Desvincula teclas temporárias de cancelamento
local function unbind_cancel_keys()
    if TEMP_KEYS_BOUND then
        mp.remove_key_binding("cancel_auto_skip_esc")
        mp.remove_key_binding("cancel_auto_skip_space")
        TEMP_KEYS_BOUND = false
    end
end

-- Cancela a contagem regressiva de avanço
local function cancel_auto_skip()
    if COUNTDOWN_ACTIVE then
        COUNTDOWN_ACTIVE = false
        if COUNTDOWN_TIMER then
            COUNTDOWN_TIMER:kill()
            COUNTDOWN_TIMER = nil
        end
        unbind_cancel_keys()
        mp.set_property_bool("pause", false)
        mp.osd_message("🛑 Salto cancelado! Continuando neste episódio.", 2.5)
        msg.info("Smart-Resume: Salto de episódio cancelado pelo usuário.")
    end
end

-- Executa o salto para o próximo episódio
local function execute_auto_skip()
    COUNTDOWN_ACTIVE = false
    unbind_cancel_keys()
    if COUNTDOWN_TIMER then
        COUNTDOWN_TIMER:kill()
        COUNTDOWN_TIMER = nil
    end

    local pos = mp.get_property_number("playlist-pos", 0)
    local count = mp.get_property_number("playlist-count", 1)

    if pos < (count - 1) then
        mp.osd_message("⏭️ Saltando para o próximo episódio...", 2.0)
        mp.set_property_bool("pause", false)
        mp.commandv("playlist-next")
    else
        mp.set_property_bool("pause", false)
    end
end

-- Inicia contagem regressiva cancelável na tela
local function start_auto_skip_countdown(percent)
    if COUNTDOWN_ACTIVE then return end
    COUNTDOWN_ACTIVE = true

    -- Pausa para dar tempo de leitura ao usuário
    mp.set_property_bool("pause", true)

    -- Mapeia teclas de cancelamento
    mp.add_forced_key_binding("ESC", "cancel_auto_skip_esc", cancel_auto_skip)
    mp.add_forced_key_binding("SPACE", "cancel_auto_skip_space", cancel_auto_skip)
    TEMP_KEYS_BOUND = true

    local remaining_seconds = COUNTDOWN_SECS

    local function tick()
        if not COUNTDOWN_ACTIVE then return end
        if remaining_seconds > 0 then
            mp.osd_message(string.format(
                "⏭️ Episódio anterior já concluído (%d%%)!\nSaltando para o próximo em %ds... [Esc ou Espaço para ficar aqui]",
                percent, remaining_seconds
            ), 1.2)
            remaining_seconds = remaining_seconds - 1
            COUNTDOWN_TIMER = mp.add_timeout(1.0, tick)
        else
            execute_auto_skip()
        end
    end

    tick()
end

-- Ao carregar um arquivo, verifica se o usuário já havia assistido
local function on_file_loaded()
    local path = mp.get_property("path", "")
    if not path or path:find("^%a[%a%d_]+://") then return end
    CURRENT_FILE_PATH = path

    -- Cancela qualquer contagem anterior
    if COUNTDOWN_ACTIVE then
        cancel_auto_skip()
    end

    local db = load_db()
    local item = db[path]

    if item and item.completed then
        -- O arquivo já foi marcado como concluído (>85%)
        local pos = mp.get_property_number("playlist-pos", 0)
        local count = mp.get_property_number("playlist-count", 1)

        -- Se há próximo episódio na playlist (graças ao nosso autoload)
        if pos < (count - 1) then
            -- Aguarda 0.8s para a interface estabilizar e inicia contagem
            mp.add_timeout(0.8, function()
                if mp.get_property("path", "") == path then
                    start_auto_skip_countdown(item.percent or 90)
                end
            end)
            return
        else
            -- Último episódio da série já visto: reinicia do começo
            mp.add_timeout(0.5, function()
                mp.commandv("seek", 0, "absolute")
                mp.osd_message("✅ Episódio já concluído (Fim da Série) [Iniciando do início]", 3.0)
            end)
            return
        end
    elseif item and item.time_pos and item.time_pos > 20 and not item.completed then
        -- Mídia em andamento: notifica onde está continuando
        local mins = math.floor(item.time_pos / 60)
        local secs = item.time_pos % 60
        mp.add_timeout(0.5, function()
            mp.osd_message(string.format("⏸️ Continuando aos %02d:%02d (%d%%)", mins, secs, item.percent), 2.5)
        end)
    end
end

-- HUD Visual de Histórico Recente ('H')
local function show_history_hud()
    local db = load_db()
    local items = {}
    for _, val in pairs(db) do
        table.insert(items, val)
    end

    table.sort(items, function(a, b)
        return (a.last_watched or 0) > (b.last_watched or 0)
    end)

    if #items == 0 then
        mp.osd_message("📺 Nenhum histórico recente encontrado.", 2.5)
        return
    end

    local lines = { "📺 CONTINUAR ASSISTINDO (Últimas Mídias):" }
    local max_show = math.min(#items, 5)

    for i = 1, max_show do
        local it = items[i]
        local mins = math.floor((it.time_pos or 0) / 60)
        local total_mins = math.floor((it.duration or 0) / 60)
        local status = it.completed and "✅ Concluído" or string.format("⏸️ %d:%02d / %d:00 (%d%%)", mins, it.time_pos % 60, total_mins, it.percent or 0)
        local display_title = (it.series_name and it.series_name ~= it.filename)
            and string.format("%s — %s", it.series_name, it.filename)
            or it.filename

        table.insert(lines, string.format(" [%d] %s\n     └─ %s", i, display_title, status))
    end

    table.insert(lines, "\n[Pressione 'H' novamente para fechar]")
    mp.osd_message(table.concat(lines, "\n"), 5.0)
end

-- Inicia timer periódico de gravação a cada 8 segundos
SAVE_TIMER = mp.add_periodic_timer(8.0, record_current_progress)

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", record_current_progress)
mp.observe_property("pause", "bool", function(name, paused)
    if paused then record_current_progress() end
end)

mp.add_key_binding("H", "show_history", show_history_hud)
