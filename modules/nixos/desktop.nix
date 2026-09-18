{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
    windowManager = {
      bspwm.enable = true;
      i3.enable = true;
      dwm.enable = true;
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

  programs.hyprland.enable = true;
  programs.dconf.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  security.pam.services.swaylock = { };

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

  environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";
}
