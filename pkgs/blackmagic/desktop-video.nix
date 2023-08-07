{
  stdenv,
  lib,
  requireFile,
  autoPatchelfHook,
  libcxx,
  libcxxabi,
  libGL,
  glib,
  libusb,
  xorg,
  dbus,
  freetype,
  fontconfig,
  qtbase,
  wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  major = "12.5";
  version = "${major}a15";

  buildInputs = [
    libcxx
    libcxxabi
    libGL
    glib
    xorg.libICE
    xorg.libSM
    xorg.libXrender
    dbus
    libusb
    freetype
    fontconfig
    qtbase
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

    mkdir -p $out/{bin,share/doc,lib/blackmagic/DesktopVideo}

    # Copy API libraries
    cp -rv usr/lib/*.so $out/lib

    # Copy utils and firmware
    cp -rv usr/lib/blackmagic/DesktopVideo/Firmware $out/lib/blackmagic/DesktopVideo
    cp -v usr/lib/blackmagic/DesktopVideo/*DesktopVideo* $out/lib/blackmagic/DesktopVideo
    cp -v usr/lib/blackmagic/DesktopVideo/libDVUpdate.so $out/lib/blackmagic/DesktopVideo

    # Copy docs and systemd service
    cp -rv usr/share/doc/desktopvideo $out/share/doc
    cp -rv usr/lib/systemd $out/lib

    # Symlink utils to bin
    ln -sr $out/lib/blackmagic/DesktopVideo/*DesktopVideo* $out/bin

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf --add-needed libDeckLinkAPI.so $out/bin/*
    patchelf --add-needed libDeckLinkPreviewAPI.so $out/bin/BlackmagicDesktopVideoSetup

    substituteInPlace \
      $out/lib/systemd/system/DesktopVideoHelper.service \
      --replace "/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper" "$out/bin/DesktopVideoHelper"

    runHook postFixup
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
