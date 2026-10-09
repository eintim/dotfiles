{
  flake.modules.nixos.nix = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        keep-outputs = true;
        keep-derivations = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      optimise.automatic = true;
    };

    nixpkgs.config.allowUnfree = true;

    programs.nix-ld = {
      enable = true;
      libraries = [ ];
    };
  };

  flake.modules.darwin.nix = {
    # Determinate owns the Nix daemon and its configuration.
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;
  };
}
