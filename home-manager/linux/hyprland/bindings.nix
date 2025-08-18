{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Key bindings
    "$mainMod" = "SUPER";

    bind = [
      # Application shortcuts
      "$mainMod, return, exec, $terminal"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, B, exec, $browser"
      "$mainMod, M, exec, $music"
      "$mainMod, N, exec, $terminal -e nvim"
      "$mainMod, T, exec, $terminal -e btop"
      "$mainMod, D, exec, $terminal -e lazydocker"
      "$mainMod, G, exec, $messenger"
      "$mainMod, space, exec, wofi --show drun --sort-order=alphabetical"
      "$mainMod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"
      "$mainMod, W, killactive,"
      "$mainMod, Backspace, killactive,"

      "$mainMod  A, exec, $webapp=https://grok.com"
      "$mainMod  SHIFT A, exec, $webapp=https://chatgpt.com"
      "$mainMod, Y, exec, $webapp=https://youtube.com/"
      "$mainMod SHIFT, G, exec, $webapp=https://web.whatsapp.com/"
      "$mainMod, X, exec, $webapp=https://x.com/"
      "$mainMod SHIFT, X, exec, $webapp=https://x.com/compose/post"

      # End active session
      "$mainMod, ESCAPE, exec, hyprlock"
      "$mainMod SHIFT, ESCAPE, exit,"
      "$mainMod CTRL, ESCAPE, exec, reboot"
      "$mainMod SHIFT CTRL, ESCAPE, exec, systemctl poweroff"
      "$mainMod, F1, exec, ~/.local/bin/show-keybindings"

      # Layouts
      "$mainMod, T, togglesplit, # dwindle"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, V, togglefloating,"
      "$mainMod, U, togglegroup,"
      "$mainMod, Tab, changegroupactive, f"
      "$mainMod, F, fullscreen,"

      # Super workspace floating layer
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Move focus
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, J, movefocus, u"
      "$mainMod, K, movefocus, d"

      # Workspace switching
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, comma, workspace, -1"
      "$mainMod, period, workspace, +1"

      # Move active window to workspace
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

      # move window in current workspace
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, J, movewindow, u"
      "$mainMod SHIFT, K, movewindow, d"

      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

      # Resize active window
      "$mainMod, minus, resizeactive, -100 0"
      "$mainMod, equal, resizeactive, 100 0"
      "$mainMod SHIFT, minus, resizeactive, 0 -100"
      "$mainMod SHIFT, equal, resizeactive, 0 100"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Screenshots
      ", PRINT, exec, hyprshot -m region"
      "SHIFT, PRINT, exec, hyprshot -m window"
      "CTRL, PRINT, exec, hyprshot -m output"

      # Color picker
      "SUPER, PRINT, exec, hyprpicker -a"

      # Clipse (bluetooth)
      "CTRL SUPER, V, exec, $terminal --class clipse -e clipse"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
