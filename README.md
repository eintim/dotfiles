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
```

## Rebuild

```console
./apply-system.sh xps13 switch    # sudo nixos-rebuild switch --flake .#xps13
./apply-system.sh macbook switch  # sudo darwin-rebuild switch --flake .#macbook
```

Omit `switch` to only build. Run `./update.sh` to update all flake inputs.

