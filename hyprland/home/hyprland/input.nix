{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = lib.mkDefault {
      kb_layout = "br";
      kb_variant = "abnt2";

      kb_options = "compose:caps";

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = true;
      };
    };
  };
}
