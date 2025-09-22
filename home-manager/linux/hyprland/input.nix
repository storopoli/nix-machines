{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      repeat_delay = 200;
      repeat_rate = 30;

      follow_mouse = 1;

      numlock_by_default = true;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        clickfinger_behavior = true;
        middle_button_emulation = false;
        "tap-to-click" = false;
        drag_lock = false;
      };
    };
  };
}
