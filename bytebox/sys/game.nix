{ config, pkgs, ... }:
{
    # use steam-hardware module for KK3 nintendo switch mode
    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
        steam
        steamcmd
        protonplus
        xemu
        r2modman
        gamemode
    ];
}
