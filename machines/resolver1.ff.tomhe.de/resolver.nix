{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/freifunk
    ../../roles/resolver
  ];

  modules.freifunk.gateway = {
    vxlan.local = "2a01:4f8:171:3242:5054:ff:fefa:a211";
    domains = {
      dom0 = {
        batmanAdvanced.mac = "47:8a:5a:96:18:4e";
        ipv4 = {
          prefixes."10.1.64.0/20" = {};
        };
        ipv6 = {
          prefixes = {
            "fdeb:52c8:d094:1000::/64" = {
              addresses =[
                "fdeb:52c8:d094:1000::53:1"
              ];
            };
            "2a01:4f8:160:97c0::/64" = {
              addresses =[
                "2a01:4f8:160:97c0::53:1"
              ];
            };
          };
        };
      };
    };
  };
}