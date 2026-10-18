{
  flake.modules.nixos.shell =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    };

  flake.modules.homeManager.shell = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases.ll = "ls -l";
      history = {
        size = 50000;
        save = 10000;
        extended = true;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };
      setOptions = [ "HIST_VERIFY" ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };

    # Ctrl+R searches history, Ctrl+T inserts a file path.
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
