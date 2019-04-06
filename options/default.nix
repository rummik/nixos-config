{ lib, isLinux, ... }:

let
  inherit (lib) optionals;
in
  {
    imports =
      [
        ./home-manager.nix
        ./tmux.nix
        ./zplug.nix
      ]

      ++ optionals isLinux [
        ./loginctl-enable-linger.nix
        ./nvm.nix
        ./synergy2.nix
      ];
  }
