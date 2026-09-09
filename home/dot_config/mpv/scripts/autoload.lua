-- ==============================================================================
-- 📜 Autoload.lua — Enfileirador Inteligente de Séries para o MPV
-- ==============================================================================
-- Quando você abre um episódio de uma série ou um vídeo qualquer, este script
-- escaneia automaticamente a mesma pasta e adiciona todos os vídeos à playlist
-- em ordem alfanumérica natural (Episodio 1, 2, ..., 10).
-- ==============================================================================

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

local function find_and_add_entries()
    local path = mp.get_property("path", "")
    if path:find("^%a[%a%d_]+://") then
        return -- Não roda para URLs remotas de streaming direto
    end

    local dir, filename = utils.split_path(path)
    if not dir or #dir == 0 then dir = "." end

    local files = utils.readdir(dir, "files")
    if not files then return end

    table.sort(files, alnumcomp)

    local current_idx = nil
    local playlist_items = {}

    for _, file in ipairs(files) do
        local ext = file:match("%.([^.]+)$")
        if ext and ext_map[ext:lower()] then
            local full_path = utils.join_path(dir, file)
            table.insert(playlist_items, full_path)
            if full_path == path then
                current_idx = #playlist_items
            end
        end
    end

    if #playlist_items <= 1 or not current_idx then return end

    -- Adiciona arquivos seguintes na playlist
    for i = current_idx + 1, #playlist_items do
        mp.commandv("loadfile", playlist_items[i], "append")
    end

    -- Adiciona arquivos anteriores antes do arquivo atual
    for i = 1, current_idx - 1 do
        mp.commandv("loadfile", playlist_items[i], "append")
    end

    msg.info(string.format("Autoload: Enfileirados %d episódios da pasta.", #playlist_items))
end

mp.register_event("file-loaded", find_and_add_entries)
