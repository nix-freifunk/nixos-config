{ name, nodes, config, pkgs, lib, ...}:
let
  peerDir = "/var/lib/fastd/peer_groups/nodes";

in
{
  imports = [
    ../../modules/freifunk
    ./unbound
  ];

  deployment.keys."fastd-secret" = {
    keyFile = ../../secrets/fastd/${name};
    destDir = "/etc/fastd";
    name = "secret.conf";
    user = "root";
    group = "root";
    permissions = "0400";
    uploadAt = "pre-activation";
  };

  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = true;
    # useDHCP = false;
  };

  environment.systemPackages = with pkgs; [
    bridge-utils
    git
    fastd
    jq
    batctl
    tcpdump
  ];

  modules.freifunk.gateway = {
    enable = true;
    yanic.enable = true;
    fastd = {
      peerDir = peerDir;
      secretKeyIncludeFile = "${config.deployment.keys."fastd-secret".path}";
    };
    domains = {
      dom0 = {
        names = {
          dom0 = "Domain 0";
          ffda_default = "Default";
        };
        vxlan.vni = 97726;
        ipv4 = {
          # subnet = "10.84.0.0/20";
          prefixes."10.84.0.0/20" = {};

          # address = "10.84.0.1";
          dhcpV4 = {
            enable = lib.mkDefault true;
            dnsServers = [ "10.84.15.254" ];
            # pools = [
            #   "10.84.0.8 - 10.84.1.255"
            #   "10.84.2.8 - 10.84.3.255"
            # ];
          };
        };
        ipv6 = {
          # subnet = "fd01:67c:2ed8:1000::/64";
          # address = "fd01:67c:2ed8:1000::1";
          # dhcpV4 = {
          #   enable = true;
          #   dnsServers = [ "10.84.15.254" ];
          # };
        };
      };
      dom18 = {
        names = {
          dom18 = "Domain 18";
          ffda_da_540_kelley = "Darmstadt: Kelley-Barracks";
        };
        fastd = {
          enable = true;
          peerDir = peerDir;
          secretKeyIncludeFile = "${config.deployment.keys."fastd-secret".path}";
        };
        batmanAdvanced = {
        };
        vxlan = {
          vni = 14443279;
        };
        ipv4 = {
          # subnet = "10.85.32.0/20";
          # address = "10.85.32.1";
          # dhcpV4.enable = false;
        };
        ipv6 = {
          # subnet = "fd01:67c:2ed8:1012::/64";
          # address = "fd01:67c:2ed8:1012::1";
        };
      };
      dom1 = {
        enable = false;
        vxlan.vni = 11417690;
        # ipv4.enable = false;
        # ipv4.dhcpV4.enable = false;
      };
      dom2 = {
        enable = false;
        vxlan.vni = 14452509;
      };
      dom3 = {
        enable = false;
        vxlan.vni = 13895626;
      };
      dom4 = {
        enable = false;
        vxlan.vni = 14266393;
      };
      dom5 = {
        enable = false;
        vxlan.vni = 11671747;
      };
      dom6 = {
        enable = false;
        vxlan.vni = 4120142;
      };
      dom7 = {
        enable = false;
        vxlan.vni = 1750245;
      };
      dom8 = {
        enable = false;
        vxlan.vni = 11671747;
      };
      dom9 = {
        enable = false;
        vxlan.vni = 13030931;
      };
      dom10 = {
        enable = false;
        vxlan.vni = 14062832;
      };
      dom11 = {
        enable = false;
        vxlan.vni = 10491846;
      };
      dom12 = {
        enable = false;
        vxlan.vni = 14103921;
      };
      dom13 = {
        enable = false;
        vxlan.vni = 3304440;
      };
      dom14 = {
        enable = false;
        vxlan.vni = 12138417;
      };
      dom15 = {
        enable = false;
        vxlan.vni = 2804204;
      };
      dom16 = {
        enable = false;
        vxlan.vni = 12382809;
      };
      dom17 = {
        enable = false;
        vxlan.vni = 15416306;
      };
      dom19 = {
        enable = false;
        vxlan.vni = 3414260;
      };
      # dom19 = {
      #   fastd = {
      #     enable = false;
      #     port = 10190;
      #     peerDir = peerDir;
      #     secretKeyIncludeFile = "${config.deployment.keys."fastd-secret".path}";
      #   };
      # };
    };
  };

  systemd.network.networks."10-mainif".networkConfig.VXLAN = config.modules.freifunk.gateway.vxlan.interfaceNames;

  services.fastd-peergroup-nodes = {
    enable = true;
    reloadServices = map (service: "${service.unitName}.service") (builtins.attrValues config.services.fastd);
    repoUrl = "https://github.com/nix-freifunk/fastd-keys.git";
    repoBranch = "main";
  };

}