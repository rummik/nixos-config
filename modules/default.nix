{ lib, ... }:

let

  inherit (lib) optional flatten;
  inherit (builtins) attrNames readDir currentSystem;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

in

{
  imports = flatten [
    ./home-manager.nix
    (optional isLinux ./os-specific/linux)
  ];
}
