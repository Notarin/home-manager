{
  pkgs,
  lib,
  ...
}: let
  wezterm-ssh = pkgs.writeShellApplication {
    name = "wezterm-ssh";
    runtimeInputs = builtins.attrValues {
      inherit (pkgs) wezterm fuzzel jc;
    };
    text = "exec ${./wezterm-ssh.nu}";
  };
in {
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        "SUPER + S"
        (lib.generators.mkLuaInline "hl.dsp.exec_raw(\"${lib.getExe wezterm-ssh}\")")
      ];
    }
  ];
  home.packages = [wezterm-ssh];
}
