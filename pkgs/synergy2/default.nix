{ stdenv, fetchFromGitHub, fetchpatch, cmake, xlibsWrapper, libX11, libXi, libXtst, libXrandr
, xinput, curl, openssl, unzip }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "synergy-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "v${version}-stable";
    sha256 = "00maxwjx2rykkqk8ij2l5gkv6kwx76cx68yfm3zzclwgxx7pg6s4";
  };

  buildInputs = [
    cmake xlibsWrapper libX11 libXi libXtst libXrandr xinput curl openssl
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export SYNERGY_VERSION_MAJOR=2
    export SYNERGY_VERSION_MINOR=0
    export SYNERGY_VERSION_PATCH=0
    export SYNERGY_VERSION_STAGE=archive
    export GIT_COMMIT=deadbeef
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/synergy-core $out/bin
    cp bin/synergyc $out/bin
    cp bin/synergys $out/bin
  '';

  meta = {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = https://github.com/symless/synergy-core;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
