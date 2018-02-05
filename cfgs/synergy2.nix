{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (callPackage ../pkgs/synergy2/default.nix {})
  ];

  services.synergy2.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    { from = 24800; to = 24810; }
  ];
}
