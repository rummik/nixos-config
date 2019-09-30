self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage python3 gnome3 wineWowPackages;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux rec {
  firmwareLinuxNonfree = callPackage <nixpkgs-unstable/pkgs/os-specific/linux/firmware/firmware-linux-nonfree> {};


  mailspring = callPackage ./mailspring {};
  minipro = callPackage ./minipro {};
}
