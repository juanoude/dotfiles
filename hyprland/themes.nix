{ nix-colors }:

let
  mkTheme = { colorScheme, vscode, nvim, wallpaper }: {
    inherit vscode nvim wallpaper;
    colorScheme = nix-colors.colorSchemes.${colorScheme};
  };

  mkCustomTheme = { colorScheme, vscode, nvim, wallpaper }: {
    inherit vscode nvim wallpaper;
    colorScheme = import ./colorschemes/${colorScheme}.nix;
  };

  # Read file if it exists, otherwise return empty string
  readIfExists = path:
    if builtins.pathExists path
    then builtins.readFile path
    else "";

  # Strip leading # from hex colors
  stripHash = color:
    if builtins.substring 0 1 color == "#"
    then builtins.substring 1 (-1) color
    else color;

  # Convert alacritty.toml to colorScheme
  alacrittyToColorScheme = { tomlPath, slug, name, author ? "unknown" }:
    let
      toml = builtins.fromTOML (builtins.readFile tomlPath);
      colors = toml.colors;
      primary = colors.primary;
      normal = colors.normal;
      bright = colors.bright;
      cursor = colors.cursor or {};
      selection = colors.selection or {};
      accent = colors.accent or normal.magenta;
    in {
      inherit slug name author;
      accent = stripHash accent;
      background = stripHash primary.background;
      foreground = stripHash primary.foreground;
      cursor-color = stripHash (cursor.cursor or primary.foreground);
      cursor-text = stripHash (cursor.text or primary.background);
      selection-foreground = stripHash (
        if selection.text or "" == "CellForeground"
        then primary.foreground
        else selection.text or primary.foreground
      );
      selection-background = stripHash (selection.background or "#44475a");
      palette = {
        base00 = stripHash normal.black;
        base01 = stripHash normal.red;
        base02 = stripHash normal.green;
        base03 = stripHash normal.yellow;
        base04 = stripHash normal.blue;
        base05 = stripHash normal.magenta;
        base06 = stripHash normal.cyan;
        base07 = stripHash normal.white;
        base08 = stripHash bright.black;
        base09 = stripHash bright.red;
        base0A = stripHash bright.green;
        base0B = stripHash bright.yellow;
        base0C = stripHash bright.blue;
        base0D = stripHash bright.magenta;
        base0E = stripHash bright.cyan;
        base0F = stripHash bright.white;
      };
    };

  # Convert colors.toml to colorScheme
  colorsTomlToColorScheme = { tomlPath, slug, name, author ? "unknown" }:
    let
      toml = builtins.fromTOML (builtins.readFile tomlPath);
    in {
      inherit slug name author;
      accent = stripHash (toml.accent or toml.color5);
      background = stripHash toml.background;
      foreground = stripHash toml.foreground;
      cursor-color = stripHash toml.cursor;
      cursor-text = stripHash toml.background;
      selection-foreground = stripHash toml.selection_foreground;
      selection-background = stripHash toml.selection_background;
      palette = {
        base00 = stripHash toml.color0;
        base01 = stripHash toml.color1;
        base02 = stripHash toml.color2;
        base03 = stripHash toml.color3;
        base04 = stripHash toml.color4;
        base05 = stripHash toml.color5;
        base06 = stripHash toml.color6;
        base07 = stripHash toml.color7;
        base08 = stripHash toml.color8;
        base09 = stripHash toml.color9;
        base0A = stripHash toml.color10;
        base0B = stripHash toml.color11;
        base0C = stripHash toml.color12;
        base0D = stripHash toml.color13;
        base0E = stripHash toml.color14;
        base0F = stripHash toml.color15;
      };
    };

  # Convert ghostty.conf to colorScheme
  ghosttyToColorScheme = { confPath, slug, name, author ? "unknown", accent ? null }:
    let
      content = builtins.readFile confPath;
      lines = builtins.filter (l: l != "") (builtins.split "\n" content);
      # Filter out non-string elements (split returns a mix of strings and lists)
      stringLines = builtins.filter builtins.isString lines;
      # Check if line is a comment (starts with # after optional whitespace)
      isComment = line: builtins.match "[[:space:]]*#.*" line != null;
      # Parse "key = value" lines
      parseLine = line:
        let
          parts = builtins.match "[[:space:]]*([a-zA-Z0-9_-]+)[[:space:]]*=[[:space:]]*(.*)" line;
        in
          if isComment line then null
          else if parts == null then null
          else { name = builtins.elemAt parts 0; value = builtins.elemAt parts 1; };
      parsed = builtins.filter (x: x != null) (map parseLine stringLines);
      # Convert to attrset, handling palette entries specially
      toAttrs = builtins.foldl' (acc: entry:
        if entry.name == "palette" then
          let
            paletteParts = builtins.match "([0-9]+)=(.*)" entry.value;
          in
            if paletteParts == null then acc
            else acc // { "palette${builtins.elemAt paletteParts 0}" = builtins.elemAt paletteParts 1; }
        else
          acc // { ${entry.name} = entry.value; }
      ) {} parsed;
      cfg = toAttrs;
    in {
      inherit slug name author;
      accent = stripHash (if accent != null then accent else cfg.palette5 or cfg.foreground);
      background = stripHash cfg.background;
      foreground = stripHash cfg.foreground;
      cursor-color = stripHash (cfg.cursor-color or cfg.foreground);
      cursor-text = stripHash (cfg.cursor-text or cfg.background);
      selection-foreground = stripHash (cfg.selection-foreground or cfg.background);
      selection-background = stripHash (cfg.selection-background or cfg.foreground);
      palette = {
        base00 = stripHash cfg.palette0;
        base01 = stripHash cfg.palette1;
        base02 = stripHash cfg.palette2;
        base03 = stripHash cfg.palette3;
        base04 = stripHash cfg.palette4;
        base05 = stripHash cfg.palette5;
        base06 = stripHash cfg.palette6;
        base07 = stripHash cfg.palette7;
        base08 = stripHash cfg.palette8;
        base09 = stripHash cfg.palette9;
        base0A = stripHash cfg.palette10;
        base0B = stripHash cfg.palette11;
        base0C = stripHash cfg.palette12;
        base0D = stripHash cfg.palette13;
        base0E = stripHash cfg.palette14;
        base0F = stripHash cfg.palette15;
      };
    };

  # Helper to get all image files from a directory
  getWallpapers = dir:
    let
      files = builtins.readDir dir;
      imageExtensions = [ "png" "jpg" "jpeg" "webp" ];
      isImage = name: builtins.any (ext: builtins.match ".*\\.${ext}$" name != null) imageExtensions;
      imageFiles = builtins.filter isImage (builtins.attrNames files);
    in
      map (name: dir + "/${name}") imageFiles;

  # Pick a random wallpaper based on seed file generated at apply time
  pickWallpaper = wallpapers:
    let
      count = builtins.length wallpapers;
      seedFile = /tmp/nix-wallpaper-seed;
      seed = if builtins.pathExists seedFile
             then builtins.fromJSON (builtins.replaceStrings ["\n"] [""] (builtins.readFile seedFile))
             else 0;
      index = seed - (seed / count) * count;
    in
      builtins.elemAt wallpapers index;

