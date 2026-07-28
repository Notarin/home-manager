{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      git-bug
      git-review
      ;
  };
  programs = {
    git.enable = true;
    lazygit.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        # Enabling features
        line-numbers = true;
        hyperlinks = true;
        side-by-side = true;
        colorMoved = "default";
        conflictStyle = "zdiff3";
        # Formatting (plus some styling unless I move that elsewhere)
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        hunk-header-decoration-style = "yellow box";
        file-decoration-style = "none"; # Nukes the annoying ass blue line that is way too big.
      };
    };
  };
  shellAliases.gitui =
    lib.mkIf config.programs.lazygit.enable
    (lib.getExe config.programs.lazygit.package);
}
