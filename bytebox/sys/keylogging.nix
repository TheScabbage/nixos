{ config, pkgs, ... }:
{
    systemd.services.keylog = {
        enable = true;
        description = "bar";
        unitConfig = {
            Type = "simple";
        };
        serviceconfig = {
            ExecStart = "logkeys --start --output=/var/log/keys.log";
            Restart = "on-failure";
            RestartSec = 5;
            User = "root";
        };
        wantedBy = [ "multi-user.target" ];
    }
}
