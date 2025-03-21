# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
  lib,
  config,
  ...
}:

{
  home = {
    packages = with pkgs; [
      killall
      nixgl.nixGLIntel
      pwvucontrol
      gnome-disk-utility
      overskride
      google-chrome
      nil
      nixfmt-rfc-style
      wine
      file-roller
      direnv
      wl-clipboard
      vesktop
      jetbrains.rust-rover
      prismlauncher
      tealdeer
      r2modman
    ];

    # Files that are symlinked to the home directory
    file = { };

    sessionVariables = {
      EDITOR = "hx";
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
    image = ../../../Images/Horizontal_WP.png;
    fonts.monospace = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };
    cursor = {
      package = pkgs.oreo-cursors-plus;
      name = "oreo_pink_cursors";
      size = 32;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    targets.vscode.profileNames = [ "default" ];
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-mozc ];
      waylandFrontend = true;
    };
  };

  gtk.enable = true;
  qt.enable = true;

  programs = {
    nh.enable = true;
    git.enable = true;
    direnv.enable = true;
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
      };
    };
    starship = {
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
    helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        rust-analyzer
      ];
      settings = {
        keys.normal = {
          y = "yank_to_clipboard";
          p = "paste_clipboard_after";
          P = "paste_clipboard_before";
        };
      };
    };
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ../../../Software/wezterm-settings.lua;
    };
    nushell = import ../../../Software/nushell-config.nix {
      inherit pkgs lib config;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    bat.enable = true;
    vscode = import ../../../Software/vscode-settings.nix {
      inherit pkgs lib;
    };
    cava.enable = true;
    gitui.enable = true;
    mangohud.enable = true;
    wofi.enable = true;
    fuzzel.enable = true;
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  services.swaync.enable = true;

  wayland.windowManager.hyprland = import ../../../Software/hyprland-settings.nix {
    inherit pkgs lib;
  };

  # Nix settings
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      extra-experimental-features = "nix-command flakes";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow home-manager to update itself
  programs.home-manager.enable = true;
}
