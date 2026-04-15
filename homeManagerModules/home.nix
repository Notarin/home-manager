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
    ./user.nix
    ./programs
    (self + /resources/nix-repl/qol-nix-repl.nix)
    self.inputs.stylix.homeModules.stylix
    self.inputs.nixcord.homeModules.nixcord
  ];

  home = {
    packages = with pkgs; [
      pwvucontrol
      overskride
      file-roller
      wl-clipboard
      comma
      nautilus
      gvfs
      gomuks
      vesktop

      bitwarden-desktop

      # Fonts
      pkgs.nerd-fonts.fira-code
      pkgs.dejavu_fonts
      pkgs.jetbrains-mono
    ];

    sessionVariables = {
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
      VISUAL = lib.mkForce (
        lib.local.patternMatch true (throw "No editor set to default!")
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
        ]
      );
      NIXOS_OZONE_WL = "1"; # Enables wayland support in nixpkgs
    };
  };

  programs = {
    home-manager.enable = true;
    nh.enable = true;
    git.enable = true;
    direnv.enable = true;
    tealdeer.enable = true;
    bat.enable = true;
    cava.enable = true;
    lazygit.enable = true;
    fuzzel.enable = true;
    gpg.enable = true;
  };

  services = {
    swaync.enable = true;
    gnome-keyring.enable = true;
  };

  gtk.enable = true;
  qt.enable = true;

  fonts.fontconfig.enable = true;

  wayland.windowManager.hyprland = import (self + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
