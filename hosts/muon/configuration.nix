{ config, pkgs, lib, ... }:

{
  imports = [
    ../../profiles/server.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "yellow";
}
