{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool,
pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "bitlbee-discord-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    rev = "ba47eed85a9e0a4c4673a48217df34b05513a812";
    owner = "sm00th";
    repo = "bitlbee-discord";
    sha256 = "08dfws8vbjar5f29jh1pyca1jjdxacfqdl67cl0wdaavzw5zppjl";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ bitlbee glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Discord protocol plugin for bitlbee";

    homepage = https://github.com/sm00th/bitlbee-discord;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
