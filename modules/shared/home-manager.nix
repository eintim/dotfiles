{ inputs, ... }:
let
  integration = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      # Move files that apps replaced with their own copy (e.g. Karabiner
      # rewriting karabiner.json) aside instead of failing activation.
      backupFileExtension = "hm-bak";
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
