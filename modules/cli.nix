{
  flake.modules.homeManager.cli =
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
    };

  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.wget ];
    };
}
