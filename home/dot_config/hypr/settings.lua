-- Global Settings & Hardware Profiles
hl.config({
    general = {
        resize_on_border = true,
        extend_border_grab_area = 20,
        hover_icon_on_border = true,
        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.8,
    },

    master = {
        new_status = "master",
        new_on_top = 1,
        mfact = 0.5,
    },

    input = {
        kb_layout = "us,br,us",
        kb_variant = "intl,,",
        kb_options = "grp:alt_shift_toggle,caps:swapescape",
        repeat_rate = 50,
        repeat_delay = 300,
        follow_mouse = 1,
        float_switch_override_focus = 2,
        mouse_refocus = true,
        sensitivity = 0,
        natural_scroll = false,
        scroll_factor = 1.0,
        numlock_by_default = true,
        left_handed = false,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
        },

        touchdevice = {
            enabled = true,
        },

        tablet = {
            transform = 0,
            left_handed = 0,
        },
    },

    gestures = {
        workspace_swipe_distance = 500,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        swallow_regex = "^(kitty|ghostty|alacritty)$",
        focus_on_activate = true,
        middle_click_paste = false,
        initial_workspace_tracking = 0,
        enable_anr_dialog = true,
        anr_missed_pings = 15,
        allow_session_lock_restore = true,
        on_focus_under_fullscreen = 1,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },

    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = 0,
        new_render_scheduling = true,
    },

    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = true,
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = false,
        inactive_timeout = 0,
    },
})

-- Gestos do Touchpad
local home = os.getenv("HOME")
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.gesture({
    fingers = 3,
    direction = "up",
    action = {
        finish = function()
            hl.dispatch(hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/OverviewToggle.sh"))
        end
    }
})

hl.gesture({
    fingers = 4,
    direction = "up",
    action = "cursor_zoom"
})

hl.gesture({
    fingers = 4,
    direction = "down",
    action = "cursor_zoom"
})

-- Hardware Profiles (Teclados Bluetooth, Fones AVRCP & Touchpads)
hl.device({
    name = "logitech-k380s-keyboard",
    kb_layout = "us,br,us",
    kb_variant = "intl,,",
    kb_options = "grp:alt_shift_toggle,caps:swapescape",
})

hl.device({
    name = "k380-keyboard",
    kb_layout = "us,br,us",
    kb_variant = "intl,,",
    kb_options = "grp:alt_shift_toggle,caps:swapescape",
})

hl.device({
    name = "qcy-h3s-(avrcp)",
    enabled = false,
})

hl.device({
    name = "qcy-melobuds-anc-(avrcp)",
    enabled = false,
})

hl.device({
    name = "tpps/2-ibm-trackpoint",
    sensitivity = 0.25,
    accel_profile = "adaptive",
    natural_scroll = false,
})

hl.device({
    name = "synps/2-synaptics-touchpad",
    sensitivity = 0.15,
    accel_profile = "adaptive",
    natural_scroll = true,
    tap_to_click = true,
    disable_while_typing = true,
})
