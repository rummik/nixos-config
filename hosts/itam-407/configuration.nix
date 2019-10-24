{ config, pkgs, pkgs-unstable, lib, ... }:

{
  imports = [
    ../../config/docker.nix
    ../../config/libvirtd.nix
    ../../config/virtualbox.nix
    ../../config/yubikey.nix
    ../../profiles/games.nix
    ../../profiles/workstation.nix
  ];

  environment.variables = {
    themePrimaryColor = "red";
    themeAccentColor = "blue";
  };

  networking.firewall.enable = false;

  environment.systemPackages =
    (with pkgs; [
      ansible
      ansible-lint
      discord
      docker-compose
      fly
      kargo
      kompose
      kubernetes-helm3
      nixops
      parted
      python3
      qt5.qttools
      slack
      terraform
      terragrunt
      thunderbird
    ]);

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
