self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

  ft = import <ft>;
  callPackage = package: super.callPackage package { inherit ft; };

in

optionalAttrs isLinux {
  synergy2 = callPackage ./synergy2;
  upwork = callPackage ./upwork;
}
