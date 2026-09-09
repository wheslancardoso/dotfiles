-- ==============================================================================
-- 🧠 Smart-Lang v2 — Full Auto Pipeline: Select → Download → Sync → Cache
-- ==============================================================================
--
-- PIPELINE AUTOMÁTICO COMPLETO (zero cliques):
--
--   ┌─────────────────────────────────────────────────────────────────┐
--   │  Arquivo abre                                                  │
--   │      ↓                                                         │
--   │  Cache existe? ─── SIM → Carrega .srt sincronizado → FIM ✅    │
--   │      ↓ NÃO                                                     │
--   │  Determina idioma-alvo baseado no áudio selecionado:           │
--   │    Audio EN → Sub EN | Audio PT → Sub PT | Audio JA → Sub EN   │
--   │      ↓                                                         │
--   │  Tem legenda boa? ─── SIM → Seleciona → Auto-Sync → Cache     │
--   │      ↓ NÃO                                                     │
--   │  Auto-Download (subliminal, multi-provider) → Sync → Cache     │
--   └─────────────────────────────────────────────────────────────────┘
--
-- RESULTADO: Na 2ª vez que abrir o mesmo vídeo, a legenda perfeitamente
-- sincronizada carrega em <100ms. Uma vez em cache, NUNCA mais dessincroniza
-- porque foi alinhada diretamente pela forma de onda do áudio deste vídeo.
--
-- DEPENDÊNCIAS (opcionais, o script degrada graciosamente):
--   pip install ffsubsync   → Sincronização acústica
--   pip install subliminal   → Download multi-provider (OpenSubtitles, Addic7ed, etc.)
--   ffmpeg                   → Extração de legendas embutidas em MKV/MP4
--
-- ATALHOS MANUAIS:
--   Alt+e  → Modo Imersão (Audio EN + Sub EN, 1 tecla)
--   Alt+p  → Modo Nativo (Audio PT + Sub PT, 1 tecla)
--   Ctrl+e → Dual Sub (EN embaixo + PT em cima)
--   a/A    → Trocar áudio (legenda acompanha automaticamente)
-- ==============================================================================

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

-- ==============================================================================
-- Configuração
-- ==============================================================================

local CACHE_DIR = os.getenv("HOME") .. "/.cache/mpv_synced_subs"

-- Preferências de idioma para imersão em inglês
local PREF = {
    audio_immersion = { "en", "eng" },
    audio_native    = { "pt", "por", "pt-BR", "ptBR" },
    audio_anime     = { "ja", "jp", "jpn" },
    sub_immersion   = { "en", "eng", "enUS", "en-US" },
    sub_native      = { "pt", "por", "pt-BR", "ptBR", "pob" },
}

-- Cache de verificação de ferramentas (evita rodar `which` repetidamente)
local tools_cache = {}

-- ==============================================================================
-- Utilitários
-- ==============================================================================

local function file_exists(path)
    local f = io.open(path, "r")
    if f then f:close(); return true end
    return false
end

local function normalize_lang(lang)
    if not lang then return nil end
    lang = lang:lower():gsub("[_%-]", "")
    local map = {
        en = "en", eng = "en", enus = "en",
        pt = "pt", por = "pt", ptbr = "pt", pob = "pt",
        ja = "ja", jp = "ja", jpn = "ja",
        es = "es", spa = "es",
        fr = "fr", fre = "fr", fra = "fr",
        de = "de", ger = "de", deu = "de",
    }
    return map[lang] or lang
end

local function has_tool(name)
    if tools_cache[name] ~= nil then return tools_cache[name] end
    local res = mp.command_native({
        name = "subprocess", playback_only = false,
        capture_stdout = true, args = { "which", name }
    })
    tools_cache[name] = (res.status == 0)
    return tools_cache[name]
end

local function is_forced(track)
    if track.forced then return true end
    local title = (track.title or ""):lower()
    return title:find("forced") or title:find("forçada") or title:find("forcada")
          or title:find("signs") or title:find("songs")
end

local function is_sdh(track)
    local title = (track.title or ""):lower()
    return title:find("sdh") or title:find("hearing") or title:find("cc")
          or title:find("closed caption")
end

local function is_commentary(track)
    local title = (track.title or ""):lower()
    return title:find("commentary") or title:find("comment") or title:find("director")
end

local function is_local_file(path)
    if not path or path == "" then return false end
    if path:find("^%a[%a%d_]+://") then return false end
    return true
end

-- ==============================================================================
-- Cache Management (chave = vídeo + idioma, não track ID)
-- ==============================================================================

