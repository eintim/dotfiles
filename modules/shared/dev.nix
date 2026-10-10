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

      programs.zsh.initContent = ''
        if (( $+commands[ng] )); then
          source <(ng completion script)
        fi
      '';
    };
}
