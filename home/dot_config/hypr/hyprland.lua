-- ==============================================================================
-- 🚀 HYPRLAND NATIVE LUA CONFIGURATION (v0.57+)
-- Base Soberana de Dotfiles do Usuário (TCE-GO 2026)
-- ==============================================================================

local home = os.getenv("HOME")
package.path = home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua;" .. package.path

-- 1. Variáveis de Ambiente & Toolkits (Wayland, NVIDIA, Electron, Temas)
require("env")

-- 2. Monitores & Workspaces (Resoluções, Taxas de Atualização & Telas)
pcall(require, "monitors")
require("workspaces")

-- 3. Configurações Globais & Hardware (Input, Dwindle, Master, Cursor, Render, Dispositivos)
require("settings")

-- 4. Estética & Decorações (Bordas, Glassmorphism, Sombras, Cores Dinâmicas Wallust)
require("decorations")

-- 5. Animações Líquidas (Curvas Bezier & Física Orgânica macOS Sequoia)
require("animations")

-- 6. Regras de Janelas & Camadas (Tags, Flutuantes, Scratchpads, Gamescope, Blur)
require("rules")

-- 7. Catálogo Completo de Atalhos & Submaps (Teclado, Mouse & Redimensionamento)
require("keybinds")

-- 8. Autostart & Inicialização de Serviços (Barra, Notificações, Áudio, Daemons)
require("autostart")
