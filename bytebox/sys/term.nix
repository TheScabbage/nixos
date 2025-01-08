{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm
    alacritty
    kitty
    ghostty
  ];
}
