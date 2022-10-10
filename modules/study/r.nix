{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    teams
    unityhub
    rstudio
    discord
  ];
}