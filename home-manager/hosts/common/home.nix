# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
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
      EDITOR = lib.mkForce "";
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  gtk.enable = true;
  qt.enable = true;

  wayland.windowManager.hyprland = import (self + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
