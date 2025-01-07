{
    description = "Scabbageflake";

    # Some git repos
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.11";
    };

    # System config
    outputs = { self, nixpkgs, ...}:
    let
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            bytebox = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configuration.nix ];
            };
        };
    };
}
