{ config, pkgs, ... }:

{
  networking.hosts = {
    "2001:db8::d00:dad" = [ "tau" ];
  };
}
