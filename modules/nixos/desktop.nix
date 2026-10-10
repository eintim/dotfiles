{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;

      services.xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
        };
      };

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.flatpak.enable = true;
      services.devmon.enable = true;
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      services.blueman.enable = true;
      services.printing.enable = true;

      hardware.bluetooth.enable = true;

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      programs.dconf.enable = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        firefox
        kitty
        alacritty
        brightnessctl
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
        nerd-fonts.symbols-only
        font-awesome
      ];
    };

  flake.modules.homeManager.desktop =
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
    };
}
