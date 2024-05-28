{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/all.nix
      ./gw.nix
      ./meshviewer.nix
    ];

  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  boot.loader.grub = {
    enable = true;
    configurationLimit = 5;
    efiSupport = false;
    extraConfig = "
      serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
      terminal_input serial
      terminal_output serial
    ";
    device = "/dev/vda";
  };

  networking.hostName = "gw-test01"; # Define your hostname.
  networking.domain = "ff.tomhe.de";
  deployment.targetHost = "2a01:4f8:160:624c:5054:ff:fe6b:6397";

  # networking.firewall.enable = false;
  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 5201 ];
  networking.firewall.allowedUDPPorts = [ 5201 ];

  systemd.network.networks."10-mainif" = {
    matchConfig = {
      Name = "enp1s0";
    };
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };

  networking.nftables.tables.postrouting = {
    content = ''
      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;
        ip saddr 10.0.0.0/8 masquerade
        ip6 saddr fd01:67c:2ed8:1000::/64 masquerade
      }
    '';
    family = "inet";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.mosh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
