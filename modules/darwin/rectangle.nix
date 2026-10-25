let
  # What Caps Lock sends while held (see karabiner.nix): Ctrl+Option+Cmd, as
  # macOS modifier flags. Adding Shift gives a second layer.
  hyper = 1835008;
  hyperShift = hyper + 131072;

  # Rectangle binds virtual key codes, which name physical keys in US
  # positions, so only keys that sit in the same place on a German layout are
  # used: no punctuation, and no Y or Z.
  keys = {
    h = 4;
    j = 38;
    k = 40;
    l = 37;
    u = 32;
    i = 34;
    o = 31;
    c = 8;
    f = 3;
    backspace = 51;
  };

  bind = modifierFlags: key: {
    keyCode = keys.${key};
    inherit modifierFlags;
  };
in
{
  flake.modules.darwin.rectangle = {
    # From Homebrew rather than nixpkgs: Accessibility access is tied to the
    # app's path, and a store path changes with every update.
    homebrew.casks = [ "rectangle" ];

    # macOS's own tiling would compete with Rectangle's snap areas when a
    # window is dragged to a screen edge.
    system.defaults.WindowManager = {
      EnableTilingByEdgeDrag = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
    };

    # Rectangle reads its settings at launch, so changes take effect after
    # quitting and reopening it.
    system.defaults.CustomUserPreferences."com.knollsoft.Rectangle" = {
      launchOnLogin = true;
      # Use Rectangle's own shortcuts for actions not bound below, not
      # Spectacle's.
      alternateDefaultShortcuts = true;
      gapSize = 0.0;

      leftHalf = bind hyper "h";
      bottomHalf = bind hyper "j";
      topHalf = bind hyper "k";
      rightHalf = bind hyper "l";

      firstThird = bind hyper "u";
      centerThird = bind hyper "i";
      lastThird = bind hyper "o";
      firstTwoThirds = bind hyperShift "u";
      lastTwoThirds = bind hyperShift "o";

      maximize = bind hyper "f";
      center = bind hyper "c";
      restore = bind hyper "backspace";

      previousDisplay = bind hyperShift "h";
      nextDisplay = bind hyperShift "l";
    };
  };
}
