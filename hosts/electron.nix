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

  programs.tmux.theme.secondaryColor = "cyan";

  environment.systemPackages = with pkgs; [
    parted
    pv
    debootstrap
  ];
}
