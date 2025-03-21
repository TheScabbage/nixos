{ config, pkgs, ... }:
{
    config.services.postgresql = {
        enable = true;
        ensureDatabases = [ "dust" ];
        authentication = pkgs.lib.mkOverride 10 ''
            #type database DBuser auth-method
            local all      all    trust
        '';
    };

    environment.systemPackages = with pkgs; {
        postgresql
    };
}
