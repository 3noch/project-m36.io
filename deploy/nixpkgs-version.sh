#!/usr/bin/env bash
export nixpkgs_channel="https://nixos.org/channels/nixpkgs-unstable"
export nixpkgs_snapshot="https://d3g5gsiof5omrk.cloudfront.net/nixpkgs/nixpkgs-17.03pre100133.a14217e/nixexprs.tar.xz"

if [ "$(uname)" == "Darwin" ]; then
  export nixops_version="/nix/store/jcvvin1i87vin4hwldz0b68sd64n0ly0-nixops-1.5pre2127_c3b164a"
else
  export nixops_version="/nix/store/axd7sljp4hyrx9qc78m082d7v8nqmxrx-nixops-1.5pre2127_c3b164a"
fi

if [ ! -d "$nixops_version" ]; then
  nix-store -r "$nixops_version"
fi
