self: super:

let

  inherit (import ../channels) __nixPath;
  inherit (builtins) mapAttrs readDir;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux isDarwin;

  callPackages = path:
    mapAttrs
      (name: value: callPackage (path + "/${name}") { ft = import <ft>; })
      (removeAttrs (readDir path) [ "os-specific" "default.nix" ]);

in

callPackages ./.
// optionalAttrs isLinux (callPackages ./os-specific/linux)
// optionalAttrs isDarwin (callPackages ./os-specific/darwin)
