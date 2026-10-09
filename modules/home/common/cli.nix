{ pkgs, ... }:
{
  home.packages = with pkgs; [
    btop
    fastfetch
    gh
    jq
    jujutsu
    lazygit
    mpv
    p7zip
    ripgrep
    tmux
    typst
    unar
  ];
}
