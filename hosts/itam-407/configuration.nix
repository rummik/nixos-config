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
      discord
      qt5.qttools
      slack
      thunderbird
    ])

    ++
    
    (with pkgs-unstable; [
      kubernetes-helm
      minikube
      #minikube140
    ]);

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
