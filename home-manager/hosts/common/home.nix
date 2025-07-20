# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
  pkgs-stable,
  plexpkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    ./nix.nix
    ./stylix.nix
    ./dynamic.nix
  ];

  home = {
    packages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
      (
        pkgs.writeShellScriptBin "hydrus-client"
        "env --unset=WAYLAND_DISPLAY ${lib.getExe' pkgs-stable.hydrus "hydrus-client"}"
      )
      pwvucontrol
      gnome-disk-utility
      overskride
      google-chrome
      wine
      file-roller
      wl-clipboard
      prismlauncher
      r2modman
      qjackctl
      comma
      vlc
      gimp
      element-desktop
      logseq
      youtube-music
      heroic
      nautilus
      plexpkgs.plex-htpc

      # Editors
      jetbrains.idea-community-bin
      jetbrains.rust-rover

      # Fonts
      pkgs.nerd-fonts.fira-code
      pkgs.dejavu_fonts
      pkgs.jetbrains-mono
    ];

    sessionVariables = {
      VISUAL =
        lib.local.patternMatch true
        (throw "No editor set to default!")
        (throw "Multiple editors set to default simultaneously!")
        [
          [
            config.programs.helix.enable
            (lib.getExe pkgs.helix)
          ]
          [
            config.programs.neovim.enable
            (lib.getExe pkgs.neovim)
          ]
        ];
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = ["hyprland" "gtk"];
    };
  };

  gtk.enable = true;
  qt.enable = true;

  fonts.fontconfig.enable = true;

  wayland.windowManager.hyprland = import (self + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
