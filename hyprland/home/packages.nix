{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Suppose it's necessary - present on installation tutorial
    atool
    httpie

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    noto-fonts-color-emoji   

    # Hyprland essentials
    hyprpolkitagent
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    gnome-themes-extra
    pavucontrol

    # TUIs
    lazygit
    lazydocker
    btop
    powertop
    fastfetch

    # GUIs
    obsidian
    vlc
    typora
    spotify

    # Development tools
    # github-desktop
    # gh

    # Containers
    docker-compose
    ffmpeg
  ];
}
