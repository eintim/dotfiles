{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.nuc = inputs.nixpkgs.lib.nixosSystem {
    modules = [ nixos.nuc ];
  };

  flake.modules.nixos.nuc = {
    imports = with nixos; [
      ./_hardware-configuration.nix
      cli
      git
      home-manager
      locale
      nix
      shell
      tailscale
    ];

    networking.hostName = "nuc";

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    users.users.tim = {
      isNormalUser = true;
      description = "Tim Horlacher";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqvC2JdmRN15RiHVXCffZwbTzPLboRbd39bD/DfO8JH tim.horlacher@protonmail.com"
      ];
    };

    home-manager.users.tim =
      { config, ... }:
      {
        imports = with homeManager; [
          cli
          git
          home-manager
          neovim
          nh
          shell
        ];

        home.username = "tim";
        home.homeDirectory = "/home/tim";
        home.stateVersion = "26.05";

        programs.zsh.history.path = "${config.xdg.dataHome}/zsh/history";
      };

    system.stateVersion = "26.05";
  };
}
