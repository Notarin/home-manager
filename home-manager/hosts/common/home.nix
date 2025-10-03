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
      pwvucontrol
      overskride
      google-chrome
      file-roller
      wl-clipboard
      comma
      nautilus
      gomuks
      vesktop

      bitwarden-desktop

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

  gtk.enable = true;
  qt.enable = true;

  fonts.fontconfig.enable = true;

  wayland.windowManager.hyprland = import (self + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