local function ensure_cache_dir()
    mp.command_native({
        name = "subprocess", playback_only = false,
        args = { "mkdir", "-p", CACHE_DIR }
    })
end

local function get_cache_path(video_path, lang)
    local sanitized = video_path:gsub("[^%w%._-]", "_")
    if #sanitized > 120 then sanitized = sanitized:sub(-120) end
    return string.format("%s/%s_%s.synced.srt", CACHE_DIR, sanitized, lang or "en")
end

-- ==============================================================================
-- Subtitle Scoring & Selection
-- ==============================================================================

local function score_subtitle(track, target_langs)
    if not track or track.type ~= "sub" then return -999 end

    local lang = normalize_lang(track.lang)
    local score = 0
    local lang_matched = false

    for i, wanted in ipairs(target_langs) do
        if lang == normalize_lang(wanted) then
            score = score + (100 - i)
            lang_matched = true
            break
        end
    end

    if not lang_matched then return -999 end

    -- Penalidades
    if is_forced(track)     then score = score - 80 end
    if is_sdh(track)        then score = score - 5  end
    if is_commentary(track) then score = score - 90 end

    -- Bônus
    if track.external then score = score + 2 end
    if track.default  then score = score + 1 end

    return score
end

local function find_best_sub(target_langs)
    local tracks = mp.get_property_native("track-list", {})
    local best, best_score = nil, -999

    for _, track in ipairs(tracks) do
        if track.type == "sub" then
            local s = score_subtitle(track, target_langs)
            if s > best_score then
                best_score = s
                best = track
            end
        end
    end

    return best, best_score
end

local function find_audio_by_lang(target_langs)
    local tracks = mp.get_property_native("track-list", {})
    for _, wanted in ipairs(target_langs) do
        local norm = normalize_lang(wanted)
        for _, track in ipairs(tracks) do
            if track.type == "audio" and normalize_lang(track.lang) == norm then
                if not is_commentary(track) then return track end
            end
        end
    end
    return nil
end

-- ==============================================================================
-- Audio → Subtitle Language Mapping
-- ==============================================================================

local function get_current_audio_lang()
    local tracks = mp.get_property_native("track-list", {})
    local current_aid = mp.get_property_number("aid", 0)
    for _, track in ipairs(tracks) do
        if track.type == "audio" and track.id == current_aid then
            return normalize_lang(track.lang)
        end
    end
    return nil
end

-- Determina qual idioma de legenda baixar/selecionar baseado no áudio
local function map_audio_to_sub_lang(audio_lang)
    if audio_lang == "en" then return "en"      -- Audio EN → Sub EN (imersão: lendo junto)
    elseif audio_lang == "pt" then return "pt"   -- Audio PT → Sub PT (match)
    elseif audio_lang == "ja" then return "en"   -- Anime: JA → Sub EN
    else return "en"                             -- Default: imersão em inglês
    end
end

local function get_sub_prefs(target_lang)
    if target_lang == "pt" then return PREF.sub_native end
    return PREF.sub_immersion
end

-- Retorna o código de idioma que o subliminal entende
local function get_subliminal_lang(target_lang)
    if target_lang == "pt" then return "pt-BR" end
    return target_lang
end

-- ==============================================================================
-- Sync Engine (extrai embedded se necessário → ffsubsync → cache)
-- ==============================================================================

local function get_sub_stream_index(target_track)
    local tracks = mp.get_property_native("track-list", {})
    local idx = 0
    for _, track in ipairs(tracks) do
        if track.type == "sub" then
            if track.id == target_track.id then return idx end
            idx = idx + 1
        end
    end
    return 0
end

local function sync_and_cache(video_path, sub_file, target_lang, callback)
    if not has_tool("ffsubsync") then
        msg.info("Smart-Lang: ffsubsync não disponível. Pulando auto-sync.")
        if callback then callback(false) end
        return
    end

    ensure_cache_dir()
    local output = get_cache_path(video_path, target_lang)

    mp.osd_message("🔄 [Auto-Sync] Alinhando legenda com o áudio... (background)", 3.0)

    mp.command_native_async({
        name = "subprocess", playback_only = false,
        args = { "ffsubsync", video_path, "-i", sub_file, "-o", output }
    }, function(ok, res)
        if ok and res.status == 0 and file_exists(output) then
            mp.commandv("sub-add", output, "select")
            mp.osd_message("✅ [Auto-Sync] Legenda sincronizada e salva em cache permanente!", 3.5)
            msg.info("Smart-Lang: Sync completo → " .. output)
            if callback then callback(true) end
        else
            mp.osd_message("⚠️ [Auto-Sync] ffsubsync não conseguiu alinhar. Usando legenda original.", 3.0)
            if callback then callback(false) end
        end
    end)
