{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    ../../config/yubikey.nix
    ../../config/docker.nix
  ];

  environment.variables.themePrimaryColor = "green";

  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
