{ lib, isLinux, isDarwin, ... }:

let
  inherit (lib) optionals;
  inherit (builtins) attrNames readDir;

  readPath = path: ignore:
    map
      (name: path + "/${name}")
      (attrNames (removeAttrs (readDir path) ignore));
in
  {
    imports =
      readPath ./. [ "os-specific" "default.nix" ]
      ++ optionals isLinux (readPath ./os-specific/linux []);
  }
