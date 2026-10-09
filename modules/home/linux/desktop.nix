{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    distrobox
    webcord
    element-desktop
    streamlink
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

  services.syncthing.enable = true;
  programs.go.enable = true;

  xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=auto-safe
    vo=gpu
    profile=gpu-hq
  '';
}
