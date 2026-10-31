-- Workspaces mapping
-- HDMI-A-1 no Workspace 1 e DP-1 com Workspaces 2 a 10

hl.workspace_rule({
    workspace = "1",
    monitor = "HDMI-A-1",
    default = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "DP-1",
    default = true,
})

for i = 3, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-1",
    })
end
