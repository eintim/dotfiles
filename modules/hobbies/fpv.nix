{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cura
    blender
    betaflight-configurator
    obs-studio
  ];
}