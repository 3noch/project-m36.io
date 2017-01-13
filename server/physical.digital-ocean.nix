with import ./common.nix;

{ dropletRegion, dropletSize }: {
  resources.sshKeyPairs.ssh-key = {};

  ${machineName} = {...}: {
    deployment = {
      targetEnv = "digitalOcean";
      digitalOcean = {
        region    = dropletRegion;
        size      = dropletSize;
      };
    };
  };
}
