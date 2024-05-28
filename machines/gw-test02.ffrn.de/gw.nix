{ name, config, lib, pkgs, ... }:
{
  imports = [
    ../../roles/gw
  ];

  services.freifunk.bird = {
    routerId = "10.42.21.2";
    localAdresses = [
      "fd01:67c:2ed8:a::55:1" # ns1
      "fd01:67c:2ed8:a::56:1" # ns2
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
          prefix  fd01:67c:2ed8:1000::/64 {
            valid lifetime 3600;
            preferred lifetime 1800;
          };
          rdnss {
            lifetime mult 10;
            ns fd01:67c:2ed8:1000::1:1;
          };
          dnssl {
            domain "ffda.io";
            domain "darmstadt.freifunk.net";
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
          # address = "10.84.2.1";
          prefixes = {
            "10.84.0.0/20" = {
              addresses =[
                "10.84.2.1"
              ];
            };
          };
          dhcpV4 = {
            pools = [
              "10.84.2.8 - 10.84.3.255"
            ];
          };
          
        };
        ipv6 = {
          # address = "fd01:67c:2ed8:1000::2";
          prefixes = {
            "fd01:67c:2ed8:1000::/64" = {
              addresses =[
                "fd01:67c:2ed8:1000::2"
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
      dom18 = {
        batmanAdvanced = {
          mac = "5a:90:63:2a:b2:f9";
        };
        ipv4 = {
          # subnet = "10.85.32.0/20";
          # address = "10.85.32.2";
          prefixes = {
            "10.85.32.0/20" = {
              addresses =[
                "10.85.34.1"
              ];
            };
          };
        };
        ipv6 = {
          # address = "fd01:67c:2ed8:1012::2";
          prefixes = {
            "fd01:67c:2ed8:1012::/64" = {
              addresses =[
                "fd01:67c:2ed8:1012::2"
              ];
            };
          };
        };
      };
    };
  };

}
