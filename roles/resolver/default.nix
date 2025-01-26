{ config, lib, pkgs, ... }:
let
  sources = import ../../npins;
in
{
  imports = [
    (import sources.nix-freifunk)
  ];

  modules.freifunk.gateway = {
    enable = true;
    yanic.enable = false;
    dnsSearchDomain = [
      "ff.tomhe.de"
    ];
    domains = {
      dom0 = {
        fastd.enable = false;
        names = {
          dom0 = "Domain 0";
          ffda_default = "Default";
        };
        bird.enable = false;
        vxlan.vni = 97726;
        ipv4 = {
          # subnet = "10.1.64.0/20";
          prefixes."10.1.64.0/20" = {};

          # address = "10.1.64.1";
          dhcpV4 = {
            enable = lib.mkDefault false;
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
    };
  };

  environment.systemPackages = with pkgs; [
    bridge-utils
    git
    fastd
    jq
    batctl
    tcpdump
  ];

  systemd.network.networks."10-mainif".networkConfig.VXLAN = config.modules.freifunk.gateway.vxlan.interfaceNames;

}
