self: super:

let

  inherit (import ../../channels) __nixPath;
  inherit (super) callPackage fetchFromGitHub;
  inherit (super.lib) replaceStrings;

  mkPackage = pkg: callPackage pkg {};

in

rec {
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

  proxmark3-flasher = proxmark3.overrideAttrs (pm3: rec {
    pname = "proxmark3-flasher";
    installPhase = /* sh */ ''
      mkdir -p $out/bin
      cp flasher $out/bin/proxmark3-flasher
    '';
  });

  proxmark3-firmware = proxmark3.overrideAttrs (pm3: rec {
    pname = "proxmark3-firmware";

    buildInputs = pm3.buildInputs ++ (with super.pkgs; [
      gcc-arm-embedded
      libusb
      pcsclite
      perl
      qt4
    ]);

    dontFixup = true;

    preBuild = ":";

    buildPhase = /* sh */ ''
    git status
    perl tools/mkversion.pl
    exit 1
      make armsrc/obj/fullimage.elf bootrom/obj/bootrom.elf
    '';

    installPhase = /* sh */ ''
      mkdir -p $out/share/proxmark3/firmware

      cp bootrom/obj/bootrom.elf $out/share/proxmark3/firmware
      cp armsrc/obj/fullimage.elf $out/share/proxmark3/firmware
    '';
  });
}
