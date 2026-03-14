{pkgs, ...}: {
  imports = [
    ./bindings.nix
    ./env.nix
    ./input.nix
    ./appearance.nix
    ./rules.nix
    ./autostart.nix
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true;
}
