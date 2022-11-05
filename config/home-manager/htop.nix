{
  programs.zsh.shellAliases.top = "htop";

  programs.htop = {
    enable = true;

    settings = {
      left_meters = [ "AllCPUs2" "Memory" "Battery" ];
      right_meters = [ "Hostname" "Tasks" "Uptime" "LoadAverage" ];
    };
  };
}
