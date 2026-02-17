{ config, pkgs, ... }:

{
  home.username = "eintim";
  home.homeDirectory = "/home/eintim";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    codex
    opencode
    claude-code
    swaybg
    pavucontrol
    pkgs.nerd-fonts."jetbrains-mono"
    font-awesome
  ];

  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  fonts.fontconfig.enable = true;
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        spacing = 8;
        modules-left = [ "niri/workspaces" ];
        modules-center = [ ];
        modules-right = [ "tray" "pulseaudio" "network" "cpu" "memory" "battery" "clock" "custom/logout" "custom/shutdown" ];

        "niri/workspaces" = {
          format = "{index}";
        };

        clock = {
          format = "{:%H:%M:%S}";
          tooltip = true;
          tooltip-format = "{:%Y-%m-%d %a}";
        };

        "custom/logout" = {
          format = "⎋";
          tooltip = true;
          tooltip-format = "Log out";
          on-click = "loginctl terminate-user \"$USER\"";
        };

        "custom/shutdown" = {
          format = "⏻";
          tooltip = true;
          tooltip-format = "Shut down";
          on-click = "systemctl poweroff";
        };

        cpu = { format = "{usage}% "; };
        memory = { format = "{}% "; };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
        };

        tray = { spacing = 8; };
      };
    };
    style = ''
      @define-color bg #1b1d27;
      @define-color bg-alt #2a2d3a;
      @define-color fg #e6e6e6;
      @define-color accent #8aadf4;
      @define-color accent-2 #a6da95;
      @define-color warn #f5a97f;
      @define-color crit #ed8796;

      * {
        font-family: JetBrainsMono Nerd Font, FontAwesome, sans-serif;
        font-size: 13px;
        font-weight: 600;
        color: @fg;
      }

      window#waybar {
        background: linear-gradient(90deg, #1b1d27 0%, #202331 50%, #1b1d27 100%);
        border-bottom: 1px solid #0f1117;
      }

      #workspaces {
        margin: 4px 6px;
        padding: 2px;
        background-color: rgba(0, 0, 0, 0.25);
        border-radius: 10px;
      }

      #workspaces button {
        padding: 2px 10px;
        margin: 0 2px;
        border-radius: 8px;
        background: transparent;
      }

      #workspaces button:hover {
        background-color: @bg-alt;
      }

      #workspaces button.active {
        background-color: @accent;
        color: #0f1117;
      }

      #workspaces button.focused {
        background-color: @accent;
        color: #0f1117;
      }

      #workspaces button.urgent {
        background-color: @crit;
        color: #0f1117;
      }

      #clock,
      #tray,
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #battery,
      #custom-logout,
      #custom-shutdown {
        padding: 0 10px;
        margin: 4px 4px;
        border-radius: 8px;
        background-color: @bg-alt;
        border: 1px solid #1b1f2a;
      }

      #clock {
        background-color: #31364a;
      }

      #pulseaudio {
        background-color: #3a2f1f;
        border-color: #3e3425;
      }

      #network {
        background-color: #243447;
        border-color: #2a3b51;
      }

      #cpu {
        background-color: #243a2c;
        border-color: #2a4433;
      }

      #memory {
        background-color: #37263a;
        border-color: #402b44;
      }

      #battery {
        background-color: #2f3533;
        border-color: #343c39;
      }

      #custom-logout {
        background-color: #3a3346;
        border-color: #473f57;
      }

      #custom-shutdown {
        background-color: #4a2c30;
        border-color: #5a3439;
      }

      #battery.critical:not(.charging) {
        background-color: @crit;
        color: #0f1117;
      }
    '';
  };
  services.mako.enable = true; # notification daemon
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
 

  programs.zsh = {
    enable = true; 
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
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

  # Niri Wayland compositor config (VM session at GDM)
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
  xdg.configFile."niri/wallpaper.png".source = ../../wallpapers/nix-wallpaper-simple-dark-gray.png;
}