end

local function sync_track(video_path, sub_track, target_lang)
    if sub_track.external and sub_track["external-filename"] then
        -- Legenda externa: sincroniza direto
        sync_and_cache(video_path, sub_track["external-filename"], target_lang)
    else
        -- Legenda embutida: extrai com ffmpeg primeiro
        if not has_tool("ffmpeg") then
            msg.info("Smart-Lang: ffmpeg não disponível. Não é possível extrair legendas internas.")
            return
        end

        local sub_idx = get_sub_stream_index(sub_track)
        local temp = string.format("/tmp/mpv_smartlang_%d.srt", os.time())

        msg.info("Smart-Lang: Extraindo legenda embutida (stream index " .. sub_idx .. ")...")

        mp.command_native_async({
            name = "subprocess", playback_only = false,
            args = { "ffmpeg", "-y", "-i", video_path, "-map", string.format("0:s:%d", sub_idx), temp }
        }, function(ok, res)
            if ok and res.status == 0 and file_exists(temp) then
                sync_and_cache(video_path, temp, target_lang, function()
                    os.remove(temp)
                end)
            else
                msg.warn("Smart-Lang: Falha ao extrair legenda com ffmpeg.")
                os.remove(temp)
            end
        end)
    end
end

-- ==============================================================================
-- Download Engine (subliminal multi-provider, language-aware)
-- ==============================================================================

local function download_and_sync(video_path, target_lang, callback)
    if not has_tool("subliminal") then
        msg.info("Smart-Lang: subliminal não instalado. Auto-download desativado.")
        mp.osd_message("⚠️ Sem legendas. Para auto-download instale:\npip install subliminal", 4.0)
        if callback then callback(false) end
        return
    end

    -- Diretório temporário limpo para este download
    local tmp_dir = string.format("/tmp/mpv_smartlang_dl_%d", os.time())
    mp.command_native({
        name = "subprocess", playback_only = false,
        args = { "mkdir", "-p", tmp_dir }
    })

    local sub_lang = get_subliminal_lang(target_lang)
    local fallback_lang = target_lang == "en" and "pt-BR" or "en"

    mp.osd_message(string.format("🌐 [Smart-Lang] Baixando legenda %s...", sub_lang:upper()), 3.0)
    msg.info(string.format("Smart-Lang: Downloading %s subtitles for: %s", sub_lang, video_path))

    local function try_download(lang, on_result)
        mp.command_native_async({
            name = "subprocess", playback_only = false,
            capture_stdout = true, capture_stderr = true,
            args = { "subliminal", "download", "-l", lang, "-d", tmp_dir, "--", video_path }
        }, function(ok, res)
            -- Verifica se algum arquivo foi baixado
            local find_res = mp.command_native({
                name = "subprocess", playback_only = false,
                capture_stdout = true,
                args = { "find", tmp_dir, "-maxdepth", "1", "-type", "f",
                         "(", "-name", "*.srt", "-o", "-name", "*.ass", "-o", "-name", "*.sub", ")",
                         "-print", "-quit" }
            })

            local found_file = nil
            if find_res.status == 0 and find_res.stdout then
                found_file = find_res.stdout:gsub("%s+$", "")
                if #found_file == 0 then found_file = nil end
            end

            on_result(found_file)
        end)
    end

    -- Tenta idioma primário, depois fallback
    try_download(sub_lang, function(sub_path)
        if sub_path then
            on_download_success(video_path, sub_path, target_lang, tmp_dir, callback)
        else
            -- Fallback para outro idioma
            msg.info("Smart-Lang: Primary language not found, trying fallback: " .. fallback_lang)
            mp.osd_message(string.format("🌐 [Smart-Lang] %s não encontrada, tentando %s...",
                sub_lang:upper(), fallback_lang:upper()), 2.5)

            try_download(fallback_lang, function(fb_path)
                if fb_path then
                    -- O fallback é de outro idioma, mas ainda usamos target_lang pro cache
                    local actual_lang = target_lang == "en" and "pt" or "en"
                    on_download_success(video_path, fb_path, actual_lang, tmp_dir, callback)
                else
                    mp.osd_message("⚠️ [Smart-Lang] Nenhuma legenda encontrada online.\nUse Ctrl+s para busca manual.", 4.0)
                    if callback then callback(false) end
                end
            end)
        end
    end)
end

