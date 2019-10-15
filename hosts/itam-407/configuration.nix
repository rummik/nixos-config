{ config, pkgs, pkgs-unstable, lib, ... }:

{
  imports = [
    ../../config/yubikey.nix
    ../../config/docker.nix
    ../../config/virtualbox.nix
    ../../profiles/games.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "red";

  networking.firewall.enable = false;

  environment.systemPackages =
    (with pkgs; [
      ansible
      discord
      docker-compose
      fly
      kompose
      nixops
      parted
      qt5.qttools
      slack
      terraform
      thunderbird
    ]);

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
