{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    package = lib.mkForce null;
    #portalPackage = lib.mkForce null;
  };

  programs.btop.package = pkgs.btop-rocm;

  # Do not touch
  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,1920x1080@60,0x0,1"
    "DP-2,1920x1080@60,1920x-420,1,transform,1"
    "HDMI-A-1,1920x1080@60,0x0,1,mirror,DP-1"
  ];
}
