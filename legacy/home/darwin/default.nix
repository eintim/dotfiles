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
    tio

    # Global language runtimes. Projects pin their own versions in a flake
    # dev shell (see templates/devshell) or with uv.
    nodejs_24
    pnpm
    python313
    uv
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # Global npm installs go to ~/.local instead of the read-only Nix store.
  home.sessionVariables.NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.local";

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

      path+=("$HOME/.antigravity/antigravity/bin")
    '';

    initContent = ''
      if (( $+commands[ng] )); then
        source <(ng completion script)
      fi
    '';
  };
}
