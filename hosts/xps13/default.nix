{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.dell-xps-13-9360
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/virtualization.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "xps13";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = [ "ntfs" ];

    initrd.secrets."/crypto_keyfile.bin" = null;
    initrd.luks.devices."luks-bb5d84da-b8b0-4393-aafa-8b39f9dc862a" = {
      device = "/dev/disk/by-uuid/bb5d84da-b8b0-4393-aafa-8b39f9dc862a";
      keyFile = "/crypto_keyfile.bin";
    };

    extraModprobeConfig = ''
      options snd slots=snd-hda-intel
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 1883 ];
    checkReversePath = "loose";
    logReversePathDrops = true;
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  users.users.tim = {
    isNormalUser = true;
    description = "Tim Horlacher";
    extraGroups = [
      "video"
      "networkmanager"
      "wheel"
      "dialout"
      "docker"
      "adbusers"
    ];
  };

  environment.systemPackages = with pkgs; [
    android-tools
  ];

  services.udev = {
    packages = [
      pkgs.platformio
      pkgs.platformio-core.udev
      pkgs.openocd
    ];
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.intel-compute-runtime ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tim = ./home.nix;
  };

  system.stateVersion = "22.05";
}
