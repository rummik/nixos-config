{ lib, ... }:

let
  inherit (lib) optionals;
  inherit (lib.systems.elaborate { system = __currentSystem; }) isLinux;
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
