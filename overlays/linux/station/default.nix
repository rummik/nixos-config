{ stdenv, appimage-run, fetchurl, runtimeShell }:

let

  runner = appimage-run.override {
    extraPkgs =
      pkgs: with pkgs;
        [
          atomEnv.packages
          at-spi2-core
          cups
          curl
          dpkg
          openssl
          udev
        ];
  };

in

stdenv.mkDerivation rec {
  pname = "station";
  version = "1.52.2";

  src = fetchurl {
    url = "https://github.com/getstation/desktop-app-releases/releases/download/${version}/Station-${version}-x86_64.AppImage";
    sha256 = "0lhiwvnf94is9klvzrqv2wri53gj8nms9lg2678bs4y58pvjxwid";
  };

  buildInputs = [ appimage-run ];

  dontUnpack = true;

  installPhase = /* sh */ ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/Station.AppImage
    echo "#!${runtimeShell}" > $out/bin/station
    echo "${runner}/bin/appimage-run $out/share/Station.AppImage" >> $out/bin/station
    chmod +x $out/bin/station $out/share/Station.AppImage
  '';

  meta = with stdenv.lib; {
    description = "A single place for all of your web applications.";
    longDescription = ''
      Station is the first smart browser for busy people. A single place for
      all of your web applications.
    '';
    homepage = https://getstation.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ rummik ];
    platforms = [ "x86_64-linux" ];
  };
}
