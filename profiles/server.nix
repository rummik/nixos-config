{ config, pkgs, ... }:

{
  imports = [
    ../config/ssh.nix
  ];

  boot.cleanTmpDir = true;

  networking.firewall.allowPing = true;

  programs.tmux.shortcut = "s";

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
