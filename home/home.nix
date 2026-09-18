{ config, pkgs, ... }:

{
  imports = [
    
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tim";
  home.homeDirectory = "/home/tim";


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; 

  home.packages = with pkgs; [
    keepassxc
    distrobox
    webcord
    element-desktop
    mpv
    streamlink
    zsh
    libreoffice
    prismlauncher
    ansible
    dolphin-emu
    obs-studio
    zoom-us
    heroic
    obsidian
    signal-desktop
    teamspeak6-client
    android-tools
    qbittorrent
    platformio
    avrdude
  ];

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };


  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
  
  services.syncthing.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.go.enable = true;
  programs.zsh = {
    enable = true; 
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
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
    settings.user = {
      name = "eintim";
      email = "tim.horlacher@protonmail.com";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=auto-safe
    vo=gpu
    profile=gpu-hq
  '';

}
