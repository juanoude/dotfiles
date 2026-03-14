{ pkgs, currentTheme, ... }:

{
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-vscode.cpptools
      eamodio.gitlens
      esbenp.prettier-vscode
      bbenoist.nix
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "everforest";
        publisher = "sainnhe";
        version = "0.3.0";
        sha256 = "sha256-nZirzVvM160ZTpBLTimL2X35sIGy5j2LQOok7a2Yc7U=";
      }
      {
        name = "tokyo-night";
        publisher = "enkia";
        version = "1.1.2";
        sha256 = "sha256-oW0bkLKimpcjzxTb/yjShagjyVTUFEg198oPbY5J2hM=";
      }
      {
        name = "kanagawa";
        publisher = "qufiwefefwoyn";
        version = "1.5.1";
        sha256 = "sha256-AGGioXcK/fjPaFaWk2jqLxovUNR59gwpotcSpGNbj1c=";
      }
      {
        name = "nord-visual-studio-code";
        publisher = "arcticicestudio";
        version = "0.19.0";
        sha256 = "sha256-awbqFv6YuYI0tzM/QbHRTUl4B2vNUdy52F4nPmv+dRU=";
      }
      {
        name = "gruvbox";
        publisher = "jdinhlife";
        version = "1.28.0";
        sha256 = "sha256-XwQzbbZU6MfYcT50/0YgQp8UaOeQskEvEQPZXG72lLk=";
      }
      {
        name = "winteriscoming";
        publisher = "johnpapa";
        version = "1.4.4";
        sha256 = "sha256-47zCB7VDj+gYXUeblbNsWnGMJt4U4UMyqU1NYTmz2Jc=";
      }
      {
        name = "celestial-echoes";
        publisher = "jemo";
        version = "0.0.7";
        sha256 = "sha256-cccCmXUUMhMI8fzehgzYfewwwWEyDlWu3bHsurdNV0A=";
      }
      {
        name = "theme-dracula";
        publisher = "dracula-theme";
        version = "2.25.1";
        sha256 = "sha256-ijGbdiqbDQmZYVqZCx2X4W7KRNV3UDddWvz+9x/vfcA=";
      }
      {
        name = "catppuccin-vsc";
        publisher = "Catppuccin";
        version = "3.18.1";
        sha256 = "sha256-Kph5nQgbRSgDVqo2n2eXoQXh7ga0o8/oNkQyoSZxHZo=";
      }
      {
        name = "ethereal-omarchy";
        publisher = "Bjarne";
        version = "1.0.0";
        sha256 = "sha256-GojGDTmpwaODXliQU3oDspxd+pCcz9BaqWpTzaEkTdw=";
      }
      {
        name = "hackerman-omarchy";
        publisher = "Bjarne";
        version = "1.0.0";
        sha256 = "sha256-E2xaru4HNYCqMBlZfFiL6j/eYIBuk8cmslA3C2lCnrI=";
      }
      {
        name = "matteblack";
        publisher = "TahaYVR";
        version = "1.0.2";
        sha256 = "sha256-6FHDploW432klWeLxz45PTfR7sqzpDRYGMMNvsqOyjk=";
      }
      {
        name = "in-the-fog-theme";
        publisher = "ganevru";
        version = "0.3.1";
        sha256 = "sha256-B/ae1scmVCWu8mnYyZS3moAzwucHrd9axB78UWzZkNE=";
      }
      {
        name = "ocean-green";
        publisher = "jovejonovski";
        version = "1.1.2";
        sha256 = "sha256-sUNjnzqXya23Uieg8RLcEfnxiX0ImZ6CIjFtSJ66vM4=";
      }
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "2.0.12";
        sha256 = "sha256-e/IjWP+GgA8dTJWV9nloFVuv68Bh5DiW1QcVXpUdS3Q=";
      }
      {
        name = "vantablack-omarchy";
        publisher = "Bjarne";
        version = "1.0.0";
        sha256 = "sha256-EQ+LuoeWAaayU8geI3ss/F8sF2oNfHjX+fzbLA9TJEk=";
      }
      {
        name = "2077-theme";
        publisher = "endormi";
        version = "1.5.3";
        sha256 = "sha256-poytaPKzqUaEytRsvfi36mEhy/ot1rYKY1nvANwBY6Q=";
      }
    ];

    userSettings = {
      "workbench.colorTheme" = currentTheme.vscode;
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
    };
  };
}
