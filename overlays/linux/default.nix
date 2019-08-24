self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux rec {
  firmwareLinuxNonfree = callPackage <nixpkgs-unstable/pkgs/os-specific/linux/firmware/firmware-linux-nonfree> {};
  minipro = callPackage ./minipro {};
  upwork = callPackage ./upwork {};
}
