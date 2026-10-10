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

    programs.nix-ld.enable = true;
  };

  flake.modules.darwin.nix =
    { lib, pkgs, ... }:
    {
      # Determinate owns the Nix daemon and its configuration.
      nix.enable = false;

      nixpkgs.config.allowUnfree = true;

      # Determinate collects unreferenced store paths on its own, but old
      # generations stay GC roots. Prune them like nix.gc does on NixOS.
      launchd.daemons.nh-clean.serviceConfig = {
        ProgramArguments = [
          (lib.getExe pkgs.nh)
          "clean"
          "all"
          "--keep-since"
          "14d"
        ];
        StartCalendarInterval = [
          {
            Weekday = 0;
            Hour = 12;
            Minute = 0;
          }
        ];
      };
    };
}
