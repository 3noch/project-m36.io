import ./logical.nix {
  host           = "try.project-m36.dev";
  hostRedirects  = [];
  enableHttps    = false;
  enableRollback = false;
}
