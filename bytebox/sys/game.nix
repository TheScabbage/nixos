{ config, pkgs, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ xpadneo xone ];

  # Use steam-hardware module for KK3 nintendo switch mode
  hardware.steam-hardware.enable = true;

  # Bluetooth xbox gamepads
  hardware.xpadneo.enable = true;
  boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  # Xbox wireless adapter
  hardware.xone.enable = true;

  # Fixes Finals crashing on startup
  boot.kernelParams = [ "clearcpuid=304" ];

  environment.systemPackages = with pkgs; [
      steam
      steamcmd
      steam-tui
      gamescope
      protonplus
      xemu
      r2modman
      gamemode
  ];
}
