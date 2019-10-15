{
  stdenv,
  autoPatchelfHook,
  fetchzip,
  libusb,
}:

stdenv.mkDerivation {
  pname = "cmdpcprox";
  version = "1.0.3";

  src = fetchzip {
    url = https://www.rfideas.com/files/downloads/software/CmdpcProx.tar.gz;
    sha256 = "09q0wr2p2929mip8mfip76xba5g079axx1sz9bk71xjs0mkxj07h";
    stripRoot = false;
  };

  #dontPatchELF = true;
  #dontStrip = true;
  #dontBuild = true;
  #dontConfigure = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc
    libusb
  ];

  installPhase = /* sh */ ''
    mkdir -p $out/bin
    cp CmdpcProx $out/bin/cmdpcprox
  '';
}
