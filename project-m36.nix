{ callPackage, fetchFromGitHub, haskell, ... }:
let
  project-m36-nix = fetchFromGitHub {
    owner  = "3noch";
    repo   = "project-m36";
    rev    = "bf783b65577a7c40305731edc3326f0caa7ef29b";
    sha256 = "10vnqay7kyw54a0lmmzfcrxr2z6jcj2gbdcrsqr4q6lqgd0wjz7w";
  };
in {
  src = project-m36-nix;
  bin = callPackage "${project-m36-nix}/default.nix" {
    haskellPackages = haskell.packages.ghc802;
  };
}
