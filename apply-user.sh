#!/bin/sh
pushd ~/nixos-config
home-manager switch --flake .#tim
popd
