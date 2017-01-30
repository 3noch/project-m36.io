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

    websocketPort = 8888;

    nginxConfig = import ./nginx-config.nix {
      inherit config pkgs acmeChallengesDir enableHttps host hostRedirects;
      appRoot = "${project-m36-parts.src}/src/bin/ProjectM36/Server/WebSocket";
      websocketServer = "http://127.0.0.1:${toString websocketPort}";
    };

    project-m36-parts = pkgs.callPackage ../project-m36.nix {};
    project-m36 = project-m36-parts.bin;
  in {
    networking = {
      hostName = "project-m36-main";
      firewall.allowedTCPPorts = [80] ++ pkgs.lib.optional enableHttps 443;
    };

    environment.systemPackages = with pkgs; [
      gzip htop lsof unzip nix-repl vim zip
      project-m36
    ];

    services.nginx = {
      enable     = true;
      httpConfig = nginxConfig;
      user = "root";
    };

    systemd.services.project-m36-websocket = {
      description   = "Project:M36 WebSocket Server";
      wantedBy      = [ "multi-user.target" "nginx" ];
      after         = [ "network.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = pkgs.writeScript "start-websocket-server" ''
          #!${pkgs.bash}/bin/bash
          HOME=/root ${project-m36}/bin/project-m36-websocket-server --port ${toString websocketPort} -n test --timeout 5000000
        '';
      };
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
