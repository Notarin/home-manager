{
  pkgs,
  lib,
  system,
  self,
  ...
}: {
  imports = [./dynamic.nix];

  home = {
    packages = with pkgs;
    with self.packages.${system}; [
      (discord.override {
        withVencord = true;
      })
      hydrus-client
      r2modman
      prismlauncher
      gimp
      element-desktop
      nheko
      youtube-music
      plex-htpc
      ytdownloader
      vlc
      plexamp
      picard
      eog

      # Snix
      snix-cli

      # Editors
      jetbrains.idea-community-bin
      (pkgs.writeShellApplication {
        name = "rust-rover";
        runtimeInputs = with pkgs; [
          gcc
          rustup
        ];
        text = "${lib.getExe pkgs.jetbrains.rust-rover}";
      })
    ];
  };

  wayland.windowManager.hyprland = {
    package = lib.mkForce null;
    portalPackage = lib.mkForce null;
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
