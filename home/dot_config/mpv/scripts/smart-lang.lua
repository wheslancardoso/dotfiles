-- ==============================================================================
-- 🧠 Smart-Lang — Super-Inteligência de Idioma, Legenda & Dual Audio
-- ==============================================================================
-- Resolve TODOS os problemas de legenda e dual audio de uma vez:
--
-- 1. AUTO-SELECT: Ao abrir um vídeo, seleciona automaticamente a MELHOR legenda
--    para imersão em inglês (prioriza en full > en SDH > en qualquer > pt)
-- 2. DUAL AUDIO LINK: Ao trocar de áudio (a/A), troca a legenda junto para
--    o idioma correspondente automaticamente.
-- 3. IMMERSION TOGGLE: Alt+e ativa o "Modo Imersão Total" (áudio EN + legenda EN)
--    com 1 tecla. Alt+p volta para áudio PT + legenda PT.
-- 4. AUTO-DOWNLOAD: Se não encontrar legenda boa, baixa automaticamente via
--    OpenSubtitles em background (sem precisar apertar Ctrl+s).
-- 5. SECONDARY SUB: Ctrl+e ativa legendas duplas (EN primária + PT secundária)
--    para estudo comparativo lado a lado.
-- ==============================================================================

local mp = require 'mp'
local msg = require 'mp.msg'

-- Configuração de preferência de idioma para imersão
local PREF = {
    -- Prioridade de áudio (primeiro = mais preferido)
    audio_immersion = { "en", "eng" },
    audio_native    = { "pt", "por", "pt-BR", "ptBR" },
    audio_anime     = { "ja", "jp", "jpn" },

    -- Prioridade de legenda
    sub_immersion   = { "en", "eng", "enUS", "en-US" },
    sub_native      = { "pt", "por", "pt-BR", "ptBR", "pob" },
}

-- ============================================================================
-- Utilitários
-- ============================================================================

local function normalize_lang(lang)
    if not lang then return nil end
    lang = lang:lower():gsub("[_%-]", "")
    -- Mapeia variações para forma canônica
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

-- Pontua uma trilha de legenda (maior = melhor para imersão em inglês)
local function score_subtitle(track, target_langs)
    if not track or track.type ~= "sub" then return -999 end

    local lang = normalize_lang(track.lang)
    local score = 0

    -- Idioma correto é a base (+100 para primeiro match, +90 para segundo, etc.)
    local lang_matched = false
    for i, wanted in ipairs(target_langs) do
        if lang == normalize_lang(wanted) then
            score = score + (100 - i)
            lang_matched = true
            break
        end
    end

    -- Se o idioma nem bate, descarta
    if not lang_matched then return -999 end

    -- Penalidades e bônus
    if is_forced(track) then
        score = score - 80  -- Forçadas = quase nunca queremos
    end

    if is_sdh(track) then
        score = score - 5   -- SDH é ok, mas full é melhor
    end

    if is_commentary(track) then
        score = score - 90  -- Comentário = lixo
    end

    -- Legendas externas têm leve bônus (geralmente melhor qualidade)
    if track.external then
        score = score + 2
    end

    -- Trilha "default" marcada pelo muxer tem leve bônus
    if track.default then
        score = score + 1
    end

    return score
end

-- Encontra a melhor trilha de um tipo com base numa lista de idiomas preferidos
local function find_best_track(track_type, preferred_langs)
    local tracks = mp.get_property_native("track-list", {})
    local best_track = nil
    local best_score = -999

    for _, track in ipairs(tracks) do
        if track.type == track_type then
            local s = score_subtitle(track, preferred_langs)
            if s > best_score then
                best_score = s
                best_track = track
            end
        end
    end

    return best_track, best_score
end

-- Encontra qualquer trilha de áudio com o idioma especificado
local function find_audio_by_lang(target_langs)
    local tracks = mp.get_property_native("track-list", {})
    for _, wanted in ipairs(target_langs) do
        local norm_wanted = normalize_lang(wanted)
        for _, track in ipairs(tracks) do
            if track.type == "audio" and normalize_lang(track.lang) == norm_wanted then
                if not is_commentary(track) then
                    return track
                end
            end
        end
    end
    return nil
end

-- ============================================================================
-- 1. AUTO-SELECT: Seleciona a melhor legenda ao abrir o vídeo
-- ============================================================================

