{
  flake.modules.homeManager.neovim = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = true;
      withPython3 = true;
      # init.lua is managed outside of Nix; load the provider setup through
      # the wrapper instead of overwriting it.
      sideloadInitLua = true;
    };
  };
}
