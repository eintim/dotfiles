{
  flake.modules.darwin.karabiner = {
    # Not services.karabiner-elements: since Karabiner 15 its background
    # services must be registered from an app in /Applications, so the
    # nix-darwin module fails to start them.
    homebrew.casks = [ "karabiner-elements" ];

    # Karabiner handles Caps Lock now. Key mapping stays enabled with no
    # mappings, so activation clears the old hidutil Caps Lock remap, which
    # would otherwise hide the real key from Karabiner.
    system.keyboard.enableKeyMapping = true;
  };

  flake.modules.homeManager.karabiner = {
    # Karabiner rewrites this file when settings change in its GUI. As a
    # read-only link those changes fail, so settings belong here instead.
    home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
      profiles = [
        {
          name = "Default";
          selected = true;
          # The built-in keyboard is ISO. With the default ANSI type, the
          # virtual keyboard swaps the < and ^ keys on German layouts.
          virtual_hid_keyboard.keyboard_type_v2 = "iso";
          complex_modifications.rules = [
            {
              description = "Caps Lock: Escape when tapped, Ctrl+Option+Cmd when held";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                    modifiers.optional = [ "any" ];
                  };
                  to = [
                    {
                      key_code = "left_control";
                      modifiers = [
                        "left_option"
                        "left_command"
                      ];
                    }
                  ];
                  to_if_alone = [ { key_code = "escape"; } ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
