{
  pkgs,
  lib,
  self,
  system,
  ...
}: {
  enable = true;
  mutableExtensionsDir = false;
  profiles.default = {
    keybindings = [
      {
        key = "ctrl+r";
        command = "workbench.action.tasks.runTask";
        when = "taskCommandsRegistered";
      }
      {
        key = "alt+enter";
        command = "editor.action.quickFix";
        when = "editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
      }
      {
        key = "ctrl+c";
        command = "runCommands";
        when = "terminalFocus && terminalTextSelected";
        args = {
          commands = [
            "workbench.action.terminal.copySelection"
            "workbench.action.terminal.clearSelection"
          ];
        };
      }
      {
        key = "ctrl+v";
        command = "workbench.action.terminal.paste";
        when = "terminalFocus";
      }
    ];
    userSettings = {
      "editor.renderWhitespace" = "all";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.rulers" = [
        {
          "column" = 79;
          "color" = "#0f02";
        }
        {
          "column" = 80;
          "color" = "#f002";
        }
      ];
      "workbench.editor.enablePreviewFromCodeNavigation" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.wrapTabs" = true;
      "workbench.settings.editor" = "ui";
      "workbench.startupEditor" = "none";
      "git.openRepositoryInParentFolders" = "never";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "security.workspace.trust.enabled" = false;
      "window.menuBarVisibility" = "toggle";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${lib.getExe pkgs.nil}";
      "nix.serverSettings" = {
        nil = {
          formatting = {
            command = ["${lib.getExe self.formatter.${system}}" "--quiet" "--stdin" "\${file}"];
          };
        };
      };
      "files.autoSave" = "onFocusChange";
      "rust-analyzer.diagnostics.styleLints.enable" = true;
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.checkOnSave" = true;
      "rust-analyzer.server.extraEnv" = {
        "PATH" = lib.makeBinPath (
          with pkgs; [
            gcc
            cargo
            rustc
            rustfmt
          ]
        );
      };
      "github.copilot.nextEditSuggestions.enabled" = true;
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = true;
        "markdown" = true;
        "rust" = false;
      };
      "terminal.integrated.commandsToSkipShell" = [
        "workbench.action.terminal.copySelection"
        "workbench.action.terminal.paste"
      ];
    };
    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          label = "Rebuild & Deploy home with nh";
          type = "shell";
          command = "nh home switch .";
          presentation = {
            reveal = "always";
            revealProblems = "onProblem";
            panel = "dedicated";
            focus = true;
            echo = false;
            showReuseMessage = false;
            clear = true;
            close = true;
            group = "nix build&switch";
          };
          options.shell = {
            executable = "${lib.getExe pkgs.nushell}";
            args = ["-c"];
          };
          problemMatcher = [];
        }
        {
          label = "Rebuild & Deploy NixOS with nh";
          type = "shell";
          command = "nh os switch .";
          presentation = {
            reveal = "always";
            revealProblems = "onProblem";
            panel = "dedicated";
            focus = true;
            echo = false;
            showReuseMessage = false;
            clear = true;
            close = true;
            group = "nix build&switch";
          };
          options.shell = {
            executable = "${lib.getExe pkgs.nushell}";
            args = ["-c"];
          };
          problemMatcher = [];
        }
      ];
    };
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-marketplace;
    with pkgs.vscode-extensions; [
      mkhl.direnv
      github.copilot
      github.copilot-chat
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      fill-labs.dependi
      thenuprojectcontributors.vscode-nushell-lang
      sumneko.lua
      justarandomgeek.factoriomod-debug
      svizzini.factorio-lua-api-autocomplete
    ];
    enableExtensionUpdateCheck = false;
  };
}