local function auto_select_best_sub()
    local tracks = mp.get_property_native("track-list", {})

    -- Conta quantas trilhas de legenda existem
    local sub_count = 0
    for _, t in ipairs(tracks) do
        if t.type == "sub" then sub_count = sub_count + 1 end
    end

    if sub_count == 0 then
        msg.info("Smart-Lang: Nenhuma legenda encontrada. Auto-download será tentado.")
        -- Dispara auto-download em background após 2 segundos (dá tempo do file-loaded terminar)
        mp.add_timeout(2, function()
            auto_download_if_needed()
        end)
        return
    end

    -- Tenta encontrar a melhor legenda em inglês (imersão)
    local best, best_score = find_best_track("sub", PREF.sub_immersion)

    -- Se não encontrou em inglês, tenta português
    if best_score < 0 then
        best, best_score = find_best_track("sub", PREF.sub_native)
    end

    if best and best_score > 0 then
        mp.set_property_number("sid", best.id)
        local lang_label = best.lang or best.title or ("Track " .. best.id)
        local type_label = ""
        if is_forced(best) then type_label = " [Forçada]"
        elseif is_sdh(best) then type_label = " [SDH]"
        end
        msg.info(string.format("Smart-Lang: Auto-selecionado legenda: %s%s (score: %d)",
            lang_label, type_label, best_score))
    end
end

-- ============================================================================
-- 2. DUAL AUDIO LINK: Ao trocar áudio, troca legenda junto
-- ============================================================================

local last_audio_id = nil

local function on_audio_change(_, aid)
    if not aid then return end
    local new_aid = tonumber(aid) or 0
    if new_aid == last_audio_id then return end
    last_audio_id = new_aid

    if new_aid == 0 then return end

    local tracks = mp.get_property_native("track-list", {})

    -- Descobre o idioma do áudio atual
    local audio_lang = nil
    for _, track in ipairs(tracks) do
        if track.type == "audio" and track.id == new_aid then
            audio_lang = normalize_lang(track.lang)
            break
        end
    end

    if not audio_lang then return end

    -- Mapeia o idioma do áudio para a preferência de legenda correspondente
    local sub_pref
    if audio_lang == "en" then
        sub_pref = PREF.sub_immersion
    elseif audio_lang == "pt" then
        sub_pref = PREF.sub_native
    elseif audio_lang == "ja" then
        -- Anime: áudio japonês → legenda em inglês
        sub_pref = PREF.sub_immersion
    else
        -- Para outros idiomas, tenta legenda em inglês
        sub_pref = PREF.sub_immersion
    end

    local best = find_best_track("sub", sub_pref)
    if best then
        mp.set_property_number("sid", best.id)
        local lang_label = best.lang or best.title or ("Track " .. best.id)
        mp.osd_message(string.format("🧠 [Smart-Lang] Áudio: %s → Legenda: %s", audio_lang:upper(), lang_label), 2.5)
    end
end

-- ============================================================================
-- 3. IMMERSION TOGGLE: Alt+e = Modo Imersão (EN), Alt+p = Modo Nativo (PT)
-- ============================================================================

local function set_immersion_mode()
    local audio = find_audio_by_lang(PREF.audio_immersion)
    if audio then
        mp.set_property_number("aid", audio.id)
    end

    local sub = find_best_track("sub", PREF.sub_immersion)
    if sub then
        mp.set_property_number("sid", sub.id)
    end

    -- Desativa legenda secundária
    mp.set_property("secondary-sid", "no")

    local a_label = audio and (audio.lang or "EN") or "N/A"
    local s_label = sub and (sub.lang or "EN") or "N/A"
    mp.osd_message(string.format("🎯 [IMMERSION MODE] 🇬🇧\nÁudio: %s | Legenda: %s\nFoco total em inglês!", a_label, s_label), 3.5)
end

local function set_native_mode()
    local audio = find_audio_by_lang(PREF.audio_native)
    if not audio then
        -- Se não tem PT, tenta EN
        audio = find_audio_by_lang(PREF.audio_immersion)
    end
    if audio then
        mp.set_property_number("aid", audio.id)
    end

    local sub = find_best_track("sub", PREF.sub_native)
    if not sub then
        sub = find_best_track("sub", PREF.sub_immersion)
    end
    if sub then
        mp.set_property_number("sid", sub.id)
    end

    mp.set_property("secondary-sid", "no")

    local a_label = audio and (audio.lang or "PT") or "N/A"
    local s_label = sub and (sub.lang or "PT") or "N/A"
    mp.osd_message(string.format("🏠 [NATIVE MODE] 🇧🇷\nÁudio: %s | Legenda: %s", a_label, s_label), 3.5)
