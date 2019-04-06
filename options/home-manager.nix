{ lib, isLinux, isDarwin, __nixPath, ... }:

let
  inherit (lib) optional optionalAttrs;
in
  optionalAttrs isDarwin {
    imports = [ <home-manager/nix-darwin> ];
  }

  // optionalAttrs isLinux {
    imports = [ <home-manager/nixos> ];
    #home-manager.useUserPackages = true;
  }
