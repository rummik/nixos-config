{ stdenv, fetchurl, atomEnv, libXScrnSaver, dpkg, gtk2, makeWrapper,

  makeLibraryPath ? stdenv.lib.makeLibraryPath,
  replaceStrings ? stdenv.lib.replaceStrings,
  substring ? stdenv.lib.substring,
}:

let
  clean = version: replaceStrings [ "_" ] [ "." ] (substring 0 9 version); 
in
  stdenv.mkDerivation rec {
    name = "upwork-${clean version}";
    version = "5_1_0_562_f3wgs5ljinabm69t";

    src = fetchurl {
      url = "https://updates-desktopapp.upwork.com/binaries/v${version}/upwork_${clean version}_amd64.deb";
      sha256 = "1h38vw2w6li4sd6b91z42a6pa4svyz5024jrmg9i0nfds7ixlw5g";
    };

    buildInputs = [ dpkg makeWrapper ];

    unpackPhase = /* sh */ ''
      dpkg -x $src .
    '';

    installPhase = /* sh */ ''
      mkdir -p $out/bin
      cp -ar ./usr/share $out
      makeWrapper $out/share/upwork/upwork $out/bin/upwork
    '';

    postFixup = /* sh */ ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${makeLibraryPath [ gtk2 libXScrnSaver ]}:$out/share/upwork" \
        $out/share/upwork/upwork
    '';

    meta = with stdenv.lib; {
      description = "Desktop time tracking and chat client for Upwork freelancers.";
      homepage = https://www.upwork.com/downloads;
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  }
