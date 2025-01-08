
{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.background = ./wallpapers/space.jpg;
  services.desktopManager.plasma6.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.theme = "tokyo-night-sddm";

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kwalletmanager
    #kdePackages.sddm
    xwayland
    xwaylandvideobridge
    xdg-desktop-portal-kde
  ];
}
