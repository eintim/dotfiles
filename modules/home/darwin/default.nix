{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    autoconf-archive
    automake
    bash
    ccache
    cmake
    gource
    luarocks
    mkcert
    nasm
    ninja
    opencode
    pnpm
    tio
  ];

  programs.zsh = {
    dotDir = config.home.homeDirectory;
    history.path = "${config.home.homeDirectory}/.zsh_history";
    oh-my-zsh.theme = "robbyrussell";

    # .zshenv is read by every zsh, so PATH is the same in login and
    # non-login shells.
    envExtra = ''
      typeset -U path

      if [[ -r "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
      fi
      path=("$HOME/.local/bin" $path)

      # Append Homebrew so Nix packages take precedence.
      if [[ -x /opt/homebrew/bin/brew ]]; then
        export HOMEBREW_PREFIX=/opt/homebrew
        export HOMEBREW_CELLAR=/opt/homebrew/Cellar
        export HOMEBREW_REPOSITORY=/opt/homebrew
        path+=(/opt/homebrew/bin /opt/homebrew/sbin)
        fpath+=(/opt/homebrew/share/zsh/site-functions)
      fi

      # CLIs pip-installed into the python.org framework build.
      path+=(/Library/Frameworks/Python.framework/Versions/3.13/bin)
      path+=("$HOME/.antigravity/antigravity/bin")
    '';

    initContent = ''
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

      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"
      if (( $+commands[pyenv] )); then
        eval "$(pyenv init --path)"
      fi
    '';
  };
}
