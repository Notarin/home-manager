{
  lib,
  pkgs,
  config,
  self,
  ...
}: let
  nix_locate =
    builtins.replaceStrings ["~nix-locate~"] [(lib.getExe' pkgs.nix-index "nix-locate")]
    (builtins.readFile (self + "/resources/nix-locate.nu"));
in {
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
    q = "exit"; # `q` for "quit"
    l = "ls";
    la = "${l} -la";
    c = "clear";
    cd = "z"; # Zoxide support
    r = reload;
    reload = "exec nu"; # Technically just starts a fresh nushell
    helix = "hx"; # I keep accidentally typing `helix` instead of `hx`
    edit = config.home.sessionVariables.VISUAL;
    cat = lib.getExe pkgs.bat;
    gitui =
      lib.local.patternMatch true "echo 'No visual git enabled.'" (throw "Multiple visual git clients enabled.")
      [
        [
          config.programs.gitui.enable
          (lib.getExe pkgs.gitui)
        ]
        [
          config.programs.lazygit.enable
          (lib.getExe pkgs.lazygit)
        ]
      ];
  };
  environmentVariables = config.home.sessionVariables;
  extraConfig =
    ''$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append "/.nix-profile/bin" | str join))''
    + "\n"
    + nix_locate;
}
