{
  description = "Tim's system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, nix-darwin, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
    homeConfigurations."eintim@macbook" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      modules = [ ./home/darwin ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      modules = [ ./darwin/configuration.nix ];
    };

    packages.aarch64-darwin = {
      home-manager = home-manager.packages.aarch64-darwin.home-manager;
      darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;
    };

    homeConfigurations.tim = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/home.nix
        ];
    };

    nixosConfigurations = {
      xps13 = lib.nixosSystem {
        inherit system;

	      modules = [
	        nixos-hardware.nixosModules.dell-xps-13-9360
          ./system/configuration.nix
	      ];
      };
    };
  };
}
