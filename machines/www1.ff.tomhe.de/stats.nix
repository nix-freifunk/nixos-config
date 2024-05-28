{config, pkgs, lib, ...}:
{
  imports = [
    ../../modules/acme.nix
  ];

  services.influxdb = {
    enable = true;
  };


  deployment.keys."influxdb-basicAuth" = {
    keyFile = ../../secrets/influxdb-basicAuth;
    destDir = "/etc/nginx/influxdb-basicAuth";
    name = "influxdb";
    user = "root";
    group = "root";
    permissions = "0400";
    uploadAt = "pre-activation";
  };

  # credentialsFile = "${config.deployment.keys.acme-environment.destDir}/${config.deployment.keys.acme-environment.name}";

  services.nginx = lib.mkIf config.services.influxdb.enable {
    enable = lib.mkDefault true;
    virtualHosts."influxdb.${config.networking.domain}" = {
      locations."/" = {
        # return = "200 'influxdb'";
        proxyPass = "http://127.0.0.1:8086";
        # extraConfig = ''
        #   default_type text/plain;
        # '';
        recommendedProxySettings = true;
        basicAuthFile = "${config.deployment.keys.influxdb-basicAuth.destDir}/${config.deployment.keys.influxdb-basicAuth.name}";
      };
      basicAuthFile = "${config.deployment.keys.influxdb-basicAuth.destDir}/${config.deployment.keys.influxdb-basicAuth.name}";

      # locations."/data/".alias = "/var/www/html/meshviewer/data/";
      useACMEHost = "${config.networking.hostName}.${config.networking.domain}";
      forceSSL = true;
    };
  };


  # services.grafana = {
  #   enable = true
  # };

  security.acme = {
    certs."${config.networking.hostName}.${config.networking.domain}" = {
      extraDomainNames = []
      ++ (if config.services.influxdb.enable then [ "influxdb.${config.networking.domain}" ] else []);
    };
  };

  users.groups."${config.security.acme.certs."${config.networking.hostName}.${config.networking.domain}".group}" = {
    members = [ "${config.services.nginx.user}" ];
  };
}