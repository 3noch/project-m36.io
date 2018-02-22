{ pkgs, ... }:
let

  # Stackage LTS 9.3
  nixpkgs-version = {
    url    = "https://github.com/NixOS/nixpkgs/archive/2509b629d77511ff5256f920663d541ebc43ea72.zip";
    sha256 = "0lrkjhca2zyi32c2w1ai847w3k46msjq26ny7zq87d1h9ydxkilz";
  };

  projPkgs = import (pkgs.fetchzip nixpkgs-version) {};

  project-m36-src = projPkgs.fetchFromGitHub {
    owner  = "agentm";
    repo   = "project-m36";
    rev    = "64ae3e68a34ec1ce4ebfa8f0c77ebc2917ded166";
    sha256 = "1xr71zmdmrhmrdr7s9zlgljbb8xqgm2j3lxb5d53sprpvmx2zmdd";
  };

  haskellPkgs = projPkgs.haskellPackages.override {
    overrides = self: super: let lib = projPkgs.haskell.lib; in {
      extended-reals = lib.doJailbreak super.extended-reals;  # needs newer version of HUnit
      distributed-process-systest = lib.doJailbreak super.distributed-process-systest;
      distributed-process-extras = lib.doJailbreak super.distributed-process-extras;
      distributed-process-async = lib.doJailbreak super.distributed-process-async;
      distributed-process-client-server = lib.doJailbreak super.distributed-process-client-server;

      project-m36 = lib.dontHaddock (lib.dontCheck (self.callCabal2nix "project-m36" project-m36-src {}));
    };
  };
in {
  src = project-m36-src;
  bin = haskellPkgs.project-m36;
}
