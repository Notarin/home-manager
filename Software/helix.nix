{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  defaultEditor = true;
  extraPackages = with pkgs; [
    rust-analyzer
  ];
  settings = {
    editor = {
      default-yank-register = "+";
      shell = [
        (lib.getExe pkgs.nushell)
        "-c"
      ];
      line-number = "relative";
      cursorline = true;
      rulers = [
        80
        100
      ];
      bufferline = "multiple";
      color-modes = true;
      popup-border = "all";
      end-of-line-diagnostics = "hint";
      statusline = {
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
        left = [
          "mode"
          "spinner"
          "file-name"
          "read-only-indicator"
          "file-modification-indicator"
        ];
        center = [];
        right = [
          "diagnostics"
          "version-control"
          "selections"
          "register"
          "position"
          "position-percentage"
          "total-line-numbers"
          "file-encoding"
        ];
      };
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      whitespace = {
        render = {
          space = "none";
          nbsp = "all";
          nnbsp = "all";
          tab = "all";
          newline = "none";
        };
      };
    };
    keys.normal = rec {
      y = "yank";
      p = "paste_after";
      P = "paste_clipboard_before";
      w = ":write";
      q = ":quit";
      r = ":config-reload";
      b = ":buffer-next";
      C-right = "move_next_word_start";
      C-left = "move_prev_word_start";
      t = "command_mode";
      ";" = t;
      ":" = "no_op";
    };
  };
  languages = {
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.alejandra;
        };
      }
      {
        name = "nu";
        auto-format = false;
        formatter = {
          command = lib.getExe pkgs.nufmt;
          args = ["--stdin"];
        };
      }
    ];
  };
}
