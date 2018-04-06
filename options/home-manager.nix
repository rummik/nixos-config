{ ... }:

let
  ref = "1bc59f729047886b845ffd9162d40593fad5c7f0";
in
  {
    imports = [
      (import (builtins.fetchTarball {
        url = "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
        sha256 = "12hsk3bbpvycwzhh59xj10rynz2gicpilh6m7llknl70r2hykn4w";
      }) {}).nixos
    ];
  }
