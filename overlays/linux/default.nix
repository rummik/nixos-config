self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux {
  minipro = callPackage ./minipro {};
  upwork = callPackage ./upwork {};
}
