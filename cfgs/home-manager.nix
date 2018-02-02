{ ... }:

{
  imports = [
    (import (builtins.fetchTarball https://github.com/rycee/home-manager/archive/nixos-module.tar.gz) {}).nixos
  ];

  home-manager.users.rummik = { ... }: {
    imports = [
      ./home-manager/git.nix
    ];
  };

  home-manager.users.root = { ... }: {
    imports = [
      ./home-manager/git.nix
    ];
  };
}
