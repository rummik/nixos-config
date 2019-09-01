self: super:

let

  inherit (import ../channels) __nixPath;

in

{
  nur = import <nur> { pkgs = super; };
}
