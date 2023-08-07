{
  stdenv,
  lib,
  requireFile,
  autoPatchelfHook,
  wrapQtAppsHook,
  alsa-lib,
  blackmagic-desktop-video,
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-media-express";
  major = "12.5";
  version = "3.8.1a4";

  buildInputs = blackmagic-desktop-video.buildInputs ++ [
    blackmagic-desktop-video
    alsa-lib
  ];

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${major}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/8dbc1e1a31924df7ad46cfa4a8e08ce1/Linux";
    sha256 = "1l9xlg1179iy8cvkbwy9vi6nlc1hyssfdk8yl3xfw3gx7q98irpn";
  };

  sourceRoot = "mediaexpress-${version}-x86_64";

  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;

  unpackPhase = ''
    runHook preUnpack
    tar xf $src -O Blackmagic_Desktop_Video_Linux_${major}/other/x86_64/mediaexpress-${version}-x86_64.tar.gz | tar xz
    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib/blackmagic/MediaExpress}

    cp -v usr/lib/blackmagic/MediaExpress/MediaExpress $out/lib/blackmagic/MediaExpress/
    cp -v usr/lib/blackmagic/MediaExpress/libMXF.so $out/lib/blackmagic/MediaExpress/
    cp -v usr/lib/blackmagic/MediaExpress/libQtSingleApplication.so $out/lib/blackmagic/MediaExpress/

    cp -rv usr/share/* $out/share

    ln -sr $out/lib/blackmagic/MediaExpress/MediaExpress $out/bin

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf --add-needed libDeckLinkAPI.so $out/bin/MediaExpress
    patchelf --add-needed libDeckLinkPreviewAPI.so $out/bin/MediaExpress

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work.";
    platforms = platforms.linux;
    broken = !stdenv.isx86_64;
  };
}
