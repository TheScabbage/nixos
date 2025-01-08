
{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "where-is-my-sddm-theme";

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kwalletmanager
    xwayland
    xwaylandvideobridge
    xdg-desktop-portal-kde
  ];
}
