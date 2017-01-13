with import ./common.nix;

let
  machineTemplate = memoryMb: {
    deployment.targetEnv = "virtualbox";
    deployment.virtualbox = {
      memorySize = memoryMb;
    };
  };
in {
  ${machineName} = machineTemplate 512;
}
