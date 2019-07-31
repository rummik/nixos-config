{
  programs.zsh.shellAliases.top = "htop";

  programs.htop = {
    enable = true;

    meters = {
      left = [ "AllCPUs2" "Memory" "Battery" ];
      right = [ "Hostname" "Tasks" "Uptime" "LoadAverage" ];
    };
  };
}
