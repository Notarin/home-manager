{self, ...}: {
  enable = true;
  extraConfig = builtins.readFile (self + /resources/wezterm.lua);
}
