{ ... }:
{
  imports = [
    ../../modules/home/common
    ../../modules/home/darwin
  ];

  home.username = "eintim";
  home.homeDirectory = "/Users/eintim";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
