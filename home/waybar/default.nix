{ config, lib, pkgs, ...}:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"] ;} );
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;
        modules-left = [ "custom/nix" "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [ "tray" "pulseaudio" "cpu" "memory" "backlight" "battery" "clock" "custom/powermenu" ];

        "custom/powermenu" = {
          "format" = " ";
          "on-click" = "~/.config/hypr/eww/scripts/waybar/powermenu";
          "tooltip" = false;
        };

        "custom/swaync" = {
          "format" = " ";
          "on-click" = "~/.config/hypr/swaync/scripts/tray_waybar.sh";
          "on-click-right" = "swaync-client -C";
          "tooltip" = false;
        };

        "custom/menu" = {
          "format" = " ";
          "on-click" = "~/.config/hypr/eww/scripts/waybar/bar_menu";
          "tooltip" = false;
        };

        "keyboard-state" = {
          "numlock" = true;
          "capslock" = true;
          "format" = "{name} {icon}";
          "format-icons" = {
              "locked" = "";
              "unlocked" = "";
          };
        };




        "custom/nix" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "wlogout";
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "all-outputs" = true;
          "format-icons" = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六"; 
            "7" = "七"; 
            "8" = "八"; 
            "9" = "九"; 
            "10" = "十";
          };
        };

        "clock" = {
          "format" = "<span color='#b4befe'> </span>{:%H:%M}";
          "tooltip" = true;
          "tooltip-format" = "{:%Y-%m-%d %a}";
        };

        "cpu" = { "format" = "{usage}% "; };
        "memory" = {
          "interval" = 1;
          "format" = "{}% ";
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons"= ["" "" ""];
        };


        "backlight" = {
          "device" = "intel_backlight";
          "format" = "{percent}% {icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };

        "pulseaudio"= {
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];

          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
        };
        "bluetooth" = {
          "format" = "<span color='#b4befe'></span> {status}";
          "format-disabled" = "";
          "format-connected" = "<span color='#b4befe'></span> {num_connections}";
          "tooltip-format" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}   {device_address}";
        };
        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "tooltip-format" = "{ifname} via {gwaddr} ";
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}%  ";
          "format-plugged" = "{capacity}%  ";
          "format-icons" =  [" " " " " " " " " "];
        };
        "tray" = {
          "spacing" = 10;
        };
      };
    };

    style = ''
* {
    font-family: JetBrainsMono Nerd Font, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 14px;
    font-weight: bold;
}

window#waybar {
    background-color: #1f2223;
    border-bottom: 8px solid #191c1d;
    color: #ebdbb2;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}

/*
window#waybar.empty {
    background-color: transparent;
}
window#waybar.solo {
    background-color: #FFFFFF;
}
*/

window#waybar.termite {
    background-color: #3F3F3F;
}

window#waybar.chromium {
    background-color: #000000;
    border: none;
}

button {
    all: unset;
    background-color: #689d6a;
    color: #282828;
    border: none;
    border-bottom: 8px solid #518554;
    border-radius: 5px;
    margin-left: 4px;
    margin-bottom: 2px;
    font-family: JetBrainsMono Nerd Font, sans-sherif;
    font-weight: bold;
    font-size: 14px;
    padding-left: 15px;
    padding-right: 15px;
    transition: transform 0.1s ease-in-out;
}

button:hover {
    background: inherit;
    background-color: #8ec07c;
    border-bottom: 8px solid #76a765;
}

button.active {
    background: inherit;
    background-color: #7db37e;
    border-bottom: 8px solid #659a68;
}

#mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#custom-swaync,
#custom-menu,
#custom-nix,
#mpd {
    padding: 0 10px;
    color: #ffffff;
}

#window,
#workspaces {
    margin: 0 4px;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
    margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
    margin-right: 0;
}

#window {
    background-color: #303030;
    color: #ebdbb2;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #272727;
    border-radius: 5px;
    margin-bottom: 2px;
    padding-left: 10px;
    padding-right: 10px;
}

