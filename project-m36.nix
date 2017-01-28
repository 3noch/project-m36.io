{ callPackage, fetchFromGitHub, haskell, ... }:
let
  project-m36-nix = fetchFromGitHub {
    owner  = "3noch";
    repo   = "project-m36";
    rev    = "d8c338507ce0ccd203cc0487847142685f9642bd";
    sha256 = "1a937kz3i70k8rr1cqycnxpzwp7n2jl9p7ws9fh3gqzwza4jjrl5";
  };
in {
  src = project-m36-nix;
  bin = callPackage "${project-m36-nix}/default.nix" {
    haskellPackages = haskell.packages.ghc802;
  };
}
