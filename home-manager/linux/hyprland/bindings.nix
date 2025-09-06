{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindd = [
      # Application shortcuts
      "SUPER, return, Terminal, exec, $terminal"
      "SUPER, E, File manager, exec, $fileManager"
      # "SUPER, B, Web browser, exec, $browser"
      "SUPER, B, Web browser (Personal), exec, $browser --profile-directory='Default'"
      "SUPER SHIFT, B, Web browser (Work), exec, $browser --profile-directory='Profile 1'"
      "SUPER, M, Music app, exec, $music"
      "SUPER, N, Editor, exec, $terminal -e $editor"
      "SUPER, I, Task manager, exec, $terminal -e btop"
      "SUPER, D, Lazydocker, exec, $terminal -e lazydocker"
      "SUPER, G, Signal, exec, $messenger"
      "SUPER, space, Open apps, exec, wofi --show drun --sort-order=alphabetical"
      "SUPER SHIFT, SPACE, toggle top bar, exec, pkill -SIGUSR1 waybar"
      "SUPER, W, Close active window, killactive,"
      "SUPER, Backspace, Close active window, killactive,"

      "SUPER,  A, Grok, exec, $webapp=https://grok.com/"
      "SUPER SHIFT, A, ChatGPT, exec, $webapp=https://chatgpt.com/"
      "SUPER, Y, Youtube, exec, $webapp=https://youtube.com/"
      "SUPER SHIFT, G, Whatsapp, exec, $webapp=https://web.whatsapp.com/"
      "SUPER, X, X.com, exec, $webapp=https://x.com/"
      "SUPER SHIFT, X, X.com (Post), exec, $webapp=https://x.com/compose/post"

      # End active session
      "SUPER, ESCAPE, Lock the screen, exec, hyprlock"
      "SUPER SHIFT, ESCAPE, Logout, exit,"
      "SUPER CTRL, ESCAPE, Reboot, exec, reboot"
      "SUPER SHIFT CTRL, ESCAPE, Shutdown, exec, systemctl poweroff"
      "SUPER, F1, Show keybindings, exec, ~/.local/bin/show-keybindings"

      # Layouts
      "SUPER, T, Toggle split, togglesplit"
      "SUPER, P, Pseudo window, pseudo"
      "SUPER, V, Toggle floating, togglefloating"
      "SUPER, U, Toggle group, togglegroup"
      "SUPER, F, Toggle fullscreen, fullscreen"

      # Super workspace floating layer
      "SUPER, S, Toggle scratchpad, togglespecialworkspace, magic"
      "SUPER SHIFT, S, Move scratchpad, movetoworkspace, special:magic"

      # Move focus
      "SUPER, left, Move focus left, movefocus, l"
      "SUPER, right, Move focus right, movefocus, r"
      "SUPER, up, Move focus up, movefocus, u"
      "SUPER, down, Move focus down, movefocus, d"
      "SUPER, H, Move focus left, movefocus, l"
      "SUPER, L, Move focus right, movefocus, r"
      "SUPER, J, Move focus up, movefocus, u"
      "SUPER, K, Move focus down, movefocus, d"

      # Workspace switching
      "SUPER, 1, Switch to workspace 1, workspace, 1"
      "SUPER, 2, Switch to workspace 2, workspace, 2"
      "SUPER, 3, Switch to workspace 3, workspace, 3"
      "SUPER, 4, Switch to workspace 4, workspace, 4"
      "SUPER, 5, Switch to workspace 5, workspace, 5"
      "SUPER, 6, Switch to workspace 6, workspace, 6"
      "SUPER, 7, Switch to workspace 7, workspace, 7"
      "SUPER, 8, Switch to workspace 8, workspace, 8"
      "SUPER, 9, Switch to workspace 9, workspace, 9"
      "SUPER, 0, Switch to workspace 10, workspace, 10"
      "SUPER, comma, Switch to previous workspace, workspace, -1"
      "SUPER, period, Switch to next workspace, workspace, +1"

      # Move active window to workspace
      "SUPER SHIFT, 1, Move window to workspace 1, movetoworkspacesilent, 1"
      "SUPER SHIFT, 2, Move window to workspace 2, movetoworkspacesilent, 2"
      "SUPER SHIFT, 3, Move window to workspace 3, movetoworkspacesilent, 3"
      "SUPER SHIFT, 4, Move window to workspace 4, movetoworkspacesilent, 4"
      "SUPER SHIFT, 5, Move window to workspace 5, movetoworkspacesilent, 5"
      "SUPER SHIFT, 6, Move window to workspace 6, movetoworkspacesilent, 6"
      "SUPER SHIFT, 7, Move window to workspace 7, movetoworkspacesilent, 7"
      "SUPER SHIFT, 8, Move window to workspace 8, movetoworkspacesilent, 8"
      "SUPER SHIFT, 9, Move window to workspace 9, movetoworkspacesilent, 9"
      "SUPER SHIFT, 0, Move window to workspace 10, movetoworkspacesilent, 10"

      # move window in current workspace
      "SUPER SHIFT, H, Swap window to the left, movewindow, l"
      "SUPER SHIFT, L, Swap window to the right, movewindow, r"
      "SUPER SHIFT, J, Swap window to up, movewindow, u"
      "SUPER SHIFT, K, Swap window to down, movewindow, d"

      # Scroll through existing workspaces with SUPER + scroll
      "SUPER, mouse_down, Scroll active workspace forward, workspace, e+1"
      "SUPER, mouse_up, Scroll active workspace backward, workspace, e-1"

      # Tab between workspaces
      "SUPER, TAB, Next workspace, workspace, e+1"
      "SUPER SHIFT, TAB, Previous workspace, workspace, e-1"

      # Cycle through applications on active workspace
      "ALT, Tab, Cycle to next window, cyclenext"
      "ALT SHIFT, Tab, Cycle to prev window, cyclenext, prev"
      "ALT, Tab, Reveal active window on top, bringactivetotop"
      "ALT SHIFT, Tab, Reveal active window on top, bringactivetotop"

      # Resize active window
      "SUPER, minus, Expand window left, resizeactive, -100 0"
      "SUPER, equal, Shrink window right, resizeactive, 100 0"
      "SUPER SHIFT, minus, Shrink window up, resizeactive, 0 -100"
      "SUPER SHIFT, equal, Expand window down, resizeactive, 0 100"

      # Screenshots
      ", PRINT, Screenshot of region, exec, hyprshot -m region --clipboard-only"
      "SHIFT, PRINT, Screenshot of window, exec, hyprshot -m window --clipboard-only"
      "CTRL, PRINT, Screenshot of display, exec, hyprshot -m output --clipboard-only"

      # Color picker
      "SUPER, PRINT, Color picker, exec, hyprpicker -a"

      # Clipse
      "CTRL SUPER, V, Clipboard manager, exec, $terminal --class=clipse -e clipse"
    ];

    bindmd = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "SUPER, mouse:272, Move window, movewindow"
      "SUPER, mouse:273, Resize window, resizewindow"
    ];

    bindeld = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, Volume up, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, Volume down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, Mute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, Mute microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, Brightness up, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, Brightness down, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindld = [
      # Requires playerctl
      ", XF86AudioNext, Next track, exec, playerctl next"
      ", XF86AudioPrev, Previous track, exec, playerctl previous"
      ", XF86AudioPause, Pause, exec, playerctl play-pause"
      ", XF86AudioPlay, Play, exec, playerctl play-pause"
    ];
  };
}
