let
  sources = import ./npins;
  pkgs = (import sources.nixpkgs { inherit sources; config = {}; });
in pkgs.mkShell {
  buildInputs = with pkgs; [
    (callPackage "${sources.agenix}/pkgs/agenix.nix" {})
    colmena
    npins
    (callPackage "${sources.npins-updater}/pkgs/npins-updater.nix" {})
  ];
}
