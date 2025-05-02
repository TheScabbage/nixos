{ config, pkgs, ... }:
{
    #services.postgresql = {
    #    enable = true;
    #    ensureDatabases = [ "dust" ];
    #    authentication = pkgs.lib.mkOverride 10 ''
    #        #type DATABASE  USER        ADDRESS     METHOD
    #        local all       all                     trust
    #        host  all       postgres    0.0.0.0/0   scram-sha-256
    #    '';
    #};

    environment.systemPackages = with pkgs; [
        pgadmin4
    ];
}
