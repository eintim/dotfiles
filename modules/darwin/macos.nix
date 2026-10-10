{
  flake.modules.darwin.macos = {
    system.defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.15;
        minimize-to-application = true;
        # Keep Spaces in a fixed order.
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
        tilesize = 52;
      };

      finder = {
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCev";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        # Empty the Trash after 30 days.
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        # Tab moves between all controls in dialogs.
        AppleKeyboardUIMode = 3;
        AppleShowAllExtensions = true;
        # Holding a key repeats it instead of showing the accent popup.
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      screencapture.disable-shadow = true;

      loginwindow.GuestEnabled = false;

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      # No .DS_Store files on network shares and USB drives.
      CustomUserPreferences."com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };

    system.startup.chime = false;

    networking.applicationFirewall = {
      enable = true;
      enableStealthMode = true;
    };

    # Touch ID for sudo, also inside tmux sessions.
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      reattach = true;
    };
  };

  flake.modules.homeManager.macos =
    { config, pkgs, ... }:
    {
      # macOS ships bash 3.2.
      home.packages = [ pkgs.bash ];

      programs.zsh = {
        dotDir = config.home.homeDirectory;
        history.path = "${config.home.homeDirectory}/.zsh_history";
        oh-my-zsh.theme = "robbyrussell";

        # .zshenv is read by every zsh, so PATH is the same in login and
        # non-login shells.
        envExtra = ''
          typeset -U path

          if [[ -r "$HOME/.cargo/env" ]]; then
            source "$HOME/.cargo/env"
          fi
          path=("$HOME/.local/bin" $path)

          # Append Homebrew so Nix packages take precedence.
          if [[ -x /opt/homebrew/bin/brew ]]; then
            export HOMEBREW_PREFIX=/opt/homebrew
            export HOMEBREW_CELLAR=/opt/homebrew/Cellar
            export HOMEBREW_REPOSITORY=/opt/homebrew
            path+=(/opt/homebrew/bin /opt/homebrew/sbin)
            fpath+=(/opt/homebrew/share/zsh/site-functions)
          fi

          path+=("$HOME/.antigravity/antigravity/bin")
        '';
      };
    };
}
