-- ==============================================================================
-- 🌐 Sub-Download — Baixar Legendas Automáticas com 1 Clique (Ctrl+s)
-- ==============================================================================
-- Pesquisa e baixa legendas oficiais em Inglês ou Português com base no nome
-- do arquivo ou hash do vídeo, injetando direto na reprodução sem sair do MPV.
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local function clean_title(filename)
    -- Remove extensões e ruídos comuns de releases (1080p, WEB-DL, x264, etc.)
    local name = filename:gsub("%.%w+$", "")
    name = name:gsub("[%._]", " ")
    name = name:gsub("%[.-%]", "")
    name = name:gsub("%(.-%)", "")
    name = name:gsub("%d%d%d+p.*", "")
    name = name:gsub("WEB%-DL.*", "")
    name = name:gsub("BluRay.*", "")
    name = name:gsub("x26%d.*", "")
    name = name:gsub("HEVC.*", "")
    return name:match("^%s*(.-)%s*$")
end

local function download_subtitles()
    local path = mp.get_property("path", "")
    if not path or path == "" or path:find("^%a[%a%d_]+://") then
        mp.osd_message("❌ [Sub-Download] Indisponível para streams diretos da web.", 3.0)
        return
    end

    local dir, filename = utils.split_path(path)
    local query = clean_title(filename)
    if not query or #query == 0 then query = filename end

    mp.osd_message(string.format("🌐 [Sub-Download] Buscando legendas para: %s...", query), 4.0)

    -- Script Python auxiliar inline para buscar no OpenSubtitles via REST v1
    local python_code = string.format([[
import urllib.request, urllib.parse, json, os, sys

query = sys.argv[1]
video_path = sys.argv[2]
base_dir = os.path.dirname(video_path)

headers = {'User-Agent': 'SubDB/1.0 (mpv-god-mode/1.0; https://github.com/dotfiles)'}
url = f"https://rest.opensubtitles.org/search/query-{urllib.parse.quote(query)}"

try:
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=8) as res:
        data = json.loads(res.read().decode('utf-8'))
        
    en_sub = None
    pt_sub = None
    
    for item in data:
        lang = item.get('SubLanguageID')
        link = item.get('SubDownloadLink')
        if lang in ['eng', 'en'] and not en_sub:
            en_sub = (item.get('MovieReleaseName') or 'English', link)
        elif lang in ['pob', 'pt', 'pt-br'] and not pt_sub:
            pt_sub = (item.get('MovieReleaseName') or 'Portuguese', link)
            
    chosen = en_sub or pt_sub
    if chosen and chosen[1]:
        dest_srt = os.path.join("/tmp", f"downloaded_{os.path.basename(video_path)}.srt")
        # Download gzipped srt
        gz_dest = dest_srt + ".gz"
        urllib.request.urlretrieve(chosen[1], gz_dest)
        import gzip
        with gzip.open(gz_dest, 'rb') as f_in, open(dest_srt, 'wb') as f_out:
            f_out.write(f_in.read())
        os.remove(gz_dest)
        print(dest_srt)
    else:
        sys.exit(1)
except Exception as e:
    sys.exit(1)
]], "")

    mp.command_native_async({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        args = { "python3", "-c", python_code, query, path }
    }, function(success, res)
        if success and res.status == 0 and res.stdout and #res.stdout:gsub("%s+", "") > 0 then
            local downloaded_file = res.stdout:gsub("%s+", "")
            mp.commandv("sub-add", downloaded_file, "select")
            mp.osd_message("🎉 [Sub-Download] Legenda baixada e ativada com sucesso!", 4.0)
        else
            -- Tenta fallback com subliminal se instalado
            mp.command_native_async({
                name = "subprocess",
                playback_only = false,
                args = { "subliminal", "download", "-l", "en", "-l", "pt-BR", path }
            }, function(sub_ok, sub_res)
                if sub_ok and sub_res.status == 0 then
                    mp.commandv("rescan-external-files", "reselect")
                    mp.osd_message("✔ [Subliminal] Legenda baixada e anexada!", 3.5)
                else
                    mp.osd_message("⚠️ [Sub-Download] Nenhuma legenda encontrada para este título.", 3.5)
                end
            end)
        end
    end)
end

mp.add_key_binding(nil, "download_subtitles", download_subtitles)
