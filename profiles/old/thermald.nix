{ pkgs, ... }: let
  nur-no-pkgs = import ../nix/nur.nix;
in {
  imports = [
    nur-no-pkgs.repos.rummik.modules.dptfxtract
  ];

  services.dptfxtract = {
    enable = true;
    configIndex = 3;
  };
}
