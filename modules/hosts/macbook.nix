{ inputs, ... }:
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.home-manager.darwinModules.home-manager
      ../../hosts/macbook
    ];
  };
}
