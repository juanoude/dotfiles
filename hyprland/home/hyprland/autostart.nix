{currentMonitorConfig, ...}: {
  wayland.windowManager.hyprland.settings = {
    monitor = currentMonitorConfig.monitors;

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
