{ inputs, ... }:
{
  flake.nixosConfigurations.xps13 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/xps13
    ];
  };
}
