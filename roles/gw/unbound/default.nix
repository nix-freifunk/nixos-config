{ pkgs, config, lib, ... }:
let

  getOnlyEnabled = lib.filterAttrs (_: value: value.enable);

  enabledDomains = getOnlyEnabled config.modules.freifunk.gateway.domains;

  batmanInterfaceNamesNft = lib.concatStringsSep ", " (lib.mapAttrsToList (_: domain: "\"${domain.batmanAdvanced.interfaceName}\"") enabledDomains);

in {

  imports = [
    ./exporter.nix
  ];


  networking.nameservers = [
    "2001:67c:2960::64"
    "2001:67c:2960::6464"
  ];

  services.resolved.enable = true;

  services.unbound = {
    enable = true;

    package = pkgs.unbound-full;

    settings = {
      server = {
        num-threads = "2";

        interface = [
          "::1" "127.0.0.1"    # localhost
          "fd01:67c:2ed8:a::55:1" # ns1
          "fd01:67c:2ed8:a::56:1" # ns2
        ];

        access-control  = [
          "0.0.0.0/0 allow"
          "::/0 allow"
        ];

        edns-buffer-size = "1232";

        so-rcvbuf = "4m";
        so-sndbuf = "4m";

        # hardening
        harden-glue = "yes";
        harden-dnssec-stripped = "yes";
        harden-algo-downgrade = "yes";
        harden-large-queries = "yes";
        harden-short-bufsize = "yes";

        serve-expired = "yes";

        # privacy
        qname-minimisation = "yes";
        use-caps-for-id = "yes";
        rrset-roundrobin = "yes";
        minimal-responses = "yes";

        prefetch = "yes";
        prefetch-key = "yes";

        cache-min-ttl = "30";
        cache-max-ttl = "86400";

        msg-cache-size = "128m";
        rrset-cache-size = "256m";

        msg-cache-slabs = "2";
        rrset-cache-slabs = "2";
        infra-cache-slabs = "2";
        key-cache-slabs = "2";

        local-zone = [
          "\"dn42.\" typetransparent"
          "\"d.f.ip6.arpa.\" typetransparent"
        ];

        private-domain = [
          "dn42"
          "d.f.ip6.arpa"
        ];

        domain-insecure = [
          "dn42"
        ];
      };

      forward-zone = [
        # {
        #   name = ".";
        #   forward-addr = config.networking.nameservers;
        #   forward-no-cache = "yes";
        # }
      ];

    };

  };

  networking.nftables.tables.nixos-fw = {
    content = ''
      chain input_extra {
        iifname {${batmanInterfaceNamesNft}} meta l4proto {tcp, udp} th dport 53 counter accept comment "accept DNS from domains"
      }
    '';
  };

}