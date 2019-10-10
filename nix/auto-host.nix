{ lib, ... }:

let

  inherit (builtins) pathExists;
  inherit (lib) flatten;

  hostName = import ./hostname.nix lib;
  optionalPath = file: if (pathExists file) then [ file ] else [ ];

in

{
  networking.hostName = hostName;

  imports = flatten [
    (../. + "/hosts/${hostName}/configuration.nix")
    (optionalPath (../. + "/hosts/${hostName}/hardware-configuration.nix"))
    (optionalPath (../. + "/hosts/${hostName}/private-configuration.nix"))
  ];
}
