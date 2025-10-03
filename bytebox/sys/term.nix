{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm
    alacritty
    kitty
    # Disabled (building from source instead)
    #ghostty
  ];
}
