{
  config,
  lib,
  pkgs,
  ...
}: {
  shellAliases = rec {
    q = "exit"; # `q` for "quit"
    l = "ls";
    la = "${l} -la";
    c = "clear";
    helix = "hx"; # I keep accidentally typing `helix` instead of `hx`
    edit = config.home.sessionVariables.VISUAL;
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
}
