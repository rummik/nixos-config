{ config, pkgs, pkgs-unstable, lib, ... }:

{
  imports = [
    ../../config/docker.nix
    ../../config/libvirtd.nix
    ../../config/ssh.nix
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
      discord
      qt5.qttools
      slack
      thunderbird
      zoom-us
    ])

    ++
    
    (with pkgs-unstable; [
      kubernetes-helm
      minikube
      #minikube140
    ]);
}
