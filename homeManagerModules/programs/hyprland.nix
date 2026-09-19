{
  pkgs,
  lib,
  config,
  ...
}: {
  home = {
    packages = with pkgs;
      [
        wl-clipboard
        nautilus
        gvfs
        file-roller
      ]
      ++ lib.optionals (config.host == "uriel") [
        vlc
        eog
      ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    };
  };
  programs.fuzzel.enable = true;
  services = {
    swaync.enable = true;
    gnome-keyring.enable = true;
  };
  gtk.enable = true;
  qt.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkIf (config.host == "uriel") null;
    portalPackage = lib.mkIf (config.host == "uriel") null;
    systemd.variables = ["--all"];
    settings =
      {
        #input = {
        #  kb_options = "caps:super";
        #};

        workspace_rule = [
          (lib.generators.mkLuaInline "{ workspace = \"w[tv1]\", gaps_out = 0, gaps_in = 0, no_border = true }")
          (lib.generators.mkLuaInline "{ workspace = \"f[1]\", gaps_out = 0, gaps_in = 0, no_border = true }")
        ];

        bind = let
          bind = bindName: command: {
            _args = [
              bindName
              (lib.generators.mkLuaInline command)
            ];
          };
          bindl = bindName: command: {
            _args = [
              bindName
              (lib.generators.mkLuaInline command)
              (lib.generators.mkLuaInline "{ locked = true }")
            ];
          };
          bindel = bindName: command: {
            _args = [
              bindName
              (lib.generators.mkLuaInline command)
              (lib.generators.mkLuaInline "{ locked = true, [\"repeat\"] = true }")
            ];
          };
        in
          [
            # Audio / Media Binds
            (bindl "XF86AudioPlay" "hl.dsp.exec_raw(\"${lib.getExe pkgs.playerctl} play-pause\")")
            (bindl "XF86AudioPrev" "hl.dsp.exec_raw(\"${lib.getExe pkgs.playerctl} previous\")")
            (bindl "XF86AudioNext" "hl.dsp.exec_raw(\"${lib.getExe pkgs.playerctl} next\")")
            (bindl "XF86AudioMute" "hl.dsp.exec_raw(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            (bindel "XF86AudioRaiseVolume" "hl.dsp.exec_raw(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+\")")
            (bindel "XF86AudioLowerVolume" "hl.dsp.exec_raw(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-\")")

            # General Binds
            (bind "SUPER + code:36" "hl.dsp.exec_raw(\"${lib.getExe pkgs.wezterm}\")")
            (bind "SUPER + E" "hl.dsp.exec_raw(\"${lib.getExe pkgs.nautilus}\")")
            (bind "SUPER + D" "hl.dsp.exec_raw(\"${lib.getExe pkgs.fuzzel}\")")
            #(bind "SUPER + SPACE" "hl.dsp.window.toggle_floating()")
            #(bind "SUPER + J" "hl.dsp.window.toggle_split()")
            (bind "SUPER + F" "hl.dsp.window.fullscreen(0)")
            (bind "F11" "hl.dsp.window.fullscreen(0)")
            (bind "SUPER + L" "hl.dsp.exec_raw(\"${lib.getExe pkgs.hyprlock}\")")
            (bind "SUPER + Q" "hl.dsp.window.close()")
            (bind "SUPER + K" "hl.dsp.exit()")
            (bind "SUPER + G" "hl.dsp.group.toggle()")

            # Screenshot & Notification
            (bind "SUPER + SHIFT + S" "hl.dsp.exec_cmd(\"${lib.getExe pkgs.grim} -g \" .. '\"' .. \"$(${lib.getExe pkgs.slurp})\" .. '\"' .. \" - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}\")")
            (bind "Print" "hl.dsp.exec_cmd(\"${lib.getExe pkgs.grim} -t jpeg - | ${lib.getExe pkgs.imv} -f -\")")
            (bind "SUPER + N" "hl.dsp.exec_raw(\"${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} -t\")")

            # Moving Focus
            (bind "SUPER + LEFT" "hl.dsp.focus({ direction = \"l\" })")
            (bind "SUPER + RIGHT" "hl.dsp.focus({ direction = \"r\" })")
            (bind "SUPER + UP" "hl.dsp.focus({ direction = \"u\" })")
            (bind "SUPER + DOWN" "hl.dsp.focus({ direction = \"d\" })")

            # Moving Windows (Or to group)
            #(bind "SUPER + SHIFT + LEFT" "hl.dsp.window.move_or_group({ direction = \"l\" })")
            #(bind "SUPER + SHIFT + RIGHT" "hl.dsp.window.move_or_group({ direction = \"r\" })")
            #(bind "SUPER + SHIFT + UP" "hl.dsp.window.move_or_group({ direction = \"u\" })")
            #(bind "SUPER + SHIFT + DOWN" "hl.dsp.window.move_or_group({ direction = \"d\" })")

            # Workspace / Group scrolling
            (bind "SUPER + mouse_down" "hl.dsp.focus({ workspace = \"r-1\"})")
            (bind "SUPER + mouse_up" "hl.dsp.focus({ workspace = \"r+1\"})")
            (bind "SUPER + Tab" "hl.dsp.group.next()")
            (bind "SUPER + SHIFT + Tab" "hl.dsp.group.prev()")

            {
              _args = [
                "SUPER + mouse:272"
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                (lib.generators.mkLuaInline "{mouse = true}")
              ];
            }
            {
              _args = [
                "SUPER + mouse:273"
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                (lib.generators.mkLuaInline "{mouse = true}")
              ];
            }
          ]
          ++ lib.optionals (config.host == "uriel") [
            (bind "SUPER + CONTROL + LEFT" "hl.dsp.focus({ workspace = \"e-1\"})")
            (bind "SUPER + CONTROL + RIGHT" "hl.dsp.focus({ workspace = \"e+1\"})")
            #(bind "SUPER + ALT + RIGHT" "hl.dsp.workspace.move_to_monitor(\"HDMI-A-1\")")
            #(bind "SUPER + ALT + LEFT" "hl.dsp.workspace.move_to_monitor(\"DP-1\")")
          ];
      }
      // lib.optionalAttrs (config.host == "uriel") {
        monitor = [
          (lib.generators.mkLuaInline "{ output = \"DP-1\", mode = \"1920x1080@60\", position = \"0x0\", scale = 1}")
          (lib.generators.mkLuaInline "{ output = \"HDMI-A-1\", mode = \"1920x1080@60\", position = \"1920x-420\", scale = 1, transform = 1}")
        ];
      };
    extraConfig = "
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
            hl.bind(\"SUPER + \" .. key,             hl.dsp.focus({ workspace = i}))
            hl.bind(\"SUPER + SHIFT + \" .. key,     hl.dsp.window.move({ workspace = i }))
        end
      ";
  };
}