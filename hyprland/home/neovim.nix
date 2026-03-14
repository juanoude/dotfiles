{pkgs, currentTheme, ...}:

let
  lazyvim-starter = pkgs.fetchFromGitHub {
    owner = "LazyVim";
    repo = "starter";
    rev = "main";
    sha256 = "sha256-QrpnlDD4r1X4C8PqBhQ+S3ar5C+qDrU1Jm/lPqyMIFM=";
  };

  # Use theme's neovim.lua if present, otherwise generate base16 config from palette
  hasNeovimConf = (currentTheme ? neovimConf) && currentTheme.neovimConf != "";
  palette = currentTheme.colorScheme.palette;

  colorschemeConfig = if hasNeovimConf then currentTheme.neovimConf
    else ''
      return {
        {
          "RRethy/nvim-base16",
          lazy = false,
          priority = 1000,
          config = function()
            require("base16-colorscheme").setup({
              base00 = "#${palette.base00}",
              base01 = "#${palette.base01}",
              base02 = "#${palette.base02}",
              base03 = "#${palette.base03}",
              base04 = "#${palette.base04}",
              base05 = "#${palette.base05}",
              base06 = "#${palette.base06}",
              base07 = "#${palette.base07}",
              base08 = "#${palette.base08}",
              base09 = "#${palette.base09}",
              base0A = "#${palette.base0A}",
              base0B = "#${palette.base0B}",
              base0C = "#${palette.base0C}",
              base0D = "#${palette.base0D}",
              base0E = "#${palette.base0E}",
              base0F = "#${palette.base0F}",
            })
          end,
        },
        {
          "LazyVim/LazyVim",
          opts = {
            colorscheme = function() end,  -- Disable LazyVim colorscheme, we set it above
          },
        },
      }
    '';

  themePlugins = ''
    return {
      { "folke/tokyonight.nvim" },
      { "ellisonleao/gruvbox.nvim" },
      { "shaunsingh/nord.nvim" },
      { "rebelot/kanagawa.nvim" },
      { "sainnhe/everforest" },
      { "catppuccin/nvim", name = "catppuccin" },
      { "rose-pine/neovim", name = "rose-pine" },
      { "navarasu/onedark.nvim" },
      { "ishan9299/nvim-solarized-lua" },
    }
  '';
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = lazyvim-starter;
    recursive = true;
  };

  home.file.".config/nvim/lua/plugins/colorscheme.lua".text = colorschemeConfig;
  # Only include theme plugins when using base16 fallback (no custom neovimConf)
  home.file.".config/nvim/lua/plugins/themes.lua" = {
    text = themePlugins;
    enable = !hasNeovimConf;
  };
}
