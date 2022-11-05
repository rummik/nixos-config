self: super:

let

  inherit (import ../nix/path.nix) __nixPath;

in

{
  nur = import <nur> rec {
    pkgs = super;
    repoOverrides.rummik = import <nur-rummik> { inherit pkgs; };
  };
}
