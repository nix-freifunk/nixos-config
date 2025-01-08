{ name, config, lib, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
in
{
  imports = [
    (import sources.nixos-freifunk)
    ../../modules/acme.nix
  ];

  services.freifunk.gluon-firmware-server = {
    enable = true;
    enableSSL = true;
    useACMEHost = "${config.networking.hostName}.${config.networking.domain}";
    uploadUserAuthorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUFJ6wlx64KaaONJZs83e93ewlGn6krK2uX8HK5a/Id github-actions@github" # nix-freifunk/site-ffnix
    ] ++ config.users.users.root.openssh.authorizedKeys.keys;
    firmwareSelectorServer = {
      enable = true;
      domain = "fw.ff.tomhe.de";
      config = {
        listMissingImages = true;
        vendormodels = "vendormodels";
        enabled_device_categories = ["recommended"];
        recommended_toggle = false;
        recommended_info_link = null;
        community_prefix = "gluon-ffnix-";
        version_regex = "-([0-9]+.[0-9]+.[0-9x]+([+-~][0-9]+)?)[.-]";
        directories = {
          "./images/stable/factory/" = "stable";
          "./images/stable/sysupgrade/" = "stable";
          "./images/stable/other/" = "stable";
          "./images/beta/factory/" = "beta";
          "./images/beta/sysupgrade/" = "beta";
          "./images/beta/other/" = "beta";
          "./images/experimental/factory/" = "experimental";
          "./images/experimental/sysupgrade/" = "experimental";
          "./images/experimental/other/" = "experimental";
          "./images/nightly/factory/" = "nightly";
          "./images/nightly/sysupgrade/" = "nightly";
          "./images/nightly/other/" = "nightly";
        };
        title = "Firmware FFNIX";
        branch_descriptions = {
          stable = "Gut getestet, zuverlässig und stabil.";
          beta = "Vorabtests neuer Stable-Kandidaten.";
          experimental = "Ungetestet, teilautomatisch generiert.";
          nightly = "Absolut ungetestet, automatisch generiert. Nur für absolute Experten.";
        };
        # branch_descriptions = [
        #   { name = "stable"; description = "Gut getestet, zuverlässig und stabil."; }
        #   { name = "beta"; description = "Vorabtests neuer Stable-Kandidaten."; }
        #   { name = "testing"; description = "Ungetestet, automatisch generiert."; }
        # ];
        recommended_branch = "beta";
        experimental_branches = ["experimental" "nightly"];
        # experimental_branches = ["nightly" "experimental"];
        preview_pictures = "pictures/";
        changelog = "CHANGELOG.html";
      };
    };
    autoupdaterServer = {
      enable = true;
      domain = "fw.gluon.ff.tomhe.de";
    };
    packageServer = {
      enable = true;
      domain = "opkg.ff.tomhe.de";
      proxyOpenWrtFeedEnable = true;
      proxyOpenWrtFeedAllowedAddrs = [ "0.0.0.0/0" "::/0"];
    };
    openFirewall = true;
  };

  security.acme = {
    certs."${config.networking.hostName}.${config.networking.domain}" = {
      extraDomainNames = [
        "${config.services.freifunk.gluon-firmware-server.firmwareSelectorServer.domain}"
        "${config.services.freifunk.gluon-firmware-server.autoupdaterServer.domain}"
        "${config.services.freifunk.gluon-firmware-server.packageServer.domain}"
      ];
    };
  };

  users.groups."${config.security.acme.certs."${config.networking.hostName}.${config.networking.domain}".group}" = {
    members = [ "${config.services.nginx.user}" ];
  };

}
