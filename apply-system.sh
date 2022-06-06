#!/bin/sh
pushd ~/nixos-config
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
