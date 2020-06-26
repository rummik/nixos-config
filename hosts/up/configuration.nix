{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/server.nix
  ];

  environment.variables.themePrimaryColor = "white";
}

