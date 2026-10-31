-- Environment Variables Configuration
local home = os.getenv("HOME")
local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. (os.getenv("UID") or "1000"))

local env_vars = {
    -- Current Version
    {"DOTS_VERSION", "2.3.20"},
    
    -- Default Editors
    {"EDITOR", "nvim"},
    {"VISUAL", "nvim"},
    
    -- Toolkit Backend
    {"GDK_BACKEND", "wayland,x11,*"},
    {"QT_QPA_PLATFORM", "wayland;xcb"},
    {"CLUTTER_BACKEND", "wayland"},
    
    -- XDG Specifications
    {"XDG_CURRENT_DESKTOP", "Hyprland"},
    {"XDG_SESSION_DESKTOP", "Hyprland"},
    {"XDG_SESSION_TYPE", "wayland"},
    
    -- Qt Styling
    {"QT_AUTO_SCREEN_SCALE_FACTOR", "1"},
    {"QT_WAYLAND_DISABLE_WINDOWDECORATION", "1"},
    {"QT_QPA_PLATFORMTHEME", "qt6ct"},
    {"QT_QUICK_CONTROLS_STYLE", "org.hyprland.style"},
    
    -- XWayland scaling fix
    {"GDK_SCALE", "1"},
    {"QT_SCALE_FACTOR", "1"},
    
    -- Cursors
    {"HYPRCURSOR_THEME", "Bibata-Modern-Ice"},
    {"HYPRCURSOR_SIZE", "24"},
    {"XCURSOR_THEME", "Bibata-Modern-Ice"},
    {"XCURSOR_SIZE", "24"},
    
    -- Web & Browsers
    {"MOZ_ENABLE_WAYLAND", "1"},
    {"BROWSER", "brave"},
    {"ELECTRON_OZONE_PLATFORM_HINT", "auto"},
    
    -- NVIDIA RTX 5060 Hardware Acceleration
    {"LIBVA_DRIVER_NAME", "nvidia"},
    {"__GLX_VENDOR_LIBRARY_NAME", "nvidia"},
    {"NVD_BACKEND", "direct"},
    {"GBM_BACKEND", "nvidia-drm"},
    {"__GL_GSYNC_ALLOWED", "1"},
    {"__GL_VRR_ALLOWED", "1"},
    {"GSK_RENDERER", "ngl"},
    {"EGL_PLATFORM", "wayland"},
    
    -- Portals & Debug
    {"GTK_USE_PORTAL", "1"},
    {"GDK_DEBUG", "portals"},
    {"PATH", home .. "/.local/bin:" .. os.getenv("PATH")},
    
    -- GNOME Keyring & Secret Service
    {"GNOME_KEYRING_CONTROL", runtime_dir .. "/keyring"},
    {"SSH_AUTH_SOCK", runtime_dir .. "/keyring/ssh"},
}

for _, e in ipairs(env_vars) do
    hl.env(e[1], e[2])
end
