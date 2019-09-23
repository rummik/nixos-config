self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage python3 gnome3 wineWowPackages;
  inherit (super.lib) optionalAttrs;
  inherit (super.stdenv) isLinux;

in

optionalAttrs isLinux rec {
  firmwareLinuxNonfree = callPackage <nixpkgs-unstable/pkgs/os-specific/linux/firmware/firmware-linux-nonfree> {};

  libstrangle = callPackage <nixpkgs-unstable/pkgs/tools/X11/libstrangle> {
    stdenv = super.stdenv_32bit;
  };

  dumb = callPackage <nixpkgs-unstable/pkgs/misc/dumb> { };
  sndio = callPackage <nixpkgs-unstable/pkgs/misc/sndio> { };

  lutris = callPackage <nixpkgs-unstable/pkgs/applications/misc/lutris/chrootenv.nix> { };

  lutris-unwrapped = python3.pkgs.callPackage <nixpkgs-unstable/pkgs/applications/misc/lutris>  {
    inherit (gnome3) gnome-desktop libgnome-keyring webkitgtk;
    wine = wineWowPackages.staging;
    gdk-pixbuf = callPackage <nixpkgs-unstable/pkgs/development/libraries/gdk-pixbuf> { };
  };

  mailspring = callPackage ./mailspring {};
  minipro = callPackage ./minipro {};
}
