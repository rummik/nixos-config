self: super:

let

  inherit (import ../../channels) __nixPath;

  ft = import <ft>;
  callPackage = package: super.callPackage package { inherit ft; };

in

{
  alacritty = super.callPackage <nixpkgs-unstable/pkgs/applications/misc/alacritty> {
    inherit (super.xorg) libXcursor libXxf86vm libXi;
    inherit (super.darwin) cf-private;
    inherit (super.darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  bitlbee-discord = callPackage ./bitlbee-discord;
  bitlbee-mastodon = callPackage ./bitlbee-mastodon;
  ddpt = callPackage ./ddpt;
  lab = callPackage ./lab;
  nvm = callPackage ./nvm;
  tio = callPackage ./tio;
  zplug = callPackage ./zplug;
}