end

-- ============================================================================
-- 4. AUTO-DOWNLOAD: Baixa legenda se nenhuma boa for encontrada
-- ============================================================================

function auto_download_if_needed()
    local tracks = mp.get_property_native("track-list", {})
    local path = mp.get_property("path", "")

    -- Não funciona para streams
    if not path or path == "" or path:find("^%a[%a%d_]+://") then return end

    -- Verifica se já tem legenda aceitável
    local en_sub = find_best_track("sub", PREF.sub_immersion)
    local pt_sub = find_best_track("sub", PREF.sub_native)

    if en_sub or pt_sub then return end -- Já tem legenda boa

    msg.info("Smart-Lang: Nenhuma legenda encontrada. Tentando download automático...")
    mp.osd_message("🌐 [Smart-Lang] Sem legendas. Baixando automaticamente...", 3.0)

    -- Tenta via subliminal (mais confiável e simples)
    mp.command_native_async({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        args = { "which", "subliminal" }
    }, function(ok, res)
        if ok and res.status == 0 then
            mp.command_native_async({
                name = "subprocess",
                playback_only = false,
                args = { "subliminal", "download", "-l", "en", "-l", "pt-BR", path }
            }, function(sub_ok, sub_res)
                if sub_ok and sub_res.status == 0 then
                    mp.commandv("rescan-external-files", "reselect")
                    mp.osd_message("🎉 [Smart-Lang] Legenda baixada e ativada automaticamente!", 3.5)
                    -- Re-run auto-select para pegar a melhor
                    mp.add_timeout(1, auto_select_best_sub)
                else
                    mp.osd_message("⚠️ [Smart-Lang] Não encontrou legendas online. Use Ctrl+s para busca manual.", 3.5)
                end
            end)
        else
            msg.info("Smart-Lang: 'subliminal' não instalado. Pulando auto-download.")
        end
    end)
end

-- ============================================================================
-- 5. SECONDARY SUB: Legenda dupla para estudo (EN + PT lado a lado)
-- ============================================================================

local dual_sub_active = false

local function toggle_dual_subs()
    if dual_sub_active then
        -- Desativa legenda secundária
        mp.set_property("secondary-sid", "no")
        dual_sub_active = false
        mp.osd_message("📝 [Dual Sub] Desativado — legenda única", 2.5)
    else
        -- Ativa: primária = EN, secundária = PT
        local en_sub = find_best_track("sub", PREF.sub_immersion)
        local pt_sub = find_best_track("sub", PREF.sub_native)

        if en_sub and pt_sub and en_sub.id ~= pt_sub.id then
            mp.set_property_number("sid", en_sub.id)
            mp.set_property_number("secondary-sid", pt_sub.id)
            -- Posiciona a secundária no topo da tela
            mp.set_property("secondary-sub-pos", 15)
            dual_sub_active = true
            mp.osd_message("📝 [Dual Sub] Ativo!\n🇬🇧 Inglês (baixo) + 🇧🇷 Português (topo)", 3.5)
        elseif en_sub or pt_sub then
            mp.osd_message("⚠️ [Dual Sub] Precisa de legendas em 2 idiomas diferentes.", 3.0)
        else
            mp.osd_message("⚠️ [Dual Sub] Nenhuma legenda encontrada.", 3.0)
        end
    end
end

-- ============================================================================
-- Registro de Eventos e Atalhos
-- ============================================================================

-- Auto-select ao carregar arquivo
mp.register_event("file-loaded", function()
    -- Pequeno delay para dar tempo de todas as trilhas serem detectadas
    mp.add_timeout(0.5, auto_select_best_sub)
end)

-- Monitora troca de áudio para linkar legenda
mp.observe_property("aid", "string", on_audio_change)

-- Atalhos registrados (vinculados no input.conf)
mp.add_key_binding(nil, "immersion_mode", set_immersion_mode)
mp.add_key_binding(nil, "native_mode", set_native_mode)
mp.add_key_binding(nil, "toggle_dual_subs", toggle_dual_subs)
