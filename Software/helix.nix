{ pkgs, ... }:

{
  enable = true;
  defaultEditor = true;
  extraPackages = with pkgs; [
    rust-analyzer
  ];
  settings = {
    keys.normal = {
      y = "yank_to_clipboard";
      p = "paste_clipboard_after";
      P = "paste_clipboard_before";
    };
  };
}
