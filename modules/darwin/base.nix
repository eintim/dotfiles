{ ... }:
{
  imports = [
    ./defaults.nix
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Determinate owns the Nix daemon and its configuration.
  nix.enable = false;

  # Touch ID for sudo, also inside tmux sessions.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
