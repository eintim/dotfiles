#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
target=${1:-}
action=${2:-build}
case "$action" in build|switch) ;; *) echo 'Action must be build or switch.' >&2; exit 2;; esac
case "$target:$(uname -s)" in
  macbook:Darwin)
    if [ "$action" = build ]; then
      exec nix build .#darwinConfigurations.macbook.system
    fi
    exec sudo nix run .#darwin-rebuild -- switch --flake .#macbook
    ;;
  xps13:Linux)
    if [ "$action" = switch ]; then
      exec sudo nixos-rebuild switch --flake .#xps13
    fi
    exec nixos-rebuild build --flake .#xps13
    ;;
  *) echo 'Usage: ./apply-system.sh macbook|xps13 [build|switch] (on matching OS)' >&2; exit 2;;
esac
