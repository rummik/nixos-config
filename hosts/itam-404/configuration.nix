{ config, pkgs, pkgs-unstable, lib, ... }:

{
  imports = [
    ../../config/docker.nix
    ../../config/networkmanager.nix
    ../../config/virtualbox.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "red";

  environment.systemPackages =
    (with pkgs-unstable; [
      fly
    ])

    ++

    (with pkgs; [
      ansible
      discord
      docker-compose
      kompose
      nixops
      parted
      qt5.qttools
      slack
      thunderbird
    ]);

  services.openssh.enable = false;
}
