--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name   = "kitty-floating",
    match  = { class = "^(kitty-float)$" },

    float  = true,
    size   = "1000 650",
    center = true,
})

-- Reguła dla miksera dźwięku Pavucontrol
hl.window_rule({
    name   = "float-pavucontrol",
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },

    float  = true,
    size   = "700 500",
    center = true,
})

hl.window_rule({
    name   = "float-blueman",
    match  = { class = "^(blueman-manager)$" },
    float  = true,
    size   = "700 500",
    center = true,
})

hl.window_rule({
    name   = "float-nm-connection-editor",
    match  = { class = "^(nm-connection-editor)$" },
    float = true,
    size = "700 500",
    center = true,

})

hl.window_rule({
    name = "float-spotify",
    match = { class = "^(Spotify)$" },
    float = true,
    size = "1000 650",
    center = true,
})

hl.window_rule({
    name = "float-calendar",
    match = { class = "^(org.gnome.Calendar)$" },
    float = true,
    size = "1250 924",
    center = true,
})

hl.window_rule({
    name = "float-loupe",
    match = { class = "^(org.gnome.Loupe)$" },
    float = true,
    size = "1250 924",
    center = true,
})

hl.window_rule({
    name = "float-loupe",
    match = { class = "^(org.gnome.Nautilus)$" },
    float = true,
    size = "1124 924",
    center = true,
})

hl.window_rule({
    name = "float-calculator",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    size = "400 350",
    center = true,
})



