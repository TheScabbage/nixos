{ config, pkgs, ... }:
{
  services.displayManager.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.lightdm.background = ./wallpapers/space.jpg;

  services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.theme = "tokyo-night-sddm";
}
