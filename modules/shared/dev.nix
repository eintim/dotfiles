{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        autoconf
        autoconf-archive
        automake
        ccache
        cmake
        gource
        luarocks
        mkcert
        nasm
        ninja
        opencode
        shellcheck
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
      home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

      # Generating the completion starts Node, so cache it until ng changes.
      programs.zsh.initContent = ''
        if (( $+commands[ng] )); then
          _ng_completion="${config.xdg.cacheHome}/zsh/ng-completion.zsh"
          if [[ ! -s $_ng_completion || $commands[ng] -nt $_ng_completion ]]; then
            mkdir -p "''${_ng_completion:h}"
            ng completion script >| "$_ng_completion"
          fi
          source "$_ng_completion"
          unset _ng_completion
        fi
      '';
    };
}
