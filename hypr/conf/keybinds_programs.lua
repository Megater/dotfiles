---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal       = "kitty"
local fileManager    = "nautilus"
local menu           = "/home/mateusz/.config/rofi/launchers/type-3/launcher.sh"
local windowSwitcher = "/home/mateusz/.config/rofi/window.sh"
local browser        = "firefox"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Klawisz Windows

-- Podstawowe aplikacje
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/eww/launch.sh"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/.config/waybar/reload.sh"))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + End", hl.dsp.exec_cmd("/home/mateusz/.config/rofi/powermenu/type-2/powermenu.sh"))

-- Przełączanie aktywnego okna na pełny ekran
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Focus w oknach (strzałki)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

---------------------------------
---- WORKSPACE RULES (MONITORS) -
---------------------------------

-- Monitor DP-3 (dół / główny): Pulpity 1 do 10
for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-3",
        default = (i == 1),
    })
end

-- Monitor HDMI-A-1 (góra / pomocniczy): Pulpity 11 do 20
for i = 11, 20 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-1",
        default = (i == 11),
    })
end




---------------------------------
---- WORKSPACE BINDS ------------
---------------------------------

for i = 1, 10 do
    local idx = i
    local key = idx % 10

    hl.bind(mainMod .. " + " .. key, function()
        local mon = hl.get_active_monitor()
        local mon_name = (mon and mon.name) or "DP-3"
        local target = (mon_name == "HDMI-A-1") and (idx + 10) or idx

        hl.dispatch(hl.dsp.focus({ workspace = target }))
    end)

    hl.bind(mainMod .. " + SHIFT + " .. key, function()
        local mon = hl.get_active_monitor()
        local mon_name = (mon and mon.name) or "DP-3"
        local target = (mon_name == "HDMI-A-1") and (idx + 10) or idx

        hl.dispatch(hl.dsp.window.move({ workspace = target }))
    end)
end

---------------------------------
---- MOVE WINDOWS / FOCUS -------
---------------------------------

-- Przerzucanie aktywnego okna między monitorami (góra / dół)
hl.bind(mainMod .. " + ALT + up",   hl.dsp.window.move({ monitor = "HDMI-A-1" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ monitor = "DP-3" }))

-- Przełączanie fokusu między monitorami (DP-3 <-> HDMI-A-1) pod Super + Tab
hl.bind(mainMod .. " + tab", function()
    local mon = hl.get_active_monitor()
    local mon_name = (mon and mon.name) or "DP-3"
    local target_mon = (mon_name == "DP-3") and "HDMI-A-1" or "DP-3"

    hl.dispatch(hl.dsp.focus({ monitor = target_mon }))
end)

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------------------
---- AUDIO & BRIGHTNESS OSD -----
---------------------------------

local function volume_osd(wpctl_cmd)
    local cmd = wpctl_cmd
        .. [[ && out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)]]
        .. [[ && vol=$(echo "$out" | awk '{print int($2*100)}')]]
        .. [[ && if echo "$out" | grep -q "MUTED"; then]]
        .. [[ body="<span size='150%' foreground='#606774'>󰝟   ${vol}%</span>";]]
        .. [[ else]]
        .. [[ if [ "$vol" -ge 70 ]; then icon="󰕾"; elif [ "$vol" -ge 35 ]; then icon="󰖀"; elif [ "$vol" -gt 0 ]; then icon="󰕿"; else icon="󰝟"; fi;]]
        .. [[ body="<span size='150%'>${icon}   ${vol}%</span>";]]
        .. [[ fi]]
        .. [[ && notify-send -a "OSD" -h string:x-canonical-private-synchronous:vol-osd -t 800 "" "$body"]]

    return hl.dsp.exec_cmd(cmd)
end

local function mic_osd()
    local cmd = [[wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle]]
        .. [[ && out=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)]]
        .. [[ && if echo "$out" | grep -q "MUTED"; then]]
        .. [[ body="<span size='150%' foreground='#bf616a'>󰍭   Wyciszony</span>";]]
        .. [[ else]]
        .. [[ body="<span size='150%'>󰍬   Aktywny</span>";]]
        .. [[ fi]]
        .. [[ && notify-send -a "OSD" -h string:x-canonical-private-synchronous:vol-osd -t 800 "" "$body"]]

    return hl.dsp.exec_cmd(cmd)
end

-- Klawisze głośności i mikrofonu
hl.bind(mainMod .. " + equal",         volume_osd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + minus",         volume_osd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", volume_osd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind(mainMod .. " + SHIFT + minus", mic_osd(),                                                    { locked = true })