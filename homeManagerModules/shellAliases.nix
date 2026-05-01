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
    l = "ls";
    la = "${l} -la";
    c = "clear";
    edit = config.home.sessionVariables.VISUAL;
    cat = lib.getExe pkgs.bat;
  };
}
