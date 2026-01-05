{ config, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  system.userActivationScripts = {
      startXdgDesktopPortal.text = ''
        #!/bin/sh
        source ${config.system.build.setEnvironment}

        systemctl --user stop xdg-desktop-portal-hyprland
        systemctl --user mask xdg-desktop-portal-hyprland

        systemctl --user unmask xdg-desktop-portal-kde
        systemctl --user start xdg-desktop-portal-kde

        systemctl --user start xdg-desktop-portal
      '';
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.qttools
    xwayland
    amdgpu_top
    wayland-scanner
  ];
}
