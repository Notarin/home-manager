{config, ...}: {
  programs.bash = {
    enable = true;
    sessionVariables = config.home.sessionVariables;
    shellAliases = config.shellAliases;
  };
}
