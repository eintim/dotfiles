{ config, inputs, pkgs, ...}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''

exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

exec-once = swayosd &
exec-once = waybar &
exec-once = nm-applet --indicator &
exec-once = dunst &
exec-once = nwg-dock-hyprland -d &
exec-once = swww init & sleep 0.1 & swww img ~/Wallpaper/ghibli-japanese-walled-garden.png &



# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto
monitor=eDP-1, 1920x1080@60, 0x0, 1
monitor=DP-1, 3440x1440@50, 1920x0, 1
# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Some default env vars.
env = XCURSOR_SIZE,24

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = de
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = yes
	    clickfinger_behavior = 1
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
        new_optimizations = true
    }


    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
    no_gaps_when_only = 1
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = yes
}

misc {
    # lower the amount of sent frames when nothing is happening on-screen.
    vfr = true
    disable_hyprland_logo = true
    disable_splash_rendering = true
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER
$lock = swaylock --screenshot --clock --indicator --effect-vignette 0.5:0.5 --effect-blur 7x5 --fade-in 0.5

binde=, XF86AudioRaiseVolume, exec, swayosd --output-volume raise
binde=, XF86AudioLowerVolume, exec, swayosd --output-volume lower
bind=, XF86AudioMute, exec, swayosd --output-volume mute-toggle
bind=, XF86AudioMicMute, exec, swayosd --input-volume mute-toggle

bind=, XF86AudioPlay, exec, playerctl play-pause
bind=, XF86AudioPause, exec, playerctl play-pause
bind=, XF86AudioNext, exec, playerctl next
bind=, XF86AudioPrev, exec, playerctl previous

bind=, XF86MonBrightnessUp, exec, swayosd --brightness raise
bind=, XF86MonBrightnessDown, exec, swayosd --brightness lower

bindr=, Caps_Lock, exec, swayosd --caps-lock

bind = , Print, exec, grim -g "$(slurp -d)" - | wl-copy


# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive, 
bind = $mainMod, M, exit, 
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating, 
bind = $mainMod, D, exec, rofi -show drun -show-icons
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, F, fullscreen,
bind = $mainMod, K, exec, wlogout
bind = $mainMod, L, exec, $lock


# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Move window with mainMod + shift + arrow keys
bind = SUPER_SHIFT, left, movewindow, l
bind = SUPER_SHIFT, right, movewindow, r
bind = SUPER_SHIFT, up, movewindow, u
bind = SUPER_SHIFT, down, movewindow, d


# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

bindl =, switch:Lid Switch, exec, $lock
bindl =, switch:on:Lid Switch, exec, $lock & systemctl suspend
    '';
  };
}