function on_download_success(video_path, sub_path, target_lang, tmp_dir, callback)
    mp.commandv("sub-add", sub_path, "select")
    mp.osd_message("🎉 [Smart-Lang] Legenda baixada! Sincronizando...", 2.5)

    -- Auto-sync a legenda baixada
    mp.add_timeout(0.5, function()
        sync_and_cache(video_path, sub_path, target_lang, function(sync_ok)
            -- Limpa temp dir depois de tudo (com delay pra garantir que o sync copiou)
            mp.add_timeout(2, function()
                mp.command_native({
                    name = "subprocess", playback_only = false,
                    args = { "rm", "-rf", tmp_dir }
                })
            end)
            if callback then callback(true) end
        end)
    end)
end

-- ==============================================================================
-- 🚀 Full Auto Pipeline — Orquestrador principal
-- ==============================================================================

local pipeline_running = false

local function run_auto_pipeline()
    local video_path = mp.get_property("path", "")
    if not is_local_file(video_path) then return end
    if pipeline_running then return end
    pipeline_running = true

    msg.info("Smart-Lang: Pipeline auto iniciado para: " .. video_path)

    -- 1. Determinar idioma-alvo baseado no áudio
    local audio_lang = get_current_audio_lang()
    local target_lang = map_audio_to_sub_lang(audio_lang)
    msg.info(string.format("Smart-Lang: Audio=%s → Target sub=%s", audio_lang or "?", target_lang))

    -- 2. Cache hit? → Carrega instantaneamente e encerra
    ensure_cache_dir()
    local cached = get_cache_path(video_path, target_lang)
    if file_exists(cached) then
        mp.commandv("sub-add", cached, "select")
        mp.osd_message(string.format("⚡ [Smart-Lang] Legenda %s sincronizada (cache)", target_lang:upper()), 2.5)
        pipeline_running = false
        return
    end

    -- 3. Buscar a melhor legenda existente no arquivo
    local pref = get_sub_prefs(target_lang)
    local best, best_score = find_best_sub(pref)

    if best and best_score > 0 then
        -- Tem legenda boa → seleciona e sincroniza
        mp.set_property_number("sid", best.id)
        local label = best.lang or best.title or ("Track " .. best.id)
        msg.info(string.format("Smart-Lang: Selecionada legenda: %s (score: %d)", label, best_score))

        -- Auto-sync em background
        mp.add_timeout(1.5, function()
            sync_track(video_path, best, target_lang)
            pipeline_running = false
        end)
    else
        -- Sem legenda boa → download automático
        msg.info("Smart-Lang: Nenhuma legenda adequada encontrada. Iniciando download...")
        download_and_sync(video_path, target_lang, function()
            pipeline_running = false
        end)
    end
end

-- ==============================================================================
-- 🔗 Dual Audio Link — Troca de áudio sincroniza legenda junto
-- ==============================================================================

local last_audio_id = nil

local function on_audio_change(_, aid)
    if not aid then return end
    local new_aid = tonumber(aid) or 0
    if new_aid == last_audio_id then return end
    last_audio_id = new_aid
    if new_aid == 0 then return end

    local video_path = mp.get_property("path", "")
    if not is_local_file(video_path) then return end

    -- Descobre o idioma do novo áudio
    local tracks = mp.get_property_native("track-list", {})
    local audio_lang = nil
    for _, track in ipairs(tracks) do
        if track.type == "audio" and track.id == new_aid then
            audio_lang = normalize_lang(track.lang)
            break
        end
    end
    if not audio_lang then return end

    local target_lang = map_audio_to_sub_lang(audio_lang)

    -- Cache hit? → Carrega a versão sincronizada para este idioma
    local cached = get_cache_path(video_path, target_lang)
    if file_exists(cached) then
        mp.commandv("sub-add", cached, "select")
        mp.osd_message(string.format("🧠 [Smart-Lang] Áudio %s → Legenda %s (cache)",
            audio_lang:upper(), target_lang:upper()), 2.5)
        return
    end

    -- Sem cache: busca a melhor legenda disponível
    local pref = get_sub_prefs(target_lang)
    local best = find_best_sub(pref)

    if best then
        mp.set_property_number("sid", best.id)
        local label = best.lang or best.title or ("Track " .. best.id)
        mp.osd_message(string.format("🧠 [Smart-Lang] Áudio %s → Legenda: %s",
            audio_lang:upper(), label), 2.5)
    else
        mp.osd_message(string.format("🧠 [Smart-Lang] Áudio %s → Sem legenda %s disponível",
            audio_lang:upper(), target_lang:upper()), 2.5)
    end
end

