{ ... }:
{
  imports = [
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Determinate owns the Nix daemon and its configuration.
  nix.enable = false;
}
