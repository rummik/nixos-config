{ config, ... }:
{
  virtualisation.docker.enable = true;

  networking.networkmanager.unmanaged = [
    "interface-name:veth*"
  ];
}
