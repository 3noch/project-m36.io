{ callPackage, fetchFromGitHub, haskell, ... }:
let
  project-m36-nix = fetchFromGitHub {
    owner  = "3noch";
    repo   = "project-m36";
    rev    = "b3fbf7bb8f2194f43f0da7361d2d67f0fbb5b9d8";
    sha256 = "1kmk8c50hinjkmw3vapy740p7ps7g7m7cgvmvh3n055k7384sc96";
  };
in {
  src = project-m36-nix;
  bin = callPackage "${project-m36-nix}/default.nix" {
    haskellPackages = haskell.packages.ghc802;
  };
}
