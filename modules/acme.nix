{ lib, config, name, ... }:

{

  age.secrets."acme" = {
    file = ../secrets/${name}/acme.age;
    mode = "0400";
    owner = "root";
    group = "root";
  };

  security.acme = {
    defaults = {
      email = "freifunk-webmaster@tomherbers.de";
      dnsProvider = "rfc2136";
      credentialsFile = config.age.secrets."acme".path;
    };
    acceptTerms = true;
  };
}