in
{
  futurism = {
    vscode = "Winter is Coming (Dark Blue)";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/futurism/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/futurism/colors.toml;
      slug = "futurism";
      name = "Futurism";
      author = "bjarneo";
    };
    neovimConf = readIfExists ./colorschemes/futurism/neovim.lua;
    btopConf = readIfExists ./colorschemes/futurism/btop.theme;
  };

  aetheria = {
    vscode = "Celestial Echoes";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/aetheria/backgrounds);
    colorScheme = ghosttyToColorScheme {
      confPath = ./colorschemes/aetheria/ghostty.conf;
      slug = "aetheria";
      name = "Aetheria";
      author = "JJDizz1L";
      accent = "#BE3F50";
    };
    hyprlandConf = readIfExists ./colorschemes/aetheria/hyprland.conf;
    hyprlockConf = readIfExists ./colorschemes/aetheria/hyprlock.conf;
    makoConf = readIfExists ./colorschemes/aetheria/mako.ini;
    neovimConf = readIfExists ./colorschemes/aetheria/neovim.lua;
    btopConf = readIfExists ./colorschemes/aetheria/btop.theme;
  };

  dracula = {
    vscode = "Dracula Theme";
    nvim = "dracula";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/dracula/backgrounds);
    colorScheme = alacrittyToColorScheme {
      tomlPath = ./colorschemes/dracula/alacritty.toml;
      slug = "dracula";
      name = "Dracula";
      author = "Dracula Theme";
    };
    hyprlandConf = readIfExists ./colorschemes/dracula/hyprland.conf;
    hyprlockConf = readIfExists ./colorschemes/dracula/hyprlock.conf;
    makoConf = readIfExists ./colorschemes/dracula/mako.ini;
    neovimConf = readIfExists ./colorschemes/dracula/neovim.lua;
    btopConf = readIfExists ./colorschemes/dracula/btop.theme;
  };

  catppuccin = {
    vscode = "Catppuccin Mocha";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/catppuccin/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/catppuccin/colors.toml;
      slug = "catppuccin";
      name = "Catppuccin Mocha";
      author = "Catppuccin";
    };
    neovimConf = readIfExists ./colorschemes/catppuccin/neovim.lua;
    btopConf = readIfExists ./colorschemes/catppuccin/btop.theme;
  };

  ethereal = {
    vscode = "Ethereal";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/ethereal/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/ethereal/colors.toml;
      slug = "ethereal";
      name = "Ethereal";
      author = "Bjarne";
    };
    neovimConf = readIfExists ./colorschemes/ethereal/neovim.lua;
    btopConf = readIfExists ./colorschemes/ethereal/btop.theme;
  };

  everforest = {
    vscode = "Everforest Dark";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/everforest/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/everforest/colors.toml;
      slug = "everforest";
      name = "Everforest";
      author = "sainnhe";
    };
    neovimConf = readIfExists ./colorschemes/everforest/neovim.lua;
    btopConf = readIfExists ./colorschemes/everforest/btop.theme;
  };

  gruvbox = {
    vscode = "Gruvbox Dark Medium";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/gruvbox/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/gruvbox/colors.toml;
      slug = "gruvbox";
      name = "Gruvbox Dark Medium";
      author = "morhetz";
    };
    neovimConf = readIfExists ./colorschemes/gruvbox/neovim.lua;
    btopConf = readIfExists ./colorschemes/gruvbox/btop.theme;
  };

  hackerman = {
    vscode = "Hackerman";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/hackerman/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/hackerman/colors.toml;
      slug = "hackerman";
      name = "Hackerman";
      author = "Bjarne";
    };
    neovimConf = readIfExists ./colorschemes/hackerman/neovim.lua;
    btopConf = readIfExists ./colorschemes/hackerman/btop.theme;
  };

  kanagawa = {
    vscode = "Kanagawa";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/kanagawa/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/kanagawa/colors.toml;
      slug = "kanagawa";
      name = "Kanagawa";
      author = "rebelot";
    };
    neovimConf = readIfExists ./colorschemes/kanagawa/neovim.lua;
    hyprlandConf = readIfExists ./colorschemes/kanagawa/hyprland.conf;
    btopConf = readIfExists ./colorschemes/kanagawa/btop.theme;
  };

  matte-black = {
    vscode = "Matte Black";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/matte-black/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/matte-black/colors.toml;
      slug = "matte-black";
      name = "Matte Black";
      author = "TahaYVR";
    };
    neovimConf = readIfExists ./colorschemes/matte-black/neovim.lua;
    btopConf = readIfExists ./colorschemes/matte-black/btop.theme;
  };

  miasma = {
    vscode = "In The Fog Dark";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/miasma/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/miasma/colors.toml;
      slug = "miasma";
      name = "Miasma";
      author = "xero";
    };
    neovimConf = readIfExists ./colorschemes/miasma/neovim.lua;
    btopConf = readIfExists ./colorschemes/miasma/btop.theme;
  };

  nord = {
    vscode = "Nord";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/nord/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/nord/colors.toml;
      slug = "nord";
      name = "Nord";
      author = "arcticicestudio";
    };
    neovimConf = readIfExists ./colorschemes/nord/neovim.lua;
    btopConf = readIfExists ./colorschemes/nord/btop.theme;
  };

  osaka-jade = {
    vscode = "Ocean Green: Dark";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/osaka-jade/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/osaka-jade/colors.toml;
      slug = "osaka-jade";
      name = "Osaka Jade";
      author = "craftzdog";
    };
    neovimConf = readIfExists ./colorschemes/osaka-jade/neovim.lua;
    btopConf = readIfExists ./colorschemes/osaka-jade/btop.theme;
  };

  ristretto = {
    vscode = "Monokai Pro (Filter Ristretto)";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/ristretto/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/ristretto/colors.toml;
      slug = "ristretto";
      name = "Ristretto";
      author = "Monokai";
    };
    neovimConf = readIfExists ./colorschemes/ristretto/neovim.lua;
    btopConf = readIfExists ./colorschemes/ristretto/btop.theme;
  };

  tokyo-night = {
    vscode = "Tokyo Night";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/tokyo-night/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/tokyo-night/colors.toml;
      slug = "tokyo-night";
      name = "Tokyo Night";
      author = "enkia";
    };
    neovimConf = readIfExists ./colorschemes/tokyo-night/neovim.lua;
    btopConf = readIfExists ./colorschemes/tokyo-night/btop.theme;
  };

  vantablack = {
    vscode = "Vantablack";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/vantablack/backgrounds);
    colorScheme = colorsTomlToColorScheme {
      tomlPath = ./colorschemes/vantablack/colors.toml;
      slug = "vantablack";
      name = "Vantablack";
      author = "Bjarne";
    };
    neovimConf = readIfExists ./colorschemes/vantablack/neovim.lua;
    btopConf = readIfExists ./colorschemes/vantablack/btop.theme;
  };

  aura = {
    vscode = "Tokyo Night";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/aura/backgrounds);
    colorScheme = alacrittyToColorScheme {
      tomlPath = ./colorschemes/aura/alacritty.toml;
      slug = "aura";
      name = "Aura";
      author = "bjarneo";
    };
    hyprlandConf = readIfExists ./colorschemes/aura/hyprland.conf;
    hyprlockConf = readIfExists ./colorschemes/aura/hyprlock.conf;
    makoConf = readIfExists ./colorschemes/aura/mako.ini;
    neovimConf = readIfExists ./colorschemes/aura/neovim.lua;
    btopConf = readIfExists ./colorschemes/aura/btop.theme;
  };

  fireside = {
    vscode = "Fireside";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/fireside/backgrounds);
    colorScheme = alacrittyToColorScheme {
      tomlPath = ./colorschemes/fireside/alacritty.toml;
      slug = "fireside";
      name = "Fireside";
      author = "bjarneo";
    };
    hyprlandConf = readIfExists ./colorschemes/fireside/hyprland.conf;
    hyprlockConf = readIfExists ./colorschemes/fireside/hyprlock.conf;
    makoConf = readIfExists ./colorschemes/fireside/mako.ini;
    neovimConf = readIfExists ./colorschemes/fireside/neovim.lua;
    btopConf = readIfExists ./colorschemes/fireside/btop.theme;
  };

  pink-blood = {
    vscode = "2077";
    wallpaper = pickWallpaper (getWallpapers ./colorschemes/pink-blood/backgrounds);
    colorScheme = alacrittyToColorScheme {
      tomlPath = ./colorschemes/pink-blood/alacritty.toml;
      slug = "pink-blood";
      name = "Pink Blood";
      author = "ITSZXY";
    };
    hyprlandConf = readIfExists ./colorschemes/pink-blood/hyprland.conf;
    hyprlockConf = readIfExists ./colorschemes/pink-blood/hyprlock.conf;
    makoConf = readIfExists ./colorschemes/pink-blood/mako.ini;
    neovimConf = readIfExists ./colorschemes/pink-blood/neovim.lua;
    btopConf = readIfExists ./colorschemes/pink-blood/btop.theme;
  };
}
