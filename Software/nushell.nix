{
  lib,
  pkgs,
  config,
  ...
}: let
  patternMatch = match: none: multiple: pattern: let
    isValidPattern =
      builtins.all (
        entry: (builtins.isList entry) && (builtins.length entry == 2)
      )
      pattern;
    matches = builtins.filter (entry: (builtins.elemAt entry 0) == match) pattern;
    return =
      if builtins.length matches == 1
      then builtins.elemAt (builtins.elemAt matches 0) 1
      else if builtins.length matches == 0
      then none
      else if builtins.length matches > 1
      then multiple
      else throw "Unreachable branch! Somehow a lists length was not 0, 1, or any greater number?!";
  in
    assert isValidPattern; return;
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
  shellAliases = {
    q = "exit";
    l = "ls";
    la = "ls -la";
    c = "clear";
    cd = "z";
    cat = lib.getExe pkgs.bat;
    gitui =
      patternMatch true "echo 'No visual git enabled.'" (throw "Multiple visual git clients enabled.")
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
  extraConfig = ''$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append "/.nix-profile/bin" | str join))'';
}
