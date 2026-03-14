{
  config,
  pkgs,
  theme,
  font,
  ...
}:
let
  palette = theme.palette;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window settings
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.95;
      window-decoration = "none";

      font-family = font;
      font-size = 12;

      theme = "omarchy";
      keybind = [
        "ctrl+k=reset"
      ];
    };
    themes = {
      omarchy = {
        background = "#${theme.background}";
        foreground = "#${theme.foreground}";

        selection-background = "#${theme.selection-background}";
        selection-foreground = "#${theme.selection-foreground}";
        palette = [
          "0=#${palette.base00}"
          "1=#${palette.base01}"
          "2=#${palette.base02}"
          "3=#${palette.base03}"
          "4=#${palette.base04}"
          "5=#${palette.base05}"
          "6=#${palette.base06}"
          "7=#${palette.base07}"
          "8=#${palette.base08}"
          "9=#${palette.base09}"
          "10=#${palette.base0A}"
          "11=#${palette.base0B}"
          "12=#${palette.base0C}"
          "13=#${palette.base0D}"
          "14=#${palette.base0E}"
          "15=#${palette.base0F}"
        ];
      };
    };
  };
}
