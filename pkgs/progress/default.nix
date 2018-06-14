{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "progress";
    version = "1.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c88d89ee3bd06716a0b8b5504d9c3bcb3c1c0ab98f96dc7f1dc5f56812a4f60a";
    };

    # invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
      description = "Easy to use progress bars";
      license = licenses.isc;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }
