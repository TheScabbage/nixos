{
  description = "Scabbageflake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-roslyn.url = "github:NixOS/nixpkgs/a595dde4d0d3";
    nixpkgs-unityhub.url = "github:NixOS/nixpkgs/517841072fbf8de9ac8f305c1340ce8fcf764a5f";
  };

  outputs = { self, nixpkgs, nixpkgs-roslyn, nixpkgs-unityhub, ... }:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      bytebox = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            nixpkgs.overlays = [
              (final: prev: {
                roslyn-ls = nixpkgs-roslyn.legacyPackages.${prev.system}.roslyn-ls;
              })
              (final: prev: {
                unityhub = nixpkgs-unityhub.legacyPackages.${prev.system}.unityhub;
              })
            ];
          }
        ];
      };
    };
  };
}
