{ config, pkgs, nur, lib, ... }:

{
  imports = [
    ../../config/docker.nix
    ../../config/networkmanager.nix
    ../../config/sc-controller.nix
    #../../config/virtualbox.nix
    ../../config/wireshark.nix
    ../../profiles/games.nix
    ../../profiles/haskell.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "yellow";


  networking.firewall.allowedTCPPortRanges = [
    { from = 4100; to = 4105; }
    { from = 19000; to = 19100; }
  ];

  networking.firewall.allowedUDPPorts = [
    5353
  ];

  networking.firewall.allowedTCPPorts = [
    3000
    4000
    5000
    9001
    1337
  ];

  environment.systemPackages =
    (with pkgs; [
      parted
    ])

    ++

    (with pkgs.nur.repos.rummik; [
      #activitywatch
    ]);
}
