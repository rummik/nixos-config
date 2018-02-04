{ config, pkgs, ... }:

{
  boot.cleanTmpDir = true;

  networking.firewall.enable = false;
  networking.firewall.allowPing = true;

  programs.tmux.shortcut = "s";

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
