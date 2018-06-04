{ stdenv, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.30";
  name = "tio-${version}";

  src = builtins.fetchTarball {
    url = "https://github.com/tio/tio/releases/download/v${version}/tio-${version}.tar.xz";
    sha256 = "08w4vp866pk2b86jnskd8f0vx3a1x3794qdymb7wkvy55qyyzjck";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  meta = {
    description = "A simple TTY terminal I/O application";

    homepage = https://tio.github.io;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
