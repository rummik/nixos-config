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

  kubernetes-helm3 = super.kubernetes-helm.overrideAttrs (helm2: rec {
    version = "3.0.0-beta.4";

    src = fetchFromGitHub {
      owner = "helm";
      repo = "helm";
      rev = "v${version}";
      sha256 = "18ly31db2kxybjlisz8dfz3cdxs7j2wsh4rx5lwhbm5hpp42h17d";
    };

    buildFlagsArray = replaceStrings [ helm2.version ] [ version ] helm2.buildFlagsArray;
  });

  proxmark3 = super.proxmark3.overrideAttrs (pm3: {
    src = super.fetchgit rec {
      url = "${pm3.src.meta.homepage}.git";
      rev = pm3.src.rev;
      deepClone = true;
      sha256 = "1cxbpj7r6zaidifi6njhv8q1anqdj318yp4vbwhajnflavq24krz";
    };

    postPatch = ":";

    buildInputs = pm3.buildInputs ++ (with super.pkgs; [
      git
      perl
      (runCommand "termcap" {} /* sh */ ''
        mkdir -p $out/lib
        ln -s ${ncurses}/lib/libncurses.so $out/lib/libtermcap.so
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib"
      '')
    ]);
  });
}
