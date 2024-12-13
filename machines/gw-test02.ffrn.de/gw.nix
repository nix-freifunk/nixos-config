{ name, config, lib, pkgs, ... }:
{
  imports = [
    ../../roles/gw
  ];

  services.freifunk.bird = {
    routerId = "10.42.21.2";
    localAdresses = [
      "fdeb:52c8:d094:a::55:1" # ns1
      "fdeb:52c8:d094:a::56:1" # ns2
    ];
  };

  modules.freifunk.gateway = {
    vxlan.local = "2a01:4f8:140:4093:5054:ff:fe02:e2a6";
    domains = {
      dom0 = {
        batmanAdvanced = {
          mac = "0a:c4:b9:de:ff:c7";
        };
        ipv4 = {
          prefixes = {
            "10.1.64.0/20" = {
              addresses =[
                "10.1.65.1"
              ];
            };
          };
          dhcpV4 = {
            pools = [
              "10.1.65.8 - 10.1.65.255"
            ];
          };
          
        };
        ipv6 = {
          prefixes = {
            "fdeb:52c8:d094:1000::/64" = {
              addresses =[
                "fdeb:52c8:d094:1000::2"
              ];
            };
            "2a01:4f8:160:97c0::/64" = {
              addresses =[
                "2a01:4f8:160:97c0::2"
              ];
              # announce = false;
            };
          };
        };
      };
    };
  };

}
