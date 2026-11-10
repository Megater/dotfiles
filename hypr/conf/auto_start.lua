-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
  hl.exec_cmd("hyprlock")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("~/.config/eww/launch.sh")
  hl.exec_cmd("nm-applet & blueman-applet")
  hl.exec_cmd("spotify --minimized")
  hl.exec_cmd("waybar")



end)
