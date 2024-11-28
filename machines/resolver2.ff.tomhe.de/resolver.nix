{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/freifunk
    ../../roles/resolver
  ];

  modules.freifunk.gateway = {
    vxlan.local = "2a01:4f8:140:4093:5054:ff:fe2c:c94b";
    domains = {
      dom0 = {
        batmanAdvanced.mac = "b6:38:a8:1d:8c:b3";
        ipv4 = {
          prefixes."10.1.64.0/20" = {};
        };
        ipv6 = {
          prefixes = {
            "fdeb:52c8:d094:1000::/64" = {
              addresses =[
                "fdeb:52c8:d094:1000::53:2"
              ];
            };
            "2a01:4f8:160:97c0::/64" = {
              addresses =[
                "2a01:4f8:160:97c0::53:2"
              ];
            };
          };
        };
      };
    };
  };
}