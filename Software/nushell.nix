{
  lib,
  pkgs,
  config,
  ...
}: {
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
  extraConfig = ''$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append "/.nix-profile/bin" | str join))'';
}
