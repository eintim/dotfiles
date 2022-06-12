{
  description = "Tim's system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      tim = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
	stateVersion = "22.05";
	username = "tim";
	homeDirectory = "/home/tim";
	configuration = {
          imports= [
	    ./users/tim/home.nix
	  ];
	};
      };
    };

    nixosConfigurations = {
      xps13 = lib.nixosSystem {
        inherit system;

	modules = [
          ./system/configuration.nix
	];
      };
    };
  };
}
