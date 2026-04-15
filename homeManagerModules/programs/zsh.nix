{config, ...}: {
  programs.zsh = {
    enable = true;
    sessionVariables = config.home.sessionVariables;
    shellAliases = config.shellAliases;
  };
}
