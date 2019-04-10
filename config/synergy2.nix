{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    synergy2
  ];

  services.synergy2.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    { from = 24800; to = 24810; }
  ];
}
