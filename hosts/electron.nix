{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/networkmanager.nix
    ../cfgs/virtualbox.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/graphical.nix
    ../presets/thinkpad.nix
  ];

  networking.hostName = "electron";

  services.miredo.enable = true;

  programs.tmux.theme.secondaryColor = "cyan";

  networking.firewall.trustedInterfaces = [
    "enp0s25"
    "wlp2s0"
  ];

  environment.systemPackages = with pkgs; [
    parted
    pv
    debootstrap
  ];
}
