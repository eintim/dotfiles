#!/bin/sh
pushd ~/nixos-config
home-manager switch -f ./users/tim/home.nix
popd
