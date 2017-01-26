{ callPackage, fetchFromGitHub, ... }:
let
  project-m36-nix = fetchFromGitHub {
    owner  = "3noch";
    repo   = "project-m36";
    rev    = "a8a9734126298f6acea4d8a41a02bae1cb7422a5";
    sha256 = "1r4zmar0d6z8z4vhp1vx63x7jf2ln0xgzry92kv4kak2yv9ghwkv";
  };
in callPackage "${project-m36-nix}/default.nix" {}
