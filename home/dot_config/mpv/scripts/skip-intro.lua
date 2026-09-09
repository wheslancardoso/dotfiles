-- ==============================================================================
-- ⏭️ Skip-Intro — Pular Aberturas e Encerramentos (Estilo Netflix / Crunchyroll)
-- ==============================================================================
-- Detecta automaticamente capítulos de "Opening", "Intro", "Abertura", "Recap"
-- e "Ending", permitindo pular a vinheta instantaneamente com a tecla TAB.
-- ==============================================================================

local mp = require 'mp'

local function is_intro_or_ending(title)
    if not title then return false end
    local lower = title:lower()
    return (
        lower:find("intro") or
        lower:find("opening") or
        lower:find("abertura") or
        lower:find("recap") or
        lower:find("^op$") or
        lower:find("ending") or
        lower:find("encerramento") or
        lower:find("créditos") or
        lower:find("credits") or
        lower:find("^ed$")
    )
end

local function check_chapter(name, chapter_idx)
    if not chapter_idx or chapter_idx < 0 then return end

    local chapters = mp.get_property_native("chapter-list", {})
    if #chapters == 0 then return end

    local current = chapters[chapter_idx + 1]
    if current and current.title and is_intro_or_ending(current.title) then
        mp.osd_message(string.format("⏭️ [%s] Pressione TAB para pular vinheta", current.title), 4.0)
    end
end

local function skip_intro()
    local chapters = mp.get_property_native("chapter-list", {})
    local chapter_idx = mp.get_property_number("chapter", -1)

    if chapter_idx >= 0 and chapter_idx < (#chapters - 1) then
        mp.commandv("add", "chapter", "1")
        mp.osd_message("⏭️ Abertura pulada!", 2.0)
    else
        -- Se não houver capítulos formais, avança 85 segundos (tempo padrão de abertura de série/anime)
        mp.commandv("seek", "85", "relative")
        mp.osd_message("⏭️ Avançado 85s (Pulo de Abertura)", 2.0)
    end
end

mp.observe_property("chapter", "number", check_chapter)
mp.add_key_binding(nil, "skip_intro", skip_intro)
