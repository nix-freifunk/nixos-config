{ pkgs, config, ... }:
{

  services.prometheus.exporters.unbound = {
    enable = true;
    controlInterface = "${config.services.unbound.localControlSocketPath}";
    listenAddress = "[::]";
    group = "${config.services.unbound.group}";
  };

  services.unbound = {
    settings = {
      remote-control.control-enable = true;
    };
    localControlSocketPath = "/run/unbound/unbound.ctl";
  };

  networking.nftables.tables.nixos-fw = {
    content = ''
      chain input_extra {
        tcp dport ${toString config.services.prometheus.exporters.unbound.port} ip saddr { 82.195.73.4, 10.223.254.14 } counter accept comment "prometheus-unbound-exporter: accept from elsa"
        tcp dport ${toString config.services.prometheus.exporters.unbound.port} ip6 saddr { 2001:67c:2ed8::4:1, fd01:67c:2ed8:a::14:1 } counter accept comment "prometheus-unbound-exporter: accept from elsa"
      }
    '';
  };

}