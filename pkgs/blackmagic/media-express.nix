{
  stdenv,
  lib,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  blackmagic-desktop-video,
  wrapQtAppsHook
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
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib}

    ls -R

    cp -rv usr/lib/* $out/lib
    cp -rv usr/share/* $out/share

    mv $out/lib/blackmagic/MediaExpress/lib*.so* $out/lib
    ln -sr $out/lib/blackmagic/MediaExpress/MediaExpress $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.hexchen ];
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work.";
    platforms = platforms.linux;
    broken = !stdenv.isx86_64;
  };
}
