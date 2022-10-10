{
  description = "Tim's system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
    homeConfigurations = {
      "tim" = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
	stateVersion = "22.05";
	username = "tim";
	homeDirectory = "/home/tim";
	configuration = {
          imports= [
	    ./home/home.nix
	  ];
	};
      };
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
