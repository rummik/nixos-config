{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ htop ];

  environment.shellAliases.top = "htop";
}
