{
  pkgs,
  lib,
  self,
  ...
}: {
  imports = [
    ./mangohud.nix
    ./obs-studio.nix
  ];

  home = {
    packages = with pkgs;
    with self.packages.${pkgs.stdenv.system}; [
      (discord.override {
        withVencord = true;
      })
      hydrus-client
      r2modman
      prismlauncher
      gimp
      element-desktop
      nheko
      pear-desktop
      plex-htpc
      ytdownloader
      vlc
      plexamp
      picard
      eog
      space-station-14-launcher

      # Snix
      snix-cli

      # Editors
      jetbrains.idea-oss
      (pkgs.writeShellApplication {
        name = "rust-rover";
        runtimeInputs = with pkgs; [
          gcc
          rustup
        ];
        text = "${lib.getExe pkgs.jetbrains.rust-rover}";
      })
      (pkgs.symlinkJoin {
        name = "rider";
        paths = [
          (pkgs.writeShellApplication {
            name = "rider";
            runtimeInputs = [pkgs.dotnet-ef];
            text = "${lib.getExe pkgs.jetbrains.rider}";
          })
          pkgs.jetbrains.rider
        ];
      })
    ];
  };

  programs = {
    obsidian.enable = true;
    btop.package = pkgs.btop-rocm;
  };

  # Do not touch
  home.stateVersion = "24.05";

  wayland.windowManager.hyprland = {
    package = lib.mkForce null;
    portalPackage = lib.mkForce null;
    settings = {
      monitor = [
        "DP-1,1920x1080@60,0x0,1"
        "HDMI-A-1,1920x1080@60,1920x-420,1,transform,1"
        "DP-2,1920x1080@60,0x0,1,mirror,DP-1"
      ];
      bind = [
        "$mod_ALT, RIGHT, movecurrentworkspacetomonitor, HDMI-A-1"
        "$mod_ALT, LEFT, movecurrentworkspacetomonitor, DP-1"
      ];
    };
  };
}
