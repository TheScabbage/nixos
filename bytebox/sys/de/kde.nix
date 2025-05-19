{ config, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.qttools
    xwayland
    amdgpu_top
    wayland-scanner
  ];
}
