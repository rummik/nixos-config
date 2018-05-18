{ stdenv, sg3_utils, autoconf, automake, libtool, pkgconfig, glib }:

stdenv.mkDerivation rec {
  version = "0.95";
  name = "ddpt-${version}";

  src = builtins.fetchTarball {
    url = "http://sg.danny.cz/sg/p/ddpt-${version}.tgz";
    sha256 = "00knwxdhqc9i8b272xx7w272vrld4i75a9w7dli23xdpvz0p9vrz";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ sg3_utils glib ];

  meta = {
    description = "ddpt utility (a Unix dd command variant)";

    homepage = http://sg.danny.cz/sg/ddpt.html;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
