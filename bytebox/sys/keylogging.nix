{ config, pkgs, ... }:
{
    systemd.services.keylog = {
        enable = true;
        description = "Keylogging service";
        unitConfig = {
            Type = "simple";
        };
        serviceConfig = {
            ExecStart = "${pkgs.logkeys}/bin/logkeys --start --no-daemon --output=/var/log/keys.log";
            #ExecStop = "${pkgs.logkeys}/bin/logkeys --kill";
            Restart = "always";
            RestartSec = 5;
        };
        wantedBy = [ "multi-user.target" ];
    };
}
