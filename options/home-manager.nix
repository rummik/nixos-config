{ ... }:

let
  ref = "50de1a6885dc7c306fa85c3c4538ee8ba54a65f7";
in
  {
    imports = [
      (import (builtins.fetchTarball {
        url = "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
        sha256 = "1jwz5q2hpyaspbfm4hmvaqi3dldr9pxkz1apsnc2b2dbbzp97vyk";
      }) {}).nixos
    ];
  }
