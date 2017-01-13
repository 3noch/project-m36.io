# Logical definition of our server

with import ./common.nix;

{ host
, hostRedirects
, adminEmail ? "admin@graftedindesign.com"
, enableHttps
, enableRollback
}:
{
  network = {
    inherit enableRollback;
    description = "Project:M36";
  };

  ${machineName} = { config, pkgs, ... }: let
    acmeChallengesDir = "/var/www/challenges";

    nginxConfig = import ./nginx-config.nix {
      inherit config pkgs acmeChallengesDir enableHttps host hostRedirects;
      appRoot = "";
    };
  in {
    networking = {
      hostName = "project-m36-main";
      firewall.allowedTCPPorts = [80] ++ pkgs.lib.optional enableHttps 443;
    };

    environment.systemPackages = with pkgs; [
      gzip htop unzip nix-repl vim zip
    ];

    services.nginx = {
      enable     = true;
      httpConfig = nginxConfig;
    };

    users = {
      mutableUsers = false;
      extraUsers   = import ./users.keys.nix;
    };

  } // (
    if enableHttps then {
      security.acme.certs.${host} = {
        webroot = acmeChallengesDir;
        email   = adminEmail;
        postRun = "systemctl reload nginx.service";
      };
    } else {}
  );
}
