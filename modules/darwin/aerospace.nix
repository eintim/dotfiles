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
      # Four-finger swipes belong to aerospace-swipe. Three fingers are taken by
      # three-finger drag (see macos.nix).
      trackpad.TrackpadFourFingerHorizSwipeGesture = 0;
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

  flake.modules.homeManager.aerospace =
    { pkgs, ... }:
    let
      # Switches workspaces with horizontal trackpad swipes. Not packaged in
      # nixpkgs or Homebrew. Built as an app bundle so it shows up by name when
      # granting Accessibility access, which has to be done again after every
      # update because the store path changes.
      aerospace-swipe = pkgs.stdenv.mkDerivation {
        pname = "aerospace-swipe";
        version = "0-unstable-2026-09-16";

        src = pkgs.fetchFromGitHub {
          owner = "acsandmann";
          repo = "aerospace-swipe";
          rev = "7e06fe41e0deff786a643bf4d56963104c459c12";
          hash = "sha256-97vCTspK+0JXfYUw7PiRK7ST9YhIV/Ra0VO/W7FeTUw=";
        };

        # The upstream makefile builds with -march=native and installs into the
        # source checkout, so compile directly instead.
        buildPhase = ''
          runHook preBuild
          $CC -std=c99 -O2 -fobjc-arc -o AerospaceSwipe \
            src/aerospace.c src/yyjson.c src/haptic.c src/event_tap.m src/main.m \
            -framework CoreFoundation -framework IOKit -framework ApplicationServices -framework Cocoa \
            -F/System/Library/PrivateFrameworks -framework MultitouchSupport -ldl
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          app=$out/Applications/AerospaceSwipe.app/Contents
          install -Dm755 AerospaceSwipe $app/MacOS/AerospaceSwipe
          cat > $app/Info.plist <<EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleExecutable</key><string>AerospaceSwipe</string>
            <key>CFBundleIdentifier</key><string>com.acsandmann.swipe</string>
            <key>CFBundleName</key><string>AerospaceSwipe</string>
            <key>CFBundlePackageType</key><string>APPL</string>
            <key>LSUIElement</key><true/>
          </dict>
          </plist>
          EOF
          runHook postInstall
        '';
      };
    in
    {
      # Read from ~/.config regardless of XDG_CONFIG_HOME. Swipe right moves to
      # the next workspace.
      home.file.".config/aerospace-swipe/config.json".text = builtins.toJSON {
        fingers = 4;
        natural_swipe = true;
        skip_empty = true;
        wrap_around = true;
      };

      launchd.agents.aerospace-swipe = {
        enable = true;
        config = {
          ProgramArguments = [
            "${aerospace-swipe}/Applications/AerospaceSwipe.app/Contents/MacOS/AerospaceSwipe"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Interactive";
          LimitLoadToSessionType = "Aqua";
          StandardErrorPath = "/tmp/aerospace-swipe.err";
        };
      };

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
