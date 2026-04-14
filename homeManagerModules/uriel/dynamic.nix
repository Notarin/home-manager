{
  lib,
  config,
  ...
}: {
  programs =
    (lib.local.simpleEnabledPrograms ["obsidian"])
    // (lib.local.complexEnabledPrograms config (./Software));
}
