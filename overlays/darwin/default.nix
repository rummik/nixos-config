self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isDarwin;

  ft = import <ft>;
  callPackage = package: super.callPackage package { inherit ft; };

in

optionalAttrs isDarwin {
  folderify = callPackage ./folderify;
  tpkb = callPackage ./tpkb;
}
