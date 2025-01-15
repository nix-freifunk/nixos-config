{ name, nodes, config, pkgs, lib, ...}:
let
  peerDir = "/var/lib/fastd/peer_groups/nodes";

  sources = import ../../npins;
in
{
  imports = [
    (import sources.nixos-freifunk)
    ./unbound
  ];

  age.secrets."fastd" = {
    file = ../../secrets/${name}/fastd.age;
    mode = "0400";
    owner = "root";
    group = "root";
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
      secretKeyIncludeFile = config.age.secrets."fastd".path;
    };
    dnsSearchDomain = [
      "ff.tomhe.de"
    ];
    domains = {
      dom0 = {
        names = {
          dom0 = "Domain 0";
          ffda_default = "Default";
        };
        vxlan.vni = 97726;
        ipv4 = {
          # subnet = "10.1.64.0/20";
          prefixes."10.1.64.0/20" = {};

          # address = "10.1.64.1";
          dhcpV4 = {
            enable = lib.mkDefault true;
            dnsServers = [ "10.1.67.254" ];
            # pools = [
            #   "10.1.64.8 - 10.1.64.255"
            #   "10.1.65.8 - 10.84.3.255"
            # ];
          };
        };
        ipv6 = {
          dnsServers = [
            "fdeb:52c8:d094:1000::1:1"
          ];
        };
      };
      dom18 = {
        enable = false;
        names = {
          dom18 = "Domain 18";
          ffda_da_540_kelley = "Darmstadt: Kelley-Barracks";
        };
        fastd = {
          enable = true;
          peerDir = peerDir;
          secretKeyIncludeFile = config.age.secrets."fastd".path;
        };
        batmanAdvanced = {
        };
        vxlan = {
          vni = 14443279;
        };
        ipv4 = {
          # dhcpV4.enable = false;
        };
        ipv6 = {
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
