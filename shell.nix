{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    (pkgs.callPackage "${(import ./npins).agenix}/pkgs/agenix.nix" {})
    colmena
    npins
    (pkgs.callPackage "${(import ./npins).npins-updater}/pkgs/npins-updater.nix" {})
  ];
}
