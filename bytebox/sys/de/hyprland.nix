{ config, pkgs, ... }:
{
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
        kitty
        waybar
        networkmanagerapplet
        wofi
        hyprpaper
        xdg-desktop-portal-hyprland
        xfce.thunar
        lxappearance
    ];
}
