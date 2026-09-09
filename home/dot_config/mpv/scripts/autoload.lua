-- ==============================================================================
-- 📜 Autoload.lua — Enfileirador Inteligente de Séries & Multi-Temporadas
-- ==============================================================================
-- 1. Ao abrir qualquer episódio de uma série (ex: S01E03), este script escaneia
--    automaticamente a pasta atual e pastas irmãs de temporadas (Season 1, Season 2,
--    Temporada 1, Temporada 2, Specials, etc.).
-- 2. Constrói uma playlist contínua em ordem alfanumérica natural.
-- 3. Quando o último episódio da Temporada 1 terminar, o MPV já avança direto
--    para a Temporada 2 Episódio 1 com zero interrupção!
-- ==============================================================================

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local EXTENSIONS = {
    'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg',
    'm4v', '3gp', 'ts', 'm2ts', 'mov', 'vob', 'iso'
}

local function Set(t)
    local set = {}
    for _, v in pairs(t) do set[v] = true end
    return set
end

local ext_map = Set(EXTENSIONS)

local function alnumcomp(x, y)
    local function padnum(d)
        local dec, n = string.match(d, "(%.?)0*(.+)")
        return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n)
    end
    return tostring(x):gsub("%.?%d+", padnum):lower() < tostring(y):gsub("%.?%d+", padnum):lower()
end

local function is_season_folder(name)
    if not name then return false end
    local lower = name:lower():gsub("^[%.%s]+", ""):gsub("[%.%s]+$", "")
    return lower:match("^[Ss]eason[%s_%-]*(%d+)")
        or lower:match("^[Tt]emporada[%s_%-]*(%d+)")
        or lower:match("^[Ss](%d+)$")
        or lower:match("^[Tt](%d+)$")
        or lower:match("^series[%s_%-]*(%d+)")
        or lower:match("specials")
        or lower:match("especiais")
        or lower:match("extras")
end

local function scan_dir_videos(directory)
    local entries = utils.readdir(directory, "files")
    if not entries then return {} end
    table.sort(entries, alnumcomp)
    local result = {}
    for _, file in ipairs(entries) do
        local ext = file:match("%.([^.]+)$")
        if ext and ext_map[ext:lower()] then
            table.insert(result, utils.join_path(directory, file))
        end
    end
    return result
end

local function clean_path(p)
    if not p or #p == 0 then return "." end
    return p:gsub("[/\\]+$", "")
end

local function get_series_playlist(current_path)
    local dir, filename = utils.split_path(current_path)
    if not dir or #dir == 0 then dir = "." end
    local clean_dir = clean_path(dir)
    local parent_dir, current_folder = utils.split_path(clean_dir)
    if not parent_dir or #parent_dir == 0 then parent_dir = "." end

    local season_dirs = {}
    local series_root = dir

    -- Caso A: O arquivo está dentro de uma pasta de temporada (ex: /Frieren/Season 01/E03.mkv)
    if is_season_folder(current_folder) then
        series_root = clean_path(parent_dir)
        local parent_subs = utils.readdir(series_root, "dirs") or {}
        for _, sub in ipairs(parent_subs) do
            if is_season_folder(sub) then
                table.insert(season_dirs, sub)
            end
        end
    else
        -- Caso B: O arquivo está na raiz da série e há subpastas de temporada
        local dir_subs = utils.readdir(clean_dir, "dirs") or {}
        local count = 0
        for _, sub in ipairs(dir_subs) do
            if is_season_folder(sub) then
                count = count + 1
                table.insert(season_dirs, sub)
            end
        end
        if count >= 1 then
            series_root = clean_dir
        else
            season_dirs = {}
        end
    end

    local playlist_items = {}

    -- Se detectou múltiplas temporadas na série
    if #season_dirs > 0 then
        table.sort(season_dirs, alnumcomp)
        for _, sdir in ipairs(season_dirs) do
            local full_sdir = utils.join_path(series_root, sdir)
            local files = scan_dir_videos(full_sdir)
            for _, f in ipairs(files) do
                table.insert(playlist_items, f)
            end
        end
        -- Inclui também qualquer arquivo avulso na raiz da série
        local root_files = scan_dir_videos(series_root)
        for _, f in ipairs(root_files) do
            table.insert(playlist_items, f)
        end
    else
        -- Modo pasta única padrão
        playlist_items = scan_dir_videos(dir)
    end

    return playlist_items
end

local function find_and_add_entries()
    local path = mp.get_property("path", "")
    if not path or path:find("^%a[%a%d_]+://") then
        return -- Ignora URLs remotas de streaming
    end

    local playlist_items = get_series_playlist(path)
    if #playlist_items <= 1 then return end

    local current_idx = nil
    for idx, item in ipairs(playlist_items) do
        if item == path then
            current_idx = idx
            break
        end
    end

    if not current_idx then return end

    -- Enfileira episódios seguintes (incluindo próximas temporadas)
    for i = current_idx + 1, #playlist_items do
        mp.commandv("loadfile", playlist_items[i], "append")
    end

    -- Enfileira episódios anteriores no final da playlist para acesso circular
    for i = 1, current_idx - 1 do
        mp.commandv("loadfile", playlist_items[i], "append")
    end

    local remaining_count = #playlist_items - current_idx
    msg.info(string.format("Autoload Multi-Temporadas: Enfileirados %d episódios seguintes.", remaining_count))
end

mp.register_event("file-loaded", find_and_add_entries)
