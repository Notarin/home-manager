{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = lib.mkIf (config.host == "uriel") true;
    sessionVariables = config.home.sessionVariables;
    shellAliases = config.shellAliases;
  };
}
