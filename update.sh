#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [ "$#" -ne 0 ]; then
  echo 'Usage: ./update.sh' >&2
  exit 2
fi

exec nix flake update
