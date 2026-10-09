{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Tim Horlacher";
          email = "tim.horlacher@protonmail.com";
        };
        init.defaultBranch = "main";
        core.autocrlf = "input";
      };
    };
  };

  flake.modules.nixos.git =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];
    };
}
