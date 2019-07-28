{ stdenv
, fetchFromGitLab

, libusb
, pkgconfig
, which
}:

stdenv.mkDerivation {
  name = "minipro-2018-07-24";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "minipro";
    rev = "f0ee9d86f513d36d3435a49c822fac09bd7b661b";
    sha256 = "08bjmsyh34qpz8sakbp149is5mhl8srhz8h30s9ihhdfvvd3ggpz";
  };

  nativeBuildInputs = [
    pkgconfig
    which
  ];

  buildInputs = [
    libusb
  ];

#  preConfigure = /* sh */ ''
#    substituteInPlace
#    sed \
#      -e "s/^origincdirs = .*/origincdirs = []/" \
#      -e "s/^origlibdirs = .*/origlibdirs = []/" \
#      -e "/\/include\/smpeg/d" \
#      -i config_unix.py
#  '';

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

