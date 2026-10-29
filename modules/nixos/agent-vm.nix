# A microVM for coding agents. Agents run as an unprivileged user inside the
# VM, which can reach the internet but not the LAN, the tailnet or the host.
# Reach it through the host: ssh -J tim@nuc agent@10.100.0.2
# The VM's T3 Code server is forwarded to the tailnet as http://nuc:3773.
{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;

  tap = "vm-agent";
  hostAddress = "10.100.0.1";
  guestAddress = "10.100.0.2";
  mac = "02:00:00:00:00:01";
  t3Port = 3773;

  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqvC2JdmRN15RiHVXCffZwbTzPLboRbd39bD/DfO8JH tim.horlacher@protonmail.com";

  # Private and link-local ranges the VM must not reach, including the
  # tailnet's CGNAT range.
  blockedRanges = "{ 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10, 169.254.0.0/16 }";

  # Global instructions for Claude Code (CLAUDE.md), Codex and opencode
  # (AGENTS.md).
  agentInstructions = ''
    # Environment

    You run as `agent` in a disposable NixOS microVM built as a sandbox for
    you. Act without asking for approval; the VM boundary is the safety net.

    ## Getting tools

    NixOS has no apt and you have no root. Get tools through Nix:

    - One command: `nix shell nixpkgs#<pkg> -c <cmd>`. Find names with
      `nix search nixpkgs <name>`.
    - A repo with a `flake.nix`: run inside its dev shell with
      `nix develop -c <cmd>`, or `direnv allow` once to load it on `cd`.
    - Node: `npm install -g` installs into `~/.local`, which is on PATH.
      Python: use `uv`.
    - Prebuilt Linux binaries (from npm, pip or downloads) run as-is.

    ## Limits

    - Only `/home` persists. Packages from `nix shell` are fetched again
      after a VM restart. Keep repos in `~/dev`.
    - Network reaches the public internet only. The LAN, the tailnet and the
      host are blocked by the firewall.
    - 3 vCPUs and about 5 GB RAM on an old CPU. Run one build or test suite
      at a time, and prefer targeted tests over full suites.

    ## GitHub

    `gh` is logged in, and git uses it for HTTPS. Clone with https URLs.
  '';

  guest =
    { lib, pkgs, ... }:
    {
      imports = with nixos; [
        home-manager
        locale
        nix
        shell
      ];

      networking.hostName = "agent";

      # The host owns the store; collecting or optimising the overlay only
      # fights the read-only lower layer.
      nix.gc.automatic = lib.mkForce false;
      nix.optimise.automatic = lib.mkForce false;

      # The VM uses the host's package set, which already allows unfree.
      nixpkgs.config = lib.mkForce { };

      microvm = {
        hypervisor = "qemu";
        vcpu = 3;
        mem = 5120;

        interfaces = [
          {
            type = "tap";
            id = tap;
            inherit mac;
          }
        ];

        shares = [
          {
            proto = "virtiofs";
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }
        ];

        # Lets agents use nix shell and nix develop. The Nix database forgets
        # these paths on reboot, so the overlay starts empty on every boot.
        writableStoreOverlay = "/nix/.rw-store";
        preStart = "rm -f nix-store-overlay.img";

        volumes = [
          {
            image = "nix-store-overlay.img";
            mountPoint = "/nix/.rw-store";
            size = 20480;
          }
          {
            image = "home.img";
            mountPoint = "/home";
            size = 51200;
          }
          {
            image = "persist.img";
            mountPoint = "/persist";
            size = 64;
          }
        ];
      };

      # Mount /home before users are created, so home directories land on the
      # volume instead of underneath it.
      fileSystems."/home".neededForBoot = true;

      networking.useNetworkd = true;
      systemd.network.networks."10-eth" = {
        matchConfig.MACAddress = mac;
        address = [ "${guestAddress}/24" ];
        gateway = [ hostAddress ];
        networkConfig.DNS = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };

      zramSwap.enable = true;

      # The VM is the sandbox, so agents run without approval prompts. These
      # system-level files sit below each tool's user config, which stays
      # writable.
      environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
        permissions.defaultMode = "bypassPermissions";
        skipDangerousModePermissionPrompt = true;
      };
      environment.etc."codex/config.toml".text = ''
        approval_policy = "never"
        sandbox_mode = "danger-full-access"
      '';

      networking.firewall.allowedTCPPorts = [ t3Port ];

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
        # The root filesystem is rebuilt on every boot. Keep the host key so
        # it doesn't change.
        hostKeys = [
          {
            path = "/persist/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [ sshKey ];
      users.users.agent = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ sshKey ];
        # Start the user's services, like the T3 Code server, at boot.
        linger = true;
      };

      home-manager.users.agent =
        { config, ... }:
        {
          imports = with homeManager; [
            agent-skills
            cli
            dev
            git
            home-manager
            neovim
            shell
          ];

          home.file.".claude/CLAUDE.md".text = agentInstructions;
          home.file.".codex/AGENTS.md".text = agentInstructions;
          # opencode installs through the dev module and allows all tools by
          # default, so it only needs the instructions.
          xdg.configFile."opencode/AGENTS.md".text = agentInstructions;

          home.packages = with pkgs; [
            claude-code
            codex
          ];

          # Home Manager owns the git config, so `gh auth setup-git` can't
          # write the credential helper. Declare it here instead.
          programs.gh = {
            enable = true;
            gitCredentialHelper.enable = true;
          };

          home.username = "agent";
          home.homeDirectory = "/home/agent";
          home.stateVersion = "26.05";

          programs.zsh.history.path = "${config.xdg.dataHome}/zsh/history";
        };

      system.stateVersion = "26.05";
    };
in
{
  flake.modules.nixos.agent-vm = {
    imports = [ inputs.microvm.nixosModules.host ];

    microvm.vms.agent.config = guest;

    networking.useNetworkd = true;
    # Don't hold up boot until the VM's tap interface is up.
    systemd.network.wait-online.anyInterface = true;
    systemd.network.networks."30-${tap}" = {
      matchConfig.Name = tap;
      address = [ "${hostAddress}/24" ];
      networkConfig.IPv4Forwarding = true;
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ tap ];
    };

    # A separate table, because a drop in any base chain is final, no matter
    # what the NixOS firewall accepts later.
    networking.nftables.enable = true;
    networking.nftables.tables.agent-vm = {
      family = "inet";
      content = ''
        # The host may open connections to the VM, not the other way around.
        chain input {
          type filter hook input priority filter - 1; policy accept;
          iifname "${tap}" ct state != { established, related } drop
        }

        chain forward {
          type filter hook forward priority filter - 1; policy accept;
          ct state { established, related } accept
          iifname "${tap}" ip daddr ${blockedRanges} drop
          iifname "${tap}" meta nfproto ipv6 drop
        }

        # Tailnet devices reach the VM's T3 Code server through the host.
        chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;
          iifname "tailscale0" tcp dport ${toString t3Port} dnat ip to ${guestAddress}:${toString t3Port}
        }
      '';
    };
  };
}
