{ ... }:

{
  imports = [
    (import (builtins.fetchTarball https://github.com/rycee/home-manager/archive/nixos-module.tar.gz) {}).nixos
  ];
}
