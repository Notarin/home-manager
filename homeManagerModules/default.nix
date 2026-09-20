{
  imports = [
    ./programs
    ./services
    ./fonts.nix
    ./home-manager.nix
    ./nixConfig.nix
    ./stylix.nix
  ];

  # Set my clock format for GTK apps to be 12hr
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
    };
  };
}
