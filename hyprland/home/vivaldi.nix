{ currentTheme, ... }:

let
  palette = currentTheme.colorScheme.palette;
in
{
  home.file.".config/vivaldi/Default/CustomCSS/custom.css".text = ''
    :root {
      --colorBg: #${palette.base00};
      --colorBgDark: #${palette.base01};
      --colorBgLighter: #${palette.base02};
      --colorFg: #${palette.base07};
      --colorFgFaded: #${palette.base05};
      --colorAccent: #${palette.base0D};
      --colorAccentAlt: #${palette.base0E};
      --colorHighlight: #${palette.base0A};
      --colorBorder: #${palette.base03};
      --colorError: #${palette.base01};
      --colorSuccess: #${palette.base02};
    }

    /* Tab bar background */
    #tabs-tabbar-container {
      background-color: var(--colorBgDark) !important;
    }

    /* Address bar */
    .UrlBar {
      background-color: var(--colorBg) !important;
    }

    /* Panel */
    #panels-container {
      background-color: var(--colorBgDark) !important;
    }

    /* Bookmarks bar */
    .bookmark-bar {
      background-color: var(--colorBgDark) !important;
    }

    /* Speed dial */
    .startpage {
      background-color: var(--colorBg) !important;
    }

    /* Active tab */
    .tab.active {
      background-color: var(--colorBg) !important;
    }

    /* Tab hover */
    .tab:hover {
      background-color: var(--colorBgLighter) !important;
    }
  '';
}
