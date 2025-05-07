{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  package = pkgs.hyprland;
  portalPackage = pkgs.xdg-desktop-portal-hyprland;
  systemd.variables = ["--all"];
  settings = {
    "$mod" = "SUPER";

    bindl = [
      ",XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
      ",XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
      ",XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bind = [
      # General Binds
      "$mod, Q, killactive"
      "$mod, code:36, exec, ${lib.getExe pkgs.wezterm}"
      "$mod, E, exec, ${lib.getExe pkgs.nautilus}"
      "$mod, SPACE, togglefloating,"
      "$mod, D, exec, ${lib.getExe pkgs.fuzzel}"
      "$mod, J, togglesplit,"
      "$mod, F, fullscreen, 0"
      ",F11, fullscreen, 0"
      "$mod, L, exec, ${lib.getExe pkgs.hyprlock}"

      # Moving Focus/Windows
      ## Move focus with mainMod + arrow keys
      "$mod, LEFT, movefocus, l"
      "$mod, RIGHT, movefocus, r"
      "$mod, UP, movefocus, u"
      "$mod, DOWN, movefocus, d"
      ## Move windows with mainMod + Shift + arrow keys
      "$mod_SHIFT, LEFT, movewindoworgroup, l"
      "$mod_SHIFT, RIGHT, movewindoworgroup, r"
      "$mod_SHIFT, UP, movewindoworgroup, u"
      "$mod_SHIFT, DOWN, movewindoworgroup, d"

      # Grouping
      ## Making/Deleting groups
      "$mod, g, togglegroup"
      ## Moving within a group
      "$mod, Tab, changegroupactive, f"
      "$mod_SHIFT, Tab, changegroupactive, b"

      # Switch workspaces with mainMod + Alt + LEFT/RIGHT
      "$mod_CTRL, LEFT, workspace, e-1"
      "$mod_CTRL, RIGHT, workspace, e+1"

      # Switch workspaces with mainMod + [0-9]
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Switch workspaces with mainMod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Move/resize windows with mainMod + LMB/RMB and dragging
      #"$mod, mouse:272, movewindow"
      #"$mod, mouse:273, resizewindow"

      # Move workspaces over monitors
      "$mod_ALT, RIGHT, movecurrentworkspacetomonitor, DP-2"
      "$mod_ALT, LEFT, movecurrentworkspacetomonitor, DP-1"
      "$mod_ALT, UP, movecurrentworkspacetomonitor, HDMI-A-1"

      # Screenshot
      ''$mod_SHIFT, S, exec, ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}''
      ",Print, exec, ${lib.getExe pkgs.grim} -t jpeg - | ${lib.getExe pkgs.imv} -f -"

      # Notification center
      "$mod, N, exec, ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} -t"
    ];

    workspace = [
      "w[t1], gapsin:0, gapsout:0, border:0, rounding:0"
      "w[tg1], gapsin:0, gapsout:0, border:0, rounding:0"
      "f[1], gapsin:0, gapsout:0, border:0, rounding:0"
    ];

    exec-once = [
      "${lib.getExe pkgs.google-chrome}"
      "${lib.getExe pkgs.vesktop}"
    ];

    env = [
      "XCURSOR_SIZE,32"
      "XDG_SESSION_DESKTOP,Hyprland"
    ];

    windowrulev2 = [
      "renderunfocused,title:^(Minecraft)"
      "renderunfocused,class:^(steam_app_3146520)$"
      "noborder, fullscreen:1"
      "noshortcutsinhibit,class:.*virt-manager.*"
      "workspace 10, class:^(vesktop)$"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      mouse_refocus = false;
      touchpad = {
        natural_scroll = false;
        disable_while_typing = true;
        drag_lock = true;
      };
      sensitivity = 0;
    };

    general = {
      gaps_in = 2;
      gaps_out = 6;
      border_size = 2;
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      mfact = 0.7;
    };

    gestures = {
      workspace_swipe = true;
    };

    misc = {
      force_default_wallpaper = 0;
    };

    debug = {
      disable_logs = false;
      enable_stdout_logs = true;
    };
  };
}
