{config, ...}: {
  enable = true;
  shellAliases = config.programs.nushell.shellAliases;
  sessionVariables = config.home.sessionVariables;
}
