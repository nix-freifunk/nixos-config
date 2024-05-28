{ lib, config, name, ... }:

{

  deployment.keys."acme-environment" = {
    keyFile = ../secrets/acme/${name};
    destDir = "/run/keys/acme";
    name = "environment";
    user = "root";
    group = "root";
    permissions = "0400";
    uploadAt = "pre-activation";
  };

  security.acme = {
    defaults = {
      email = "freifunk-webmaster@tomherbers.de";
      dnsProvider = "rfc2136";
      credentialsFile = "${config.deployment.keys.acme-environment.destDir}/${config.deployment.keys.acme-environment.name}";
    };
    acceptTerms = true;
  };
}
