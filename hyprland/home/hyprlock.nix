{
  pkgs,
  theme,
  nix-colors,
  wallpaper,
  currentTheme,
  ...
}:
let
  palette = theme.palette;
  convert = nix-colors.lib.conversions.hexToRGBString;

  hasThemeConf = (currentTheme.hyprlockConf or "") != "";

  # Fallback colors computed from palette
  backgroundRgb = "rgba(${convert ", " palette.base00}, 0.8)";
  surfaceRgb = "rgb(${convert ", " palette.base02})";
  foregroundRgb = "rgb(${convert ", " palette.base05})";
  foregroundMutedRgb = "rgb(${convert ", " palette.base04})";

  # When theme provides hyprlock.conf, use variable references
  inner_color = if hasThemeConf then "$inner_color" else surfaceRgb;
  outer_color = if hasThemeConf then "$outer_color" else foregroundRgb;
  font_color = if hasThemeConf then "$font_color" else foregroundRgb;
  placeholder_color = if hasThemeConf then "$font_color" else foregroundMutedRgb;
  check_color = if hasThemeConf then "$check_color" else "rgba(131, 192, 146, 1.0)";
in
{
  xdg.configFile."hypr/hyprlock-theme.conf" = {
    enable = hasThemeConf;
    text = currentTheme.hyprlockConf or "";
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      source = if hasThemeConf then [ "~/.config/hypr/hyprlock-theme.conf" ] else [];

      general = {
        disable_loading_bar = true;
        no_fade_in = false;
      };
      auth = {
        fingerprint.enabled = true;
      };
      background = {
        monitor = "";
        path = toString wallpaper;
        # blur_passes = 3;
        # brightness = 0.5;
      };

      input-field = {
        monitor = "";
        size = "600, 100";
        position = "0, 0";
        halign = "center";
        valign = "center";

        inherit inner_color outer_color font_color placeholder_color check_color;
        outline_thickness = 4;

        font_family = "CaskaydiaMono Nerd Font";
        font_size = 32;

        placeholder_text = "  Enter Password 󰈷 ";
        fail_text = "Wrong";

        rounding = 0;
        shadow_passes = 0;
        fade_on_empty = false;
      };

      label = {
        monitor = "";
        text = "\$FPRINTPROMPT";
        text_align = "center";
        color = if hasThemeConf then "$font_color" else "rgb(211, 198, 170)";
        font_size = 24;
        font_family = "CaskaydiaMono Nerd Font";
        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };
}
