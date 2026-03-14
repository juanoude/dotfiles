{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./vscode.nix
    ./hyprland
    ./waybar.nix
    ./ghostty.nix
    ./zsh.nix
    ./zoxide.nix
    ./wofi.nix
    ./mako.nix
    ./neovim.nix
    ./starship.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./fonts.nix
    ./direnv.nix
    ./vivaldi.nix
    ./yazi.nix
  ];

  home.stateVersion = "25.11";
}
