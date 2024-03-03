{ config, pkgs, ... }:

let
  RStudio-with-my-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ggplot2 dplyr xts tidyverse rpart vcd nycflights13 giscoR sf gganimate transformr ggstream quarto ]; };

in
{
  home.packages = with pkgs; [
    RStudio-with-my-packages
    quarto
  ];
}