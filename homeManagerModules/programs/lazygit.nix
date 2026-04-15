{
  lib,
  config,
  ...
}: {
  programs.lazygit.enable = true;
  shellAliases.gitui = lib.mkIf config.programs.lazygit.enable (
    lib.getExe config.programs.lazygit.package
  );
}
