{ ... }:
{
  imports = [
    ../../legacy/darwin/base.nix
    ../../legacy/shared/home-manager.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "eintim";

  users.users.eintim.home = "/Users/eintim";

  home-manager.users.eintim = ./home.nix;
}
