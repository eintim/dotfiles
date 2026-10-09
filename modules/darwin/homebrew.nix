{ ... }:
{
  # Homebrew complements Nix for macOS applications and packages that are
  # easier to consume from their upstream taps. General-purpose CLI tools
  # belong in Home Manager instead.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;

      # Remove formulae and casks that have been migrated to Nix or are no
      # longer part of the declared macOS setup.
      cleanup = "uninstall";
    };

    brews = [
      "herdr"
      "mole"
      "qt"

      # macOS-specific helpers without an equivalent in the current setup.
      "pidof"
    ];

    casks = [
      "android-platform-tools"
      "basictex"
      "bitwarden"
      "claude-code"
      "dotnet-sdk"
      "dotnet-sdk@8"
      "ghostty"
      "rar"
      "stats"
      "whisky"
    ];
  };
}
