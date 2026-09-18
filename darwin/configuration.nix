{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate owns the Nix daemon and its configuration.
  nix.enable = false;
  system.stateVersion = 6;

  # Homebrew, GUI apps, macOS defaults and the login shell stay independently managed.
  homebrew.enable = false;
}
