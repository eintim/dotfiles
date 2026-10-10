{ inputs, config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [ darwin.macbook ];
  };

  flake.modules.darwin.macbook = {
    imports = with darwin; [
      aerospace
      home-manager
      homebrew
      karabiner
      locale
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
          aerospace
          cli
          dev
          git
          home-manager
          karabiner
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
