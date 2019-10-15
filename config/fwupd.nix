{ pkgs, ... }:

{
  services.fwupd.enable = true;
  environment.systemPackages = [ pkgs.fwupd ];
}
