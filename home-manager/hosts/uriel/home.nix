{ ... }:

{
  # Uriel specific configuration
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";

  # Do not touch
  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,1920x1080@144,0x0,1"
    "DP-2,1920x1080@144,1920x-420,1,transform,1"
  ];
}
