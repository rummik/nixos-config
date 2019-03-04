{ ... }:

let
  ref = "465d08d99f5b72b38cecb7ca1865b7255de3ee86";
in
  {
    imports = [
      (import (builtins.fetchTarball {
        url = "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
        sha256 = "1dkvz0sx8kjvk1lap50d5vfgm2wprh1cmhcrx3bn28r3skpj4rbj";
      }) {}).nixos
    ];
  }
