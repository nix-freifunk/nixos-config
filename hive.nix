let
  sources = import ./npins;
  inherit (sources) nixpkgs;
  inherit (sources) nixpkgs-unstable;
  lib = import (nixpkgs + "/lib");
in
{
  meta = {
    nixpkgs = import nixpkgs { };
  };

  defaults = { pkgs, ... }: {
    # This module will be imported by all hosts
    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      htop
      mtr
      ethtool
      tmux
      tcpdump
      dig
      ncdu
    ];

    imports = [
      (sources.agenix + "/modules/age.nix")
      ./modules/time.nix
    ];
  };

  "gw-test01" = { name, nodes, ... }:  {
    imports = [ ./machines/gw-test01.ffrn.de ];
  };
  "gw-test02" = { name, nodes, ... }:  {
    imports = [ ./machines/gw-test02.ffrn.de ];
  };

  "resolver1" = { name, nodes, ... }:  {
    imports = [ ./machines/resolver1.ff.tomhe.de ];
  };
  "resolver2" = { name, nodes, ... }:  {
    imports = [ ./machines/resolver2.ff.tomhe.de ];
  };

  "www1" = { name, nodes, ... }:  {
    imports = [ ./machines/www1.ff.tomhe.de ];
  };

}
