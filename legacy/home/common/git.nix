{ ... }:
{
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
}
