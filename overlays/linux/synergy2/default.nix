{ stdenv, lib, xlibsWrapper , libX11, libXi, libXtst, libXrandr, xinput, curl,
openssl_1_1_0, libGL, qt5, libsodium, avahi, systemd, libXext }:

stdenv.mkDerivation rec {
  name = "synergy-${version}";
  version = "2.0.12";

  src = ./synergy_2.0.12.beta_b74+0b61673b_amd64.deb;

  sourceRoot = ".";
  unpackCmd = "ar p $src data.tar.xz | tar xJ";

  buildPhase = ":";

  installPhase = /* sh */ ''
    mkdir -p $out/bin
    cp -R usr/* $out/

    substituteInPlace \
      $out/share/applications/synergy.desktop \
      --replace /usr/ $out/usr/
  '';

  preFixup =
    let
        libPath = lib.makeLibraryPath [
          stdenv.cc.cc.lib
          curl openssl_1_1_0.out xlibsWrapper libX11 libXi libXtst libXrandr xinput libGL
          qt5.qtbase libsodium avahi qt5.qtdeclarative qt5.qtsvg systemd libXext
        ];
    in /* sh */ ''
      for file in $out/bin/*; do
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${libPath}" \
          $file
      done
    '';

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = https://github.com/symless/synergy-core;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
