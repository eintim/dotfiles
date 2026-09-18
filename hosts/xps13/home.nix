{ config, ... }:
{
  imports = [
    ../../modules/home/common
    ../../modules/home/linux/desktop.nix
    ../../modules/home/programs/neovim.nix
    ../../modules/home/programs/vscode.nix
  ];

  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh.theme = "afowler";
  };
}
