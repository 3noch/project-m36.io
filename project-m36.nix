{ callPackage, fetchFromGitHub, haskell, ... }:
let
  project-m36-nix = fetchFromGitHub {
    owner  = "3noch";
    repo   = "project-m36";
    rev    = "df84953caf3370632c2b6351956c53648f6681a5";
    sha256 = "0s7lfpa83wpbclrvkkn6qlwj56hifiab9dx1w6z0ks6bnllmav0i";
  };
in {
  src = project-m36-nix;
  bin = callPackage "${project-m36-nix}/default.nix" {
    haskellPackages = haskell.packages.ghc802;
  };
}
