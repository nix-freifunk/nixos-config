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
    extraConfig = ''
      protocol radv radv_dom0 {
        propagate routes no;

        ipv6 {
          table master6;
          export all;
          import none;
        };

        interface "bat-dom0" {
          min delay 3;
          max ra interval 60;
          solicited ra unicast yes;
          prefix  fdeb:52c8:d094:1000::/64 {
            valid lifetime 3600;
            preferred lifetime 1800;
          };
          rdnss {
            lifetime mult 10;
            ns fdeb:52c8:d094:1000::1:1;
          };
          dnssl {
            domain "ff.tomhe.de";
          };
          link mtu 1280;

          # custom option type 38 value hex:0e:10:20:01:06:7c:29:60:64:64:00:00:00:00;
          # custom option type 38 value hex:0e:10:00:64:ff:9b:00:00:00:00:00:00:00:00;
        };

        prefix ::/0 {
          skip;
        };
      }
    '';
  };

  modules.freifunk.gateway = {
    vxlan.local = "2a01:4f8:140:4093:5054:ff:fe02:e2a6";
    domains = {
      dom0 = {
        batmanAdvanced = {
          mac = "0a:c4:b9:de:ff:c7";
        };
        ipv4 = {
          # address = "10.1.65.1";
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
          # address = "fdeb:52c8:d094:1000::2";
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
            };
          };
        };
      };
    };
  };

}
