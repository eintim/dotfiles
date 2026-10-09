{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.xps13 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ nixos.xps13 ];
  };

  flake.modules.nixos.xps13 =
    { pkgs, ... }:
    {
      imports = with nixos; [
        inputs.nixos-hardware.nixosModules.dell-xps-13-9360
        ./_hardware-configuration.nix
        cli
        desktop
        git
        home-manager
        locale
        nix
        shell
        virtualization
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
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.intel-compute-runtime ];
      };

      home-manager.users.tim =
        { config, ... }:
        {
          imports = with homeManager; [
            cli
            desktop
            git
            home-manager
            neovim
            nh
            shell
            vscode
          ];

          home.username = "tim";
          home.homeDirectory = "/home/tim";
          home.stateVersion = "23.05";

          programs.zsh = {
            history.path = "${config.xdg.dataHome}/zsh/history";
            oh-my-zsh.theme = "afowler";
          };
        };

      system.stateVersion = "22.05";
    };
}
