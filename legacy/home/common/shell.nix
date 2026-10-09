{ ... }:
{
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
