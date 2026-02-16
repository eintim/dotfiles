#!/bin/sh
# Usage: ./apply-system.sh [HOST]
# If HOST is omitted, uses current hostname (must match flake: xps13 or vm).
HOST="${1:-$(hostname)}"
pushd ~/nixos-config
sudo nixos-rebuild switch --flake ".#${HOST}"
popd
