import ./logical.nix {
  host           = "try.project-m36.io";
  hostRedirects  = [];
  enableHttps    = true;
  enableRollback = true;
}
