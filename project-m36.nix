{ fetchFromGitHub, haskell, haskellPackages, ... }:
let

  project-m36-src = fetchFromGitHub {
    owner  = "agentm";
    repo   = "project-m36";
    rev    = "8247956b3ceea95a9ab3b02be9abfcafb6393952";
    sha256 = "1cirplnxmkncvy4d9m5zmpb6qw065sy6ayzhvzxb21vn5h48i7am";
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
