{ fetchFromGitHub, haskell, haskellPackages, ... }:
let

  project-m36-src = fetchFromGitHub {
    owner  = "agentm";
    repo   = "project-m36";
    rev    = "9cfdd630d81ef88c9c9db5def386058fb56af9c5";
    sha256 = "1gzhw9p88c5zld9qh0p199xf046k5ra7ylaygvjis30scy8kggjl";
  };

  haskellPkgs = haskellPackages.override {
    overrides = self: super: {
      distributed-process-client-server = haskell.lib.dontCheck (haskell.lib.doJailbreak super.distributed-process-client-server);
      distributed-process-extras = haskell.lib.doJailbreak super.distributed-process-extras;
      megaparsec = self.callHackage "megaparsec" "4.4.0" {};
      persistent = super.persistent_2_2_4_1;
      persistent-template = super.persistent-template_2_1_8_1;
      project-m36 = haskell.lib.dontHaddock (haskell.lib.dontCheck (self.callCabal2nix project-m36-src {}));
    };
  };
in {
  src = project-m36-src;
  bin = haskellPkgs.project-m36;
}
