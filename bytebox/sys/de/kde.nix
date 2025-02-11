{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.desktopManager.plasma6.enable = true;

  services.displayManager.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.lightdm.background = ./wallpapers/space.jpg;

  services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.theme = "tokyo-night-sddm";

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.qttools
    xwayland
    xwaylandvideobridge
    xdg-desktop-portal-kde
    amdgpu_top
  ];
}
