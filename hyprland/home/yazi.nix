{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };

     # preview = {
     #   max_width = 1000;
     #   max_height = 1000;
     # };
    };
  };
}
