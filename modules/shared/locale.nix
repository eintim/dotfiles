let
  timeZone = "Europe/Berlin";
in
{
  flake.modules.darwin.locale.time = { inherit timeZone; };

  flake.modules.nixos.locale = {
    time = { inherit timeZone; };
    i18n.defaultLocale = "en_US.utf8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.utf8";
      LC_IDENTIFICATION = "de_DE.utf8";
      LC_MEASUREMENT = "de_DE.utf8";
      LC_MONETARY = "de_DE.utf8";
      LC_NAME = "de_DE.utf8";
      LC_NUMERIC = "de_DE.utf8";
      LC_PAPER = "de_DE.utf8";
      LC_TELEPHONE = "de_DE.utf8";
      LC_TIME = "de_DE.utf8";
    };
    console.keyMap = "de";
  };
}
