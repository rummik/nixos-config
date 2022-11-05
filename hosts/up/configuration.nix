{ config, pkgs, ... }:

{
  imports = [
    #../../config/networkmanager.nix
    #../../profiles/common.nix
    ../../profiles/server.nix
    ../../config/binfmt.nix
  ];

  environment.variables.themePrimaryColor = "white";
}

