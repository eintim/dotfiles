{ ... }:
{
  imports = [
    ./cli.nix
    ./git.nix
    ./nh.nix
    ./shell.nix
    ../programs/neovim.nix
  ];
}
