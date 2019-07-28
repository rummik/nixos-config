self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux {
  minipro = callPackage ./minipro {};

  synergy2 = callPackage ./synergy2 {
    inherit (super) openssl_1_1_0;
  };

  upwork = callPackage ./upwork {};
}
