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

    taps = [
      "anomalyco/tap"
      "charmbracelet/tap"
      "jesseduffield/lazygit"
    ];

    brews = [
      "herdr"
      "mkcert"
      "mole"

      # Keep language runtimes and their version managers together until
      # they are migrated to project-specific Nix development shells.
      "node@24"
      "openjdk@21"
      "pnpm"
      "pyenv"
      "python@3.13"
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
