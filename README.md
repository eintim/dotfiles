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

[nh](https://github.com/nix-community/nh) is installed on both machines
and knows where this repository lives, so it works from any directory. It
shows the package changes before switching.

```console
nh os switch            # xps13
nh darwin switch        # macbook
nh darwin switch --update   # update flake inputs, then switch
nh darwin build         # build only
```

Before nh is installed, bootstrap with the plain commands:

```console
sudo nixos-rebuild switch --flake .#xps13
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#macbook
```

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
