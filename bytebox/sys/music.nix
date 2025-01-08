{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    reaper
    audacity
    picard
    rhythmbox
    yt-dlp
  ];
}
