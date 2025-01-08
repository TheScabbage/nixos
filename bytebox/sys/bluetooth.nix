{ config, pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  services.pipewire.wireplumber.enable = true;
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-hw-volume" = true;
        # Remove the phone profiles cuz they sound like ass
        "bluez5.enable-msbc" = false;
        "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];
    };
  };
}
