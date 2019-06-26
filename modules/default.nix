{ lib, ... }:

let

  inherit (lib) optionals flatten;
  inherit (builtins) attrNames readDir currentSystem;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  readPath = path:
    map
      (name: path + "/${name}")
      (attrNames (readDir path));

in

{
  imports = flatten [
    ./home-manager.nix
    ./tmux.nix
    ./zplug.nix

    (optionals isLinux (readPath ./os-specific/linux))
  ];
}
