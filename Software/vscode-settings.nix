{
  enable = true;
  keybindings = [
    {
      key = "ctrl+r";
      command = "workbench.action.tasks.runTask";
      when = "taskCommandsRegistered";
    }
  ];
  userSettings = {
    "editor.renderWhitespace" = "all";
    "editor.fontLigatures" = true;
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
    "git.openRepositoryInParentFolders" = "never";
    "security.workspace.trust.untrustedFiles" = "open";
    "security.workspace.trust.enabled" = false;
    "workbench.settings.editor" = "ui";
    "workbench.startupEditor" = "none";
    "window.menuBarVisibility" = "toggle";
    "git.autofetch" = true;
    "nix.enableLanguageServer" = true;
  };
}
