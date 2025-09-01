{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      "suppressevent maximize, class:.*"

      # Browser types
      "tag +chromium-based-browser, class:([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, class:(Firefox|zen|librewolf)"

      # Just dash of transparency
      "opacity 0.97 0.9, class:.*"

      # Force chromium-based browsers into a tile to deal with --app bug
      "tile, tag:chromium-based-browser"

      # Only a subtle opacity change, but not for video sites
      "opacity 0.97 0.9, tag:chromium-based-browser"
      "opacity 0.97 0.9, tag:firefox-based-browser"

      # Some video sites should never have opacity applied to them
      "opacity 1.0 1.0, initialTitle:(youtube\.com_/|app\.zoom\.us_/wc/home)"

      # Settings management
      "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"

      # Clipboard manager
      "float, class:clipse"

      # Float Steam, fullscreen RetroArch
      "float, class:steam"
      "center, class:steam, title:Steam"
      "opacity 1 1, class:steam"
      "size 1100 700, class:steam, title:Steam"
      "size 460 800, class:steam, title:Friends List"
      "idleinhibit fullscreen, class:steam"
      "fullscreen, class:^(com.libretro.RetroArch)$"

      # Fullscreen screensaver
      "fullscreen, class:Screensaver"

      # OBS and Steam no transparency
      "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
      "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Float in the middle for clipse clipboard manager
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
      "stayfocused, class:(clipse)"
    ];

    layerrule = [
      # Proper background blur for wofi
      "blur, wofi"
      "blur, waybar"

      # Remove 1px border around hyprshot screenshots
      "noanim, selection"
    ];
  };
}
