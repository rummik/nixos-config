{ stdenv, buildGoPackage, fetchgit, libudev, autoPatchelfHook }:

buildGoPackage rec {
  name = "joycon-${version}";
  version = "v0.3";

  goPackagePath = "github.com/rummik/joycon";

  src = fetchgit {
    url = "https://${goPackagePath}.git";
    rev = version;
    sha256 = "015gahbw7zpj71g82z69p168hy29wx5rspai6hhmfdc0sxn5vklb";
  };

  meta = {
    description = "Joy-Con input driver for Linux";
    homepage = https://github.com/riking/joycon;
    platforms = stdenv.lib.platforms.linux;
  };
}
