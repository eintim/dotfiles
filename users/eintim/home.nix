{ config, pkgs, ... }:

{
  home.username = "eintim";
  home.homeDirectory = "/home/eintim";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userName  = "eintim";
    userEmail = "tim.horlacher@protonmail.com";
  };
}
