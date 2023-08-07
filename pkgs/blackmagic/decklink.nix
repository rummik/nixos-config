{
  stdenv,
  lib,
  requireFile,
  kernel
}:

stdenv.mkDerivation rec {
  pname = "decklink";
  major = "12.5";
  version = "${major}a15";
  name = "${pname}-${version}-${kernel.version}";

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${major}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/8dbc1e1a31924df7ad46cfa4a8e08ce1/Linux";
    sha256 = "1l9xlg1179iy8cvkbwy9vi6nlc1hyssfdk8yl3xfw3gx7q98irpn";
  };

  dontConfigure = true;
  dontFixup = true;

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs =  kernel.moduleBuildDependencies;

  sourceRoot = "desktopvideo-${version}-x86_64/usr/src";

  unpackPhase = ''
    runHook preUnpack
    tar xf $src -O Blackmagic_Desktop_Video_Linux_${major}/other/x86_64/desktopvideo-${version}-x86_64.tar.gz | tar xz
    runHook postUnpack
  '';

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installTargets = [ "modules_install" ];

  installFlags = kernel.installFlags ++ [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=/build/${sourceRoot}"
  ];

  buildPhase = ''
    runHook preBuild

    make -C blackmagic-${version} $makeFlags $buildFlags
    make -C blackmagic-io-${version} $makeFlags $buildFlags

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make $installFlags M=$PWD/blackmagic-${version} $makeFlags $installTargets
    make $installFlags M=$PWD/blackmagic-io-${version} $makeFlags $installTargets

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    license = licenses.unfree;
    description = "Kernel module for the Blackmagic Design Decklink cards";
    platforms = platforms.linux;
    broken = !stdenv.isx86_64 || (versionAtLeast kernel.version "6.2");
  };
}
