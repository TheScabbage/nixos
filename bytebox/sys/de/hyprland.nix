{ config, pkgs, ... }:
{
    programs.hyprland.enable = true;
    networking.networkmanager.enable = true;
    services.displayManager.sddm.autoNumlock = true;

    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
        kitty
        gnome-keyring
        swww
        polkit_gnome
        waybar
        networkmanagerapplet
        wofi
        hyprpaper
        hyprshot
        hyprlandPlugins.hyprexpo
        hyprlandPlugins.hyprwinwrap
        dunst
        xwayland
        xdg-desktop-portal-hyprland
        playerctl
        xfce.thunar
        lxappearance
        nwg-look
    ];
}
