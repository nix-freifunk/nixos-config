{ name, config, lib, pkgs, ... }:
{
  imports = [
    ../../roles/gw
  ];

  services.nginx.virtualHosts."default" = {
    default = true;
    rejectSSL = true;
    locations."/" = {
      return = "200 \"<!DOCTYPE html><html><head></head><body><h1>${config.networking.fqdnOrHostName}</h1></body></html>\"";
      extraConfig = "default_type text/html;";
    };
    # locations."/".return = "200 \"<!DOCTYPE html><h1>${config.networking.fqdnOrHostName}</h1>\"</html>";
  };

  services.freifunk.bird = {
    routerId = "10.42.21.1";
    localAdresses = [
      "fdeb:52c8:d094:a::55:1" # ns1
      "fdeb:52c8:d094:a::56:1" # ns2
    ];
  };

  services.yanic.autostart = true;

  modules.freifunk.gateway = {
    outInterfaces = [ config.systemd.network.networks."10-mainif".matchConfig.Name ];
    vxlan.local = "2a01:4f8:160:624c:5054:ff:fe6b:6397";
    domains = {
      dom0 = {
        batmanAdvanced = {
          mac = "82:82:49:55:29:d0";
        };
        ipv4 = {
          dhcpV4 = {
            pools = [
              "10.1.64.8 - 10.1.64.255"
            ];
          };
          prefixes = {
            "10.1.64.0/20" = {
              addresses =[
                "10.1.64.1"
              ];
            };
          };
        };
        ipv6 = {
          prefixes = {
            "fdeb:52c8:d094:1000::/64" = {
              addresses =[
                "fdeb:52c8:d094:1000::1"
              ];
            };
            "2a01:4f8:160:97c0::/64" = {
              addresses =[
                "2a01:4f8:160:97c0::1"
              ];
            };
          };
        };
      };
    };
  };

}
