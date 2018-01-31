{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
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
