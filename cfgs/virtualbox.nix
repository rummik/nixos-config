{ config, pkgs, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    addNetworkInterface = true;
  };
}
