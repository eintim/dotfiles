# Standalone NixOS config for VM. Does not import xps13 or shared modules.

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm";
  networking.useDHCP = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";

  users.mutableUsers = true;
  users.users.eintim = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
