{config, pkgs, lib, name, ...}:
{
  imports = [
    ../../modules/acme.nix
  ];

  services.influxdb = {
    enable = true;
  };

  age.secrets."influxdb-basicAuth" = {
    file = ../../secrets/${name}/influxdb-basicAuth.age;
    mode = "0400";
    owner = "root";
    group = "root";
  };

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
        basicAuthFile = config.age.secrets."influxdb-basicAuth".path;
      };
      basicAuthFile = config.age.secrets."influxdb-basicAuth".path;

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
