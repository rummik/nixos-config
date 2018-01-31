{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/networkmanager.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/server.nix
  ];

  networking.hostName = "up";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.tmux.theme.secondaryColor = "yellow";

  environment.systemPackages = with pkgs; [
    parted
  ];
}
