{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    jq
    tmux
  ];

  programs.zsh = {
    dotDir = config.home.homeDirectory;
    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 50000;
      save = 10000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    setOptions = [ "HIST_VERIFY" ];
    oh-my-zsh.theme = "robbyrussell";

    envExtra = ''
      if [[ -r "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
      fi
      export PATH="$HOME/.local/bin:$PATH"
    '';

    profileExtra = ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
    '';

    initContent = ''
      # `brew shellenv` in .zprofile resets PATH, so restore all Nix profiles.
      export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

      export NVM_DIR="$HOME/.nvm"
      if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
      fi
      if [[ -s "$NVM_DIR/bash_completion" ]]; then
        source "$NVM_DIR/bash_completion"
      fi

      if (( $+commands[ng] )); then
        source <(ng completion script)
      fi

      export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
      export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"
      if (( $+commands[pyenv] )); then
        eval "$(pyenv init --path)"
      fi
    '';
  };
}
