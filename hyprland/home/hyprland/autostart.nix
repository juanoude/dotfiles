{...}: {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 2880x1800@60, 0x0, 1"
    ];

    xwayland = {
      force_zero_scaling = true;
    };

    # Don't show update on first launch
    ecosystem = {
      no_update_news = true;
    };

    exec-once = [
      "hyprsunset"
      "systemctl --user start hyprpolkitagent"
      "wl-clip-persist --clipboard regular & clipse -listen"
    ];

    exec = [
      "pkill -SIGUSR2 waybar || waybar"
    ];
  };
}
