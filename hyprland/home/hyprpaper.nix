{
  config,
  pkgs,
  wallpaper,
  ...
}:

let
  wallpaperString = toString wallpaper;
in
{
  home.file = {
    "Pictures/Wallpapers" = {
      source = wallpaper;
      recursive = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        wallpaperString
      ];
      wallpaper = [
        ",${wallpaperString}"
      ];
    };
  };
}