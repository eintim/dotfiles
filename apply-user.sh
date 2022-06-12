#!/bin/sh
pushd ~/nixos-config
nix build .#homeManagerConfigurations.tim.activationPackage
./result/activate
popd
