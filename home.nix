{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  # System specific
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";
  # Do not touch
  home.stateVersion = "24.05";

  # Packages
  home.packages = with pkgs; [
    killall
  ];

  # Deployed files/directories
  home.file = {
  };

  # ENV variables
  home.sessionVariables = {
    EDITOR = "hx";
  };

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
  stylix.image = ./Images/Horizontal_WP.png;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = import ./hyprland-settings.nix;
  };
  gtk.enable = true;
  qt.enable = true;
  programs.btop.enable = true;
  programs.btop.settings.update_ms = 100;
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      hostname = {
        ssh_symbol = "📡";
      };
      shell = {
        disabled = false;
      };
    };
  };
  programs.helix.enable = true;
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm-settings.lua;
  };
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      ls = {
        use_ls_colors = true;
        clickable_links = true;
      };
      rm = {
        always_trash = true;
      };
      history = {
        max_size = 100000;
      };
      filesize = {
        metric = true;
      };
      edit_mode = "emacs";
      use_kitty_protocol = false;
    };
    shellAliases = {
      q = "exit";
      l = "ls";
      c = "clear";
      cd = "z";
      cat = lib.getExe pkgs.bat;
    };
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.bat.enable = true;

  # Allow home-manager to update itself
  programs.home-manager.enable = true;
}
