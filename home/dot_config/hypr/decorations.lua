-- Decoration Settings & Wallust Dynamic Colors
local home = os.getenv("HOME")

-- Leitor dinâmico das cores geradas pelo Wallust
local function load_wallust_colors()
    local colors = {}
    local f = io.open(home .. "/.config/hypr/wallust/wallust-hyprland.conf", "r")
    if f then
        for line in f:lines() do
            local var, val = line:match("^%s*%$(%w+)%s*=%s*(.-)%s*$")
            if var and val then
                colors[var] = val
            end
        end
        f:close()
    end
    return colors
end

local c = load_wallust_colors()
local active_c1 = c["color12"] or "rgb(6F7073)"
local active_c2 = c["color11"] or "rgb(25282B)"
local active_c3 = c["color14"] or "rgb(DADBDD)"
local inactive_c = "rgba(283042aa)"
local group_border_active = c["color15"] or "rgb(E4E5E6)"
local group_bar_active = c["color0"] or "rgb(3A3A3B)"

hl.config({
    general = {
        border_size = 2,
        gaps_in = 3,
        gaps_out = 6,
        col = {
            active_border = { colors = { active_c1, active_c2, active_c3 }, angle = 45 },
            inactive_border = inactive_c,
        },
    },

    decoration = {
        rounding = 12,

        active_opacity = 1.0,
        inactive_opacity = 0.94,
        fullscreen_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.08,
        dim_special = 0.35,

        shadow = {
            enabled = true,
            range = 25,
            render_power = 3,
            color = "rgba(00000055)",
            color_inactive = "rgba(00000025)",
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            new_optimizations = true,
            xray = false,
            ignore_opacity = true,
            special = true,
            popups = true,
            noise = 0.015,
            contrast = 0.95,
            brightness = 0.95,
        },
    },

    group = {
        col = {
            border_active = group_border_active,
        },
        groupbar = {
            col = {
                active = group_bar_active,
            },
        },
    },
})
