{ ... }:

let
  ref = "dadfaed82913692b26ad8816ad6a6ce993c66100";
in
  {
    imports = [
      (import (builtins.fetchTarball {
        url = "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
        sha256 = "14ki7yw00l5vhm3ic91xghyxsbgp123bmmxyxkz1pa0pcvppw4dv";
      }) {}).nixos
    ];
  }
