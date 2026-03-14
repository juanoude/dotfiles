{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Juan Ananda";
    userEmail = "juanoude@gmail.com";

    extraConfig = {
      pull.rebase = false;
      core.editor = "nvim";
    };
  };
}
