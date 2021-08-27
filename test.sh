#!/usr/bin/env bash

TYPES="hello-passed-src hello-passed-cleaned-src hello-not-passed-src hello-not-passed-cleaned-src"

IFS=$" "

for type in $TYPES; do
    echo "Current type: $type"
    echo "Legacy:"
    nix build -f ./default.nix --argstr type $type && ./result/bin/*
    echo "Flake:"
    nix run .#$type || echo ""
done
