{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "gogs_client";
    version = "1.0.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4bd585ff86f6d70a245cea3b9b9756205bdaa9f512b314c47f715842970b3d3f";
    };

    doCheck = false;

    propagatedBuildInputs = with python3.pkgs; [ requests attrs future ];

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
      description = "A python library for interacting with a gogs server";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }

