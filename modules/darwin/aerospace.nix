{ lib, ... }:
let
  # What Caps Lock sends while held (see karabiner.nix). Shift is left out, so
  # Caps Lock+Shift is a second layer.
  mod = "ctrl-alt-cmd";

  directions = {
    h = "left";
    j = "down";
    k = "up";
    l = "right";
  };

  workspaces = map toString (lib.range 1 9);
in
{
  flake.modules.darwin.aerospace = {
    system.defaults = {
      # Show windows grouped by app in Mission Control, so AeroSpace's hidden
      # windows stay readable there.
      dock.expose-group-apps = true;
      # Ctrl+Cmd drag moves a window from anywhere inside it.
      NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    };

    # Border around the focused window, which is hard to spot between tiles.
    services.jankyborders = {
      enable = true;
      width = 4.0;
      hidpi = true;
      active_color = "0xff5e9eff";
      inactive_color = "0x00000000";
    };
  };

  flake.modules.homeManager.aerospace = {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;

      settings = {
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };

        # Moving focus to another monitor moves the mouse along with it.
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        mode.main.binding =
          lib.concatMapAttrs (key: dir: {
            "${mod}-${key}" = "focus ${dir}";
            "${mod}-shift-${key}" = "move ${dir}";
          }) directions
          // lib.mergeAttrsList (
            map (ws: {
              "${mod}-${ws}" = "workspace ${ws}";
              "${mod}-shift-${ws}" = "move-node-to-workspace ${ws}";
            }) workspaces
          )
          # AeroSpace binds physical keys in US positions, so only keys that
          # sit in the same place on a German layout are used: no punctuation,
          # and no Y or Z.
          // {
            "${mod}-t" = "layout tiles horizontal vertical";
            "${mod}-a" = "layout accordion horizontal vertical";
            "${mod}-f" = "fullscreen";
            "${mod}-shift-space" = "layout floating tiling";
            "${mod}-tab" = "workspace-back-and-forth";
            "${mod}-shift-tab" = "move-workspace-to-monitor --wrap-around next";
            "${mod}-r" = "mode resize";
            "${mod}-shift-r" = "mode service";
          };

        # Resize with H/J/K/L, leave with Enter or Esc.
        mode.resize.binding = {
          h = "resize width -50";
          l = "resize width +50";
          j = "resize height +50";
          k = "resize height -50";
          enter = "mode main";
          esc = "mode main";
        };

        # Rarely used commands, left with Esc.
        mode.service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          # Reset the layout of the current workspace.
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];
        };

        # Small utility windows float instead of being squeezed into the tree.
        on-window-detected =
          map
            (appId: {
              "if".app-id = appId;
              run = "layout floating";
            })
            [
              "com.apple.systempreferences"
              "com.apple.ActivityMonitor"
              "com.apple.calculator"
              "com.bitwarden.desktop"
            ];
      };
    };
  };
}
