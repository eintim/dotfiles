{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-manager
    wireguard-tools
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd.enable = true;
  };
}
