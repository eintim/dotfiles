{ inputs, config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [ config.flake.modules.darwin.macbook ];
  };

  flake.modules.darwin.macbook = {
    imports = with darwin; [
      home-manager
      homebrew
      macos
      nix
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
    system.primaryUser = "eintim";

    users.users.eintim.home = "/Users/eintim";

    home-manager.users.eintim =
      { config, ... }:
      {
        imports = with homeManager; [
          cli
          git
          home-manager
          macos
          neovim
          nh
          shell
        ];

        home.username = "eintim";
        home.homeDirectory = "/Users/eintim";
        home.stateVersion = "26.05";

        # The Mac's hostname does not match the configuration name.
        programs.nh.darwinFlake = "${config.programs.nh.flake}#macbook";
      };
  };
}
