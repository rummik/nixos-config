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
    inherit (super) stdenv lib writeTextFile fetchFromGitHub fetchFromGitLab
      nix-zsh-completions;
  };

  revolver = mkPackage {} (
    { stdenv, fetchFromGitHub, writeScript, zsh }:

    stdenv.mkDerivation rec {
      name = "revolver";
      version = "0.2.3";

      src = fetchFromGitHub {
        owner = "molovo";
        repo = "revolver";
        rev = "v${version}";
        sha256 = "122zb5vpsaqc2s8dm4i79y7vdayn8prpv9jfyypzp7v38hq2h9h0";
      };

      dontStrip = true;
      dontPatchELF = true;
      dontBuild = true;

      buildInputs = [ zsh ];

      installPhase = /* sh */ ''
        mkdir -p $out/{bin,share/zsh/site-functions}
        chmod a+x revolver
        cp revolver $out/bin
        cp revolver.zsh-completion $out/share/zsh/site-functions/_revolver
      '';
    }
  );

  zunit = mkPackage { inherit revolver; } (
    { stdenv, fetchFromGitHub, writeScript, zsh, revolver }:

    stdenv.mkDerivation rec {
      name = "zunit";
      version = "0.8.2";

      src = fetchFromGitHub {
        owner = "zunit-zsh";
        repo = "zunit";
        rev = "v${version}";
        sha256 = "0dxa0fmjgqrf5awx7mh9s09pqdmw0nzfpnhbhs0apjx1i7k1nm96";
      };

      dontStrip = true;
      dontPatchELF = true;

      buildInputs = [ zsh revolver ];

      buildPhase = /* sh */ ''
        [[ -f build.zsh ]] && zsh build.zsh
      '';

      installPhase = /* sh */ ''
        mkdir -p $out/{bin,share/zsh/site-functions}
        chmod a+x zunit
        cp zunit $out/bin
        cp zunit.zsh-completion $out/share/zsh/site-functions/_zunit
      '';
    }
  );

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
