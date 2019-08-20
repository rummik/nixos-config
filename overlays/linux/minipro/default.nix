{ stdenv
, fetchFromGitLab

, libusb
, pkgconfig
, which
}:

stdenv.mkDerivation rec {
  version = "0.3";
  pname = "minipro";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = pname;
    rev = version;
    sha256 = "0bxdylsdahakbq99chsyw5p4wnbgiplnkv1br62mr9h73mkwy3gi";
  };

  nativeBuildInputs = [
    pkgconfig
    which
  ];

  buildInputs = [
    libusb
  ];

  preBuild = /* sh */ ''
    makeFlagsArray+=(
      "PREFIX=$out"
      "UDEV_RULES_INSTDIR=$out/etc/udev/rules.d"
      "COMPLETIONS_DIR=$out/etc/bash_completion.d"
    )
  '';

  meta = with stdenv.lib; {
    /*maintainers = with maintainers; [
      wkennington
    ];*/

    platforms = [
      "x86_64-linux"
    ];
  };
}

