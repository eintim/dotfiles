{ config, pkgs, ... }:

{
  home.username = "eintim";
  home.homeDirectory = "/home/eintim";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    codex
    claude-code
  ];

  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.mako.enable = true; # notification daemon
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
  home.packages = with pkgs; [
    swaybg # wallpaper
  ];

  programs.zsh = {
    enable = true; 
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "afowler";
    };
  };

  programs.git = {
    enable = true;
    userName  = "eintim";
    userEmail = "tim.horlacher@protonmail.com";
  };

  # Niri Wayland compositor config (VM session at GDM)
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
}
