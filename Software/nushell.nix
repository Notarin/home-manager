{
  lib,
  pkgs,
  config,
  ...
}:
{
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
    c = "clear";
    cd = "z";
    cat = lib.getExe pkgs.bat;
  };
  environmentVariables = config.home.sessionVariables;
  extraConfig = ''$env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | append "/.nix-profile/bin" | str join))'';
}
