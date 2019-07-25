self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isDarwin;

in

optionalAttrs isDarwin {
  folderify = callPackage ./folderify {};
  tpkb = callPackage ./tpkb {};
}
