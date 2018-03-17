{ config, pkgs, ... }:

{
  nixpkgs.config.virtualbox.enableExtensionPack = true;

  virtualisation.virtualbox.host = {
    enable = true;
    addNetworkInterface = true;
  };
}
