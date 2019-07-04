self: super:

let

  inherit (import ../../channels) __nixPath;

  ft = import <ft>;
  callPackage = package: super.callPackage package { inherit ft; };

in

{
  bitlbee-discord = callPackage ./bitlbee-discord;
  bitlbee-mastodon = callPackage ./bitlbee-mastodon;
  ddpt = callPackage ./ddpt;
  lab = callPackage ./lab;
  nvm = callPackage ./nvm;
  tio = callPackage ./tio;
  zplug = callPackage ./zplug;
}
