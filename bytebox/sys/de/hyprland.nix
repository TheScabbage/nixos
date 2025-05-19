{ config, pkgs, ... }:
{
    programs.hyprland.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
        kitty
        waybar
        networkmanagerapplet
        wofi
        hyprpaper
        hyprshot
        gnome-keyring
        xdg-desktop-portal-hyprland
        xfce.thunar
        lxappearance
        nwg-look
    ];
}
