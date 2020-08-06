{ config, pkgs, nur, lib, ... }:

{
  imports = [
    ../../config/anbox.nix
    ../../config/immersed-vr.nix
    ../../config/kdenlive.nix
    ../../config/libvirtd.nix
    ../../config/networkmanager.nix
    ../../config/pia.nix
    ../../config/renoise.nix
    #../../config/rtl-sdr.nix
    ../../config/sc-controller.nix
    ../../config/ssh.nix
    ../../config/virtualbox.nix
    #../../config/wireshark.nix
    #../../profiles/games.nix
    #../../profiles/haskell.nix
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
    22
    3000
    4000
    5000
    9001
    1337
    1883
    8123
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
