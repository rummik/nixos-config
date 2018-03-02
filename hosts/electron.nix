{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/networkmanager.nix
    ../cfgs/virtualbox.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/haskell.nix
    ../presets/thinkpad.nix
    ../presets/work.nix
    ../presets/workstation.nix
  ];

  networking.hostName = "electron";

  programs.tmux.theme.secondaryColor = "cyan";

  environment.systemPackages = with pkgs; [
    parted
  ];
}
