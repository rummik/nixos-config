{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/networkmanager.nix
    ../cfgs/sc-controller.nix
    ../cfgs/virtualbox.nix
    ../cfgs/wireshark.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/haskell.nix
    ../presets/thinkpad.nix
    ../presets/workstation.nix
  ];

  networking.hostName = "electron";

  programs.tmux.theme.secondaryColor = "cyan";

  networking.firewall.allowedTCPPorts = [
    3000
    4000
    5000
    9001
    1337
  ];

  environment.systemPackages = with pkgs; [
    parted
  ];
}
