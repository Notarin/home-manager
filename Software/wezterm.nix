{rootDir, ...}: {
  enable = true;
  extraConfig = builtins.readFile (rootDir + /resources/wezterm.lua);
}
