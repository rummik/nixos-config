{ lib, ... }:

{
  _module.args.ft =
    (attrs: lib.genAttrs attrs (name: "")) [
      "nix"
      "sh"
      "tmux"
      "vim"
      "xf86conf"
      "zsh"
    ];
}
