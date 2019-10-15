self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage;

in

{
  #activitywatch = callPackage ./activitywatch;

  alacritty = callPackage <nixpkgs-unstable/pkgs/applications/misc/alacritty> {
    inherit (super.xorg) libXcursor libXxf86vm libXi;
    inherit (super.darwin.apple_sdk.frameworks) AppKit CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  ddpt = callPackage ./ddpt {};

  gitAndTools = super.gitAndTools // (import ./git-and-tools) {
    inherit (super) callPackage;
  };

  vimPlugins = super.vimPlugins // (import ./vim-plugins) {
    inherit (super) fetchFromGitHub;
    inherit (super.vimUtils) buildVimPluginFrom2Nix;
  };

  zshPlugins = (import ./zsh-plugins) {
    inherit (super) lib fetchFromGitHub fetchFromGitLab;
  };
}
