-- Apex macOS Liquid Glass Animations
hl.config({
    animations = {
        enabled = true,
    },
})

-- Curvas de física orgânica & desaceleração Apple
hl.curve("apple_ease",  { type = "bezier", points = { {0.16, 1},    {0.3, 1}    } })
hl.curve("mac_fluid",   { type = "bezier", points = { {0.25, 1},    {0.5, 1}    } })
hl.curve("soft_decel",  { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.02} } })
hl.curve("win_pop",     { type = "bezier", points = { {0.05, 0.95}, {0.1, 1.05} } })
hl.curve("win_close",   { type = "bezier", points = { {0.3, -0.1},  {0.1, 1}    } })
hl.curve("liner",       { type = "bezier", points = { {1, 1},       {1, 1}       } })

-- Janelas: abertura em popin orgânico e fechamento limpo
hl.animation({ leaf = "windows",         enabled = true, speed = 4.5, bezier = "soft_decel",  style = "popin 75%" })
hl.animation({ leaf = "windowsIn",       enabled = true, speed = 4.2, bezier = "win_pop",     style = "popin 75%" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 3.2, bezier = "win_close",   style = "popin 80%" })
hl.animation({ leaf = "windowsMove",     enabled = true, speed = 4.0, bezier = "apple_ease",  style = "slide" })

-- Bordas e Fade
hl.animation({ leaf = "border",          enabled = true, speed = 1.5, bezier = "liner" })
hl.animation({ leaf = "borderangle",     enabled = true, speed = 100, bezier = "liner",       style = "loop" })
hl.animation({ leaf = "fade",            enabled = true, speed = 3.0, bezier = "apple_ease" })
hl.animation({ leaf = "fadeLayersIn",    enabled = true, speed = 2.5, bezier = "mac_fluid" })
hl.animation({ leaf = "fadeLayersOut",   enabled = true, speed = 2.0, bezier = "mac_fluid" })

-- Camadas flutuantes (Rofi, Notificações, Waybar)
hl.animation({ leaf = "layersIn",        enabled = true, speed = 3.5, bezier = "apple_ease",  style = "slide" })
hl.animation({ leaf = "layersOut",       enabled = true, speed = 2.5, bezier = "apple_ease",  style = "slide" })

-- Workspaces: Transição macOS líquida
hl.animation({ leaf = "workspaces",      enabled = true, speed = 4.5, bezier = "apple_ease",  style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace",enabled = true, speed = 3.8, bezier = "apple_ease",  style = "slidefadevert 25%" })
