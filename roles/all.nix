{ config, lib, pkgs, ... }:
{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.useNetworkd = true;
  networking.nftables.enable = true;
  networking.usePredictableInterfaceNames = true;

  users.users.root.openssh.authorizedKeys.keys = [
   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILp4HgDDRQYOp1xXPTUkqv83dZw+DGIj5jZdBzR2u57Y tom v6"
   "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMiPPoELDHdbSRFIDU55751WYNh97bEgBKVEgx3aEvUzAAAACnNzaDp0b20tdjg= Tom-YubiKey5NFC-2"
  ];

  services.bird2.package = pkgs.bird3;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "de";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # automatically remove unused old derivations
  nix.gc = {
    automatic = true;
    dates = "daily";
    randomizedDelaySec = "6h";
    options = "--delete-older-than 14d";
  };

  # Ensure that we can't even touch the configuration directory if we wanted to.
  fileSystems."/etc/nixos" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=1M,ro" ];
  };

}
