{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool,
pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "bitlbee-mastodon-${version}";
  version = "git";

  src = fetchFromGitHub {
    rev = "0dbae61";
    owner = "kensanata";
    repo = "bitlbee-mastodon";
    sha256 = "1awfr2lymbp1ax0irqx8xc6yfyn312x1xc01ign4wjv0hswwrwwx";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ bitlbee glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Mastodon protocol plugin for bitlbee";

    homepage = https://github.com/kensanata/bitlbee-mastodon;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
