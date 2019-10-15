self: super:

let

  inherit (super) callPackage callPackage_i686;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux rec {
  cmdpcprox = callPackage_i686 ./cmdpcprox {};
  ferdi = callPackage ./ferdi {};
  github-desktop = callPackage ./github-desktop {};
  minipro = callPackage ./minipro {};
  station = callPackage ./station {};
}
