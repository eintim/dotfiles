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
modules/shared Modules for both NixOS and nix-darwin
templates/    Flake templates
```

## Rebuild

```console
./apply-system.sh xps13 switch    # sudo nixos-rebuild switch --flake .#xps13
./apply-system.sh macbook switch  # sudo darwin-rebuild switch --flake .#macbook
```

Omit `switch` to only build. Run `./update.sh` to update all flake inputs.

## Project dev shells

Language runtimes installed globally are only defaults. A project that
needs specific tool versions gets its own dev shell, which direnv loads
when entering the directory:

```console
cd ~/dev/my-project
nix flake init -t ~/dev/dotfiles#devshell
direnv allow
```

Edit the `packages` list in the generated `flake.nix` as needed. Python
projects can use `uv` instead (`uv python pin 3.12`, `uv sync`).