-- ==============================================================================
-- 🎯 Mode Toggles — Immersion / Native / Dual Sub
-- ==============================================================================

local function set_immersion_mode()
    local video_path = mp.get_property("path", "")

    local audio = find_audio_by_lang(PREF.audio_immersion)
    if audio then mp.set_property_number("aid", audio.id) end

    -- Tenta cache primeiro
    if is_local_file(video_path) then
        local cached = get_cache_path(video_path, "en")
        if file_exists(cached) then
            mp.commandv("sub-add", cached, "select")
            mp.set_property("secondary-sid", "no")
            local a_label = audio and (audio.lang or "EN") or "N/A"
            mp.osd_message(string.format(
                "🎯 [IMMERSION MODE] 🇬🇧\nÁudio: %s | Legenda: EN (synced cache)\nFoco total em inglês!", a_label), 3.5)
            return
        end
    end

    local sub = find_best_sub(PREF.sub_immersion)
    if sub then mp.set_property_number("sid", sub.id) end
    mp.set_property("secondary-sid", "no")

    local a_label = audio and (audio.lang or "EN") or "N/A"
    local s_label = sub and (sub.lang or "EN") or "N/A"
    mp.osd_message(string.format(
        "🎯 [IMMERSION MODE] 🇬🇧\nÁudio: %s | Legenda: %s\nFoco total em inglês!", a_label, s_label), 3.5)
end

local function set_native_mode()
    local video_path = mp.get_property("path", "")

    local audio = find_audio_by_lang(PREF.audio_native)
    if not audio then audio = find_audio_by_lang(PREF.audio_immersion) end
    if audio then mp.set_property_number("aid", audio.id) end

    -- Tenta cache primeiro
    if is_local_file(video_path) then
        local cached = get_cache_path(video_path, "pt")
        if file_exists(cached) then
            mp.commandv("sub-add", cached, "select")
            mp.set_property("secondary-sid", "no")
            local a_label = audio and (audio.lang or "PT") or "N/A"
            mp.osd_message(string.format(
                "🏠 [NATIVE MODE] 🇧🇷\nÁudio: %s | Legenda: PT (synced cache)", a_label), 3.5)
            return
        end
    end

    local sub = find_best_sub(PREF.sub_native)
    if not sub then sub = find_best_sub(PREF.sub_immersion) end
    if sub then mp.set_property_number("sid", sub.id) end
    mp.set_property("secondary-sid", "no")

    local a_label = audio and (audio.lang or "PT") or "N/A"
    local s_label = sub and (sub.lang or "PT") or "N/A"
    mp.osd_message(string.format(
        "🏠 [NATIVE MODE] 🇧🇷\nÁudio: %s | Legenda: %s", a_label, s_label), 3.5)
end

local dual_sub_active = false

local function toggle_dual_subs()
    if dual_sub_active then
        mp.set_property("secondary-sid", "no")
        dual_sub_active = false
        mp.osd_message("📝 [Dual Sub] Desativado — legenda única", 2.5)
    else
        local en_sub = find_best_sub(PREF.sub_immersion)
        local pt_sub = find_best_sub(PREF.sub_native)

        if en_sub and pt_sub and en_sub.id ~= pt_sub.id then
            mp.set_property_number("sid", en_sub.id)
            mp.set_property_number("secondary-sid", pt_sub.id)
            mp.set_property("secondary-sub-pos", 15)
            dual_sub_active = true
            mp.osd_message("📝 [Dual Sub] Ativo!\n🇬🇧 Inglês (baixo) + 🇧🇷 Português (topo)", 3.5)
        elseif en_sub or pt_sub then
            mp.osd_message("⚠️ [Dual Sub] Precisa de legendas em 2 idiomas.", 3.0)
        else
            mp.osd_message("⚠️ [Dual Sub] Nenhuma legenda encontrada.", 3.0)
        end
    end
end

-- ==============================================================================
-- Registro de Eventos e Atalhos
-- ==============================================================================

-- Pipeline auto ao carregar arquivo (delay de 1s para todas as trilhas serem detectadas)
mp.register_event("file-loaded", function()
    pipeline_running = false
    last_audio_id = nil
    mp.add_timeout(1.0, run_auto_pipeline)
end)

-- Dual audio link: monitora troca de áudio
mp.observe_property("aid", "string", on_audio_change)

-- Atalhos manuais (vinculados no input.conf)
mp.add_key_binding(nil, "immersion_mode", set_immersion_mode)
mp.add_key_binding(nil, "native_mode", set_native_mode)
mp.add_key_binding(nil, "toggle_dual_subs", toggle_dual_subs)
