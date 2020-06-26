{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/common.nix
    #../../profiles/games.nix
    ../../profiles/server.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "white";
}

