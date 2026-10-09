{ ... }:
{
  imports = [
    ./cli.nix
    ./git.nix
    ./shell.nix
    ../programs/neovim.nix
  ];
}
