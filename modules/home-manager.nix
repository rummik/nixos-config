{ lib, isLinux, isDarwin, __nixPath, ... }:

let
  inherit (lib) optional;
in
  {
    imports =
         optional isDarwin <home-manager/nix-darwin>
      ++ optional isLinux <home-manager/nixos>;

    home-manager.useUserPackages = true;
  }
