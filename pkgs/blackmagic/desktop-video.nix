{
  stdenv,
  lib,
  requireFile,
  autoPatchelfHook,
  wrapQtAppsHook,
  dbus,
  fontconfig,
  freetype,
  glib,
  libGL,
  libcxx,
  libcxxabi,
  libusb,
  qtbase,
  xorg
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  major = "12.5";
  version = "${major}a15";

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libGL
    libcxx
    libcxxabi
    libusb
    qtbase
    xorg.libICE
    xorg.libSM
    xorg.libXrender
  ];

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${major}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/8dbc1e1a31924df7ad46cfa4a8e08ce1/Linux";
    sha256 = "1l9xlg1179iy8cvkbwy9vi6nlc1hyssfdk8yl3xfw3gx7q98irpn";
  };

  sourceRoot = "desktopvideo-${version}-x86_64";

  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;

  unpackPhase = ''
    runHook preUnpack
    tar xf $src -O Blackmagic_Desktop_Video_Linux_${major}/other/x86_64/desktopvideo-${version}-x86_64.tar.gz | tar xz
    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,etc,share/doc,lib/blackmagic/DesktopVideo}

    cp -rv usr/lib/*.so $out/lib

    cp -rv usr/lib/blackmagic/DesktopVideo/Firmware $out/lib/blackmagic/DesktopVideo
    cp -v usr/lib/blackmagic/DesktopVideo/*DesktopVideo* $out/lib/blackmagic/DesktopVideo
    cp -v usr/lib/blackmagic/DesktopVideo/libDVUpdate.so $out/lib/blackmagic/DesktopVideo

    cp -rv usr/share/* $out/share

    cp -rv usr/lib/systemd $out/lib
    cp -rv etc/udev $out/etc
    cp -rv etc/xdg $out/etc

    ln -sr $out/lib/blackmagic/DesktopVideo/*DesktopVideo* $out/bin

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf --add-needed libDeckLinkAPI.so $out/bin/*
    patchelf --add-needed libDeckLinkPreviewAPI.so $out/bin/BlackmagicDesktopVideoSetup

    substituteInPlace \
      $out/etc/udev/rules.d/55-blackmagic.rules \
      $out/lib/systemd/system/DesktopVideoHelper.service \
      --replace "/usr/lib/blackmagic/DesktopVideo/" "$out/bin/"

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
