{ fetchFromGitHub, haskell, haskellPackages, ... }:
let

  project-m36-src = fetchFromGitHub {
    owner  = "agentm";
    repo   = "project-m36";
    rev    = "fc9e67a8cae0c290ff6d5d25408e50465c68b9a0";
    sha256 = "0y0q2ni19ln1x109zxzalgcvl2cw9mydcdmffirgzj4zdgb4vhvr";
  };

  haskellPkgs = haskellPackages.override {
    overrides = self: super: {
      extended-reals = haskell.lib.dontCheck super.extended-reals;
      project-m36    = haskell.lib.dontHaddock (haskell.lib.dontCheck (self.callCabal2nix "project-m36" project-m36-src {}));
    };
  };
in {
  src = project-m36-src;
  bin = haskellPkgs.project-m36;
}