#custom-swaync {
    background-color: #689d6a;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 18px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #518554;
    border-radius: 5px;
    margin-bottom: 2px;
    padding-left: 13px;
    padding-right: 9px;
}

#custom-menu {
    background-color: #689d6a;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 18px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #518554;
    border-radius: 5px;
    margin-bottom: 2px;
    padding-left: 14px;
    padding-right: 8px;
}

#custom-powermenu {
    background-color: #e23c2c;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 22px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #cc241d;
    border-radius: 5px;
    margin-bottom: 2px;
    margin-right: 4px;
    padding-left: 14px;
    padding-right: 7px;
}

#clock {
    background-color: #98971a;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #828200;
    border-radius: 5px;
    margin-bottom: 2px;
}

#battery {
    background-color: #5d9da0;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #458588;
    border-radius: 5px;
    margin-bottom: 2px;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #e23c2c;
    color: #1d2021;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #cc241d;
    border-radius: 5px;
    margin-bottom: 2px;
}

label:focus {
    background-color: #000000;
}

#cpu {
    background-color: #689d6a;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #518554;
    border-radius: 5px;
    margin-bottom: 2px;
}

#memory {
    background-color: #c8779b;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #b16286;
    border-radius: 5px;
    margin-bottom: 2px;
}

#disk {
    background-color: #964B00;
}

#backlight {
    background-color: #98bbad;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #80a295;
    border-radius: 5px;
    margin-bottom: 2px;
}

#network {
    background-color: #2980b9;
}

#network.disconnected {
    background-color: #f53c3c;
}

#pulseaudio {
    background-color: #f2b13c;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #d79921;
    border-radius: 5px;
    margin-bottom: 2px;
}

/*
#pulseaudio.muted {
    background-color: #90b1b1;
    color: #2a5c45;
}
*/

#wireplumber {
    background-color: #fff0f5;
    color: #000000;
}

#wireplumber.muted {
    background-color: #f53c3c;
}

#custom-media {
    background-color: #66cc99;
    color: #2a5c45;
    min-width: 100px;
}

#custom-media.custom-spotify {
    background-color: #66cc99;
}

#custom-media.custom-vlc {
    background-color: #ffa000;
}

#temperature {
    background-color: #f0932b;
}

#temperature.critical {
    background-color: #eb4d4b;
}

#tray {
    background-color: #ec7024;
    color: #282828;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-size: 15px;
    font-weight: bold;
    border: none;
    border-bottom: 8px solid #d05806;
    border-radius: 5px;
    margin-bottom: 2px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}

#idle_inhibitor {
    background-color: #2d3436;
}

#idle_inhibitor.activated {
    background-color: #ecf0f1;
    color: #2d3436;
}

#mpd {
    background-color: #66cc99;
    color: #2a5c45;
}

#mpd.disconnected {
    background-color: #f53c3c;
}

#mpd.stopped {
    background-color: #90b1b1;
}

#mpd.paused {
    background-color: #51a37a;
}

#language {
    background: #00b093;
    color: #740864;
    padding: 0 5px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state {
    background: #97e1ad;
    color: #000000;
    padding: 0 0px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state > label {
    padding: 0 5px;
}

#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}

#scratchpad {
    background: rgba(0, 0, 0, 0.2);
}

#scratchpad.empty {
	background-color: transparent;
}

tooltip {
  background-color: #1f2223;
  border: none;
  border-bottom: 8px solid #191c1d;
  border-radius: 5px;
}

tooltip decoration {
  box-shadow: none;
}

tooltip decoration:backdrop {
  box-shadow: none;
}

tooltip label {
  color: #ebdbb2;
  font-family: JetBrainsMono Nerd Font, monospace;
  font-size: 16px;
  padding-left: 5px;
  padding-right: 5px;
  padding-top: 0px;
  padding-bottom: 5px;
}
  '';
  };
}
