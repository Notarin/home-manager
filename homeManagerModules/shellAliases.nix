{
  config,
  lib,
  pkgs,
  ...
}: {
  options.shellAliases = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    description = "Shell aliases to be added to all shells.";
  };
  config.shellAliases = rec {
    q = "exit"; # `q` for "quit"
    l = "ls";
    la = "${l} -la";
    c = "clear";
    helix = "hx"; # I keep accidentally typing `helix` instead of `hx`
    edit = config.home.sessionVariables.VISUAL;
    cat = lib.getExe pkgs.bat;
  };
}
