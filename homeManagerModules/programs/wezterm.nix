{self, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile (self + /resources/wezterm.lua);
  };
}
