self: super:

let
  inherit (builtins) mapAttrs readDir;
  inherit (super) callPackage;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux isDarwin;

  callPackages = path: ignore:
    mapAttrs
      (name: value: callPackage (path + "/${name}") { ft = import ./ft.nix super.lib; })
      (removeAttrs (readDir path) ignore);
in
  callPackages ./. [ "os-specific" "default.nix" "ft.nix" ]
  // optionalAttrs isLinux (callPackages ./os-specific/linux [])
  // optionalAttrs isDarwin (callPackages ./os-specific/darwin [])
