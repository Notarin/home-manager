{
  config,
  pkgs,
  wezterm-config,
  starship-config,
  neovim-config,
  nushell-config,
  hyprland-config,
  helix-config,
  zsh-config,
  ssh-config,
  ...
}:

{
  # System specific
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";
  # Do not touch
  home.stateVersion = "24.05";

  # Packages
  home.packages = [
  ];

  # Deployed files/directories
  home.file = {
    ".config/wezterm/".source = wezterm-config;
    ".config/".source = starship-config;
    ".config/".recursive = true;
    ".config/nvim/".source = neovim-config;
    ".config/nushell/".source = nushell-config;
    ".config/nushell/".recursive = true;
    ".config/hypr/".source = hyprland-config;
    ".config/helix/".source = helix-config;
    ".config/zsh/".source = zsh-config;
    ".ssh/".source = ssh-config;
  };

  # ENV variables
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Allow home-manager to update itself
  programs.home-manager.enable = true;
}
