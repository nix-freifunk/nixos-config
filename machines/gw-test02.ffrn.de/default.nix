{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      "${modulesPath}/virtualisation/incus-virtual-machine.nix"
      ../../roles/all.nix
      ./gw.nix
    #   ./meshviewer.nix
    ];

  networking.hostName = "gw-test02"; # Define your hostname.
  networking.domain = "ff.tomhe.de";
  deployment.targetHost = "2a01:4f8:140:4093:5054:ff:fe02:e2a6";

  # networking.firewall.enable = false;
  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 5201 ];
  networking.firewall.allowedUDPPorts = [ 5201 ];

  systemd.network.networks."10-mainif" = {
    matchConfig = {
      Name = "enp5s0";
    };
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = false;
    };
  };

  networking.nftables.tables.postrouting = {
    content = ''
      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;
        ip saddr 10.0.0.0/8 masquerade
        ip6 saddr fdeb:52c8:d094:1000::/64 masquerade
      }
    '';
    family = "inet";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.mosh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
