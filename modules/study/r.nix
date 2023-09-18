{ config, pkgs, ... }:

let
  RStudio-with-my-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ggplot2 dplyr xts tidyverse rpart vcd nycflights13 mosaic maps shiny sf ggmap tidyr gganimate gifski transformr MASS mongolite giscoR st ggstream]; };
in
{
  home.packages = with pkgs; [
    RStudio-with-my-packages
    teams
    unityhub
    discord
    quarto
  ];
}