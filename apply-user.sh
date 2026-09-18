#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
target=${1:-}
action=${2:-build}
case "$action" in build|switch) ;; *) echo 'Action must be build or switch.' >&2; exit 2;; esac
case "$target:$(uname -s)" in
  macbook:Darwin)
    exec nix run .#home-manager -- "$action" --flake '.#eintim@macbook'
    ;;
  tim:Linux)
    exec home-manager "$action" --flake .#tim
    ;;
  *) echo 'Usage: ./apply-user.sh macbook|tim [build|switch] (on matching OS)' >&2; exit 2;;
esac
