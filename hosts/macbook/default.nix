{ ... }:
{
  imports = [
    ../../modules/darwin/base.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "eintim";

  users.users.eintim.home = "/Users/eintim";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.eintim = ./home.nix;
  };
}
