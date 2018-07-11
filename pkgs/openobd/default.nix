{ stdenv, lib, wxGTK29, glibc, xorg, sqlite, makeWrapper, fetchurl }:

stdenv.mkDerivation rec {
  name = "openobd-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/openobd/Binaries/${version}/openobd-${version}.deb";
    sha256 = "981d7b08c531f8380d6dde6472ea8d988e11e993062d4d4574ccbfa98fedcf86";
  };

  sourceRoot = ".";

  unpackCmd = ''
    ar p "$src" data.tar.gz | tar xz
  '';

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out
    cp -R usr/share usr/bin $out/
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      wxGTK29
      sqlite
      glibc
      xorg.libpthreadstubs
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/openobd
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/openobd/;
    description = "A cross platform GUI for OBD-II interface device control";
    longDescription = ''
      Currently supporting ELM327 devices, the app allows you to view and clear
      error codes, and view live data from the ECU
    '';

    license = licenses.GPLv3;
    platforms = platforms.linux;
    maintainers = [ rummik ];
  };
}
