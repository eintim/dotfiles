{ inputs, config, ... }:
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [ config.flake.modules.darwin.macbook ];
  };

  flake.modules.darwin.macbook = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      ../../legacy/darwin/base.nix
      ../../legacy/shared/home-manager.nix
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
    system.primaryUser = "eintim";

    users.users.eintim.home = "/Users/eintim";

    home-manager.users.eintim =
      { config, ... }:
      {
        imports = [
          ../../legacy/home/common
          ../../legacy/home/darwin
        ];

        home.username = "eintim";
        home.homeDirectory = "/Users/eintim";
        home.stateVersion = "26.05";

        programs.home-manager.enable = true;

        # The Mac's hostname does not match the configuration name.
        programs.nh.darwinFlake = "${config.programs.nh.flake}#macbook";
      };
  };
}
