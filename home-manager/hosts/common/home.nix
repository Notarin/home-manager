# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
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
    ./desktop-shell.nix
  ];

  home = {
    packages = with pkgs; [
      pwvucontrol
      gnome-disk-utility
      overskride
      google-chrome
      wine
      file-roller
      wl-clipboard
      prismlauncher
      qjackctl
      comma
      vlc
      gimp
      element-desktop
      logseq
      youtube-music
      nautilus
      plexpkgs.plex-htpc

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
      NIXOS_OZONE_WL = "1"; # Enables wayland support in nixpkgs
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
