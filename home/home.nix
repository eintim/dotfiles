{ config, pkgs, ... }:

{
  imports =
    (import ../modules/study) ++
    (import ../modules/hobbies);

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
    discord
    webcord
    element-desktop
    mpv
    streamlink
    zsh
    libreoffice-fresh
    prismlauncher
    ansible
    dolphin-emu-beta
    zoom-us
    python38
    obsidian
    teams
    signal-desktop-beta
    teamspeak5_client
    android-tools
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
  
  services.syncthing.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.go.enable = true;
  programs.zsh = {
    enable = true; 
    enableAutosuggestions = true;
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
    userName  = "eintim";
    userEmail = "tim.horlacher@protonmail.com";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=auto-safe
    vo=gpu
    profile=gpu-hq
  '';
}
