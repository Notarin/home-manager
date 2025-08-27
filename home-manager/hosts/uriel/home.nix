{
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
      (
        pkgs.writeShellScriptBin "hydrus-client"
        "env --unset=WAYLAND_DISPLAY ${lib.getExe' pkgs-stable.hydrus "hydrus-client"}"
      )
      r2modman
      heroic
      prismlauncher

      # Editors
      (pkgs-stable.jetbrains.idea-community-bin.override {
        jdk = pkgs.openjdk21;
      })
      (jetbrains.rust-rover.override {
        jdk = pkgs.openjdk21;
      })
    ];
  };

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
