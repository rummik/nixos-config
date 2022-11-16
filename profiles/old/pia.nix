let
  nur-no-pkgs = import ../nix/nur.nix;
in {
  imports = [
    nur-no-pkgs.repos.rummik.modules.pia
  ];

  services.pia.enable = true;
}
