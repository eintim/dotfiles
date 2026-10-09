{ config, ... }:
{
  imports = [
    ../../modules/home/common
    ../../modules/home/linux/desktop.nix
    ../../modules/home/programs/vscode.nix
  ];

  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    history.path = "${config.xdg.dataHome}/zsh/history";
    oh-my-zsh.theme = "afowler";
  };
}
