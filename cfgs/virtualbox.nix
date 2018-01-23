{ config, pkgs, ... }:

{
  virtualisation.virtualbox.host.enable = true;

  environment.systemPackages = with pkgs; [
    virtualbox
  ];
}
