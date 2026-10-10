{ inputs, ... }:
let
  integration = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
in
{
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      integration
    ];
  };

  flake.modules.darwin.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      integration
    ];
  };

  flake.modules.homeManager.home-manager = {
    programs.home-manager.enable = true;
  };
}
