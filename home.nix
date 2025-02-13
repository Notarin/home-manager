{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hyprland-settings.nix
  ];

  # System specific
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";
  # Do not touch
  home.stateVersion = "24.05";

  # Packages
  home.packages = with pkgs; [
    killall
    nh
    halloy
    nixgl.nixGLIntel
    vesktop
    pwvucontrol
    gnome-disk-utility
    overskride
    google-chrome
  ];

  # Deployed files/directories
  home.file = {
  };

  # ENV variables
  home.sessionVariables = {
    EDITOR = "hx";
    NIXOS_OZONE_WL = "1";
  };

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
  stylix.image = ./Images/Horizontal_WP.png;
  stylix.fonts.monospace = {
    name = "Fira Code";
    package = pkgs.fira-code;
  };
  stylix.cursor.package = pkgs.oreo-cursors-plus;
  stylix.cursor.name = "Oreo-Pink-Cursors";

  i18n.inputMethod.enabled = "fcitx5";

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
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
    extraConfig = "$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append \"/.nix-profile/bin\" | str join))";
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.bat.enable = true;
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.renderWhitespace" = "all";
      "editor.fontLigatures" = true;
      "editor.rulers" = [
        {
          "column" = 79;
          "color" = "#0f02";
        }
        {
          "column" = 80;
          "color" = "#f002";
        }
      ];
      "workbench.editor.enablePreviewFromCodeNavigation" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.wrapTabs" = true;
      "git.openRepositoryInParentFolders" = "never";
      "security.workspace.trust.untrustedFiles" = "open";
      "security.workspace.trust.enabled" = false;
      "workbench.settings.editor" = "ui";
      "workbench.startupEditor" = "none";
      "window.menuBarVisibility" = "toggle";
      "git.autofetch" = true;
    };
  };
  programs.cava.enable = true;
  programs.gitui.enable = true;
  programs.mangohud.enable = true;
  services.swaync.enable = true;
  programs.wofi.enable = true;
  programs.fuzzel.enable = true;

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
