# Nix configuration

This flake manages three machines:

- `xps13`: NixOS on `x86_64-linux`
- `nuc`: headless NixOS server on `x86_64-linux`
- `macbook`: nix-darwin on `aarch64-darwin`

Home Manager is integrated into both system configurations. A system rebuild
therefore updates the matching user environment as well.

## Layout

The flake follows the [dendritic pattern](https://github.com/mightyiam/dendritic):
every file under `modules/` is a [flake-parts](https://flake.parts) module,
imported automatically by [import-tree](https://github.com/vic/import-tree).
Each file is one feature and configures every class it touches, for example
`shell.nix` sets up zsh for both NixOS and Home Manager:

```nix
{
  flake.modules.nixos.shell = { pkgs, ... }: { users.defaultUserShell = pkgs.zsh; };
  flake.modules.homeManager.shell = { programs.zsh.enable = true; };
}
```

```text
modules/shared/  Features for both machines
modules/darwin/  macOS-only features
modules/nixos/   NixOS-only features
modules/flake/   Flake plumbing: checks, formatter, templates
modules/hosts/   Machines: hardware, users and the features they import
templates/       Flake templates
```

Folders only sort features by platform. A feature that applies to both
machines stays a single file in `shared/`, even when it configures
different classes on each.

Hosts pick features from `config.flake.modules.<class>`. Files can be
moved or renamed freely; paths starting with `_` are skipped by
import-tree and imported explicitly (e.g. the generated hardware
configuration).

## Rebuild

[nh](https://github.com/nix-community/nh) is installed on both machines
and knows where this repository lives, so it works from any directory. It
shows the package changes before switching.

```console
nh os switch            # xps13, nuc
nh darwin switch        # macbook
nh darwin switch --update   # update flake inputs, then switch
nh darwin build         # build only
```

Before nh is installed, bootstrap with the plain commands:

```console
sudo nixos-rebuild switch --flake .#xps13   # or .#nuc
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
