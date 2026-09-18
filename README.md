# Nix configuration

This flake manages two machines:

- `xps13`: NixOS on `x86_64-linux`
- `macbook`: nix-darwin on `aarch64-darwin`

Home Manager is integrated into both system configurations. A system rebuild
therefore updates the matching user environment as well.

## Layout

```text
hosts/        Concrete machines, hardware and user composition
modules/home/ Reusable Home Manager features
modules/nixos Reusable NixOS features
modules/darwin Reusable nix-darwin features
packages/     Local packages exposed by the flake
dev-shells/   Development environments exposed by the flake
```

## Rebuild

```console
sudo nixos-rebuild switch --flake .#xps13
darwin-rebuild switch --flake .#macbook
```

