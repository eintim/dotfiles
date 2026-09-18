{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Determinate owns the Nix daemon and its configuration.
  nix.enable = false;

  # GUI applications and macOS defaults remain independently managed.
  homebrew.enable = false;
}
