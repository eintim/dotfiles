{ config, ... }:
{
  imports = [
    ../../modules/home/common
    ../../modules/home/darwin
  ];

  home.username = "eintim";
  home.homeDirectory = "/Users/eintim";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # The Mac's hostname does not match the configuration name.
  programs.nh.darwinFlake = "${config.programs.nh.flake}#macbook";
}
