-- ==============================================================================
-- 🚀 YAZI INIT CONFIGURATION — Estética Catppuccin Mocha & Plugins de Elite
-- ==============================================================================

-- 1. Bordas Arredondadas Completas (Full Border)
require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

-- 2. Indicadores de Status Git em Tempo Real no Linemode
require("git"):setup {
	order = 1500,
}
