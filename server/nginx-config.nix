# References:
# https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/
# https://www.nginx.com/blog/9-tips-for-improving-wordpress-performance-with-nginx/
# https://easyengine.io/wordpress-nginx/tutorials/single-site/fastcgi-cache-with-purging/

{ config              # machine configuration
, pkgs

, host                # host for this site
, hostRedirects ? []  # list of hosts that redirect to the primary host
, appRoot             # root directory to serve
, websocketServer     # URL to websocket server to proxy wobsocket connections to.
, enableHttps         # serve the site over HTTPS only?
, acmeChallengesDir   # directory where ACME (Let's Encrypt) challenges are stored
}:
let
  rootUrl = (if enableHttps then "https" else "http") + "://" + host;

  fullNginxConfig = ''
    map $http_upgrade $connection_upgrade {
      default upgrade;
      ${"''"} close;
    }

    ${if enableHttps then secureConfig else insecureConfig}
  '';

  secureConfig = ''
    server {
      server_name ${host};
      ${listenPart.insecure}

      location /.well-known/acme-challenge {
        root "${acmeChallengesDir}";
      }

      location / {
        return 301 https://${host}$request_uri;
      }
    }

    ${hostRedirectsConfig "https"}

    server {
      server_name ${host};
      ${listenPart.secure}

      ${tlsPart}
      ${serverPart}
    }
  '';

  insecureConfig = ''
    server {
      server_name ${host};
      ${listenPart.insecure}

      ${serverPart}
    }

    ${hostRedirectsConfig "http"}
  '';

  hostRedirectsConfig = targetScheme: pkgs.lib.optionalString (hostRedirects != []) ''
    server {
      server_name ${pkgs.lib.concatStringsSep " " hostRedirects};
      ${listenPart.insecure}
      return 301 ${targetScheme}://${host}$request_uri;
    }
  '';

  # Listen for both IPv4 & IPv6 requests with http2 enabled
  listenPart = {
    secure = ''
      listen 443 ssl http2;
      listen [::]:443 ssl http2;
    '';

    insecure = ''
      listen 80;
      listen [::]:80;
    '';
  };

  tlsPart = ''
    # SSL/TLS configuration, with TLS1 disabled
    ssl_certificate     ${config.security.acme.directory}/${host}/fullchain.pem;
    ssl_certificate_key ${config.security.acme.directory}/${host}/key.pem;
    ssl_protocols TLSv1.2 TLSv1.1;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4";
    ssl_session_timeout 30m;
    ssl_session_cache shared:SSL:50m;
    ssl_stapling on;
    ssl_stapling_verify on;

    #ssl_dhparam /etc/ssl/certs/dhparam.pem;
  '';

  serverPart = ''
    root "${appRoot}";
    index index.html index.htm websocket-client.html;
    charset utf-8;

    location /ws {
        proxy_pass "${websocketServer}";
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    # 301 Redirect URLs with trailing /'s as per https://webmasters.googleblog.com/2010/04/to-slash-or-not-to-slash.html
    #rewrite ^/(.*)/$ /$1 permanent;

    # Change // -> / for all URLs
    #merge_slashes off;
    #rewrite (.*)//+(.*) $1/$2 permanent;

    # Don't send the nginx version number in error pages and Server header
    server_tokens off;

    # Load configuration files from nginx-partials
    #include ${./nginx-partials}/*.conf;

    # Misc settings
    #sendfile off;
    #client_max_body_size 100m;
  '';

in fullNginxConfig
