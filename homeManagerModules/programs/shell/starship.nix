{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      hostname = {
        ssh_symbol = "📡";
      };
      shell = {
        disabled = false;
      };
    };
  };
}
