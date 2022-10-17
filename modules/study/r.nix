{ config, pkgs, ... }:

let
  RStudio-with-my-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ggplot2 dplyr xts tidyverse rpart vcd ]; };
in
{
  home.packages = with pkgs; [
    RStudio-with-my-packages
    teams
    unityhub
    discord
  ];
}