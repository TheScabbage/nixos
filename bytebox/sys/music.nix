{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    reaper
    audacity
    picard
    yt-dlp
  ];
}
