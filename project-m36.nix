{ fetchFromGitHub, haskell, haskellPackages, ... }:
let

  project-m36-src = fetchFromGitHub {
    owner  = "agentm";
    repo   = "project-m36";
    rev    = "308de71a027f61752a93aa73bb561ed8b44ddbca";
    sha256 = "112c5hq996b2aa4lf75spq69zw5cbqhrv82b9wc68bs4fgh3h7m4";
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
