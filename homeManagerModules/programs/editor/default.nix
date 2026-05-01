{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./helix.nix
    ./vscode.nix
  ];
  programs.obsidian.enable = lib.mkIf (config.host == "uriel") true;
  home = {
    sessionVariables.VISUAL = lib.mkForce "${lib.getExe pkgs.helix}";
    packages = lib.mkIf (config.host == "uriel") (with pkgs; [
      jetbrains.idea-oss
      (pkgs.writeShellApplication {
        name = "rust-rover";
        runtimeInputs = with pkgs; [
          gcc
          rustup
        ];
        text = "${lib.getExe pkgs.jetbrains.rust-rover}";
      })
      (pkgs.symlinkJoin {
        name = "rider";
        paths = [
          (pkgs.writeShellApplication {
            name = "rider";
            runtimeInputs = [pkgs.dotnet-ef];
            text = "${lib.getExe pkgs.jetbrains.rider}";
          })
          pkgs.jetbrains.rider
        ];
      })
    ]);
  };
}
