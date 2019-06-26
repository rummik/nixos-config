{ lib, ... }:

let

  inherit (lib) optional flatten;
  inherit (import ../channels) __nixPath;
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;

in

{
  imports = flatten [
    (optional isDarwin <home-manager/nix-darwin>)
    (optional isLinux <home-manager/nixos>)
  ];

  home-manager.useUserPackages = true;
}
