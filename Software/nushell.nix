{
  lib,
  pkgs,
  config,
  self,
  ...
} @ specialArgs: let
  nix_locate =
    builtins.replaceStrings ["~nix-locate~"] [(lib.getExe' pkgs.nix-index "nix-locate")]
    (builtins.readFile (self + "/resources/nix-locate.nu"));
  globalShellConfig = import (self + "/resources/shellConfig.nix") specialArgs;
in
  lib.recursiveUpdate {
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
      edit_mode = "emacs";
      use_kitty_protocol = false;
    };
    shellAliases = rec {
      cd = "z"; # Zoxide support
      r = reload;
      reload = "exec nu"; # Technically just starts a fresh nushell
      "nix build" = "${lib.getExe pkgs.nix-output-monitor} build";
      "nix shell" = "${lib.getExe pkgs.nix-output-monitor} shell";
    };
    environmentVariables = config.home.sessionVariables;
    extraConfig =
      ''$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append "/.nix-profile/bin" | str join))''
      + "\n"
      + nix_locate;
  }
  globalShellConfig
