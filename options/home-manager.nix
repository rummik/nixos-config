{ ... }:

let
  ref = "1bc59f729047886b845ffd9162d40593fad5c7f0";
in
  {
    imports = [
      (import (builtins.fetchTarball "https://github.com/rycee/home-manager/archive/${ref}.tar.gz") {}).nixos
    ];
  }
